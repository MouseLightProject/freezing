function result = fraction_variance_explained(mj2_stack, tif_stack)
    if isequal(class(mj2_stack), class(tif_stack)) && isequal(size(mj2_stack), size(tif_stack)) ,
        if all(all(all(mj2_stack==tif_stack))) ,
            result = 1 ;
        else
            mj2_stack_serial = double(mj2_stack(:)) ;
            tif_stack_serial = double(tif_stack(:)) ;
            tif_mean = mean(tif_stack_serial) 
            
            residual_variance = mean( (mj2_stack_serial-tif_stack_serial).^2 ) 
            sqrt_residual_variance = sqrt(residual_variance)
            total_variance = mean( (tif_stack_serial-tif_mean).^2 ) 
            sqrt_total_variance = sqrt(total_variance)
            
            if residual_variance == 0 ,                
                result = 1 ;  % want this to be so even if total_variance==0, which would give nan in the expression below
            else
                result = 1 - residual_variance/total_variance ;  % this can actually be negative, since the mj2_stack is not a regression
            end
        end
    else
        result = 0 ;
    end
end
