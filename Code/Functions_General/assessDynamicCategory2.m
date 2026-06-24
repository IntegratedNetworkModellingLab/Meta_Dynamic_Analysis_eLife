function QBR = assessDynamicCategory2(drug_response_array)
    num_prot = length(drug_response_array(1,:));
    QBR_temp = strings(1,num_prot);
    min_tol = 1e-3;
    DR_array_temp = drug_response_array;
    
    for i = 1:num_prot
        DR_norm_array = DR_array_temp(:,i)/DR_array_temp(1,i);
        DR_norm_array(DR_norm_array < 1e-9) = 0;
        
        steady_state_norm = DR_norm_array(end); % steady state
        
        array_max = max(DR_array_temp(:,i));
        array_max_norm = max(DR_norm_array); % max
        array_min = min(DR_array_temp(:,i));
        array_min_norm = min(DR_norm_array); % min
        
        rebound_norm = steady_state_norm - array_min_norm; % reactivation
        biphasic_norm = array_max_norm - steady_state_norm;

        gradient_norm = gradient(DR_norm_array);
        gradient_norm(abs(gradient_norm) < 1e-6) = 0;
        change_array = sign(gradient_norm);
        change_array(change_array == 0) = [];
        diff_array = diff(change_array);
        num_osc = numel(find(diff_array));
        
%         num_zero_gradient = numel(find(diff(sign(gradient_norm))));
        
        abs_conc_change = array_max - array_min;
        
        if(abs_conc_change <= min_tol)
            QBR_temp(1,i) = 'NRPABS';
        else
            % Concentration increased, at most, by 5%, concentration
            % decreased, at most, by 5%.
            if(array_max_norm < 1.05 && array_min_norm > 0.95)
                QBR_temp(1,i) = 'NRP';

            % At least 5% reduction in concentration, no more than 5%
            % increase and no more than 5% rebound and final value must be
            % at least 5% lower than the initial value.
            elseif(array_max_norm < 1.05 && array_min_norm < 0.95 && steady_state_norm < 0.95 && rebound_norm < 0.05)
                if all(gradient_norm < 0)
                    QBR_temp(1,i) = 'DEC-S';
                else
                    QBR_temp(1,i) = 'DEC-W';
                end

            % At least 5% increase in concentration, no more than a 5%
            % decrease and the steady state is within 5% of the maximum and
            % the final value must be 5% higher than the initial value.
            elseif(array_max_norm > 1.05 && array_min_norm > 0.95 && steady_state_norm > 1.05 && biphasic_norm < 0.05)
                if all(gradient_norm > 0)
                    QBR_temp(1,i) = 'INC-S';
                else
                    QBR_temp(1,i) = 'INC-W';
                end

            % Drug effect causes at least an initial 20% decrease (0.2) in
            % concentration and rebound recovery is at least 10% of the drug effect.
            elseif(array_min_norm < 0.95 && rebound_norm > 0.05 && num_osc >= 1 && num_osc < 3)
                QBR_temp(1,i) = 'REB-S';

            elseif(array_min_norm < 0.95 && rebound_norm > 0 && num_osc >= 1 && num_osc < 3)
                QBR_temp(1,i) = 'REB-W';

            % At least a 20% increase initially (1.2), final concentration reduced by at least 10%
            % (0.8)
            elseif(array_max_norm > 1.05 && biphasic_norm > 0.05 && num_osc >= 1 && num_osc < 3)
                QBR_temp(1,i) = 'BIP-S';

            elseif(array_max_norm > 1.05 && biphasic_norm > 0 && num_osc >= 1 && num_osc < 3)
                QBR_temp(1,i) = 'BIP-W';
            
            elseif(num_osc >= 2)
                if(num_osc >= 3)
                    QBR_temp(1,i) = 'OSC-S';
                else
                    QBR_temp(1,i) = 'OSC-W';
                end

            else
                QBR_temp(1,i) = 'ETC';
            end
        end
    end
    QBR(:,:) = QBR_temp(:,:);
end