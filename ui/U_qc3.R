tabItem(tabName = "qc3",
                 
        fluidRow(#fluidRow1
          h2("Quality Visualization Point 3: Proportion of Ions with Higher Expression in the Tissue Region Compared to the Background Region"),
          p("Based on the previous selection, all pixels in the selected background region were assigned as background group, 
            while that in the tissue region formed region group. The fold change and p-value from the t-test were calculated for all ions between these two groups,
            and the proportion of ions with higher expression in the tissue region compared to the background region was determined."),
          p("Generally, the proportion of ions that are elevated in the tissue regions should be higher. "),
          p("However, it is important to note that the proportion of tissue regions being higher than background regions can vary across different platforms and ionization modes."),
          box(#box1
            title = "Comaparison between the tissue and background area:",width = 6,
            plotOutput("volcano_background_vs_tissue")
          ),#box1
          box(#box2
            title = "Statistics about the ions higer in tissue area:",width = 6,
            tableOutput("number_background_vs_tissue")
          )#box2
                 
        ),#fluidRow1
        
        fluidRow(#fluidRow2
          h2("Process2：remove the data points in the bakcground area:"),
          p("To identify the pixel points in the background region, we first utilize ions with high intensity in the tissue region to create a total intensity distribution map. 
            By setting a total intensity threshold, those above the threshold are classified as tissue regions, while those below the threshold are classified as background regions. 
            It is important to note that we only remove the pixel points in the background region and do not eliminate ions with high expression levels in the background region."),
          box(#box3
            title = "The total intensity distribution of all ions:",width = 6,
            plotOutput("total_intensity_before_mz_remove")
          ),#box3
          box(#box4
            title = "The total intensity distribution of ions higher in tissue area:",width = 6,
            plotOutput("total_intensity_after_mz_remove")
          )#box4
        ),#fluidRow2
        fluidRow(#fluidRow3
          #box(#box5
            p("you can determine whether a pixel is from the background or tissue region based on its total intensity value. 
              Please set an intensity threshold according to the total intensity distribution map, where pixels below this threshold will be classified as background region pixels."),
          #),#box5
          #box(#box6
           # title = "The total intensity distribution after mz removal:",width = 6,
            sliderInput("datapoint_cutoff", 
                        label = "Set the intensity cutoff of the datapoints:",
                        min = 0, 
                        max = 10, 
                        value = c(1), 
                        step = 0.01,
                        width = '500px')
          #)#box6
        ),#fluidRow3
        
        fluidRow(#fluidRow4
          
          box(#box3
            title = "Histogram of total intensity distribution of pixels ",width = 6,
            plotOutput("total_intensity_hist")
          ),#box3
          box(#box4
            title = "The classification of the tissue and background pixels:",width = 6,
            plotOutput("bakcground_tissue_classify")
          )#box4
          
        )#fluidRow4
        
)#tabitem




