
volcano_table <- eventReactive(input$finish_selection, {
  background <- background()
  tissue <- tissue()
  data <- peakData()

  validate(
    need((length(tissue)>0) & length(background)>0,"Please choose tissue and background area")
  )
  data$mark <- "unlabel"
  data$group <- "unlabel"
  for(i in names(background)){
    k <- which(row.names(data) %in% row.names(background[[i]]))
    data$mark[k] <- i
    data$group[k] <- "background"
  }
  for(j in names(tissue)){
    v <- which(row.names(data) %in% row.names(tissue[[j]]))
    data$mark[v] <- j
    data$group[v] <- "tissue"
  }
  
  data <- data[data$mark != "unlabel",]
  spectrum_data <- NULL
  for(i in unique(data$mark)){
    kd <- data[data$mark == i,]
    spectra <- apply(kd[,-c(1,2,ncol(kd),(ncol(kd)-1))],2,function(x){median(x,na.rm = T)})
    spectrum <- data.frame(mz=names(spectra),intensity=spectra,region=i,group=kd$group[1])
    spectrum_data <- rbind(spectrum_data,spectrum)
  }

  spectrum_data3 <- dcast(spectrum_data,region+group ~ mz,value.var = "intensity")
  na_cal <- apply(spectrum_data3,2,function(x){sum(is.na(x))/nrow(spectrum_data3)})
  all_miss <- which(names(spectrum_data3) %in% names(na_cal[na_cal == 1]))
  if(length(all_miss)>0){
    spectrum_data3 <- spectrum_data3[,-all_miss]
  }
  spectrum_data3[is.na(spectrum_data3)] <- runif(sum(is.na(spectrum_data3)), min = 0, max = 1)
  b <- which(spectrum_data3$group == "background")
  t <- which(spectrum_data3$group == "tissue")
  vol <- apply(spectrum_data3[,-c(1,2)],2,function(x){
    back_mean <- median(x[b])
    tissue_mean <- median(x[t])
    fd <- tissue_mean/back_mean 
    p <- t.test(log2(x[b]),log2(x[t]))
    k <- c(back_mean,tissue_mean,fd,p$p.value)
    names(k) <- c("back_mean","tissue_mean","fold_change","p")
    return(k)
  })
  
  vol <- as.data.frame(t(vol))
  vol$mz <- row.names(vol)
  vol$Status <- ifelse(vol$fold_change > 1, "higher in tissue", "higher in background")
  return(vol)
})


output$volcano_background_vs_tissue <- renderPlot({
  vol <- volcano_table()
  k <- ggplot(vol,aes(log2(fold_change),-log10(p),colour = Status))+geom_point()+theme_bw()+
    ggtitle("tissue region / background region")
  return(k)
})

output$number_background_vs_tissue <- renderTable({
  vol <- volcano_table()
  status <- table(vol$Status)
  ratio <- status[2]/(status[1]+status[2])
  k <- data.frame(
    higer_in_tissue_peaks=status[2],
    higher_in_background_peaks=status[1],
    higher_in_tissue_percent=status[2]/(status[1]+status[2])
  )
  return(k)
})

peakData_remove_background_feature <- reactive({
  data <- peakData()
  vol <- volcano_table()
  mz_high_in_background <-vol$mz[vol$fold_change<1]
  mz_remove <- which(names(data) %in% mz_high_in_background)
  data <- data[,-mz_remove]
  return(data)
})

output$total_intensity_before_mz_remove <- renderPlot({
  data <- peakData()
  loc <- locs()
  sam_view_data <- apply(data[,-c(1,2)],1,function(x){
    sum_intensity <- sum(x,na.rm = T)
    return(sum_intensity)
  })
  md_intensity <- data.frame(intensity=sam_view_data,point=names(sam_view_data))
  md_intensity$X <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][1]}))
  md_intensity$Y <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][2]}))
  md_plot <-  ggplot(md_intensity,aes(X,Y,colour =intensity))+geom_point()+
    scale_color_distiller(palette = "Spectral")+xlim(c(loc[1],loc[2]))+ylim(c(loc[1],loc[2]))+
    theme_bw()
  return(md_plot)
  
})

output$total_intensity_after_mz_remove <- renderPlot({
  data <- peakData_remove_background_feature()
  loc <- locs()
  sam_view_data <- apply(data[,-c(1,2)],1,function(x){
    sum_intensity <- sum(x,na.rm = T)
    return(sum_intensity)
  })
  md_intensity <- data.frame(intensity=sam_view_data,point=names(sam_view_data))
  md_intensity$X <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][1]}))
  md_intensity$Y <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][2]}))
  md_plot <-  ggplot(md_intensity,aes(X,Y,colour =intensity))+geom_point()+
    scale_color_distiller(palette = "Spectral")+xlim(c(loc[1],loc[2]))+ylim(c(loc[1],loc[2]))+
    theme_bw()
  return(md_plot)
})


remove_background_mz_intensity <- reactive({
  data <- peakData_remove_background_feature()
  sam_view_data <- apply(data[,-c(1,2)],1,function(x){
    sum_intensity <- sum(x,na.rm = T)
    return(sum_intensity)
  })
  md_intensity <- data.frame(intensity=sam_view_data,point=names(sam_view_data))
  return(md_intensity)
})

observe({
  K <- remove_background_mz_intensity()
  updateSliderInput(session = getDefaultReactiveDomain(), "datapoint_cutoff",
                    min = round(log10(min(K$intensity)),2), 
                    max = round(log10(max(K$intensity)),2), 
                    value = log10(median(K$intensity)))
})


output$total_intensity_hist <- renderPlot({
  md_intensity <- remove_background_mz_intensity()
  cutoff <- 10^input$datapoint_cutoff
  intensity_distribution <- ggplot(md_intensity,aes(log10(intensity)))+geom_histogram()+
    geom_vline(xintercept = log10(cutoff), color = "red", linetype = "dashed", size = 1)+theme_bw()
  return(intensity_distribution)
})


md_intensity <- reactive({
  data <- peakData_remove_background_feature()
  cutoff <- 10^input$datapoint_cutoff
  loc <- locs()
  sam_view_data <- apply(data[,-c(1,2)],1,function(x){
    sum_intensity <- sum(x,na.rm = T)
    return(sum_intensity)
  })
  md_intensity <- data.frame(intensity=sam_view_data,point=names(sam_view_data))
  md_intensity$X <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][1]}))
  md_intensity$Y <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][2]}))
  
  md_intensity$intensity_mark <- "background"
  md_intensity$intensity_mark[md_intensity$intensity > cutoff] <- "tissue"
  return(md_intensity)
})

output$bakcground_tissue_classify <- renderPlot({
  md_intensity <- md_intensity()
  loc <- locs()
  layer2 <- ggplot(md_intensity,aes(X,Y))+geom_point(aes(colour = intensity_mark))+
    theme_bw()+xlim(c(loc[1],loc[2]))+ylim(c(loc[1],loc[2]))
  return(layer2)
})


peakData_remove_background_points <- reactive({
  data <- peakData()
  req(ncol(data)>0)
  md_intensity <- md_intensity()
  md_intensity <- md_intensity[md_intensity$intensity_mark == "tissue",]
  remain <- which(row.names(data) %in% md_intensity$point)
  data <- data[remain,]
  return(data)
})

