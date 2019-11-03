function verify_file_sizes_after_mj2_from_tif(mj2_output_folder_name, tif_input_folder_name, compression_ratio)
    % Makes sure all the target files are present in the the destination, and have
    % the right size, or at least a plausible size in the case of .mj2's.
    is_all_well = true ;
    is_all_well = verify_file_sizes_after_mj2_from_tif_helper(mj2_output_folder_name, tif_input_folder_name, compression_ratio, is_all_well) ;
    if is_all_well ,
        fprintf('Target folder %s matches source folder %s\n', mj2_output_folder_name, tif_input_folder_name) ;
    else
        error('Target folder %s had discrepancies', mj2_output_folder_name) ;
    end    
end    



function is_all_well = verify_file_sizes_after_mj2_from_tif_helper(mj2_output_folder_name, tif_input_folder_name, compression_ratio, is_all_well)
    tif_input_entities = dir_without_dot_and_dot_dot(tif_input_folder_name) ;
    tif_input_entity_count = length(tif_input_entities) ;
    for i = 1 : tif_input_entity_count ,
        tif_input_entity = tif_input_entities(i) ;        
        tif_input_entity_name = tif_input_entity.name ;
        tif_input_entity_path = fullfile(tif_input_folder_name, tif_input_entity_name) ;
        if tif_input_entity.isdir ,
            % if a folder, recurse
            mj2_output_entity_path = fullfile(mj2_output_folder_name, tif_input_entity_name) ;
            is_all_well = verify_file_sizes_after_mj2_from_tif_helper(mj2_output_entity_path, tif_input_entity_path, compression_ratio, is_all_well) ;
        else
            % If a normal file, check the file size
            [~,~,ext] = fileparts(tif_input_entity_path) ;
            if isequal(ext, '.tif') ,
                mj2_output_entity_path = fullfile(mj2_output_folder_name, replace_extension(tif_input_entity_name, '.mj2')) ;
                if exist(mj2_output_entity_path, 'file') ,
                    tif_file_size = tif_input_entity.bytes ;
                    mj2_file_size = get_file_size(mj2_output_entity_path) ;
                    desired_mj2_file_size = round(tif_file_size/compression_ratio) ;
                    if mj2_file_size == desired_mj2_file_size ,
                        % do nothing, this is fine and good, and should handle zero-length files
                    elseif round(0.8*desired_mj2_file_size)<=mj2_file_size && mj2_file_size<=round(1.2*desired_mj2_file_size)
                        % do nothing this is also fine
                    else
                        is_all_well = false ;
                        fprintf('Target file %s is %d bytes, which seems suspect given the desired size was %d bytes\n', ...
                                mj2_output_entity_path, ...
                                mj2_file_size, ...
                                desired_mj2_file_size) ;
                    end
                else
                    is_all_well = false ;
                    fprintf('Target file %s is missing\n', mj2_output_entity_path) ;
                end
            else
                % Source file is not a tif, so destination file should be exactly the same size
                % as source.
                mj2_output_entity_path = fullfile(mj2_output_folder_name, tif_input_entity_name) ;  % input not really a tif, output not really a .mj2
                if exist(mj2_output_entity_path, 'file') ,
                    tif_file_size = tif_input_entity.bytes ;
                    mj2_file_size = get_file_size(mj2_output_entity_path) ;
                    if mj2_file_size == tif_file_size ,
                        % do nothing, this is fine and good
                    else
                        is_all_well = false ;
                        fprintf('Target file %s is %d bytes, but it should be %d bytes\n', ...
                                mj2_output_entity_path, ...
                                mj2_file_size, ...
                                tif_file_size) ;
                    end
                else
                    is_all_well = false ;
                    fprintf('Target file %s is missing\n', mj2_output_entity_path) ;                    
                end
            end
        end
    end    
end
