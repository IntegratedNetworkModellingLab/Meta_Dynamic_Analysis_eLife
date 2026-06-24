function plotModelStruct_BASIC(ModelStruct)
    unique_ID = ModelStruct.ID;
    ModelStruct = loadProperties(unique_ID,ModelStruct);
    param_set = ModelStruct.ParameterValues;
    IC_set = ModelStruct.StateICs .* ModelStruct.StateTargetIDX';
    state_names = ModelStruct.StateNames;
    num_states = length(state_names);
    variable_names = ModelStruct.VariableNames;
    num_vars = length(variable_names);
    time_points = 1:23000;

    input_vector = ["input_Input1","input_Input2","input_Drug1"]; 
    time_vector = [10000,10000,3000];
    concentration_matrix = [0,0,0; 500,500,0; 500,500,500]; 
    data_phase = 3;
    ModelStruct = setupSimulationParameters(ModelStruct,input_vector,time_vector,concentration_matrix,data_phase);
    model_output = simulateModelInstance_STIFF(ModelStruct,param_set,IC_set);
    
    num_phases = length(model_output);
    total_states = [];
    total_vars = [];
    for j = 1:num_phases
        total_states = vertcat(total_states,model_output(j).statevalues);
        total_vars = vertcat(total_vars,model_output(j).variablevalues);
    end

    for i = 1:num_states
        figure
        plot(time_points,total_states(:,i));
        title(state_names(i));
    end
end
        