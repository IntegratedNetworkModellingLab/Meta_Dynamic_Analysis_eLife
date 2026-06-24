function plotModelStruct_OP(ModelStruct,output_protein)
    state_names = ModelStruct.Properties.StateNames;
    num_states = length(state_names);
    variable_names = ModelStruct.Properties.VariableNames;
    num_vars = length(variable_names);
    data_var_idx = ModelStruct.Properties.DataVariableIDX;
    data_names = ModelStruct.Properties.DataVariables;

    try
        op_idx = ismember(state_names,output_protein);
    catch
        op_idx = ismember(variable_names,output_protein);
    end
    
    model_output = simulateModelInstance_STIFF(ModelStruct,[]);
    
    num_phases = length(model_output);
    total_states = [];
    total_vars = [];
    for j = 1:num_phases
        try
            op_tc = vertcat(total_states,model_output(j).statevalues(:,op_idx));
        catch
            op_tc = vertcat(total_vars,model_output(j).variablevalues(:,op_idx));
        end
    end

    time_points = 1:size(op_tc,1);

    figure
    title(output_protein)
    plot(time_points,op_tc);
    title(sprintf("%s Time-Course",output_protein));
    xlabel('Time(minutes)')
    ylabel('Concentration (nM)');

    op_tc_norm = op_tc ./ mean(op_tc);
    figure
    title(output_protein)
    plot(time_points,op_tc_norm);
    title(sprintf("%s Time-Course (Norm. Mean)",output_protein));
    xlabel('Time(minutes)')
    ylabel('Fold Change');
end