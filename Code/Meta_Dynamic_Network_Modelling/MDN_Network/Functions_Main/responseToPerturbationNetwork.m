%% Function that tests the response of the model to perturbation. 
% Returns TRUE if the model response beyond pert_tol.

function result = responseToPerturbationNetwork(model_output, pert_tol, abs_tol, max_unresponsive)
    num_phases = size(model_output,2);
    num_inputs = size(model_output(1).statevalues,2);
    temp_values = [];
    responsive = zeros(num_phases-1,num_inputs);
    for i = 2:num_phases  
        temp_values = model_output(i).statevalues;
        y_max = max(temp_values,[],1);
        y_min = min(temp_values,[],1);
        y_diff = abs(y_max - y_min);
        
        y_abs = y_diff > abs_tol;
        y_percent = (y_diff ./ temp_values(1,:)) > pert_tol;
        
        responsive(i-1,:) = y_abs .* y_percent;
    end
    
    sum_responsive = sum(responsive,1);

    num_responsive = sum(sum_responsive > 0);
    
    if(num_responsive < max_unresponsive)
        result = false;
    else
        result = true;
    end
end