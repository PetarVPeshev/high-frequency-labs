close all;
clear;
clc;

if ~exist([pwd() '\figures'], 'dir')
    mkdir('figures');
end

if ~exist([pwd() '\figures\meas1_S21'], 'dir')
    mkdir('figures\meas1_S21');
end

if ~exist([pwd() '\figures\meas2_S21'], 'dir')
    mkdir('figures\meas2_S21');
end

if ~exist([pwd() '\figures\meas3_S21'], 'dir')
    mkdir('figures\meas3_S21');
end

if ~exist([pwd() '\figures\meas4_S21'], 'dir')
    mkdir('figures\meas4_S21');
end

if ~exist([pwd() '\figures\meas5_S21'], 'dir')
    mkdir('figures\meas5_S21');
end

if ~exist([pwd() '\figures\meas6_S21'], 'dir')
    mkdir('figures\meas6_S21');
end

if ~exist([pwd() '\figures\meas7_S21'], 'dir')
    mkdir('figures\meas7_S21');
end

meas_dir = 'measurements';
meas1_dir = '1_Horn_Measurement_dist9cm_probe';
meas2_dir = '2_Horn2horn_dist14p3667cm';
meas3_dir = '3_Probe2Probe_dist9cm';
meas4_dir = '4_Lens2Probe_dist6p7cm';
meas5_dir = '5_Lens2Lens_dist6p1cm';
meas6_dir = '6_Lens2Probe_dist10cm';
meas7_dir = '7_Lens2Horn_dist10cm';

meas1_max_t = 0.78 * 1e-6;
meas2_max_t = 0.9 * 1e-6;
meas3_max_t = 0.95 * 1e-6;
meas4_max_t = 0.95 * 1e-6;
meas5_max_t = 0.95 * 1e-6;
meas6_max_t = 1.15 * 1e-6;
meas7_max_t = 0.9 * 1e-6;

%% READ MEASUREMENTS
[~, meas1] = read_meas(meas_dir, meas1_dir, 'Plane');
meas2 = read_meas(meas_dir, meas2_dir, 'Broadside');
meas3 = read_meas(meas_dir, meas3_dir, 'Broadside');
[~, meas4] = read_meas(meas_dir, meas4_dir, 'Plane');
% Measurement 5 has no frequency
load([meas_dir '\' meas5_dir '.mat']);
meas5 = struct('x', 0, 'freq', meas3.freq, ...
    'num_freq_pts', meas3.num_freq_pts, 'S11', S11, 'S12', S12, ...
    'S21', S21, 'S22', S22);
[~,  meas6] = read_meas(meas_dir, meas6_dir, 'Plane');
% Measurement 7 has no frequency
load([meas_dir '\' meas7_dir '.mat']);
meas7 = struct('x', 0, 'freq', meas5.freq, ...
    'num_freq_pts', meas5.num_freq_pts, 'S11', S11, 'S12', S12, ...
    'S21', S21, 'S22', S22);
% Clear unwanted data
clear('Distance', 'S11', 'S12', 'S21', 'S22');

%% BROADSIDE STRUCTS
meas1 = meas1(ceil(length(meas1) / 2));
meas4 = meas4(ceil(length(meas4) / 2));
meas6 = meas6(ceil(length(meas6) / 2));

%% TIME GATE
% Measurement 1
meas1_save_dir = 'figures\meas1_S21';
meas1 = get_time_gate(meas1, meas1_max_t, 'PlotS21', meas1_save_dir);
meas1_S21 = openfig([meas1_save_dir '\S21_w_and_wo_tg_x_0mm.fig']);
% Measurement 2
meas2_save_dir = 'figures\meas2_S21';
meas2 = get_time_gate(meas2, meas2_max_t, 'PlotS21', meas2_save_dir);
meas2_S21 = openfig([meas2_save_dir '\S21_w_and_wo_tg_x_0mm.fig']);
% Measurement 3
meas3_save_dir = 'figures\meas3_S21';
meas3 = get_time_gate(meas3, meas3_max_t, 'PlotS21', meas3_save_dir);
meas3_S21 = openfig([meas3_save_dir '\S21_w_and_wo_tg_x_0mm.fig']);
% Measurement 4
meas4_save_dir = 'figures\meas4_S21';
meas4 = get_time_gate(meas4, meas4_max_t, 'PlotS21', meas4_save_dir);
meas4_S21 = openfig([meas4_save_dir '\S21_w_and_wo_tg_x_0mm.fig']);
% Measurement 5
meas5_save_dir = 'figures\meas5_S21';
meas5 = get_time_gate(meas5, meas5_max_t, 'PlotS21', meas5_save_dir);
meas5_S21 = openfig([meas5_save_dir '\S21_w_and_wo_tg_x_0mm.fig']);
% Measurement 6
meas6_save_dir = 'figures\meas6_S21';
meas6 = get_time_gate(meas6, meas6_max_t, 'PlotS21', meas6_save_dir);
meas6_S21 = openfig([meas6_save_dir '\S21_w_and_wo_tg_x_0mm.fig']);
% Measurement 7
meas7_save_dir = 'figures\meas7_S21';
meas7 = get_time_gate(meas7, meas7_max_t, 'PlotS21', meas7_save_dir);
meas7_S21 = openfig([meas7_save_dir '\S21_w_and_wo_tg_x_0mm.fig']);

%% S-PARAMETERS PLOT
% Measurement 1
meas1_sparam_fig = plot_time_gate(meas1, ...
    'Measurement 1 S-Parameters @ Broadside');
saveas(meas1_sparam_fig, 'figures\meas1_S21\meas1_Sparam.fig');
% Measurement 2
meas2_sparam_fig = plot_time_gate(meas2, ...
    'Measurement 2 S-Parameters @ Broadside');
saveas(meas2_sparam_fig, 'figures\meas2_S21\meas2_Sparam.fig');
% Measurement 3
meas3_sparam_fig = plot_time_gate(meas3, ...
    'Measurement 3 S-Parameters @ Broadside');
saveas(meas3_sparam_fig, 'figures\meas3_S21\meas3_Sparam.fig');
% Measurement 4
meas4_sparam_fig = plot_time_gate(meas4, ...
    'Lens-To-Probe Without Plano-Convex Lens S-Parameters @ Broadside');
saveas(meas4_sparam_fig, 'figures\meas4_S21\meas4_Sparam.fig');
% Measurement 5
meas5_sparam_fig = plot_time_gate(meas5, ...
    'Lens-To-Lens S-Parameters @ Broadside');
saveas(meas5_sparam_fig, 'figures\meas5_S21\meas5_Sparam.fig');
% Measurement 6
meas6_sparam_fig = plot_time_gate(meas6, ...
    'Lens-To-Probe With Plano-Convex Lens S-Parameters @ Broadside');
saveas(meas6_sparam_fig, 'figures\meas6_S21\meas6_Sparam.fig');
% Measurement 7
meas7_sparam_fig = plot_time_gate(meas7, ...
    'Lens-To-Horn With Plano-Convex Lens S-Parameters @ Broadside');
saveas(meas7_sparam_fig, 'figures\meas7_S21\meas7_Sparam.fig');

%% PLOT COUPLING
freq_GHz = meas1.freq * 1e-9;
fig = figure('Position', [100 100 800 400]);
subplot(2, 1, 1);
plot(freq_GHz, 20 * log10(abs(meas1.S12)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 1');
hold on;
plot(freq_GHz, 20 * log10(abs(meas2.S12)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 2');
hold on;
plot(freq_GHz, 20 * log10(abs(meas3.S12)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 3');
hold on;
plot(freq_GHz, 20 * log10(abs(meas4.S12)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 4');
hold on;
plot(freq_GHz, 20 * log10(abs(meas5.S12)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 5');
hold on;
plot(freq_GHz, 20 * log10(abs(meas6.S12)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 6');
hold on;
plot(freq_GHz, 20 * log10(abs(meas7.S12)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 7');
grid on;
xlim([min(freq_GHz) max(freq_GHz)]);
legend show;
legend('location', 'bestoutside');
ylabel('|S_{12}| / dB');
title('Non-Time-Gated');
subplot(2, 1, 2);
plot(freq_GHz, 20 * log10(abs(meas1.S12_tg)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 1');
hold on;
plot(freq_GHz, 20 * log10(abs(meas2.S12_tg)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 2');
hold on;
plot(freq_GHz, 20 * log10(abs(meas3.S12_tg)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 3');
hold on;
plot(freq_GHz, 20 * log10(abs(meas4.S12_tg)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 4');
hold on;
plot(freq_GHz, 20 * log10(abs(meas5.S12_tg)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 5');
hold on;
plot(freq_GHz, 20 * log10(abs(meas6.S12_tg)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 6');
hold on;
plot(freq_GHz, 20 * log10(abs(meas7.S12_tg)), 'LineWidth', 2.0, ...
    'DisplayName', 'meas 7');
grid on;
xlim([min(freq_GHz) max(freq_GHz)]);
legend show;
legend('location', 'bestoutside');
xlabel('f / GHz');
ylabel('|S_{12}| / dB');
title('Time-Gated');
sgtitle('Measurement Setups Coupling', 'FontWeight', 'bold', ...
    'FontSize', 12);
saveas(gcf, 'figures\coupling.fig');
