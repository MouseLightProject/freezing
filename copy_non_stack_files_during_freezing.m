function copy_non_stack_files_during_freezing(output_folder_name, ...
                                              input_folder_name)
    % Find all non-.tif files, copy them over to the mj2 side
    
    do_submit = false ;
    do_try = true ;
    maximum_running_slot_count = 400 ;  % doesn't matter
    slots_per_job = 1 ;  % doesn't matter
    bsub_options = '-P mouselight -W 59 -J copy' ;  % doesn't matter
    submit_host_name = '' ;

    function result = predicate_function(tif_side_file_path)
        result = is_a_non_tif_and_target_missing(tif_side_file_path, input_folder_name, output_folder_name) ;
    end

    function batch_function(tif_side_file_path)
        copy_file_for_find_and_batch(tif_side_file_path, input_folder_name, output_folder_name) ;
    end
    
    find_and_batch(input_folder_name, ...
                   @predicate_function, ...
                   @batch_function, ...
                   'do_submit', do_submit, ...
                   'do_try', do_try, ...
                   'submit_host_name', submit_host_name, ...
                   'maximum_running_slot_count', maximum_running_slot_count, ...
                   'slots_per_job', slots_per_job, ...
                   'bsub_options', bsub_options, ...
                   'folder_predicate_function', @is_not_the_ktx_folder) ;
end
