function [new_population, new_f] = antivirus...
    (population, f, survivor_percent, kind)
    arguments
        population(:, 3) double;
        f(1, :) double;
        survivor_percent double = 0.6;
        kind string = "FIXED";
    end
    
    % Sort if not sorted
    [f, idx] = sort(f);
    population = population(idx, :);
    
    % FIXED
    if kind == "FIXED"
        n = int32(length(population) * survivor_percent);
        new_population = population(1:n, :);
        new_f = f(1:n);
    end
    % RANDOM
    if kind == "RANDOM"
        n = int32(rand()*survivor_percent*length(population));
        new_population = population(1:n, :);
        new_f = f(1:n);
    end

    % Avoid more than 5 viruses for memory's sake
    n = min(20, length(new_population));
    new_population = new_population(1:n, :);
    new_f = new_f(1:n);
end