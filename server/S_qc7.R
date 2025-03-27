
isotope_list <- reactive({
  data <- peakData_remove_noise()
  spotNb <- nrow(data)
  mz_view_data <- mz_view_data()
  
  y <- mz_view_data[,c(4,3)]
  y$mz <- as.numeric(y$mz)
  y <- y[order(y$mz),]
  isos <- isotopologues(y, ppm = input$iso_ppm_setting)
  data[is.na(data)] <- 0.1
  for (i in seq_along(isos)) {
    z <- isos[[i]]
    m <- data[,c(z+2)]
    co <- cor(m)
    co[co==1] <- 0
    high_co <- unique(as.vector(which(co > 0.5, arr.ind = TRUE)))
    if(length(high_co) == 0){#check correlation
      isos[[i]] <- NA
    }else{
      m_cor <- data[,c(z[high_co]+2)]
      m_intensity <- apply(m_cor,2,median)
      o1 <- order(m_intensity,decreasing = T)
      o2 <- order(names(m_intensity))
      if(identical(o1,o2)){#check intensity order
        isos[[i]] <- z[high_co]
      }else{
        isos[[i]] <- NA
      }#check intensity order
    }#check correlation
  }#for
  cleaned_list <- isos[!is.na(isos)]
  names(cleaned_list) <- paste("iso_pair",c(1:length(cleaned_list)),sep = "_")
  return(cleaned_list)
})


output$isotope_ratio_box <- renderInfoBox({
  cleaned_list <- isotope_list()
  data <- peakData_remove_noise()
  
  k <- length(unlist(cleaned_list))/(ncol(data)-2)
  infoBox(
    "The percent of isotope peak is:", sprintf("%.2f%%", k * 100), icon = icon("list"),
    color = "purple"
  )
})

output$Isotope_peaks_distribution <- renderPlot({
  cleaned_list <- isotope_list()
  data <- peakData_remove_noise()
  
  mz_view_data <- apply(data[,-c(1,2)],2,function(x){
    median_intensity <- median(x,na.rm = T)
    return(median_intensity)
  })
  y <- data.frame(intensity=mz_view_data,mz=names(mz_view_data))
  jl <- list(y=y,cleaned_list=cleaned_list)
  plot(y$mz, y$intensity, type = "h",xlab = "m/z",ylab = "Intensity")
  for (i in seq_along(cleaned_list)) {
    z <- cleaned_list[[i]]
    points(y$mz[z], y$intensity[z], col = i + 1)
  }
})


single_isotope_peak <- reactive({
  data <- peakData_remove_noise()
  cleaned_list <- isotope_list()
  
  iso <- NULL
  for (i in seq_along(cleaned_list)) {
    z <- cleaned_list[[i]]
    min_loc <- min(z)
    single_iso <- names(data)[min_loc+2]
    all_loc <- names(data)[z+2]
    iso_mz <- data.frame(mz=all_loc,single_ios=single_iso)
    iso <- rbind(iso,iso_mz)
  }#for

  return(iso)
  
})

