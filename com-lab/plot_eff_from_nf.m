function fig = plot_eff_from_nf(title_label, plane, theta, phi, ...
    norm_or_comp, varargin)
%PLOT_EFF Summary of this function goes here
%   Detailed explanation goes here
    [row_idx_1, ~] = find(round(phi * 180 / pi, 2) == plane);
    row_idx_1 = row_idx_1(1);
    [row_idx_2, ~] = find(round(phi * 180 / pi, 2) == (plane + 180));
    row_idx_2 = row_idx_2(1);
    theta_plot = NaN(1, size(theta, 2) * 2);
    theta_plot(1 : size(theta, 2)) = - fliplr(theta(1, :)) * 180 / pi;
    theta_plot(size(theta, 2) + 1 : end) = theta(1, :) * 180 / pi;
    fig = figure('Position', [250 250 800 400]);
    if strcmp(norm_or_comp, 'Normal')
        for arg_idx = 1 : 1 : length(varargin)
            Et = sqrt(abs(varargin{arg_idx}.E(:, :, 1)) .^ 2 ...
                + abs(varargin{arg_idx}.E(:, :, 2)) .^ 2 ...
                + abs(varargin{arg_idx}.E(:, :, 3)) .^ 2);
            Et_db = 20 * log10(Et / max(Et, [], 'all'));
            E_plot = NaN(1, size(theta, 2) * 2);
            E_plot(1 : size(theta, 2)) = fliplr(Et_db(row_idx_2, :));
            E_plot(size(theta, 2) + 1 : end) = Et_db(row_idx_1, :);
            plot(theta_plot, E_plot, 'LineWidth', 2.0, ...
                'DisplayName', ['|E^{FF}|, f = ' ...
                num2str(varargin{arg_idx}.freq * 1e-9) ' GHz']);
            hold on;
        end
        hold off;
    elseif strcmp(norm_or_comp, 'Compare')
        Et = sqrt(abs(varargin{1}.E(:, :, 1)) .^ 2 ...
            + abs(varargin{1}.E(:, :, 2)) .^ 2 ...
            + abs(varargin{1}.E(:, :, 3)) .^ 2);
        Et_db = 20 * log10(Et / max(Et, [], 'all'));
        E_plot = NaN(1, size(theta, 2) * 2);
        E_plot(1 : size(theta, 2)) = fliplr(Et_db(row_idx_2, :));
        E_plot(size(theta, 2) + 1 : end) = Et_db(row_idx_1, :);
        plot(theta_plot, E_plot, 'LineWidth', 2.0, ...
            'DisplayName', 'meas');
        hold on;
        Et = sqrt(abs(varargin{2}.E(:, :, 1)) .^ 2 ...
            + abs(varargin{2}.E(:, :, 2)) .^ 2 ...
            + abs(varargin{2}.E(:, :, 3)) .^ 2);
        Et_db = 20 * log10(Et / max(Et, [], 'all'));
        E_plot = NaN(1, size(theta, 2) * 2);
        E_plot(1 : size(theta, 2)) = fliplr(Et_db(row_idx_2, :));
        E_plot(size(theta, 2) + 1 : end) = Et_db(row_idx_1, :);
        plot(theta_plot, E_plot, '--', 'LineWidth', 2.0, ...
            'DisplayName', 'airy');
    else
        error('Error. Invalid argument.');
    end
    xticks(-90 : 15 : 90);
    xlim([-90 90]);
    grid on;
    legend show;
    legend('location', 'bestoutside');
    xlabel('\theta / deg');
    ylabel('|E^{FF}| / dB');
    title(title_label);
end

