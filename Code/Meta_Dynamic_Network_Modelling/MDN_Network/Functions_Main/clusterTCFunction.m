function [Clusters, T, clust_gram] = clusterTCFunction(MDNStruct,array, tree_level,display_range)
    
    tmp_TC_array = array;
    numSets = length(tmp_TC_array(:,1));
    
    data_phase = MDNStruct.Simulation.DataPhase;
    drug_time_plot_log = MDNStruct.Simulation.Phases(data_phase).Log10TimeIndex;
    color_matrix = setColorMap("natureBlueWhiteRedMap");

    clust_gram = clustergram(tmp_TC_array,'standardize','none',...
        'Cluster','Column',...
        'ColumnPdist', 'euclidean',...
        'Colormap',color_matrix,...
        'DisplayRange',display_range,...
        'DisplayRatio',[0.02 0.2]);
    
%     cgAxes = plot(clust_gram);
%     set(cgAxes,'Clim',[0,1]);
%     colormap colorMap;
        
    clust_gram.ColumnLabels = drug_time_plot_log;
    clust_gram.RowLabels = {};
    addXLabel(clust_gram,'Time (Minutes)','FontSize',12);
    addYLabel(clust_gram,strcat('Models(n = ',num2str(numSets),')'),'FontSize',12);
    clust_gram.ColumnLabelsRotate = 45;
    

    
    figure('Position',[680   788   560   190])
    tree = linkage(tmp_TC_array,'complete');
    % T = cluster(tree,'maxclust',20);
    % dendrogram(tree);
    % determine the level of hierarchy (num of clusters)
    lvl = tree_level;

    [H,T,outperm] = dendrogram(tree,lvl,'ColorThreshold',...
        (max(tree(end-2,3))));
    % H : Handles to lines
    % T : Leaf node numbers
    xtickangle(45)
    xlabel(strcat('Outperform groups (n=',num2str(lvl),')'))
    ylabel('Linkage')
    title('Dendrogram')
    set(gca,'FontSize',10)

    if lvl == 0
        set(gca,'XTick',{})
        set(gca,'XTickLabel',{})
    else
        title(strcat('outperm = ',num2str(lvl)))
    end
    
    Clusters = struct;
    for ii = 1:lvl
        clust_loc = ismember(T,ii);
        Clusters(ii).Cluster = array(clust_loc,:);
    end
end