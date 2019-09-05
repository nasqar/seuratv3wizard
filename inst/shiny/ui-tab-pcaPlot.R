tabItem(tabName = "pcaPlot",
        fluidRow(
          column(12,h3(strong("PCAPlot Output:")),
                 column(3,
                        wellPanel(
                          h4("Choose PCs to plot:"),
                          numericInput("dim1", "X-axis (PC)", value = 1),
                          numericInput("dim2", "Y-axis (PC)", value = 2)
                        ),
                        #actionButton("jackStraw2","Next Step: Determine statistically significant PCs >>",class = "btn btn-success btn-lg", style = "white-space: normal")
                        wellPanel(
                          h4("Plot Download Options"),
                          numericInput("pcaDownloadHeight", "Plot height (in cm):", value = 14),
                          numericInput("pcaDownloadWidth", "Plot width (in cm):", value = 14),
                          radioButtons("pcaDownloadAs", "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), selected = ".pdf"),
                          downloadButton("downloadPcaPlot", "Download Plot")
                        )
                 ),
                 column(9,
                        column(12,
                               
                               #p("Visualize cells and genes that define the PCA"),
                               #strong(textOutput("numVarGenesFound")),
                               withSpinner(plotOutput(outputId = "pcaPlot", height = 700))
                        )
                 )
          )
        )
)

