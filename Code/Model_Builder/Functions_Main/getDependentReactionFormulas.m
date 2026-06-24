function newReaction = getDependentReactionFormulas(newReaction)
    switch newReaction.reaction_type
        case 'PROM'
            newReaction = getPROM(newReaction);
        case 'INHB'
            newReaction = getINHB(newReaction);

        otherwise
            error("Dependent reaction rate law abbreviation not recognised.");
    end
end