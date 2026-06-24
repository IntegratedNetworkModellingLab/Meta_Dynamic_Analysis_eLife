%% Patch script to extract data.
clear; clc;
unique_ID = "MCF7_ECC";
calibration_protocol1 = "All";
calibration_variables1 = "PS";
calib_table = "SoftRobust";
filename_pert = sprintf("%s_%s_%s_%s_PertStruct.mat",unique_ID,calibration_protocol1,calibration_variables1,calib_table);
PertStruct = loadFile(filename_pert);

num_combos = size(PertStruct.DoubleDrug.DrugCombinationNames,1);
combo_names = PertStruct.DoubleDrug.DrugCombinationNames;

for i = 1:num_combos
    index(i,1) = any(strcmp(combo_names(i,:),"CDK46"));
end

CDK46_combos = combo_names(index,:);

Inhib50 = PertStruct.DoubleDrug.PertDiffMatrix(5).DoseEffects(index,:);