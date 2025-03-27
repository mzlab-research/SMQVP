tabItem(tabName = "qc7",
                 
        fluidRow(#fluidRow1
          h2("Quality Visualization Point 7: Isotopic Peak Ratio of Ions"),
          p("Isotopic peaks are commonly observed in mass spectrometry data. 
            Typically, biomolecules should exhibit isotopic peaks, though they may go undetected if their intensity is too low. 
            Initially, we use the isotopologues function from MetaboCoreUtils to perform preliminary identification of isotopic peaks based on a specified ppm error. 
            For identified isotopic peaks, we then calculate the Pearson correlation of their spatial intensities to assess the consistency of their spatial distribution. 
            Peaks exceeding the set threshold are considered isotopic peaks. "),
          p("We have established initial thresholds for the two parameters of mass accuracy and the correlation with isotopic peaks, which you can also adjust manually."),
          box(#box3
            title = "Set parameters for isotope peak recognition:",width = 5,
            sliderInput("iso_ppm_setting",              
                        "Set a mass accuracy(unit:ppm):",          
                        min = 0,                 
                        max = 10,               
                        value = 5),
            sliderInput("iso_corr_cutoff",              
                        "Set the threshold for the intensity correlation between isotope peaks:",          
                        min = 0,                 
                        max = 1,               
                        value = 0.6)
            
            #selectInput("isotope_pair_select", "Select an isotope pair for visiualization:", choices = NULL), # 初始化时 choices = NULL
          ),#box3
          
          box(#box2
            title = "The ratio of isotope peaks:",width = 7,
            infoBoxOutput("isotope_ratio_box",width = 10)
            #plotOutput("Isotope_peaks_individual",width = "800px")
          )#box2
                 
        ),#fluidRow1
        
        fluidRow(#fluidRow2
          p("Generally speaking, ions with isotope peaks are often more reliable than those without, as they are less likely to be noise signals. 
            A higher proportion of ions with isotope peaks indicates better data quality."),
          p("In addition, we can use the following graph to observe whether most of the high-abundance ions have isotope peaks."),
          box(#box1
            title = "Isotope peaks distribution:",width = 12,
            plotOutput("Isotope_peaks_distribution")
          )#box1
          # h2("Process4:group the isotope peaks:"),
          # box(
          #   title = "Click to group isotope peaks:",width = 6,
          #   actionButton("group_isotope_peaks", "group_isotope_peaks", class = "btn-primary")
          # ),
          # box(
          #   infoBoxOutput("isotope_remove_number",width = 12)
          # )
          
        )#fluidRow2
        
        
        
)#tabitem
