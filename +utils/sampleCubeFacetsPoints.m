function points = sampleCubeFacetsPoints(cube, n)
    arguments
        cube (1, 6) double
        n (1,1) double
    end
    import utils.cartesian_prod

    x1 = cube(1, 1);
    y1 = cube(1, 2);
    z1 = cube(1, 3);
    x2 = x1 + cube(1, 4); % first point + offset 
    y2 = y1 + cube(1, 5);
    z2 = z1 + cube(1, 6);

    x = linspace(x1, x2, n);
    y = linspace(y1, y2, n);
    z = linspace(z1, z2, n);

    % for each face, samples the intersections of a square grid of size n
    % inscribed inside the face

    points = zeros(6*n^2,3);
    insert_index = 1;
    
    % faces x and -x
    points(insert_index:insert_index+n^2-1, :) = cartesian_prod(x1, y, z);
    insert_index = insert_index + n^2;
    points(insert_index:insert_index+n^2-1, :) = cartesian_prod(x2, y, z);
    insert_index = insert_index + n^2;

    % faces y and -y
    points(insert_index:insert_index+n^2-1, :) = cartesian_prod(x, y1, z);
    insert_index = insert_index + n^2;
    points(insert_index:insert_index+n^2-1, :) = cartesian_prod(x, y2, z);
    insert_index = insert_index + n^2;

    % faces z and -z
    points(insert_index:insert_index+n^2-1, :) = cartesian_prod(x, y, z1);
    insert_index = insert_index + n^2;
    points(insert_index:insert_index+n^2-1, :) = cartesian_prod(x, y, z2);
    points = unique(points, 'rows');
    %condition = x == xi | x == xf | y == yi | y == yf | z == zi | z == zf;
    %insert_index = insert_index + n^2;
end

