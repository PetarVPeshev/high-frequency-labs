function meas_gain = get_gain(meas_x, d, varargin)
%GET_GAIN Summary of this function goes here
%   Detailed explanation goes here
    same_antenna = false;
    for arg_idx = 1 : 1 : length(varargin)
        if strcmp(varargin{arg_idx}, 'SameAntenna')
            same_antenna = true;
        elseif strcmp(varargin{arg_idx}, 'DifferentAntennas')
            gain_rx = varargin{arg_idx + 1};
        end
    end

    c = physconst('LightSpeed');
    
    num_x_pts = length(meas_x);
    meas_gain(num_x_pts) = struct('x', [], 'gain', []);

    for x_idx = 1 : 1 : num_x_pts
        meas_gain(x_idx).x = meas_x(x_idx).x;

        power_ratio = abs(meas_x(x_idx).S21_tg) .^ 2 ...
            .* (1 - abs(meas_x(x_idx).S22_tg) .^ 2);

        wavelength = c ./ meas_x(x_idx).freq;
        prop_loss = (wavelength / (4 * pi * d)) .^ 2;
        
        gain_tx_rx = power_ratio ./ prop_loss;
        if same_antenna == true
            meas_gain(x_idx).gain = sqrt(gain_tx_rx);
        else
            meas_gain(x_idx).gain = gain_tx_rx ./ gain_rx;
        end
    end
end

