function plotMDNStruct_QBD_2(QBD_percent, col_labels, row_labels)
    
    colorMapMatrix = setColorMap("natureBlueWhiteRedMap");
    % behaviour_names = MDNStruct.Behaviours;
    % state_names = MDNStruct.StateNames;
    % state_names = reshape(state_names,[],1);
    % var_names = MDNStruct.VariableNames;
    % var_names = reshape(var_names,[],1);
    % % label_names = vertcat(state_names,var_names);
    % label_names = var_names;
    
    h = heatmap(row_labels,col_labels,QBD_percent','Colormap', colorMapMatrix);
    set(gcf,"units",'normalized','OuterPosition',[0 0 1 1]);
    h.Interpreter = 'none';
    h.Title = sprintf('Dynamic Category Distribution');
    h.YLabel = 'Protein States';
    h.XLabel = 'Behaviours';
    h.FontSize = 20;
    h.FontName = 'Arial';
    h.ColorScaling = 'log';
    h.GridVisible = 'off';
    
end