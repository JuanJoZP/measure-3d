classdef IntegrateLengthTest < matlab.unittest.TestCase
  
    methods (Test)

        function circle(testCase)
            % generate circle parametrization
            n_points = 10;
            lower = 0;
            upper = 2*pi;
            t = linspace(lower, upper, n_points);
            x = 1.*cos(1.*t);
            y = 1.*sin(1.*t);
            z = 0.*t;

            % generate interpolation
            import interpolate.InterpolateCurve
            points = [x' y' z']; 
            param = InterpolateCurve(points, lower, upper);

            % calculate length
            import length.integrateLength
            aprox_length = integrateLength(param);

            length = 2*pi; % analytic solution
            relative_error = abs((length - aprox_length)/length)*100;
            verifyLessThan(testCase, relative_error, 5);
        end

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

            % generate interpolation
            import interpolate.InterpolateCurve
            points = [x' y' z']; 
            param = InterpolateCurve(points, lower, upper);
            
            % calculate length
            import length.integrateLength
            aprox_length = integrateLength(param);

            length = sqrt(radius^2 + height^2)*(upper - lower); % analytic solution
            relative_error = abs((length - aprox_length)/length)*100;
            verifyLessThan(testCase, relative_error, 5);
        end

        function trefoilKnot(testCase)
            % generate trefoil parametrization
            n_points = 12;
            lower = 0;
            upper = 2*pi;
            t = linspace(lower, upper, n_points); 
            x = cos(1.*t) + 2.*cos(2.*t);
            y = sin(1.*t) - 2.*sin(2.*t);
            z = -sin(3.*t);

            % get InterpolateCurve
            import interpolate.InterpolateCurve
            points = [x' y' z']; 
            param = InterpolateCurve(points, lower, upper);

            % calculate length
            import length.integrateLength
            aprox_length = integrateLength(param);

            f = @(t) sqrt((-sin(t) - 4*sin(2*t)).^2 + (cos(t) - 4*cos(2*t)).^2 + (-3*cos(3*t)).^2);
            length = integral(f, lower, upper);
            relative_error = abs((length - aprox_length)/length)*100;
            verifyLessThan(testCase, relative_error, 5);
        end


        function archimedeanSpiral(testCase)
            % generate trefoil parametrization
            n_points = 102;
            height = 3;
            a = 0.2;
            lower = 0;
            upper = 6*pi;
            t = linspace(lower, upper, n_points); % 0 to 2π×lcm(p,q) (theta)
            x = a.*t.*cos(1.*t);
            y = a.*t.*sin(1.*t);
            z = height.*t;         

            % get InterpolateCurve
            import interpolate.InterpolateCurve
            points = [x' y' z']; % half the points (odd index)
            plot3(x,y,z)
            param = InterpolateCurve(points, lower, upper);

            % calculate length
            import length.integrateLength
            aprox_length = integrateLength(param);

            ds = @(t) sqrt((a .* (cos(t) - t .* sin(t))).^2 + (a .* (sin(t) + t .* cos(t))).^2 + height^2);
            length = integral(ds, lower, upper); % calculating ds analytically, integrating numerically
            relative_error = abs((length - aprox_length)/length)*100;
            verifyLessThan(testCase, relative_error, 5);
        end
    end
end