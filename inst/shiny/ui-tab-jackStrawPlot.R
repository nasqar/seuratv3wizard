tabItem(tabName =  "jackStrawPlot",
        fluidRow(
          column(12,
                 h3(strong("Determine statistically significant PCs:")),
                 hr(),
                 # column(3,
                 #        wellPanel(
                 #          numericInput("numReplicates", "Number of Replicates", value = 100),
                 #          hr(),
                 #          h4("PCs to use:"),
                 #          numericInput("jsPcsToPlot1", "PC", value = 1),
                 #          numericInput("jsPcsToPlot2", "To", value = 12)
                 #        )),
                 column(12,
                        column(12,
                               #actionButton("jackStraw","Next Step: Determine statistically significant PCs >>",class = "btn btn-success btn-lg"),
                               
                               p("To overcome the extensive technical noise in any single gene for scRNA-seq data, Seurat clusters cells based on their PCA scores, with each PC essentially representing a ‘metagene’ that combines information across a correlated gene set. Determining how many PCs to include downstream is therefore an important step."),
                               
                               p("PC selection – identifying the true dimensionality of a dataset – is an important step for Seurat, but can be challenging/uncertain for the user. We therefore suggest these three approaches to consider."),
                               p(" The first is more supervised, exploring PCs to determine relevant sources of heterogeneity, and could be used in conjunction with GSEA for example."),
                               p("The second implements a statistical test based on a random null model, but is time-consuming for large datasets, and may not return a clear PC cutoff."),
                               p("The third is a heuristic that is commonly used, and can be calculated instantly."),
                               hr(),
                               
                               tags$div(
                                 class = "BoxArea2",
                                 h4(strong("1) PC Elbow Plot (quick)")),
                                 
                                 p("A more ad hoc method for determining which PCs to use is to look at a plot of the standard deviations of the principle components and draw your cutoff where there is a clear elbow in the graph. This can be done with PCElbowPlot."),
                                 
                                 h4(style = "min-height: 60px;",
                                    actionButton("doElbowPlot","Show Elbow Plot",class = "button button-3d button-block button-pill button-action")
                                 ),
                                 conditionalPanel("input.doElbowPlot > 0",
                                                  fluidRow(
                                                    column(10,
                                                           withSpinner(plotOutput(outputId = "pcElbowPlot")),
                                                           hr(),
                                                           p(
                                                             actionButton(
                                                               "nextClusterCells",
                                                               "Next Step: Cluster Cells",
                                                               class = "button button-3d button-pill button-caution"
                                                             )
                                                           )
                                                    ),
                                                    column(2,
                                                           conditionalPanel(
                                                             condition = "input.doElbowPlot !== 0 && output.pcElbowPlot",
                                                             wellPanel(
                                                               h4("Plot Download Options"),
                                                               numericInput("elbowDownloadHeight", "Plot height (in cm):", value = 15),
                                                               numericInput("elbowDownloadWidth", "Plot width (in cm):", value = 30),
                                                               radioButtons("elbowDownloadAs", "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), selected = ".pdf"),
                                                               downloadButton("downloadElbowPlot", "Download Plot")
                                                             )
                                                           )
                                                    )
                                                  )
                                 )
                               ),
                               tags$div(
                                 class = "BoxArea2",
                                 h4(strong("2) JackStraw (slow) OPTIONAL")),
                                 column(8,
                                        p("In Macosko et al, we implemented a resampling test inspired by the jackStraw procedure. We randomly permute a subset of the data (1% by default) and rerun PCA, constructing a ‘null distribution’ of gene scores, and repeat this procedure. We identify ‘significant’ PCs as those who have a strong enrichment of low p-value genes."),
                                        p("The JackStrawPlot function provides a visualization tool for comparing the distribution of p-values for each PC with a uniform distribution (dashed line). ‘Significant’ PCs will show a strong enrichment of genes with low p-values (solid curve above the dashed line)."),
                                        p(strong(
                                          span(style = "color:red;",
                                               "NOTE: this process can take a long time for big datasets. It can take ~10 minutes for the example PBMC data."
                                          )
                                          
                                        ))
                                 ),
                                 column(4,
                                        wellPanel(
                                          numericInput("numReplicates", "Number of Replicates", value = 100),
                                          hr(),
                                          h4(strong("PCs to use:")),
                                          numericInput("jsPcsToPlot1", "PC", value = 1, max = 20),
                                          numericInput("jsPcsToPlot2", "To", value = 12, max = 20),
                                          actionButton("doJackStraw","Perform JackStraw",class = "button button-3d button-block button-pill button-action", style = "width:100%;")
                                          
                                        )  
                                        
                                 ),
                                 tags$div(class = "clearBoth")
                                 ,
                                 conditionalPanel("output.jackStrawPlotAvailable",
                                                  hr(),
                                                  fluidRow(
                                                    column(10,
                                                           withSpinner(plotOutput(outputId = "jackStrawPlot")),
                                                           hr(),
                                                           p(
                                                             actionButton(
                                                               "nextClusterCells1",
                                                               "Next Step: Cluster Cells",
                                                               class = "button button-3d button-pill button-caution"
                                                             )
                                                           )
                                                    ),
                                                    column(2,
                                                           conditionalPanel(
                                                             condition = "input.doJackStraw !== 0 && output.jackStrawPlot",
                                                             wellPanel(
                                                               h4("Plot Download Options"),
                                                               numericInput("jackStrawDownloadHeight", "Plot height (in cm):", value = 15),
                                                               numericInput("jackStrawDownloadWidth", "Plot width (in cm):", value = 30),
                                                               radioButtons("jackStrawDownloadAs", "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), selected = ".pdf"),
                                                               downloadButton("downloadJackStrawPlot", "Download Plot")
                                                             )
                                                           )
                                                    )
                                                  )
                                 )
                               )
                               ,
                               hr()
                               #actionButton("jackStraw","Determine statistically significant PCs",class = "button button-3d button-block button-pill button-primary button-large align-right",style = "width: 100%")
                               
                        )
                 )
          )
        )
        
)
