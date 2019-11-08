function result = does_need_preverification_after_freezing(tif_file_path, tif_root_path, mj2_root_path)
    [~,file_name] = fileparts2(tif_file_path) ;
    result = does_file_name_end_in_dot_tif(file_name) && ...
             ~does_is_similar_to_tif_check_file_exist(tif_file_path, tif_root_path, mj2_root_path) ;
end
