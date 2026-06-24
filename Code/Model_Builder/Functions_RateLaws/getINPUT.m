function newReaction = getINPUT(newReaction)
    variable = newReaction.reaction_variable;
    parameters = [];
    temp_param_one = strcat('input_',variable);
    parameters = vertcat(parameters,temp_param_one);

    temp_param_two = strcat('inptime_',variable);
    parameters = vertcat(parameters, temp_param_two);

    variable_reaction = strcat(variable," =", temp_param_one, ' * piecewiseIQM(1,ge(time,',temp_param_two,'),0)');

    newReaction.reaction = variable_reaction;
    newReaction.reaction_parameters = parameters;
end
