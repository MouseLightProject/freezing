function mj2tif(input_folder_name, output_folder_name, do_verify)
    % Converts each .mj2 file in input_folder_name to a multi-image .tif in
    % output_folder_name.  Will overwrite pre-existing files in
    % output_folder_name, if present.
    
    if nargin<3 ,
        do_verify = false ;
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
            mj2tif(entity_path, output_entity_path) ;
        else
            % if a normal file, convert to .tif if it's a .mj2, or just
            % copy otherwise
            [~,~,ext] = fileparts(entity_path) ;
            if isequal(ext, '.mj2') ,
                output_entity_path = fullfile(output_folder_name, replace_extension(entity_name, '.tif')) ;
                if ~exist(output_entity_path, 'file') ,
                    fprintf('About to convert %s...', entity_path);
                    tic_id = tic() ;
                    mj2tif_single(entity_path, output_entity_path, do_verify) ;
                    duration  = toc(tic_id) ;
                    fprintf(' took %g seconds\n', duration) ;
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
