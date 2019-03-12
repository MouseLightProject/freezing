function mj2tif(input_folder_name, output_folder_name, do_verify, do_run_on_cluster)
    % Converts each .mj2 file in input_folder_name to a multi-image .tif in
    % output_folder_name.  Will overwrite pre-existing files in
    % output_folder_name, if present.
    
    if nargin<3 || isempty(do_verify) ,
        do_verify = false ;
    end
    if nargin<4 || isempty(do_run_on_cluster) ,
        do_run_on_cluster = false ;
    end
    
    if ~exist(output_folder_name, 'dir') ,
        mkdir(output_folder_name) ;
    end
    entity_names = setdiff(simple_dir(input_folder_name), {'.' '..'}) ;
    entity_count = length(entity_names) ;
    for i = 1 : entity_count ,
        entity_name = entity_names{i} ;        
        entity_path = fullfile(input_folder_name, entity_name) ;
        if exist(entity_path, 'dir') ,
            % if a folder, recurse
            output_entity_path = fullfile(output_folder_name, entity_name) ;
            mj2tif(entity_path, output_entity_path, do_verify, do_run_on_cluster) ;
        else
            % if a normal file, convert to .tif if it's a .mj2, or just
            % copy otherwise
            [~,~,ext] = fileparts(entity_path) ;
            if isequal(ext, '.mj2') ,
                output_entity_path = fullfile(output_folder_name, replace_extension(entity_name, '.tif')) ;
                if ~exist(output_entity_path, 'file') ,
                    fprintf('Converting %s...\n', entity_path);
                    tic_id = tic() ;
                    if do_run_on_cluster , 
                        command_line = ...
                            sprintf(['matlab -nojvm -singleCompThread -r "entity_path = ''%s'';  output_entity_path = ''%s''; do_verify = %s; ' ...
                                     'mj2tif_single(entity_path, output_entity_path, do_verify)"'], ...
                                    entity_path, ...
                                    output_entity_path, ...
                                    fif(do_verify, 'true', 'false')) ;
                        fprintf('Command line: %s\n', command_line) ;                        
                        bsub_command_line = sprintf('bsub -o /dev/null -e /dev/null %s', command_line) ;
                        fprintf('bsub Command line: %s\n', bsub_command_line) ;
                        system(bsub_command_line) ;
                    else
                        mj2tif_single(entity_path, output_entity_path, do_verify) ;
                    end
                    duration  = toc(tic_id) ;
                    fprintf('Took %g seconds\n', duration) ;
                end
            else
                output_entity_path = fullfile(output_folder_name, entity_name) ;
                if ~exist(output_entity_path, 'file') ,
                    copyfile(entity_path, output_entity_path) ;
                end
            end
        end
    end
end
