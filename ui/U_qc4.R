tabItem(tabName = "qc4",
                 
        fluidRow(#fluidRow1
          h2("Quality Visualization Point 4: Noise Ions ratio & Process 3: Remove noise peaks"),
          p("Noise ions are defined as ions that exhibit a completely random spatial distribution. 
          The presence of noise ions can mask the signals of biological ions, thereby interfering with spatial pattern recognition and other analytical processes. 
          We employ quadrat test from the spatstat package to identify ions randomly distributed in space. 
          The p-values from these tests are transformed using -log10 to generate noise scores. 
          A threshold is set for the noise score, with ions below this threshold classified as noise ions. 
          The spatial distribution maps of ions near the threshold are provided to assist in evaluating the appropriateness of the chosen threshold."),

          p("First click the “click to calculate ion noise score” button, then adjust the threshold based on your data performance."),
          box(#box1
            title = "Noise score cutoff:",width = 6,
            sliderInput("noise_cutoff",
                        "Choose a score:",
                        min = 1,
                        max = 100,
                        value = 60),
            actionButton("noise_calculate", "Click to calculate ion noise score"),
            tableOutput("noise_ratio")
          ),#box1
          box(#box2
            title = "Noise_distribution:",width = 6,
            plotOutput("noise_distribution")
          )#box2
        ),#fluidRow1
        
        fluidRow(#fluidRow2
          h2("Typical ions with specific noise score"),
          plotOutput("noise_score_selected",width = "1600px",height = "800px")
        )#fluidRow2
        
        # fluidRow(#fluidRow3
        #   h2("Clustering of the raw and processed data"),
        # 
        #   box(#box2
        #     title = "Set the clustering resulution",
        #     sliderInput(
        #       inputId = "cluster_resolution", 
        #       label = "Choose a number:",
        #       min = 0, 
        #       max = 10, 
        #       value = 0.5,
        #       step = 0.1
        #     )
        #   ),#box2
        #   box(#box3
        #     title = "Click to veiw the clustering plot",
        #     actionButton("start_clustering", "Click to veiw the clustering plot")
        #   )#box3
        # ),#fluidRow3
        # 
        # fluidRow(#fluidRow3
        #   box(#box2
        #     title = "Clustering of the raw data:",width = 6,
        #     plotOutput("raw_clustering",width = "700px", height = "600px")
        #   ),#box2
        #   box(#box2
        #     title = "Clustering of the processed data:",width = 6,
        #     plotOutput("processed_clustering",width = "700px", height = "600px")
        #   )#box2
        # )#fluidRow3
        
        
        
        
)#tabitem






