tabItem(tabName = "clusterCells",
        fluidRow(
          column(12,
                 h3(strong("Cluster Cells")),
                 #hr(),
                 wellPanel(
                   column(12,
                          tags$div(class = "BoxArea2",
                                   p("Seurat now includes an graph-based clustering approach. Importantly, the distance metric which drives the clustering analysis (based on previously identified PCs) remains the same. However, our approach to partioning the cellular distance matrix into clusters has dramatically improved. Our approach was heavily inspired by recent manuscripts which applied graph-based clustering approaches to scRNA-seq data [SNN-Cliq, Xu and Su, Bioinformatics, 2015] and CyTOF data [PhenoGraph, Levine et al., Cell, 2015]."),
                                   p("Briefly, these methods embed cells in a graph structure - for example a K-nearest neighbor (KNN) graph, with edges drawn between cells with similar gene expression patterns, and then attempt to partition this graph into highly interconnected ‘quasi-cliques’ or ‘communities’. As in PhenoGraph, we first construct a KNN graph based on the euclidean distance in PCA space, and refine the edge weights between any two cells based on the shared overlap in their local neighborhoods (Jaccard distance). To cluster the cells, we apply modularity optimization techniques [SLM, Blondel et al., Journal of Statistical Mechanics], to iteratively group cells together, with the goal of optimizing the standard modularity function."),

                                   tags$div(class = "clearBoth")
                          )
                   )
                   ,

                   hr(),

                   column(12,
                          tags$div(class = "BoxArea2",
                                   h4(strong("FindClusters paramters")),
                                   p("The FindClusters function implements the procedure, and contains a resolution parameter that sets the ‘granularity’ of the downstream clustering, with increased values leading to a greater number of clusters. We find that setting this parameter between 0.6-1.2 typically returns good results for single cell datasets of around 3K cells. Optimal resolution often increases for larger datasets. The clusters are saved in the object@ident slot."),
                                   column(12,
                                          column(6,selectInput("reducType", "Reduction Type",
                                                               choices = list("pca"), selected = "pca")),
                                          column(6,numericInput("clustResolution", "Resolution (Granularity)", value = 0.6))
                                          ),
                                   column(12,
                                          column(6,selectizeInput("clustPCDim", "Choose Dimensions(PC) To Use", multiple = TRUE, choices = c(1:20),selected = c(1,2,3,4,5)))
                                          ),
                                   conditionalPanel("output.clustParamsAvailable",
                                                    h4(strong("Clustering Algorithm Output:")
                                                    ),
                                                    tags$div(class = "BoxArea",htmlOutput("clustParamsPrint"), tags$div(class = "clearBoth")),
                                                    hr(),
                                                    p(
                                                      actionButton(
                                                        "nextRunTsne",
                                                        "Next Step:  Non-linear Reduction",
                                                        class = "button button-3d button-pill button-caution"
                                                      )
                                                    )
                                                    ),
                                   tags$div(class = "clearBoth")

                          )

                   ),
                   hr(),
                   column(12,
                          actionButton("clusterCells","Cluster Cells",class = "button button-3d button-block button-pill button-primary button-large",style = "width: 100%"))
                   ,
                   tags$div(class = "clearBoth")


                 )
          )
        )
)
