function meas_freq_ft = get_aperture_ft(meas_freq, meas_plane, ...
    wave_vector, meas_or_tg)
%GET_APERTURE_FT Summary of this function goes here
%   Detailed explanation goes here
    num_freq_pts = length(meas_freq);
    if strcmp(meas_or_tg, 'Measured')
        meas_freq_ft(num_freq_pts) = struct('freq', [], 'S11', [], ...
            'S12', [], 'S21', [], 'S22', [], 'S12_ft', []);
    elseif strcmp(meas_or_tg, 'TimeGated')
        meas_freq_ft(num_freq_pts) = struct('freq', [], 'S11', [], ...
            'S12', [], 'S21', [], 'S22', [], 'S11_tg', [], ...
            'S12_tg', [], 'S21_tg', [], 'S22_tg', [], 'S12_ft', []);
    else
        error('Error. Invalid argument.');
    end


    x = meas_plane.x;
    y = meas_plane.y;
    [X, Y] = meshgrid(x, y);

    for freq_idx = 1 : 1 : num_freq_pts
        kx = repmat(wave_vector(freq_idx).kx, [1 1 size(X, 1, 2)]);
        kx = permute(kx, [3 4 1 2]);
        ky = repmat(wave_vector(freq_idx).ky, [1 1 size(X, 1, 2)]);
        ky = permute(ky, [3 4 1 2]);

        dx = meas_plane.x_step;
        dy = meas_plane.y_step;
        
        if strcmp(meas_or_tg, 'Measured')
            i = meas_freq(freq_idx).S12 .* exp( 1j * (kx .* X + ky .* Y) );
            S12_ft = sum(i, [1 2]) * dx * dy;
    
            meas_freq_ft(freq_idx).freq = meas_freq(freq_idx).freq;
            meas_freq_ft(freq_idx).S11 = meas_freq(freq_idx).S11;
            meas_freq_ft(freq_idx).S12 = meas_freq(freq_idx).S12;
            meas_freq_ft(freq_idx).S21 = meas_freq(freq_idx).S21;
            meas_freq_ft(freq_idx).S22 = meas_freq(freq_idx).S22;
            meas_freq_ft(freq_idx).S12_ft = permute(S12_ft, [3 4 1 2]);
        elseif strcmp(meas_or_tg, 'TimeGated')
            i = meas_freq(freq_idx).S12_tg ...
                .* exp( 1j * (kx .* X + ky .* Y) );
            S12_ft = sum(i, [1 2]) * dx * dy;
    
            meas_freq_ft(freq_idx).freq = meas_freq(freq_idx).freq;
            meas_freq_ft(freq_idx).S11 = meas_freq(freq_idx).S11;
            meas_freq_ft(freq_idx).S12 = meas_freq(freq_idx).S12;
            meas_freq_ft(freq_idx).S21 = meas_freq(freq_idx).S21;
            meas_freq_ft(freq_idx).S22 = meas_freq(freq_idx).S22;
            meas_freq_ft(freq_idx).S11_tg = meas_freq(freq_idx).S11_tg;
            meas_freq_ft(freq_idx).S12_tg = meas_freq(freq_idx).S12_tg;
            meas_freq_ft(freq_idx).S21_tg = meas_freq(freq_idx).S21_tg;
            meas_freq_ft(freq_idx).S22_tg = meas_freq(freq_idx).S22_tg;
            meas_freq_ft(freq_idx).S12_ft = permute(S12_ft, [3 4 1 2]);
        else
            error('Error. Invalid argument.');
        end
    end
end

