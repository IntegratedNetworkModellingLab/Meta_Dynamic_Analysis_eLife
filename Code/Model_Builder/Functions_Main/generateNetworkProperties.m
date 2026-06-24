function generateNetworkProperties(ModelStruct,filename)
    parameters = ModelStruct.ParameterNames;
    num_params = length(ModelStruct.ParameterNames);

    for j = 1:num_params
        temp_param = parameters(j);
        temp_param_split = strsplit(temp_param,'_');
        temp_param_mod = temp_param_split(1);
        switch temp_param_mod
            case "kc"
                parameter_values(j,1) = 0.1;
            case "Km"
                parameter_values(j,1) = 100;
            case "Vm"
                parameter_values(j,1) = 10;
            case "ka"
                parameter_values(j,1) = 0.001;
            case "kd"
                parameter_values(j,1) = 0.01;
            case "ksyn"
                parameter_values(j,1) = 10;
            case "kdcy"
                parameter_values(j,1) = 240;
            case "kdeg"
                parameter_values(j,1) = 0.1;
            case "alpha"
                parameter_values(j,1) = 1;
            case "input"
                parameter_values(j,1) = 500;
            case "inptime"
                parameter_values(j,1) = 1;
            case 'const'
                parameter_values(j,1) = 500;
            otherwise
                error("Parameter type not recognised")
        end
    end

    column_names = ["Parameter","Value","CalibrationTarget"];
    calib_param = ones(num_params,1);
    parameters = reshape(parameters,[],1);
    parameter_table = table(parameters,parameter_values,calib_param);
    parameter_table.Properties.VariableNames = column_names;
    writetable(parameter_table,filename,"Sheet","Parameters");

    states = ModelStruct.StateNames;
    states = reshape(states,[],1);
    num_states = length(ModelStruct.StateNames);
    states_IC = 500 * ones(num_states,1);

    col_names = ["States","IC","CalibrationTarget"];
    calib_states = ones(num_states,1);
    state_table = table(states,states_IC,calib_states);
    state_table.Properties.VariableNames = col_names;
    writetable(state_table,filename,"Sheet","States");

end