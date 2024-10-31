function integral = simpson(f, lower, upper)
    arguments
        f function_handle
        lower (1, 1) double
        upper (1, 1) double
    end
    assert(lower < upper, "Interval for integration is not well defined. lower bound should be less than upper bound")
    
    h = (upper - lower)/4;
    lower = lower + h;
    integral = ((4*h)/3)*(2*f(lower) + (-1)*f(lower+h) + 2*f(lower+3*h));
end

