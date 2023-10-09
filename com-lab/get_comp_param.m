function [theta, r_prime] = get_comp_param(meas_freq, d)
%GET_COMP_PARAM Summary of this function goes here
%   Detailed explanation goes here
    x = meas_freq(1).x;
    theta = atan(x / d);
    r_prime = x ./ sin(theta);
end
