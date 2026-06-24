function Experiments = loadExperimentalData(ID,data_file)
    
    filename = sprintf("%s_PropStruct.mat",ID);
    PropStruct = loadFile(filename);
    exp_contents = readcell(data_file);
    experiments = string(exp_contents(2:end,1));
    num_experiments = length(experiments);

    ID = string(exp_contents(2:end,2));
    treatments = string(exp_contents(2:end,3));
    exp_types = string(exp_contents(2:end,4));
    % Has to be str2num, str2double fails the conversion.
    exp_timepoints = exp_contents(2:end,5);
    exp_time_units = string(exp_contents(2:end,6));
    exp_num_timepoints = exp_contents(2:end,7);
    exp_doses = exp_contents(2:end,8);
    exp_dose_units = string(exp_contents(2:end,9));
    exp_num_doses = exp_contents(2:end,10);
    exp_model_inputs = exp_contents(2:end,11);
    exp_sim_time_vectors = exp_contents(2:end,12);
    exp_sim_conc_matrix = exp_contents(2:end,13);
    exp_data_phase = exp_contents(2:end,14);

    for i = 1:num_experiments 
        exp_num = experiments(i);
        data = readcell(data_file,'Sheet',exp_num);
        data_values = cell2mat(data(2:end,2:end));
        data_variable_names = string(data(1,2:end));
        num_data_variables = length(PropStruct.DataVariables);
    
        data_timepoints = unique(cell2mat(data(2:end,1)));
        num_timepoints = length(data_timepoints);
        % reads in data and matches it to the order the data variables appear in ModelStruct.Properties.DataVariables.
        for ii = 1:num_data_variables
            try
                data_index = strcmp(data_variable_names,PropStruct.DataVariables(ii));
                temp_mean_data(:,ii) = data_values(1:num_timepoints,data_index);
                temp_error_data(:,ii) = data_values((num_timepoints+1):end,data_index);
                temp_name(1,ii) = PropStruct.DataVariables(ii);
            catch
                disp('%s data variable not found.',PropStruct.DataVariables(ii))
                temp_mean_data(:,ii) = [];
                temp_error_data(:,ii) = [];
                temp_name(1,ii) = [];
            end
        end
        
        Experiments(i).DataMean = array2table(temp_mean_data,'VariableNames',temp_name);
        Experiments(i).DataError = array2table(temp_error_data,'VariableNames',temp_name);
        
        Experiments(i).ExpNum = exp_num;
        Experiments(i).ID = ID(i);
        Experiments(i).Treatment = treatments(i);
        Experiments(i).ExpType = exp_types(i);
        Experiments(i).TimePoints = str2num(exp_timepoints{i});
        Experiments(i).TimeUnits = exp_time_units(i);
        Experiments(i).NumTimePoints = exp_num_timepoints(i);
        Experiments(i).Doses = str2num(exp_doses{i});
        Experiments(i).DoseUnits = exp_dose_units(i);
        Experiments(i).NumDoses = exp_num_doses(i);

        %% Setup simulation parameters.
        input_vector = string(exp_model_inputs{i});
        input_vector = strsplit(input_vector,',');
        time_vector = [str2num(exp_sim_time_vectors{i})];
        concentration_matrix = [str2num(exp_sim_conc_matrix{i})]; 
        data_phase = exp_data_phase{i};
        
        % Stimulation parameters.
        Experiments(i).ExpSimParams.StimulationParameters = input_vector;
        Experiments(i).ExpSimParams.DataPhase = data_phase;
       
        num_phases = length(time_vector);
        for jj = 1:num_phases
            Experiments(i).ExpSimParams.Phases(jj).StimParamValues = concentration_matrix(jj,:);
            Experiments(i).ExpSimParams.Phases(jj).Time = time_vector(jj);
        end
        
        data_phase_time = Experiments(i).ExpSimParams.Phases(data_phase).Time;
        log_time_index = unique(round(logspace(0,log10(data_phase_time),51)));
        Experiments(i).ExpSimParams.Phases(data_phase).Log10TimeIndex = log_time_index;
        Experiments(i).J_Weights = ones(1,num_data_variables);

    end
end