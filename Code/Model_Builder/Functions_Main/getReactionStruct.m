%% Generate base model from adjacency matrix.
function reactionStruct = getReactionStruct(base_reaction_filename)
    % Load in base adjacency and formulation matrix.
    indi_reaction_list_temp = readcell(base_reaction_filename,"Sheet","IndependentReactions");
    indi_reaction_list = indi_reaction_list_temp(2:end,:);
    num_indi_reactions = size(indi_reaction_list,1);
    reactionStruct = [];
    
    for i = 1:num_indi_reactions
        newReaction = [];
        temp_reaction_info = indi_reaction_list(i,:);
        newReaction.reaction_rate = string(temp_reaction_info(1,1));
        
        reactants_temp = strsplit(string(temp_reaction_info(1,2)),',');
        reactants_temp = reshape(reactants_temp,length(reactants_temp),1);
        newReaction.reaction_reactants = reactants_temp;

        products_temp = strsplit(string(temp_reaction_info(1,3)),',');
        products_temp = reshape(products_temp,length(products_temp),1);
        newReaction.reaction_products = products_temp;

        catalysts_temp = strsplit(string(temp_reaction_info(1,4)),',');
        catalysts_temp = reshape(catalysts_temp,length(catalysts_temp),1);
        newReaction.reaction_catalysts = catalysts_temp;
        
        newReaction.reaction_targetID = temp_reaction_info{1,5};
        
        reactionStruct = addNewIndependentReaction(newReaction,reactionStruct);
    end

    dep_reaction_list_temp = readcell(base_reaction_filename,"Sheet","DependentReactions"); 
    dep_reaction_list = dep_reaction_list_temp(2:end,:);
    num_dep_reactions = size(dep_reaction_list,1);

    for i = 1:num_dep_reactions
        newReaction = [];
        temp_reaction_info = dep_reaction_list(i,:);
        
        newReaction.reaction_type = string(temp_reaction_info(1,1));

        newReaction.reaction_rate = string(temp_reaction_info(1,2));
        
        reactants_temp = strsplit(string(temp_reaction_info(1,3)),',');
        reactants_temp = reshape(reactants_temp,length(reactants_temp),1);
        newReaction.reaction_reactants = reactants_temp;

        products_temp = strsplit(string(temp_reaction_info(1,4)),',');
        products_temp = reshape(products_temp,length(products_temp),1);
        newReaction.reaction_products = products_temp;

        catalysts_temp = strsplit(string(temp_reaction_info(1,5)),',');
        catalysts_temp = reshape(catalysts_temp,length(catalysts_temp),1);
        newReaction.reaction_catalysts = catalysts_temp;
        
        newReaction.secondary_catalyst = temp_reaction_info{1,6};
        
        reactionStruct = addNewDependentReaction(newReaction,reactionStruct);
    end

    variable_reaction_list_temp = readcell(base_reaction_filename,"Sheet","Variables"); 
    variable_reaction_list = variable_reaction_list_temp(2:end,:);
    num_variable_reactions = size(variable_reaction_list,1);
    reactionStruct.Variables = [];

    for i = 1:num_variable_reactions
        newReaction = [];
        temp_reaction_info = variable_reaction_list(i,:);
        
        newReaction.reaction_formula = string(temp_reaction_info(1,1));

        newReaction.reaction_variable = string(temp_reaction_info(1,2));
        
        reactants_temp = strsplit(string(temp_reaction_info(1,3)),',');
        reactants_temp = reshape(reactants_temp,length(reactants_temp),1);
        newReaction.reaction_reactants = reactants_temp;

        reactionStruct = addNewVariableReaction(newReaction,reactionStruct);
    end

    data_reaction_list_temp = readcell(base_reaction_filename,"Sheet","Data"); 
    data_reaction_list = data_reaction_list_temp(2:end,:);
    num_data_reactions = size(data_reaction_list,1);
    reactionStruct.Data = [];
    
    for i = 1:num_data_reactions
        temp_reaction_info = data_reaction_list(i,:);
        
        temp_reaction_variable = string(temp_reaction_info(1,1));
        temp_reaction_formula = string(temp_reaction_info(1,2));

        reactionStruct.Data(i).Reaction = strcat(temp_reaction_variable, ' =',temp_reaction_formula);
    end
end