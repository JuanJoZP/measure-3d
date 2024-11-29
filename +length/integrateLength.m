function length = integrateLength(parametrization)
    arguments
        parametrization interpolate.InterpolateCurve
    end
    import utils.evalf
    import derivate.richardson
    import integrate.simpson
    
    get_spline_x = @(i) parametrization.splines_x.splines(i);
    get_spline_y = @(i) parametrization.splines_y.splines(i);
    get_spline_z = @(i) parametrization.splines_z.splines(i);

    % cambiar h e incrementar el orden de extrapolacion parece no
    % incrementar la precision
    dx = @(t, i) richardson(@(x) evalf(get_spline_x(i),x), t, 0.1, 1); 
    dy = @(t, i) richardson(@(x) evalf(get_spline_y(i),x), t, 0.1, 1);
    dz = @(t, i) richardson(@(x) evalf(get_spline_z(i),x), t, 0.1, 1);
    ds = @(t, i) sqrt(dx(t, i)^2 + dy(t, i)^2 + dz(t, i)^2); % longitud de arco
 
    length = 0;    
    num_splines = size(parametrization.points, 1)-1;
    % integrate over each part of the spline
    for i=1:num_splines
        lower = parametrization.t(i);
        upper = parametrization.t(i+1);
        length = length + simpson(@(x) ds(x, i), lower, upper);
    end
end