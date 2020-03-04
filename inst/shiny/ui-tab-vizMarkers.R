tabItem(tabName = "vizMarkersTab",
        
        fluidRow(
          
          column(12,
                 
                 
                 h3(strong("Visualizing Marker Expression:")),
                 
                 tabsetPanel(type = "tabs",
                             tabPanel("Vln Plot",
                                      column(12,
                                             p("Note: make sure to find cluster markers first, as the list of genes you can plot will from the output of that step"),
                                             
                                             h3(strong("Vln Plot:")),
                                             column(3,
                                                    wellPanel(
                                                      h4("Genes to plot:"),
                                                      selectizeInput("genesToPlotVln", label="Select Genes",
                                                                     choices=NULL,
                                                                     multiple=TRUE,
                                                                     options = list(
                                                                       placeholder =
                                                                         'Start typing gene name'
                                                                     )
                                                      ),
                                                      checkboxInput("useRaw","Use Raw UMI counts"),
                                                      checkboxInput("ylog","Plot Y-axis on log scale"),
                                                      actionButton("plotVlns","Plot",class = "button button-3d button-block button-pill button-primary", style = "width: 100%")
                                                    ),
                                                    conditionalPanel(
                                                      condition = "input.plotVlns !== 0 && output.VlnMarkersPlot",
                                                      wellPanel(
                                                        h4("Plot Download Options"),
                                                        numericInput("vlnDownloadHeight", "Plot height (in cm):", value = 15),
                                                        numericInput("vlnDownloadWidth", "Plot width (in cm):", value = 30),
                                                        radioButtons("vlnDownloadAs", "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), selected = ".pdf"),
                                                        downloadButton("downloadVlnPlot", "Download Plot")
                                                      )
                                                    )
                                             ),
                                             column(9,
                                                    column(12,
                                                           withSpinner(plotOutput(outputId = "VlnMarkersPlot"))
                                                    )
                                             )
                                      )),
                             
                             tabPanel("Feature Plot",
                                      column(12,
                                             p("Note: make sure to find cluster markers first, as the list of genes you can plot will from the output of that step"),
                                             
                                             h3(strong("Feature Plot:")),
                                             column(3,
                                                    wellPanel(
                                                      h4("Genes to plot:"),
                                                      selectizeInput("genesToFeaturePlot", label="Select Genes",
                                                                     choices=NULL,
                                                                     multiple=TRUE,
                                                                     options = list(
                                                                       placeholder =
                                                                         'Start typing gene name'
                                                                     )
                                                      ),
                                                      selectInput("reducUseFeature","Reduction method to use",choices = c("umap","tsne","pca","ica"), selected = "umap"),
                                                      actionButton("plotFeatureMarkers","Plot",class = "button button-3d button-block button-pill button-primary", style = "width: 100%")
                                                    ),
                                                    conditionalPanel(
                                                      condition = "input.plotFeatureMarkers !== 0 && output.FeatureMarkersPlot",
                                                      wellPanel(
                                                        h4("Plot Download Options"),
                                                        numericInput("featureDownloadHeight", "Plot height (in cm):", value = 15),
                                                        numericInput("featureDownloadWidth", "Plot width (in cm):", value = 30),
                                                        radioButtons("featureDownloadAs", "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), selected = ".pdf"),
                                                        downloadButton("downloadFeaturePlot", "Download Plot")
                                                      )
                                                    )
                                             ),
                                             column(9,
                                                    column(12,
                                                           withSpinner(plotOutput(outputId = "FeatureMarkersPlot"))
                                                    )
                                             )
                                      )
                             )
                 )
          )
        )
)
