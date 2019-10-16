sample_date = '2019-03-26' ;
mj2_output_folder_path = sprintf('/nrs/mouselight-v/frozen/%s', sample_date) ;
tif_input_folder_path = sprintf('/groups/mousebrainmicro/mousebrainmicro/data/%s', sample_date) ;
batch_verify_files_after_mj2_from_tif(mj2_output_folder_path, tif_input_folder_path)
