
peakData <- reactive({
  req((!is.null(input$peakfile))|(input$use_example > 0))
  if (input$use_example > 0) {
    sp <- readRDS("./example_data/peakData.rds")
    sp
  } else if (!is.null(input$peakfile)) {
    file_path <- input$peakfile$datapath
    withProgress(message = 'reading file...', value = 0, {
      incProgress(0.3, detail = "reading file...")
      sp <- read.table(file_path,header = T,sep = "\t",check.names = F)
      sp[sp == 0] <- NA
      row.names(sp) <- paste(sp[,1],sp[,2],sep = "_")
      incProgress(1, detail = "finished reading！")
    })
    sp  
  } else{
    NULL
  }
  

})


output$basic_info <- renderTable({
  data <- peakData()
  req(ncol(data)>0)
  point_number <- nrow(data)
  peak_number <- ncol(data)-2
  number_of_rows <- length(unique(data$X))
  number_of_cols <- length(unique(data$Y))
  data.frame(point_number=point_number,
             number_of_rows=number_of_rows,
             number_of_cols=number_of_cols,
             peak_number=peak_number)
})


locs <- reactive({
  data <- peakData()
  req(ncol(data)>0)
  min_loc <- min(c(data$X,data$Y))
  max_loc <- max(c(data$X,data$Y))
  loc <- c(min_loc,max_loc)
  loc
})


observe({
  data <- peakData()
  req(ncol(data)>0)
  ions <- as.numeric(names(data)[-c(1,2)])
  updateSelectizeInput(session = getDefaultReactiveDomain(), "ion_select", choices = ions,selected = ions[1],server = TRUE)
})



output$specific_ion_plot <- renderPlot({
  req(input$ion_select) 
  data <- peakData()
  req(ncol(data)>0)
  ion <- as.numeric(input$ion_select)
  loc <- locs()
  n <- min(abs(as.numeric(names(data[,-c(1,2)]))-ion))
  w <- which(abs(as.numeric(names(data[,-c(1,2)]))-ion)==n)
  if (n < 0.1) {
    d <- data[,c(1,2,w+2)]
    names(d)[3] <- "intensity"
    p <- ggplot(d,aes(X,Y,colour=log10(intensity)))+geom_point()+scale_color_distiller(palette = "Spectral")+
      ggtitle(names(data)[w+2])+theme_bw()+xlim(c(loc[1],loc[2]))+ylim(c(loc[1],loc[2]))
    p
  } else {
    p <- ggplot() + xlim(0, 10) + ylim(0, 10) +  
      geom_text(aes(x = 5, y = 5, label = paste(ion," is not found. The nearest is: ",names(data)[w],sep = "")),  
                color = "blue", size = 6) + 
      theme_void()  
    p
  }
  
})