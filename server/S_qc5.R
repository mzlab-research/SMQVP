
output$total_intensity_after_pioints_remove <- renderPlot({
  data <- peakData_remove_noise()
  loc <- locs()
  sam_view_data <- apply(data[,-c(1,2)],1,function(x){
    sum_intensity <- sum(x,na.rm = T)
    return(sum_intensity)
  })
  md_intensity <- data.frame(intensity=sam_view_data,point=names(sam_view_data))
  md_intensity$X <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][1]}))
  md_intensity$Y <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][2]}))
  md_plot <-  ggplot(md_intensity,aes(X,Y,colour =log10(intensity)))+geom_point()+
    scale_color_distiller(palette = "Spectral")+xlim(c(loc[1],loc[2]))+ylim(c(loc[1],loc[2]))+
    theme_bw()
  return(md_plot)
})

mz_view_data <- reactive({
  data <- peakData_remove_noise()
  spotNb <- nrow(data)
  mz_view_data <- apply(data[,-c(1,2)],2,function(x){
    non_miss_nb <- sum(!is.na(x))
    miss_ratio <- 1-non_miss_nb/spotNb
    median_intensity <- median(x,na.rm = T)
    mz_wise <- c(non_miss_nb,miss_ratio,median_intensity)
    names(mz_wise) <- c("non_miss_nb","miss_ratio","median_intensity")
    return(mz_wise)
  })
  mz_view_data <- as.data.frame(t(mz_view_data))
  mz_view_data$mz <- row.names(mz_view_data)
  return(mz_view_data)
})

output$mz_intensity_hist <- renderPlot({
  mz_view_data <- mz_view_data()
  intensity_distribution <- ggplot(mz_view_data,aes(log10(median_intensity)))+geom_histogram()+theme_bw()
  return(intensity_distribution)
})

output$mz_intensity_spectra <- renderPlot({
  mz_view_data <- mz_view_data()
  mz_view_data$mz <- as.numeric(mz_view_data$mz)
  mz_range <- range(mz_view_data$mz)  
  mz_breaks <- seq(from = floor(mz_range[1] / 100) * 100,  
                   to = ceiling(mz_range[2] / 100) * 100,  
                   by = 100)
  intensity_range <- ggplot(mz_view_data,aes(x=mz,y=median_intensity))+
    geom_segment( aes(x=mz, xend=mz, y=0, yend=median_intensity))+theme_bw()+
    scale_x_continuous(breaks = mz_breaks) 
  return(intensity_range)
})