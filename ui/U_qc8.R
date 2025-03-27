tabItem(tabName = "qc8",
                 
        fluidRow(#fluidRow1
          h2("Quality Visualization Point 8: Ratio of Adduct Ions"),
          p("Accurate identification of adduct forms of ions in mass spectrometry data is crucial for subsequent identification processes. 
            In both positive and negative ion modes, we recommend common adduct forms, though users could add or remove adduct types based on their own understanding. 
            We search for ion pairs that match the mass difference corresponding to the specified adduct forms across all ions. 
            The Pearson correlation of the spatial intensities of these ion pairs is then calculated, and those exceeding the correlation threshold are assigned as adduct ions."),
          p("In our workflow, we have set default adduct forms for both positive and negative ion modes. You can modify these adduct ions based on your understanding. 
            You can also adjust the threshold for mass accuracy and correlation below."),
          box(#box1
            title = "Choose adduct ions:",width = 4,
            selectInput("adduct_ion", "Please choose adduct ions:", choices = NULL, multiple = TRUE),
            sliderInput("add_ppm_setting",              
                        "Set a mass accuracy(unit:ppm):",          
                        min = 0,                 
                        max = 10,               
                        value = 5),
            sliderInput("add_corr_cutoff",              
                        "Set the threshold for the intensity correlation between isotope peaks:",          
                        min = 0,                 
                        max = 1,               
                        value = 0.6),
            infoBoxOutput("adduct_ratio_box",width = 10)
          ),#box1
          box(#box2
            title = "Statistics about adduct ions:",width = 8,
            plotOutput("adduct_peaks_count")
          )#box2
                 
        )#fluidRow1
        
        
)#tabitem




