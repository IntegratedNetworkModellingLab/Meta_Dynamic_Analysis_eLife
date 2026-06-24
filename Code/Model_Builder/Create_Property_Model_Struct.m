%% Create a new patient/cell model and save.
clear;clc;close all;
checkDirectory();

%% Define Cell Line / Patient for IMF
cell_line = "MDAMB468";
network_model = "ECC_Base";
unique_ID = sprintf("%s_%s",cell_line,network_model);
filename = sprintf("%s_PropStruct.mat",unique_ID);

% Select Network Model
network_model_name = "ECC_Base";
network_model_MEX_handle = @ECC_Base;

PropStruct = createBaseModelStruct(unique_ID, network_model_name, network_model_MEX_handle);

%% Generate Network Properties file.
folder2 = fullfile(pwd,"\Files\Model_Instances\",unique_ID,"Model_Files");
generateNetworkProperties(PropStruct,fullfile(folder2,sprintf("%s_Network_Properties.xlsx",unique_ID)));

%% Save patient/cell model struct
if(isfolder(fullfile(pwd,"Files\Model_Instances", unique_ID,"Property_Struct")))
    folder = fullfile(pwd,"Files\Model_Instances", unique_ID,"Property_Struct");
    save(fullfile(folder,filename),'PropStruct');
else
    mkdir(fullfile(pwd,"Files\Model_Instances", unique_ID,"Property_Struct"))
    folder = fullfile(pwd,"Files\Model_Instances", unique_ID,"Property_Struct");
    save(fullfile(folder,filename),'PropStruct');
end
