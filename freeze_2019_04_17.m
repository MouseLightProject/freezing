sample_date = '2019-04-17' ;
mj2_output_folder_path = sprintf('/nrs/mouselight-v/frozen/%s', sample_date) ;
tif_input_folder_path = sprintf('/groups/mousebrainmicro/mousebrainmicro/data/%s', sample_date) ;
compression_ratio = 10 ;
do_verify = false ;
do_run_on_cluster = true ;

mj2_from_tif(mj2_output_folder_path, tif_input_folder_path, compression_ratio, do_verify, do_run_on_cluster)
%is_all_well = verify_frozen_files(mj2_output_folder_path, tif_input_folder_path, do_run_on_cluster) 

fprintf('Doing batch preverification of .tif files...\n') ;
batch_preverify_tif_files_after_mj2_from_tif(mj2_output_folder_path, tif_input_folder_path, do_run_on_cluster)
fprintf('Done with batch preverification of .tif files.\n') ;

fprintf('Doing verification of .tif files...\n') ;
is_all_well = verify_tif_files_after_mj2_from_tif(tif_input_folder_path, mj2_output_folder_path) ;
fprintf('Done with verification of .tif files.\n') ;

% If anything is amiss, exit
if ~is_all_well , 
    fprintf('Compression and/or verification failed.\n') ;
    return
end

fprintf('Doing verification of non-.tif files...\n') ;        
is_all_well = verify_non_tif_files_after_mj2_from_tif(mj2_output_folder_path, tif_input_folder_path) ;
fprintf('Done with verification of non-.tif files.\n') ;        

% If anything is amiss, exit
if ~is_all_well , 
    fprintf('Compression and/or verification failed.\n') ;
    return
end

% Delete certificate files
find_and_batch(mj2_output_folder_path, ...
               @does_file_name_match_certificate_file, ...
               @delete, ...
               false, ...
               '') ;

% Do a final comparison of .tif files and .mj2 files, just for the heck of it
[status, result] = system(sprintf('find %s -name "*.tif" -print | wc -l', tif_input_folder_path)) ;
if status~= 0 ,
    is_all_well = false ;
    fprintf('Unable to count number of .tif files\n') ;
    return
end
final_tif_count = str2double(result) ;
fprintf('.tif count in %s is: %d\n', tif_input_folder_path, final_tif_count) ;

[status, result] = system(sprintf('find %s -name "*.mj2" -print | wc -l', mj2_output_folder_path)) ;
if status~= 0 ,
    is_all_well = false ;
    fprintf('Unable to count final number of .mj2 files\n') ;
    return
end
final_mj2_count = str2double(result) ;
fprintf('Final .mj2 count in %s is: %d\n', mj2_output_folder_path, final_mj2_count) ;
           
% Report final status           
if is_all_well ,
    fprintf('Compression and verification succeeded!\n') ;
else
    fprintf('Compression and/or verification failed.\n') ;
end

