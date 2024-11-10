function new_points = removePointsOutsideCube(points , cube)
    arguments
        points (:, 3) double
        cube (1, :) double
    end
    x1 = cube(1, 1);
    y1 = cube(1, 2);
    z1 = cube(1, 3);
    x2 = x1 + cube(1, 4); % first point + offset 
    y2 = y1 + cube(1, 5);
    z2 = z1 + cube(1, 6);
    new_points = zeros(size(points,1), 3);
    insert_index = 1;
    for i=1:size(points, 1)
        [x, y, z] = deal(points(i, 1), points(i, 2), points(i, 3));
        condition = x1 <= x & x <= x2 & y1 <= y & y <= y2 & z1 <= z & z <= z2; 
        if condition
            new_points(insert_index, :) = [x, y, z];
            insert_index = insert_index + 1;
        end
    end

    new_points = new_points(1:insert_index-1, :);
end

