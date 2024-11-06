classdef Object3D < handle
    properties
        points (:, 3) double
        alpha_complex
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
        end
        
        function plot(obj, ax)
            if nargin == 1
                scatter3(obj.points(:, 1), obj.points(:, 2), obj.points(:, 3))
            elseif nargin == 2
                scatter3(ax, obj.points(:, 1), obj.points(:, 2), obj.points(:, 3))
            end
        end

        function length = lengthCurve(~, curve_points, interpolation_deegre)
            arguments
                ~
                curve_points (:, 3) double
                interpolation_deegre {mustBeMember(interpolation_deegre, {'linear', 'cubic'})}
            end
            % POR AHORA ASI, LUEGO CON INDICES DE CADA PUNTO PARA JUNTARLO
            % CON LA SELECCION
            import interpolate.InterpolateCurve
            import integrate.integrateLength

            parametrization = InterpolateCurve(curve_points, 1, size(curve_points, 1), "deegre", interpolation_deegre);
            length = integrateLength(parametrization);
        end

        function obj = setAlphaComplex(obj, alpha)
            obj.alpha_complex = alphaShape(obj.points, alpha);
        end

        function vol = volumeTotal(obj)
            assert(isa(obj.alpha_complex, 'alphaShape'), "In order to calculate volume alpha complex must be set")
            vol = volume(obj.alpha_complex);
        end

        function area = areaTotal(obj)
            assert(isa(obj.alpha_complex, 'alphaShape'), "In order to calculate volume alpha complex must be set")
            area = surfaceArea(obj.alpha_complex);
        end
    end
end

