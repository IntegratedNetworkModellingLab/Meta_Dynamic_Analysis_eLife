function newReaction = getIndependentReactionFormulas(newReaction)
    switch newReaction.reaction_rate
        case 'MM'
            newReaction = getMM(newReaction);
        case 'CF'
            newReaction = getCF(newReaction);
        case 'CD'
            newReaction = getCD(newReaction);
        case 'SYN'
            newReaction = getSYN(newReaction);
        case 'DEG'
            newReaction = getDEG(newReaction);
        case 'MMS'
            newReaction = getMMS(newReaction);
        otherwise
            error("Reaction rate law abbreviation not recognised.");
    end
end