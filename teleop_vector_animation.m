% teleop_vector_animation.m
close all;
max_mag = sqrt(max([sum(velocity_patient.signals.values.*...
                       velocity_patient.signals.values,2);
                   sum(f_th_d.signals.values.*f_th_d.signals.values,2);
                   sum(f_mod.signals.values.*f_mod.signals.values,2)]));
               
f_factor = 0.1;

plot_times = 1:25:length(velocity_patient.time);

% Setting up video parameters
frame_time = 0.05;
v = VideoWriter('force_rotation.mp4','MPEG-4');
v.FrameRate = 1/frame_time;
F(length(plot_times)) = struct('cdata',[],'colormap',[]);

h_fig = figure('visible','off');
plot(position_desired.signals.values(:,1),...
     position_desired.signals.values(:,2));
xlabel('X Position [m]');
ylabel('Y Position [m]');
title('Rotation - 50 ms delay (0.5x speed)')
hold on;
h_axis = gca;
axis equal
axis([-0.4 0.4 -0.4 0.4]);
v_line = line([0 1],[0 0],'Color','r');
f_line = line([0 1],[0 1],'Color','b');
% f_a_line = line([0 0],[0 1],'Color','g');
% f_g_line = line([0 0],[0 1],'Color','k');
f_mod_line = line([0 0],[0 1],'Color','g');
v.open();
try
    for i = plot_times
        update_vector(f_line,-f_factor*f_th_d.signals.values(i,1:2));
        move_vector(f_line,position_patient.signals.values(i,1:2));
    %     update_vector(f_a_line,f_a.signals.values(i,1:2));
    %     update_vector(f_g_line,f_g.signals.values(i,1:2));
        update_vector(f_mod_line,-f_factor*f_mod.signals.values(i,1:2));
        move_vector(f_mod_line,position_patient.signals.values(i,1:2));
        update_vector(v_line,f_factor*velocity_patient.signals.values(i,1:2));
        move_vector(v_line,position_patient.signals.values(i,1:2));
        drawnow
        F(i) = getframe(h_fig);
        v.writeVideo(F(i))
    end
catch ME
    v.close();
    disp('Closed!');
    rethrow(ME);
end
v.close();
disp('Closed!');

function update_vector(line_obj, new_vector)
    line_obj.XData = [line_obj.XData(1) line_obj.XData(1)+new_vector(1)];
    line_obj.YData = [line_obj.YData(1) line_obj.YData(1)+new_vector(2)];
end

function move_vector(line_obj, new_position)
    line_obj.XData = line_obj.XData - line_obj.XData(1) + new_position(1);
    line_obj.YData = line_obj.YData - line_obj.YData(1) + new_position(2);
end