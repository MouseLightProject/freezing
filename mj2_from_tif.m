function mj2_from_tif(mj2_output_folder_name, tif_input_folder_name, compression_ratio, do_verify, do_run_on_cluster)
    % Converts each .mj2 file in input_folder_name to a multi-image .tif in
    % output_folder_name.  Will overwrite pre-existing files in
    % output_folder_name, if present.
    
    if ~exist('compression_ratio', 'var') || isempty(compression_ratio) ,
        compression_ratio = 10 ;
    end
    if ~exist('do_verify', 'var') || isempty(do_verify) ,
        do_verify = false ;
    end
    if ~exist('do_run_on_cluster', 'var') || isempty(do_run_on_cluster) ,
        do_run_on_cluster = false ;
    end

    % Call the helper
    fprintf('Compressing .tifs to .mj2s...\n') ;
    job_ids = mj2_from_tif_helper(mj2_output_folder_name, tif_input_folder_name, compression_ratio, do_verify, do_run_on_cluster, zeros(1,0)) ;
    
    % Wait for the jobs to finish
    fprintf('Waiting for mj2_from_tif() bjobs to finish...\n') ;
    bwait(job_ids) ;
    fprintf('mj2_from_tif() bjobs are done.\n') ;
    
    fprintf('Done compressing .tifs to .mj2s.\n') ;    
end



function job_ids = mj2_from_tif_helper(mj2_output_folder_name, tif_input_folder_name, compression_ratio, do_verify, do_run_on_cluster, initial_job_ids)
    job_ids = initial_job_ids ;
    if ~exist(mj2_output_folder_name, 'dir') ,
        mkdir(mj2_output_folder_name) ;
    end
    tif_input_entity_names = setdiff(simple_dir(tif_input_folder_name), {'.' '..'}) ;
    tif_input_entity_count = length(tif_input_entity_names) ;
    for i = 1 : tif_input_entity_count ,
        tif_input_entity_name = tif_input_entity_names{i} ;        
        tif_input_entity_path = fullfile(tif_input_folder_name, tif_input_entity_name) ;
        if exist(tif_input_entity_path, 'dir') ,
            % if a folder, recurse
            mj2_output_entity_path = fullfile(mj2_output_folder_name, tif_input_entity_name) ;
            job_ids = mj2_from_tif_helper(mj2_output_entity_path, tif_input_entity_path, compression_ratio, do_verify, do_run_on_cluster, job_ids) ;
        else
            % if a normal file, convert to .mj2 if it's a .tif, or just
            % copy otherwise
            [~,~,ext] = fileparts(tif_input_entity_path) ;
            if isequal(ext, '.tif') ,
                mj2_output_entity_path = fullfile(mj2_output_folder_name, replace_extension(tif_input_entity_name, '.mj2')) ;
                if ~exist(mj2_output_entity_path, 'file') ,
                    if do_verify , 
                        core_count_to_request = 4 ;
                    else
                        core_count_to_request = 1 ;
                    end
                    bsub_options = sprintf('-n%d -P mouselight -W 59 -J freeze', core_count_to_request) ;
                    job_id = bsub(do_run_on_cluster, ...
                                  bsub_options, ...
                                  @mj2_from_tif_single_with_temps, ...
                                      mj2_output_entity_path, ...
                                      tif_input_entity_path, ...
                                      compression_ratio, ...
                                      do_verify) ;
                    job_ids = horzcat(job_ids, job_id) ;  %#ok<AGROW>
                end
            else
                mj2_output_entity_path = fullfile(mj2_output_folder_name, tif_input_entity_name) ;  % input not really a tif, output not really a .mj2
                if ~exist(mj2_output_entity_path, 'file') ,
                    copyfile(tif_input_entity_path, mj2_output_entity_path) ;                    
                end
            end
        end
    end    
end
