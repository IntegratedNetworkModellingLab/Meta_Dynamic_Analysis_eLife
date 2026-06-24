function ModelStruct = loadProperties(folder,unique_ID,ModelStruct,calib_MDN_flag)
    temp_filename = sprintf('%s_Network_Properties.xlsx',unique_ID);
    switch calib_MDN_flag
        case "CALIB"
            temp_filename = fullfile(pwd,"Files\Model_Instances",folder,"Model_Files",temp_filename);
        case "MDN"
            temp_filename = fullfile(pwd,"Files\Network_Instances",folder,temp_filename);
        otherwise
            error("Property file type not specified.")
    end
    param_properties = readcell(temp_filename,'Sheet','Parameters');
    
    param_values = cell2mat(param_properties(2:end,2));
    ModelStruct.BasePS = reshape(param_values,1,[]);
    param_target_index = logical(cell2mat(param_properties(2:end,3)));

    state_properties = readcell(temp_filename,'Sheet','States');
    state_ICs = cell2mat(state_properties(2:end,2));
    calib_states = logical(cell2mat(state_properties(2:end,3)));
    ModelStruct.BaseIC = reshape(state_ICs,1,[]);
    
    ModelStruct.ParamTargetIDX = param_target_index;
    ModelStruct.StateTargetIDX = calib_states;
    
%     temp_filename = sprintf("%s_PropStruct.mat",unique_ID);
%     PropStruct = loadFile(temp_filename);

    ModelStruct.CurrentPS = ModelStruct.BasePS;
    ModelStruct.CurrentIC = ModelStruct.BaseIC;
   
%     best_fit_param_state = horzcat("Score","Exit Flag",PropStruct.ParameterNames,PropStruct.StateNames);
%     best_fit_param_state_values = horzcat(Inf,Inf,ModelStruct.BasePS,ModelStruct.BaseIC);
%     best_fit_param_state_table = array2table(best_fit_param_state_values,...
%         'VariableNames',best_fit_param_state);
% 
%     ModelStruct.BestFitParamStateTable = best_fit_param_state_table; 
%     ModelStruct.TotalInitialPopMatrix = [];
%     ModelStruct.InitialPopMatrix = [];

end