function strcell = points2str(points)
    strcell = {};
    for i=1:size(points,1)
        strcell = [strcell; {char(['(', num2str(points(i,1)), ', ', num2str(points(i,2)), ', ', num2str(points(i,3)), ')'])}];
    end
end

