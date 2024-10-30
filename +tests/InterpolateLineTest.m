classdef InterpolateLineTest < matlab.unittest.TestCase
  
    methods (Test)

        function coil(testCase)
            % generate coil parametrization
            radius = 2;
            height = 5;
            n_points = 10;
            lower = 0;
            upper = 3*2*pi;
            t = linspace(lower, upper, n_points); % three turns
            x = radius.*cos(t);
            y = radius.*sin(t);
            z = height.*t;

            % get interpolateLine
            import interpolate.InterpolateLine
            points = [x' y' z']; 
            param = InterpolateLine(points, lower, upper);

            % get uniform sample from coil equation
            t_sample = linspace(lower + t(2)/2, upper - t(2)/2, n_points - 1); % so that samples are in the middle of fixed points
            x_sample = radius.*cos(t_sample );
            y_sample  = radius.*sin(t_sample );
            z_sample  = height.*t_sample ;
            points_sample = [x_sample' y_sample' z_sample'];

            % get aprox of sample points from interpolation
            aprox_points_sample = param.eval_set(t_sample);
            
            % get error = points - aprox
            import linalg.l2_distance
            errors = arrayfun(@(r) l2_distance(points_sample(r,:), aprox_points_sample(r,:)), 1:size(points_sample,1));
            verifyLessThan(testCase, max(errors), 1);
            %disp(max(errors))
            %hold on;
            %scatter3(points_sample(:, 1), points_sample(:, 2), points_sample(:, 3));
            %scatter3(aprox_points_sample(:, 1), aprox_points_sample(:, 2), aprox_points_sample(:, 3));
            %param.show();
            %hold off
        end

        function trefoilKnot(testCase)
            % generate trefoil parametrization
            n_points = 10;
            lower = 0;
            upper = 2*pi;
            t = linspace(lower, upper, n_points); % 0 to 2π×lcm(p,q) (theta)
            x = cos(1.*t) + 2.*cos(2.*t);
            y = sin(1.*t) - 2.*sin(2.*t);
            z = -sin(3.*t);

            % get interpolateLine
            import interpolate.InterpolateLine
            points = [x' y' z']; 
            param = InterpolateLine(points, lower, upper);

            % get uniform sample from coil equation
            t_sample = linspace(lower + t(2)/2, upper - t(2)/2, n_points); % so that samples are in the middle of fixed points
            x_sample = cos(1.*t) + 2.*cos(2.*t_sample);
            y_sample = sin(1.*t) - 2.*sin(2.*t_sample);
            z_sample = -sin(3.*t_sample);
            points_sample = [x_sample' y_sample' z_sample'];

            % get aprox of sample points from interpolation
            aprox_points_sample = param.eval_set(t_sample);
            
            % get errors = points - aprox
            import linalg.l2_distance
            errors = arrayfun(@(r) l2_distance(points_sample(r,:), aprox_points_sample(r,:)), 1:size(points_sample,1));
            verifyLessThan(testCase, max(errors), 1);
            %disp(max(errors))
            %hold on;
            %scatter3(points_sample(:, 1), points_sample(:, 2), points_sample(:, 3));
            %scatter3(aprox_points_sample(:, 1), aprox_points_sample(:, 2), aprox_points_sample(:, 3));
            %param.show();
            %hold off
        end


        function archimedeanSpiral(testCase)
            % generate trefoil parametrization
            n_points = 12;
            height = 3;
            a = 0.2;
            lower = 0;
            upper = 6*pi;
            t = linspace(lower, upper, n_points); % 0 to 2π×lcm(p,q) (theta)
            x = a.*t.*cos(1.*t);
            y = a.*t.*sin(1.*t);
            z = height.*t;         

            % get interpolateLine
            import interpolate.InterpolateLine
            points = [x' y' z'];
            param = InterpolateLine(points, lower, upper);

            % get uniform sample from coil equation
            t_sample = linspace(lower + t(2)/2, upper - t(2)/2, n_points); % so that samples are in the middle of fixed points
            x_sample = a.*t_sample.*cos(1.*t_sample);
            y_sample = a.*t_sample.*sin(1.*t_sample);
            z_sample = height.*t_sample;  
            points_sample = [x_sample' y_sample' z_sample'];

            % get aprox of sample points from interpolation
            aprox_points_sample = param.eval_set(t_sample);
            
            % get errors = points - aprox
            import linalg.l2_distance
            errors = arrayfun(@(r) l2_distance(points_sample(r,:), aprox_points_sample(r,:)), 1:size(points_sample,1));
            verifyLessThan(testCase, max(errors), 1);
            %disp(max(errors))
            %hold on;
            %scatter3(points_sample(:, 1), points_sample(:, 2), points_sample(:, 3));
            %scatter3(aprox_points_sample(:, 1), aprox_points_sample(:, 2), aprox_points_sample(:, 3));
            %param.show();
            %hold off
        end
    end
end