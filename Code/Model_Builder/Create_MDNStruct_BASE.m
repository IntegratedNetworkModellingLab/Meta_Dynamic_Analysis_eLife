%% Create MDNStruct.
clear;clc;close all;
checkDirectory();

%% Declare Model ID and handle
model_ID = "MM_IFF1C";
MEX_handle = @MM_IFF1C;

%% Generate filename/folder
rate_order = 'MichaelisMentenKinetics';
folder = fullfile(pwd,"\Projects\Dose_Dependent_Response\Files\",rate_order,model_ID);

%% Create Base Model Struct
MDNStruct = createBaseModelStruct(model_ID,"MDN",MEX_handle);

%% Generate Network Properties file if it doesn't exist.
generateNetworkProperties(MDNStruct,fullfile(folder,sprintf("%s_Network_Properties.xlsx",model_ID)));

%% Finalise MDNStruct Creation
MDNStruct = createMDNModelStruct(model_ID,MDNStruct);

%% Save patient/cell model struct
filename = sprintf("MDNStruct_%s_BASE",model_ID);
save(fullfile(folder,filename),'MDNStruct');