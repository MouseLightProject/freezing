function verify_files_after_mj2_from_tif(mj2_output_folder_name, tif_input_folder_name)
    % Makes sure all the target files are present in the the destination, and have
    % the right size, or at least a plausible size in the case of .mj2's.
    is_all_well = true ;
    is_all_well = verify_files_after_mj2_from_tif_helper(mj2_output_folder_name, tif_input_folder_name, is_all_well) ;
    if is_all_well ,
        fprintf('Target folder %s matches source folder %s\n', mj2_output_folder_name, tif_input_folder_name) ;
    else
        error('Target folder %s had discrepancies', mj2_output_folder_name) ;
    end    
end    



function is_all_well = verify_files_after_mj2_from_tif_helper(mj2_output_folder_name, tif_input_folder_name, is_all_well)
    tif_input_entities = dir_without_dot_and_dot_dot(tif_input_folder_name) ;
    tif_input_entity_count = length(tif_input_entities) ;
    for i = 1 : tif_input_entity_count ,
        tif_input_entity = tif_input_entities(i) ;        
        tif_input_entity_name = tif_input_entity.name ;
        tif_input_entity_path = fullfile(tif_input_folder_name, tif_input_entity_name) ;
        if tif_input_entity.isdir ,
            % if a folder, recurse
            mj2_output_entity_path = fullfile(mj2_output_folder_name, tif_input_entity_name) ;
            is_all_well = verify_files_after_mj2_from_tif_helper(mj2_output_entity_path, tif_input_entity_path, is_all_well) ;
        else
            [~,~,ext] = fileparts(tif_input_entity_path) ;
            if isequal(ext, '.tif') ,
                % If source is a tif, read in both files, and make sure they are close to one
                % another.
                mj2_output_entity_path = fullfile(mj2_output_folder_name, replace_extension(tif_input_entity_name, '.mj2')) ;
                if exist(mj2_output_entity_path, 'file') ,
                    try                        
                        mj2_stack = read_16bit_grayscale_mj2(mj2_output_entity_path) ;
                    catch err
                        is_all_well = false ;
                        fprintf('Unable to read target file %s: %s\n', mj2_output_entity_path, err.message) ;
                    end
                    tif_stack = read_16bit_grayscale_tif(tif_input_entity_path) ;
                    if is_mj2_similar_to_tif(mj2_stack, tif_stack) ,
                        % do nothing, all is well
                    else
                        is_all_well = false ;
                        fprintf('Target file %s is considerably different from source file%s\n', ...
                                mj2_output_entity_path, ...
                                tif_input_entity_path) ;
                    end
                else
                    is_all_well = false ;
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
                        % do nothing, this is fine and good
                    else
                        is_all_well = false ;
                        fprintf('Target file %s differs from source file %s\n', ...
                                mj2_output_entity_path, ...
                                tif_input_entity_path) ;
                    end
                else
                    is_all_well = false ;
                    fprintf('Target file %s is missing\n', mj2_output_entity_path) ;                    
                end
            end
        end
    end    
end
