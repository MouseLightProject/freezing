function result = is_mj2_similar_to_tif(mj2_stack, tif_stack)
    % Checks if an mj2 file is similar to a .tif file.
    % Although really, can compare any two stacks.
    
    %mj2_stack = read_16bit_grayscale_mj2(mj2_file_name) ;
    %tif_stack = read_16bit_grayscale_tif(tif_file_name) ;
    if isequal(class(mj2_stack), class(tif_stack)) && isequal(size(mj2_stack), size(tif_stack)) ,
        if all(all(all(mj2_stack==tif_stack))) ,
            result = true ;
        else
            %ssim_value = ssim(mj2_stack, tif_stack) ;
            %result = (ssim_value>0.95) ;
            
            % Use fraction of variance explained by the mj2
            
            mj2_stack_serial = double(mj2_stack(:))/(2^16-1) ;
            tif_stack_serial = double(tif_stack(:))/(2^16-1) ;
            absolute_error = abs(mj2_stack_serial-tif_stack_serial) ;
            error_scale = max(1/256, tif_stack_serial) ;
            summary_error = absolute_error ./ error_scale ;  % relative error, but with a guard against very small target values
            mean_summary_error = mean(summary_error) ;
            result = (mean_summary_error<0.1) ;  % this is just intended as a gross sanity check, so use a tolerant threshold
        end
    else
        result = false ;
    end
end
