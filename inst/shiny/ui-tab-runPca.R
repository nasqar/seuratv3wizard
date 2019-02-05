tabItem(tabName = "runPcaTab",
         fluidRow(
           column(12,
                  h3(strong("Scale Data and Perform PCA")),
                  #hr(),
                  wellPanel(
             column(12,
                    tags$div(class = "BoxArea2",
                             h4(strong("Scaling the data and removing unwanted sources of variation")),
                             p("Your single cell dataset likely contains ‘uninteresting’ sources of variation. This could include not only technical noise, but batch effects, or even biological sources of variation (cell cycle stage). As suggested in Buettner et al, NBT, 2015, regressing these signals out of the analysis can improve downstream dimensionality reduction and clustering. To mitigate the effect of these signals, Seurat constructs linear models to predict gene expression based on user-defined variables. The scaled z-scored residuals of these models are stored in the scale.data slot, and are used for dimensionality reduction and clustering."),
                             p("We can regress out cell-cell variation in gene expression driven by batch (if applicable), cell alignment rate (as provided by Drop-seq tools for Drop-seq data), the number of detected molecules, and mitochondrial gene expression. Refer to tutorial to see an example  of regressing on the number of detected molecules per cell as well as the percentage mitochondrial gene content for post-mitotic blood cells."),
                             selectizeInput("varsToRegress", label="Variables to regress out",
                                            choices=NULL,
                                            multiple=TRUE),
                             tags$div(class = "clearBoth")
                             )
           )
           ,

           hr(),

           column(12,
                  tags$div(class = "BoxArea2",
                           h4(strong("Perform linear dimensional reduction")),
                           p("Next we perform PCA on the scaled data. By default, the variable features are used as input, but can be defined using features."),
                           p("We have typically found that running dimensionality reduction on highly variable genes can improve performance."),
                           p("However, with UMI data - particularly after regressing out technical variables, we often see that PCA returns similar (albeit slower) results when run on much larger subsets of genes, including the whole transcriptome."),
                           column(6,numericInput("numPCs", "Number of PCs to show", value = 5)),
                           column(6,numericInput("numGenes", "Number of Genes to show", value = 5)),
                           tags$div(class = "clearBoth"),
                           conditionalPanel("output.pcsPrintAvailable",
                                              h4(style = "min-height: 60px;", strong("PCA Print Output"),
                                                 actionButton("vizPca", "Visualize PCA", class = "button button-3d button-block button-pill button-action pull-right")
                                              )
                                            ,
                                            tags$div(class = "BoxArea",htmlOutput("pcsPrint"), tags$div(class = "clearBoth")))

                           )

           ),
           hr(),
           column(12,
                  actionButton("runPca","Scale and Perform PCA",class = "button button-3d button-block button-pill button-primary button-large",style = "width: 100%"))
           ,
           tags$div(class = "clearBoth")


                  )
         )
           )
)
