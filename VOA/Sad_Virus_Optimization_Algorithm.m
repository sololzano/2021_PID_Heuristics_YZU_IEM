% SadVOA parameters
viruses = 5; % Initial number of viruses
x_min = [0., 0., 0.]; % Kp, Ki, Kd
x_max = [100., 100., 50.]; % Kp, Ki, Kd 
strong_percent = 0.4; % Percentage of strong viruses in the cell
strong_rate = 1; % Replicas from strong viruses
weak_rate = 2; % Replicas from weak viruses
intensity = 0.5; % Intensity of replicas from strong viruses
decay = 0.95; % Decaying ratio of intensity
survivor_percent = 0.3; % Percentage of virus surviving after antivirus
kind = "FIXED"; % RANDOM or FIXED
iterations = 20; % Stopping criteria
mode = "NORMAL"; % NORMAL, DYNAMIC, SAD
wr = [1., 1., 1., 1.]; % Weights Tr, Os, Ts, Dc
system = "PENDULUM"; % System to evaluate

tic;
    [gb_array, x] = sad_voa(viruses, x_min, x_max, strong_percent,...
        strong_rate, weak_rate, intensity, decay, survivor_percent,...
        kind, iterations, mode, wr, system);
elapsed_time = toc;
disp(elapsed_time);
% Get global best array
z = zeros(1, iterations);
for j=1:iterations
    z(1, j) = objective_function(gb_array(j, :), wr, system);
end

% Step response of PSO System
gb = gb_array(end, :);
ss_tf = get_system(system);
PID = pid(gb(1, 1), gb(1, 2), gb(1, 3));
SS = feedback(PID * ss_tf, 1);
figure();
t = 0:0.1:5;
step(SS, t);
title('SadVOA');
set(findall(gcf, 'Type', 'line'), 'LineWidth', 1.2);
disp(objective_function(gb));
disp(gb);

% Global best behavior
figure();
plot(z, 'LineWidth', 1.5);
title('Global best behavior');