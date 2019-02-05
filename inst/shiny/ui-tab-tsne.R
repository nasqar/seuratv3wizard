tabItem(tabName = "tsneTab",

        fluidRow(

          column(12,
                 h3(strong("Run Non-linear dimensional reduction (tSNE)")),
                 hr(),

                 tags$div(class = "BoxArea2",

                 column(12,
                        tags$div(class = "",
                                 h4(strong("Parameters")),
                                 p("Seurat continues to use tSNE as a powerful tool to visualize and explore these datasets. While we no longer advise clustering directly on tSNE components, cells within the graph-based clusters determined above should co-localize on the tSNE plot. This is because the tSNE aims to place cells with similar local neighborhoods in high-dimensional space together in low-dimensional space. As input to the tSNE, we suggest using the same PCs as input to the clustering analysis, although computing the tSNE based on scaled gene expression is also supported using the genes.use argument."),

                                 column(4,numericInput("tsnePCDim1", "Dimensions(PC) To Use (1):", value = 1)),
                                 column(4,numericInput("tsnePCDim2", "Dimensions(PC) To Use (2):", value = 10)),
                                 column(4,numericInput("tsnePerplexity", "Perplexity:", value = 30)),

                                 p("Once running the reduction is complete, you can also view/download cells in each cluster"),
                                 tags$div(class = "clearBoth")
                                 )

                 ),
                 hr(),
                 column(12,
                        conditionalPanel("output.tsnePlotAvailable",

                                         tabsetPanel(type = "tabs",
                                                     tabPanel("TSNE Plot",

                                                              column(12,
                                                                     h4(strong("TSNE Plot")),
                                                                     withSpinner(plotOutput(outputId = "tsnePlot"))
                                                              ),
                                                              tags$div(class = "clearBoth")
                                                     ),
                                                     tabPanel("Find Cells in Clusters",
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
                                         ),


                                         hr(),
                                         p(
                                           actionButton(
                                             "nextClusterMarkers",
                                             "Next Step: Find Cluster Markers",
                                             class = "button button-3d button-pill button-caution"
                                           ),
                                           actionButton(
                                             "nextDownload",
                                             "Download Seurat Object",
                                             class = "button button-3d button-pill",
                                             icon = icon("download")
                                           )
                                         )

                        )

                 )
                 
                 ,
                 tags$div(class = "clearBoth")


                        ),
                 column(12,
                        actionButton("runTSNE","Run TSNE Reduction",class = "button button-3d button-block button-pill button-primary button-large", style = "width: 100%"))
                 ,
                 tags$div(class = "clearBoth")
        )
          )
)
