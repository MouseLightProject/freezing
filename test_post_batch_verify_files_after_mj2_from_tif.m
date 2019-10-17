this_script_path = mfilename('fullpath') ;
this_folder_path = fileparts(this_script_path) ;
tif_input_folder_path = fullfile(this_folder_path, 'mj2-from-tif-test-input-folder') ;
mj2_output_folder_path = fullfile(this_folder_path, 'mj2-from-tif-test-output-folder') ;
post_batch_verify_files_after_mj2_from_tif(mj2_output_folder_path, tif_input_folder_path)
