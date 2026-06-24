function QBD_percentage = calculateDynamicDistribution(QBD_array)
    QBD_num_sets = size(QBD_array,1);
    QBD_num_states = size(QBD_array,2);
    QBD = zeros(8,QBD_num_states);
    
    for mm = 1:QBD_num_states
        QBD(1,mm) = (sum(ismember(QBD_array(:,mm),'INC-S')) / QBD_num_sets) * 100;
        QBD(2,mm) = (sum(ismember(QBD_array(:,mm),'INC-W')) / QBD_num_sets) * 100;
        QBD(3,mm) = (sum(ismember(QBD_array(:,mm),'DEC-S')) / QBD_num_sets) * 100;
        QBD(4,mm) = (sum(ismember(QBD_array(:,mm),'DEC-W')) / QBD_num_sets) * 100;
        QBD(5,mm) = (sum(ismember(QBD_array(:,mm),'BIP-S')) / QBD_num_sets) * 100;
        QBD(6,mm) = (sum(ismember(QBD_array(:,mm),'BIP-W')) / QBD_num_sets) * 100;
        QBD(7,mm) = (sum(ismember(QBD_array(:,mm),'REB-S')) / QBD_num_sets) * 100;
        QBD(8,mm) = (sum(ismember(QBD_array(:,mm),'REB-W')) / QBD_num_sets) * 100;
        QBD(9,mm) = (sum(ismember(QBD_array(:,mm),'OSC-S')) / QBD_num_sets) * 100;
        QBD(10,mm) = (sum(ismember(QBD_array(:,mm),'OSC-W')) / QBD_num_sets) * 100;
        QBD(11,mm) = (sum(ismember(QBD_array(:,mm),'NRP')) / QBD_num_sets) * 100;
        QBD(12,mm) = (sum(ismember(QBD_array(:,mm),'NRPABS')) / QBD_num_sets) * 100;
        QBD(13,mm) = (sum(ismember(QBD_array(:,mm),'ETC')) / QBD_num_sets) * 100;
    end

    QBD_percentage = QBD(:,:);

end

