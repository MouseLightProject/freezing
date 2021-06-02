function modpath()
    this_folder_path = fileparts(mfilename('fullpath')) ;
    tmt_modpath_path = fullfile(this_folder_path, 'tmt', 'modpath.m') ;
    run(tmt_modpath_path) ;
end
