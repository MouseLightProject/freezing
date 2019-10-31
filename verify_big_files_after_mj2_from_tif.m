function is_all_well = verify_big_files_after_mj2_from_tif(tif_root_folder_path)
    % Makes sure there's a .similar-mj2-exists for each .tif file in
    % tif_root_folder_path.    
    is_all_well = find_and_verify(tif_root_folder_path, '^\d\d\d\d\d-ngc.\d.tif$', @verify_single_big_file_after_mj2_from_tif) ;
end
   