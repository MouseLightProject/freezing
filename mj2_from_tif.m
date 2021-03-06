function mj2_from_tif(mj2_root_folder_path, tif_root_folder_path, compression_ratio, do_run_on_cluster)
    % Converts each .mj2 file in input_folder_name to a multi-image .tif in
    % output_folder_name.  Will overwrite pre-existing files in
    % output_folder_name, if present.
    
    if ~exist('compression_ratio', 'var') || isempty(compression_ratio) ,
        compression_ratio = 10 ;
    end
    if ~exist('do_run_on_cluster', 'var') || isempty(do_run_on_cluster) ,
        do_run_on_cluster = false ;
    end

    % Call the helper
    fprintf('Compressing .tifs to .mj2s...\n') ;
    job_ids = mj2_from_tif_helper(mj2_root_folder_path, tif_root_folder_path, compression_ratio, do_run_on_cluster, zeros(1,0)) ;
    
    % Wait for the jobs to finish
    fprintf('Waiting for %d mj2_from_tif() bjobs to finish...\n', length(job_ids)) ;
    bwait(job_ids) ;
    fprintf('mj2_from_tif() bjobs are done.\n') ;
    
%     bsub_options = '-n1 -P mouselight -W 59 -J freeze' ;
%     find_and_batch(tif_root_folder_path, ...
%                    @(varargin)(true), ...
%                    @mj2_from_tif_single, ...
%                    do_run_on_cluster, ...
%                    bsub_options, ...
%                    tif_root_folder_path, ...
%                    mj2_root_folder_path, ...
%                    compression_ratio) ;
    
    fprintf('Done compressing .tifs to .mj2s.\n') ;    
end



function job_ids = mj2_from_tif_helper(mj2_folder_path, tif_folder_path, compression_ratio, do_run_on_cluster, initial_job_ids)
    job_ids = initial_job_ids ;
    if ~exist(mj2_folder_path, 'dir') ,
        mkdir(mj2_folder_path) ;
    end
    tif_side_file_names = simple_dir(tif_folder_path) ;
    tif_side_file_name_count = length(tif_side_file_names) ;
    for i = 1 : tif_side_file_name_count ,
        tif_side_file_name = tif_side_file_names{i} ;        
        tif_side_file_path = fullfile(tif_folder_path, tif_side_file_name) ;
        if exist(tif_side_file_path, 'dir') ,
            % if a folder, recurse
            tif_side_subfolder_path = tif_side_file_path ;
            tif_side_subfolder_name = tif_side_file_name ;
            mj2_side_subfolder_path = fullfile(mj2_folder_path, tif_side_subfolder_name) ;
            job_ids = mj2_from_tif_helper(mj2_side_subfolder_path, tif_side_subfolder_path, compression_ratio, do_run_on_cluster, job_ids) ;
        else
            % if a normal file, convert to .mj2 if it's a .tif, or just
            % copy otherwise
            if does_file_name_end_in_dot_tif(tif_side_file_path) ,
                tif_file_path = tif_side_file_path ;
                tif_file_name = tif_side_file_name ;
                mj2_file_name = replace_extension(tif_file_name, '.mj2') ;
                mj2_file_path = fullfile(mj2_folder_path, mj2_file_name) ;
                if ~exist(mj2_file_path, 'file') ,
                    bsub_options = '-n1 -P mouselight -W 59 -J freeze' ;
                    job_id = bsub(do_run_on_cluster, ...
                                  bsub_options, ...
                                  @mj2_from_tif_single, ...
                                      mj2_file_path, ...
                                      tif_file_path, ...
                                      compression_ratio) ;
                    job_ids = horzcat(job_ids, job_id) ;  %#ok<AGROW>
                end
            else
                mj2_side_file_path = fullfile(mj2_folder_path, tif_side_file_name) ;  % input not really a tif, output not really a .mj2
                if ~exist(mj2_side_file_path, 'file') ,
                    copyfile(tif_side_file_path, mj2_side_file_path) ;                    
                end
            end
        end
    end    
end
