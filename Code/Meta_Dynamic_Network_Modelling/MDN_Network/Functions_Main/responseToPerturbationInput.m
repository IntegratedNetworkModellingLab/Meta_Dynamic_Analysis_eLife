%% Function that tests the response of the model to perturbation. 
% Returns TRUE if the model response beyond pert_tol.

function result = responseToPerturbationInput(model_output, input_state_locations, pert_tol, abs_tol)
    num_phases = size(model_output,2);
    num_inputs = length(input_state_locations);
    temp_values = [];
    responsive = zeros(num_phases-1,num_inputs);
    for i = 2:num_phases  
        temp_values = model_output(i).statevalues(:,input_state_locations);
        y_max = max(temp_values,[],1);
        y_min = min(temp_values,[],1);
        y_diff = abs(y_max - y_min);
        if(all(y_diff > abs_tol))
            y_percent = y_diff ./ temp_values(1,:);
            responsive(i-1,:) = y_percent > pert_tol;
        end
    end
    
    sum_responsive = sum(responsive,1);
    
    if(any(sum_responsive == 0))
        result = false;
    else
        result = true;
    end
end