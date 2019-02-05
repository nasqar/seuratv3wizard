tabItem(tabName = "vizPcaPlot", 
        fluidRow(
          column(12,
                 h3(strong("VizPlot Output:")),
                 
                 column(3,
                        wellPanel(
                          h4("PCs to plot:"),
                          numericInput("pcsToPlotStart", "PC", value = 1),
                          numericInput("pcsToPlotEnd", "To", value = 4)
                        )
                        #actionButton("jackStraw1","Next Step: Determine statistically significant PCs >>",class = "btn btn-success btn-lg", style = "white-space: normal")
                 ),
                 column(9,
                        column(12,
                               #p("Visualize cells and genes that define the PCA"),
                               #strong(textOutput("numVarGenesFound")),
                               withSpinner(plotOutput(outputId = "vizPcaPlot", height = 700))
                        )
                 )
          )
        )
        
)