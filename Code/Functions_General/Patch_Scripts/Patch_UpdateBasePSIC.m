%% Update base PS and IC for model files.
% Need to change loadProperties file for Absolute_Protein_Quantity.
clear;clc;close all;
checkDirectory();

cell_line = input("Enter cell line: ", 's');
network_model = input("Enter network model: ",'s');
unique_ID = sprintf("%s_%s",cell_line,network_model);
calibration_protocol = input("Enter calibration protocol: ", 's');
calibration_variables = input("Enter calibration optimisation variables: ", 's');

PEC_Struct = loadPEC_Structs(unique_ID, calibration_protocol, calibration_variables);

temp_filename = sprintf("%s_%s_%s_CalibStruct.mat",unique_ID,calibration_protocol,calibration_variables);
filename_calib = fullfile(pwd,"Files\Model_Instances",unique_ID,"Calibration_Outputs",...
    calibration_protocol,calibration_variables,temp_filename);
CalibStruct = PEC_Struct.CalibStruct;
CalibStruct = loadProperties(unique_ID,CalibStruct);
save(filename_calib,'CalibStruct');