function newReaction = getDEG(newReaction)
    reactant = newReaction.reaction_reactants;
    catalyst = newReaction.reaction_catalysts;
    parameters = [];

    if(ismissing(catalyst))
        reaction = strcat(reactant,"=>");
        param_kdecay = strcat('kdcy_',reactant);
        parameters = vertcat(parameters,param_kdecay);
        reaction_ODE = strcat('((',num2str(log(2)),' / ',param_kdecay,') * ',reactant,')'); 
    else
        reaction = strcat(reactant,"=>");    
        param_kdeg = strcat('kdeg_',catalyst,'_',reactant);
        parameters = vertcat(parameters,param_kdeg);
        param_Km = strcat('Km_',catalyst,'_',reactant);
        parameters = vertcat(parameters,param_Km);
        reaction_ODE = strcat('((',param_kdeg,' *',catalyst,'*',reactant,') / (',param_Km,' +',reactant,'))');
    end

    newReaction.reaction_formula = reaction;
    newReaction.reaction_ODE = reaction_ODE;
    newReaction.reaction_parameters = parameters;
end