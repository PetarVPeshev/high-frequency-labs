function varargout = get_time_gate(meas_x, time_gate_max, varargin)
%TIME_GATE Summary of this function goes here
%   Detailed explanation goes here
    plot_S21 = false;
    get_freq_struct = false;
    for arg_idx = 1 : 1 : length(varargin)
        if strcmp(varargin{arg_idx}, 'PlotS21')
            plot_S21 = true;
            plot_save_dir = varargin{arg_idx + 1};
        elseif strcmp(varargin{arg_idx}, 'GetFreqStruct')
            get_freq_struct = true;
            meas_freq = varargin{arg_idx + 1};
        end
    end

    num_x_pts = size(meas_x, 2);
    num_y_pts = size(meas_x, 1);

    if num_y_pts == 1
        meas_x_tg(num_x_pts) = struct('x', [], 'freq', [], ...
            'num_freq_pts', [], 'S11', [], 'S12', [], 'S21', [], ...
            'S22', [], 't', [], 'time_gate', [], 'S11_tg', [], ...
            'S12_tg', [], 'S21_tg', [], 'S22_tg', []);
    
        for x_idx = 1 : 1 : num_x_pts
            num_freq_pts = meas_x(x_idx).num_freq_pts;
    
            time_S11 = ifft(meas_x(x_idx).S11);
            time_S12 = ifft(meas_x(x_idx).S12);
            time_S21 = ifft(meas_x(x_idx).S21);
            time_S22 = ifft(meas_x(x_idx).S22);
    
            df = meas_x(x_idx).freq(2) - meas_x(x_idx).freq(1);
            dt = 1 / df;
            meas_x_tg(x_idx).t = (0 : 1 : ...
                length(meas_x(x_idx).freq) - 1) * dt;
    
            meas_x_tg(x_idx).time_gate = meas_x_tg(x_idx).t ...
                <= time_gate_max;
            
            meas_x_tg(x_idx).x = meas_x(x_idx).x;
            meas_x_tg(x_idx).freq = meas_x(x_idx).freq;
            meas_x_tg(x_idx).num_freq_pts = num_freq_pts;
            meas_x_tg(x_idx).S11 = meas_x(x_idx).S11;
            meas_x_tg(x_idx).S12 = meas_x(x_idx).S12;
            meas_x_tg(x_idx).S21 = meas_x(x_idx).S21;
            meas_x_tg(x_idx).S22 = meas_x(x_idx).S22;
            tg_S11 = time_S11 .* meas_x_tg(x_idx).time_gate;
            tg_S12 = time_S12 .* meas_x_tg(x_idx).time_gate;
            tg_S21 = time_S21 .* meas_x_tg(x_idx).time_gate;
            tg_S22 = time_S22 .* meas_x_tg(x_idx).time_gate;
            
            meas_x_tg(x_idx).S11_tg = fft(tg_S11);
            meas_x_tg(x_idx).S12_tg = fft(tg_S12);
            meas_x_tg(x_idx).S21_tg = fft(tg_S21);
            meas_x_tg(x_idx).S22_tg = fft(tg_S22);
            
            if plot_S21 == true
                fig = figure('Position', [250 250 800 400]);
                plot(meas_x_tg(x_idx).t * 1e6, ...
                    10 * log10(abs(time_S21)), 'LineWidth', 1.0, ...
                    'DisplayName', 'time-domain');
                hold on;
                plot(meas_x_tg(x_idx).t * 1e6, ...
                    10 * log10(abs(tg_S21)), 'LineWidth', 1.0, ...
                    'DisplayName', 'time-gated');
                grid on;
                xlim([min(meas_x_tg(x_idx).t * 1e6) ...
                    max(meas_x_tg(x_idx).t * 1e6)]);
                legend show;
                legend('location', 'bestoutside');
                xlabel('t / us');
                ylabel('S_{21} / dB');
                title(['Time Domain S_{21} @ x_{rel} = ' ...
                    num2str(meas_x_tg(x_idx).x * 1e3) ' mm']);
                saveas(gcf, [plot_save_dir '\S21_w_and_wo_tg_x_' ...
                    num2str(meas_x(x_idx).x * 1e3) 'mm.fig']);
        
                close(fig);
            end
        end
    
        varargout{1} = meas_x_tg;
        
        if get_freq_struct == true
            num_freq_pts = length(meas_freq);
            meas_freq_tg(num_freq_pts) = struct('freq', [], 'x', [], ...
                'x_step', [], 'num_x_pts', [], 'mid_x_idx', [], ...
                'S11', [], 'S12', [], 'S21', [], 'S22', [], ...
                'S11_tg', [], 'S12_tg', [], 'S21_tg', [], 'S22_tg', []);
        
            for freq_idx = 1 : 1 : num_freq_pts
                meas_freq_tg(freq_idx).freq = meas_freq(freq_idx).freq;
                meas_freq_tg(freq_idx).x = meas_freq(freq_idx).x;
                meas_freq_tg(freq_idx).x_step = meas_freq(freq_idx).x_step;
                meas_freq_tg(freq_idx).num_x_pts ...
                    = meas_freq(freq_idx).num_x_pts;
                meas_freq_tg(freq_idx).mid_x_idx ...
                    = meas_freq(freq_idx).mid_x_idx;
                meas_freq_tg(freq_idx).S11 = meas_freq(freq_idx).S11;
                meas_freq_tg(freq_idx).S12 = meas_freq(freq_idx).S12;
                meas_freq_tg(freq_idx).S21 = meas_freq(freq_idx).S21;
                meas_freq_tg(freq_idx).S22 = meas_freq(freq_idx).S22;
                
                meas_freq_tg(freq_idx).S11_tg = NaN(1, num_x_pts);
                meas_freq_tg(freq_idx).S12_tg = NaN(1, num_x_pts);
                meas_freq_tg(freq_idx).S21_tg = NaN(1, num_x_pts);
                meas_freq_tg(freq_idx).S22_tg = NaN(1, num_x_pts);
                for x_idx = 1 : 1 : num_x_pts
                    meas_freq_tg(freq_idx).S11_tg(x_idx) ...
                        = meas_x_tg(x_idx).S11_tg(freq_idx);
                    meas_freq_tg(freq_idx).S12_tg(x_idx) ...
                        = meas_x_tg(x_idx).S12_tg(freq_idx);
                    meas_freq_tg(freq_idx).S21_tg(x_idx) ...
                        = meas_x_tg(x_idx).S21_tg(freq_idx);
                    meas_freq_tg(freq_idx).S22_tg(x_idx) ...
                        = meas_x_tg(x_idx).S22_tg(freq_idx);
                end
            end
    
            varargout{2} = meas_freq_tg;
        end
    else
        meas_x_tg(num_x_pts) = struct('x', [], 'y', [], 'freq', [], ...
            'num_freq_pts', [], 'S11', [], 'S12', [], 'S21', [], ...
            'S22', [], 't', [], 'time_gate', [], 'S11_tg', [], ...
            'S12_tg', [], 'S21_tg', [], 'S22_tg', []);

        for x_idx = 1 : 1 : num_x_pts
            for y_idx = 1 : 1 : num_y_pts
                num_freq_pts = meas_x(y_idx, x_idx).num_freq_pts;
    
                time_S11 = ifft(meas_x(x_idx, y_idx).S11);
                time_S12 = ifft(meas_x(x_idx, y_idx).S12);
                time_S21 = ifft(meas_x(x_idx, y_idx).S21);
                time_S22 = ifft(meas_x(x_idx, y_idx).S22);
    
                df = meas_x(x_idx, y_idx).freq(2) ...
                    - meas_x(x_idx, y_idx).freq(1);
                dt = 1 / df;
                meas_x_tg(x_idx, y_idx).t = (0 : 1 : ...
                    length(meas_x(x_idx, y_idx).freq) - 1) * dt;
        
                meas_x_tg(x_idx, y_idx).time_gate ...
                    = meas_x_tg(x_idx, y_idx).t <= time_gate_max;
            
                meas_x_tg(x_idx, y_idx).x = meas_x(x_idx, y_idx).x;
                meas_x_tg(x_idx, y_idx).y = meas_x(x_idx, y_idx).y;
                meas_x_tg(x_idx, y_idx).freq = meas_x(x_idx, y_idx).freq;
                meas_x_tg(x_idx, y_idx).num_freq_pts = num_freq_pts;
                meas_x_tg(x_idx, y_idx).S11 = meas_x(x_idx, y_idx).S11;
                meas_x_tg(x_idx, y_idx).S12 = meas_x(x_idx, y_idx).S12;
                meas_x_tg(x_idx, y_idx).S21 = meas_x(x_idx, y_idx).S21;
                meas_x_tg(x_idx, y_idx).S22 = meas_x(x_idx, y_idx).S22;
                tg_S11 = time_S11 .* meas_x_tg(x_idx, y_idx).time_gate;
                tg_S12 = time_S12 .* meas_x_tg(x_idx, y_idx).time_gate;
                tg_S21 = time_S21 .* meas_x_tg(x_idx, y_idx).time_gate;
                tg_S22 = time_S22 .* meas_x_tg(x_idx, y_idx).time_gate;
                
                meas_x_tg(x_idx, y_idx).S11_tg = fft(tg_S11);
                meas_x_tg(x_idx, y_idx).S12_tg = fft(tg_S12);
                meas_x_tg(x_idx, y_idx).S21_tg = fft(tg_S21);
                meas_x_tg(x_idx, y_idx).S22_tg = fft(tg_S22);
            
                if plot_S21 == true
                    fig = figure('Position', [250 250 800 400]);
                    plot(meas_x_tg(x_idx, y_idx).t * 1e6, ...
                        10 * log10(abs(time_S21)), 'LineWidth', 1.0, ...
                        'DisplayName', 'time-domain');
                    hold on;
                    plot(meas_x_tg(x_idx, y_idx).t * 1e6, ...
                        10 * log10(abs(tg_S21)), 'LineWidth', 1.0, ...
                        'DisplayName', 'time-gated');
                    grid on;
                    xlim([min(meas_x_tg(x_idx, y_idx).t * 1e6) ...
                        max(meas_x_tg(x_idx, y_idx).t * 1e6)]);
                    legend show;
                    legend('location', 'bestoutside');
                    xlabel('t / us');
                    ylabel('S_{21} / dB');
                    title(['Time Domain S_{21} @ x_{rel} = ' ...
                        num2str(meas_x_tg(x_idx, y_idx).x * 1e3) ' mm,' ...
                        ' y_{rel} = ' ...
                        num2str(meas_x_tg(x_idx, y_idx).y * 1e3) ' mm']);
                    saveas(gcf, [plot_save_dir '\S21_w_and_wo_tg_x_' ...
                        num2str(meas_x(x_idx, y_idx).x * 1e3) 'mm_y_' ...
                        num2str(meas_x(x_idx, y_idx).y * 1e3) 'mm.fig']);
            
                    close(fig);
                end
            end
        end
    
        varargout{1} = meas_x_tg;
        
        if get_freq_struct == true
            num_freq_pts = length(meas_freq);
            meas_freq_tg(num_freq_pts) = struct('freq', [], 'S11', [], ...
                'S12', [], 'S21', [], 'S22', [], 'S11_tg', [], ...
                'S12_tg', [], 'S21_tg', [], 'S22_tg', []);
        
            for freq_idx = 1 : 1 : num_freq_pts
                meas_freq_tg(freq_idx).freq = meas_freq(freq_idx).freq;
                meas_freq_tg(freq_idx).S11 = meas_freq(freq_idx).S11;
                meas_freq_tg(freq_idx).S12 = meas_freq(freq_idx).S12;
                meas_freq_tg(freq_idx).S21 = meas_freq(freq_idx).S21;
                meas_freq_tg(freq_idx).S22 = meas_freq(freq_idx).S22;
                
                meas_freq_tg(freq_idx).S11_tg = NaN(num_y_pts, num_x_pts);
                meas_freq_tg(freq_idx).S12_tg = NaN(num_y_pts, num_x_pts);
                meas_freq_tg(freq_idx).S21_tg = NaN(num_y_pts, num_x_pts);
                meas_freq_tg(freq_idx).S22_tg = NaN(num_y_pts, num_x_pts);
                for x_idx = 1 : 1 : num_x_pts
                    for y_idx = 1 : 1 : num_y_pts
                        meas_freq_tg(freq_idx).S11_tg(y_idx, x_idx) ...
                            = meas_x_tg(x_idx, y_idx).S11_tg(freq_idx);
                        meas_freq_tg(freq_idx).S12_tg(y_idx, x_idx) ...
                            = meas_x_tg(x_idx, y_idx).S12_tg(freq_idx);
                        meas_freq_tg(freq_idx).S21_tg(y_idx, x_idx) ...
                            = meas_x_tg(x_idx, y_idx).S21_tg(freq_idx);
                        meas_freq_tg(freq_idx).S22_tg(y_idx, x_idx) ...
                            = meas_x_tg(x_idx, y_idx).S22_tg(freq_idx);
                    end
                end
            end
    
            varargout{2} = meas_freq_tg;
        end
    end
end

