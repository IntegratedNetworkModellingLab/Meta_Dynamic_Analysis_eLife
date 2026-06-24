%% Create a model struct from a given IQM file.
function ModelStruct = createBaseModelStruct(ID, network_model_name, network_model_MEX_handle)    
    IQM_Model = network_model_MEX_handle;
    % Supply the ModelStruct with a name
    ModelStruct.ID = ID;
    ModelStruct.Model_Name = network_model_name;
    ModelStruct.MEX_Handle = network_model_MEX_handle;
    
    model_output = IQM_Model(0:10);
    
    % Model parameters, states and variables
    ModelStruct.ParameterNames = reshape(string(IQM_Model('parameters')),1,[]);
    ModelStruct.NumParameters = length(ModelStruct.ParameterNames);
    ModelStruct.StateNames = reshape(string(IQM_Model('states')),1,[]);
    ModelStruct.NumStates = length(ModelStruct.StateNames);
    ModelStruct.VariableNames = string(model_output.variables)';
    ModelStruct.NumVariables = length(ModelStruct.VariableNames);

    temp_variables = ModelStruct.VariableNames;
    pat = '_Data';
    data_variables_index = contains(temp_variables,pat);
    data_variables = temp_variables(data_variables_index);
    ModelStruct.DataVariables = data_variables;
    ModelStruct.DataVariableIDX = data_variables_index;
    ModelStruct.NumDataVariables = length(data_variables);
    
    % Default mex options.
    mexOptions.maxnumsteps = 1000;
    mexOptions.abstol      = 1e-9;
    mexOptions.reltol      = 1e-9;
    mexOptions.tss_check   = @(x) logical(sum((abs(x(end-1,x(end,:)>1e-3) - ...
        x(end,x(end,:)>1e-3))./x(end,x(end,:)>1e-3) > 1e-3) + (x(end,x(end,:)>1e-3)) < -1e-10));
    ModelStruct.MexOptions = mexOptions;

    

end


