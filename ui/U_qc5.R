tabItem(tabName = "qc5",
                 

          h2("Quality Visualization Point 5: Intensity Distribution of Pixels and Ions"),
          
          h4("Intensity distribution of ions"),
          p("For the intensity distribution map of the ions, we first calculate the median intensity value of a mass ion across all pixel points, 
          and then use these medians to create a histogram of intensity distribution. 
            We also depict the intensity distribution for different m/z values."),
          p("Generally, the intensity distribution of ions should follow a normal distribution, and the highest intensity of ions should exceed 10^5."),
          fluidRow(
          box(#box1
            title = "Hist plot of the ion intensity",width = 6,
            plotOutput("mz_intensity_hist",width = "600px", height = "500px")
          ),#box1
          box(#box2
            title = "Ion intensity distribution",width = 6,
            plotOutput("mz_intensity_spectra",width = "600px", height = "500px")
          )#box2
          ),
        
        h4("Intensity distribution of pixel"),
        p("For the intensity distribution map of the pixel points, 
        we first calculate the dedian of the intensities of all ion peaks at each pixel point, and then visualize the median of the intensities for each pixel point. 
          This visualization allows for an initial assessment of the signal at each pixel."),
        fluidRow(
          box(#box1
            title = "Intensity distribution of pixel",width = 6,
            plotOutput("total_intensity_after_pioints_remove",width = "600px", height = "500px")
          )
        )#fluidRow         
        
)#tabitem




