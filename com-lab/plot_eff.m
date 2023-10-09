function fig = plot_eff(title_label, varargin)
%PLOT_EFF Summary of this function goes here
%   Detailed explanation goes here
    fig = figure('Position', [250 250 800 400]);
    for arg_idx = 1 : 1 : length(varargin)
        E = 20 * log10(abs(varargin{arg_idx}.Ey) ...
            / max(abs(varargin{arg_idx}.Ey)));
        plot(varargin{arg_idx}.theta * 180 / pi, E, 'LineWidth', 2.0, ...
            'DisplayName', ['E^{FF}, f = ' ...
            num2str(varargin{arg_idx}.freq * 1e-9) ' GHz']);
        hold on;
    end
    hold off;
    xticks(-45 : 5 : 45);
    xlim([-45 45]);
    grid on;
    legend show;
    legend('location', 'bestoutside');
    xlabel('\theta / deg');
    ylabel('|E^{FF}| / dB');
    title(title_label);
end

