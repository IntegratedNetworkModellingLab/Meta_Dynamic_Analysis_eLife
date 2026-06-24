%% Executive script to generate functional parameter or state IC sets.
clear;clc;close all;
checkDirectory();

%% Load in base MDNStruct
model_ID = "ECC_Base";
filename = sprintf("%s_MDNStruct",model_ID);
MDNStruct = loadFile(filename);

%%
base_param_values = MDNStruct.IC_Variation.PS;
test_set = MDNStruct.IC_Variation.FunctionalICs{1,:};
MDNStruct.Simulation = MDNStruct.IC_Variation.Simulation;

%%
num_IC = 50;
phase = 3;
state = "AKTpp";
state_idx = ismember(MDNStruct.StateNames, state);
plotMDNStruct_ICNUM(MDNStruct,50, state_idx);
% test_model_out = simulateModelInstance_STIFF(MDNStruct,base_param_values,test_set);

state_names = MDNStruct.StateNames;
% num_states = length(state_names);
    
IC_sets = table2array(MDNStruct.IC_Variation.FunctionalICs);
num_sets = size(IC_sets,1);

param_set = MDNStruct.IC_Variation.PS;

figure
hold on
for i = 1:num_IC
    rand_IC = randi(num_sets);
    IC_set = IC_sets(rand_IC,:);
    model_output = simulateModelInstance_STIFF(MDNStruct,param_set, IC_set);
    
    total_states = [];
    num_phases = length(model_output);
    for ii = phase
        total_states = vertcat(total_states,model_output(ii).statevalues);
    end

    time_points = 1:size(total_states,1);
    state_values = total_states(:,state_idx);
    norm_values = state_values ./ mean(state_values);
    
    plot(time_points(1:50),state_values(1:50), LineWidth=3);
    ylim([0 30])
    ax = gca;
    ax.FontSize = 10;
    ax.FontName = "Arial";
    ax.LineWidth = 2;      
end

hold off
