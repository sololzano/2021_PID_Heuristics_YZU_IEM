% Objective function
function v = objective_function(x, w, system)
    arguments
        x (1, 3) double = [0., 0., 0.];
        w (1, 4) double = [1, 1, 1, 1];
        system string = "PITCH";
    end

    % System transfer function
    sr = get_system(system);
    
    % PID controller
    C = pid(x(1), x(2), x(3));

    % Step response for system
    T_sys = feedback(sr * C, 1);
    S = stepinfo(T_sys);
    tr = S.RiseTime;
    os = S.Overshoot;
    ts = S.SettlingTime;
    dc = 1 - dcgain(T_sys);
    % Check for non-feasible solutions
    if isnan(tr)
        tr = 10;
    end
    if isnan(os)
        os = 100;
    end
    if isnan(ts)
        ts = 25;
    end
    if isnan(dc)
        dc = 10;
    end
    v = w(1)*tr + w(2)*os + w(3)*ts + w(4)*dc;
end