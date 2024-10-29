classdef MeasuresTest < matlab.unittest.TestCase
    methods (Test)
        function volumeTotalCubo(testCase)
            cubo = Object3D("Cubo.asc");
            aprox = cubo.volumeTotal();
            real = 10^3; % side = 10
            relative_error = abs((aprox - real)/real)*100;
            verifyLessThan(testCase, relative_error, 5);
        end

        function volumeTotalCilindro(testCase)
            cilindro = Object3D("Cilindro.asc");
            aprox = cilindro.volumeTotal();
            real = 10*pi*(2^2); % height = 10, radius = 2
            relative_error = abs((aprox - real)/real)*100;
            verifyLessThan(testCase, relative_error, 5);
        end

        function volumeTotalCilindroHueco(testCase)
            cilindro_hueco = Object3D("CilindroHueco.asc");
            aprox = cilindro_hueco.volumeTotal();
            real = 20*pi*(5^2) - 20*pi*(4^2); % height = 20, outter radius = 5, inner radius = 4
            relative_error = abs((aprox - real)/real)*100;
            verifyLessThan(testCase, relative_error, 5);
        end

        function surfaceTotalCubo(testCase)
            cubo = Object3D("Cubo.asc");
            aprox = cubo.surfaceTotal();
            real = 6*(10^2); % side = 10
            relative_error = abs((aprox - real)/real)*100;
            verifyLessThan(testCase, relative_error, 5);
        end

        function surfaceTotalCilindro(testCase)
            cilindro = Object3D("Cilindro.asc");
            aprox = cilindro.surfaceTotal();
            real = 10*2*pi*2 + 2*pi*(2^2); % height = 10, radius = 2
            relative_error = abs((aprox - real)/real)*100;
            verifyLessThan(testCase, relative_error, 5);
        end

        function surfaceTotalCilindroHueco(testCase)
            cilindro_hueco = Object3D("CilindroHueco.asc");
            aprox = cilindro_hueco.volumeTotal();
            real = 20*2*pi*5 + 20*2*pi*4 + 2*pi*(5^2) - 2*pi*(4^2); % height = 20, outter radius = 5, inner radius = 4
            relative_error = abs((aprox - real)/real)*100;
            verifyLessThan(testCase, relative_error, 5);
        end

    end

end
