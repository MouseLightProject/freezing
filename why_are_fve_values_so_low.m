tif_root_path = '/groups/mousebrainmicro/mousebrainmicro/data/2018-10-01' ;
mj2_root_path = '/nrs/mouselight-v/frozen/2018-10-01' ;

tif_file_paths = find_and_list(tif_root_path, @does_match_raw_tile_tif_name);
tif_count = length(tif_file_paths) ;
shuffled_file_indices = randperm(tif_count) ;
tile_count = 20 ;
random_file_indices = shuffled_file_indices(1:tile_count)
%random_file_indices = [      16503       35805        9320] ;

mj2_file_paths = cell(1,tif_count) ;
for i = 1 : tif_count ,
    tif_file_path = tif_file_paths{i} ;
    tif_relative_path = relpath(tif_file_path, tif_root_path) ;
    mj2_relative_path = replace_extension(tif_relative_path, '.mj2') ;
    mj2_file_path = fullfile(mj2_root_path, mj2_relative_path) ;
    mj2_file_paths{i} = mj2_file_path ;
end  
%mj2_file_paths

% compute fve for each
tic_id = tic() ;
fves_on_diagonal = zeros(tile_count, 1) ;
for i = 1:tile_count ,    
    tif_file_path = tif_file_paths{random_file_indices(i)} ;
    tif_stack = read_16bit_grayscale_tif(tif_file_path) ;
    mj2_file_path = mj2_file_paths{random_file_indices(i)} ;
    mj2_stack = read_16bit_grayscale_mj2(mj2_file_path) ;
    fves_on_diagonal(i) = fraction_variance_explained(mj2_stack, tif_stack) ;
end
toc(tic_id) ;
fves_on_diagonal


% % 2 has the lowest fve
% tif_file_path = tif_file_paths{random_file_indices(2)} 
% mj2_file_path = mj2_file_paths{random_file_indices(2)} 
% mj2_stack = mj2_stacks(:,:,:,2) ;
% tif_stack = tif_stacks(:,:,:,2) ;
% self_difference_stack = mj2_stack - tif_stack ;
% abs_diff_stack = abs(self_difference_stack) ;
% [max_abs_diff, i_max_abs_diff] = max(abs_diff_stack(:))
% [i_mad,j_mad,k_mad] = ind2sub(size(abs_diff_stack), i_max_abs_diff)
% 
% mj2_slice = mj2_stack(:,:,k_mad) ;
% tif_slice = tif_stack(:,:,k_mad) ;
% 

% has the highest fve
[max_fve, i_max_fve] = max(fves_on_diagonal)
file_index = random_file_indices(i_max_fve)
tif_file_path = tif_file_paths{file_index} 
mj2_file_path = mj2_file_paths{file_index} 
