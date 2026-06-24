function plotMDNStruct_QBD_DATA(MDNStruct,plot_data,param_or_state,rep)
    switch plot_data
        case 'QBD'
            switch param_or_state
                case "PS"
                    QBD_percent = MDNStruct.PS_Variation(rep).QBD_Percentage';
                case "SV"
                    QBD_percent = MDNStruct.IC_Variation(rep).QBD_Percentage';
                otherwise
            end
        case 'Error'
            QBD_percent = MDNStruct.QBD_StdDev';
        otherwise
    end
    colorMapMatrix = setColorMap("natureBlueWhiteRedMap");
    behaviour_names = MDNStruct.Behaviours;
    num_states = length(MDNStruct.Properties.StateNames);
    variable_names = MDNStruct.Properties.DataVariables;
    data_var_idx = MDNStruct.Properties.DataVariableIDX;
    num_states_vars = size(QBD_percent,1);
    states_vars_idx = zeros(1,num_states_vars);
    states_vars_idx(1,num_states+1:end) = data_var_idx;
    states_vars_idx = logical(states_vars_idx);

    h = heatmap(behaviour_names,variable_names,QBD_percent(states_vars_idx,:),'Colormap', colorMapMatrix);
    h.Title = 'Qualitative Behaviour Distribution';
    h.YLabel = 'Protein States';
    h.XLabel = 'Behaviours';
    h.ColorScaling = 'log';
    h.Position = [0.1300 0.1100 0.35 0.70];
end