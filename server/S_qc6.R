
output$mz_missing_hist <- renderPlot({
  data <- peakData_remove_noise()
  spotNb <- nrow(data)
  mz_view_data <- mz_view_data()
  miss_distribution <- ggplot(mz_view_data,aes(miss_ratio))+geom_histogram(binwidth = 0.01)+theme_bw()
  return(miss_distribution)
})

output$mz_missing_distribution <- renderPlot({
  data <- peakData_remove_noise()
  spotNb <- nrow(data)
  mz_view_data <- mz_view_data()
  mz_view_data$mz <- as.numeric(mz_view_data$mz)
  mz_range <- range(mz_view_data$mz)  
  mz_breaks <- seq(from = floor(mz_range[1] / 100) * 100,  
                   to = ceiling(mz_range[2] / 100) * 100,  
                   by = 100)
  miss_distribution <- ggplot(mz_view_data,aes(mz,miss_ratio))+geom_point()+theme_bw()+
    scale_x_continuous(breaks = mz_breaks) 
  return(miss_distribution)
})

output$sample_missing_distribution <- renderPlot({
  data <- peakData_remove_noise()
  loc <- locs()
  mzNb <- ncol(data)-2
  sam_view_data <- apply(data[,-c(1,2)],1,function(x){
    non_miss_nb <- sum(!is.na(x))
    miss_ratio <- 1-non_miss_nb/mzNb
    return(miss_ratio)
  })
  md_intensity <- data.frame(miss_ratio=sam_view_data,point=names(sam_view_data))
  md_intensity$X <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][1]}))
  md_intensity$Y <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][2]}))
  miss_range <- ggplot(md_intensity,aes(x=X,y=Y,colour=miss_ratio))+geom_point()+
    scale_color_distiller(palette = "Spectral")+theme_bw()+xlim(c(loc[1],loc[2]))+ylim(c(loc[1],loc[2]))
  return(miss_range)
})