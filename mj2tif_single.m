function mj2tif_single(input_file_name, output_file_name, do_verify)
    % Converts a single .mj2 file at input_file_name to a multi-image .tif
    % at output_file_name.  Will overwrite pre-existing file at
    % output_file_name, if present.
    
    if nargin<3 || isempty(do_verify) ,
        do_verify = false ;
    end
    
    input_file = VideoReader(input_file_name) ;
    frame_index = 0 ;
    while input_file.hasFrame() ,
        frame_index = frame_index + 1 ; 
        frame = input_file.readFrame() ;
        if frame_index == 1 ,
            imwrite(frame, output_file_name, 'WriteMode', 'overwrite',  'Compression', 'none') ;
        else
            imwrite(frame, output_file_name, 'WriteMode', 'append',  'Compression', 'none') ;            
        end        
    end    
    
    if do_verify ,
        if ~is_mj2_same_as_tif(input_file_name, output_file_name) ,
            error('%s is not the same as %s\n', output_file_name, input_file_name) ;
        end
    end
end
