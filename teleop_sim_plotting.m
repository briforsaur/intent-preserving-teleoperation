% teleop_sim_plotting.m

close all;

t = position_patient.time;
true_tracking_error = [position_patient.signals.values - position_desired.signals.values,...
    velocity_patient.signals.values - velocity_desired.signals.values];
true_tracking_error_mag = sqrt(sum(true_tracking_error.^2,2));

figure;
subplot(3,2,1);
plot(position_patient.time, position_patient.signals.values(:,1),...
     position_desired.time, position_desired.signals.values(:,1));
xlabel('Time [s]');
ylabel('Hand position [m]');
legend('Actual','Desired');
title('X-Direction');
subplot(3,2,2);
plot(position_patient.time, position_patient.signals.values(:,2),...
     position_desired.time, position_desired.signals.values(:,2));
xlabel('Time [s]');
ylabel('Hand position [m]');
legend('Actual','Desired');
title('Y-Direction');
subplot(3,2,3);
plot(velocity_patient.time,velocity_patient.signals.values(:,1),...
     velocity_desired.time,velocity_desired.signals.values(:,1));
xlabel('Time [s]');
ylabel('Hand velocity [m/s]');
legend('Actual','Desired');
subplot(3,2,4);
plot(velocity_patient.time,velocity_patient.signals.values(:,2),...
     velocity_desired.time,velocity_desired.signals.values(:,2));
xlabel('Time [s]');
ylabel('Hand velocity [m/s]');
legend('Actual','Desired');
subplot(3,1,3);
plot(t,true_tracking_error_mag);
xlabel('Time [s]');
ylabel('Error magnitude');

% 2D trajectory plot
figure;
plot(position_patient.signals.values(:,1),...
     position_patient.signals.values(:,2),...
     position_desired.signals.values(:,1),...
     position_desired.signals.values(:,2));
xlabel('X position [m]');
ylabel('Y position [m]');
legend('Actual','Desired');

% Force plot
figure;
subplot(2,1,1);
plot(f_th_d.time,sqrt(sum(f_th_d.signals.values.^2,2)),...
     f_mod.time,sqrt(sum(f_mod.signals.values.^2,2)));
xlabel('Time [s]')
ylabel('Force magn. [N]')
legend('Therapist','Modified');
subplot(2,1,2);
plot(f_a.time,sqrt(sum(f_a.signals.values.^2,2)),...
     f_g.time,sqrt(sum(f_g.signals.values.^2,2)));
xlabel('Time [s]');
ylabel('Force magn. [N]');
legend('Assistance','Guidance');

% Velocity magnitude
figure;
plot(velocity_patient.time,sqrt(sum(velocity_patient.signals.values.^2,2)))
xlabel('Time [s]');
ylabel('Velocity magn. [m/s]');