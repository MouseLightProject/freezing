tif_file_name = '01018-ngc.0.tif' ;
mj2_file_name = '01018-ngc.0.mj2' ;

tic_id = tic() ;
tif_stack = read_16bit_grayscale_tif(tif_file_name) ;
mj2_stack = read_16bit_grayscale_mj2(mj2_file_name) ;
toc(tic_id)

tic_id = tic() ;
ssim_value = ssim(mj2_stack, tif_stack)
toc(tic_id)

tic_id = tic() ;
vmre_value = voxelwise_mean_relative_error_with_guard(mj2_stack, tif_stack, 1/256) 
toc(tic_id)

tic_id = tic() ;
fpe_value = fraction_power_explained(mj2_stack, tif_stack) 
toc(tic_id)

