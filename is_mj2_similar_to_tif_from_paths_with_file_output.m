function is_mj2_similar_to_tif_from_paths_with_file_output(mj2_output_entity_path, tif_input_entity_path)
    % Checks that the mj2 is similar to the .tif, and outputs a .check file in the
    % mj2 folder if the are similar.  If unable to verify, writes nothing.
    if exist(mj2_output_entity_path, 'file') ,
        try                        
            mj2_stack = read_16bit_grayscale_mj2(mj2_output_entity_path) ;
        catch err %#ok<NASGU>
            return
        end
        tif_stack = read_16bit_grayscale_tif(tif_input_entity_path) ;
        if is_mj2_similar_to_tif(mj2_stack, tif_stack) ,
            check_file_path = horzcat(mj2_output_entity_path, '.check') ;
            touch(check_file_path) ;
        end
    end
end
