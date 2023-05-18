function result = does_need_preverification_after_freezing(tif_file_path, tif_root_path, mj2_root_path)
    result = is_a_tif_and_target_present(tif_file_path, tif_root_path, mj2_root_path) && ...
             ~does_is_similar_to_tif_check_file_exist(tif_file_path, tif_root_path, mj2_root_path) ;
end
