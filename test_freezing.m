path_to_this_script = mfilename('fullpath') ;
path_to_this_folder = fileparts(path_to_this_script) ;
mj2_output_folder_path = fullfile(path_to_this_folder, 'freezing-test-output-folder') ;
tif_input_folder_path = fullfile(path_to_this_folder, 'freezing-test-input-folder') ;
compression_ratio = 10 ;
do_verify = false ;
do_run_on_cluster = false ;

reset_for_test(mj2_output_folder_path) ;

mj2_from_tif(mj2_output_folder_path, tif_input_folder_path, compression_ratio, do_verify, do_run_on_cluster)
%is_all_well = verify_frozen_files(mj2_output_folder_path, tif_input_folder_path, do_run_on_cluster) 

fprintf('Doing batch preverification of large files...\n') ;
batch_preverify_tif_files_after_mj2_from_tif(mj2_output_folder_path, tif_input_folder_path, do_run_on_cluster)
fprintf('Done with batch preverification of large files.\n') ;

fprintf('Doing verification of large files...\n') ;
is_all_well_with_big_files = verify_tif_files_after_mj2_from_tif(tif_input_folder_path, mj2_output_folder_path) ;
fprintf('Done with verification of large files.\n') ;

if is_all_well_with_big_files, 
    fprintf('Doing verification of small files...\n') ;        
    is_all_well = verify_non_tif_files_after_mj2_from_tif(mj2_output_folder_path, tif_input_folder_path) ;
    fprintf('Done with verification of small files.\n') ;        
else
    is_all_well = false ;
end

if is_all_well ,
    fprintf('Compression and verification succeeded!\n') ;
else
    fprintf('Compression and/or verification failed.\n') ;
end

