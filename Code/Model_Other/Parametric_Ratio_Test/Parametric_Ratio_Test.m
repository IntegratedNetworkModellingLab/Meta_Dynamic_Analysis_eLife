%% Function  for testing a small model.
% Attempt to elucidate parametric ratios that drive signal transduction.
clear; clc;
%% Load in model
model_ID = "TOY_MODEL_SMALL";
filename = sprintf("MDNStruct_%s_BASE",model_ID);
MDNStruct = loadFile(filename);
MDNStruct = loadProperties(MDNStruct);

%% Generate simulation parameters
input_vector = ["input_Input1","input_Drug1"];
time_vector = [3000,20000,3000];
concentration_matrix = [0,0; 500,0; 500,500];
data_phase = 3;
MDNStruct = setupSimulationParameters(MDNStruct,input_vector,time_vector,concentration_matrix,data_phase);

%% Initialise Current PS and plot initial simulation.
MDNStruct.Calibration.CurrentPS = MDNStruct.Properties.ParameterValues;

param_values = MDNStruct.Calibration.CurrentPS;
param_names = MDNStruct.Properties.ParameterNames;
param_table = table(param_values,'RowNames',param_names);
% plotModelStruct_ALL(MDNStruct);

state_names = MDNStruct.Properties.StateNames;
num_states = length(state_names);

%% Test several orders of magnitude to test the ability of this small network to transduce a signal.
log10_array = [-4:1:3];
num_order_mag = length(log10_array);

param2 = "ksyn_pB_C";
param1 = "kdcy_C";
param_loc1 = ismember(param_names,param1);
param_loc2 = ismember(param_names,param2);

output_protein = "C";
prot_loc = ismember(state_names,output_protein);

%% Colour order for graph.
ColourTable = readtable('Colour_Fades.xlsx', 'Sheet', 'Red');
ColourArray = table2array(ColourTable);
numColours = length(ColourArray);
newColours = strings(1,numColours);

for kk = 1:numColours
    newColours(kk) = ColourArray{kk};
end


%% Loop and plot
% m = ceil(sqrt(num_states));
% figure
% 
% for i = 1:num_states
%     for ii = 1:num_order_mag
%         temp_param_values = param_values;
%         temp_param_values(param_loc1) = 10^(log10_array(ii));
%         MDNStruct.Calibration.CurrentPS = temp_param_values;
%         hold on
%         subplot(m,m,i), plotMDNStruct_SINGLESTATE(MDNStruct,state_names(i));
%         subtitle(state_names(i));
%         set(gca, 'YScale', 'log');
%     end
%     colororder(newColours);
%     MDNStruct.Calibration.CurrentPS = param_values;
%     subplot(m,m,i), plotMDNStruct_SINGLEWT(MDNStruct,state_names(i));
%     
%     hold off
%     sgtitle(param1,'defaultTextInterpreter','none')
% end

%% Now shift 2 parameters past each other.
m = num_order_mag / 2;
n = 2;
iter = 1;
figure
for i = 1:num_order_mag
    temp_param_values = param_values;
    temp_param_values(param_loc1) = 10^(log10_array(i));
    for ii = 1:num_order_mag
        temp_temp_param_values = temp_param_values;
        temp_temp_param_values(param_loc2) = 10^(log10_array(ii));
        MDNStruct.Calibration.CurrentPS = temp_temp_param_values;
        hold on
        subplot(n,m,iter), plotMDNStruct_SINGLESTATE(MDNStruct,state_names(prot_loc));
        subtitle(num2str(10^log10_array(i)));
        set(gca, 'YScale', 'log');
    end
    colororder(newColours);
    MDNStruct.Calibration.CurrentPS = temp_param_values;
    subplot(n,m,iter), plotMDNStruct_SINGLEWT(MDNStruct,state_names(prot_loc));
    hold off
    sgtitle(strcat(param1,", ",param2,", ",output_protein),'defaultTextInterpreter','none')
    iter = iter + 1;
end


%% Now shift 2 parameters past each other.
% m = num_order_mag;
% n = num_states;
% iter = 1;
% figure
% for j = 1:num_states
%     for i = 1:num_order_mag
%         temp_param_values = param_values;
%         temp_param_values(param_loc1) = 10^(log10_array(i));
%         for ii = 1:num_order_mag
%             temp_temp_param_values = temp_param_values;
%             temp_temp_param_values(param_loc2) = 10^(log10_array(ii));
%             MDNStruct.Calibration.CurrentPS = temp_temp_param_values;
%             hold on
%             subplot(n,m,iter), plotMDNStruct_SINGLESTATE(MDNStruct,state_names(j));
%             subtitle(num2str(10^log10_array(i)));
%             set(gca, 'YScale', 'log');
%         end
%         colororder(newColours);
%         MDNStruct.Calibration.CurrentPS = param_values;
%         subplot(n,m,iter), plotMDNStruct_SINGLEWT(MDNStruct,state_names(j));
%         hold off
%         sgtitle(param1,'defaultTextInterpreter','none')
%         iter = iter + 1;
%     end
% end



