output_folder_name = '/groups/mousebrainmicro/mousebrainmicro/scripts/octree-freezing/octree-rebuilding-test-input-folder' ;
input_folder_name = '/nrs/mouselight/SAMPLES/2023-02-23' ;
max_depth = 2 ;
do_submit = true ;
do_try = false ;
maximum_running_slot_count = 400 ;
slots_per_job = 1 ;
bsub_options = '-P mouselight -W 59 -J copy' ; 
submit_host_name = 'login2.int.janelia.org' ;

% Delete the test output folder
reset_for_test(output_folder_name) ;

% Do the copy
find_and_batch(input_folder_name, ...
               @(file_path)(true), ...
               @copy_file_for_find_and_batch, ...
               'do_submit', do_submit, ...
               'do_try', do_try, ...
               'submit_host_name', submit_host_name, ...
               'maximum_running_slot_count', maximum_running_slot_count, ...
               'slots_per_job', slots_per_job, ...
               'bsub_options', bsub_options, ...
               'max_depth', max_depth, ...
               'predicate_extra_args', cell(1,0), ...
               'batch_function_extra_args', {input_folder_name, output_folder_name}) ;
