% teleop_sim_plotting.m

close all;
clear;
data_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/output_data/";
data_file = "2021-02-01_ipt-vy-sim_none_no-PC_T200";
load(strcat(data_dir, data_file));

error_vel = velocity_patient - velocity_desired;

figure;
subplot(2,2,1);
plot(position_patient.Time, position_patient.Data(:,1));
xlabel('Time [s]');
ylabel('Hand position [m]');
title('X-Direction');
grid on;
subplot(2,2,2);
plot(position_patient.Time, position_patient.Data(:,2));
xlabel('Time [s]');
ylabel('Hand position [m]');
title('Y-Direction');
grid on;
subplot(2,2,3);
plot(velocity_patient.Time,velocity_patient.Data(:,1),...
     velocity_desired.Time,velocity_desired.Data(:,1));
xlabel('Time [s]');
ylabel('Hand velocity [m/s]');
legend('Actual','Desired');
grid on;
subplot(2,2,4);
plot(velocity_patient.Time,velocity_patient.Data(:,2),...
     velocity_desired.Time,velocity_desired.Data(:,2));
xlabel('Time [s]');
ylabel('Hand velocity [m/s]');
legend('Actual','Desired');
grid on;

% 2D trajectory plot
figure;
plot(position_patient.Data(:,1),...
     position_patient.Data(:,2));
xlabel('X position [m]');
ylabel('Y position [m]');
axis equal;
grid on;

% Force plot
f_th_d_mag = calc_timeseries_magnitude(f_th_d);
f_mod_mag = calc_timeseries_magnitude(f_mod);
figure;
plot(f_th_d_mag.Time,f_th_d_mag.Data,...
     f_mod_mag.Time,f_mod_mag.Data);
xlabel('Time [s]')
ylabel('Force magn. [N]')
legend('Therapist','Modified');
grid on;

% Velocity magnitude
v_p_mag = calc_timeseries_magnitude(velocity_patient);
v_d_mag = calc_timeseries_magnitude(velocity_desired);
figure;
plot(v_p_mag.Time,v_p_mag.Data, v_d_mag.Time, v_d_mag.Data)
xlabel('Time [s]');
ylabel('Velocity magn. [m/s]');
legend('Actual','Desired');

% Rotational Impact Plots
v_p = velocity_patient;
v_p_d = velocity_patient_d;
[fa_change_rel_total, fa_rel_intent] = calc_norm_assist_change(f_th_d,v_p,v_p_d);
assist_change_sign = sign_timeseries(dot_product_timeseries(f_th_d,v_p_d)*dot_product_timeseries(f_th_d,v_p));

figure;
subplot(2,1,1);
plot(fa_change_rel_total)
% hold on;
% plot(assist_change_sign)
xlabel('Time [s]');
ylabel('Relative change [N/N]')
title('Assistance change relative to total force');
grid on;
subplot(2,1,2);
plot(fa_rel_intent);
xlabel('Time [s]');
ylabel('Relative change [N/N]')
title('Actual assistance relative to Intended assistance')
grid on;

if decode_type >= 1
% Velocity rotation angle
    figure;
    plot(theta_v);
    xlabel('Time [s]');
    ylabel('Angle [rad]');
    title('Relative velocity angle, theta_v');
    grid on;
end
if passivity_control_type == 1
% LOP integration
    figure;
    plot(LOP_p);
    xlabel('Time [s]');
    ylabel('LOP');
    title('Patient Lack-of-Passivity');
    grid on;
end

function [fa_change_rel_total, fa_rel_intent] = calc_norm_assist_change(f,v_p,v_p_d)
    v_p_mag = calc_timeseries_magnitude(v_p);
    v_p_d_mag = calc_timeseries_magnitude(v_p_d);
    f_mag = calc_timeseries_magnitude(f);
    fa_intent = dot_product_timeseries(f,v_p_d./v_p_d_mag);
    fa_actual = dot_product_timeseries(f,v_p./v_p_mag);
    assistance_change = fa_actual - fa_intent;
    fa_change_rel_total = assistance_change./f_mag;
    fa_rel_intent = fa_actual/fa_intent;
end