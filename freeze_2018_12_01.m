sample_date = '2018-12-01' ;
mj2_output_folder_path = sprintf('/nrs/mouselight-v/frozen/%s/Tiling', sample_date) ;
tif_input_folder_path = sprintf('/nrs/mouselight/pipeline_output/%s/stage_1_line_fix_output', sample_date) ;
compression_ratio = 10 ;
do_verify = false ;
do_run_on_cluster = true ;

freeze_sample
