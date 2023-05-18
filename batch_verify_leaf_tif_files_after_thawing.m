function batch_verify_leaf_tif_files_after_thawing(output_folder_name, ...
                                                   input_folder_name, ...
                                                   do_submit, ...
                                                   do_try, ...
                                                   submit_host_name, ...
                                                   maximum_running_slot_count)
    % Makes sure all the leaf image files are present in the the destination, and
    % are similar to their source files.
    
    slots_per_job = 4 ;
    bsub_options = '-P mouselight -W 59 -J verify-thawed-leaves' ;
    find_and_batch(input_folder_name, ...
                   @is_leaf_mj2_and_lacks_cert_for_output, ...
                   @verify_single_tif_file_after_thawing, ...
                   'do_submit', do_submit, ...
                   'do_try', do_try, ...
                   'submit_host_name', submit_host_name, ...
                   'maximum_running_slot_count', maximum_running_slot_count, ...
                   'slots_per_job', slots_per_job, ...
                   'bsub_options', bsub_options, ...
                   'predicate_extra_args', {input_folder_name, output_folder_name}, ...
                   'batch_function_extra_args', {input_folder_name, output_folder_name}) ;
end
