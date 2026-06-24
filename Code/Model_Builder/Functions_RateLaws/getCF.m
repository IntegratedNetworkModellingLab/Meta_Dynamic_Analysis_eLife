function newReaction = getCF(newReaction)
    reactants = newReaction.reaction_reactants;
    product = newReaction.reaction_products;

    reaction = [];
    num_reactants = length(reactants);
    parameters = [];
    param = "ka_";
    
    for k = 1:num_reactants
        if(k == num_reactants)
            param = strcat(param,reactants(k),"_",product);
            reaction = strcat(reaction,reactants(k));
        else
            param = strcat(param,reactants(k),"_");
            reaction = strcat(reaction,reactants(k)," +");
        end
    end
    
    reaction = strcat(reaction," => ", product);
    parameters = vertcat(parameters,param);
    
    reaction_ODE = strcat("(",param," *");
    for m = 1:num_reactants
        if(m == num_reactants)
            reaction_ODE = strcat(reaction_ODE,reactants(m),")");    
        else
            reaction_ODE = strcat(reaction_ODE,reactants(m)," *");
        end
    end
    
    newReaction.reaction_formula = reaction;
    newReaction.reaction_ODE = reaction_ODE;
    newReaction.reaction_parameters = parameters;
end