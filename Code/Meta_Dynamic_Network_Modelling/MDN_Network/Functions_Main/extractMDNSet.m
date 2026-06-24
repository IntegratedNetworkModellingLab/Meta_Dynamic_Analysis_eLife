function MDN_Set = extractMDNSet(MDNStruct,output_protein,behaviour,param_or_state,num_set)
    state_names = MDNStruct.Properties.StateNames;
    output_prot_index = ismember(state_names,output_protein);
    
    switch param_or_state
        case "PS"
            QBD = MDNStruct.PS_Variation(num_set).QBD;
            QBD_filtered = QBD(:,output_prot_index);
            behaviour_index = ismember(QBD_filtered,behaviour);
            MDN_Set = MDNStruct.PS_Variation(num_set).FunctionalPS(behaviour_index,:);
        case "SV"
            QBD = MDNStruct.IC_Variation(num_set).QBD;
            QBD_filtered = QBD(:,output_prot_index);
            behaviour_index = ismember(QBD_filtered,behaviour);
            MDN_Set = MDNStruct.IC_Variation(num_set).FunctionalICs(behaviour_index,:);
        otherwise
    end
end