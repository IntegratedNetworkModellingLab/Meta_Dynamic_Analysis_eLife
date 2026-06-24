%% Plot QBD as a stacked bar chart. Only plot active proteins.
clear;clc;close all;
checkDirectory();

%% Load in the relevant MDN struct.
model_ID = "DDR_NFLC1";
filename = sprintf("%s_MDNStruct.mat",model_ID);
MDNStruct = loadFile(filename);
ID = MDNStruct.ID;
PS_replicate = 2;

%Can also plot heatmap if desired. Otherwise comment out.
plotMDNStruct_QBD(MDNStruct,"QBD","PS",PS_replicate);

%% Extract relevant variables and data.
active_proteins = ["pA","pB","pC"];
output_labels = ["pA","pB","pC"];
num_active = length(active_proteins);
behaviours = MDNStruct.Behaviours;
num_behaviours = length(behaviours);

QBD = MDNStruct.PS_Variation(PS_replicate).QBD_Percentage{:,:};

for i = 1:num_active
    active_idx = find(ismember(MDNStruct.StateNames,active_proteins(i)));
    plot_data(i,:) = QBD(:,active_idx);
end

%% Plot the data.
fig_tile = tiledlayout(1,2);

ax = nexttile([1 2]);
bar_plot = bar(plot_data,'stacked');
ax.XTickLabel = output_labels;
ax.FontName = "Arial";
ax.FontSize = 15;
ax.YLim = [0 105];
ax.YLabel.String = "Percentage(%)";
ax.XLabel.String = "Output Protein";
ax.Title.String = "Protein Dynamic Distribution";

% INC-S
bar_plot(1).FaceColor = '#5f0f40';
bar_plot(1).EdgeColor = '#5f0f40';
% INC-W
bar_plot(2).FaceColor = '#5f0f40';
bar_plot(2).EdgeColor = '#5f0f40';

% DEC-S
bar_plot(3).FaceColor = '#9a031e';
bar_plot(3).EdgeColor = '#9a031e';
% DEC-W
bar_plot(4).FaceColor = '#9a031e';
bar_plot(4).EdgeColor = '#9a031e';

% BIP-S
bar_plot(5).FaceColor = '#fb8b24';
bar_plot(5).EdgeColor = '#fb8b24';
% BIP-W
bar_plot(6).FaceColor = '#fb8b24';
bar_plot(6).EdgeColor = '#fb8b24';

% REB-S
bar_plot(7).FaceColor = '#e36414';
bar_plot(7).EdgeColor = '#e36414';
% REB-W
bar_plot(8).FaceColor = '#e36414';
bar_plot(8).EdgeColor = '#e36414';

% OSC-S
bar_plot(9).FaceColor = '#0f4c5c';
bar_plot(9).EdgeColor = '#0f4c5c';
% OSC-W
bar_plot(10).FaceColor = '#0f4c5c';
bar_plot(10).EdgeColor = '#0f4c5c';

% NRP
bar_plot(11).FaceColor = '#bcb8b1';
bar_plot(11).EdgeColor = '#bcb8b1';
% NRPABS
bar_plot(12).FaceColor = '#bcb8b1';
bar_plot(12).EdgeColor = '#bcb8b1';

% ETC
bar_plot(13).FaceColor = '#bcb8b1';
bar_plot(13).EdgeColor = '#bcb8b1';

fig_leg = legend(behaviours);
fig_leg.Layout.Tile = 'east';
