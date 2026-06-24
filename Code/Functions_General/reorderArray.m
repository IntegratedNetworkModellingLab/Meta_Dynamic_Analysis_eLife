function reordered_array = reorderArray(base_array,output_array)
    base_array = reshape(base_array,1,[]);
    output_array = reshape(output_array,1,[]);

    num_in_array = length(output_array);
    for i = 1:num_in_array
        index(i) = find(ismember(base_array,output_array(i)));
    end

    [~,sort_idx] = sort(index,2,'ascend');
    reordered_array = output_array(sort_idx);
   
end