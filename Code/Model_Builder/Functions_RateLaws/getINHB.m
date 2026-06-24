function dependentReaction = getINHB(dependentReaction)
    reaction_rate = dependentReaction.reaction_rate;
    reactants = dependentReaction.reaction_reactants;
    products = dependentReaction.reaction_products;
    catalyst = dependentReaction.reaction_catalysts;
    secondary_catalyst = dependentReaction.secondary_catalyst;
    
    if(ismissing(reactants))
        reactants = [];
    end
    if(ismissing(products))
        products = [];
    end
    if(ismissing(catalyst))
        catalyst = [];
    end
    
    parameters = [];
    
    param_alpha = strcat('alpha_',reaction_rate);

    for i = 1:length(reactants)
        param_alpha = strcat(param_alpha,'_',reactants(i));
    end
    for j = 1:length(products)
        param_alpha = strcat(param_alpha,'_',products(j));
    end
    
    param_alpha = strcat(param_alpha,'_',catalyst,'_',secondary_catalyst);
    parameters = vertcat(parameters,param_alpha);

    reaction_ODE = strcat('(1 / (1 +',param_alpha,' *',secondary_catalyst,'))'); 

    dependentReaction.reaction_ODE = reaction_ODE;
    dependentReaction.reaction_parameters = parameters;
end