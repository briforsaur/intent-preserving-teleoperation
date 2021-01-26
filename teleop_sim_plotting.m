% teleop_sim_plotting.m

close all;
clear;
data_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/output_data/";
data_file = "2021-01-25_ipt-sim_sRIPT_MTDPC_T200";
load(strcat(data_dir, data_file));

error_pos = position_patient - position_desired;
error_vel = velocity_patient - velocity_desired;
true_tracking_error = timeseries([error_pos.Data, error_vel.Data],...
                                 error_pos.Time);
true_tracking_error_mag = calc_timeseries_magnitude(true_tracking_error);

figure;
subplot(3,2,1);
plot(position_patient.Time, position_patient.Data(:,1),...
     position_desired.Time, position_desired.Data(:,1));
xlabel('Time [s]');
ylabel('Hand position [m]');
legend('Actual','Desired');
title('X-Direction');
subplot(3,2,2);
plot(position_patient.Time, position_patient.Data(:,2),...
     position_desired.Time, position_desired.Data(:,2));
xlabel('Time [s]');
ylabel('Hand position [m]');
legend('Actual','Desired');
title('Y-Direction');
subplot(3,2,3);
plot(velocity_patient.Time,velocity_patient.Data(:,1),...
     velocity_desired.Time,velocity_desired.Data(:,1));
xlabel('Time [s]');
ylabel('Hand velocity [m/s]');
legend('Actual','Desired');
subplot(3,2,4);
plot(velocity_patient.Time,velocity_patient.Data(:,2),...
     velocity_desired.Time,velocity_desired.Data(:,2));
xlabel('Time [s]');
ylabel('Hand velocity [m/s]');
legend('Actual','Desired');
subplot(3,1,3);
plot(true_tracking_error_mag);
xlabel('Time [s]');
ylabel('Error magnitude');

% 2D trajectory plot
figure;
plot(position_patient.Data(:,1),...
     position_patient.Data(:,2),...
     position_desired.Data(:,1),...
     position_desired.Data(:,2));
xlabel('X position [m]');
ylabel('Y position [m]');
legend('Actual','Desired');
axis equal;
axis(1.2*max(max(wrkspcVars.X))*[-0.05 0.95 -0.05 0.95]);

% % Force plot
% f_th_d_mag = calc_timeseries_magnitude(f_th_d);
% f_mod_mag = calc_timeseries_magnitude(f_mod);
% figure;
% plot(f_th_d_mag.Time,f_th_d_mag.Data,...
%      f_mod_mag.Time,f_mod_mag.Data);
% xlabel('Time [s]')
% ylabel('Force magn. [N]')
% legend('Therapist','Modified');

% % Velocity magnitude
% velocity_patient_mag = calc_timeseries_magnitude(velocity_patient);
% figure;
% plot(velocity_patient_mag.Time,velocity_patient_mag.Data)
% xlabel('Time [s]');
% ylabel('Velocity magn. [m/s]');

if decode_type >= 1
% Velocity rotation angle
    figure;
    plot(theta_v);
    xlabel('Time [s]');
    ylabel('Angle [rad]');
    title('Relative velocity angle, theta_v');
end
if passivity_control_type == 1
% LOP integration
    figure;
    plot(LOP_p);
    xlabel('Time [s]');
    ylabel('LOP');
    title('Patient Lack-of-Passivity');
end