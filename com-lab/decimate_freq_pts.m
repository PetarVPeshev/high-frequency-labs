function [meas_freq, meas_xy] = decimate_freq_pts(meas_freq_ini, ...
    meas_xy, meas_plane, step_idx)
%DECIMATE_FREQ_PTS Summary of this function goes here
%   Detailed explanation goes here
    old_num_freq_pts = length(meas_freq_ini);
    new_num_freq_pts = floor(old_num_freq_pts / step_idx);
    meas_freq(new_num_freq_pts) = struct('freq', [], 'S11', [], ...
        'S12', [], 'S21', [], 'S22', []);
    
    new_freq_idx = 1;
    for freq_idx = 1 : step_idx : old_num_freq_pts
        meas_freq(new_freq_idx).freq = meas_freq_ini(freq_idx).freq;
        meas_freq(new_freq_idx).S11 = meas_freq_ini(freq_idx).S11;
        meas_freq(new_freq_idx).S12 = meas_freq_ini(freq_idx).S12;
        meas_freq(new_freq_idx).S21 = meas_freq_ini(freq_idx).S21;
        meas_freq(new_freq_idx).S22 = meas_freq_ini(freq_idx).S22;
        new_freq_idx = new_freq_idx + 1;
    end

    num_x_pts = meas_plane.num_x_pts;
    num_y_pts = meas_plane.num_y_pts;

    freq = meas_xy(1, 1).freq;
    freq = freq(1 : step_idx : old_num_freq_pts);

    for x_idx = 1 : 1 : num_x_pts
        for y_idx = 1 : 1 : num_y_pts
            meas_xy(x_idx, y_idx).freq = freq;
            meas_xy(x_idx, y_idx).S11 ...
                = meas_xy(x_idx, y_idx).S11(1 : step_idx : ...
                old_num_freq_pts);
            meas_xy(x_idx, y_idx).S12 ...
                = meas_xy(x_idx, y_idx).S12(1 : step_idx : ...
                old_num_freq_pts);
            meas_xy(x_idx, y_idx).S21 ...
                = meas_xy(x_idx, y_idx).S21(1 : step_idx : ...
                old_num_freq_pts);
            meas_xy(x_idx, y_idx).S22 ...
                = meas_xy(x_idx, y_idx).S22(1 : step_idx : ...
                old_num_freq_pts);
        end
    end
end
