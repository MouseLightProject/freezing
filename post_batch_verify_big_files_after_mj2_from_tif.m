function post_batch_verify_mj2_files_after_mj2_from_tif(mj2_output_folder_name, tif_input_folder_name)
    % Makes sure all the target .mj2 files are present in the the destination, and
    % have the corresponding .check file
    tic_id = tic() ;
    verified_ok_mj2_count = 0 ;
    problem_mj2_paths = cell(1,0) ;
    [verified_ok_mj2_count, problem_mj2_paths] = ...
        post_batch_verify_mj2_files_after_mj2_from_tif_helper(mj2_output_folder_name, ...
                                                          tif_input_folder_name, ...
                                                          verified_ok_mj2_count, ...
                                                          problem_mj2_paths) ;
    if isempty(problem_mj2_paths) ,
        fprintf('Target folder %s .mj2 files match source folder %s, and each has a .check file\n', mj2_output_folder_name, tif_input_folder_name) ;
        fprintf('%d files checked\n', verified_ok_mj2_count) ;
        fprintf('Hooray!\n') ;
    else        
        for i = 1 : length(problem_mj2_paths) ,
            fprintf('Target file %s lacks a check file\n', problem_mj2_paths{i}) ;
        end
        fprintf('Boo!\n') ;
    end    
    elapsed_time = toc(tic_id) ;
    fprintf('Elapsed time for post-verfication was %g seconds.\n', elapsed_time) ;
end



function [verified_ok_mj2_count, problem_mj2_paths] = ...
        post_batch_verify_mj2_files_after_mj2_from_tif_helper(mj2_output_folder_name, ...
                                                          tif_input_folder_name, ...
                                                          verified_ok_mj2_count, ...
                                                          problem_mj2_paths)
                                                 
    tif_input_entities = dir_without_dot_and_dot_dot(tif_input_folder_name) ;
    tif_input_entity_count = length(tif_input_entities) ;
    for i = 1 : tif_input_entity_count ,
        tif_input_entity = tif_input_entities(i) ;        
        tif_input_entity_name = tif_input_entity.name ;
        tif_input_entity_path = fullfile(tif_input_folder_name, tif_input_entity_name) ;
        if tif_input_entity.isdir ,
            % if a folder, recurse
            mj2_output_entity_path = fullfile(mj2_output_folder_name, tif_input_entity_name) ;
            [verified_ok_mj2_count, problem_mj2_paths] = ...
                post_batch_verify_mj2_files_after_mj2_from_tif_helper(mj2_output_entity_path, ...
                                                                  tif_input_entity_path, ...
                                                                  verified_ok_mj2_count, ...
                                                                  problem_mj2_paths) ;
        else
            %tif_input_entity_path = fullfile(tif_input_folder_name, tif_input_entity_name) ;    
            [~,~,ext] = fileparts(tif_input_entity_name) ;
            if isequal(ext, '.tif') ,
                % If source is a tif, check for the corresponding .mj2 and .mj2.check files
                mj2_output_entity_path = fullfile(mj2_output_folder_name, replace_extension(tif_input_entity_name, '.mj2')) ;                
                check_file_path = horzcat(mj2_output_entity_path, '.check') ;
                if exist(mj2_output_entity_path, 'file') && exist(check_file_path, 'file') ,
                    verified_ok_mj2_count = verified_ok_mj2_count + 1 ;
                else
                    problem_mj2_paths = horzcat(problem_mj2_paths, {mj2_output_entity_path}) ;  %#ok<AGROW>
                end
            else
                % We don't check other files at this stage.
            end
        end
    end    
end



   