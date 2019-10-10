tabItem(tabName = "nonLinReductTab",
        fluidRow(
          column(12,
                 h3(strong("Run Non-linear dimensional reduction")),
                 
                 wellPanel(
                   column(12,
                          radioButtons("reductionMethod", label = "Choose reduction method to proceed with:",
                                       choices = list("tsne" = "tsne", "umap" = "umap"), selected = "umap")),
                   tags$div(class = "clearBoth"),
                   style = "background-color: #1e9ddc40;"
                 ),
                 
                 hr(),
                 
                 tags$div(class = "BoxArea2",
                                      
                                      conditionalPanel("input.reductionMethod == 'tsne'",
                                                       column(12,
                                                              tags$div(class = "",
                                                                       h4(strong("Parameters")),
                                                                       p("Seurat continues to use tSNE as a powerful tool to visualize and explore these datasets. While we no longer advise clustering directly on tSNE components, cells within the graph-based clusters determined above should co-localize on the tSNE plot. This is because the tSNE aims to place cells with similar local neighborhoods in high-dimensional space together in low-dimensional space. As input to the tSNE, we suggest using the same PCs as input to the clustering analysis, although computing the tSNE based on scaled gene expression is also supported using the genes.use argument."),
                                                                       column(6,selectizeInput("tsnePCDim", "Choose Dimensions(PC) To Use", multiple = TRUE, choices = c(1:20),selected = c(1,2,3,4,5))),
                                                                       column(6,numericInput("tsnePerplexity", "Perplexity:", value = 30)),
                                                                       tags$div(class = "clearBoth")
                                                              )

                                                       ),
                                                       conditionalPanel("output.tsnePlotAvailable",
                                                       hr(),
                                                                column(8,
                                                                       h4(strong("TSNE Plot")),
                                                                       column(12,
                                                                              withSpinner(plotOutput(outputId = "tsnePlot"))
                                                                       )
                                                                ),
                                                                column(4,
                                                                       radioButtons("tsneGroupBy", label = "Color by:",
                                                                                    choices = list("Clusters" = "ident", "Samples" = "orig.ident"),
                                                                                    selected = "ident"),
                                                                       hr(),
                                                                       h4(strong("Plot Download Options")),
                                                                       numericInput("tsneDownloadHeight", "Plot height (in cm):", value = 30),
                                                                       numericInput("tsneDownloadWidth", "Plot width (in cm):", value = 30),
                                                                       radioButtons("tsneDownloadAs", "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), selected = ".pdf"),
                                                                       downloadButton("downloadTsne", "Download Plot"),
                                                                       br(),br()
                                                                )
                                      ),
                                                       column(12,
                                                              actionButton("runTSNE","Run TSNE Reduction",class = "button button-3d button-block button-pill button-primary button-large", style = "width: 100%")
                                                       ),
                                      conditionalPanel("output.tsnePlotAvailable",
                                      column(12,
                                             hr(),
                                             wellPanel(
                                               
                                               p("Once running the reduction is complete, you can also view/download cells in each cluster"),
                                               column(12,
                                                      wellPanel(
                                                        h4("Find Cells in Clusters:"),
                                                        column(6,selectInput("clusterNumCells", "Cluster Num",
                                                                             choices = NULL, selected = 1)),
                                                        div(style = "clear:both;"),
                                                        actionButton("findCellsInCluster","Find Cells in Clusters",class = "button button-3d button-block button-primary")
                                                      )
                                                      ,
                                                      conditionalPanel("output.clustercellsavailable",
                                                                       downloadButton('downloadClusterCells','Save Results as CSV File', class = "btn btn-primary"),
                                                                       withSpinner(dataTableOutput('cellsInClusters'))
                                                      )
                                                      
                                               ),
                                               tags$div(class = "clearBoth")
                                             )
                                      )
                                      ),
                                      
                                      
                                                       tags$div(class = "clearBoth")
                                      ),
                                      conditionalPanel("input.reductionMethod == 'umap'",

                                                       conditionalPanel("output.umapPlotAvailable",
                                                                column(8,
                                                                       h4(strong("UMAP Plot")),
                                                                       column(12,
                                                                              withSpinner(plotOutput(outputId = "umapPlot"))
                                                                       )
                                                                ),
                                                                column(4,
                                                                       radioButtons("umapGroupBy", label = "Color by:",
                                                                                    choices = list("Clusters" = "ident", "Samples" = "orig.ident"),
                                                                                    selected = "ident"),
                                                                       hr(),
                                                                       h4(strong("Plot Download Options")),
                                                                       numericInput("UmapDownloadHeight", "Plot height (in cm):", value = 30),
                                                                       numericInput("UmapDownloadWidth", "Plot width (in cm):", value = 30),
                                                                       radioButtons("UmapDownloadAs", "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), selected = ".pdf"),
                                                                       downloadButton("downloadUmap", "Download Plot"),
                                                                       br(),br()

                                                                )
                                                       ),
                                                       column(12,
                                                              actionButton("runUmap","Show UMAP Reduction",class = "button button-3d button-block button-pill button-primary button-large", style = "width: 100%")
                                                       ),
                                                       tags$div(class = "clearBoth")

                          )
                          ,
                          hr(),
                          conditionalPanel("output.umapPlotAvailable || output.tsnePlotAvailable",
                            p(
                              actionButton(
                                "nextClusterMarkers",
                                "Next Step: Find Cluster Markers",
                                class = "button button-3d button-pill button-caution"
                              ),
                              hr(),
                              actionButton(
                                "nextDownload",
                                "Download Seurat Object",
                                class = "button button-3d button-pill",
                                icon = icon("download")
                              )
                            )
                          )
                          ,
                          tags$div(class = "clearBoth")
                 )
          )
        )
)
