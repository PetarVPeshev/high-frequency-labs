nf_lens_ft;

close all;
clear;
clc;

if ~exist([pwd() '\figures'], 'dir')
    mkdir('figures');
end

processing_dir = 'processing';
ft_data_file = 'export_ft_theta_201pts_freq_801pts';

Rff = 1;
D = 30 * 1e-3;

%% LOAD DATA
load([processing_dir '\' ft_data_file '.mat']);

%% FAR-FIELD
% Measurement
lens_ff = get_ff_from_nf(meas_freq, wave_vector, theta, phi, Rff);
% Uniform circular current distribution
airy_ff(3) = struct('freq', [], 'E', []);
airy_ff(1) = get_airy_field(lens_ff(1).freq, D, theta, phi, Rff);
airy_ff(2) = get_airy_field(lens_ff(401).freq, D, theta, phi, Rff);
airy_ff(3) = get_airy_field(lens_ff(801).freq, D, theta, phi, Rff);

%% DIRECTIVITY
lens_dir = get_dir_from_nf(lens_ff, theta, phi, Rff);

%% FAR-FIELD PLOT
% Plot f = 140 GHz at phi = 0 deg
phi0_eff = plot_eff_from_nf(['Radiation Pattern @ f = ' ...
    num2str(lens_ff(1).freq * 1e-9) ' GHz, \phi = 0 deg, R = ' ...
    num2str(Rff) ' m'], 0, theta, phi, 'Compare', lens_ff(1), airy_ff(1));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi0_eff, 'figures\lens_eff_phi_0_140GHz_nf.fig');
% Plot f = 180 GHz at phi = 0 deg
phi0_eff = plot_eff_from_nf(['Radiation Pattern @ f = ' ...
    num2str(lens_ff(401).freq * 1e-9) ' GHz, \phi = 0 deg, R = ' ...
    num2str(Rff) ' m'], 0, theta, phi, 'Compare', lens_ff(401), ...
    airy_ff(2));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi0_eff, 'figures\lens_eff_phi_0_180GHz_nf.fig');
% Plot f = 220 GHz at phi = 0 deg
phi0_eff = plot_eff_from_nf(['Radiation Pattern @ f = ' ...
    num2str(lens_ff(801).freq * 1e-9) ' GHz, \phi = 0 deg, R = ' ...
    num2str(Rff) ' m'], 0, theta, phi, 'Compare', lens_ff(801), ...
    airy_ff(3));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi0_eff, 'figures\lens_eff_phi_0_220GHz_nf.fig');
% Plot f = 140 GHz at phi = 90 deg
phi0_eff = plot_eff_from_nf(['Radiation Pattern @ f = ' ...
    num2str(lens_ff(1).freq * 1e-9) ' GHz, \phi = 90 deg, R = ' ...
    num2str(Rff) ' m'], 90, theta, phi, 'Compare', lens_ff(1), airy_ff(1));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi0_eff, 'figures\lens_eff_phi_90_140GHz_nf.fig');
% Plot f = 180 GHz at phi = 90 deg
phi0_eff = plot_eff_from_nf(['Radiation Pattern @ f = ' ...
    num2str(lens_ff(401).freq * 1e-9) ' GHz, \phi = 90 deg, R = ' ...
    num2str(Rff) ' m'], 90, theta, phi, 'Compare', lens_ff(401), ...
    airy_ff(2));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi0_eff, 'figures\lens_eff_phi_90_180GHz_nf.fig');
% Plot f = 220 GHz at phi = 90 deg
phi0_eff = plot_eff_from_nf(['Radiation Pattern @ f = ' ...
    num2str(lens_ff(801).freq * 1e-9) ' GHz, \phi = 90 deg, R = ' ...
    num2str(Rff) ' m'], 90, theta, phi, 'Compare', lens_ff(801), ...
    airy_ff(3));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi0_eff, 'figures\lens_eff_phi_90_220GHz_nf.fig');
% Plot f = 140 GHz at phi = 45 deg
phi0_eff = plot_eff_from_nf(['Radiation Pattern @ f = ' ...
    num2str(lens_ff(1).freq * 1e-9) ' GHz, \phi = 45 deg, R = ' ...
    num2str(Rff) ' m'], 45, theta, phi, 'Compare', lens_ff(1), airy_ff(1));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi0_eff, 'figures\lens_eff_phi_45_140GHz_nf.fig');
% Plot f = 180 GHz at phi = 45 deg
phi0_eff = plot_eff_from_nf(['Radiation Pattern @ f = ' ...
    num2str(lens_ff(401).freq * 1e-9) ' GHz, \phi = 45 deg, R = ' ...
    num2str(Rff) ' m'], 45, theta, phi, 'Compare', lens_ff(401), ...
    airy_ff(2));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi0_eff, 'figures\lens_eff_phi_45_180GHz_nf.fig');
% Plot f = 220 GHz at phi = 45 deg
phi0_eff = plot_eff_from_nf(['Radiation Pattern @ f = ' ...
    num2str(lens_ff(801).freq * 1e-9) ' GHz, \phi = 45 deg, R = ' ...
    num2str(Rff) ' m'], 45, theta, phi, 'Compare', lens_ff(801), ...
    airy_ff(3));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi0_eff, 'figures\lens_eff_phi_45_220GHz_nf.fig');
% Plot lens far-field at phi = 0 deg
phi90_eff = plot_eff_from_nf(['Lens Radiation Pattern @ \phi = 0 deg,' ...
    ' R = ' num2str(Rff) ' m'], 0, theta, phi, 'Normal', lens_ff(1), ...
    lens_ff(401), lens_ff(801));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi90_eff, 'figures\lens_eff_phi_0_nf.fig');
% Plot lens far-field at phi = 90 deg
phi90_eff = plot_eff_from_nf(['Lens Radiation Pattern @ \phi = 90 deg,' ...
    ' R = ' num2str(Rff) ' m'], 90, theta, phi, 'Normal', lens_ff(1), ...
    lens_ff(401), lens_ff(801));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi90_eff, 'figures\lens_eff_phi_90_nf.fig');
% Plot lens far-field at phi = 45 deg
phi45_eff = plot_eff_from_nf(['Lens Radiation Pattern @ \phi = 45 deg,' ...
    ' R = ' num2str(Rff) ' m'], 45, theta, phi, 'Normal', lens_ff(1), ...
    lens_ff(401), lens_ff(801));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi45_eff, 'figures\lens_eff_phi_45_nf.fig');
% Plot airy far-field at phi = 0 deg
phi90_eff = plot_eff_from_nf(['Airy Radiation Pattern @ \phi = 0 deg,' ...
    ' R = ' num2str(Rff) ' m'], 0, theta, phi, 'Normal', airy_ff(1), ...
    airy_ff(2), airy_ff(3));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi90_eff, 'figures\airy_eff_phi_0_nf.fig');
% Plot airy far-field at phi = 90 deg
phi90_eff = plot_eff_from_nf(['Airy Radiation Pattern @ \phi = 90 deg,' ...
    ' R = ' num2str(Rff) ' m'], 90, theta, phi, 'Normal', airy_ff(1), ...
    airy_ff(2), airy_ff(3));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi90_eff, 'figures\airy_eff_phi_90_nf.fig');
% Plot airy far-field at phi = 45 deg
phi45_eff = plot_eff_from_nf(['Airy Radiation Pattern @ \phi = 45 deg,' ...
    ' R = ' num2str(Rff) ' m'], 45, theta, phi, 'Normal', airy_ff(1), ...
    airy_ff(2), airy_ff(3));
xticks(-30 : 5 : 30);
xlim([-30 30]);
ylim([-40 0]);
saveas(phi45_eff, 'figures\airy_eff_phi_45_nf.fig');

%% SAVE DIRECTIVITY
freq_GHz = meas_xy(1, 1).freq * 1e-9;
save(['processing\export_dir_theta_' num2str(size(theta, 2)) ...
    'pts_freq_' num2str(length(meas_freq)) 'pts.mat'], 'lens_dir', ...
    'freq_GHz', 'Rff');
