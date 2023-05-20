function batch_convert_all_tif_files_to_mj2(mj2_folder_name, ...
                                            tif_folder_name, ...
                                            compression_ratio, ...
                                            do_submit, ...
                                            do_try, ...
                                            maximum_running_slot_count, ...
                                            submit_host_name)
    % Find all .tif files in folder tree, convert them to .mj2
    
    slots_per_job = 1 ;
    bsub_options = '-P mouselight -W 59 -J freeze' ;
    find_and_batch(tif_folder_name, ...
                   @does_file_name_end_in_dot_tif_and_mj2_is_missing, ...
                   @mj2_from_tif_single_for_find_and_batch, ...
                   'do_submit', do_submit, ...
                   'do_try', do_try, ...
                   'submit_host_name', submit_host_name, ...
                   'maximum_running_slot_count', maximum_running_slot_count, ...
                   'slots_per_job', slots_per_job, ...
                   'bsub_options', bsub_options, ...
                   'predicate_extra_args', {tif_folder_name, mj2_folder_name}, ...
                   'batch_function_extra_args', {tif_folder_name, mj2_folder_name, compression_ratio}) ;
end