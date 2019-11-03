function result = is_mj2_similar_to_tif(mj2_stack, tif_stack)
    % Checks if an mj2 file is similar to a .tif file.
    % Although really, can compare any two stacks.
    
    %mj2_stack = read_16bit_grayscale_mj2(mj2_file_name) ;
    %tif_stack = read_16bit_grayscale_tif(tif_file_name) ;
    if isequal(class(mj2_stack), class(tif_stack)) && isequal(size(mj2_stack), size(tif_stack)) ,
        if all(all(all(mj2_stack==tif_stack))) ,
            result = true ;
        else
            % ssim_value = ssim(mj2_stack, tif_stack) ;
            % result = (ssim_value>0.95) ;
            
            % mean_summary_error = voxelwise_mean_relative_error_with_guard(mj2_stack, tif_stack, 1/256) ;
            % result = (mean_summary_error<0.1) ;  % this is just intended as a gross sanity check, so use a tolerant threshold
            
            fpe_value = fraction_power_explained(mj2_stack, tif_stack) ;
            result = (fpe_value > 0.99) ;
        end
    else
        result = false ;
    end
end
