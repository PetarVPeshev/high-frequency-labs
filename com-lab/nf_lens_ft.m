close all;
clear;
clc;

if ~exist([pwd() '\processing'], 'dir')
    mkdir('processing');
end

meas_dir = 'measurements';
nf_meas = 'NF_LensAntenna_Copol_60x60mm_1mm_6401p';

max_t = 0.83 * 1e-6;
Ntheta = 201;
Nphi = 401;

%% READ MEASUREMENTS
[meas_freq, meas_xy, meas_plane] = read_meas(meas_dir, nf_meas, 'Plane');
% Decimate frequency points
[meas_freq, meas_xy] = decimate_freq_pts(meas_freq, meas_xy, ...
    meas_plane, 8);

%% TIME GATE
[meas_xy, meas_freq] = get_time_gate(meas_xy, max_t, ...
    'GetFreqStruct', meas_freq);

%% SPHERICAL GRID
theta = linspace(0, pi / 2 - 0.1 * pi / 180, Ntheta);
phi = linspace(0, 2 * pi, Nphi);
[theta, phi] = meshgrid(theta, phi);

%% WAVE VECTOR
% Frequency list
freq = NaN(1, length(meas_freq));
for freq_idx = 1 : 1 : length(meas_freq)
    freq(freq_idx) = meas_freq(freq_idx).freq;
end
% Wave vector
wave_vector = get_wave_vector(freq, theta, phi);

%% APERTURE FT
meas_freq = get_aperture_ft(meas_freq, meas_plane, wave_vector, ...
    'TimeGated');

%% S-PARAMETERS PLOT
nf_sparam_fig = plot_time_gate(meas_xy(31, 31), ...
    'Near-Field S-Parameters @ Broadside of Plane Measurement');
saveas(nf_sparam_fig, 'figures\nf_Sparam.fig');

%% SAVE STRUCTURES AND VARIABLES
save(['processing\export_ft_theta_' num2str(size(theta, 2)) ...
    'pts_freq_' num2str(length(freq)) 'pts.mat'], 'meas_ff', ...
    'meas_freq', 'meas_plane', 'meas_xy', 'wave_vector', 'theta', 'phi');
