function fig = plot_time_gate(tg_struct, title)
%PLOT_TIME_GATE Summary of this function goes here
%   Detailed explanation goes here
    freq_GHz = tg_struct.freq * 1e-9;
    fig = figure('Position', [100 100 1200 600]);
    subplot(4, 1, 1);
    plot(freq_GHz, 20 * log10(abs(tg_struct.S11)), ...
        'LineWidth', 2.0, 'Color', [0 0.4470 0.7410], ...
        'DisplayName', 'S_{11}^{meas}');
    hold on;
    plot(freq_GHz, 20 * log10(abs(tg_struct.S11_tg)), '--', ...
        'LineWidth', 2.0, 'Color', [0 0.4470 0.7410], ...
        'DisplayName', 'S_{11}^{tg}');
    grid on;
    xlim([min(freq_GHz) max(freq_GHz)]);
    legend show;
    legend('location', 'bestoutside');
    ylabel('|S_{11}| / dB');
    subplot(4, 1, 2);
    plot(freq_GHz, 20 * log10(abs(tg_struct.S12)), ...
        'LineWidth', 2.0, 'Color', [0.8500 0.3250 0.0980], ...
        'DisplayName', 'S_{12}^{meas}');
    hold on;
    plot(freq_GHz, 20 * log10(abs(tg_struct.S12_tg)), '--', ...
        'LineWidth', 2.0, 'Color', [0.8500 0.3250 0.0980], ...
        'DisplayName', 'S_{12}^{tg}');
    grid on;
    xlim([min(freq_GHz) max(freq_GHz)]);
    legend show;
    legend('location', 'bestoutside');
    ylabel('|S_{12}| / dB');
    subplot(4, 1, 3);
    plot(freq_GHz, 20 * log10(abs(tg_struct.S21)), ...
        'LineWidth', 2.0, 'Color', [0.9290 0.6940 0.1250], ...
        'DisplayName', 'S_{21}^{meas}');
    hold on;
    plot(freq_GHz, 20 * log10(abs(tg_struct.S21_tg)), '--', ...
        'LineWidth', 2.0, 'Color', [0.9290 0.6940 0.1250], ...
        'DisplayName', 'S_{21}^{tg}');
    grid on;
    xlim([min(freq_GHz) max(freq_GHz)]);
    legend show;
    legend('location', 'bestoutside');
    ylabel('|S_{21}| / dB');
    subplot(4, 1, 4);
    plot(freq_GHz, 20 * log10(abs(tg_struct.S21)), ...
        'LineWidth', 2.0, 'Color', [0.4940 0.1840 0.5560], ...
        'DisplayName', 'S_{22}^{meas}');
    hold on;
    plot(freq_GHz, 20 * log10(abs(tg_struct.S21_tg)), '--', ...
        'LineWidth', 2.0, 'Color', [0.4940 0.1840 0.5560], ...
        'DisplayName', 'S_{22}^{tg}');
    grid on;
    xlim([min(freq_GHz) max(freq_GHz)]);
    legend show;
    legend('location', 'bestoutside');
    xlabel('f / GHz');
    ylabel('|S_{22}| / dB');
    sgtitle(title, 'FontWeight', 'bold', 'FontSize', 12);
end
