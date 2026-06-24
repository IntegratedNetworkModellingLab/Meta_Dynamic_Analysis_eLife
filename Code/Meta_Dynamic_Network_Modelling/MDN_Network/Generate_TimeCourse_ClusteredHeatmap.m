%% Simulate and analyse the time-course profiles of a selected protein across the population of model instances.
clear;clc;close all;
pat = "ODE_Modelling_Suite";
str = string(pwd);

if(~contains(str,pat))
    error("Please ensure the working directory is in Modelling_Suite");
end

%% Load in the relevant MDN struct.
rep = "REP1";
model_ID = "ECC_Base";
%filename = sprintf("%s_MDNStruct_%s.mat",model_ID,rep);
filename = sprintf("%s_MDNStruct.mat",model_ID);
MDNStruct = loadFile(filename);
ID = MDNStruct.ID;

%% Select protein, load in variables.
model_state_names = MDNStruct.StateNames;
model_var_names = MDNStruct.VariableNames;
output_protein = 'MYC_Data';
%protein_index = find(ismember(model_state_names,output_protein)); 

protein_index = find(ismember(model_var_names,output_protein)); 

num_PS = size(MDNStruct.PS_Variation.FunctionalPS,1);
total_PS = table2array(MDNStruct.PS_Variation.FunctionalPS);

data_phase = MDNStruct.Simulation.DataPhase;
data_phase_time = MDNStruct.Simulation.Phases(data_phase).Time;
log_time_index = unique(round(logspace(0,log10(data_phase_time),51)));
MDNStruct.Simulation.Phases(data_phase).Log10TimeIndex = log_time_index;

num_test_PS = 1000;
PS_rand_loc = randperm(num_PS,num_test_PS);
rand_PS_array = total_PS(PS_rand_loc,:);

%% Generate Time Course data for output protein.
tic
parfor i = 1:num_test_PS
    temp_PS = rand_PS_array(i,:);
    temp_model_output = simulateModelInstance_STIFF(MDNStruct,temp_PS, []);
    
    temp_drug_output = temp_model_output(data_phase).variablevalues(log_time_index,protein_index);
    temp_drug_output(temp_drug_output < 0) = eps;
    
    drug_output(i,:) = abs(temp_drug_output);
    norm_drug_output(i,:) = abs(temp_drug_output ./ max(temp_drug_output));
end
toc
%% Cluster the time course data.
num_clusters = 9;
norm_drug_output(norm_drug_output < 0 ) = eps;
[N_Clusters, N_T, N_clust_gram] = clusterTCFunction(MDNStruct, norm_drug_output, num_clusters,500);

%% Plot the clusters
% for j = 1:num_clusters
%     try
%         N2_Clusters = clusterTCFunction(MDNStruct,N_Clusters(1,j).Cluster,num_clusters,500);
%     catch
%         disp('Too few model instances in cluster')
%     end
% end
