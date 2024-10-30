function l = integrateLength(parametrization)
    arguments
        parametrization interpolate.InterpolateLine
    end

    % POR AHORA ATACANDO CON FORMULAS MAS BASICAS
    % AÑADIR options.truncate

    import utils.evalf
    h = 0.01;
    
    get_spline_x = @(i) parametrization.splines_x.splines(i);
    get_spline_y = @(i) parametrization.splines_y.splines(i);
    get_spline_z = @(i) parametrization.splines_z.splines(i);

    
    dx = @(t, i) (evalf(get_spline_x(i), t - 2*h) - 8*evalf(get_spline_x(i), t - h) + 8*evalf(get_spline_x(i), t + h) - evalf(get_spline_x(i), t + 2*h))/(12*h); % formula: midpoint 3 points
    dy = @(t, i) (evalf(get_spline_y(i), t - 2*h) - 8*evalf(get_spline_y(i), t - h) + 8*evalf(get_spline_y(i), t + h) - evalf(get_spline_y(i), t + 2*h))/(12*h);
    dz = @(t, i) (evalf(get_spline_z(i), t - 2*h) - 8*evalf(get_spline_z(i), t - h) + 8*evalf(get_spline_z(i), t + h) - evalf(get_spline_z(i), t + 2*h))/(12*h);

    ds = @(t, i) sqrt(dx(t, i)^2 + dy(t, i)^2 + dz(t, i)^3);

    
    l = 0;    
    num_splines = size(parametrization.points, 1)-1;
    % integrate over each spline, sum at the end
    for i=1:num_splines
        lower = parametrization.t(i);
        upper = parametrization.t(i+1);
        h = (upper - lower)/4;
        lower = lower + h;
        l = l + ((4*h)/3)*(2*ds(lower, i) + (-1)*ds(lower + h, i) + 2*ds(lower + 3*h, i));
    end
end