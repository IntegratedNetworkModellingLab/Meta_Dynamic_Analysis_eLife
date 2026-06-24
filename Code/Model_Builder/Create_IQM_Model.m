%% Create models from a matrix.
% Rows are the reactants, columns are the products.
clear; clc; close all;

%% Get the reactions from the matrix file.
model_name = "MM_IFF1C";
filename = sprintf("%s_Reactions.xlsx",model_name);
reactionStruct = getReactionStruct(filename);

%% Generate IQM text file from reaction struct.
generateIQMmodel(model_name,reactionStruct);

%% Convert to MEX file.
text_file = sprintf('%s.txtbc',model_name);
model = IQMmodel(text_file);
IQMmakeMEXmodel(model, model_name)
