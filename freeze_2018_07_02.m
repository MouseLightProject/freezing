sample_date = '2018-07-02' ;
mj2_output_folder_path = sprintf('/nrs/mouselight-v/frozen/%s', sample_date) ;
tif_input_folder_path = sprintf('/groups/mousebrainmicro/mousebrainmicro/data/%s', sample_date) ;
compression_ratio = 10 ;
do_verify = false ;
do_run_on_cluster = true ;
mj2_from_tif(mj2_output_folder_path, tif_input_folder_path, compression_ratio, do_verify, do_run_on_cluster)
