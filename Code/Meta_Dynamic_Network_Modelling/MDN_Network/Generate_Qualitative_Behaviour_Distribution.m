%% Simulate and analyse the qualitative behaviour distribution of the proteins within the specified network.
clear;clc;close all;
checkDirectory();

%% Calculate QBD for parameter sets (PS), or state variables (SV).
param_or_state = "PS";
set_num = 1;

%% Load in the relevant MDN struct.
model_ID = "ECC_Base";
filename = sprintf("%s_MDNStruct.mat",model_ID);
MDNStruct = loadFile(filename);
ID = MDNStruct.ID;

% %Can plot straight from here if desired. Otherwise comment out.
% plotMDNStruct_QBD(MDNStruct,"QBD",param_or_state,set_num);
% plotMDNStruct_QBD_DATA(MDNStruct,"QBD",param_or_state,set_num);

%% Establish simulation variables.
input_vector = ["input_INSULIN","input_CDK46i"];
time_vector = [5000,5000,3000];
concentration_matrix = [0,0; 500,0; 500,50];
data_phase = 3;
MDNStruct = setupSimulationParameters(MDNStruct,input_vector,time_vector,concentration_matrix,data_phase);


% Extract test parameter sets.
switch param_or_state
    case "PS"
        test_array = table2array(MDNStruct.PS_Variation(set_num).FunctionalPS);
        num_test_array = size(test_array,1);
        base_IC_set = MDNStruct.PS_Variation(set_num).StateICs;

    case "SV"
        test_array = table2array(MDNStruct.IC_Variation(set_num).FunctionalICs);
        num_test_array = size(test_array,1);
        base_PS_set = MDNStruct.IC_Variation(set_num).PS;
    otherwise
end

%% Generate QBD
tic
parfor i = 1:num_test_array
    switch param_or_state
        case "PS"
            temp_PS = test_array(i,:);
            try
                temp_model_output = simulateModelInstance_STIFF(MDNStruct,temp_PS,base_IC_set);
            catch
                temp_model_output = [];
                disp(i)
            end
        case "SV"
            temp_ICs = test_array(i,:);
            try
                temp_model_output = simulateModelInstance_STIFF(MDNStruct,base_PS_set,temp_ICs);
            catch
                temp_model_output = [];
                disp(i)
            end
        otherwise
    end

    % temp_state_values = temp_model_output(data_phase).statevalues;
    % temp_var_values = temp_model_output(data_phase).variablevalues;
    % temp_values = horzcat(temp_state_values,temp_var_values);
    temp_values = temp_model_output(data_phase).variablevalues;
    
    QBD(i,:) = assessDynamicCategory(temp_values);

end
%%
%QBD_percentage = calculateDynamicDistribution(QBD);
%behaviours = ["INC-S","INC-W","DEC-S","DEC-W","BIP-S","BIP-W","REB-S",...
%    "REB-W","OSC-S","OSC-W","NRP","NRPABS","ETC"];
QBD_percentage = calculateDynamicDistribution_simple(QBD);
behaviours = ["INC","DEC","BIP","REB","NRP","NRPABS","ETC"];
vars = reshape(MDNStruct.VariableNames,[],1);
% states_vars = [reshape(MDNStruct.StateNames,[],1) ;reshape(MDNStruct.VariableNames,[],1)];
MDNStruct.Behaviours = behaviours;
QBD_table = array2table(QBD_percentage);
QBD_table.Properties.RowNames = behaviours;

QBD_data = QBD_percentage(:,7:18);
data_vars = vars(7:18);

% QBD_table.Properties.VariableNames = states_vars;
QBD_table.Properties.VariableNames = vars;
switch param_or_state
    case "PS"
        MDNStruct.PS_Variation(set_num).QBD = QBD;
        MDNStruct.PS_Variation(set_num).QBD_Percentage = QBD_table;
    case "SV"
        MDNStruct.IC_Variation(set_num).QBD = QBD;
        MDNStruct.IC_Variation(set_num).QBD_Percentage = QBD_table;
    otherwise
end
plotMDNStruct_QBD_2(QBD_data,data_vars,behaviours);

toc
%% Save MDN Struct
% folder = fullfile(pwd,"Files","Network_Instances",model_ID,"MDN_Files");
% save(fullfile(folder,filename),'MDNStruct');

vars = reshape(MDNStruct.VariableNames,[],1);
behaviours = ["INC","DEC","BIP","REB","NRP","NRPABS","ETC"];

QBD_data = MDNStruct.PS_Variation.QBD_Percentage{:,66:77}';
data_vars = vars(7:18);

qbd_table = array2table(QBD_data);
qbd_table.Properties.RowNames = data_vars;
qbd_table.Properties.VariableNames = behaviours;
writetable(qbd_table, 'data_qbd_table.csv','WriteRowNames', true);
