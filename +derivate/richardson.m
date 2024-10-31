function derivative = richardson(f, t, h, order)
        arguments
            f function_handle
            t (1, 1) double
            h (1, 1) double
            order (1, 1) double
        end
        import derivate.richardson
        
        if order == 1
            derivative = (f(t-2*h) - 8*f(t - h) + 8*f(t + h) - f(t + 2*h))/(12*h);
        else
            less_order_h_2 = richardson(f, t, h/2, order-1);
            less_order_h = richardson(f, t, h, order-1);
        
            derivative = less_order_h_2 + (less_order_h_2 - less_order_h)/(4^(order-1) - 1);
        end
end

