function mj2_from_tif_single_with_temps(mj2_output_file_path, tif_input_file_path, compression_ratio, do_verify)
    scratch_folder_path = get_scratch_folder_path() ;
    temporary_tif_input_file_path = [tempname(scratch_folder_path) '.tif'] ;
    temporary_mj2_output_file_path = [tempname(scratch_folder_path) '.mj2'] ;  % risky, but VideoWriter is dumb and always adds this anyway
    copyfile(tif_input_file_path, temporary_tif_input_file_path);
    mj2_from_tif_single(temporary_mj2_output_file_path, temporary_tif_input_file_path, compression_ratio, do_verify);
    copyfile(temporary_mj2_output_file_path, mj2_output_file_path);
    delete(temporary_tif_input_file_path);
    delete(temporary_mj2_output_file_path);
end
