% create_trajectories.m
close all;
clearvars;

trajectory_dir = "./trajectories/";
data_filename = datestr(now,29) + "circle_trajectory.mat";

dt = 0.001; %[s] Maximum simulation step
t_max = 20; %[s] Total simulation runtime

% Circle parameters
% Radius of the circle
R = 0.2; %[m]
% Time per circuit
T = 5; %[s]

% Intitial conditions
X_0 = [R,0,0];

t = 0:dt:t_max;
%% Generating trajectory
frequency = 2*pi/T;
cos_values = cos(frequency*t);
sin_values = sin(frequency*t);
X = R*[cos_values; sin_values; zeros(size(t))];
V = R*frequency*[-sin_values; cos_values; zeros(size(t))];
A = R*frequency^2*[-cos_values; -sin_values; zeros(size(t))];

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