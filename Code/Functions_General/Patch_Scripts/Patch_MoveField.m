%% Patch script to move fields.
clear; clc;
unique_ID = "HCC1954_ECC";
calibration_protocol1 = "All";
calibration_variables1 = "PS";
calib_table = "Top50";
filename_pert = sprintf("%s_%s_%s_%s_PertStruct.mat",unique_ID,calibration_protocol1,calibration_variables1,calib_table);
PertStruct = loadFile(filename);

filename2 = sprintf("COPY3%s_%s_%s_%s_PertStruct.mat",unique_ID,calibration_protocol1,calibration_variables1,calib_table);
PertStruct2 = loadFile(filename2);

% Insert whichever fields are being moved here.
PertStruct.SingleDrug = PertStruct2.SingleDrug;
PertStruct.DoubleDrug = PertStruct2.DoubleDrug;
PertStruct.TripleDrug = PertStruct2.TripleDrug;
    
CalibStruct = stitchReplicateTables(CalibStruct);

CalibStruct = loadProperties(unique_ID,CalibStruct);

CalibStruct.Combined_BFPS_Table{:,187} = 500;

% CalibStruct.Combined_BFPS_Table = ...
%     ModelStruct2.CalibrationOutput.(calibration_protocol2).(calibration_variables2).Combined_BFPS_Table;
% 
% CalibStruct.Complete_BFPS_Table = ...
%     ModelStruct2.CalibrationOutput.(calibration_protocol2).(calibration_variables2).Complete_BFPS_Table;
% 
% CalibStruct.Double_Complete_BFPS_Table = ...
%     ModelStruct2.CalibrationOutput.(calibration_protocol2).(calibration_variables2).Double_Complete_BFPS_Table;

folder = fullfile(pwd,"\Files\Model_Instances\", unique_ID,"Calibration_Outputs",calibration_protocol1,calibration_variables1);
save(fullfile(folder,filename),'PertStruct');