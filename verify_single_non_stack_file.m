function result = verify_single_non_stack_file(input_file_path, input_root_folder_path, output_root_folder_path)
    % Compare the md5sum of 
    relative_file_path = relpath(input_file_path, input_root_folder_path) ;
    output_file_path = fullfile(output_root_folder_path, relative_file_path) ;
    if exist(output_file_path, 'file') ,                    
        result = are_files_same_size_and_md5sum(input_file_path, output_file_path) ;
    else
        result = false ;
    end
end
