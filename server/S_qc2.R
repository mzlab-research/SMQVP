
peak_table_background <- eventReactive(input$finish_selection, {
  background <- background()
  data <- peakData()
  validate(
    need(length(background)>0,"Please choose an background area")
  )
  
  data$mark <- "unlabel"
  for(i in names(background)){
    k <- which(row.names(data) %in% row.names(background[[i]]))
    data$mark[k] <- i
  }
  
  data <- data[data$mark != "unlabel",]
  spectrum_data <- NULL
  for(i in unique(data$mark)){
    #print(i)
    #i <- "background_1"
    kd <- data[data$mark == i,]
    spectra <- apply(kd[,-c(1,2,ncol(kd),ncol(kd)-1)],2,function(x){median(x,na.rm = T)})
    spectrum <- data.frame(mz=names(spectra),intensity=spectra,region=i)
    spectrum_data <- rbind(spectrum_data,spectrum)
  }
  return(spectrum_data)
  
})

output$background_correlation <- renderPlot({
  spectrum_data <- peak_table_background()
  spectrum_data2 <- dcast(spectrum_data,mz ~ region,value.var = "intensity")
  row.names(spectrum_data2) <- spectrum_data2$mz
  spectrum_data2 <- spectrum_data2[,-1]
  na <- apply(spectrum_data2,1,function(x){sum(is.na(x)/ncol(spectrum_data2))})
  na <- na[na ==1]
  if(length(na)>0){
    na_col <- which(row.names(spectrum_data2) %in% names(na))
    spectrum_data2 <- spectrum_data2[-na_col,]
  }
  spectrum_data2[is.na(spectrum_data2)] <- 0.1
  back_cor <- cor(spectrum_data2)
  pheatmap(back_cor)
})

output$background_boxplot <- renderPlot({
  spectrum_data <- peak_table_background()
  ggplot(spectrum_data,aes(region,log10(intensity)))+geom_boxplot()+theme_bw()
})