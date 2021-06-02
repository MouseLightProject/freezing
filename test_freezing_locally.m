path_to_this_folder = fileparts(mfilename('fullpath')) ;
mj2_output_folder_path = fullfile(path_to_this_folder, 'freezing-test-output-folder') ;
tif_input_folder_path = fullfile(path_to_this_folder, 'freezing-test-input-folder') ;
compression_ratio = 10 ;
do_verify = false ;
do_run_on_cluster = false ;
maximum_running_slot_count = 40 ;

% Delete the test output folder
reset_for_test(mj2_output_folder_path) ;

% Call the script
freeze_sample
