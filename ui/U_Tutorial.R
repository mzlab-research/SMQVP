tabItem(tabName = "Tutorial",
        fluidRow(
          h2("What's SMQVP?"),
          p("SMQVP is the abbreviation for Spatial Metabolomics Quality Visualization and Processing. 
            It is a tool for preprocessing and quality visuaization of spatial metabolomics data."),
          p("In SMQVP, a total of 8 quality control checkpoints and 4 data preprocessing steps are provided. 
            The specific workflow is illustrated in the flowchart below:"),
          tags$img(src = "workflow.png", width = "600px", height = "750px"),
          hr(),
          h2("How to use SMQVP?"),
          p("SMQVP is a graphical interface program written using the Shiny package in R. 
            Users can directly upload data for analysis on our website or set up their own Shiny application locally. 
            The source code for SMQVP can be found at XXXXX."),
          h2("File format and example data:"),
          p("The input file is a feature intensity matrix, which is a txt file containing the signal intensity of MS features. The following figure shows the file format, the first two columns are location, and must be names as 'X' and 'Y', 
                       the rest columns are feature names. Each row represents a point on tissue.Or you can try our example data, click the button below to download test data. "),
          downloadButton("downloadData", label = "Download"),
          p(),
          tags$img(src = "feature_matrix.png",width="800px",height="500px"),
          
          hr(),
          h2("Contact Us"),
          p("If you have any questions, suggestions or remarks, please contact meizhanlong@genomics.cn.")
        )#fluidRow
)#tabitem




