function plotModelStruct_VIABLE(ModelStruct)
    state_names = ModelStruct.Properties.StateNames;
    num_states = length(state_names);
    variable_names = ModelStruct.Properties.VariableNames;
    num_vars = length(variable_names);
    data_var_idx = ModelStruct.Properties.DataVariableIDX;
    data_names = ModelStruct.Properties.DataVariables;
    data_phase = ModelStruct.Sim.DataPhase;
    
    num_PS = size(ModelStruct.Calibration.ViableParameterSets,1);

    for i = 1:num_PS 
        ModelStruct.Calibration.CurrentPS = ModelStruct.Calibration.ViableParameterSets{i,3:end};
        viable_output(i).model_output = simulateModelInstance_STIFF(ModelStruct,[]);
    end
    
    m = ceil(sqrt(num_states));
    n = ceil(sqrt(num_vars));
    time_points = 1:size(viable_output(1).model_output(data_phase).statevalues,1);
    
    figure
    for i = 1:num_states
        hold on;
        for ii = 1:num_PS
            temp_state_values(:,ii) = viable_output(ii).model_output(data_phase).statevalues(:,i);
        end
        subplot(m,m,i),plot(time_points,temp_state_values);
        subtitle(state_names(i));
        hold off;
    end
    
    figure
    for i = 1:num_states
        hold on;
        for ii = 1:num_PS
            temp_state_values(:,ii) = viable_output(ii).model_output(data_phase).statevalues(:,i);
%             temp_state_values_norm(:,ii) = temp_state_values(:,ii) ./ max(temp_state_values(:,ii));
            temp_state_values_norm(:,ii) = temp_state_values(:,ii) ./ mean(temp_state_values(:,ii));
%             temp_state_values_norm(:,ii) = temp_state_values(:,ii) ./ temp_state_values(1,ii);
        end
        subplot(m,m,i),plot(time_points,temp_state_values_norm);
        subtitle(state_names(i));
        hold off;
    end

    figure
    for i = 1:num_vars
        hold on;
        for ii = 1:num_PS
            temp_var_values(:,ii) = viable_output(ii).model_output(data_phase).variablevalues(:,i);
        end
        subplot(n,n,i),plot(time_points,temp_var_values);
        subtitle(variable_names(i));
        hold off;
    end
    
end