function result = voxelwise_mean_relative_error_with_guard(mj2_stack, tif_stack, voxel_scale)
    if isequal(class(mj2_stack), class(tif_stack)) && isequal(size(mj2_stack), size(tif_stack)) ,
        if all(all(all(mj2_stack==tif_stack))) ,
            result = 0 ;
        else
            mj2_stack_serial = double(mj2_stack(:))/(2^16-1) ;
            tif_stack_serial = double(tif_stack(:))/(2^16-1) ;
            absolute_error = abs(mj2_stack_serial-tif_stack_serial) ;
            error_scale = max(voxel_scale, tif_stack_serial) ;  % voxel scale of 1/256 is what I've used for uint16 data...
            summary_error = absolute_error ./ error_scale ;  % relative error, but with a guard against very small target values
            result = mean(summary_error) ;
        end
    else
        result = +inf ;
    end
end
