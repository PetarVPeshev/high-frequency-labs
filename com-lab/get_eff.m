function meas_eff = get_eff(meas_freq, d, meas_or_tg)
%GET_EFF Summary of this function goes here
%   Detailed explanation goes here
    c = physconst('LightSpeed');

    [theta, r_prime] = get_comp_param(meas_freq, d);

    num_freq_pts = length(meas_freq);
    meas_eff(num_freq_pts) = struct('freq', [], 'theta', [], 'k', [], ...
        'Ey', []);

    for freq_idx = 1 : 1 : num_freq_pts
        mid_point = meas_freq(freq_idx).mid_x_idx;
        
        meas_eff(freq_idx).freq = meas_freq(freq_idx).freq;
        meas_eff(freq_idx).theta = theta;
        meas_eff(freq_idx).k = 2 * pi * meas_freq(freq_idx).freq / c;
        
        if strcmp(meas_or_tg, 'Measured')
            meas_eff(freq_idx).Ey = meas_freq(freq_idx).S12 ...
                .* exp( 1j * meas_eff(freq_idx).k * (r_prime - d) ) ...
                .* r_prime / d;
            meas_eff(freq_idx).Ey(mid_point) ...
                = meas_freq(freq_idx).S12(mid_point);
        elseif strcmp(meas_or_tg, 'TimeGated')
            meas_eff(freq_idx).Ey = meas_freq(freq_idx).S12_tg ...
                .* exp( 1j * meas_eff(freq_idx).k * (r_prime - d) ) ...
                .* r_prime / d;
            meas_eff(freq_idx).Ey(mid_point) ...
                = meas_freq(freq_idx).S12_tg(mid_point);
        else
            error('Error. Invalid argument.');
        end
    end
end
