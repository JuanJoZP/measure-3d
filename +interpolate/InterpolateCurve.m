classdef InterpolateCurve < handle
    properties
        n (1,1) double
        points (:, 3) double 
        t (1, :) double
        lower_bound (1,1) double
        upper_bound (1,1) double
        splines_x
        splines_y 
        splines_z 
    end

    methods
        function obj = InterpolateCurve(points, lower_bound, upper_bound, options)
            arguments
                points (:, 3) double 
                lower_bound (1,1) double
                upper_bound (1,1) double
                options.deegre {mustBeMember(options.deegre, {'cubic', 'linear'})} = 'cubic'
            end

            x = points(:, 1);
            y = points(:, 2);
            z = points(:, 3);
            t = linspace(lower_bound, upper_bound, length(x));
        
            obj.n = length(x);
            obj.points = points;
            obj.t = t;
            obj.lower_bound = lower_bound;
            obj.upper_bound = upper_bound;
            
            import interpolate.CubicSplines
            import interpolate.LinearSplines

            if strcmp(options.deegre, 'cubic')
                obj.splines_x = CubicSplines([t' x]);
                obj.splines_y = CubicSplines([t' y]);
                obj.splines_z = CubicSplines([t' z]);
            elseif strcmp(options.deegre, 'linear')
                obj.splines_x = LinearSplines([t' x]);
                obj.splines_y = LinearSplines([t' y]);
                obj.splines_z = LinearSplines([t' z]);
            end
        end

        function show(obj, ax, options)
            arguments
                obj
                ax
                options.hold = false
            end

            import utils.evalf
            n_points = 100; % not sure
            t = linspace(obj.lower_bound, obj.upper_bound, n_points);
            x = zeros(1, n_points);
            y = zeros(1, n_points);
            z = zeros(1, n_points);
            j = 1;
            for i=1:(obj.n-1) % for each spline
                spline_x = obj.splines_x.splines(i);
                spline_y = obj.splines_y.splines(i);
                spline_z = obj.splines_z.splines(i);
                while t(j) < obj.splines_x.points(i+1, 1)
                    x(j) = evalf(spline_x,t(j));
                    y(j) = evalf(spline_y,t(j));
                    z(j) = evalf(spline_z,t(j));
                    j = j + 1;
                end
            end
            x(end) = evalf(obj.splines_x.splines(end),t(end));
            y(end) = evalf(obj.splines_y.splines(end),t(end));
            z(end) = evalf(obj.splines_z.splines(end),t(end));

            plot3(ax, x, y, z, "-", 'Color', [0 0.4470 0.7410], 'LineWidth',2);
            hold(ax, 'on');
            p = obj.points;
            plot3(ax, p(:, 1), p(:, 2), p(:, 3), ".", 'Color', [0.8500 0.3250 0.0980], 'MarkerSize',20);
            if options.hold == false
                hold(ax, 'off');
            end
        end

        function ft = eval(obj, t)
            arguments
                obj
                t (1,1)
            end

            x = obj.splines_x.eval(t);
            y = obj.splines_y.eval(t);
            z = obj.splines_z.eval(t);
            ft = [x y z];
        end

        function image = eval_set(obj, set)
            arguments
                obj
                set (1, :) double 
            end
            
            x = obj.splines_x.eval_set(set);
            y = obj.splines_y.eval_set(set);
            z = obj.splines_z.eval_set(set);
            image = [x' y' z'];
        end
    end
end