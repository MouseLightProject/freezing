sample_date = '2022-05-10' ;
mj2_output_folder_path = sprintf('/groups/mousebrainmicro/mousebrainmicro/data/to_nearline_raw/%s', sample_date) ;
tif_input_folder_path = sprintf('/groups/mousebrainmicro/mousebrainmicro/data/to_compress/%s', sample_date) ;
compression_ratio = 10 ;
do_run_on_cluster = true ;
maximum_running_slot_count = 500 ;

freeze_sample
