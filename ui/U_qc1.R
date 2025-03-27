tabItem(tabName = "qc1",
        
        fluidRow(#fluidRow1
          h2("Process1: Set the tissue and the background area"),
          p("The first quality control step for spatial metabolomics data is to examine the consistency of background regions. 
            Therefore, it is necessary to first select some pixel points and assign them as the background regions."),
          p("The left figure below shows the median intensity distribution of the pixels, which is an interactive visualization. 
            You can use the lasso tool or other shapes to select regions on the figure."),
          p("Methods for selecting regions:"),
          p("1. Use the mouse to select a region on the visualization."),
          p("2. Click on 'add as background' or 'add as tissue' to define the selected region as either a background or a tissue region."),
          p("3. The defined regions will be displayed on the right side of the interface."),
          p("Recommendations:"),
          p("- It is suggested to define at least 3–5 background regions and 3–5 tissue regions."),
          p("- After completing the region definitions, click on 'finish selection' to proceed to the results of quality visualizaion point 1."),
          box(#box3
            title = "Select an area",width = 6,
            plotlyOutput("scatter_plot",width = "700px", height = "600px")
          ),#box3
          box(#box4
            title = "Visualization of the selected areas:",width = 6,
            plotOutput("selection_plot",width = "700px", height = "600px")
          )
          
        ),#fluidRow1
        
        fluidRow(#fluidRow2
          box(#box4
            title = "Set the selected area as tissue or background:",width = 6,
            actionButton("add_to_background", "Add as Background"),
            p(),
            actionButton("add_to_tissue", "Add as Tissue"),
            p(),
            actionButton("clear_selection", "Clear selection"),
            p(),
            actionButton("finish_selection", "Finish selection")
          ),#box4
          box(#box3
            title = "Information of the selected areas",width = 6,
            tableOutput("selection_table")
          )#box3
          
        ),#fluidRow2
        
        fluidRow(#fluidRow3
          h2("Quality Visualization Point 1: Examination of Spectra in Background and Tissue Regions"),
          p("For each selected region, we calculate the median intensity of each ions across the pixels within that region, 
          thereby generating a spectrum. In this spectrum, the x-axis represents the *m/z* values, 
          while the y-axis represents the median intensity of the corresponding ions. 
            The quality control should be conducted from the following  aspects:"),
          p("1. Generally, the spectra of different background regions should be similar to each other and should distinctly differ from that of the tissue region."),
          p("2. Additionally, the spectra can be inspected for the presence of polymer peaks. "),
          p("Note: Please click “Finish Selection” to confirm the selected areas before comparing the spectra of the tissue and background regions."),
          
          box(#box3
            title = "The spectrum from the background area:",width = 6,
            plotOutput("background_spectrum",width = "600px", height = "800px")
          ),#box3
          box(#box4
            title = "The spectrum from the tissue area:",width = 6,
            plotOutput("tissue_spectrum",width = "600px", height = "800px")
          )#box4
          
        )#fluidRow3
        
)#tabitem




