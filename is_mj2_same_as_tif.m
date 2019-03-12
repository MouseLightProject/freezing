function result = is_mj2_same_as_tif(mj2_file_name, tif_file_name)
    % Converts a single .mj2 file at input_file_name to a multi-image .tif
    % at output_file_name.  Will overwrite pre-existing file at
    % output_file_name, if present.
    
    mj2_stack = read_16bit_grayscale_mj2(mj2_file_name) ;
    tif_stack = read_16bit_grayscale_tif(tif_file_name) ;
    result = isequal(class(mj2_stack), class(tif_stack)) && isequal(size(mj2_stack), size(tif_stack)) && all(all(all(mj2_stack==tif_stack))) ;
end
