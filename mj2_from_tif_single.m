function mj2_from_tif_single(mj2_output_file_name, tif_input_file_name, compression_ratio, do_verify)
    % Converts a single .tif file at input_file_name to a MJPEG-2000 file at
    % output_file_name, using the given compression ratio.  Will overwrite
    % pre-existing file at output_file_name, if present.

    %mj2_output_file_name
    %tif_input_file_name
    
    % Process input args
    if ~exist('compression_ratio', 'var')  || isempty(compression_ratio) ,
        compression_ratio = 10 ;
    end    
    if ~exist('do_verify', 'var')  || isempty(do_verify) ,
        do_verify = false ;
    end    
    
    % Read the input file
    stack = read_16bit_grayscale_tif(tif_input_file_name) ;

    % Write the output file    
    write_16bit_grayscale_mj2(mj2_output_file_name, stack, compression_ratio) ;
    
    % Verify, if desired
    
    % This won't really catch errors on the cluster!
    % Should work if we do a quit(1) while running on the cluster, since we write to
    % local scratch, and only copy to proper location if this function returns
    % without error.
    
    if do_verify ,
        if ~is_mj2_similar_to_tif(mj2_output_file_name, stack) ,            
            error('%s is not sufficiently similar to %s\n', mj2_output_file_name, tif_input_file_name) ;
        end
    end
end
