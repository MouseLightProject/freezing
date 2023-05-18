function result = verify_single_non_tif_file_after_mj2_from_tif(tif_side_file_path, tif_root_folder_path, mj2_root_folder_path)
    % Compare the md5sum of 
    relative_file_path = relpath(tif_side_file_path, tif_root_folder_path) ;
    mj2_side_file_path = fullfile(mj2_root_folder_path, relative_file_path) ;
    if exist(mj2_side_file_path, 'file') ,                    
        result = are_files_same_size_and_md5sum(tif_side_file_path, mj2_side_file_path) ;
    else
        result = false ;
    end
end
