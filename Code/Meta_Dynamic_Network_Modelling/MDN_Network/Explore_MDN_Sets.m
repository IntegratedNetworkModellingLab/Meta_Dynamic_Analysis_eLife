%% Executive script to generate functional parameter or state IC sets.
clear;clc;close all;
pat = "MATLAB\Modelling_Suite";
str = string(pwd);

if(~contains(str,pat))
    error("Please ensure the working directory is in Modelling_Suite");
end
%% Load in base MDNStruct
model_ID = "TOY_MODEL_BASE";
filename_base = sprintf("MDNStruct_%s_BASE",model_ID);
MDNStruct_BASE = loadFile(filename_base);
MDNStruct_BASE = loadProperties(MDNStruct_BASE);

%% Load in MDNStruct
% Choose PS for parameter sets, SV for state variables.
try
    num_set = 1;
    model_ID = "TOY_MODEL_BASE";
    filename = sprintf("%s_MDNStruct",model_ID);
    MDNStruct = loadFile(filename);
catch
    error("Must have MDNStruct to explore.")
end

%% Set total desired functional parameter sets.
total_MDN_desired = 1000;
loop_size = 1000;
generate_param_or_state = "SV";

base_parameter_values = MDNStruct_BASE.Properties.ParameterValues;
base_state_values = MDNStruct_BASE.Properties.StateICs;

%% Extract PS or SV that demonstrate a particular dynamic for a particular protein.
output_protein = "H";
behaviour = "REB";
param_or_state_source = "PS";
% Extract parameter sets (PS) or state variable sets (SV).
base_MDN_values_all = extractMDNSet(MDNStruct,output_protein,behaviour,param_or_state_source,num_set);
base_MDN_values = table2array(base_MDN_values_all(2,:));

%% Set up various simulation variables.
rng('shuffle');

param_names = MDNStruct_BASE.Properties.ParameterNames;
base_param_index = MDNStruct_BASE.Calibration.ParamTargetIDX;
MEX_Handle = MDNStruct_BASE.MEX_Handle;
num_param = length(param_names);

state_names = MDNStruct_BASE.Properties.StateNames;
base_state_index = MDNStruct_BASE.Calibration.StateTargetIDX;
num_states = length(state_names);

input_vector = ["input_Input1","input_Input2","input_Drug1"];
time_vector = [3000,20000,3000];
concentration_matrix = [0,0,0; 500,500,0; 500,500,500];
data_phase = 3;
MDNStruct_BASE = setupSimulationParameters(MDNStruct_BASE,input_vector,time_vector,concentration_matrix,data_phase);

% Establish drug target protein species
state_names = MDNStruct_BASE.Properties.StateNames;
drug_targets = ["pB"];
drug_target_index = ismember(state_names,drug_targets);

% Set tolerances for checks

neg_tol = -1e-10;   % (Maximum) Negative Value tolerance
zero_tol = 0.001;  % Close to Zero Tolerance
ss_tol = 0.005;     % (Maximum) Steady State Change 
stim_tol = 0.1;    % (Minimum) Stimulation Effect
abs_tol = 0.001;    % (Minimum) State variables changes below this threshold are too small. 
drug_stim_tol = 0.2; % (Minimum) Amount the drug target must decrease.
num_states_vars = length(MDNStruct_BASE.Properties.StateNames) + length(MDNStruct_BASE.Properties.VariableNames);
percent_responsive = 0.75; %(Minimum) Number of states and variables that must respond to perturbation
min_responsive = num_states_vars * percent_responsive;

switch generate_param_or_state
    case "PS"
        test_set = param_names(base_param_index);
        size_test_set = sum(base_param_index);
        MDN_set = zeros(loop_size,num_param);
        size_set = length(param_names);
        % Determine upper and lower bounds of parameter and protein concentration space (log10).
        upper = 3;
        lower = -4;
    case "SV"
        test_set = state_names(base_state_index);
        size_test_set = sum(base_state_index);
        MDN_set = zeros(loop_size,num_states);
        size_set = length(state_names);
        % Determine upper and lower bounds of parameter and protein concentration space (log10).
        lower = 0;
        upper = 5;
    otherwise
end

total_sets_found = 0;
total_set = [];
sets_found = zeros(loop_size,1);
negative = zeros(loop_size,1);
stiff = zeros(loop_size,1);
ss = zeros(loop_size,1);
drug_stim_resp = zeros(loop_size,1);
stim_resp = zeros(loop_size,1);

%% Generate and Test PS
tic;
while(total_sets_found < total_MDN_desired)
    % Generate random parameter sets.
    rand_mat_log10 = (upper-(upper - lower) * rand(loop_size,size_test_set));
    rand_mat = 10.^(rand_mat_log10);
    
    parfor IL = 1:loop_size
       test_set = [];
        switch generate_param_or_state
           case "PS"
               test_set = base_parameter_values;
               test_set(base_param_index) = rand_mat(IL,:);
           case "SV"
               test_set = base_state_values;
               test_set(base_state_index) = rand_mat(IL,:);
           otherwise
       end
       %test_state_values = rand_state_mat(IL,:);

       % Test stiffness, negative values, steady state equilibrium,  
       try
           % Check for stiffness. Exit loop if too stiff. 
           try
               test_model_out = [];
               switch generate_param_or_state
                   case "PS"
                       test_model_out = simulateModelInstance_STIFF(MDNStruct_BASE,test_set,base_MDN_values);
                   case "SV"
                       test_model_out = simulateModelInstance_STIFF(MDNStruct_BASE,base_MDN_values,test_set);
                   otherwise
               end
               stiff(IL) = 0;
           catch
               stiff(IL) = 1;
               error();
           end

           % Check for negative values. Exit if tolerance exceeded.
           if(anyNegativeValue(test_model_out, neg_tol) == true)
               negative(IL) = 1;
               error();
           else
               negative(IL) = 0;
           end

           % Make sure system achieves a steady state before mitogenic stimulation.
           if(steadyStateAchieved(test_model_out, zero_tol, ss_tol) == false)
               ss(IL) = 1;
               error();
           else
               ss(IL) = 0;
           end
           
           % Ensure at least a 20% decrease in response to drug for drug targets.
           if(responseToPerturbationDRUGS(test_model_out, drug_target_index, data_phase, drug_stim_tol, abs_tol) == false)
               drug_stim_resp(IL) = 1;
               error();
           else
               drug_stim_resp(IL) = 0;
           end

           % Ensure at least a 1% change in response to stimulation.
           if(responseToPerturbationABS(test_model_out, stim_tol, abs_tol, min_responsive) == false)
               stim_resp(IL) = 1;
               error();
           else
               stim_resp(IL) = 0;
           end
           
           sets_found(IL) = 1;
           MDN_set(IL,:) = test_set;
       catch
           sets_found(IL) = 0;
           MDN_set(IL,:) = ones(size_set,1)*NaN;
       end
    end
    
    % Delete NaN parameter sets
    MDN_set(any(isnan(MDN_set),2),:) = [];

    % Save Functional Parameter Sets
    total_set = vertcat(total_set, MDN_set);
    
    num_FPS_found = sum(sets_found);
    total_sets_found = total_sets_found + num_FPS_found;
    num_stiff = sum(stiff);
    num_neg = sum(negative);
    num_ss = sum(ss);
    num_no_drug_response = sum(drug_stim_resp);
    num_unresponsive = sum(stim_resp);
   
    error_summary = sprintf("Num Stiff: %d\nNum Negative: %d\nNum No SS: %d\nNum No Drug Resp: %d\n" + ...
        "Num Unresponsive: %d\nNum Sets Found: %d\nTotal Sets Found: %d\n",...
        num_stiff,num_neg,num_ss, num_no_drug_response, num_unresponsive,num_FPS_found,total_sets_found);
    disp(error_summary)

    sets_found = zeros(loop_size,1);
    stiff = zeros(loop_size,1);
    ss = zeros(loop_size,1);
    drug_stim_resp = zeros(loop_size,1);
    stim_resp = zeros(loop_size,1);
    MDN_set = zeros(loop_size,size_set);
end
allTime = toc

%% Transfer array and save MDNStruct.
switch generate_param_or_state
    case "PS"
        try
            set_num = size(MDNStruct.PS_Variation,2);
            set_num = set_num+1;
        catch
            error("No base parameter sets detected.")
        end
        MDNStruct.PS_Variation(set_num).FunctionalPS = array2table(total_set,"VariableNames",param_names);
        MDNStruct.PS_Variation(set_num).StateICs = base_MDN_values;
        MDNStruct.PS_Variation(set_num).Mode = sprintf("Filter_%s_%s_%s",output_protein,behaviour,param_or_state_source);
    case "SV"
        try
            set_num = size(MDNStruct.IC_Variation,2);
            set_num = set_num+1;
        catch
            error("No base state ICs detected.")
        end
        MDNStruct.IC_Variation(set_num).FunctionalICs = array2table(total_set,"VariableNames",state_names);
        MDNStruct.IC_Variation(set_num).PS = base_MDN_values;
        MDNStruct.IC_Variation(set_num).Mode = sprintf("Filter_%s_%s_%s",output_protein,behaviour,param_or_state_source);
    otherwise
end

%% Save patient/cell model struct
folder = fullfile(pwd,"\Model_IQM_MEX_Files\", "TOY_MODELS", model_ID);
save(fullfile(folder,filename),'MDNStruct_BASE');


