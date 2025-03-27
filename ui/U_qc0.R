tabItem(tabName = "qc0",
                 
        fluidRow(
          h2("File upload"),
          p(""),
          #文件上传-----------------------
          box(#box1
            title = "Upload your file or download our demo data in Tutorial panel",width = 4,
            fileInput("peakfile", "Upload a feature matrix file",
                      accept = ".txt"),
            radioButtons("mode_select", "Choose a data acquisition mode:",
                         choices = list("Negative Mode" = "neg", "Positive Mode" = "pos"),
                         selected = "pos")
          ),#box1
          #选择离子模式-------------------
          box(#box2
            title = "Or try our example data",width = 6,
            actionButton("use_example", "Click to use our example data")
          )#box2
        ),#fluidRow
        fluidRow(
          h2("Visiualization of ion intensity distribution:"),
          p("When initially analyzing a dataset, it is advisable to examine the spatial distribution of certain specific ions."),
          p("For animal tissues, the following ions are recommended:"),
          p("In positive ion mode, it is recommended to investigate the spatial distribution of the ion at m/z 104.1069 (choline). "),
          p("In negative ion mode, the ion at m/z 89.0229 (lactate) could be considered for visualization."),
          box(#box3
            title = "Basic information about the input data",
            tableOutput("basic_info"),
            selectizeInput("ion_select", "select an ion for visualization:", choices = NULL,selected = NULL,options = list(maxOptions = 5000))
          ),#box3
          box(#box4
            title = "Ion distribution visualization",
            plotOutput("specific_ion_plot",width = "700px", height = "600px")
          )#box4
        )#fluidRow
        
        
        
)#tabitem




