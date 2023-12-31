% ipt_paper_plotting.m

close all;
clearvars;
data_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/published_data/";
fig_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/published_figures/";

single_col_width = 245; % pt
double_col_width = 505; % pt

%% No assistance plots
NA_file = "2021-02-11_ipt-circle-sim_none_no-PC_T200_no_assistance";%"2021-02-08_ipt-vy-sim_none_no-PC_T200_no_assistance";
NA_data = load(strcat(data_dir, NA_file));
h_NA = figure;
h_NA.Name = "No Assistance - Velocity";
plot_velocity_components(NA_data.velocity_patient,...
                         NA_data.velocity_desired,...
                         [1 2]);
%% No IPT plots
NI_file = "2021-02-11_ipt-circle-sim_none_no-PC_T200";%"2021-02-08_ipt-vy-sim_none_no-PC_T200";
NI_data = load(strcat(data_dir, NI_file));
% Velocity plot
h_NI = figure;
h_NI.Name = "No IPT - Velocity";
plot_velocity_components(NI_data.velocity_patient,...
                         NI_data.velocity_desired,...
                         [1 2]);
%% RIPT plots
RIPT_file = "2021-02-11_ipt-circle-sim_RIPT_no-PC_T200";%"2021-02-08_ipt-vy-sim_RIPT_no-PC_T200";
RIPT_data = load(strcat(data_dir, RIPT_file));
h_RIPT = figure;
h_RIPT.Name = "RIPT - Velocity";
plot_velocity_components(RIPT_data.velocity_patient,...
                                  RIPT_data.velocity_desired,...
                                  [1 2]);
%% sRIPT plots
sRIPT_file = "2021-02-11_ipt-circle-sim_sRIPT_no-PC_T200";%"2021-02-08_ipt-vy-sim_sRIPT_no-PC_T200";
sRIPT_data = load(strcat(data_dir, sRIPT_file));
% Velocity
h_sRIPT = figure;
h_sRIPT.Name = "sRIPT - Velocity";
plot_velocity_components(sRIPT_data.velocity_patient,...
                                   sRIPT_data.velocity_desired,...
                                   [1 2]);
%% Comparison plots

% Velocity magnitude comparison
v_d_mag = calc_timeseries_magnitude(NA_data.velocity_desired);
NA_v_p_mag = calc_timeseries_magnitude(NA_data.velocity_patient);
NI_v_p_mag = calc_timeseries_magnitude(NI_data.velocity_patient);
RIPT_v_p_mag = calc_timeseries_magnitude(RIPT_data.velocity_patient);
sRIPT_v_p_mag = calc_timeseries_magnitude(sRIPT_data.velocity_patient);
h_C = figure;
h_C.Name = "Comparison - Velocity magnitude";
plot(v_d_mag.Time, v_d_mag.Data, 'k--',...
     NA_v_p_mag.Time, NA_v_p_mag.Data,'-',...
     NI_v_p_mag.Time, NI_v_p_mag.Data,'-',...
     RIPT_v_p_mag.Time, RIPT_v_p_mag.Data,'-',...
     sRIPT_v_p_mag.Time, sRIPT_v_p_mag.Data,'-')
xlabel('Time [s]');
ylabel('Velocity magn. [m/s]');
legend('Desired','No Assistance','Assisted - No IPT','RIPT','sRIPT');
% Assistance force change comparison
h_C(2) = figure;
h_C(2).Name = "Comparison - Assistance change";
labels = {'No IPT','RIPT','sRIPT'};
datasets = {NI_data, RIPT_data, sRIPT_data};
subplot(2,1,1)
plot_force_change_comp(datasets)
title('Change in Assistance Relative to Intended Assistance');
xlabel('Time [s]')
ylabel('Relative Assitance Change')
% Highlighted regions
fill([0,0;0,0;20,20;20,20],[0,-2;1,-3;1,-3;0,-2],'g','FaceAlpha',0.1,'EdgeColor','none')
fill([0,0,0;0,0,0;20,20,20;20,20,20],[0,-3,1;-2,-4,2;-2,-4,2;0,-3,1],'y','FaceAlpha',0.1,'EdgeColor','none')
fill([0;0;20;20],[2;4;4;2],'r','FaceAlpha',0.1,'EdgeColor','none')
%axis([-inf inf -2 6]);
legend(labels)
subplot(2,1,2)
for i = 1:length(datasets)
    plot(dot_product_timeseries(datasets{i}.f_mod,...
                                datasets{i}.velocity_patient));
    hold on;
end
hold off;
title('');
xlabel('Time [s]');
ylabel('Power [W]');
grid on;
legend(labels)
%% Function definitions
function plot_velocity_components(v_p,v_d,dims)
    labels = 'XYZ';
    N = length(dims);
    for i = 1:N
        subplot(N,1,i);
        plot(v_p.Time,v_p.Data(:,dims(i)),'k-',...
             v_d.Time,v_d.Data(:,dims(i)),'k--');
        xlabel('Time [s]');
        ylabel([labels(dims(i)) ' velocity [m/s]']);
        legend('Actual','Desired');
        grid on;
    end
end

function plot_force_change(f_mod, f_th_d, v_p, v_p_d)
    fa_change_angle = assistance_change(f_mod, f_th_d, v_p, v_p_d);
    plot(fa_change_angle,'k-')
    xlabel('Time [s]');
    ylabel('Relative Assistance')
    title('Assistance change relative to Intended assistance');
end

function plot_force_change_comp(datasets)
    for i = 1:length(datasets)
        fa_change_angle = assistance_change(...
            datasets{i}.f_mod,...
            datasets{i}.f_th_d,...
            datasets{i}.velocity_patient,...
            datasets{i}.velocity_patient_d);
        plot(fa_change_angle)
        hold on;
        grid on;
    end
end

function fa_change_angle = assistance_change(f_mod, f_d, v_p, v_p_d)
    v_p_mag = calc_timeseries_magnitude(v_p);
    v_p_d_mag = calc_timeseries_magnitude(v_p_d);
    fa_intent = dot_product_timeseries(f_d, v_p_d./v_p_d_mag);
    fa_actual = dot_product_timeseries(f_mod, v_p./v_p_mag);
    fa_change_angle = timeseries(atan2(fa_actual.Data,fa_intent.Data),...
                                 fa_actual.Time);
    fa_change_angle = fa_change_angle/(pi/4);
end