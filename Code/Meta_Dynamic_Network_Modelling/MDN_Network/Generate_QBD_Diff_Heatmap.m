%% Generate QBD difference matrices and plot as a heatmap.
clear;clc;close all;
pat = "MATLAB\Modelling_Suite";
str = string(pwd);

if(~contains(str,pat))
    error("Please ensure the working directory is in Modelling_Suite");
end

%% Load in the relevant MDN structs.
model_ID = "ECC_FirstOrderKinetics";
filename = sprintf("%s_MDNStruct_MCF7.mat",model_ID);
MDNStruct = loadFile(filename);
ID = MDNStruct.ID;

% Load in the second MDN struct if necessary.
model_ID = "ECC_FirstOrderKinetics";
filename2 = sprintf("%s_MDNStruct_MDAMB468.mat",model_ID);
MDNStruct2 = loadFile(filename2);
ID2 = MDNStruct2.ID;

%% Extract the relevant QBDs
rep1 = 1;
rep2 = 1;
QBD1 = MDNStruct.PS_Variation(rep1).QBD_Percentage;
QBD2 = MDNStruct2.PS_Variation(rep2).QBD_Percentage;

% QBD_diff = abs(QBD1 - QBD2);
% QBD_diff(QBD_diff < 0.001) = 0;

QBD_diff = QBD1 - QBD2;
QBD_diff = QBD_diff';


%% Plot Heatmap All
colorMapMatrix = setColorMap("natureRedWhiteBlueMap");
behaviour_names = MDNStruct.Behaviours;
state_names = MDNStruct.Properties.StateNames;
var_names = MDNStruct.Properties.VariableNames;
label_names = vertcat(state_names,var_names);

figure
h = heatmap(behaviour_names,label_names,QBD_diff,'Colormap', colorMapMatrix);
h.Title = 'Qualitative Behaviour Distribution';
h.YLabel = 'Protein States';
h.XLabel = 'Behaviours';
% h.ColorScaling = 'log';
h.Position = [0.1300 0.1100 0.35 0.70];
% h.ColorLimits = ([-0.3 0.3]);

%% Plot Heatmap Data

colorMapMatrix = setColorMap("natureBlueWhiteRedMap");
behaviour_names = MDNStruct.Behaviours;
num_states = length(MDNStruct.Properties.StateNames);
variable_names = MDNStruct.Properties.DataVariables;
data_var_idx = MDNStruct.Properties.DataVariableIDX;
num_states_vars = size(QBD_diff,1);
states_vars_idx = zeros(1,num_states_vars);
states_vars_idx(1,num_states+1:end) = data_var_idx;
states_vars_idx = logical(states_vars_idx);

figure
h = heatmap(behaviour_names,variable_names,QBD_diff(states_vars_idx,:),'Colormap', colorMapMatrix);
h.Title = 'Qualitative Behaviour Distribution';
h.YLabel = 'Protein States';
h.XLabel = 'Behaviours';
% h.ColorScaling = 'log';
h.Position = [0.1300 0.1100 0.35 0.70];
