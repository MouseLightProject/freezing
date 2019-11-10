tif_root_path = '/groups/mousebrainmicro/mousebrainmicro/data/2018-10-01' ;
mj2_root_path = '/nrs/mouselight-v/frozen/2018-10-01' ;

tif_file_paths = find_and_list(tif_root_path, @does_match_raw_tile_tif_name);
tif_count = length(tif_file_paths) ;
shuffled_file_indices = randperm(tif_count) ;
tile_count = 50 ;
random_file_indices = shuffled_file_indices(1:tile_count)

mj2_file_paths = cell(1,tif_count) ;
for i = 1 : tif_count ,
    tif_file_path = tif_file_paths{i} ;
    tif_relative_path = relpath(tif_file_path, tif_root_path) ;
    mj2_relative_path = replace_extension(tif_relative_path, '.mj2') ;
    mj2_file_path = fullfile(mj2_root_path, mj2_relative_path) ;
    mj2_file_paths{i} = mj2_file_path ;
end  
%mj2_file_paths

% load tif stacks
tic_id = tic() ;
for i = 1:tile_count ,    
    tif_file_path = tif_file_paths{random_file_indices(i)} ;
    tif_stack = read_16bit_grayscale_tif(tif_file_path) ;
    if i == 1 ,
        tif_stacks = zeros([size(tif_stack) tile_count]) ;
    end
    tif_stacks(:,:,:,i) = tif_stack ;
end
toc(tic_id) ;

% load mj2 stacks
tic_id = tic() ;
for i = 1:tile_count ,    
    mj2_file_path = mj2_file_paths{random_file_indices(i)} ;
    mj2_stack = read_16bit_grayscale_mj2(mj2_file_path) ;
    if i == 1 ,
        mj2_stacks = zeros([size(mj2_stack) tile_count]) ;
    end
    mj2_stacks(:,:,:,i) = mj2_stack ;
end
toc(tic_id) ;

tic_id = tic() ;
fpe_matrix = zeros(tile_count, tile_count) ;
for i = 1:tile_count ,    
    tif_stack = tif_stacks(:,:,:,i) ;
    for j = 1:tile_count ,
        mj2_stack = mj2_stacks(:,:,:,j) ;
        fpe = fraction_power_explained(mj2_stack, tif_stack) ;
        fpe_matrix(i,j) = fpe ;        
    end
end
toc(tic_id) ;
fpe_matrix

is_on_diagonal = logical(eye(tile_count)) 
is_off_diagonal = ~is_on_diagonal 
fpes_on_diagonal = fpe_matrix(is_on_diagonal) 
fpes_off_diagonal = fpe_matrix(is_off_diagonal) 

log_odds_fpes_on_diagonal = log(fpes_on_diagonal./(1-fpes_on_diagonal))
log_odds_fpes_off_diagonal = log(fpes_off_diagonal./(1-fpes_off_diagonal))

mean_self_fpe = mean(log_odds_fpes_on_diagonal)
std_self_fpe = std(log_odds_fpes_on_diagonal)

mean_other_fpe = mean(log_odds_fpes_off_diagonal)
std_other_fpe = std(log_odds_fpes_off_diagonal)

self_support = min(log_odds_fpes_on_diagonal) 
other_support = max(log_odds_fpes_off_diagonal)
are_separable = self_support > other_support 
max_margin_threshold = (self_support + other_support)/2


d_prime = (mean_self_fpe-mean_other_fpe) / sqrt( (std_self_fpe^2 + std_other_fpe^2)/2 )

log_odds_edges = (0:0.5:20) ;
log_odds_centers = (log_odds_edges(1:end-1)+log_odds_edges(2:end))/2
n_self = histcounts(log_odds_fpes_on_diagonal,log_odds_edges)
n_other = histcounts(log_odds_fpes_off_diagonal,log_odds_edges)

f = figure('color', 'w') ;
a  = axes(f)
help bar
bar(log_odds_centers, n_other/sum(is_off_diagonal(:)), 'b', 'EdgeColor', 'none')
hold on
bar(log_odds_centers, n_self/sum(is_on_diagonal(:)), 'r', 'EdgeColor', 'none')
hold off
% 9 looks like a pretty good cutoff





