%% Function that tests the response of the model to perturbation. 
% Returns TRUE if the model response beyond pert_tol.

function result = responseToPerturbationDRUGS(model_output, drug_target_index, data_phase, drug_stim_tol, abs_tol)
   
  temp_values = horzcat(model_output(data_phase).statevalues(:,drug_target_index));
   
   y_max = max(temp_values,[],1);
   y_min = min(temp_values,[],1);
   y_diff = abs(y_max - y_min);
  
   num_below_abs_tol = sum(y_diff < abs_tol);

   num_unresponsive = sum((y_diff ./ y_max) <= drug_stim_tol);

   if(any(num_unresponsive) || any(num_below_abs_tol))
       result = false;
   else
       result = true;
   end
end