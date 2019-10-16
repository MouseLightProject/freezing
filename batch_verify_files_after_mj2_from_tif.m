function batch_verify_files_after_mj2_from_tif(mj2_output_folder_name, tif_input_folder_name)
    % Makes sure all the target files are present in the the destination, and have
    % the right size, or at least a plausible size in the case of .mj2's.
    tic_id = tic() ;
    verified_ok_mj2_count = 0 ;
    problem_serial_mj2_paths = cell(1,0) ;
    job_array = [] ;
    batch_mj2_paths = cell(1,0) ;
    [verified_ok_mj2_count, problem_serial_mj2_paths, job_array, batch_mj2_paths] = ...
        batch_verify_files_after_mj2_from_tif_helper(mj2_output_folder_name, ...
                                                     tif_input_folder_name, ...
                                                     verified_ok_mj2_count, ...
                                                     problem_serial_mj2_paths, ...
                                                     job_array, ...
                                                     batch_mj2_paths) ;
    cleaner = onCleanup(@()(delete_job_array(job_array))) ;
    wait_on_job_array(job_array) ;
    rs = results_from_job_array(job_array) ;
    is_batch_mj2_similar = cellfun(@(c)(fif(isempty(c), false, c{1})), rs) ;
    %batch_mj2_paths = cellfun(@(c)(c{2}), rs, 'UniformOutput', false) ;
    bad_batch_mj2_paths = batch_mj2_paths(~is_batch_mj2_similar) ;
    all_bad_mj2_paths = horzcat(problem_serial_mj2_paths, bad_batch_mj2_paths) ;
    if isempty(all_bad_mj2_paths) ,
        fprintf('Target folder %s matches source folder %s\n', mj2_output_folder_name, tif_input_folder_name) ;
        fprintf('%d files checked serially, %d in parallel\n', verified_ok_mj2_count, length(is_batch_mj2_similar)) ;
        fprintf('Hooray!\n') ;
    else        
        for i = 1 : length(all_bad_mj2_paths) ,
            fprintf('Target file %s differed meaningfully from source\n', all_bad_mj2_paths{i}) ;
        end
        fprintf('Boo!\n') ;
    end    
    elapsed_time = toc(tic_id) ;
    fprintf('Elapsed time for verfication was %g seconds.\n', elapsed_time) ;
end



function [verified_ok_mj2_count, problem_serial_mj2_paths, job_array, batch_mj2_paths] = ...
        batch_verify_files_after_mj2_from_tif_helper(mj2_output_folder_name, ...
                                                     tif_input_folder_name, ...
                                                     verified_ok_mj2_count, ...
                                                     problem_serial_mj2_paths, ...
                                                     job_array, ...
                                                     batch_mj2_paths)
    tif_input_entities = dir_without_dot_and_dot_dot(tif_input_folder_name) ;
    tif_input_entity_count = length(tif_input_entities) ;
    for i = 1 : tif_input_entity_count ,
        tif_input_entity = tif_input_entities(i) ;        
        tif_input_entity_name = tif_input_entity.name ;
        tif_input_entity_path = fullfile(tif_input_folder_name, tif_input_entity_name) ;
        if tif_input_entity.isdir ,
            % if a folder, recurse
            mj2_output_entity_path = fullfile(mj2_output_folder_name, tif_input_entity_name) ;
            [verified_ok_mj2_count, problem_serial_mj2_paths, job_array, batch_mj2_paths] = ...
                batch_verify_files_after_mj2_from_tif_helper(mj2_output_entity_path, ...
                                                             tif_input_entity_path, ...
                                                             verified_ok_mj2_count, ...
                                                             problem_serial_mj2_paths, ...
                                                             job_array, ...
                                                             batch_mj2_paths) ;
        else
            tif_input_entity_path = fullfile(tif_input_folder_name, tif_input_entity_name) ;    
            [~,~,ext] = fileparts(tif_input_entity_name) ;
            if isequal(ext, '.tif') ,
                % If source is a tif, read in both files, and make sure they are close to one
                % another.
                mj2_output_entity_path = fullfile(mj2_output_folder_name, replace_extension(tif_input_entity_name, '.mj2')) ;                
                j = batch(@is_mj2_similar_to_tif_from_paths, 1, {mj2_output_entity_path, tif_input_entity_path}) ;
                job_array = horzcat(job_array, j) ;  %#ok<AGROW>
                batch_mj2_paths = horzcat(batch_mj2_paths, mj2_output_entity_path) ;  %#ok<AGROW>
            else
                % Source file is not a tif, so destination file should be exactly the same
                % as source.
                mj2_output_entity_path = fullfile(mj2_output_folder_name, tif_input_entity_name) ;  % input not really a tif, output not really a .mj2
                if exist(mj2_output_entity_path, 'file') ,                    
                    tif_file_contents = read_file_into_uint8_array(tif_input_entity_path) ;
                    mj2_file_contents = read_file_into_uint8_array(mj2_output_entity_path) ;
                    if isequal(tif_file_contents, mj2_file_contents) ,
                        verified_ok_mj2_count = verified_ok_mj2_count + 1 ;
                    else
                        problem_serial_mj2_paths = horzcat(problem_serial_mj2_paths, mj2_output_entity_path) ; %#ok<AGROW>
                    end
                else
                    problem_serial_mj2_paths = horzcat(problem_serial_mj2_paths, mj2_output_entity_path) ; %#ok<AGROW>
                end
            end
        end
    end    
end



   