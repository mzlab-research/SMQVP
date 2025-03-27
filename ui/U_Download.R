tabItem(tabName = "Download",
        
        fluidRow(#fluidRow2
          h2("Final file download"),
          h4("Processed peak intensity table"),
          p("The Processed Peak Intensity Table provides the intensities of ions in each pixel after preprocessing. 
            The preprocessing steps include the removal of pixels from background regions, elimination of noise ions, and merging of isotopic peaks."),
          p("In this table, the first two columns represent the X and Y coordinates of the pixels. Each subsequent column corresponds to an m/z value,
            with the values indicating the intensity of the respective ion at different pixels."),
          box(#box2
            title = "Download the processed peak intensity table",width = 12,
            tableOutput("peak_table_head"),
            downloadButton("downloadData_peak_table", "Download the final peak table")
          ),
        ),
        fluidRow(#fluidRow2
          h4("Mass ion information"),
          p("In the Mass Ion Information Table, we have listed the relevant information for each ion, including:"),
          p("-miss_ratio: Missing rate"),
          p("-median_intensity: Median intensity"),
          p("-single_iso: Monoisotopic peak mass (If several ions are identified as isotopic peaks, they will have the same monoisotopic peak mass)"),
          p("-neutral_mass: Neutral mass (For ions whose adduct forms are successfully identified)"),
          p("-adduct: Specific adduct form"),
          p("-adduct_mark: Adduct mark (If two ions are different adduct forms of the same metabolite, they will have the same mark)"),
          p("-noise_score: Noise detection score for the ion"),
          box(#box2
            title = "Download the mass feature table",width = 12,
            tableOutput("mz_table_head"),
            downloadButton("downloadData_mz_info", "Download the mass feature table")
          ),
        ),
        fluidRow(#fluidRow2
          h4("Pixel information"),
          p("The Pixel Information Table provides relevant information for each pixel, primarily including:"),
          p("-Missing ratio: The missing rate of all ions in the pixel."),
          p("-Median_intensity: The median intensity of all ions in the pixel."),
          box(#box2
            title = "Download the pixel information table",width = 12,
            tableOutput("point_table_head"),
            downloadButton("downloadData_point_info", "Download the pixel info table")
          )
        )
        
        
)#tabitem




