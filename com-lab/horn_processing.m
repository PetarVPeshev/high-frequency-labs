close all;
clear;
clc;

if ~exist([pwd() '\figures'], 'dir')
    mkdir('figures');
end

if ~exist([pwd() '\figures\Horn2Horn_S21'], 'dir')
    mkdir('figures\Horn2Horn_S21');
end

if ~exist([pwd() '\figures\Probe2Probe_S21'], 'dir')
    mkdir('figures\Probe2Probe_S21');
end

if ~exist([pwd() '\figures\Horn2Probe_S21'], 'dir')
    mkdir('figures\Horn2Probe_S21');
end

meas_dir = 'measurements';
horn_meas_plane = '1_Horn_Measurement_dist9cm_probe';
horn_meas_broad = '2_Horn2horn_dist14p3667cm';
probe_meas_broad = '3_Probe2Probe_dist9cm';

d_plane = 9 * 1e-2;
d_broad = 14.3667 * 1e-2;
d_probe = 9 * 1e-2;

horn_max_t = 0.9 * 1e-6;
probe_max_t = 0.95 * 1e-6;
plane_max_t = 0.78 * 1e-6;

%% READ MEASUREMENTS
% Horn2Horn @ broadside
horn_broad = read_meas(meas_dir, horn_meas_broad, 'Broadside');
% Probe2Probe @ broadside
probe_broad = read_meas(meas_dir, probe_meas_broad, 'Broadside');
% Horn2Probe @ plane
[horn_freq, horn_x] = read_meas(meas_dir, horn_meas_plane, 'Plane');

%% TIME GATE
% Horn2Horn @ broadside
S21_plot_horn_dir = 'figures\Horn2Horn_S21';
horn_broad = get_time_gate(horn_broad, horn_max_t, ...
    'PlotS21', S21_plot_horn_dir);
hornS21 = openfig([S21_plot_horn_dir '\S21_w_and_wo_tg_x_0mm.fig']);
% Probe2Probe @ broadside
S21_plot_probe_dir = 'figures\Probe2Probe_S21';
probe_broad = get_time_gate(probe_broad, probe_max_t, ...
    'PlotS21', S21_plot_probe_dir);
probeS21 = openfig([S21_plot_probe_dir '\S21_w_and_wo_tg_x_0mm.fig']);
% Horn2Probe @ plane
S21_plot_horn_plane_dir = 'figures\Horn2Probe_S21';
[horn_x, horn_freq] = get_time_gate(horn_x, plane_max_t, ...
    'GetFreqStruct', horn_freq, 'PlotS21', S21_plot_horn_plane_dir);
plane_hornS21 = openfig([S21_plot_horn_plane_dir ...
    '\S21_w_and_wo_tg_x_0mm.fig']);

%% FAR-FIELD
% Measured with probe, direct measurement and time gated
horn_eff = get_eff(horn_freq, d_plane, 'Measured');
horn_eff_tg = get_eff(horn_freq, d_plane, 'TimeGated');

%% DIRECTIVITY
% Measured with probe
horn_dir = get_dir(horn_eff_tg);

%% GAIN
% Horn2Horn @ broadside
horn_gain = get_gain(horn_broad, d_broad, 'SameAntenna');
% Probe2Probe @ broadside
probe_gain = get_gain(probe_broad, d_probe, 'SameAntenna');

%% S-PARAMETERS PLOT
% Horn2Horn @ broadside
horn2horn_fig = plot_time_gate(horn_broad, ...
    'Horn-To-Horn S-Parameters @ Broadside');
saveas(horn2horn_fig, 'figures\horn2horn_Sparam.fig');
% Probe2Probe @ broadside
probe2probe_fig = plot_time_gate(probe_broad, ...
    'Probe-To-Probe S-Parameters @ Broadside');
saveas(probe2probe_fig, 'figures\probe2probe_Sparam.fig');
% Horn2Probe @ broadside of plane
horn2probe_fig = plot_time_gate(horn_x(51), ...
    'Horn-To-Probe S-Parameters @ Broadside of Plane Measurement');
saveas(horn2probe_fig, 'figures\horn2probe_Sparam.fig');

%% FAR-FIELD PLOT
% Direct measurement
eff_non_tg = plot_eff(['Horn Radiation Pattern @ Non-Time-Gated, R = ' ...
    num2str(d_plane * 1e3) ' mm'], horn_eff(1), horn_eff(501), ...
    horn_eff(1001));
saveas(eff_non_tg, 'figures\horn_eff_non_tg.fig');
% Time gated
eff_tg = plot_eff(['Horn Radiation Pattern @ Time-Gated, R = ' ...
    num2str(d_plane * 1e3) ' mm'], horn_eff_tg(1), horn_eff_tg(501), ...
    horn_eff_tg(1001));
saveas(eff_tg, 'figures\horn_eff_tg.fig');

%% GAIN PLOT
freq_GHz = horn_broad.freq * 1e-9;
dir_db = NaN(1, length(horn_dir));
for dir_idx = 1 : 1 : length(horn_dir)
    dir_db(dir_idx) = 10 * log10(horn_dir(dir_idx).dir);
end
figure('Position', [250 250 800 400]);
plot(freq_GHz, dir_db, 'LineWidth', 2.0, ...
    'DisplayName', ['dir, horn-to-probe, R = ' ...
    num2str(d_plane * 1e3) ' mm']);
hold on;
plot(freq_GHz, 10 * log10(horn_gain.gain), 'LineWidth', 2.0, ...
    'DisplayName', ['gain, horn-to-horn, R = ' ...
    num2str(round(d_broad, 2) * 1e3) ' mm']);
grid on;
legend show;
legend('location', 'bestoutside');
xlabel('freq / GHz');
ylabel('G or D / dB');
title('Horn Gain and Directivity @ Broadside');
saveas(gcf, 'figures\horn_dir_and_gain.fig');
