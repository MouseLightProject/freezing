function test_everything()
    for freezing_or_thawing = { 'freezing', 'thawing' } ,
        for raw_tiles_or_octree = { 'raw-tiles', 'octree' } ,
            for local_or_cluster = { 'local', 'cluster' } ,
                test_something(freezing_or_thawing{1}, raw_tiles_or_octree{1}, local_or_cluster{1})
            end
        end
    end    
end
