function wait_on_job_array(job_array)
    job_count = length(job_array) ;
    for job_index = 1 : job_count ,
        job_array(job_index).wait() ;
    end    
end