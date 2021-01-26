% teleop_sim_comparison.m
close all;
clear;
data_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/output_data/";
fig_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/figures/";

t_delay_str = "T200";
IPT_str = ["none","sRIPT"];
pc_type = "MTDPC";
exp_config = [join([IPT_str(1),pc_type,t_delay_str],"_");
              join([IPT_str(2),pc_type,t_delay_str],"_")];
date_str = "2021-01-25";
data_files = [join([date_str,"ipt-sim",exp_config(1)],"_");
              join([date_str,"ipt-sim",exp_config(2)],"_")];
data_labels = ["no-IPT+MTDPC",IPT_str(2)+"+MTDPC"];
line_specs = {'-','-','-','-'};
fig_name = "error-comp_" + exp_config(2);

for i = 1:length(data_files)
    d{i} = load(strcat(data_dir, data_files(i)));
end
h = figure;
h.Position(3:4) = [628 275];
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
%     axis([0 10 0 inf]);
    grid on;
    legend(data_labels)
    title(strcat("True tracking error comparison (Delay ",...
                 num2str(round(1000*d{i}.wrkspcVars.T)), " ms)"));
    drawnow;
    saveas(h,fig_dir + fig_name + "-" + num2str(i)+".fig");
    saveas(h,fig_dir + fig_name + "-" + num2str(i)+".png");
end
hold off
h = figure;
for i = [1,2]
    plot(d{i}.LOP_p, line_specs{i});
    hold on;
    xlabel('Time [s]');
    ylabel('LOP');
%     axis([0 10 0 inf]);
    grid on;
    legend(data_labels)
    title(strcat("Lack of passivity comparison (Delay ",...
                 num2str(round(1000*d{i}.wrkspcVars.T)), " ms)"));
    drawnow;
end
saveas(h,fig_dir + 'LOP-comp_' + exp_config(2) + ".fig");
saveas(h,fig_dir + 'LOP-comp_' + exp_config(2) + ".png");

figure;
for i = 1:length(d)
    plot(d{i}.alpha, line_specs{i})
    hold on;
end
hold off
xlabel('Time [s]');
ylabel('Alpha (MTDPC Damping)');
grid on;
legend(data_labels)