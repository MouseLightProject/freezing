function result = verify_frozen_files(mj2_root_folder_path, tif_root_folder_path, do_submit)
    fprintf('Doing batch preverification of large files...\n') ;
    batch_preverify_big_files_after_mj2_from_tif(mj2_root_folder_path, tif_root_folder_path, do_submit)
    fprintf('Done with batch preverification of large files.\n') ;
    
    fprintf('Doing verification of large files...\n') ;
    is_all_well_with_big_files = verify_big_files_after_mj2_from_tif(tif_root_folder_path, mj2_root_folder_path) ;
    fprintf('Done with verification of large files.\n') ;
    
    if is_all_well_with_big_files, 
        fprintf('Doing verification of small files...\n') ;        
        result = verify_small_files_after_mj2_from_tif(mj2_root_folder_path, tif_root_folder_path) ;
        fprintf('Done with verification of small files.\n') ;        
    else
        result = false ;
    end
end
