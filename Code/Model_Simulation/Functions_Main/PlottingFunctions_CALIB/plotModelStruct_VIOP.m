function plotModelStruct_VIOP(ModelStruct,output_protein)
    state_names = ModelStruct.Properties.StateNames;
    num_states = length(state_names);
    variable_names = ModelStruct.Properties.VariableNames;
    num_vars = length(variable_names);

    try
        op_idx = ismember(state_names,output_protein);
    catch
        op_idx = ismember(variable_names,output_protein);
    end

    data_var_idx = ModelStruct.Properties.DataVariableIDX;
    data_names = ModelStruct.Properties.DataVariables;
    data_phase = ModelStruct.Sim.DataPhase;
    
    num_PS = size(ModelStruct.Calibration.ViableParameterSets,1);
    try
        for i = 1:num_PS 
            ModelStruct.Calibration.CurrentPS = ModelStruct.Calibration.ViableParameterSets{i,3:end};
            viable_output(i).model_output = simulateModelInstance_STIFF(ModelStruct,[]);
        end
        
        m = ceil(sqrt(num_states));
        n = ceil(sqrt(num_vars));
        time_points = 1:size(viable_output(1).model_output(data_phase).statevalues,1);
        
        figure
    
        hold on;
        for ii = 1:num_PS
            temp_state_values(:,ii) = viable_output(ii).model_output(data_phase).statevalues(:,op_idx);
        end
        plot(time_points,temp_state_values);
        title(state_names(op_idx));
        hold off;
  
        figure
        hold on;
        for ii = 1:num_PS
            temp_state_values(:,ii) = viable_output(ii).model_output(data_phase).statevalues(:,op_idx);
    %             temp_state_values_norm(:,ii) = temp_state_values(:,ii) ./ max(temp_state_values(:,ii));
            temp_state_values_norm(:,ii) = temp_state_values(:,ii) ./ mean(temp_state_values(:,ii));
    %             temp_state_values_norm(:,ii) = temp_state_values(:,ii) ./ temp_state_values(1,ii);
        end
        plot(time_points,temp_state_values_norm);
        title(state_names(op_idx));

    catch
        figure
        hold on;
        for ii = 1:num_PS
            temp_var_values(:,ii) = viable_output(ii).model_output(data_phase).variablevalues(:,op_idx);
        end
        plot(time_points,temp_var_values);
        title(variable_names(op_idx));
        hold off;
    end
    
end