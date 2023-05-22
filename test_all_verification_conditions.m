function test_all_verification_conditions()
    %for freezing_or_thawing = { 'freezing', 'thawing' } ,
    for freezing_or_thawing = { 'thawing' } ,
        %for raw_tiles_or_octree = { 'raw-tiles', 'octree' } ,
        for raw_tiles_or_octree = { 'octree' } ,
            %for local_or_cluster = { 'local', 'cluster' } ,
            for local_or_cluster = { 'local' } ,
                for stack_or_non_stack = { 'stack', 'non-stack' } ,
                    for exact_problem = { 'deleted', 'zero-length', 'corrupt' } ,
                        test_verification_condition( ...
                            freezing_or_thawing{1}, raw_tiles_or_octree{1}, local_or_cluster{1}, stack_or_non_stack{1}, exact_problem{1}) ;
                    end
                end
            end
        end
    end    
end
