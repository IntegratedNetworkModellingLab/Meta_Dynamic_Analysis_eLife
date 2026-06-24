%% Executive script to generate functional parameter or state IC sets.
clear;clc;close all;
checkDirectory();

%% Load in base MDNStruct
model_ID = "ECC_Base";
filename_base = sprintf("MDNStruct_%s_BASE",model_ID);
MDNStruct_BASE = loadFile(filename_base);
folder = fullfile(model_ID);
MDNStruct_BASE = loadProperties(folder,model_ID,MDNStruct_BASE,"MDN");

%% Load in data structure storing MDN information.
try
    filename = sprintf("%s_MDNStruct",model_ID);
    MDNStruct = loadFile(filename);
catch
    MDNStruct = MDNStruct_BASE;
end

%% Set total desired functional parameter sets.
total_FPS_desired = 100000;
loop_size = 10000;
% Choose PS for parameter sets, SV for state variables.
param_or_state = "PS";

% Figure out replicate number.
% try
%     switch param_or_state
%         case "PS"
%             rep = size(MDNStruct.PS_Variation,2) + 1;
%         case "SV"
%             rep = size(MDNStruct.IC_Variation,2) + 1;
%         otherwise
%     end
% catch
%     rep = 1;
% end
rep = 1;
% If searching state variables, set parameter set.
base_param_values = MDNStruct_BASE.CurrentPS;
base_ICs = MDNStruct_BASE.CurrentIC;

%% Set up various simulation variables.
rng('shuffle');

param_names = MDNStruct_BASE.ParameterNames;
base_param_index = MDNStruct_BASE.ParamTargetIDX;
MEX_Handle = MDNStruct_BASE.MEX_Handle;
num_param = length(base_param_values);

state_names = MDNStruct_BASE.StateNames;
base_state_index = MDNStruct_BASE.StateTargetIDX;
num_states = length(state_names);

input_vector = ["input_INSULIN","input_CDK46i"]; 
time_vector = [5000,5000,3000];
concentration_matrix = [0,0; 500,0; 500,50]; 
data_phase = 3;
MDNStruct_BASE = setupSimulationParameters(MDNStruct_BASE,input_vector,time_vector,concentration_matrix,data_phase);

% Establish drug target protein species
state_names = MDNStruct_BASE.StateNames;
drug_targets = ["RBp","E2FccRBp"];
drug_target_index = ismember(state_names,drug_targets);

% Set tolerances for checks

neg_tol = -1e-10;   % (Maximum) Negative Value tolerance
zero_tol = 0.001;  % Close to Zero Tolerance
ss_tol = 0.05;     % (Maximum) Steady State Change 
stim_tol = 0.1;    % (Minimum) Stimulation Effect
abs_tol = 0.001;    % (Minimum) State variables changes below this threshold are too small. 
drug_stim_tol = 0.2; % (Minimum) Amount the drug target must decrease.
num_states_vars = length(MDNStruct_BASE.StateNames) + length(MDNStruct_BASE.VariableNames);
percent_responsive = 0.75; %(Minimum) Number of states and variables that must respond to perturbation
min_responsive = num_states_vars * percent_responsive;

switch param_or_state
    case "PS"
        test_set = param_names(base_param_index);
        size_test_set = sum(base_param_index);
        MDN_set = zeros(loop_size,num_param);
        MDNStruct_BASE.CurrentICs = base_ICs;
        size_set = length(param_names);
        % Determine upper and lower bounds of parameter and protein concentration space (log10).
        upper = 3;
        lower = -3;
    case "SV"
        test_set = state_names(base_state_index);
        size_test_set = sum(base_state_index);
        MDN_set = zeros(loop_size,num_states);
        MDNStruct_BASE.CurrentPS = base_param_values;
        size_set = length(state_names);
        % Determine upper and lower bounds of parameter and protein concentration space (log10).
        lower = 0;
        upper = 4;
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
while(total_sets_found < total_FPS_desired)
    % Generate random parameter sets.
    rand_mat_log10 = (upper-(upper - lower) * rand(loop_size,size_test_set));
    rand_mat = 10.^(rand_mat_log10);
    
    for IL = 1:loop_size
       test_set = [];
        switch param_or_state
           case "PS"
               test_set = base_param_values;
               test_set(base_param_index) = rand_mat(IL,:);
           case "SV"
               test_set = base_ICs;
               test_set(base_state_index) = rand_mat(IL,:);
           otherwise
       end
       %test_state_values = rand_state_mat(IL,:);

       % Test stiffness, negative values, steady state equilibrium,  
       try
           % Check for stiffness. Exit loop if too stiff. 
           try
               test_model_out = [];
               switch param_or_state
                   case "PS"
                       test_model_out = simulateModelInstance_STIFF(MDNStruct_BASE,test_set,base_ICs);
                   case "SV"
                       test_model_out = simulateModelInstance_STIFF(MDNStruct_BASE,base_param_values,test_set);
                   otherwise
               end
               stiff(IL) = 0;
           catch
               stiff(IL) = 1;
               error("Failed Stiff");
           end

           % Check for negative values. Exit if tolerance exceeded.
           if(anyNegativeValue(test_model_out, neg_tol) == true)
               negative(IL) = 1;
               error("Failed Negative");
           else
               negative(IL) = 0;
           end

           % Make sure system achieves a steady state before drug perturbation.
           if(steadyStateAchieved(test_model_out, zero_tol, ss_tol) == false)
               ss(IL) = 1;
               error("Failed Steady State");
           else
               ss(IL) = 0;
           end
           
           % Ensure at least a 20% decrease in response to drug for drug targets.
           if(responseToPerturbationDRUGS(test_model_out, drug_target_index, data_phase, drug_stim_tol, abs_tol) == false)
               drug_stim_resp(IL) = 1;
               error("Failed Drug Pert");
           else
               drug_stim_resp(IL) = 0;
           end

           % Ensure at least a 1% change in response to stimulation.
           if(responseToPerturbationABS(test_model_out, stim_tol, abs_tol, min_responsive) == false)
               stim_resp(IL) = 1;
               error("Failed Abs. Pert");
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
allTime = toc;

%% Transfer array and save MDNStruct.

switch param_or_state
    case "PS"
        MDNStruct.PS_Variation(rep).FunctionalPS = array2table(total_set,"VariableNames",param_names);
        MDNStruct.PS_Variation(rep).StateICs = base_ICs;
        MDNStruct.PS_Variation(rep).Mode = "Base Search";
        MDNStruct.PS_Variation(rep).Simulation = MDNStruct_BASE.Simulation;
    case "SV"
        MDNStruct.IC_Variation(rep).FunctionalICs = array2table(total_set,"VariableNames",state_names);
        MDNStruct.IC_Variation(rep).PS = base_param_values;
        MDNStruct.IC_Variation(rep).Mode = "Base Search";
        MDNStruct.IC_Variation(rep).Simulation = MDNStruct_BASE.Simulation;
    otherwise
end

%% Save patient/cell model struct
% folder = fullfile(pwd,"Files","Network_Instances",model_ID,"MDN_Files");
% save(fullfile(folder,filename),'MDNStruct');


