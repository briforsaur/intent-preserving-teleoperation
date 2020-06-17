function v_out = axis_angle_rotate(n_hat, theta, v_in)
%AXIS_ANGLE_ROTATE Rotates a vector using angle-axis representation
%   v_out = axis_angle_rotate(n_hat, theta, v_in)
%   A function that rotates a vector in any dimension according to a unit
%   vector describing the axis of rotation and an angle of rotation about
%   that axis using the right hand rule. Rodrigues' rotation formula is
%   used to compute the rotation.
%   INPUTS:
%       n_hat - The unit vector describing the axis of rotation. Must have
%               the same dimension as the input vector.
%       theta - The angle describing the rotation about the axis of
%               rotation, in radians. Positive rotation follows the
%               right-hand rule.
%       v_in  - The input vector, prior to rotation. Must have the same
%               dimension as the unit vector.
%   OUTPUT:
%       v_out - The rotated vector.

v_out = v_in*cos(theta) + cross(n_hat,v_in)*sin(theta) + ...
        n_hat*dot(n_hat,v_in)*(1 - cos(theta));
end