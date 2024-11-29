classdef Object3D < handle
    properties
        points (:, 3) double
        alpha_complex
        alpha_range (2, 1) double
    end
    
    methods
        function obj = Object3D(inputArg)
            % Check if inputArg is a filename (string) or points (numeric array)
            if ischar(inputArg) || isstring(inputArg)  
                file_split = split(inputArg, ".");
                assert(file_split(2) == "asc", "Only supports .asc files");

                obj.points = importdata(inputArg).data;
        
            elseif isnumeric(inputArg)  
                % Validate points 
                assert(isa(inputArg, 'double') && size(inputArg, 2) == 3, ...
                    "Points must be a double array with shape (:, 3)");

                obj.points = inputArg;
        
            else
                error("Invalid input. Provide either a filename or a matrix of points.");
            end

            obj.alpha_complex = alphaShape(obj.points);
            obj.alpha_range = [0; 7]; % hardcoded, could need a bigger range for larger models
        end
        
        function plot(obj, ax, options)
            arguments
                obj
                ax
                options.hold = false
            end
            scatter3(ax, obj.points(:, 1), obj.points(:, 2), obj.points(:, 3), "MarkerEdgeColor",[0 0.4470 0.7410])
            grid(ax, "on")
            axis(ax, "equal")
            xlabel(ax, 'X'); ylabel(ax, 'Y'); zlabel(ax, 'Z');
            hold(ax, "on")
            if ~options.hold
                hold(ax, "off");
            end
        end

        function length = lengthCurve(~, curve_points, interpolation_deegre)
            arguments
                ~
                curve_points (:, 3) double
                interpolation_deegre {mustBeMember(interpolation_deegre, {'linear', 'cubic'})}
            end
            import interpolate.InterpolateCurve
            import length.integrateLength

            parametrization = InterpolateCurve(curve_points, 1, size(curve_points, 1), "deegre", interpolation_deegre);
            length = integrateLength(parametrization);
        end

        function obj = setAlphaComplex(obj, alpha)
            assert(alpha > obj.alpha_range(1) & alpha <= obj.alpha_range(2))
            obj.alpha_complex.Alpha = alpha;
        end

        function vol = volumeTotal(obj)
            vol = volume(obj.alpha_complex);
        end

        function area = areaTotal(obj)
            area = surfaceArea(obj.alpha_complex);
        end
    end
end

