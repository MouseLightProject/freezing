sample_date = '2019-10-04' ;
mj2_output_folder_path = sprintf('/groups/mousebrainmicro/mousebrainmicro/frozen/%s', sample_date) ;
tif_input_folder_path = sprintf('/groups/mousebrainmicro/mousebrainmicro/data/%s', sample_date) ;
compression_ratio = 10 ;
do_run_on_cluster = true ;
maximum_running_slot_count = 1500 ;

freeze_sample
