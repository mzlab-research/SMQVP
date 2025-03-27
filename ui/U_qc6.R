tabItem(tabName = "qc6",
                 
        fluidRow(#fluidRow1
          h2("Quality Visualization Point 6: Distribution of Missing Values for Pixels and Ions"),
          h4("Missing value distribution of ions"),
          p("The proportion of missing values for ions is calculated based on the percentage of missing values for each ion across different pixels. "),
          p("We use two types of graphs to display the missing rate of ions: one is the frequency distribution of the missing ratio, 
            and the other is the distribution of the missing rate for ions with different m/z values."),
          p("By visualizing the distribution of missing values for different ions, 
          it is possible to observe the pattern of missingness across ions within various mass-to-charge (m/z) ranges."),
          box(#box1
            title = "Frequency distribution of missing value ratios in ions:",width = 6,
            plotOutput("mz_missing_hist")
          ),#box1
          box(#box2
            title = "Distribution of missing value ratios acorss different m/z values",width = 6,
            plotOutput("mz_missing_distribution")
          )#box2
        ),#fluidRow1
        
        fluidRow(#fluidRow2
          h4("Missing value distribution of pixels"),
          p("The proportion of missing values for pixels refers to the percentage of ions missed at each pixel. 
            Map missing ratio on pixels allows for assessing the variation in missing values across different spatial regions. "),
          box(#box3
            title = "Spatial distribution map of missing value ratios for pixels:",width = 6,
            plotOutput("sample_missing_distribution",width = "600px", height = "500px")
          )#box3 
        )
)#tabitem




