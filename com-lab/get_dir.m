function meas_dir = get_dir(meas_eff)
%GET_DIRECTIVITY Summary of this function goes here
%   Detailed explanation goes here
    num_freq_pts = length(meas_eff);
    meas_dir(num_freq_pts) = struct('freq', [], 'rad_inten', [], ...
        'rad_power', [], 'dir', []);

    for freq_idx = 1 : 1 : num_freq_pts
        meas_dir(freq_idx).freq = meas_eff(freq_idx).freq;

        theta_interp = linspace(-40, 40, 201) * pi / 180;
        dtheta_interp = theta_interp(2) - theta_interp(1);

        Ey_abs_sq = abs(meas_eff(freq_idx).Ey) .^ 2;
        Ey_abs_sq_interp = interp1(meas_eff(freq_idx).theta, Ey_abs_sq, ...
            theta_interp, 'spline');

        meas_dir(freq_idx).rad_inten = max(Ey_abs_sq_interp);
        meas_dir(freq_idx).rad_power = pi * sum(Ey_abs_sq_interp ...
            .* sin(abs(theta_interp))) .* dtheta_interp;
        meas_dir(freq_idx).dir = 4 * pi ...
            * meas_dir(freq_idx).rad_inten / meas_dir(freq_idx).rad_power;
    end
end

