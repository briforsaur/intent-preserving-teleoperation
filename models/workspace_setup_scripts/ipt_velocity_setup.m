% MTDPC_test_setup.m

trajectory_dir = "./trajectories/";
trajectory_file = "2021-01-28rand_y_trajectory";

%% Simulation parameters
dt = 0.001; % Maximum simulation step
t_max = 20; % Total simulation runtime
Ts = dt; % Discrete-time sample duration
epsilon = 0.0001; % Maximum magnitude to treat normalized vectors as zero
%% Patient parameters
% Passive dynamics
m = 1;
b = 8;
x_0 = [0; 0; 0];
v_0 = [0; 0; 0];
% Active dynamics
Mp = 0.1; % Desired overshoot
ts = 0.5; % Desired settling time [s]
p_settle = 0.01; % Desired settling percent
k_d = -m*log(p_settle)/ts - b;
Kp_d = k_d*eye(3);
active_factor = 0.5;
%% Therapist tracking parameters
f_0 = [0;0;0];
Kth_d = Kp_d;
active_factor_th = 1 - active_factor;
%% Desired patient motion
load(trajectory_dir+trajectory_file);
%% Communication channel parameters
T_min = 0.01; 
T = 200*Ts;
d_T = round(T/Ts); % Communication delay 
T_max = 0.5;
%% Tolerances
v_tol = 0.001; % [m/s]
theta_tol = deg2rad(0.1); % [rad]
%% M-TDPC Parameters
Gamma_w = 0.95;%0.7;
xi_r = 0;%1.05;
xi_p = b;
LOP_0 = 0;%0.5*m*max(sum(V.^2,1));