function [t,x,v,a] = generate_min_jerk_trajectory(x_i,x_f,T,dt)
%generate_min_jerk_trajectory Minimum jerk trajectory between two points
%   [t,x,v,a] = generate_min_jerk_trajectory(x_i,x_f,T,dt)
%   Calculates the minimum jerk trajectory between a start point, x_i, and
%   and end point, x_f, assuming zero velocity and acceleration at both
%   points. The position, velocity, and acceleration for the trajectory are
%   returned at a resolution of dt over a time period of T.

t = 0:dt:T;
x = (x_f(:) - x_i(:))*(6*t.^5/T^2 - 15*t.^4/T + 10*t.^3)/T^3;
x = x + x_i(:)*ones(size(t));
v = (x_f(:) - x_i(:))*(30*t.^4/T^2 - 60*t.^3/T + 30*t.^2)/T^3;
a = (x_f(:) - x_i(:))*(120*t.^3/T^2 - 180*t.^2/T + 60*t)/T^3;
end

