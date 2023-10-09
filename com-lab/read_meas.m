function varargout = read_meas(meas_dir, file_name, meas_type)
%READ_MEAS Summary of this function goes here
%   Detailed explanation goes here
    if strcmp(meas_type, 'Plane')
        meas_data = importdata([meas_dir '\' file_name '.mat']);
    
        if meas_data.ypoints == 1
            num_x_pts = meas_data.xpoints;
            mid_x_idx = ceil(meas_data.xpoints / 2);
            x = ( meas_data.xpos_rel - meas_data.xpos_rel(mid_x_idx) ) ...
                * 1e-3;
            x_step = meas_data.x_step * 1e-3;
            meas_x(num_x_pts) = struct('x', [], 'freq', [], ...
                'num_freq_pts', [], 'S11', [], 'S12', [], 'S21', [], ...
                'S22', []);
            
            S11 = cell2mat(meas_data.s11');
            S12 = cell2mat(meas_data.s12');
            S21 = cell2mat(meas_data.s21');
            S22 = cell2mat(meas_data.s22');
        
            freq_points = meas_data.fpoints;
            meas_freq(freq_points) = struct('freq', [], 'x', [], ...
                'x_step', [], 'num_x_pts', [], 'mid_x_idx', [], ...
                'S11', [], 'S12', [], 'S21', [], 'S22', []);
        
            for x_idx = 1 : 1 : num_x_pts
                meas_x(x_idx).x = x(x_idx);
                meas_x(x_idx).freq = meas_data.freq;
                meas_x(x_idx).num_freq_pts = freq_points;
                meas_x(x_idx).S11 = S11(x_idx, :);
                meas_x(x_idx).S12 = S12(x_idx, :);
                meas_x(x_idx).S21 = S21(x_idx, :);
                meas_x(x_idx).S22 = S22(x_idx, :);
            end
        
            for freq_idx = 1 : 1 : freq_points
                meas_freq(freq_idx).freq = meas_data.freq(freq_idx);
                meas_freq(freq_idx).x = x;
                meas_freq(freq_idx).x_step = x_step;
                meas_freq(freq_idx).num_x_pts = num_x_pts;
                meas_freq(freq_idx).mid_x_idx = mid_x_idx;
                meas_freq(freq_idx).S11 = S11(:, freq_idx)';
                meas_freq(freq_idx).S12 = S12(:, freq_idx)';
                meas_freq(freq_idx).S21 = S21(:, freq_idx)';
                meas_freq(freq_idx).S22 = S22(:, freq_idx)';
            end

            varargout{1} = meas_freq;
            varargout{2} = meas_x;
        else
            meas_plane = struct('x', [], 'x_step', [], 'num_x_pts', [], ...
                'mid_x_idx', [], 'y', [], 'y_step', [], ...
                'num_y_pts', [], 'mid_y_idx', []);
            
            num_x_pts = meas_data.xpoints;
            num_y_pts = meas_data.ypoints;

            meas_plane.num_x_pts = num_x_pts;
            meas_plane.mid_x_idx = ceil(meas_data.xpoints / 2);
            meas_plane.x = ( meas_data.xpos_rel ...
                - meas_data.xpos_rel(meas_plane.mid_x_idx) ) * 1e-3;
            meas_plane.x_step = meas_data.x_step * 1e-3;
            meas_plane.num_y_pts = num_y_pts;
            meas_plane.mid_y_idx = ceil(meas_data.ypoints / 2);
            meas_plane.y = ( meas_data.ypos_rel ...
                - meas_data.ypos_rel(meas_plane.mid_y_idx) ) * 1e-3;
            meas_plane.y_step = meas_data.y_step * 1e-3;

            S11 = cell2mat(permute(meas_data.s11, [3 4 1 2]));
            S12 = cell2mat(permute(meas_data.s12, [3 4 1 2]));
            S21 = cell2mat(permute(meas_data.s21, [3 4 1 2]));
            S22 = cell2mat(permute(meas_data.s22, [3 4 1 2]));

            freq_points = meas_data.fpoints;
            meas_freq(freq_points) = struct('freq', [], 'S11', [], ...
                'S12', [], 'S21', [], 'S22', []);

            for freq_idx = 1 : 1 : freq_points
                meas_freq(freq_idx).freq = meas_data.freq(freq_idx);
                meas_freq(freq_idx).S11 ...
                    = permute(S11(:, freq_idx, :, :), [3 4 1 2]);
                meas_freq(freq_idx).S12 ...
                    = permute(S12(:, freq_idx, :, :), [3 4 1 2]);
                meas_freq(freq_idx).S21 ...
                    = permute(S21(:, freq_idx, :, :), [3 4 1 2]);
                meas_freq(freq_idx).S22 ...
                    = permute(S22(:, freq_idx, :, :), [3 4 1 2]);
            end

            meas_xy(num_x_pts, num_y_pts) = struct('x', [], 'y', [], ...
                'freq', [], 'num_freq_pts', [], 'S11', [], 'S12', [], ...
                'S21', [], 'S22', []);

            for x_idx = 1 : 1 : num_x_pts
                for y_idx = 1 : 1 : num_y_pts
                    meas_xy(x_idx, y_idx).x = meas_plane.x(x_idx);
                    meas_xy(x_idx, y_idx).y = meas_plane.y(y_idx);
                    meas_xy(x_idx, y_idx).freq = meas_data.freq;
                    meas_xy(x_idx, y_idx).num_freq_pts = freq_points;
                    meas_xy(x_idx, y_idx).S11 = S11(1, :, y_idx, x_idx);
                    meas_xy(x_idx, y_idx).S12 = S12(1, :, y_idx, x_idx);
                    meas_xy(x_idx, y_idx).S21 = S21(1, :, y_idx, x_idx);
                    meas_xy(x_idx, y_idx).S22 = S22(1, :, y_idx, x_idx);
                end
            end

            varargout{1} = meas_freq;
            varargout{2} = meas_xy;
            varargout{3} = meas_plane;
        end
    elseif strcmp(meas_type, 'Broadside')
        load([meas_dir '\' file_name '.mat']);
        meas_x = struct('x', 0, 'freq', freq, ...
            'num_freq_pts', length(freq), 'S11', S11, 'S12', S12, ...
            'S21', S21, 'S22', S22);

        varargout{1} = meas_x;
    else
        error('Error. Invalid argument.');
    end
end
