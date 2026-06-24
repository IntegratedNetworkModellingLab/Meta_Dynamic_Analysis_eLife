%% Simulate and analyse the time-course profiles of a selected protein across the population of model instances.
clear;clc;close all;
pat = "MATLAB\Modelling_Suite";
str = string(pwd);

if(~contains(str,pat))
    error("Please ensure the working directory is in Modelling_Suite");
end

%% Load in the relevant MDN struct.
rep = "REP1";
model_ID = "TOY_MODEL_BASE";
filename = sprintf("%s_MDNStruct_%s.mat",model_ID,rep);
MDNStruct = loadFile(filename);
ID = MDNStruct.ID;

%% Select protein, load in variables.
model_state_names = MDNStruct.Properties.StateNames;
output_protein = 'H';
protein_index = find(ismember(model_state_names,output_protein)); 

filter_NRP_index = ismember(MDNStruct.QBD(:,protein_index),"REB");

total_PS = table2array(MDNStruct.FunctionalPS);
filtered_PS = total_PS(filter_NRP_index,:);
num_PS = size(filtered_PS,1);

data_phase = MDNStruct.Sim.DataPhase;
data_phase_time = MDNStruct.Sim.Phases(data_phase).Time;
log_time_index = unique(round(logspace(0,log10(data_phase_time),51)));
MDNStruct.Sim.Phases(data_phase).Log10TimeIndex = log_time_index;

num_test_PS = 96;
PS_rand_loc = randperm(num_PS,num_test_PS);
rand_PS_array = filtered_PS(PS_rand_loc,:);

%% Generate Time Course data for output protein.
tic
parfor i = 1:num_test_PS
    temp_PS = rand_PS_array(i,:);
    temp_model_output = simulateModelInstance_STIFF(MDNStruct,temp_PS);
    
    temp_drug_output = temp_model_output(data_phase).statevalues(log_time_index,protein_index);
    temp_drug_output(temp_drug_output < 0) = eps;
    
    drug_output(i,:) = abs(temp_drug_output);
    norm_drug_output(i,:) = abs(temp_drug_output ./ max(temp_drug_output));
end
toc
%% Cluster the time course data.
num_clusters = 9;
norm_drug_output(norm_drug_output < 0 ) = eps;
[N_Clusters, N_T, N_clust_gram] = clusterTCFunction(MDNStruct,norm_drug_output,num_clusters,500);

%% Plot the clusters
% for j = 1:num_clusters
%     try
%         clusterTCFunction(MDNStruct,N_Clusters(1,j).Cluster,num_clusters,500);
%     catch
%         disp('Too few model instances in cluster')
%     end
% end

