%% Script for creating model simulation parameters.
function ModelStruct = setupSimulationParameters(ModelStruct,input_vector,time_vector,concentration_matrix,data_phase)
    % Stimulation parameters.
    ModelStruct.Simulation.StimulationParameters = input_vector;
    ModelStruct.Simulation.DataPhase = data_phase;
    ModelStruct.Simulation.TimeStep = 1.0;

    num_phases = length(time_vector);
    for i = 1:num_phases
        ModelStruct.Simulation.Phases(i).StimParamValues = concentration_matrix(i,:);
        ModelStruct.Simulation.Phases(i).Time = time_vector(i);
    end
    
    data_phase_time = ModelStruct.Simulation.Phases(data_phase).Time;
    log_time_index = unique(round(logspace(0,log10(data_phase_time),51)));
    ModelStruct.Simulation.Phases(data_phase).Log10TimeIndex = log_time_index;

end
