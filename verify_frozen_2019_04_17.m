sample_date = '2019-04-17' ;
mj2_root_folder_path = sprintf('/nrs/mouselight-v/frozen/%s', sample_date) ;
tif_root_folder_path = sprintf('/groups/mousebrainmicro/mousebrainmicro/data/%s', sample_date) ;

is_all_well = verify_frozen_files(mj2_root_folder_path, tif_root_folder_path) 
