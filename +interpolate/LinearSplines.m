classdef LinearSplines < handle
    properties
        points (:, 2) double
        splines (1, :) sym
    end

    methods
        function obj = LinearSplines(points, options)
            arguments
                points
                options.frontier_values (1, 2) double = [0 0] % array [a b] where a = f'(x_0) ; b = f'(x_n)
            end
            assert(issorted(points(:, 1)), "Domain must be sorted in ascending order");

            obj.points = points;
            obj.points = points;
            varnames = {};
            coefs = ["a", "b"];
            for i = 0:length(points) - 2
                for j = 0:1
                    varnames = [varnames, coefs(mod(j, 2) + 1) + i];
                end
            end
            
            import utils.EqSystem
            eq = EqSystem(varnames);
            
            % Matrix to hold coefficients for each linear spline segment
            splines_coefs_names = strings(length(points) - 1, 2);
            for i = 1:length(points) - 1
                for j = 1:2
                    splines_coefs_names(i, j) = varnames((i - 1) * 2 + j);
                end
            end
            
            % Define linear equations
            for i = 1:size(splines_coefs_names, 1)
                % S_i(x_i) = y_i
                d = dictionary;
                d(splines_coefs_names(i, 1)) = 1; % a_i
                eq.addEq(d, points(i, 2)); % a_i = y_i
            
                % S_i(x_{i+1}) = y_{i+1}
                d = dictionary;
                d(splines_coefs_names(i, 2)) = points(i + 1, 1) - points(i, 1); % (x_{i+1} - x_i) * b_i
                eq.addEq(d, points(i + 1, 2) - points(i, 2)); % a_i + (x_{i+1} - x_i) * b_i = y_{i+1}
            end
            
            % Solve the system for the coefficients
            coefs_solution = eq.solve();
            syms x;
            splines = [];
            
            % Construct each linear spline based on solved coefficients
            for i = 1:size(splines_coefs_names, 1)
                a_i = coefs_solution(2 * (i - 1) + 1);
                b_i = coefs_solution(2 * (i - 1) + 2);
                spline_i = a_i + b_i * (x - points(i, 1));
                splines = [splines, spline_i];
            end
            obj.splines = splines;
        end

        function show(obj, options)
            arguments
                obj
                options.tolerance = 1
                options.hold = false
            end
            import utils.evalf
            p = obj.points;
            tolerance = (p(end, 1)-p(1,1))/size(p, 1);
            x = linspace(p(1,1)-tolerance*options.tolerance, p(end,1)+tolerance*options.tolerance, 100);
            y = zeros(1, length(x));
            j = 1;
            for i=1:length(obj.splines)
                spline = obj.splines(i);
                while x(j) < p(i+1, 1)
                    y(j) = evalf(spline,x(j));
                    j = j + 1;
                end
            end
            % calculates tail after the last point
            spline = obj.splines(end);
            while j <= length(x)
                y(j) = evalf(spline,x(j));
                j = j + 1;
            end
            
            plot(x, y, "-", 'Color', [0 0.4470 0.7410], 'LineWidth',2);
            hold on;
            plot(p(:, 1), p(:, 2), ".", 'Color', [0.8500 0.3250 0.0980], 'MarkerSize',20);
            if options.hold == false
                hold off;
            end
        end

        function fx = eval(obj, x)
            import utils.evalf
            i = 1;
            while x >= obj.points(i, 1) & i ~= size(obj.points, 1)
                i = i + 1;
            end
            spline = obj.splines(i-1);
            fx = evalf(spline, x);
        end

        function image = eval_set(obj, set)
            arguments
                obj 
                set (1, :) double
            end
            % validate domain
            assert(set(1) >= obj.points(1, 1) & set(end) <= obj.points(end, 1), "preimage must be within the domain of the splines")
            assert(issorted(set), "preimage must be in ascending order")
            
            import utils.evalf
            point_i = 1;
            preimage_i = 1;
            image = zeros(1, length(set));
            while preimage_i <= length(set)
                if set(preimage_i) > obj.points(point_i, 1)
                    point_i = point_i + 1;
                elseif set(preimage_i) == obj.points(1, 1) % special case: preimage(i) equal to lower bound
                    spline = obj.splines(1);
                    image(preimage_i) = evalf(spline, set(preimage_i));
                    preimage_i = preimage_i + 1;
                else
                    spline = obj.splines(point_i-1);
                    image(preimage_i) = evalf(spline, set(preimage_i));
                    preimage_i = preimage_i + 1;
                end
            end
        end
    end
end