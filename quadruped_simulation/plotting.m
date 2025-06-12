%% Script per Plottare Risultati della Simulazione
close all;

% Abilita LaTeX per tutti i testi
set(0, 'defaultTextInterpreter', 'latex');
set(0, 'defaultAxesTickLabelInterpreter', 'latex');
set(0, 'defaultLegendInterpreter', 'latex');

%% FIGURA 1: POSIZIONE (3 subplot)
figure(1);

subplot(3, 1, 1);
plot(tout, Xout(:,1), 'r-', 'LineWidth', 1); hold on;
plot(tout, Xdout(:,1), 'r--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$x$ [m]', 'FontSize', 10);

subplot(3, 1, 2);
plot(tout, Xout(:,2), 'm-', 'LineWidth', 1); hold on;
plot(tout, Xdout(:,2), 'm--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$y$ [m]', 'FontSize', 10);

subplot(3, 1, 3);
plot(tout, Xout(:,3), 'b-', 'LineWidth', 1); hold on;
plot(tout, Xdout(:,3), 'b--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$z$ [m]', 'FontSize', 10);

sgtitle('Position', 'FontSize', 13);

%% FIGURA 2: VELOCITÀ LINEARE
figure(2);

subplot(3, 1, 1);
plot(tout, Xout(:,4), 'r-', 'LineWidth', 1); hold on;
plot(tout, Xdout(:,4), 'r--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$\dot{x}$ [m/s]', 'FontSize', 10);

subplot(3, 1, 2);
plot(tout, Xout(:,5), 'm-', 'LineWidth', 1); hold on;
plot(tout, Xdout(:,5), 'm--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$\dot{y}$ [m/s]', 'FontSize', 10);

subplot(3, 1, 3);
plot(tout, Xout(:,6), 'b-', 'LineWidth', 1); hold on;
plot(tout, Xdout(:,6), 'b--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$\dot{z}$ [m/s]', 'FontSize', 10);

sgtitle('Linear Velocity', 'FontSize', 13);

%% FIGURA 3: VELOCITÀ ANGOLARE
figure(3);

subplot(3, 1, 1);
plot(tout, Xout(:,16), 'r-', 'LineWidth', 1); hold on;
plot(tout, Xdout(:,16), 'r--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$\omega_x$ [rad/s]', 'FontSize', 10);

subplot(3, 1, 2);
plot(tout, Xout(:,17), 'm-', 'LineWidth', 1); hold on;
plot(tout, Xdout(:,17), 'm--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$\omega_y$ [rad/s]', 'FontSize', 10);

subplot(3, 1, 3);
plot(tout, Xout(:,18), 'b-', 'LineWidth', 1); hold on;
plot(tout, Xdout(:,18), 'b--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$\omega_z$ [rad/s]', 'FontSize', 10);

sgtitle('Angular Velocity', 'FontSize', 13);

%% FIGURA 4: FORZE VERTICALI
figure(4);
set(gcf, 'Position', [50 300 600 500]);

tiledlayout(4,1, 'TileSpacing', 'compact', 'Padding', 'compact');

% Dati ZOH per le forze
t_zoh = repelem(tout, 2);
t_zoh(1) = [];
t_zoh(end+1) = t_zoh(end);
U_zoh = repelem(Uout, 2, 1);

% Subplot 1: Forza Z1
nexttile;
plot(t_zoh, U_zoh(:,3), 'r-', 'LineWidth', 1); hold on;
plot(tout, Udout(:,3), 'r--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$F_{z1}$ [N]', 'FontSize', 10);

% Subplot 2: Forza Z2
nexttile;
plot(t_zoh, U_zoh(:,6), 'm-', 'LineWidth', 1); hold on;
plot(tout, Udout(:,6), 'm--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$F_{z2}$ [N]', 'FontSize', 10);

% Subplot 3: Forza Z3
nexttile;
plot(t_zoh, U_zoh(:,9), 'b-', 'LineWidth', 1); hold on;
plot(tout, Udout(:,9), 'b--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$F_{z3}$ [N]', 'FontSize', 10);

% Subplot 4: Forza Z4
nexttile;
plot(t_zoh, U_zoh(:,12), 'k-', 'LineWidth', 1); hold on;
plot(tout, Udout(:,12), 'k--', 'LineWidth', 1);
grid on;
xlabel('Time [s]', 'FontSize', 10);
ylabel('$F_{z4}$ [N]', 'FontSize', 10);

sgtitle('Ground Reaction Forces', 'FontSize', 13, 'Interpreter', 'latex');

%% ESPORTAZIONE IN EPS
export_eps = true;

if export_eps
    % Crea la directory 'plot' se non esiste
    output_dir = 'plot';
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    % Esporta le figure nella cartella 'plot'
    figure(1); print(fullfile(output_dir, 'posizione.eps'), '-depsc2', '-r300');
    figure(2); print(fullfile(output_dir, 'velocita_lineare.eps'), '-depsc2', '-r300');
    figure(3); print(fullfile(output_dir, 'velocita_angolare.eps'), '-depsc2', '-r300');
    figure(4); print(fullfile(output_dir, 'forze_verticali.eps'), '-depsc2', '-r300');

    fprintf('File EPS esportati nella cartella "%s":\n', output_dir);
    fprintf('- posizione.eps\n');
    fprintf('- velocita_lineare.eps\n');
    fprintf('- velocita_angolare.eps\n');
    fprintf('- forze_verticali.eps\n');
end
