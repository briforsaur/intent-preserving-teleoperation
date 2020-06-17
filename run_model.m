% run_model.m
clear;

start_dir = pwd;
output_dir = "E:/Users/shfor/OneDrive - Queen's University/sim_data_and_outputs/intent_preserving_teleop/";
data_dir = "output_data/";
model_dir = "models/";
model_name = 'teleop_sim_angle';
setup_script = "teleop_sim_setup.m";
% It's easier to work in the model's directory temporarily
cd(model_dir)
update_model_workspace(model_name, setup_script);
wrkspcVars = get_model_workspace(model_name);
sim(model_name);
cd(start_dir)

% Saving all simulation inputs and outputs, except the directory strings
save(strcat(output_dir, data_dir, datestr(now,30), "_", model_name),...
     '-regexp', '^(?!(model_dir|output_data_dir|start_dir|tout)$).');

function update_model_workspace(model_name, script_path)
    save_flag = false;
    if ~bdIsLoaded(model_name)
        load_system(model_name);
    end
    mdlWorkspace = get_param(model_name,'ModelWorkspace');
    if ~strcmp(mdlWorkspace.DataSource, 'MATLAB File')
        mdlWorkspace.DataSource = 'MATLAB File';
        save_flag = true;
    end
    if ~strcmp(mdlWorkspace.FileName, script_path)
        mdlWorkspace.FileName = script_path;
        save_flag = true;
    end
    if save_flag
        save_system(model_name);
    end
    reload(mdlWorkspace);
end

function mdlWorkspaceVars = get_model_workspace(model_name)
    mdlWorkspace = get_param(model_name,'ModelWorkspace');
    var_list = whos(mdlWorkspace);
    for i = 1:length(var_list)
        var_name = var_list(i).name;
        mdlWorkspaceVars.(var_name) = getVariable(mdlWorkspace, var_name);
    end
end