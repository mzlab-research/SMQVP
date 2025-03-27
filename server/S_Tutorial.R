

output$downloadData <- downloadHandler(
  filename <- function() {
    paste("neg","txt",sep = ".")
  },
  
  content <- function(file) {
    file.copy("example_data/neg.txt", file)
  }
)