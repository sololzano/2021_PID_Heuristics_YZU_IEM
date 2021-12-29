function [new_viruses, f] = replicate...
    (population, strong_percent, strong_rate, weak_rate,... 
    intensity, wr, system)
    arguments
        population(:, 3) double;
        strong_percent double = 0.4;
        strong_rate int8 = 1;
        weak_rate int8 = 2;
        intensity double = 2.;
        wr(1, 4) double = [1., 1., 1., 1.];
        system string = "PITCH";
    end
    n_strong = int32(length(population) * strong_percent);
    strong_viruses = population(1:n_strong, :);
    weak_viruses = population(n_strong+1:end, :);

    % Replicate strong viruses
    for i=1:strong_rate
        sp = strong_viruses + (rand(n_strong, 3)*intensity);
        sn = strong_viruses - (rand(n_strong, 3)*intensity);
        population = [population; sp; sn]; %#ok<AGROW> 
    end

    % Replicate weak viruses
    for i=1:weak_rate
        wp = weak_viruses + rand(length(weak_viruses), 3)/intensity;
        wn = weak_viruses - rand(length(weak_viruses), 3)/intensity;
        population = [population; wp; wn]; %#ok<AGROW> 
    end
    new_viruses = population;

    % Evaluate and sort
    f = zeros(1, length(new_viruses));
    for i=1:length(new_viruses)
        f(i) = objective_function(new_viruses(i, :), wr, system);
    end
    [f, idx] = sort(f);
    new_viruses = new_viruses(idx, :);
end