function distance = l1_distance(vector1, vector2)
    arguments
        vector1 (1, :) double
        vector2 (1, :) double
    end
    assert(length(vector1) == length(vector2), "Distance is not defined for vectors of different dimensions.")

    distance = 0;
    for i=1:length(vector1)
        distance = distance + abs(vector1(i)-vector2(i));
    end
end

