%% Function that tests to see if the model has achieved a steady state at test_time.
% Returns TRUE if the steady state is less than ss_tol.

function result = steadyStateAchieved(model_output, zero_tol, ss_tol)
    num_phases = size(model_output,2);
    for i = 1:(num_phases-1)    
        temp_values = horzcat(model_output(i).statevalues, model_output(i).variablevalues);
        y_end = abs(temp_values(end-1,:));
        y_end_100 = abs(temp_values(end-100,:));
        %y_diff = abs(y_end - y_end_100);
        y_diff = abs((y_end - y_end_100) ./ y_end_100);
        y_ss_tol_idx = y_diff > ss_tol;
        %y_ss = (y_diff)./ ((y_end + y_end_100)/2);
        y_zero_idx = not((y_end < zero_tol) .* (y_end_100 < zero_tol));
        %y_ss_tol_idx = y_ss > ss_tol;
        
        if(any(y_zero_idx .* y_ss_tol_idx))
            result = false;
            return;
        end
    end
    result = true;
end