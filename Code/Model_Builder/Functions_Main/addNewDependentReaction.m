function reactionStruct = addNewDependentReaction(newReaction,reactionStruct)

    independentReaction = getIndependentReactionFormulas(newReaction);
    dependentReaction = getDependentReactionFormulas(newReaction);
    
    [reaction_number,~,reactionStruct] =getReactionNumber(independentReaction,reactionStruct);

    ind_reaction_formula = independentReaction.reaction_ODE;
    dependent_reaction_formula = dependentReaction.reaction_ODE;
    found_flag = 0;

    for i = 1:length(reactionStruct.Reactions(reaction_number).ReactionODE)
        found_flag =  strcmp(reactionStruct.Reactions(reaction_number).ReactionODE(i),ind_reaction_formula)...
            | contains(reactionStruct.Reactions(reaction_number).ReactionODE(i),ind_reaction_formula);
        if(found_flag)
            new_formula = strcat('(',independentReaction.reaction_ODE,...
                ' *',dependent_reaction_formula,')');
            if(strcmp(reactionStruct.Reactions(reaction_number).ReactionODE(i),ind_reaction_formula))
                reactionStruct.Reactions(reaction_number).ReactionODE(i) = new_formula;
                break;
            else
                reactionStruct.Reactions(reaction_number).ReactionODE = ...
                    vertcat(reactionStruct.Reactions(reaction_number).ReactionODE,new_formula);
                break;
            end
        end
    end

    reactionStruct.Parameters = ...
        vertcat(reactionStruct.Parameters,dependentReaction.reaction_parameters);
    reactionStruct.Parameters = unique(reactionStruct.Parameters,"stable");
    reactionStruct.Parameters(ismissing(reactionStruct.Parameters)) = [];

    reactionStruct.StateVariables = vertcat(reactionStruct.StateVariables,...
        dependentReaction.reaction_reactants,dependentReaction.reaction_products,dependentReaction.reaction_catalysts);
    reactionStruct.StateVariables = unique(reactionStruct.StateVariables,"stable");
    reactionStruct.StateVariables(ismissing(reactionStruct.StateVariables)) = [];
    reactionStruct.StateVariables(reactionStruct.StateVariables == "") = [];
end