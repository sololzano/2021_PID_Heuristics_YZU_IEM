function [gb_array, x] = sad_voa...
    (viruses, x_min, x_max, strong_percent, strong_rate,...
    weak_rate, intensity, decay, survivor_percent, kind,...
    iterations, mode, wr, system)
    arguments
        viruses(1, 1) int16 = 10;
        x_min(1, 3) double = [0., 0., 0.];
        x_max(1, 3) double = [100., 100., 100.];
        strong_percent double = 0.4;
        strong_rate int8 = 1;
        weak_rate int8 = 2;
        intensity double = 0.9;
        decay double = .95;
        survivor_percent double = 0.6;
        kind string = "FIXED";
        iterations(1, 1) int16 = 100;
        mode string = "NORMAL";
        wr(1, 4) double = [1., 1., 1., 1.];
        system string = "PITCH";
    end
    % Initialize viruses in the space
    [x, f] = init_viruses(viruses, x_min, x_max, system, wr);
    gb_array = zeros(iterations, 3);
    m = mean(f);
    % Iterate 
    for i=1:iterations
        % Replicate
        p_i = length(x);
        [x, f] = replicate(x, strong_percent, strong_rate,...
            weak_rate, intensity, wr, system);
        p_n = length(x);

        % Antivirus
        [x, f] = antivirus(x, f, survivor_percent, kind);
        p_a = p_n - length(x);

        % Dynamic part of virus optimization algorithm
        if (mode == "DYNAMIC") || (mode == "SAD")
            % Update number of strong viruses
            strong = (p_i * strong_percent)*(1+((p_n - p_i)/max(p_i, p_n)));
            strong_percent = ceil(strong)/p_n;
            % Update growth rates
            strong_rate = ceil(strong_rate * (1 + (p_a/p_n)));
            weak_rate = ceil(weak_rate * (1 + (p_a/p_n)));
        end

        % Increase exploitation through intensity for super adaptiveness
        if (mode == "SAD")
            if (m <= mean(f))
                intensity = intensity * decay;
            end
            m = mean(f);
        end

        % Decay mode
        if mode == "DECAY"
            intensity = intensity * decay;
        end

        % Sort and update global best array\
        [f, idx] = sort(f); %#ok<ASGLU> 
        x = x(idx, :);
        gb_array(i, :) = x(1, :);
    end
end