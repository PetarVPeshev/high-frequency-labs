function ff_struct = get_ff_from_nf(meas_freq_ft, wave_vector, ...
    theta, phi, r)
%GET_FF_FROM_NF Summary of this function goes here
%   Detailed explanation goes here
    num_freq_pts = length(meas_freq_ft);
    ff_struct(num_freq_pts) = struct('freq', [], 'E', []);

    for freq_idx = 1 : 1 : num_freq_pts
        k = wave_vector(freq_idx).k;
        S12_ft = meas_freq_ft(freq_idx).S12_ft;

        E_const = 2j * k * exp(-1j * k * r) / (4 * pi * r);
        E = zeros( [size(S12_ft, 1, 2), 3] );
        E(:, :, 2) = E_const * S12_ft .* cos(phi);
        E(:, :, 3) = - E_const * S12_ft .* cos(theta) .* sin(phi);

        ff_struct(freq_idx).freq = meas_freq_ft(freq_idx).freq;
        ff_struct(freq_idx).E = E;
    end
end

