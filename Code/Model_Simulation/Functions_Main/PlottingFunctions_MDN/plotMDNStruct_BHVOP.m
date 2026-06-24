function plotMDNStruct_BHVOP(MDNStruct,output_protein,behaviour,num_plots)
    
    model_state_names = MDNStruct.Properties.StateNames;
    protein_index = find(ismember(model_state_names,output_protein)); 

    filter_index = ismember(MDNStruct.QBD(:,protein_index),behaviour);
    total_PS = table2array(MDNStruct.FunctionalPS);
    filtered_PS = total_PS(filter_index,:);
    num_PS = size(filtered_PS,1);

    num_test_PS = num_plots;
    PS_rand_loc = randperm(num_PS,num_test_PS);
    rand_PS_array = filtered_PS(PS_rand_loc,:);

    data_phase = MDNStruct.Sim.DataPhase;
    log_time_index = MDNStruct.Sim.Phases(data_phase).Log10TimeIndex;
    time_points = 1:3000;
    time_points = time_points(log_time_index);
    
    figure
    for i = 1:num_plots
        temp_PS = rand_PS_array(i,:);
        model_output = simulateModelInstance_STIFF(MDNStruct,temp_PS);
        temp_protein_plot = model_output(data_phase).statevalues(log_time_index,protein_index);
        protein_plot(i,:) = temp_protein_plot;
%         norm_protein_plot(i,:) = temp_protein_plot ./ ((max(temp_protein_plot) - min(temp_protein_plot)) / 2);
%         norm_protein_plot(i,:) = temp_protein_plot ./ temp_protein_plot(1,1);
        norm_protein_plot(i,:) = temp_protein_plot ./ max(temp_protein_plot);
        hold on
        plot(time_points,norm_protein_plot(i,:));
    end
    hold off
    title(output_protein);
    xlabel('Time (minutes)')
    ylabel('Fold Change')
end


