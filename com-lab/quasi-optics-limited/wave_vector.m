function [k_vector, k] = wave_vector(relat_permit, k0, sph_grid)
%WAVE_VECTOR This function calculates the wave vector and medium
%propagation constant
%   Detailed explanation goes here
% FIXME: taking k0 as input and then calculating k is confusing, function
% should take f or k (in case of k, do not return k)
    k = k0 * sqrt(relat_permit);

    kx = k * sin(sph_grid(:, :, 1)) .* cos(sph_grid(:, :, 2));
    ky = k * sin(sph_grid(:, :, 1)) .* sin(sph_grid(:, :, 2));

    kz = NaN( size(sph_grid, 1, 2) );
    % z >= 0
    kz(sph_grid(:, :, 1) <= pi / 2) = - 1j * sqrt( - k0.^2 ...
        + kx(sph_grid(:, :, 1) <= pi / 2).^2 ...
        + ky(sph_grid(:, :, 1) <= pi / 2).^2 );
    % z < 0
    kz(sph_grid(:, :, 1) > pi / 2) = 1j * sqrt( - k0.^2 ...
        + kx(sph_grid(:, :, 1) > pi / 2).^2 ...
        + ky(sph_grid(:, :, 1) > pi / 2).^2 );
    
    k_vector = NaN( [size(sph_grid, 1, 2), 3] );
    k_vector(:, :, 1) = kx;
    k_vector(:, :, 2) = ky;
    k_vector(:, :, 3) = kz;
end