function newReaction = getVariableReactionFormulas(newReaction)
    switch newReaction.reaction_formula
        case 'ADD'
            newReaction = getADD(newReaction);
        case 'SUBTRACT'
            newReaction = getSUBTRACT(newReaction);
        case 'INPUT'
            newReaction = getINPUT(newReaction);
        case 'TOTAL'
            newReaction = getTOTAL(newReaction);
        case 'CONST'
            newReaction = getCONST(newReaction);
        otherwise
            error("Dependent reaction rate law abbreviation not recognised.");
    end
end
