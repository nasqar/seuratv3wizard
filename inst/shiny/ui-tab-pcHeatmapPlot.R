tabItem(tabName =  "heatmapPlot", 
        fluidRow(
          column(12,h3(strong("PCHeatmap Output:")),
                 column(3,
                        wellPanel(
                          h4("PCs to use:"),
                          numericInput("pcsToUse1", "PC", value = 1),
                          numericInput("pcsToUse2", "To", value = 6),
                          hr(),
                          numericInput("cellsToUse", "Number of cells to use:", value = 500)
                        )
                 ),
                 column(9,
                        column(12,
                               #p("Visualize cells and genes that define the PCA"),
                               #strong(textOutput("numVarGenesFound")),
                               withSpinner(plotOutput(outputId = "heatmapPlot", height = 700))
                        )
                 )
          )
        )
)