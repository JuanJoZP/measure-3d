function distance = l_inf_distance(vector1, vector2)
    arguments
        vector1 (1, :) double
        vector2 (1, :) double
    end
    assert(length(vector1) == length(vector2), "Distance is not defined for vectors of different dimensions.")

    distance = 0;
    for i=1:length(vector1)
        new = abs(vector1(i)-vector2(i));
        if new > distance
            distance = new;
        end
    end
end