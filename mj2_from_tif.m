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
            mj2_from_tif(mj2_output_entity_path, tif_input_entity_path, compression_ratio, do_verify, do_run_on_cluster) ;
        else
            % if a normal file, convert to .mj2 if it's a .tif, or just
            % copy otherwise
            [~,~,ext] = fileparts(tif_input_entity_path) ;
            if isequal(ext, '.tif') ,
                mj2_output_entity_path = fullfile(mj2_output_folder_name, replace_extension(tif_input_entity_name, '.mj2')) ;
                if ~exist(mj2_output_entity_path, 'file') ,
                    fprintf('Converting %s...\n', tif_input_entity_path);
                    tic_id = tic() ;
                    scratch_folder_path = get_scratch_folder_path() ;
                    temporary_tif_input_file_path = [tempname(scratch_folder_path) '.tif'] ;
                    temporary_mj2_output_file_path = [tempname(scratch_folder_path) '.mj2'] ;  % risky, but VideoWriter is dumb and always adds this anyway                   
                    if do_run_on_cluster ,                        
                        command_line = ...
                            sprintf(['matlab -nojvm ' ...
                                     '-batch ' ...
                                         '"mj2_output_entity_path = ''%s'';  tif_input_entity_path = ''%s''; do_verify = %s; ' ...
                                         'compression_ratio = %s; ' ...
                                         'temporary_tif_input_file_path = ''%s'';  temporary_mj2_output_file_path = ''%s''; ' ...                                     
                                         'copyfile(tif_input_entity_path, temporary_tif_input_file_path); ' ...
                                         'mj2_from_tif_single(temporary_mj2_output_file_path, temporary_tif_input_file_path, compression_ratio, do_verify); ' ...
                                         'copyfile(temporary_mj2_output_file_path, mj2_output_entity_path); ' ...
                                         'delete(temporary_tif_input_file_path); ' ...
                                         'delete(temporary_mj2_output_file_path);"'], ...
                                    mj2_output_entity_path, ...
                                    tif_input_entity_path, ...
                                    fif(do_verify, 'true', 'false'),  ...                                    
                                    num2str(compression_ratio, '%.18g') , ...
                                    temporary_tif_input_file_path, ...
                                    temporary_mj2_output_file_path) ;
                        fprintf('Command line: %s\n', command_line) ;
                        if do_verify , 
                            core_count_to_request = 4 ;
                        else
                            core_count_to_request = 1 ;
                        end
                        bsub_command_line = ...
                            sprintf('bsub -n%d -P mouselight -oo /dev/null -eo /dev/null -W 59 -J freeze %s', core_count_to_request, command_line) ;
                        %bsub_command_line = sprintf('bsub -n%d -P mouselight %s', core_count_to_request, command_line) ;
                        fprintf('bsub Command line: %s\n', bsub_command_line) ;
                        system(bsub_command_line) ;
                    else
                        mj2_from_tif_single(mj2_output_entity_path, tif_input_entity_path, compression_ratio, do_verify) ;
                    end
                    duration  = toc(tic_id) ;
                    fprintf('Took %g seconds\n', duration) ;
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
