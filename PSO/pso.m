% Particle Swarm Optimization Algorithm
function [gb, gb_array, gb_idx, x] = pso...
    (p, x_min, x_max, v_max, iterations, c1, c2, w, wr, system)
    arguments
        p (1, 1) int16 = 100;
        x_min (1, 3) double = [-20., -20., -20];
        x_max (1, 3) double = [20., 20., 20.];
        v_max (1, 3) double = [10., 10., 10.];
        iterations (1, 1) int8 = 1000;
        c1 (1, 1) double = 1.5;
        c2 (1, 1) double = 1.5;
        w (1, 1) double = 0.9;
        wr (1, 4) double = [1., 1., 1., 1.];
        system string = "PITCH";
    end
    
    % Get initial solutions
    [x, v, pb, gb, gb_idx] = init_population...
        (p, x_min, x_max, v_max, system);
    gb_array = zeros(iterations, 3);
    gb_array(1, :) = gb;
    % Iterate for outer loop
    fgb = objective_function(gb, wr, system);
    for j=2:iterations
        % Update particle's best
        for i=1:p
            % Best position
            fx = objective_function(x(i, :), wr, system);
            fb = objective_function(pb(i, :), wr,  system);
            % Update particle's best position
            if (fx < fb)
                pb(i, :) = x(i, :);
            end
            
            % Update global best particle and index
            if (fb < fgb)
                gb = pb(i, :);
                fgb = fb;
                gb_idx = i;
            end
            gb_array(j, :) = gb;
        end

        % Update position and velocity of particles
        for i=1:p
            % Fan's modified velocity equation
            a = c1 * rand(1, 3) .* (pb(i, :) - x(i, :));
            b = c2 * rand(1, 3) .* (gb - x(i, :));
            v(i, :) = w * v(i, :) + a + b;
            v(i, :) = clip(v(i, :), -v_max, v_max);
            % Update particle's position
            x(i, :) = x(i, :) + v(i, :);

            % Rebound particle to avoid saturation
            for d=1:3
                if (x(i, d) > x_max(d))
                    x(i, d) = x(i, d) - x_max(d);
                end
                if (x(i, d) < x_min(d))
                    x(i, d) = x(i, d) - x_min(d);
                end
            end
            x(i, :) = clip(x(i, :), x_min, x_max);
        end
        % Fan velocity update equation
        v_max = (1. - double((double(j)/double(iterations))^2)).*v_max;
    end
end