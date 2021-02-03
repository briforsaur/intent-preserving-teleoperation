% create_trajectories.m
close all;
clearvars;

trajectory_dir = "./trajectories/";
data_filename = datestr(now,29) + "rand_y_trajectory.mat";

dt = 0.001; % Maximum simulation step
t_max = 20; % Total simulation runtime

% Set of random values used to create random points to reach
r_points = [0.20;0.30;0.05;0.43;0.95;0.49;0.64;0.5;0.64;0.91];
% Maximum position to reach
x_max = 0.25; % [m]
% Maximum allowable velocity
v_max = 0.25; % [m/s]

% Intitial conditions
X_0 = zeros(3,1);
% Desired x position
x_f = 0.4;
% Desired y positions
y_f = 0.2.*(r_points - 0.5);

t = 0:dt:t_max;
X = zeros(3,length(t));
V = X;
A = X;
%% Generating X trajectory
[~,x_d,v_x,a_x] = generate_min_jerk_trajectory(X_0(1),x_f,t_max/2,dt);
X(1,:) = [x_d, x_d(end-1:-1:1)];
V(1,:) = [v_x, -v_x(end-1:-1:1)];
A(1,:) = [a_x, a_x(end-1:-1:1)];
%% Generating Y trajectory
t_y = t_max/length(y_f);
N_y = floor(t_y/dt);
for i = 1:length(y_f)
    start_ind = N_y*(i-1)+1;
    end_ind = N_y*i+1;
    [~,y_d,v_y,a_y] = generate_min_jerk_trajectory(X(2,start_ind),y_f(i),t_y,dt);
    X(2,start_ind:end_ind) = y_d;
    V(2,start_ind:end_ind) = v_y;
    A(2,start_ind:end_ind) = a_y;
end

save(trajectory_dir+data_filename,'t','X','V','A');

figure;
subplot(3,3,1);
plot(t,X(1,:));
subplot(3,3,2);
plot(t,X(2,:));
subplot(3,3,3);
plot(t,X(3,:));
subplot(3,3,4);
plot(t,V(1,:));
subplot(3,3,5);
plot(t,V(2,:));
subplot(3,3,6);
plot(t,V(3,:));
subplot(3,3,7);
plot(t,A(1,:));
subplot(3,3,8);
plot(t,A(2,:));
subplot(3,3,9);
plot(t,A(3,:));

figure;
plot(X(1,:),X(2,:));