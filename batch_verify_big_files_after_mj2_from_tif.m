function batch_verify_big_files_after_mj2_from_tif(mj2_output_folder_name, tif_input_folder_name)
    % Makes sure all the big target files are present in the the destination, and
    % are similar to their source files.
    tic_id = tic() ;
    submitted_job_count = 0 ;
    submitted_job_count = ...
        batch_verify_big_files_after_mj2_from_tif_helper(mj2_output_folder_name, ...
                                                     tif_input_folder_name, ...
                                                     submitted_job_count) ;
    fprintf('Submitted %d verification jobs.\n', submitted_job_count) ;                                             
    elapsed_time = toc(tic_id) ;
    fprintf('Elapsed time for submission of verfication jobs was %g seconds.\n', elapsed_time) ;
end



function submitted_job_count = ...
        batch_verify_big_files_after_mj2_from_tif_helper(mj2_output_folder_name, ...
                                                     tif_input_folder_name, ...
                                                     submitted_job_count)
                                                 
    tif_input_entities = dir_without_dot_and_dot_dot(tif_input_folder_name) ;
    tif_input_entity_count = length(tif_input_entities) ;
    for i = 1 : tif_input_entity_count ,
        tif_input_entity = tif_input_entities(i) ;        
        tif_input_entity_name = tif_input_entity.name ;
        tif_input_entity_path = fullfile(tif_input_folder_name, tif_input_entity_name) ;
        if tif_input_entity.isdir ,
            % if a folder, recurse
            mj2_output_entity_path = fullfile(mj2_output_folder_name, tif_input_entity_name) ;
            submitted_job_count = ...
                batch_verify_big_files_after_mj2_from_tif_helper(mj2_output_entity_path, ...
                                                             tif_input_entity_path, ...
                                                             submitted_job_count) ;
        else
            tif_input_entity_path = fullfile(tif_input_folder_name, tif_input_entity_name) ;    
            [~,~,ext] = fileparts(tif_input_entity_name) ;
            if isequal(ext, '.tif') ,
                % If source is a tif, read in both files, and make sure they are close to one
                % another.
                mj2_output_entity_path = fullfile(mj2_output_folder_name, replace_extension(tif_input_entity_name, '.mj2')) ;                
                check_file_path = horzcat(mj2_output_entity_path, '.check') ;
                if ~exist(check_file_path, 'file') ,                    
                    command_line = ...
                        sprintf(['matlab -nojvm ' ...
                                 '-batch ' ...
                                     '"mj2_output_entity_path = ''%s'';  tif_input_entity_path = ''%s''; ' ...
                                     'is_mj2_similar_to_tif_from_paths_with_file_output(mj2_output_entity_path, tif_input_entity_path);"'], ...
                                mj2_output_entity_path, ...
                                tif_input_entity_path) ;
                    fprintf('Command line: %s\n', command_line) ;
                    core_count_to_request = 4 ;
                    bsub_command_line = ...
                        sprintf('bsub -n%d -P mouselight -oo /dev/null -eo /dev/null -W 59 -J verify %s', core_count_to_request, command_line) ;
                    %bsub_command_line = sprintf('bsub -n%d -P mouselight %s', core_count_to_request, command_line) ;
                    fprintf('bsub Command line: %s\n', bsub_command_line) ;
                    system(bsub_command_line) ;
                    submitted_job_count = submitted_job_count + 1 ;
                end
            end
        end
    end    
end



   