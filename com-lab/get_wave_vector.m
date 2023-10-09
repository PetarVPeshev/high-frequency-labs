function [wave_vector] = get_wave_vector(freq, theta, phi)
%GET_WAVE_VECTOR Summary of this function goes here
%   Detailed explanation goes here
    c = physconst('LightSpeed');
    lambda = c ./ freq;
    k = 2 * pi ./ lambda;

    num_freq_pts = length(freq);
    wave_vector(num_freq_pts) = struct('k', [], 'kx', [], 'ky', []);

    for freq_idx = 1 : 1 : num_freq_pts
        wave_vector(freq_idx).k = k(freq_idx);
        wave_vector(freq_idx).kx = k(freq_idx) * sin(theta) .* cos(phi);
        wave_vector(freq_idx).ky = k(freq_idx) * sin(theta) .* sin(phi);
    end
end

