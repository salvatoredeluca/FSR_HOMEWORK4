clc
close all
clear all

% Crea la cartella 'plot' se non esiste
if ~exist('plot', 'dir')
    mkdir('plot');
end

% Parameters
g = 9.81;          % gravity (m/s^2)
l = 1.0;           % leg length (m) %%MODIFY HERE%% 
alpha = pi/8;      % half inter-leg angle (rad) %%MODIFY HERE%% 
gamma = 0.08;      % slope angle (rad) %%MODIFY HERE%% 

% Initial conditions
thetadot0 = 1; %%MODIFY HERE%% 
if (thetadot0 >= 0)
    theta0 = gamma - alpha;
else
    theta0 = gamma + alpha;
end

double_support = 0;

y0 = [theta0; thetadot0];

% Simulation settings
t0 = 0;    % initial time
tf = 25;   % final time
dt = 0.01; % max step time

% Time/state storage
T = [];
Y = [];

while t0 < tf
    options = odeset('Events', @(t, y) impact_event(t, y, alpha, gamma), 'MaxStep', dt);
    [t, y, te, ye, ie] = ode45(@(t, y) dynamics(t, y, g, l, double_support), [t0 tf], y0, options);

    T = [T; t];
    Y = [Y; y];

    if ~isempty(te)
        [y0, double_support] = impact_map(ye, alpha, g, l); % apply impact map
        t0 = te;
    else
        break;
    end
end

% --- PLOT TEMPORALE ---
figure(1)
plot(T, Y(:,1), 'b', 'DisplayName', '$\theta$ (rad)','LineWidth',1.2);
hold on;
plot(T, Y(:,2), 'r', 'DisplayName', '$\dot{\theta}$ (rad/s)','LineWidth',1.2);
xlabel('Time (s)', 'Interpreter', 'latex');
ylabel('State', 'Interpreter', 'latex');
title('Rimless Wheel Dynamics', 'Interpreter', 'latex');
legend('show', 'Interpreter', 'latex', 'Location', 'best');
grid on;
print('-depsc', fullfile('plot', 'temporale.eps'));   

% --- PLOT DI FASE ---
figure(2)
plot(Y(:,1), Y(:,2), 'b', 'DisplayName', '$\theta$ (rad)');
hold on;
plot(Y(1,1), Y(1,2), 'r*', 'LineWidth', 2, 'DisplayName', 'Initial Point');
xlabel('$\theta$ (rad)', 'Interpreter', 'latex');
ylabel('$\dot{\theta}$ (rad/s)', 'Interpreter', 'latex');
title('Rimless Wheel Limit Cycle', 'Interpreter', 'latex');
legend('show', 'Interpreter', 'latex', 'Location', 'best');
grid on;
print('-depsc', fullfile('plot', 'fase.eps'));  

% --- LIMIT CYCLE ---
if thetadot0 > 0.98
    r = size(Y, 1);
    figure(3)
    plot(Y(r/2:end,1), Y(r/2:end,2), 'k', 'DisplayName', '$\theta$ (rad)', 'LineWidth', 1.2);
    hold on;
    xlabel('$\theta$ (rad)', 'Interpreter', 'latex');
    ylabel('$\dot{\theta}$ (rad/s)', 'Interpreter', 'latex');
    title('Limit Cycle', 'Interpreter', 'latex');
    grid on;
    print('-depsc', fullfile('plot', 'limit_cycle.eps')); 
end

% --- DYNAMICS FUNCTION ---
function dydt = dynamics(~, y, g, l, ds)
    theta = y(1);
    thetadot = y(2);
    if ~ds
        dtheta = thetadot;
        dthetadot = (g/l) * sin(theta);
    else
        dtheta = 0;
        dthetadot = 0;
    end
    dydt = [dtheta; dthetadot];
end

% --- IMPACT EVENT FUNCTION ---
function [value, isterminal, direction] = impact_event(~, y, alpha, gamma)
    value = [y(1) - alpha - gamma; y(1) - gamma + alpha];
    isterminal = [1; 1]; % Stop integration
    direction = [1; -1]; % Detect when increasing or decreasing
end

% --- IMPACT MAP FUNCTION ---
function [yplus, ds] = impact_map(y_minus, alpha, g, l)
    if y_minus(2) >= 0
        theta_plus = y_minus(1) - 2 * alpha;
    else
        theta_plus = y_minus(1) + 2 * alpha;
    end
    thetadot_plus = cos(2 * alpha) * y_minus(2);
    if abs(thetadot_plus) < 0.01 * sqrt(g / l)
        thetadot_plus = 0;
        ds = 1;
    else
        ds = 0;
    end
    yplus = [theta_plus; thetadot_plus];
end
