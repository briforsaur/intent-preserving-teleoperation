% teleop_vector_animation.m
close all;
clear;
data_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/output_data/";
data_file = "2021-01-20_ipt-sim_RIPT_MTDPC_T50";
load(strcat(data_dir, data_file));
               
f_factor = 0.1;

frame_time = 0.05;
slowmo_factor = 0.5;
v_resolution = [1920 1080]; %[1280 720] [2560 1440]

plot_times = 0:frame_time*slowmo_factor:max(velocity_patient.Time);

f_th_d = resample(f_th_d, plot_times);
f_mod = resample(f_mod, plot_times);
position_patient = resample(position_patient, plot_times);
velocity_patient = resample(velocity_patient, plot_times);

% Setting up video parameters
v = VideoWriter('force_rotation.mp4','MPEG-4');
v.FrameRate = 1/frame_time;
v.Quality = 90;
F(length(plot_times)) = struct('cdata',[],'colormap',[]);

h_fig = figure('visible','off');
h_fig.Position(3:4) = v_resolution;
plot(position_desired.Data(:,1),...
     position_desired.Data(:,2));
xlabel('X Position [m]');
ylabel('Y Position [m]');
title(['Rotation - ' num2str(wrkspcVars.T) ' ms delay (' num2str(slowmo_factor) 'x speed)'])
hold on;
h_axis = gca;
axis equal
axis([-0.05 0.35 -0.1 0.2]);
v_line = line([0 1],[0 0],'Color','r');
f_line = line([0 1],[0 1],'Color','b');
% f_a_line = line([0 0],[0 1],'Color','g');
% f_g_line = line([0 0],[0 1],'Color','k');
f_mod_line = line([0 0],[0 1],'Color','g');

f_wait = waitbar(0,'Processing video...');
v.open();
try
    for i = 1:length(plot_times)
        update_vector(f_line,f_factor*f_th_d.Data(i,1:2));
        move_vector(f_line,position_patient.Data(i,1:2));
    %     update_vector(f_a_line,f_a.Data(i,1:2));
    %     update_vector(f_g_line,f_g.Data(i,1:2));
        update_vector(f_mod_line,f_factor*f_mod.Data(i,1:2));
        move_vector(f_mod_line,position_patient.Data(i,1:2));
        update_vector(v_line,f_factor*velocity_patient.Data(i,1:2));
        move_vector(v_line,position_patient.Data(i,1:2));
        drawnow
        F(i) = getframe(h_fig);
        v.writeVideo(F(i))
        waitbar(i/length(plot_times),f_wait);
    end
catch ME
    v.close();
    disp('Closed!');
    rethrow(ME);
end
v.close();
disp('Closed!');
close(f_wait);

function update_vector(line_obj, new_vector)
    line_obj.XData = [line_obj.XData(1) line_obj.XData(1)+new_vector(1)];
    line_obj.YData = [line_obj.YData(1) line_obj.YData(1)+new_vector(2)];
end

function move_vector(line_obj, new_position)
    line_obj.XData = line_obj.XData - line_obj.XData(1) + new_position(1);
    line_obj.YData = line_obj.YData - line_obj.YData(1) + new_position(2);
end