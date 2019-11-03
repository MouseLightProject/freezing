function result = verify_single_big_file_after_mj2_from_tif(tif_file_path, tif_root_folder_path, mj2_root_folder_path)
    relative_file_path_of_tif = relpath(tif_file_path, tif_root_folder_path) ;
    relative_file_path_of_mj2 = replace_extension(relative_file_path_of_tif, '.mj2') ;
    mj2_file_path = fullfile(mj2_root_folder_path, relative_file_path_of_mj2) ;
    check_file_path = horzcat(mj2_file_path, '.is-similar-to-tif') ;    
    result = logical( exist(check_file_path, 'file') ) ;
end
