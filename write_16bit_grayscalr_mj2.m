function write_16bit_grayscalr_mj2(file_name, stack) 
    vw = VideoWriter(file_name, 'Motion JPEG 2000') ;
    vw.CompressionRatio = compression_ratio ;
    vw.MJ2BitDepth = 16 ;
    vw.open() ;
    vw.writeVideo(stack) ;
    vw.close() ;
end
