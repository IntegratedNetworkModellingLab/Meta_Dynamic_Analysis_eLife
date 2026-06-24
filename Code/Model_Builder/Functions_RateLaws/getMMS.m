function newReaction = getMMS(newReaction)
    reactant = newReaction.reaction_reactants;
    product = newReaction.reaction_products;
    catalyst = newReaction.reaction_catalysts;
    parameters = [];

    if(ismissing(catalyst))
        reaction = strcat(reactant,"=>",product);
        param_Vm = strcat('Vm_',reactant,'_',product);
        parameters = vertcat(parameters,param_Vm);
        reaction_ODE = strcat('(',param_Vm,' *',reactant,')'); 
    else
        reaction = strcat(reactant,"=>",product);    
        param_kc = strcat('kc_',catalyst,'_',reactant,'_',product);
        parameters = vertcat(parameters,param_kc);
        reaction_ODE = strcat('(',param_kc,' *',catalyst,' *',reactant,')');
    end

    newReaction.reaction_formula = reaction;
    newReaction.reaction_ODE = reaction_ODE;
    newReaction.reaction_parameters = parameters;
end