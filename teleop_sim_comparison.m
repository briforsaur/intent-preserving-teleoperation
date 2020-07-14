% teleop_sim_comparison.m
close all;
clear;
data_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/output_data/";
fig_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/figures/";
% data_files = ["2020-07-14_ipt-sim_none_no-PC_T30";
%               "2020-07-14_ipt-sim_none_MTDPC_T30";
%               "2020-07-14_ipt-sim_RIPT_no-PC_T30";
%               "2020-07-14_ipt-sim_RIPT_MTDPC_T30"];
% data_labels = ["no-IPT, no PC","no-IPT+MTDPC","RIPT", "RIPT+MTDPC"];
% data_files = ["2020-07-14_ipt-sim_none_no-PC_T30";
%               "2020-07-14_ipt-sim_RIPT_no-PC_T30"];
% data_labels = ["no-IPT, no PC", "RIPT, no PC"];
data_files = ["2020-07-14_ipt-sim_none_MTDPC_T30";
              "2020-07-14_ipt-sim_RIPT_no-PC_T30";
              "2020-07-14_ipt-sim_RIPT_MTDPC_T30"];
data_labels = ["no-IPT+MTDPC","RIPT", "RIPT+MTDPC"];
line_specs = {'-','-','-','-'};
fig_name = "error-comp_MTDPC_T30-";

for i = 1:length(data_files)
    d{i} = load(strcat(data_dir, data_files(i)));
end
h = figure;
h.Position = [241 317 628 275];
for i = 1:length(d)
    error_pos = d{i}.position_patient - d{i}.position_desired;
    error_vel = d{i}.velocity_patient - d{i}.velocity_desired;
    d{i}.true_error = timeseries([error_pos.Data, error_vel.Data],...
                                  error_pos.Time);
    d{i}.true_error_mag = calc_timeseries_magnitude(d{i}.true_error);
    plot(d{i}.true_error_mag, line_specs{i});
    hold on;
    xlabel('Time [s]');
    ylabel('Error magnitude');
    axis([0 10 0 inf]);
    grid on;
    legend(data_labels)
    title('True tracking error comparison (Delay 30 ms)');
    drawnow;
    saveas(h,fig_dir + fig_name + num2str(i)+".fig");
    saveas(h,fig_dir + fig_name + num2str(i)+".png");
end
hold off