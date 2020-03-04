tabItem(tabName = "pcaPlot",
        fluidRow(
          column(12,h3(strong("PCA Plots:")),
                 column(3,
                        wellPanel(
                          h4("Choose PCs to plot:"),
                          numericInput("dim1", "X-axis (PC)", value = 1),
                          numericInput("dim2", "Y-axis (PC)", value = 2)
                        ),
                        wellPanel(
                          h4("Plot Download Options"),
                          numericInput("pcaDownloadHeight", "Plot height (in cm):", value = 14),
                          numericInput("pcaDownloadWidth", "Plot width (in cm):", value = 14),
                          radioButtons("pcaDownloadAs", "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), selected = ".pdf"),
                          downloadButton("downloadPcaPlot", "Download Plot")
                        )
                        #actionButton("jackStraw2","Next Step: Determine statistically significant PCs >>",class = "btn btn-success btn-lg", style = "white-space: normal")
                 ),
                 column(9,
                        column(12,

                               #p("Visualize cells and genes that define the PCA"),
                               #strong(textOutput("numVarGenesFound")),
                               withSpinner(plotOutput(outputId = "pcaPlot", height = 700))
                        )
                 )
          ),
          
          
          conditionalPanel("output.icsPrintAvailable",
                           
                           column(12,
                                  hr(),
                                  h3(strong("ICA Plots:")),
                                  column(3,
                                         wellPanel(
                                           h4("Choose ICs to plot:"),
                                           numericInput("dim1ica", "X-axis (IC)", value = 1),
                                           numericInput("dim2ica", "Y-axis (IC)", value = 2)
                                         ),
                                         #actionButton("jackStraw2","Next Step: Determine statistically significant PCs >>",class = "btn btn-success btn-lg", style = "white-space: normal")
                                         wellPanel(
                                           h4("Plot Download Options"),
                                           numericInput("icaDownloadHeight", "Plot height (in cm):", value = 14),
                                           numericInput("icaDownloadWidth", "Plot width (in cm):", value = 14),
                                           radioButtons("icaDownloadAs", "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), selected = ".pdf"),
                                           downloadButton("downloadIcaPlot", "Download Plot")
                                         )
                                  ),
                                  column(9,
                                         column(12,
                                                
                                                #p("Visualize cells and genes that define the PCA"),
                                                #strong(textOutput("numVarGenesFound")),
                                                withSpinner(plotOutput(outputId = "icaPlot", height = 700))
                                         )
                                  )
                           )
                           )
          
        )
)
