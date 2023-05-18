function freeze_mouselight_folder(...
        mj2_output_folder_path, ...
        tif_input_folder_path, ...
        compression_ratio, ...
        do_run_on_cluster, ...
        do_try, ...
        maximum_running_slot_count, ...
        submit_host_name)

    %
    % Compress full-rez octree tiffs to .mj2, copy all non-tif files over
    %
    
    % Compress all the full-rez octree tiles to .mj2
    batch_convert_all_tif_files_to_mj2(mj2_output_folder_path, ...
                                       tif_input_folder_path, ...
                                       compression_ratio, ...
                                       do_run_on_cluster, ...
                                       do_try, ...
                                       maximum_running_slot_count, ...
                                       submit_host_name) ;

    % Copy all the non-tiff files over to the tif side
    copy_non_tif_files_to_mj2_side(mj2_output_folder_path, ...
                                   tif_input_folder_path) ;

    %
    % Verify that all that went well
    %

    % Use the cluster to check that all compressed .tif's match their .mj2 well
    % enough, and write a 'certificate' file to represent that.
    fprintf('Doing batch preverification of .tif files...\n') ;
    batch_preverify_tif_files_after_mj2_from_tif(mj2_output_folder_path, ...
                                                 tif_input_folder_path, ...
                                                 do_run_on_cluster, ...
                                                 do_try, ...
                                                 submit_host_name, ...
                                                 maximum_running_slot_count)
    fprintf('Done with batch preverification of .tif files.\n') ;
    
    % Wait a bit to make sure the filesystem changes have propagated
    if do_run_on_cluster ,
        pause(20) ;
    end

    % Check that all the cetificate files that should be there, are there
    fprintf('Doing verification of .tif files...\n') ;
    verify_tif_files_after_mj2_from_tif(tif_input_folder_path, mj2_output_folder_path) ;
    fprintf('Done with verification of .tif files.\n') ;
    
    % Verify that all the non-tif files exist on the mj2 side
    fprintf('Doing verification of non-.tif files...\n') ;
    verify_non_tif_files_after_mj2_from_tif(mj2_output_folder_path, tif_input_folder_path) ;
    fprintf('Done with verification of non-.tif files.\n') ;
    
    %
    % Do a final comparison of .tif files and .mj2 files, just for the heck of it
    %

    % Count the tifs
    final_tif_count = ...
        find_and_count(tif_input_folder_path, @does_file_name_end_in_dot_tif) ;
    fprintf('Final .tif count in %s is: %d\n', tif_input_folder_path, final_tif_count) ;
    
    % Count the mj2s
    final_mj2_count = ...
        find_and_count(mj2_output_folder_path, @does_file_name_end_in_dot_mj2) ;
    fprintf('Final .mj2 count in %s is: %d\n', mj2_output_folder_path, final_mj2_count) ;
    
    % Final check
    if final_tif_count ~= final_mj2_count ,
      error('Final .mj2 count in target folder differs from final .tif count in source folder') ;
    end

    % Report final status if we get this far
    fprintf('Octree compression and verification succeeded!\n') ;
end
