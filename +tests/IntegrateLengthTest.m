classdef IntegrateLengthTest < matlab.unittest.TestCase
  
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

            % generate interpolation
            import interpolate.InterpolateLine
            points = [x' y' z']; 
            param = InterpolateLine(points, lower, upper);
            
            % calculate length
            import integrate.integrateLength
            aprox_length = integrateLength(param, lower, upper);

            length = sqrt(radius^2 + height^2)*(upper - lower); % analytic solution
            relative_error = abs((length - aprox_length)/length)*100;
            verifyLessThan(testCase, relative_error, 5);
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
            points = [x' y' z']; % half the points (odd index)
            param = InterpolateLine(points, lower, upper);

            % calculate length
            import integrate.integrateLength
            aprox_length = integrateLength(param, lower, upper);

            f = @(t) sqrt((-sin(t) - 4*sin(2*t)).^2 + (cos(t) - 4*cos(2*t)).^2 + (-3*cos(3*t)).^2);
            length = integral(f, upper, lower); % calculating ds analytically, integrating numerically
            relative_error = abs((length - aprox_length)/length)*100;
            verifyLessThan(testCase, relative_error, 5);
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
            points = [x' y' z']; % half the points (odd index)
            param = InterpolateLine(points, lower, upper);

            % calculate length
            import integrate.integrateLength
            aprox_length = integrateLength(param, lower, upper);

            length = 3*pi * sqrt(a^2 + height^2) * sqrt(1 + (36*a^2*pi^2)/(height^2)); % calculating ds analytically, integrating numerically
            relative_error = abs((length - aprox_length)/length)*100;
            verifyLessThan(testCase, relative_error, 5);
        end
    end
end