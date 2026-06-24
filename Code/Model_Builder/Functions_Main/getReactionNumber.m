function [reaction_number,unique_flag,reactionStruct] = getReactionNumber(newReaction,reactionStruct)
    reaction_temp = newReaction.reaction_formula;
    unique_flag = 1;
    
    if(isempty(reactionStruct))
        reaction_number = 1;
        reactionStruct.Parameters = [];
        reactionStruct.StateVariables = [];
    else
        num_reactions = size(reactionStruct.Reactions,2);
        
        found_flag = 0;
        for i = 1:num_reactions
            found_flag = strcmp(reaction_temp,reactionStruct.Reactions(i).ReactionFormula);
            if(found_flag)
                reaction_number = i;
                unique_flag = 0;
                break;
            end
        end
        
        if(~found_flag)
            reaction_number = num_reactions + 1;
        end
    end

end