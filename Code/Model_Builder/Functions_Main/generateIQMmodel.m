%% Script that takes in IQM_Reactions Struct and converts it to .txtbc file.
function generateIQMmodel(model_name,reactionStruct)
    parameters = reactionStruct.Parameters;
    state_variables = reactionStruct.StateVariables;
    model_variables = reactionStruct.Variables;
    data_variables = reactionStruct.Data;
    
    
    fileID = fopen(strcat(model_name,'.txtbc'),'w');

    fprintf(fileID,'********** MODEL NAME');
    fprintf(fileID,'\n\n');

    % model name
    fprintf(fileID,model_name);


    fprintf(fileID,'\n\n');
    fprintf(fileID,'********** MODEL NOTES');
    fprintf(fileID,'\n\n');



    fprintf(fileID,'\n\n');
    fprintf(fileID,'********** MODEL STATE INFORMATION');
    fprintf(fileID,'\n\n');
    
    

    % Initial State Values
    for i = 1:size(state_variables,1)
        IC_states = strcat(state_variables(i),'(0) = 500');
        fprintf(fileID,'%-20s\n',IC_states);
    end


    fprintf(fileID,'\n\n');
    fprintf(fileID,'********** MODEL PARAMETERS');
    fprintf(fileID,'\n\n');

    % parameters
    for j = 1:size(parameters,1)
        temp_param = parameters(j);
        temp_param_split = strsplit(temp_param,'_');
        temp_param_mod = temp_param_split(1);
        switch temp_param_mod
            case "kc"
                IC_Params = strcat(temp_param,' = 0.1');
            case "Km"
                IC_Params = strcat(temp_param,' = 100');
            case "Vm"
                IC_Params = strcat(temp_param,' = 10');
            case "ka"
                IC_Params = strcat(temp_param,' = 0.001');
            case "kd"
                IC_Params = strcat(temp_param,' = 0.01');
            case "ksyn"
                IC_Params = strcat(temp_param,' = 10');
            case "kdcy"
                IC_Params = strcat(temp_param,' = 240');
            case "kdeg"
                IC_Params = strcat(temp_param,' = 0.1');
            case "alpha"
                IC_Params = strcat(temp_param,' = 1');
            case "input"
                IC_Params = strcat(temp_param,' = 500');
            case "inptime"
                IC_Params = strcat(temp_param,' = 1');
            case 'const'
                IC_Params = strcat(temp_param,' = 500');
            otherwise
                error("Parameter type not recognised")
        end
        fprintf(fileID,'%-20s\n',IC_Params);
    end


    fprintf(fileID,'\n\n');
    fprintf(fileID,'********** MODEL VARIABLES');
    fprintf(fileID,'\n\n');

    for n = 1:size(model_variables,2)
        Input_Eq = model_variables(n).Reaction;
        fprintf(fileID,'%-20s\n',Input_Eq);
    end
    
    fprintf(fileID,'\n\n');

    for q = 1:size(data_variables,2)
        Input_Eq = data_variables(q).Reaction;
        fprintf(fileID,'%-20s\n',Input_Eq);
    end

    fprintf(fileID,'\n\n');
    fprintf(fileID,'********** MODEL REACTIONS');
    fprintf(fileID,'\n\n');

    for p = 1:size(reactionStruct.Reactions,2)
        reaction_text = reactionStruct.Reactions(p).ReactionFormula;
        reaction_text = strcat(reaction_text,' :R',num2str(p));
        fprintf(fileID,'%-20s\n',reaction_text);
        num_sub_reactions = size(reactionStruct.Reactions(p).ReactionODE,1);
        if(num_sub_reactions > 1)
            forward_text = determineTotalDepReactionText(reactionStruct.Reactions(p).ReactionODE);
        else
            forward_text = 'vf = ';
            forward_text = strcat(forward_text,reactionStruct.Reactions(p).ReactionODE);
        end
        % for pp = 1:num_sub_reactions
        % 
        %     forward_text = strcat(forward_text,reactionStruct.Reactions(p).ReactionODE(pp));
        %     if(pp < num_sub_reactions)
        %         forward_text = strcat(forward_text, ' +');
        %     end
        % end
        fprintf(fileID,'\t');
        fprintf(fileID,'%-20s\n',forward_text);

        fprintf(fileID,'\n\n');
    end

    fprintf(fileID,'\n\n');
    fprintf(fileID,'********** MODEL FUNCTIONS');
    fprintf(fileID,'\n\n');


    fprintf(fileID,'\n\n');
    fprintf(fileID,'********** MODEL EVENTS');
    fprintf(fileID,'\n\n');


    fprintf(fileID,'\n\n');
    fprintf(fileID,'********** MODEL MATLAB FUNCTIONS');
    fprintf(fileID,'\n\n');


    fclose(fileID);

end