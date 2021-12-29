% Clipping function
function z = clip(x, x_min, x_max)
    arguments
        x (1, 3) double;
        x_min (1, 3) double = [-20., -20., -20.];
        x_max (1, 3) double = [20., 20., 20.];
    end
    z = max(min(x, x_max), x_min);
end