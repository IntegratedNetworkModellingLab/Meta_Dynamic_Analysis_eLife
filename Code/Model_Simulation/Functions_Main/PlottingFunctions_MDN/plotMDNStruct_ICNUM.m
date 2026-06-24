function plotMDNStruct_ICNUM(ModelStruct,num_IC, state_idx)
    state_names = ModelStruct.StateNames;
    % num_states = length(state_names);
        
    IC_sets = table2array(ModelStruct.IC_Variation.FunctionalICs);
    num_sets = size(IC_sets,1);
    
    param_set = ModelStruct.IC_Variation.PS;
    
    figure
    hold on
    for i = 1:num_IC
        rand_IC = randi(num_sets);
        IC_set = IC_sets(rand_IC,:);
        model_output = simulateModelInstance_STIFF(ModelStruct,param_set, IC_set);
        
        total_states = [];
        num_phases = length(model_output);
        for ii = 2
            total_states = vertcat(total_states,model_output(ii).statevalues);
        end

        time_points = 1:size(total_states,1);
        state_values = total_states(:,state_idx);
        norm_values = state_values ./ mean(state_values);
        
        plot(time_points(1:200),state_values(1:200), LineWidth=3);
        ax = gca;
        ax.FontSize = 10;
        ax.FontName = "Arial";
        ax.LineWidth = 2;
        


        % ylim([0 1])
        
        
    end


end