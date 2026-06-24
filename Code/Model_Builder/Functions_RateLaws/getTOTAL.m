function newReaction = getTOTAL(newReaction)
    reactants = newReaction.reaction_reactants;
    variable = newReaction.reaction_variable;

    reaction = [];
    num_reactants = length(reactants);
    parameters = [];
    
    
    for k = 1:num_reactants
        if(k == 1)
            reaction = strcat(reactants(k));
        else
            reaction = strcat(reaction," +",reactants(k));
        end
    end
    
    variable_reaction = strcat(variable," =", reaction);

    newReaction.reaction = variable_reaction;
    newReaction.reaction_parameters = parameters;
end