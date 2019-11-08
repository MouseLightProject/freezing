mj2_from_tif(mj2_output_folder_path, tif_input_folder_path, compression_ratio, do_verify, do_run_on_cluster)
%is_all_well = verify_frozen_files(mj2_output_folder_path, tif_input_folder_path, do_run_on_cluster) 

fprintf('Doing batch preverification of .tif files...\n') ;
batch_preverify_tif_files_after_mj2_from_tif(mj2_output_folder_path, tif_input_folder_path, do_run_on_cluster)
fprintf('Done with batch preverification of .tif files.\n') ;

fprintf('Doing verification of .tif files...\n') ;
verify_tif_files_after_mj2_from_tif(tif_input_folder_path, mj2_output_folder_path) ;
fprintf('Done with verification of .tif files.\n') ;

fprintf('Doing verification of non-.tif files...\n') ;        
verify_non_tif_files_after_mj2_from_tif(mj2_output_folder_path, tif_input_folder_path) ;
fprintf('Done with verification of non-.tif files.\n') ;        

% Delete certificate files (just run locally)
find_and_batch(mj2_output_folder_path, ...
               @does_file_name_match_certificate_file, ...
               @delete, ...
               false, ...
               '') ;

% Do a final comparison of .tif files and .mj2 files, just for the heck of it
[status, result] = system(sprintf('find %s -name "*.tif" -print | wc -l', tif_input_folder_path)) ;
if status~= 0 ,
    error('Unable to count number of .tif files\n') ;
end
final_tif_count = str2double(result) ;
fprintf('.tif count in %s is: %d\n', tif_input_folder_path, final_tif_count) ;

[status, result] = system(sprintf('find %s -name "*.mj2" -print | wc -l', mj2_output_folder_path)) ;
if status~= 0 ,
    error('Unable to count final number of .mj2 files\n') ;
end
final_mj2_count = str2double(result) ;
fprintf('Final .mj2 count in %s is: %d\n', mj2_output_folder_path, final_mj2_count) ;
           
% Report final status if we get this far
fprintf('Compression and verification succeeded!\n') ;



