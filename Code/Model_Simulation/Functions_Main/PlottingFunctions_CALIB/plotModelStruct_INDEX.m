function plotModelStruct_INDEX(ModelStruct)
    data_var_idx = ModelStruct.Calibration.CalibDataVariableIDX;
    data_names = ModelStruct.Calibration.CalibDataVariables;
    data_exp_idx = ismember(ModelStruct.Calibration.DataVariables,data_names);
    num_data = length(ModelStruct.Calibration.CalibDataVariables);
    num_exp = size(ModelStruct.Calibration.Experiments,2);
    ModelStruct.Calibration.CurrentPS = ModelStruct.Calibration.BestFitParamSet;

    for i = 1:num_exp
        exp_type = ModelStruct.Calibration.Experiments(i).ExpType;
        temp_dose_range = ModelStruct.Calibration.Experiments(i).Doses;
        data_time_points = ModelStruct.Calibration.Experiments(i).TimePoints;
        % No zero array entry, adjust to first time point.
        data_time_points(1) = 1;
        phase_data = ModelStruct.Sim.DataPhase;
        sim_time_points = 1:ModelStruct.Sim.Phases(phase_data).Time;
        time_idx = ismember(sim_time_points,data_time_points);

        temp_exp_data_mean = ModelStruct.Calibration.Experiments(i).DataMean{:,data_exp_idx};
        temp_mask_error = 0.2;

        switch exp_type
            case 'TimeCourse'
                model_output = simulateModelInstance_STIFF(ModelStruct,[]);
                temp_sim_data = model_output(phase_data).variablevalues(time_idx,data_var_idx);
                
                % Set the type of normalisation.
                protein_norm = "Average";
                
                switch protein_norm
                    case 'Initial'
                        temp_exp_val = temp_exp_data_mean(1,:);
                        temp_sim_val = temp_sim_data(1,:);
                        
                    case 'Max'
                        temp_exp_val = max(temp_exp_data_mean);
                        temp_sim_val = max(temp_sim_data);
                                        
                    case 'Average'
                        temp_exp_val = mean(temp_exp_data_mean,1);
                        temp_sim_val = mean(temp_sim_data);
                        
                    otherwise
                end
                % Normalise according to normalisation method selected.
                temp_exp_norm = temp_exp_data_mean ./ temp_exp_val;
                temp_exp_min_norm = temp_exp_norm - temp_mask_error;
                temp_exp_max_norm = temp_exp_norm + temp_mask_error;
                
                temp_sim_norm = temp_sim_data ./ temp_sim_val;
                
                figure
                m = ceil(sqrt(num_data));
                for ii = 1:num_data
                    subplot(m,m,ii)
                    hold on
                    plot(data_time_points,temp_exp_max_norm(:,ii),'Color','#FFE5D6','LineStyle','--','LineWidth',2)
                    plot(data_time_points,temp_exp_min_norm(:,ii),'Color','#FFE5D6','LineStyle','--','LineWidth',2)
                    plot(data_time_points,temp_sim_norm(:,ii),'Color','#0A2433','LineStyle',':','LineWidth',3)
                    hold off
                    pbaspect([4 3 1])
                    xlabel("Mins");
                    temp_y_label = sprintf('Fold Change (Norm. %s)', protein_norm);
                    ylabel(temp_y_label);
                    protein_name = data_names(ii);
                    title(protein_name,'Interpreter','none');
                end

            otherwise
        end
    end
end