% This function calculates a ranking from biggest to smallest (descend).
% For smallest to biggest need to switch to +Inf.
function rank_array = calculateRank(unsorted_array, direction)
    if nargin < 2
        direction = 'descend';
    end

    num_array = length(unsorted_array);
    if strcmp(direction,'ascend')
        rank_array = ones(num_array,1) * Inf;
    elseif strcmp(direction,'descend')
        rank_array = ones(num_array,1) * -Inf;
    end
    %[~,sort_IDX] = sort(unsorted_array,'descend','MissingPlacement','last');
    %unique_values = unique(unsorted_array);
    % Check for unique values.
    %num_unique = length(unique_values);
    num_to_evaluate = num_array;
    nan_idx = isnan(unsorted_array);
    num_nan = sum(nan_idx);
    num_to_evaluate = num_to_evaluate - num_nan;
    if strcmp(direction,'ascend')
        unsorted_array(isnan(unsorted_array)) = Inf;
    else
        unsorted_array(isnan(unsorted_array)) = -Inf;
    end
    
    rank = 1; 
    while(num_to_evaluate > 0)
        if strcmp(direction,'ascend')
            min_val = min(unsorted_array);
            min_idx = ismember(unsorted_array,min_val);
            num_eval = sum(min_idx);
            num_to_evaluate = num_to_evaluate - num_eval;
            rank_array(min_idx) = rank;
            unsorted_array(min_idx) = Inf;
        elseif strcmp(direction,'descend')
            
            max_val = max(unsorted_array);
            max_idx = ismember(unsorted_array,max_val);
            num_eval = sum(max_idx);
            num_to_evaluate = num_to_evaluate - num_eval;
            rank_array(max_idx) = rank;
            unsorted_array(max_idx) = -Inf;
        end
        rank = rank+1;
    end
    % if(num_array ~= num_unique)
    %     rank = 1;
    %     while(num_to_evaluate > 0)
    %         max_val = max(unsorted_array);
    %         max_idx = ismember(unsorted_array,max_val);
    %         num_eval = sum(max_idx);
    %         num_to_evaluate = num_to_evaluate - num_eval;
    %         rank_array(max_idx) = rank;
    %         unsorted_array(max_idx) = -Inf;
    %         rank = rank+1;
    %     end
    % else
    %     for i = 1:num_array
    %         rank_idx = sort_IDX(i);
    %         rank_array(rank_idx) = i;
    %     end
    % end

    
end