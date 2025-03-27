
background <- reactiveVal(list())  
tissue <- reactiveVal(list())      


selection_data <- reactiveVal(data.frame(
  Group = character(),
  Region = character(),
  X_Min = numeric(),
  X_Max = numeric(),
  Y_Min = numeric(),
  Y_Max = numeric(),
  Point_Count = integer(),
  stringsAsFactors = FALSE
))

peak <- reactive({
  data <- peakData()
  sam_view_data <- apply(data[,-c(1,2)],1,function(x){
    median_intensity <- sum(x,na.rm = T)
    return(median_intensity)
  })
  md_intensity <- data.frame(intensity=sam_view_data,point=names(sam_view_data))
  md_intensity$x <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][1]}))
  md_intensity$y <- as.numeric(lapply(md_intensity$point,function(x){strsplit(x,"_")[[1]][2]}))
  md_intensity <- md_intensity[,c(3,4,1)]
  return(md_intensity)
})


output$scatter_plot <- renderPlotly({
  data <- peak()
  plot_ly(data, x = ~x, y = ~y, color = ~log10(intensity), colors = colorRamp(c("blue", "red")),
          type = 'scatter', mode = 'markers', source = "scatter",marker = list(size = 5)) %>%
    layout(dragmode = "lasso")
})


selected_points <- reactiveVal()
observe({
  data <- peak()
  selected_data <- event_data("plotly_selected", source = "scatter")
  
  if (is.null(selected_data)) {
    selected_points(NULL)
  } else {
    selected_points(data[selected_data$pointNumber + 1, ])
  }
})


observeEvent(input$add_to_background, {
  if (!is.null(selected_points())) {
    new_background <- background()
    new_background <- append(new_background, list(selected_points()))
    names(new_background) <- paste0("background_",c(1:length(new_background)))
    background(new_background)  
    showNotification("Selected area has been added to the background.")
  } else {
    showNotification("No points selected.")
  }
})



observeEvent(input$add_to_tissue, {
  if (!is.null(selected_points())) {
    new_tissue <- tissue()
    new_tissue <- append(new_tissue, list(selected_points()))
    names(new_tissue) <- paste0("tissue_",c(1:length(new_tissue)))
    tissue(new_tissue)  
    showNotification("Selected area has been added to the tissue.")
  } else {
    showNotification("No points selected.")
  }
})

output$selection_table <- renderTable({
  tissue <- tissue()
  background <- background()
  validate(
    need((length(tissue)>0) | length(background)>0,"Please choose an area")
  )
  calculate_min_max <- function(df) {
    x_min <- min(df$x)
    x_max <- max(df$x)
    y_min <- min(df$y)
    y_max <- max(df$y)
    point_number <- nrow(df)
    return(c(x_min, x_max,y_min,y_max,point_number))
  }
  tissue_df <- NULL
  t <- length(tissue)
  if(t>0){
    tissue_results <- lapply(tissue, calculate_min_max)
    tissue_df <- as.data.frame(do.call(rbind, tissue_results))
    colnames(tissue_df) <- c("X_min", "X_max","Y_min","Y_max","point_number")
    tissue_df$region_name <- rownames(tissue_df)
  }
  background_df <- NULL
  b <- length(background)
  if(b>0){
    background_results <- lapply(background, calculate_min_max)
    background_df <- as.data.frame(do.call(rbind, background_results))
    colnames(background_df) <- c("X_min", "X_max","Y_min","Y_max","point_number")
    background_df$region_name <- rownames(background_df)
  }
  result <- rbind(tissue_df,background_df)
  result
})

output$selection_plot <- renderPlot({
  data <- peak()
  tissue <- tissue()
  background <- background()
  data$intensity[is.na(data$intensity)] <- 0.1
  
  base_plot <- ggplot(data, aes(x = x, y = y)) +
    geom_point(aes(color = log10(intensity)), size = 2) +
    scale_color_gradient(low = "blue", high = "red") +
    theme_minimal()+
    theme(
      axis.title.x = element_text(size = 16),   
      axis.title.y = element_text(size = 16),   
      axis.text.x = element_text(size = 14),    
      axis.text.y = element_text(size = 14)     
    )
  
  if(length(tissue)>0){
    combined_tissue <- do.call(rbind, tissue)
    base_plot <- base_plot +
      geom_point(data = combined_tissue, aes(x = x, y = y), 
                 color = "green", size = 2, alpha = 0.15)
  }
  
  if(length(background)>0){
    combined_background <- do.call(rbind, background)
    base_plot <- base_plot +
      geom_point(data = combined_background, aes(x = x, y = y), 
                 color = "yellow", size = 2, alpha = 0.15) 
  }
  
  return(base_plot)
  
  
})


observeEvent(input$clear_selection, {
  tissue(list())  
  background(list())  
  selection_data(data.frame(
    Group = character(),
    Region = character(),
    X_Min = numeric(),
    X_Max = numeric(),
    Y_Min = numeric(),
    Y_Max = numeric(),
    Point_Count = integer(),
    stringsAsFactors = FALSE
  ))
  
  showNotification("All selected regions have been cleared.")
})



tissue_spectrum_reactive <- eventReactive(input$finish_selection, {
  tissue <- tissue()
  data <- peakData()
  validate(
    need(length(tissue)>0,"Please choose an tissue area")
  )
  
  data$mark <- "unlabel"
  for(i in names(tissue)){
    k <- which(row.names(data) %in% row.names(tissue[[i]]))
    data$mark[k] <- i
  }
  
  data <- data[data$mark != "unlabel",]
  spectra_tissue <- data[,-c(1,2)] %>%
    group_by(mark) %>%
    summarise(across(everything(), ~ median(., na.rm = TRUE)))
  spectra_tissue <- as.data.frame(spectra_tissue)
  row.names(spectra_tissue) <- spectra_tissue$mark
  spectra_tissue <- spectra_tissue[,-1]
  spectra_tissue <- as.data.frame(t(spectra_tissue))
  spectra_tissue$mz <- row.names(spectra_tissue)
  spectra_tissue <- spectra_tissue %>%
    pivot_longer(
      cols = -mz,               
      names_to = "area",     
      values_to = "median_intensity"        
    )
  spectra_tissue <- spectra_tissue[!is.na(spectra_tissue$median_intensity),]
  p_tissue <- ggplot(spectra_tissue, aes(x = mz, y = median_intensity)) +
    geom_segment( aes(x=mz, xend=mz, y=0, yend=median_intensity)) +
    facet_wrap(area ~ .,ncol = 1) +           
    labs(title = "Tissue_area", x = "mz", y = "median intensity") +
    theme_light() +theme(axis.text.x = element_blank())                    
  return(p_tissue)
})

output$tissue_spectrum <- renderPlot({
  tissue_spectrum_reactive()
})


background_spectrum_reactive <- eventReactive(input$finish_selection, {
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
  spectra_tissue <- data[,-c(1,2)] %>%
    group_by(mark) %>%
    summarise(across(everything(), ~ median(., na.rm = TRUE)))
  spectra_tissue <- as.data.frame(spectra_tissue)
  row.names(spectra_tissue) <- spectra_tissue$mark
  spectra_tissue <- spectra_tissue[,-1]
  spectra_tissue <- as.data.frame(t(spectra_tissue))
  spectra_tissue$mz <- row.names(spectra_tissue)
  spectra_tissue <- spectra_tissue %>%
    pivot_longer(
      cols = -mz,               
      names_to = "area",      
      values_to = "median_intensity"         
    )
  spectra_tissue <- spectra_tissue[!is.na(spectra_tissue$median_intensity),]
  p_tissue <- ggplot(spectra_tissue, aes(x = mz, y = median_intensity)) +
    geom_segment( aes(x=mz, xend=mz, y=0, yend=median_intensity)) +
    facet_wrap(area ~ .,ncol = 1) +           
    labs(title = "Background_area", x = "mz", y = "median intensity") +
    theme_light() +theme(axis.text.x = element_blank())                   
  return(p_tissue)
})


output$background_spectrum <- renderPlot({
  background_spectrum_reactive()
})



