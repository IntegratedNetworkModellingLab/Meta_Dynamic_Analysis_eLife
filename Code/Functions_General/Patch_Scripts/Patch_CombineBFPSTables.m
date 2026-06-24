%% Patch script to move fields.
clear; clc;
ID = "MDAMB468_ECC";
calibration_protocol1 = "All";
calibration_variables1 = "PS";
filename = sprintf("%s_%s_%s_CalibStruct.mat",ID,calibration_protocol1,calibration_variables1);
CalibStruct = loadFile(filename);

filename = sprintf("%s_%s_%s_QualityStruct.mat",ID,calibration_protocol1,calibration_variables1);
QualityStruct = loadFile(filename);

QualityStruct.Top50_BFPS_Table = CalibStruct.Complete_BFPS_Table(1:50,:);

CalibStruct_ALL = CalibStruct;
CalibStruct_ALL.Complete_BFPS_Table = [];
CalibStruct_ALL.Complete_BFPS_Table = vertcat(CalibStruct_ALL.Complete_BFPS_Table,CalibStruct.Complete_BFPS_Table);

calibration_protocol1 = "Precalib";
calibration_variables1 = "PS";
filename = sprintf("%s_%s_%s_CalibStruct.mat",ID,calibration_protocol1,calibration_variables1);
CalibStruct = loadFile(filename);

CalibStruct_ALL.Complete_BFPS_Table = vertcat(CalibStruct_ALL.Complete_BFPS_Table,CalibStruct.Complete_BFPS_Table);

calibration_protocol1 = "PrecalibMDN";
calibration_variables1 = "PS";
filename = sprintf("%s_%s_%s_CalibStruct.mat",ID,calibration_protocol1,calibration_variables1);
CalibStruct = loadFile(filename);

CalibStruct_ALL.Complete_BFPS_Table = vertcat(CalibStruct_ALL.Complete_BFPS_Table,CalibStruct.Complete_BFPS_Table);

[~,sort_IDX] = sort(CalibStruct_ALL.Complete_BFPS_Table{:,1},'ascend');
CalibStruct_ALL.Complete_BFPS_Table = CalibStruct_ALL.Complete_BFPS_Table(sort_IDX,:);

save_protocol = "All";
filename2 = sprintf("%s_%s_%s_QualityStruct.mat",ID,save_protocol,calibration_variables1);
folder = fullfile(pwd,"\Files\Model_Instances\", ID,"Calibration_Quality",save_protocol,calibration_variables1);

if(isfolder(folder))
    save(fullfile(folder,filename2),'QualityStruct');
else
    mkdir(folder)
    save(fullfile(folder,filename2),'QualityStruct');
end