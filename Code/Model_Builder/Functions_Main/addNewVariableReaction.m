function reactionStruct = addNewVariableReaction(newReaction,reactionStruct)

    newReaction = getVariableReactionFormulas(newReaction);
    
    variable_number = length(reactionStruct.Variables) + 1;
    reactionStruct.Variables(variable_number).Reaction = newReaction.reaction;

    reactionStruct.Parameters = ...
        vertcat(reactionStruct.Parameters,newReaction.reaction_parameters);
    reactionStruct.Parameters = unique(reactionStruct.Parameters,"stable");
    reactionStruct.Parameters(ismissing(reactionStruct.Parameters)) = [];
    
    % Remove variables from state_variable list.

    reactionStruct.StateVariables(strcmp(newReaction.reaction_variable, reactionStruct.StateVariables)) = [];

end