% MTDPC_test_setup.m

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
% Desired reach position
x_d = 0.3;
[t,x_D,v_x,a_x] = generate_min_jerk_trajectory(x_0(1),x_d,t_max/2,dt);
% Obstacle avoidance position
y_d = 0.1;
[~,y_D,v_y,a_y] = generate_min_jerk_trajectory(x_0(2),y_d,t_max/4,dt);
y_D = [y_D, y_D(end-1:-1:1)];
v_y = [v_y, -v_y(end-1:-1:1)];
a_y = [a_y, a_y(end-1:-1:1)];
% Planar motion
z_D = zeros(size(x_D));
% Total forward trajectory
X = [x_D;y_D;z_D];
V = [v_x;v_y;z_D];
A = [a_x;a_y;z_D];
% Return trajectory
t = [t, t(2:end)+t(end)];
X = [X,X(:,end-1:-1:1)];
V = [V,-V(:,end-1:-1:1)];
A = [A,A(:,end-1:-1:1)];
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