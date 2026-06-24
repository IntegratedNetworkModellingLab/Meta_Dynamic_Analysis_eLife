%% Create a experiment struct.
clear;clc;close all;
checkDirectory();

%% Define Cell Line / Patient for IMF
cell_line = "HCC1954";
network_model = "ECC_Base";
unique_ID = sprintf("%s_%s",cell_line,network_model);
filename = sprintf("%s_Experiments.mat",unique_ID);

%% Load in experimental data and initial conditions.
data_file = sprintf('%s_Experimental_Data.xlsx',unique_ID);
ExperimentStruct = loadExperimentalData(unique_ID,data_file);

%% Save patient/cell model struct
if(isfolder(fullfile(pwd,"Files\Model_Instances", unique_ID,"Experiments")))
    folder = fullfile(pwd,"Files\Model_Instances", unique_ID,"Experiments");
    save(fullfile(folder,filename),'ExperimentStruct');
else
    mkdir(fullfile(pwd,"Files\Model_Instances", unique_ID,"Experiments"))
    folder = fullfile(pwd,"Files\Model_Instances", unique_ID,"Experiments");
    save(fullfile(folder,filename),'ExperimentStruct');
end