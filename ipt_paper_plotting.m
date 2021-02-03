% ipt_paper_plotting.m

close all;
clear;
data_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/published_data/";
data_file = "2021-02-01_ipt-vy-sim_none_no-PC_T200_no_assistance";
load(strcat(data_dir, data_file));

figure;
subplot(2,1,1);
plot(velocity_patient.Time,velocity_patient.Data(:,1),...
     velocity_desired.Time,velocity_desired.Data(:,1));
xlabel('Time [s]');
ylabel('X velocity [m/s]');
legend('Actual','Desired');
grid on;
subplot(2,1,2);
plot(velocity_patient.Time,velocity_patient.Data(:,2),...
     velocity_desired.Time,velocity_desired.Data(:,2));
xlabel('Time [s]');
ylabel('Y velocity [m/s]');
legend('Actual','Desired');
grid on;
