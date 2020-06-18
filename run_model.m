% run_model.m
clear;
save_output = false;
% Defining file names and directories
output_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/";
data_dir = "output_data/";
model_name = 'teleop_sim_angle';
setup_script = "teleop_sim_setup.m";
% Selecting the type of IPT decoding that will be used - default is no IPT
decode_type = 0;
rotationIPT = Simulink.Variant('decode_type == 1');
% Updating the model workspace and adding it to the base workspace as a
% structure for debugging and saving
update_model_workspace(model_name, setup_script);
wrkspcVars = get_model_workspace(model_name);
% Simulating the model
sim(model_name);

if save_output
    % Saving all simulation inputs and outputs, except the dir strings
    save(strcat(output_dir, data_dir, datestr(now,30), "_", model_name),...
         '-regexp', '^(?!(model_dir|output_data_dir|start_dir|tout)$).');
end