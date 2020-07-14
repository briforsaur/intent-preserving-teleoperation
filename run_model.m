% run_model.m
clear;
save_output = true;
% Defining file names and directories
output_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/";
data_dir = "output_data/";
base_data_name = 'ipt-sim';
model_name = 'intent_preserving_teleop_sim';
setup_script = "intent_preserving_teleop_setup.m";
% Selecting the type of IPT decoding that will be used - default is no IPT
decode_type = 0;
rotationIPT = Simulink.Variant('decode_type == 1');
% Selecting the type of passvitiy controller on the patient side, default is none
passivity_control_type = 0;
mtdpc_patient = Simulink.Variant('passivity_control_type == 1');
% Updating the model workspace and adding it to the base workspace as a
% structure for debugging and saving
update_model_workspace(model_name, setup_script);
wrkspcVars = get_model_workspace(model_name);
% Simulating the model
sim(model_name);

if save_output
    switch decode_type
        case 1
            IPT_name = 'RIPT';
        otherwise
            IPT_name = 'none';
    end
    switch passivity_control_type
        case 1
            PC_name = 'MTDPC';
        otherwise
            PC_name = 'no-PC';
    end
    file_name = strcat(datestr(now,29), "_", base_data_name, "_",...
                       IPT_name, "_", PC_name, "_T",...
                       num2str(round(1000*wrkspcVars.T)));
    disp(file_name);
    % Saving all simulation inputs and outputs, except the dir strings
    save(strcat(output_dir, data_dir, file_name),...
         '-regexp', '^(?!(model_dir|output_data_dir|start_dir|tout)$).');
end