function plotMDNStruct_QBD(MDNStruct,plot_data,param_or_state,rep)
    switch plot_data
        case 'QBD'
            switch param_or_state
                case "PS"
                    QBD_percent = MDNStruct.PS_Variation(rep).QBD_Percentage{:,:}';
                case "SV"
                    QBD_percent = MDNStruct.IC_Variation(rep).QBD_Percentage{:,:}';
                otherwise
            end
        case 'Error'
            QBD_percent = MDNStruct.QBD_StdDev';
        otherwise
    end
    colorMapMatrix = setColorMap("natureBlueWhiteRedMap");
    behaviour_names = MDNStruct.Behaviours;
    state_names = MDNStruct.StateNames;
    state_names = reshape(state_names,[],1);
    var_names = MDNStruct.VariableNames;
    var_names = reshape(var_names,[],1);
    label_names = vertcat(state_names,var_names);
    
    h = heatmap(behaviour_names,label_names,QBD_percent,'Colormap', colorMapMatrix);
    set(gcf,"units",'normalized','OuterPosition',[0 0 1 1]);
    h.Title = sprintf('Dynamic Category Distribution');
    h.YLabel = 'Protein States';
    h.XLabel = 'Behaviours';
    h.FontSize = 20;
    h.FontName = 'Arial';
    h.ColorScaling = 'log';
    h.GridVisible = 'off';
    
end