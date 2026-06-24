function reactionStruct = addNewIndependentReaction(newReaction,reactionStruct)

    newReaction = getIndependentReactionFormulas(newReaction);
    
    [reaction_number,unique_flag,reactionStruct] =getReactionNumber(newReaction,reactionStruct);
    
    if(unique_flag)
        reactionStruct.Reactions(reaction_number).ReactionNumber = reaction_number;
        reactionStruct.Reactions(reaction_number).ReactionFormula = newReaction.reaction_formula;
        reactionStruct.Reactions(reaction_number).ReactionODE = newReaction.reaction_ODE;
    else
        reactionStruct.Reactions(reaction_number).ReactionNumber = reaction_number;
        reactionStruct.Reactions(reaction_number).ReactionFormula = newReaction.reaction_formula;
        reactionStruct.Reactions(reaction_number).ReactionODE = ...
            vertcat(reactionStruct.Reactions(reaction_number).ReactionODE,newReaction.reaction_ODE);
    end


    reactionStruct.Parameters = ...
        vertcat(reactionStruct.Parameters,newReaction.reaction_parameters);
    reactionStruct.Parameters = unique(reactionStruct.Parameters,"stable");
    reactionStruct.Parameters(ismissing(reactionStruct.Parameters)) = [];

    reactionStruct.StateVariables = vertcat(reactionStruct.StateVariables,...
        newReaction.reaction_reactants,newReaction.reaction_products,newReaction.reaction_catalysts);
    reactionStruct.StateVariables = unique(reactionStruct.StateVariables,"stable");
    reactionStruct.StateVariables(ismissing(reactionStruct.StateVariables)) = [];
    reactionStruct.StateVariables(reactionStruct.StateVariables == "") = [];
end