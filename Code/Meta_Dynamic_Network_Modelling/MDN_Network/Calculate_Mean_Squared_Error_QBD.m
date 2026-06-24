% Function to assess error convergence in MDN modelling.
clear;clc;close all;
pat = "MATLAB\Modelling_Suite";
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

%% Establish variables
%QBD = MDNStruct.QBD;
QBD = MDNStruct.PS_Variation.QBD;
num_PS = size(QBD,1);

num_iters = ceil(log2(num_PS));

%% Calculate QBD as number of PS doubles.
%QBD_initial = calculateDynamicDistribution(QBD(1,:));
QBD_initial = calculateDynamicDistribution_simple(QBD(1,:));
num_observations = size(QBD_initial,1) * size(QBD_initial,2);
for i = 1:num_iters
    if(2^i > num_PS)
        num_test_PS(i) = num_PS;
    else
        num_test_PS(i) = 2^i;
    end
    
    temp_QBD = QBD(1:num_test_PS(i),:);

    temp_QBD_percentage(i).temp = calculateDynamicDistribution_simple(temp_QBD);
    if(i == 1)
        error(i) = (sum((temp_QBD_percentage(i).temp - QBD_initial).^2,'all')) / num_observations;
    else
        error(i) = (sum((temp_QBD_percentage(i).temp - temp_QBD_percentage(i-1).temp).^2,'all')) / num_observations;
    end
end

%% Plot bar graph of the error as the number of model instances increases
num_PS_labels = string(num_test_PS);
bar_labels = categorical(num_PS_labels);
bar_labels = reordercats(bar_labels,num_PS_labels);
bar(bar_labels,error)

bar(bar_labels,log10(error))
