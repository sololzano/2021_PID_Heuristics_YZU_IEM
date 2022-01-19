% Clipping function
function z = clip(x, x_min, x_max)
    arguments
        x (1, :) double;
        x_min double;
        x_max double;
    end
    z = max(min(x, x_max), x_min);
end