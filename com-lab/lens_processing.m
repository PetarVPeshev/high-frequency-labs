nf_lens_processing;

close all;
clear;
clc;

if ~exist([pwd() '\figures'], 'dir')
    mkdir('figures');
end

if ~exist([pwd() '\figures\lens2horn_S21'], 'dir')
    mkdir('figures\lens2horn_S21');
end

if ~exist([pwd() '\figures\lens2probe_S21'], 'dir')
    mkdir('figures\lens2probe_S21');
end

processing_dir = 'processing';
meas_dir = 'measurements';
dir_data_file = 'export_dir_theta_201pts_freq_801pts';
probe_meas_broad = '3_Probe2Probe_dist9cm';
lens_meas_plane = '6_Lens2Probe_dist10cm';

c = physconst('LightSpeed');
d_probe2probe = 9 * 1e-2;
d_lens2probe = 10 * 1e-2;
D = 30 * 1e-3;

lens_max_t = 1.15 * 1e-6;
probe_max_t = 0.95 * 1e-6;

%% LOAD DATA
load([processing_dir '\' dir_data_file '.mat']);

%% READ MEASUREMENTS
% Probe2Probe @ broadside
probe_broad = read_meas(meas_dir, probe_meas_broad, 'Broadside');
% Lens2Probe @ plane
[lens_freq, lens_x] = read_meas(meas_dir, lens_meas_plane, 'Plane');

%% TIME GATE
% Probe2Probe @ broadside
probe_broad = get_time_gate(probe_broad, probe_max_t);
% Lens2Probe @ plane
S21_plot_lens_plane_dir = 'figures\lens2probe_S21';
[lens_x, lens_freq] = get_time_gate(lens_x, lens_max_t, ...
    'GetFreqStruct', lens_freq, 'PlotS21', S21_plot_lens_plane_dir);
plane_hornS21 = openfig([S21_plot_lens_plane_dir ...
    '\S21_w_and_wo_tg_x_0mm.fig']);

%% FAR-FIELD
lens_eff = get_eff(lens_freq, d_lens2probe, 'TimeGated');

%% IDEAL ANTENNA DIRECTIVITY
wavelength = c ./ (freq_GHz * 1e9);
ideal_dir = (pi * D ./ wavelength) .^ 2;

%% GAIN
% Probe2Probe @ broadside
probe_gain = get_gain(probe_broad, d_probe2probe, 'SameAntenna');
% Lens2Probe @ broadside
lens_gain = get_gain(lens_x(26), d_lens2probe, ...
    'DifferentAntennas', probe_gain.gain);

%% GAIN FIT
gain_fitobject = fit(probe_broad.freq', lens_gain.gain', 'poly2');
lens_gain_fit = gain_fitobject.p1 * (probe_broad.freq .^ 2) ...
    + gain_fitobject.p2 * probe_broad.freq + gain_fitobject.p3;

%% FAR-FIELD PLOT
eff_tg = plot_eff(['Lens Radiation Pattern With Focusing Lens @ \phi =' ...
    ' 0 deg, R = ' num2str(d_lens2probe * 1e3) ' mm'], lens_eff(1), ...
    lens_eff(501), lens_eff(1001));
xticks(-12 : 3 : 12);
xlim([-12 12]);
ylim([-40 0]);
saveas(eff_tg, 'figures\lens_eff_lens2probe.fig');

%% PLOT DIRECTIVITY AND GAIN
freq = probe_broad.freq;
figure('Position', [250 250 800 400]);
plot(freq_GHz, 10 * log10(ideal_dir), '--', 'LineWidth', 2.0, ...
    'Color', [0 0 0], 'DisplayName', 'ideal dir');
hold on;
plot(freq_GHz, 10 * log10(lens_dir), 'LineWidth', 2.0, ...
    'Color', [0 0.4470 0.7410], 'DisplayName', 'dir');
hold on;
plot(freq * 1e-9, 10 * log10(lens_gain.gain), 'LineWidth', 2.0, ...
    'Color', [0.8500 0.3250 0.0980], 'DisplayName', ['gain, ' ...
    'lens-to-probe, R = ' num2str(d_lens2probe * 1e3) ' mm']);
hold on;
plot(freq * 1e-9, 10 * log10(lens_gain_fit), '--', 'LineWidth', 2.0, ...
    'Color', [0.9290 0.6940 0.1250], 'DisplayName', ['gain fit, ' ...
    'lens-to-probe, R = ' num2str(d_lens2probe * 1e3) ' mm']);
grid on;
legend show;
legend('location', 'bestoutside');
xlabel('freq / GHz');
ylabel('D / dB');
title(['Maximum Lens Directivity @ R = ' num2str(Rff) ' m']);
saveas(gcf, 'figures\lens_dir.fig');
