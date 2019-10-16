function [are_files_the_same, mj2_output_entity_path] = verify_single_file_after_mj2_from_tif(mj2_output_folder_name, tif_input_folder_name, tif_input_entity_name)    
    tif_input_entity_path = fullfile(tif_input_folder_name, tif_input_entity_name) ;    
    [~,~,ext] = fileparts(tif_input_entity_name) ;
    if isequal(ext, '.tif') ,
        % If source is a tif, read in both files, and make sure they are close to one
        % another.
        mj2_output_entity_path = fullfile(mj2_output_folder_name, replace_extension(tif_input_entity_name, '.mj2')) ;
        if exist(mj2_output_entity_path, 'file') ,
            try                        
                mj2_stack = read_16bit_grayscale_mj2(mj2_output_entity_path) ;
            catch err
                are_files_the_same = false ;
                fprintf('Unable to read target file %s: %s\n', mj2_output_entity_path, err.message) ;
                return
            end
            tif_stack = read_16bit_grayscale_tif(tif_input_entity_path) ;
            if is_mj2_similar_to_tif(mj2_stack, tif_stack) ,
                are_files_the_same = true ;
            else
                are_files_the_same = false ;
                fprintf('Target file %s is considerably different from source file%s\n', ...
                        mj2_output_entity_path, ...
                        tif_input_entity_path) ;
            end
        else
            are_files_the_same = false ;
            fprintf('Target file %s is missing\n', mj2_output_entity_path) ;
        end
    else
        % Source file is not a tif, so destination file should be exactly the same
        % as source.
        mj2_output_entity_path = fullfile(mj2_output_folder_name, tif_input_entity_name) ;  % input not really a tif, output not really a .mj2
        if exist(mj2_output_entity_path, 'file') ,                    
            tif_file_contents = read_file_into_uint8_array(tif_input_entity_path) ;
            mj2_file_contents = read_file_into_uint8_array(mj2_output_entity_path) ;
            if isequal(tif_file_contents, mj2_file_contents) ,
                are_files_the_same = true ;
            else
                are_files_the_same = false ;
                fprintf('Target file %s differs from source file %s\n', ...
                        mj2_output_entity_path, ...
                        tif_input_entity_path) ;
            end
        else
            are_files_the_same = false ;
            fprintf('Target file %s is missing\n', mj2_output_entity_path) ;                    
        end
    end
end    
