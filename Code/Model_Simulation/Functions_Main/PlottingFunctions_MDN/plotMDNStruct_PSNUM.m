function plotMDNStruct_PSNUM(ModelStruct,num_PS)
    state_names = ModelStruct.Properties.StateNames;
    num_states = length(state_names);
    variable_names = ModelStruct.Properties.VariableNames;
    num_vars = length(variable_names);
    data_var_idx = ModelStruct.Properties.DataVariableIDX;
    data_names = ModelStruct.Properties.DataVariables;
    
    parameter_sets = table2array(ModelStruct.PS_Variation.FunctionalPS);
    model_output = simulateModelInstance_STIFF(ModelStruct,parameter_sets(num_PS,:));
    
    num_phases = length(model_output);
    total_states = [];
    total_vars = [];
    for j = 1:num_phases
        total_states = vertcat(total_states,model_output(j).statevalues);
        total_vars = vertcat(total_vars,model_output(j).variablevalues);
    end
    
    total_data = total_vars(:,data_var_idx);
    num_data = size(total_data,2);

    m = ceil(sqrt(num_states));
    n = ceil(sqrt(num_vars));
    o = ceil(sqrt(num_data));

    time_points = 1:size(total_states,1);

    figure
    title("STATES")
    for i = 1:num_states
        subplot(m,m,i), plot(time_points,total_states(:,i));
        subtitle(state_names(i));
    end


    figure
    title("VARIABLES")
    for i = 1:num_vars
        subplot(n,n,i), plot(time_points,total_vars(:,i));
        subtitle(variable_names(i));
    end

    figure
    title("DATA")
    for i = 1:num_data
        subplot(o,o,i), plot(time_points,total_data(:,i));
        subtitle(data_names(i));
    end


end