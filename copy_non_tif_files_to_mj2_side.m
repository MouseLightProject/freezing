function copy_non_tif_files_to_mj2_side(mj2_folder_name, ...
                                        tif_folder_name)
    % Find all non-.tif files, copy them over to the mj2 side
    
    do_submit = false ;
    do_try = true ;
    maximum_running_slot_count = 400 ;  % doesn't matter
    slots_per_job = 1 ;  % doesn't matter
    bsub_options = '-P mouselight -W 59 -J copy' ;  % doesn't matter
    submit_host_name = '' ;
    find_and_batch(tif_folder_name, ...
                   @is_a_non_tif_and_target_missing, ...
                   @copy_file_for_find_and_batch, ...
                   'do_submit', do_submit, ...
                   'do_try', do_try, ...
                   'submit_host_name', submit_host_name, ...
                   'maximum_running_slot_count', maximum_running_slot_count, ...
                   'slots_per_job', slots_per_job, ...
                   'bsub_options', bsub_options, ...
                   'predicate_extra_args', {tif_folder_name, mj2_folder_name} , ...
                   'batch_function_extra_args', {tif_folder_name, mj2_folder_name} ) ;
end
