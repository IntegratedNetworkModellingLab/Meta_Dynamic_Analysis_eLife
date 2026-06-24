function QBR = assessDynamicCategory(drug_response_array)
    num_prot = length(drug_response_array(1,:));
    QBR_temp = strings(1,num_prot);
    min_tol = 1e-3;
    DR_array_temp = drug_response_array;
    
    for ii = 1:num_prot
        DR_norm_array = DR_array_temp(:,ii)/DR_array_temp(1,ii);
        steady_state = DR_array_temp(end,ii);
        steady_state_norm = DR_norm_array(end); % steady state
        array_max = max(DR_array_temp(:,ii));
        array_max_norm = max(DR_norm_array); % max
        array_min = min(DR_array_temp(:,ii));
        array_min_norm = min(DR_norm_array); % min
        rebound = steady_state - array_min + eps;
        rebound_norm = steady_state_norm - array_min_norm + eps; % reactivation
        drug_effect = DR_array_temp(1,ii) - array_min + eps;
        drug_effect_norm = 1 - array_min_norm + eps; % effect
        abs_conc_change = array_max - array_min;
        
        if(abs_conc_change <= min_tol)
            QBR_temp(1,ii) = 'NRPABS';
        else
            % At least 20% reduction (0.8) in concentration, no more than 10%
            % increase (1.1) and no more than 10% rebound (0.1)
            if((array_max_norm - steady_state_norm) >= 0.2 && array_max_norm <= 1.05 ...
                    && rebound_norm/drug_effect_norm <= 0.1)
                QBR_temp(1,ii) = 'DEC';

            % At least 20% increase (1.2) in concentration, no more than a 10%
            % decrease (0.9) and the steady state is within 10% of the maximum
            % (1.1)
            elseif((steady_state_norm - array_min_norm) > 0.2 && array_min_norm >= 0.95 ...
                    && array_max_norm/steady_state_norm <= 1.1)
                QBR_temp(1,ii) = 'INC';

            % Drug effect causes at least an initial 20% decrease (0.2) in
            % concentration and rebound recovery is at least 10% of the drug effect.
            elseif drug_effect_norm >= 0.2 && rebound_norm/drug_effect_norm >= 0.1
                QBR_temp(1,ii) = 'REB';

            % At least a 20% increase initially (1.2), final concentration reduced by at least 10%
            % (0.8)
            elseif array_max_norm >= 1.2 && steady_state_norm/array_max_norm < 0.9
                QBR_temp(1,ii) = 'BIP';

            % Concentration increased, at most, by 10% (1.1), concentration
            % decreased, at most, by 10% (0.9).
            elseif array_max_norm < 1.05 && array_min_norm > 0.95
                QBR_temp(1,ii) = 'NRP';
            else
                QBR_temp(1,ii) = 'ETC';
            end
        end
    end
    QBR(:,:) = QBR_temp(:,:);
end