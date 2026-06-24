%% Function that tests the response of the model to perturbation. 
% Returns TRUE if the model response beyond pert_tol.

function result = responseToPerturbationABS(model_output, pert_tol,abs_tol, min_responsive)
   num_phases = size(model_output,2);
   temp_values = [];
   for i = 1:num_phases  
       temp_temp_values = model_output(i).statevalues;
       temp_values = vertcat(temp_values,temp_temp_values);
   end
   
   y_max = max(temp_values,[],1);
   y_min = min(temp_values,[],1);
   y_diff = abs(y_max - y_min);
   
   num_below_abs_tol = sum(y_diff <= abs_tol);

   num_unresponsive = sum((y_diff ./ y_max) < pert_tol);

   if(num_unresponsive > min_responsive || num_below_abs_tol > min_responsive)
       result = false;
   else
       result = true;
   end
end