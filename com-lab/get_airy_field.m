function uniform_struct = get_airy_field(freq, D, theta, phi, r)
%GET_AIRY_FIELD Summary of this function goes here
%   Detailed explanation goes here
    addpath([pwd() '\quasi-optics-limited']);

    c = physconst('LightSpeed');

    wavelength = c / freq;
    k = 2 * pi / wavelength;

    sph_grid = NaN( [size(theta, 1, 2), 2] );
    sph_grid(:, :, 1) = theta;
    sph_grid(:, :, 2) = phi;

    % Wave vector components
    [k_comp, ~] = wave_vector(1, k, sph_grid);

    % Spectral Green's function
    SGFej = dyadic_sgf(1, k, k_comp, 'E', 'J');

    % Circular current FT
    Jft = ft_current(k, D / 2, theta, 'circular', 'y');

    % Electric far-field
    E = farfield(k, r, sph_grid, k_comp(:, :, 3), SGFej, Jft);

    uniform_struct = struct('freq', freq, 'E', E);
end

