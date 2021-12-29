function [x, f] = init_viruses(viruses, x_min, x_max, system, wr)
    arguments
        viruses (1, 1) int16 = 10;
        x_min (1, 3) double = [0., 0., 0.];
        x_max (1, 3) double = [20., 20., 20.];
        system string = "PITCH";
        wr (1, 4) double = [1., 1., 1., 1.];
    end

    % Initialize random virus population
    x = x_min + (x_max - x_min).*rand(viruses, 3);
    f = zeros(1, viruses);
    for i=1:viruses
        f(i) = objective_function(x(i, :), wr, system);
    end
    % Sort viruses by objective function value
    [f, idx] = sort(f);
    x = x(idx, :);
end