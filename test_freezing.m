path_to_this_script = mfilename('fullpath') ;
path_to_this_folder = fileparts(path_to_this_script) ;
mj2_output_folder_path = fullfile(path_to_this_folder, 'mj2-from-tif-test-output-folder') ;
tif_input_folder_path = fullfile(path_to_this_folder, 'mj2-from-tif-test-input-folder') ;
compression_ratio = 10 ;
do_verify = true ;
do_delete_input_files = true ;
do_run_on_cluster = true ;
mj2_from_tif(mj2_output_folder_path, tif_input_folder_path, compression_ratio, do_verify, do_delete_input_files, do_run_on_cluster)
