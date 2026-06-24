%% Create an MDN struct from a given IQM file.
function ModelStruct = createMDNModelStruct(ID, ModelStruct)    
        
    filename = sprintf('%s_Network_Properties.xlsx',ID);
    param_properties = readcell(filename,'Sheet','Parameters');
    param_values = reshape((cell2mat(param_properties(2:end,2))),1,[]);
    ModelStruct.ParameterValues = param_values;

    param_target_index = logical(cell2mat(param_properties(2:end,3)));
    ModelStruct.ParamTargetIDX = param_target_index;

    state_properties = readcell(filename,'Sheet','States');

    state_ICs = cell2mat(state_properties(2:end,2));
    calib_states = logical(cell2mat(state_properties(2:end,3)));
    state_ICs = reshape((state_ICs .* calib_states),1,[]);
    ModelStruct.StateICs = state_ICs;
    ModelStruct.StateTargetIDX = calib_states;

    % Create a table for storing best fit parameter sets.
    param_names = string(reshape(ModelStruct.ParameterNames,1,[]));
    state_names = string(reshape(ModelStruct.StateNames,1,[]));
    ModelStruct.FunctionalPS = array2table(param_values,"VariableNames",param_names);
    ModelStruct.FunctionalICs = array2table(state_ICs,"VariableNames",state_names);

end



