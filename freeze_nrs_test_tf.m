sample_date = '2020-11-30-selected' ;
mj2_output_folder_path = sprintf('/nrs/mouselight/Temp/frozen-test/%s', sample_date) ;
tif_input_folder_path = sprintf('/groups/mousebrainmicro/mousebrainmicro/data/acquisition/scope1-tests/%s', sample_date) ;
compression_ratio = 10 ;
do_run_on_cluster = true ;
maximum_running_slot_count = 500 ;

freeze_sample

