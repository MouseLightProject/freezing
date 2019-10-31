function result = verify_frozen_files(mj2_root_folder_path, tif_root_folder_path)
    batch_preverify_big_files_after_mj2_from_tif(mj2_root_folder_path, tif_root_folder_path)
    is_all_well_with_big_files = verify_big_files_after_mj2_from_tif(tif_root_folder_path) ;
    result = is_all_well_with_big_files && verify_small_files_after_mj2_from_tif(mj2_root_folder_path, tif_root_folder_path) ;
end
