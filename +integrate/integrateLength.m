function l = integrateLength(parametrization)
    arguments
        parametrization interpolate.InterpolateCurve
    end
    import utils.evalf
    import derivate.richardson
    
    get_spline_x = @(i) parametrization.splines_x.splines(i);
    get_spline_y = @(i) parametrization.splines_y.splines(i);
    get_spline_z = @(i) parametrization.splines_z.splines(i);

    % changing h and incrementing extrapolation order does not seems to
    % increment precision
    dx = @(t, i) richardson(@(x) evalf(get_spline_x(i),x), t, 0.1, 1); 
    dy = @(t, i) richardson(@(x) evalf(get_spline_y(i),x), t, 0.1, 1);
    dz = @(t, i) richardson(@(x) evalf(get_spline_z(i),x), t, 0.1, 1);

    ds = @(t, i) sqrt(dx(t, i)^2 + dy(t, i)^2 + dz(t, i)^2); 
 
    l = 0;    
    num_splines = size(parametrization.points, 1)-1;
    % integrate over each segment of spline
    for i=1:num_splines
        % could be more precise: split segments in smaller intervals
        lower = parametrization.t(i);
        upper = parametrization.t(i+1);
        h = (upper - lower)/4;
        lower = lower + h;

        segment = ((4*h)/3)*(2*ds(lower, i) + (-1)*ds(lower+h, i) + 2*ds(lower+3*h, i));
        l = l + segment;
    end
end