function [new_viruses, f] = replicate...
    (population, strong_percent, strong_rate, weak_rate,... 
    intensity, wr, system, intensity_weak, sensor, x_min, x_max)
    arguments
        population(:, 3) double;
        strong_percent double = 0.4;
        strong_rate int32 = 1;
        weak_rate int32 = 2;
        intensity double = 2.;
        wr(1, 4) double = [1., 1., 1., 1.];
        system string = "PITCH";
        intensity_weak double = 0.5;
        sensor = 1;
        x_min (1, 3) double = [0., 0. 0.];
        x_max (1, 3) double = [100., 100., 50.];
    end
    n_strong = int32(length(population) * strong_percent);
    n_weak = length(population) - n_strong;
    strong_viruses = population(1:n_strong, :);
    weak_viruses = population(n_strong+1:end, :);
    new_viruses = zeros((2*n_strong*strong_rate) + (2*n_weak*weak_rate) + n_strong + n_weak, 3);
    % Replicate strong viruses
    sp = repmat(strong_viruses, strong_rate, 1) +...
        (rand(int32(n_strong * strong_rate), 3)*intensity.*repmat(strong_viruses, strong_rate, 1));
    sn = repmat(strong_viruses, strong_rate, 1) -...
        (rand(int32(n_strong .* strong_rate), 3).*intensity.*repmat(strong_viruses, strong_rate, 1));
    % Replicate weak viruses
    wp = repmat(weak_viruses, weak_rate, 1) +...
        (repmat(weak_viruses, weak_rate, 1).*rand(int32(n_weak .* weak_rate), 3)./intensity_weak);
    wn = repmat(weak_viruses, weak_rate, 1) -...
        (repmat(weak_viruses, weak_rate, 1).*rand(int32(n_weak .* weak_rate), 3)./intensity_weak);
    
    % New viruses
    new_viruses(:, :) = [sp; sn; wp; wn; strong_viruses; weak_viruses];
    % Evaluate and sort
    f = zeros(1, length(new_viruses));
    for i=1:length(new_viruses)
        new_viruses(i, :) = clip(new_viruses(i, :), x_min, x_max);
        f(i) = objective_function(new_viruses(i, :), wr, system, sensor);
    end
    [f, idx] = sort(f);
    new_viruses = new_viruses(idx, :);
end