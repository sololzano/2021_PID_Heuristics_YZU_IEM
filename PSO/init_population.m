% Initialize Population
function [x, v, pb, gb, gb_idx] = init_population...
    (p, x_min, x_max, v_max, system, wr)
    arguments
        p (1, 1) int8 = 10;
        x_min (1, 3) double = [-20, -20., -20.];
        x_max (1, 3) double = [20., 20., 20.];
        v_max (1, 3) double = [5., 5., 5.];
        system string = "PITCH";
        wr (1, 4) double = [1., 1., 1., 1.];
    end

    % Get population from random uniform distribution
    x = x_min + (x_max - x_min).*rand(p, 3);
    v = -(v_max/3) + ((v_max) - (-v_max/3)).*rand(p, 3);
    pb = x;

    % Update global best
    fb = zeros(1, p);
    for i=1:p
        fb(i) = objective_function(x(i), wr, system);
    end
    [~, gb_idx] = min(fb);
    gb = x(gb_idx, :);
end