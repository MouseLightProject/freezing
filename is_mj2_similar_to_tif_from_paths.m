function are_files_the_same = is_mj2_similar_to_tif_from_paths(mj2_file_path, tif_file_path)
    if exist(mj2_file_path, 'file') ,
        try                        
            mj2_stack = read_16bit_grayscale_mj2(mj2_file_path) ;
        catch err
            are_files_the_same = false ;
            fprintf('Unable to read target file %s: %s\n', mj2_file_path, err.message) ;
            return
        end
        tif_stack = read_16bit_grayscale_tif(tif_file_path) ;
        if is_mj2_similar_to_tif(mj2_stack, tif_stack) ,
            are_files_the_same = true ;
        else
            are_files_the_same = false ;
            fprintf('Target file %s is considerably different from source file%s\n', ...
                    mj2_file_path, ...
                    tif_file_path) ;
        end
    else
        are_files_the_same = false ;
        fprintf('Target file %s is missing\n', mj2_file_path) ;
    end
end
