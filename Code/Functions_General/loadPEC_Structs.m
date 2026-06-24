function PEC_Struct = loadPEC_Structs(unique_ID, calibration_protocol, calibration_variables)
    % Load in PropStruct
    try
        filename_prop = sprintf("%s_PropStruct.mat",unique_ID);
        PropStruct = loadFile(filename_prop);
    catch
        error("Couldn't find property struct. Exiting script.")
    end

    % Load in Experiments
    try
        filename_experiments = sprintf("%s_Experiments.mat",unique_ID);
        Experiments = loadFile(filename_experiments);
    catch
        error("Couldn't find experiment struct. Exiting script.");
    end

    % Load in CalibStruct
    temp_filename_protocol = sprintf("%s_%s_%s_CalibStruct.mat",unique_ID,calibration_protocol,calibration_variables);
    filename_protocol = fullfile(pwd,"Files\Model_Instances",unique_ID,"Calibration_Outputs",...
        calibration_protocol,calibration_variables,temp_filename_protocol);
    
    try
        CalibStruct = loadFile(filename_protocol);
    catch
        error("Couldn't find existing protocol struct. Exiting Script")
    end

    PEC_Struct.PropStruct = PropStruct;
    PEC_Struct.Experiments = Experiments;
    PEC_Struct.CalibStruct = CalibStruct;
end