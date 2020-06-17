function mdlWorkspaceVars = get_model_workspace(model_name)
    mdlWorkspace = get_param(model_name,'ModelWorkspace');
    var_list = whos(mdlWorkspace);
    for i = 1:length(var_list)
        var_name = var_list(i).name;
        mdlWorkspaceVars.(var_name) = getVariable(mdlWorkspace, var_name);
    end
end