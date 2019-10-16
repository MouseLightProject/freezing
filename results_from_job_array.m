function result = results_from_job_array(job_array)
    job_count = length(job_array) ;
    if job_count == 0 ,
        result = {} ;
    else
        result = cell(1, job_count) ;
        for job_index = 1 : job_count ,
            job = job_array(job_index) ;
            try
                c = job.fetchOutputs() ;
            catch err  %#ok<NASGU>
                c = cell(1,0) ;
            end                
            result{job_index} = c ;
        end    
    end
end
