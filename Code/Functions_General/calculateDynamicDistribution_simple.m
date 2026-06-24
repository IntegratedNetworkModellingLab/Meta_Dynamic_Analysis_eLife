function QBD_percentage = calculateDynamicDistribution_simple(QBD_array)
    QBD_num_sets = size(QBD_array,1);
    QBD_num_states = size(QBD_array,2);
    QBD = zeros(7,QBD_num_states);
    
    for mm = 1:QBD_num_states
        QBD(1,mm) = (sum(ismember(QBD_array(:,mm),'INC')) / QBD_num_sets) * 100;
        QBD(2,mm) = (sum(ismember(QBD_array(:,mm),'DEC')) / QBD_num_sets) * 100;
        QBD(3,mm) = (sum(ismember(QBD_array(:,mm),'BIP')) / QBD_num_sets) * 100;
        QBD(4,mm) = (sum(ismember(QBD_array(:,mm),'REB')) / QBD_num_sets) * 100;
        QBD(5,mm) = (sum(ismember(QBD_array(:,mm),'NRP')) / QBD_num_sets) * 100;
        QBD(6,mm) = (sum(ismember(QBD_array(:,mm),'NRPABS')) / QBD_num_sets) * 100;
        QBD(7,mm) = (sum(ismember(QBD_array(:,mm),'ETC')) / QBD_num_sets) * 100;
    end

    QBD_percentage = QBD(:,:);

end

