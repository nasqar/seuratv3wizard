tabItem(tabName = "umapTab",
        
        fluidRow(
          
          column(12,
                 h3(strong("Non-linear dimensional reduction (UMAP)")),
                 hr(),
                 
                 tags$div(class = "BoxArea2",
                          
                          column(12,
                                 tags$div(class = "",
                                          h4(strong("Parameters")),
                                          p("This uses SCTransform, an R package for normalization and variance stabilization of single-cell RNA-seq data using regularized negative binomial regression"),
                                          p("Uniform Manifold Approximation and Projection (UMAP) is a dimension reduction technique that can be used for visualisation similarly to t-SNE, but also for general non-linear dimension reduction. "),
                                          
                                          # column(6,numericInput("umapPCDim1", "Dimensions(PC) To Use (1):", value = 1)),
                                          # column(6,numericInput("umapPCDim2", "Dimensions(PC) To Use (2):", value = 10)),
                                          
                                          p("Once running the reduction is complete, you can also view/download cells in each cluster"),
                                          tags$div(class = "clearBoth")
                                 )
                                 
                          ),
                          hr(),
                          column(12,
                                 conditionalPanel("output.umapPlotAvailable",
                                                  
                                                  tabsetPanel(type = "tabs",
                                                              tabPanel("UMAP Plot",
                                                                       
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
                                                                              br(),br(),
                                                                              p(
                                                                                actionButton(
                                                                                  "nextClusterMarkersUmap",
                                                                                  "Next Step: Find Cluster Markers",
                                                                                  class = "button button-3d button-pill button-caution"
                                                                                ),
                                                                                hr(),
                                                                                actionButton(
                                                                                  "nextDownloadUmap",
                                                                                  "Download Seurat Object",
                                                                                  class = "button button-3d button-pill",
                                                                                  icon = icon("download")
                                                                                )
                                                                              )
                                                                              
                                                                       ),
                                                                       tags$div(class = "clearBoth")
                                                              )
                                                              # ,
                                                              # tabPanel("Find Cells in Clusters",
                                                              #          column(12,
                                                              #                 wellPanel(
                                                              #                   h4("Find Cells in Clusters:"),
                                                              #                   column(6,selectInput("clusterNumCells", "Cluster Num",
                                                              #                                        choices = NULL, selected = 1)),
                                                              #                   div(style = "clear:both;"),
                                                              #                   actionButton("findCellsInCluster","Find Cells in Clusters",class = "button button-3d button-block button-primary")
                                                              #                 )
                                                              #                 ,
                                                              #                 conditionalPanel("output.clustercellsavailable",
                                                              #                                  downloadButton('downloadClusterCells','Save Results as CSV File', class = "btn btn-primary"),
                                                              #                                  withSpinner(dataTableOutput('cellsInClusters'))
                                                              #                 )
                                                              # 
                                                              #          ),
                                                              #          tags$div(class = "clearBoth")
                                                              # )
                                                  ),
                                                  
                                                  
                                                  hr()
                                                  
                                                  
                                                  
                                 )
                                 
                          )
                          
                          ,
                          tags$div(class = "clearBoth")
                          
                          
                 ),
                 column(12,
                        actionButton("runUmap","Run UMAP Reduction",class = "button button-3d button-block button-pill button-primary button-large", style = "width: 100%")
                 )
                 ,
                 tags$div(class = "clearBoth")
          )
        )
)
