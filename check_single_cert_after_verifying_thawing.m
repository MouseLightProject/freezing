function result = check_single_cert_after_verifying_thawing(input_file_path, input_root_folder_path, output_root_folder_path)
    input_relative_file_path = relpath(input_file_path, input_root_folder_path) ;
    output_relative_file_path = replace_extension(input_relative_file_path, '.tif') ;
    output_file_path = fullfile(output_root_folder_path, output_relative_file_path) ;
    cert_file_path = horzcat(output_file_path, '.is-similar-to-mj2') ;    
    result = logical( exist(cert_file_path, 'file') ) ;
end
