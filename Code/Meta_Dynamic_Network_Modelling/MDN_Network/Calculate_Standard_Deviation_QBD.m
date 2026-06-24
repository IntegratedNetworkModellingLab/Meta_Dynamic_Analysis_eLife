% Function to assess error convergence in MDN modelling.
clear;clc;close all;
pat = "MATLAB\Modelling_Suite";
str = string(pwd);

if(~contains(str,pat))
    error("Please ensure the working directory is in Modelling_Suite");
end

%% Load in the relevant MDN struct.
rep1 = "REP1";
model_ID = "TOY_MODEL_BASE";
filename = sprintf("%s_MDNStruct_%s.mat",model_ID,rep1);
MDNStruct_1 = loadFile(filename);
QBD_percentage_1 = MDNStruct_1.QBD_Percentage;

% Load in the relevant MDN struct.
rep2 = "REP2";
model_ID = "TOY_MODEL_BASE";
filename = sprintf("%s_MDNStruct_%s.mat",model_ID,rep2);
MDNStruct_2 = loadFile(filename);
QBD_percentage_2 = MDNStruct_2.QBD_Percentage;

% Load in the relevant MDN struct.
rep3 = "REP3";
model_ID = "TOY_MODEL_BASE";
filename = sprintf("%s_MDNStruct_%s.mat",model_ID,rep3);
MDNStruct_3 = loadFile(filename);
QBD_percentage_3 = MDNStruct_3.QBD_Percentage;

%% Calculate Standard Error of the Mean (SEM)
num_behaviours = size(QBD_percentage_1,1);
for i = 1:num_behaviours
    temp_QBD(1,:) = QBD_percentage_1(i,:);  
    temp_QBD(2,:) = QBD_percentage_2(i,:);
    temp_QBD(3,:) = QBD_percentage_3(i,:);

    std_error(i,:) = std(temp_QBD,[],1);
end

mean_error = mean(std_error,'all');
MDNStruct_1.QBD_StdDev = std_error;
MDNStruct_1.QBD_MeanError = mean_error;
plotMDNStruct_QBD(MDNStruct_1,"Error");



%% Save MDN Struct
folder = fullfile(pwd,"\Model_IQM_MEX_Files", "TOY_MODELS", model_ID);
filename = sprintf("%s_MDNStruct_%s",model_ID,rep1);
save(fullfile(folder,filename),'MDNStruct_1');
