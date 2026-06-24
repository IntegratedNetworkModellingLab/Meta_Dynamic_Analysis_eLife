function gradient_between = gradientBetweenPoints(array, space_between_points)
    for i = 2:length(array)
        gradient_between(i-1) = (array(i) - array(i-1))/space_between_points;
    end
end