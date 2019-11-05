function result = verify_single_non_tif_file_after_mj2_from_tif(tif_file_path, tif_root_folder_path, mj2_root_folder_path)
    % The two files must be identical
    relative_file_path = relpath(tif_file_path, tif_root_folder_path) ;
    mj2_file_path = fullfile(mj2_root_folder_path, relative_file_path) ;
    if exist(mj2_file_path, 'file') ,                    
        tif_file_contents = read_file_into_uint8_array(tif_file_path) ;
        mj2_file_contents = read_file_into_uint8_array(mj2_file_path) ;
        result = isequal(tif_file_contents, mj2_file_contents) ;
    else
        result = false ;
    end
end
