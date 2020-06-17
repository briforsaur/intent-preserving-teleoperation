function update_model_workspace(model_name, script_path)
    if ~bdIsLoaded(model_name)
        load_system(model_name);
    end
    mdlWorkspace = get_param(model_name,'ModelWorkspace');
    if ~strcmp(mdlWorkspace.DataSource, 'MATLAB File')
        mdlWorkspace.DataSource = 'MATLAB File';
    end
    if ~strcmp(mdlWorkspace.FileName, script_path)
        mdlWorkspace.FileName = script_path;
    end
    reload(mdlWorkspace);
    save_system(model_name);
end