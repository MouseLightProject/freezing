sample_date = '2021-08-17' ;
mj2_output_folder_path = sprintf('/nrs/mouselight/SAMPLES/TO_NEARLINE_TEMP/RAW_archive/%s', sample_date) ;
tif_input_folder_path = sprintf('/groups/mousebrainmicro/mousebrainmicro/data/aborted-acquisitions/%s', sample_date) ;
compression_ratio = 10 ;
do_run_on_cluster = true ;
maximum_running_slot_count = 500 ;

freeze_sample

