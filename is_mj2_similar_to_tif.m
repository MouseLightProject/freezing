function result = is_mj2_similar_to_tif(mj2_file_name, tif_file_name)
    % Checks if an mj2 file is similar to a .tif file.
    
    mj2_stack = read_16bit_grayscale_mj2(mj2_file_name) ;
    tif_stack = read_16bit_grayscale_tif(tif_file_name) ;
    if isequal(class(mj2_stack), class(tif_stack)) && isequal(size(mj2_stack), size(tif_stack)) ,
        if all(all(all(mj2_stack==tif_stack))) ,
            result = true ;
        else
            ssim_value = ssim(mj2_stack, tif_stack) ;
            result = (ssim_value>0.95) ;
            if ~result ,
                keyboard 
            end
%            mj2_stack_serial = double(mj2_stack(:)) ;
%            tif_stack_serial = double(tif_stack(:)) ;            
%             Rho_hat = corrcoef(mj2_stack_serial, tif_stack_serial) ;
%             rho_hat = Rho_hat(1,2) 
%             result = (rho_hat>0.9) ;
        end
    else
        result = false ;
    end
end
