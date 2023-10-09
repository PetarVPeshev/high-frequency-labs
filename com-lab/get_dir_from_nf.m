function dir = get_dir_from_nf(meas_ff, theta, phi, r)
%GET_DIR_FROM_NF Summary of this function goes here
%   Detailed explanation goes here
    wave_impedance = 376.730313668;

    num_freq_pts = length(meas_ff);

    dtheta = theta(1, 2) - theta(1, 1);
    dphi = phi(2, 1) - phi(1, 1);

    dir = NaN(1, num_freq_pts);
    for freq_idx = 1 : 1 : num_freq_pts
        Et = sqrt(abs(meas_ff(freq_idx).E(:, :, 1)) .^ 2 ...
            + abs(meas_ff(freq_idx).E(:, :, 2)) .^ 2 ...
            + abs(meas_ff(freq_idx).E(:, :, 3)) .^ 2);
    
        rad_inten = (Et .^ 2) .* (r .^ 2) / (2 * wave_impedance);
        rad_power = sum(rad_inten .* sin(theta), [1 2]) * dtheta * dphi;
        dir(freq_idx) = max(rad_inten, [], 'all') * 4 * pi / rad_power;
    end
end

