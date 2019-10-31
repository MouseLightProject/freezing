function result = fraction_power_explained(mj2_stack, tif_stack)
    if isequal(class(mj2_stack), class(tif_stack)) && isequal(size(mj2_stack), size(tif_stack)) ,
        if all(all(all(mj2_stack==tif_stack))) ,
            result = 1 ;
        else
            mj2_stack_serial = double(mj2_stack(:))/(2^16-1) ;
            tif_stack_serial = double(tif_stack(:))/(2^16-1) ;

            error_power = mean( (mj2_stack_serial-tif_stack_serial).^2 ) ;
            image_power = mean( tif_stack_serial.^2 ) ;
            

            % PSNR is Imax^2 / MSE, where Imax is the max possible image intensity, which is
            % 1 in this case because we divided by 2^16-1.  So PSNR = 1/MSE.  So the "PNSR"
            % is just MSE.  So 1-mse is the fraction of variance explained
            
            result = 1 - error_power/image_power
        end
    else
        result = 0 ;
    end
end
