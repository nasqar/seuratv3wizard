tabItem(tabName = "runPcaTab",
         fluidRow(
           column(12,
                  h3(strong("Perform linear dimensional reduction")),
                  #hr(),
                  wellPanel(
             
           column(12,
                  tags$div(class = "BoxArea2",
                           h4(strong("Compute PCA")),
                           column(8,
                                  p("Next we perform PCA on the scaled data. By default, the variable features are used as input, but can be defined using features."),
                                  p("We have typically found that running dimensionality reduction on highly variable genes can improve performance."),
                                  p("However, with UMI data - particularly after regressing out technical variables, we often see that PCA returns similar (albeit slower) results when run on much larger subsets of genes, including the whole transcriptome.")
                                  )
                           ,
                           column(4,
                                  wellPanel(
                                    numericInput("numPCs", "Number of PCs to show", value = 5),
                                    numericInput("numGenes", "Number of Genes to show", value = 5)
                                  )
                                  ),
                           conditionalPanel("output.pcsPrintAvailable",
                                            column(12,
                                                   h4(style = "min-height: 60px;", strong("PCA Print Output"),
                                                      actionButton("vizPca", "Visualize PCA", class = "button button-3d button-block button-pill button-action pull-right")
                                                   ),
                                                   tags$div(class = "BoxArea",htmlOutput("pcsPrint"), tags$div(class = "clearBoth"))
                                            )
                           ),
                           column(12,
                                  hr(),
                                  h4(strong("Compute ICA (Optional)")),
                                  checkboxInput("runIca","Run Independent Component Analysis (ICA)")
                                  ),
                           conditionalPanel("output.icsPrintAvailable",
                                            #hr(),
                                            column(12,
                                                   h4(style = "min-height: 60px;", strong("ICA Print Output")),
                                                   tags$div(class = "BoxArea",htmlOutput("icsPrint"), tags$div(class = "clearBoth"))
                                                   )
                                            
                           ),
                           tags$div(class = "clearBoth")

                           )

           ),
           hr(),
           column(12,
                  actionButton("runPca","Compute Linear Reduction",class = "button button-3d button-block button-pill button-primary button-large",style = "width: 100%"))
           ,
           tags$div(class = "clearBoth")


                  )
         )
           )
)
