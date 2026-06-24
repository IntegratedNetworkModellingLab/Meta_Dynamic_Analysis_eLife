function newReaction = getCONST(newReaction)
    variable = newReaction.reaction_variable;
    parameters = strcat('const_',variable);

    variable_reaction = strcat(variable," =", parameters);

    newReaction.reaction = variable_reaction;
    newReaction.reaction_parameters = parameters;
end