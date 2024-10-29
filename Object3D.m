classdef Object3D 
    properties
        points (:, 3) double
    end
    
    methods
        function obj = Object3D(filename)
            file_split = split(filename, ".");
            assert(file_split(2) == "asc", "Only supports .asc files")

            obj.points = importdata(filename).data;
        end
        
        function plot(obj)
            scatter3(obj.points(:, 1), obj.points(:, 2), obj.points(:, 3))
        end

        function volume = volumeTotal(obj)
            error("Not implemented yet")
        end

        function surface = surfaceTotal(obj)
            error("Not implemented yet")
        end
    end
end

