%% Function takes in a model and determines if any of the output values are negative.

function result = anyNegativeValue(model_output, neg_tol)
    num_phases = size(model_output,2);
    for i = 1:num_phases
        temp_values = horzcat(model_output(i).statevalues, model_output(i).variablevalues);
        if(min(temp_values) < neg_tol)
            result = true;
            return; 
        end
    end
    result = false;
end