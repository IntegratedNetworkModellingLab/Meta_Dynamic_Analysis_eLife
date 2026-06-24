function newReaction = getADD(newReaction)
    reactants = newReaction.reaction_reactants;
    variable = newReaction.reaction_variable;

    reaction = [];
    num_reactants = length(reactants);
    parameters = [];
    
    
    for k = 1:num_reactants
        param = "alpha";
        if(k == num_reactants)
            param = strcat(param,'_',reactants(k));
            reaction = strcat(reaction,param," *",reactants(k));
            parameters = vertcat(parameters,param);
        else
            param = strcat(param,'_',reactants(k));
            reaction = strcat(reaction,param," *",reactants(k)," +");
            parameters = vertcat(parameters,param);
        end
    end
    
    variable_reaction = strcat(variable," =", reaction);

    newReaction.reaction = variable_reaction;
    newReaction.reaction_parameters = parameters;
end