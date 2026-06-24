function plotMDNStruct_SINGLEWT(ModelStruct,plot_state)
    state_names = ModelStruct.Properties.StateNames;
    state_loc = ismember(state_names,plot_state);

    model_output = simulateModelInstance_STIFF(ModelStruct,[]);
    
    num_phases = length(model_output);
    total_states = [];
    total_vars = [];
    for j = 1:num_phases
        total_states = vertcat(total_states,model_output(j).statevalues);
        total_vars = vertcat(total_vars,model_output(j).variablevalues);
    end

    time_points = 1:size(total_states(:,1));
    plot(time_points,total_states(:,state_loc),'black');
end