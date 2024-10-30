function distance = l2_distance(vector1, vector2)
    arguments
        vector1 (1, :) double
        vector2 (1, :) double
    end
    assert(length(vector1) == length(vector2), "Distance is not defined for vectors of different dimensions.")

    x = (vector1-vector2);
    distance = sqrt(dot(x,x));
end