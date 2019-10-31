function result = verify_single_big_file_after_mj2_from_tif(tif_file_path)
    check_file_path = horzcat(tif_file_path, '.similar-mj2-exists') ;    
    result = logical( exist(check_file_path, 'file') ) ;
end
