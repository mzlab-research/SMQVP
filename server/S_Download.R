
output$peak_table_head <- renderTable({
  data <- peakData_remove_noise()
  data[1:5,1:10]
})

output$downloadData_peak_table <- downloadHandler(
  filename = function() {
    paste("peak_intensity_table_", Sys.Date(), ".csv", sep = "")
  },
  content = function(file) {
    data_to_download <- peakData_remove_noise()
    write.csv(data_to_download, file, row.names = FALSE,col.names = T,sep = ",")
  }
)

point_info <- reactive({
  data <- peakData_remove_noise()
  mzNb <- ncol(data)-2
  sam_view_data <- apply(data[,-c(1,2)],1,function(x){
    x <- as.numeric(x)
    non_miss_nb <- sum(!is.na(x))
    miss_ratio <- 1-non_miss_nb/mzNb
    median_intensity <- median(x,na.rm = T)
    return(c(miss_ratio,median_intensity))
  })
  sam_view_data <- as.data.frame(t(sam_view_data))
  names(sam_view_data) <- c("missing ratio","median_intensity")
  sam_view_data$point <- row.names(sam_view_data)
  sam_view_data$X <- as.numeric(lapply(sam_view_data$point,function(x){strsplit(x,"_")[[1]][1]}))
  sam_view_data$Y <- as.numeric(lapply(sam_view_data$point,function(x){strsplit(x,"_")[[1]][2]}))
  sam_view_data[,c(4,5,1,2)]
})

output$point_table_head <- renderTable({
  data <- point_info()
  head(data)
})

output$downloadData_point_info <- downloadHandler(
  filename = function() {
    paste("point_info_", Sys.Date(), ".csv", sep = "")
  },
  content = function(file) {
    data_to_download <- point_info()
    write.csv(data_to_download, file, row.names = FALSE,col.names = T,sep = ",")
  }
)


mz_info_summary <- reactive({
  noise_score <- noise_detection()
  mz_view_data <- mz_view_data() #miss_ratio;median_intensity
  single_isotope_peak <- single_isotope_peak()  #mz vector
  adduct_ion_table <- adduct_ion_table()
  mz_view_data <- merge(mz_view_data,single_isotope_peak,by="mz",all.x=TRUE)#isotope
  mz_view_data <- merge(mz_view_data,adduct_ion_table,by="mz",all.x=TRUE) #adduct
  noise <- data.frame(noise_score=noise_score,mz=names(noise_score))
  mz_view_data <- merge(mz_view_data,noise,by="mz",all.x=TRUE)
  mz_view_data <- mz_view_data[,-2]
  mz_view_data$adduct <- as.character(mz_view_data$adduct)
  mz_view_data[is.na(mz_view_data)] <- "Unknown"
  mz_view_data$noise_score <- -log10(mz_view_data$noise_score)
  mz_view_data$miss_ratio <- round(mz_view_data$miss_ratio,3)
  mz_view_data <- mz_view_data %>% arrange(adduct_mark,single_ios)
  
  return(mz_view_data)
})


output$mz_table_head <- renderTable({
  data <- mz_info_summary()
  head(data)
})

output$downloadData_mz_info <- downloadHandler(
  filename = function() {
    paste("mass_feature_info_", Sys.Date(), ".csv", sep = "")
  },
  content = function(file) {
    data_to_download <- mz_info_summary()
    write.csv(data_to_download, file, row.names = FALSE,col.names = T,sep = ",")
  }
)