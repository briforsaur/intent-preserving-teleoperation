% MTDPC_test_setup.m

% Simulation parameters
dt = 0.001; % Maximum simulation step
t_max = 20; % Total simulation runtime
Ts = dt; % Discrete-time sample duration
epsilon = 0.0001; % Maximum magnitude to treat normalized vectors as zero
% Patient parameters
m = 1;
b = 8;
x_0 = [0; 0; 0];
v_0 = [0; 0; 0];
% Therapist tracking parameters
f_0 = [0;0;0];
Mp = 0.1; % Desired overshoot
ts = 0.25; % Desired settling time [s]
p_settle = 0.01; % Desired settling percent
zeta = -log(Mp)/(pi*sqrt((log(Mp)/pi)^2 + 1));
w_n = exp(p_settle)/(zeta*ts);
k_p = m*w_n^2;
k_d = 2*zeta*w_n*m - b;
K_p = k_p*eye(3);
K_d = k_d*eye(3);
% Desired patient motion
A_v = 0.12*[1; 0.8; 0];
w_v = 2*pi*0.5;
derivative_phases = [[0; pi/2; 0] [pi/2; pi; 0] [0; pi/2; 0]];
% Communication channel parameters
T_min = 0.01; 
T = 0.05;
d_T = round(T/Ts); % Communication delay 
T_max = 0.5;
% Tolerances
v_tol = 0.001; % [m/s]
theta_tol = deg2rad(0.1); % [rad]
% M-TDPC Parameters
Gamma_w = 1;%0.7;
xi_r = 0;%1.05;
xi_p = b;
LOP_0 = 0.5*m*max(A_v*w_v)^2;