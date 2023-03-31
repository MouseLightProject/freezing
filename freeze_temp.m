sample_date = '2020-04-15' ;
mj2_output_folder_path = sprintf('/nrs/mouselight/SAMPLES/TO_NEARLINE/RAW_archive/%s', sample_date) ;
tif_input_folder_path = sprintf('/nrs/mouselight/pipeline_output/%s/stage_1_line_fix_output/', sample_date) ;
compression_ratio = 10 ;
do_run_on_cluster = true ;
maximum_running_slot_count = 500 ;

freeze_sample
