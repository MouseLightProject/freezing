path_to_this_script = mfilename('fullpath') ;
path_to_this_folder = fileparts(path_to_this_script) ;
mj2_output_folder_path = fullfile(path_to_this_folder, 'freezing-test-output-folder') ;
tif_input_folder_path = fullfile(path_to_this_folder, 'freezing-test-input-folder') ;
compression_ratio = 10 ;
do_verify = false ;
do_run_on_cluster = true ;

reset_for_test(mj2_output_folder_path) ;
mj2_from_tif(mj2_output_folder_path, tif_input_folder_path, compression_ratio, do_verify, do_run_on_cluster)
is_all_well = verify_frozen_files(mj2_output_folder_path, tif_input_folder_path, do_run_on_cluster) 
