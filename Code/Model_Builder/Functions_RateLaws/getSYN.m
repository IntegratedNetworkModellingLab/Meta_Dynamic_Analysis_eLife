function newReaction = getSYN(newReaction)
    product = newReaction.reaction_products;
    catalyst = newReaction.reaction_catalysts;
    parameters = [];

    if(ismissing(catalyst))
        reaction = strcat("=>",product);
        param_ksyn = strcat('ksyn_',product);
        parameters = vertcat(parameters,param_ksyn);
        reaction_ODE = strcat('(',param_ksyn,')'); 
    else
        % Should change this ksyn to ksync i.e. catalysed synthesis.
        reaction = strcat("=>",product);    
        param_ksyn = strcat('ksyn_',catalyst,'_',product);
        parameters = vertcat(parameters,param_ksyn);
        param_Km = strcat('Km_',catalyst,'_',product);
        parameters = vertcat(parameters,param_Km);
        reaction_ODE = strcat('((',param_ksyn,' *',catalyst,') / (',param_Km,' +',catalyst,'))');
    end

    newReaction.reaction_formula = reaction;
    newReaction.reaction_ODE = reaction_ODE;
    newReaction.reaction_parameters = parameters;
end