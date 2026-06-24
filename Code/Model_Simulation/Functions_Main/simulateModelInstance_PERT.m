function model_output = simulateModelInstance_PERT(ModelStruct, parameter_set, IC_set, param_pert_idx, pert_amount)
    if(isempty(parameter_set))
        try
            parameter_set = ModelStruct.Calibration.CurrentPS;
        catch
            error("No CurrentPS set.");
        end
    end
    if(isempty(IC_set))
        try
            IC_set = ModelStruct.Calibration.CurrentICs;
        catch
            error("No CurrentICs set.");
        end
    end
    
    IQM_MEXHandle = ModelStruct.MEX_Handle;
    ICs = IC_set;
    mex_options = ModelStruct.Simulation.MexOptions;
    parameter_names = ModelStruct.Properties.ParameterNames;
    parameter_values = parameter_set;

    num_phases = size(ModelStruct.Simulation.Phases,2);
    stim_param = ModelStruct.Simulation.StimulationParameters;
    num_stim_param = length(ModelStruct.Simulation.StimulationParameters);
    data_phase = ModelStruct.Simulation.DataPhase;
    
    model_output.statevalues = [];
    model_output.variablevalues = [];
    new_ICs = ICs;

    for i = 1:num_phases
        stim_values = ModelStruct.Simulation.Phases(i).StimParamValues;
        phase_time = ModelStruct.Simulation.Phases(i).Time;
        for ii = 1:num_stim_param
            stim = stim_values(ii);
            temp_index = strcmp(parameter_names,stim_param(ii));
            parameter_values(temp_index) = stim;
        end
        if(i == data_phase)
            parameter_values(param_pert_idx) = parameter_values(param_pert_idx) * pert_amount;
        end
        mex_options.maxnumsteps = 10000;
        ini_temp_model_output = IQM_MEXHandle(1:3,new_ICs,parameter_values,mex_options);
        temp_new_ICs = ini_temp_model_output.statevalues(end,:);

        mex_options.maxnumsteps = 1000;
        temp_model_output = IQM_MEXHandle(1:(phase_time-3),temp_new_ICs,parameter_values,mex_options);
        new_ICs = temp_model_output.statevalues(end,:);

        model_output(i).statevalues = vertcat(ini_temp_model_output.statevalues,temp_model_output.statevalues);
        model_output(i).variablevalues = vertcat(ini_temp_model_output.variablevalues,temp_model_output.variablevalues);
    end
end