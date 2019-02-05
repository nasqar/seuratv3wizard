tabItem(tabName = "vlnplot",
         fluidRow(
          #column(12,
           column(12,
                  h3(strong("Vln Plot (Filter Cells)")),
                  p("Note that low.thresholds and high.thresholds are used to define a 'gate'"),
                  p("Select thresholds to filter cells"),
                  column(12,selectizeInput("subsetNames", label="Subset Names",
                                           choices=NULL,
                                           multiple=TRUE)
                  ),
                  uiOutput("vlnPlotsUI"),
                  hr(),
                  actionButton("filterCells","Filter Cells (within thesholds)",class = "button button-3d button-block button-pill button-primary button-large", style = "width: 100%")
                  ),

           column(12,
                  hr(),
                  h3(strong("Feature Scatter Plot")),
                  p("Scatter Plot is typically used to visualize feature-feature relationships.",
                  a(href = "https://satijalab.org/seurat/pbmc3k_tutorial.html", target = "_blank", "See tutorial for examples/details"))
                  ,
                  #withSpinner(plotOutput(outputId = "ScatterPlot"))
                  uiOutput("featureScatterUI")
                  )
         #)
         )

)
