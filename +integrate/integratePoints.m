function intx = integratePoints(points, lower, upper, n, options)
    arguments
        points dictionary % string -> double dict (x and f(x))
        lower double
        upper double {mustBeGreaterThan(upper, lower)}
        n double {mustBeInteger, mustBeInRange(n, 0, 4)} % deegre
        options.open = false
    end

    keys = points.keys;
    for i = 1:length(keys)
        mustBeA(keys(i), 'string');
    end
    
    format long
    
    if options.open
        h = (upper - lower)/(n+2);
        lower = lower + h;
        if n == 0
            intx = 2*h*points(num2str(lower));
        elseif n == 1
            intx = ((3*h)/2)*(points(num2str(lower)) + points(num2str(lower + h)));
        elseif n == 2
            intx = ((4*h)/3)*(2*points(num2str(lower)) + (-1)*points(num2str(lower + h)) + 2*points(num2str(lower + 3*h)));
        elseif n == 3
            intx = ((5*h)/24)*(11*points(num2str(lower)) + points(num2str(lower + h)) + points(num2str(lower + 2*h)) + 11*points(num2str(lower + 3*h)));
        elseif n == 4
            error("Open formulas do not support n=4. Try setting open=false")
        end
    else
        h = (upper - lower)/n;
        if n == 0
            error("Closed formulas do not support n=0. Try setting open=true")
        elseif n == 1
            intx = (h/2)*(points(num2str(lower)) + points(num2str(lower + h)));
        elseif n == 2
            intx = (h/3)*(points(num2str(lower)) + 4*points(num2str(lower + h)) + points(num2str(lower + 2*h)));
        elseif n == 3
            intx = ((3*h)/8)*(points(num2str(lower)) + 3*points(num2str(lower + h)) + 3*points(num2str(lower + 2*h)) + points(num2str(lower + 3*h)));
        elseif n == 4
            intx = ((2*h)/45)*(7*points(num2str(lower)) + 32*points(num2str(lower + h)) + 12*points(num2str(lower + 2*h)) + 32*points(num2str(lower + 3*h)) + 7*points(num2str(lower + 4*h)));
        end
    end
end
