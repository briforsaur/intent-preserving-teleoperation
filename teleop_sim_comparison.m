% teleop_sim_comparison.m
close all;
clear;
data_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/output_data/";
data_file = ["2020-07-14_intent_preserving_teleop_sim_RIPT_T30";
             "2020-07-14_intent_preserving_teleop_sim_none_T30"];
data_labels = ["RIPT", "No IPT"];

d{1} = load(strcat(data_dir, data_file(1)));
d{2} = load(strcat(data_dir, data_file(2)));

figure;
for i = 1:length(d)
    error_pos = d{i}.position_patient - d{i}.position_desired;
    error_vel = d{i}.velocity_patient - d{i}.velocity_desired;
    d{i}.true_error = timeseries([error_pos.Data, error_vel.Data],...
                                  error_pos.Time);
    d{i}.true_error_mag = calc_timeseries_magnitude(d{i}.true_error);
    plot(d{i}.true_error_mag);
    hold on;
    xlabel('Time [s]');
    ylabel('Error magnitude');
end
legend(data_labels)
title('True tracking error comparison');
hold off