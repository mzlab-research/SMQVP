tabItem(tabName = "qc2",
                 
        fluidRow(#fluidRow1
          h2("Quality Visualization Point 2: Consistency of Background Regions"),
          p("The consistency of background regions can reflect the stability of the instrument to some extent. 
            We assess the consistency of the background regions from the following two aspects:"),
          p("1.Intensity Distribution of Background Regions"),
          p("A boxplot of the median intensity of all ions within each selected region is generated. 
            This allows for a direct comparison of intensity distribution differences among the various regions."),
          p("2.Correlation Between Regions"),
          p("The correlation between the median intensities of ions across multiple regions is calculated and visualized using a heatmap. 
            Typically, a correlation coefficient above 0.9 indicates a high level of consistency, suggesting that the acquisition process is relatively stable."),
          box(#box2
            title = "Background boxplot:",width = 6,
            plotOutput("background_boxplot")
          ),#box2           
          box(#box2
            title = "Background correlation:",width = 6,
            plotOutput("background_correlation")
          )#box2

        )
        
        
        
)#tabitem




