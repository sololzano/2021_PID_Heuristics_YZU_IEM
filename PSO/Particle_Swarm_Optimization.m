% PSO parameters
p = 5; % Population size
x_min = [0., 0., 0.]; % Kp, Ki, Kd
x_max = [100., 100., 50.]; % Kp, Ki, Kd
v_max = [20., 20., 20.]; % Kp, Ki, Kd
iterations = 30; 
c1 = 2.; % Memory trust
c2 = 2.; % Leader trust
w = 0.2; % Inertia 
wr = [1., 1., 1., 1.]; % Weights Tr, Os, Ts, Dc
system = "PENDULUM"; % System to evaluate

% Start tests
tic;
[gb, gb_array, gb_idx, x] = pso...
    (p, x_min, x_max, v_max, iterations, c1, c2, w, wr, system);
elapsed_time = toc;

% Get global best array
z = zeros(1, iterations);
for j=1:iterations
    z(1, j) = objective_function(gb_array(j, :), wr, system);
end

% Step response of PSO System
ss_tf = get_system(system);
PID = pid(gb(1, 1), gb(1, 2), gb(1, 3));
SS = feedback(PID * ss_tf, 1);
figure();
t = 0:0.1:5;
step(SS, t);
title('PSO');
set(findall(gcf, 'Type', 'line'), 'LineWidth', 1.2);
disp(objective_function(gb));
disp(gb);

% Global best behavior
figure();
plot(z, 'LineWidth', 1.5);
title('Global best behavior');