function newReaction = getCD(newReaction)
    reactant = newReaction.reaction_reactants;
    products = newReaction.reaction_products;

    reaction = [];
    num_products = length(products);
    num_reactants = length(reactant);
    parameters = [];
    param = strcat("kd_",reactant,"_");
    
    for k = 1:num_products
        if(k == num_products)
            param = strcat(param,products(k));
            reaction = strcat(reaction,products(k));
        else
            param = strcat(param,products(k),"_");
            reaction = strcat(reaction,products(k)," +");
        end
    end
    
    reaction = strcat(reactant, " => ", reaction);
    parameters = vertcat(parameters,param);
    
    reaction_ODE = strcat("(",param," *");
    for m = 1:num_reactants
        if(m == num_reactants)
            reaction_ODE = strcat(reaction_ODE,reactant(m),")");    
        else
            reaction_ODE = strcat(reaction_ODE,reactant(m)," *");
        end
    end
    
    newReaction.reaction_formula = reaction;
    newReaction.reaction_ODE = reaction_ODE;
    newReaction.reaction_parameters = parameters;
end