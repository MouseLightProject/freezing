function thaw_mouselight_folder(...
        output_folder_path, ...
        input_folder_path, ...
        do_run_on_cluster, ...
        do_try, ...
        maximum_running_slot_count, ...
        submit_host_name)

    %
    % Phase 1: Decompress all full-rez octree .mj2's to .tif
    %
    
    % Compress all the full-rez octree tiles to .mj2
    batch_convert_all_mj2_files_to_tif(...
        output_folder_path, ...
        input_folder_path, ...
        do_run_on_cluster, ...
        do_try, ...
        maximum_running_slot_count, ...
        submit_host_name) ;

    % Use the cluster to check that all decompressed .tif's match their .mj2 well
    % enough, and write a 'certificate' file to represent that.
    fprintf('Doing batch verification of leaf .tif files...\n') ;
    batch_verify_leaf_tif_files_after_thawing(...
        output_folder_path, ...
        input_folder_path, ...
        do_run_on_cluster, ...
        do_try, ...
        submit_host_name, ...
        maximum_running_slot_count)
    fprintf('Done with batch verification of leaf .tif files.\n') ;
    
    % Wait a bit to make sure the filesystem changes have propagated
    if do_run_on_cluster ,
        pause(20) ;
    end

    % Check that all the cetificate files that should be there, are there
    fprintf('Checking leaf verification certificates...\n') ;
    check_certs_after_verifying_thawing(input_folder_path, output_folder_path) ;
    fprintf('Done checking leaf verification certificates.\n') ;


    %
    % Phase 2: Copy all the non-mj2 files over
    %

    % Copy all the non-mj2 files over to the tif side
    copy_non_mj2_files_to_tif_side(output_folder_path, ...
                                   input_folder_path) ;
    
    % Verify that all the non-tif files exist on the mj2 side
    fprintf('Doing verification of non-.tif files...\n') ;
    verify_non_tif_files_after_thawing(output_folder_path, input_folder_path) ;
    fprintf('Done with verification of non-.tif files.\n') ;

    
    %
    % Do a final comparison of leaf .tif files and .mj2 files, just for the heck of it
    %

    % Count the mj2s
    final_mj2_count = ...
        find_and_count(input_folder_path, @does_file_name_end_in_dot_mj2) ;
    fprintf('Final .mj2 count in %s is: %d\n', input_folder_path, final_mj2_count) ;
    
    % Count the tifs
    final_tif_count = ...
        find_and_count(output_folder_path, @does_file_name_end_in_dot_tif) ;
    fprintf('Final .tif count in %s is: %d\n', output_folder_path, final_tif_count) ;
    
    % Final check
    if final_tif_count ~= final_mj2_count ,
      error('Final .tif count in target folder differs from final .mj2 count in source folder') ;
    end
    
    % Report final status if we get this far
    fprintf('Octree decompression and verification succeeded!\n') ;
end
