function ModelStruct = loadICs(ModelStruct,ID)
    IC_sheet = readcell('Cell_Line_ICs.xlsx');
    
    model_proteins = string(IC_sheet(2:end,1));
    num_proteins = length(model_proteins);

    cell_lines = string(IC_sheet(1,:));

    index = strcmp(cell_lines,ID);
    ICs = cell2mat(IC_sheet(2:end,index));

    state_names = ModelStruct.Properties.StateNames;
    num_states = length(state_names);
    IC_values = zeros(num_states,1);
    
    parameter_names = ModelStruct.Properties.ParameterNames;
    parameters = ModelStruct.Properties.ParameterValues;
    
    for i = 1:num_proteins
        protein_temp = model_proteins(i);

        index_protein = strcmp(state_names,protein_temp);
        IC_values(index_protein,1) = ICs(i);

        if(~any(index_protein))
            input_pat = sprintf('const_%s',protein_temp);
            index_param = contains(parameter_names,input_pat);
            parameters(index_param) = ICs(i);
        end

    end
    
    sim_time = 500;
    mex_options = ModelStruct.Properties.MexOptions;
    mex_options.maxnumsteps = 10000;

    mexHandle = ModelStruct.MEX_Handle;

    model_output = mexHandle(1:sim_time,IC_values,parameters,mex_options);

    new_ICs = model_output.statevalues(end,:);

    ModelStruct.Properties.StateICs = reshape(new_ICs,1,[]);
    ModelStruct.Properties.ParameterValues = parameters;
   
end