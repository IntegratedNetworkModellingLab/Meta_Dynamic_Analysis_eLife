function forward_text = determineTotalDepReactionText(reaction_array)
    num_reactions = size(reaction_array,1);
    
    for i = 1:length(reaction_array)
        pat = " *(";
        base_reaction = extractBefore(reaction_array(i),pat);
        if(ismissing(base_reaction))
            base_reaction = reaction_array(i);
        end
        base_reaction = erase(base_reaction, "(");
        base_reaction = erase(base_reaction, ")");
        base_reactions(i,1) = base_reaction;
    end

    [reactions,ia,ic] = unique(base_reactions,'rows');
    num_reactions = accumarray(ic,1);
    multi_reaction_idx = num_reactions > 1;
    num_multi = sum(multi_reaction_idx);
    multi_reaction_loc = find(multi_reaction_idx);
    
    iter = 0;

    % First extract all promotion reactions.
    while(~isempty(base_reactions))
        iter = iter + 1;
        temp_reaction_group = base_reactions(1);
        same_base_idx = strcmp(base_reactions,temp_reaction_group);
        temp_reaction_array = reaction_array(same_base_idx);
        if(length(temp_reaction_array) > 1)
            num_prom_found = 0;
            num_inhb_found = 0;
            prom_list = strings(0);
            inhb_list = strings(0);
            num_indi_reactions = length(temp_reaction_array);
            for i = 1:num_indi_reactions
                temp_str = [];
                temp_reaction = temp_reaction_array(i);
                reg_pat = regexpPattern('\(1 / \(1 [+]\w* [*]\w*\)\)');
                temp_str = extract(temp_reaction, reg_pat);
                if(~isempty(temp_str))
                    num_inhb_found = num_inhb_found + 1;
                    reg_pat = regexpPattern('\w* [*]\w*');
                    inhb_list(num_inhb_found,1) = extract(temp_str, reg_pat);
                else
                    reg_pat = regexpPattern('\(1 [+]\w* [*]\w*\)');
                    temp_str = extract(temp_reaction, reg_pat);
                    if(~isempty(temp_str))
                        num_prom_found = num_prom_found + 1;
                        reg_pat = regexpPattern('\w* [*]\w*');
                        prom_list(num_prom_found,1) = extract(temp_str, reg_pat);
                    end
                end
            end
            
            base_prom = "(1 +";
            if(~isempty(prom_list))
                for j = 1:length(prom_list)
                    if(j == length(prom_list))
                        base_prom = strcat(base_prom,prom_list(j),")");
                    else
                        base_prom = strcat(base_prom,prom_list(j), " +");
                    end
                end
            end
            
            if(~isempty(inhb_list))
            base_inhb = "(1 +";
                for j = 1:length(inhb_list)
                    if(j == length(inhb_list))
                        base_inhb = strcat(base_inhb,inhb_list(j),")");
                    else
                        base_inhb = strcat(base_inhb,inhb_list(j), " +");
                    end
                end
            end
          
            if(isempty(prom_list))
                temp_forward_text(iter) = strcat("((",base_reaction,") /",base_inhb,")");
            elseif(isempty(inhb_list))
                temp_forward_text(iter) = strcat("((",base_reaction,") *",base_prom,")");
            else
                temp_forward_text(iter) = strcat("((",base_reaction,") *",base_prom, " /",base_inhb,")");
            end

        else
            temp_forward_text(iter,1) = strcat("(",temp_reaction_array,")");
        end
        base_reactions(same_base_idx) = [];
        reaction_array(same_base_idx) = [];
    end
    
    forward_text = 'vf = ';
    for pp = 1:length(temp_forward_text)
        forward_text = strcat(forward_text,temp_forward_text(pp));
        if(pp < length(temp_forward_text))
            forward_text = strcat(forward_text, ' +');
        end
    end

end