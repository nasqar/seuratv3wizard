tabItem(tabName = "filterNormSelectTab",

        fluidRow(column(
          12,
          h3(strong("Normalize, Select Var. Features, Scale Data")),
          
          wellPanel(
            column(12,
                   radioButtons("sctransformOption", label = "Choose which method to proceed with:",
                                choices = list("Normalize / Detect Var Features / Scale Data (Default)" = "defaultPath", 
                                               "SCTransform: using regularized negative binomial regression" = "sctransformPath"), 
                                selected = "defaultPath")),
            tags$div(class = "clearBoth"),
            style = "background-color: #1e9ddc40;"
          ),
          
          conditionalPanel("input.sctransformOption == 'sctransformPath'",
                           hr(),
                           wellPanel(
                             column(
                               12,
                               tags$div(
                                 class = "BoxArea2",
                                 h4(strong("SCTransform function")),
                                 p(
                                   "Use this function as an alternative to the NormalizeData, FindVariableFeatures, ScaleData workflow. Results are saved in a new assay called SCT with counts being (corrected) counts, data being log1p(counts), scale.data being pearson residuals; sctransform::vst intermediate results are saved in misc slot of new assay."),
                                 p("We can regress out cell-cell variation in gene expression driven by batch (if applicable), cell alignment rate (as provided by Drop-seq tools for Drop-seq data), the number of detected molecules, and mitochondrial gene expression. Refer to tutorial to see an example  of regressing on the number of detected molecules per cell as well as the percentage mitochondrial gene content for post-mitotic blood cells."),
                                 p(
                                   "Variables to regress out in a second non-regularized linear regression. For example, percent.mito."
                                 ),
                                 column(
                                   12,
                                   selectizeInput("varsToRegressUmap", label="Variables to regress out",
                                                  choices=NULL,
                                                  multiple=TRUE)
                                 )
                                 ,
                                 tags$div(class = "clearBoth")
                               )
                               ,
                               actionButton(
                                 "scTransform",
                                 "SCTransform",
                                 class = "button button-3d button-block button-pill button-primary button-large",
                                 style = "width: 100%"
                               )
                             ),
                             tags$div(class = "clearBoth")
                           )
                           ),
          
          ############
          hr(),

          conditionalPanel("input.sctransformOption == 'defaultPath'",
                           wellPanel(
                             column(
                               12,
                               tags$div(
                                 class = "BoxArea2",
                                 h4(strong("Data Normalization")),
                                 p(
                                   "After removing unwanted cells from the dataset, the next step is to normalize the data."
                                 ),
                                 p(
                                   "By default, we employ a global-scaling normalization method “LogNormalize” that normalizes the gene expression measurements for each cell by the total expression,
                                   multiplies this by a scale factor (10,000 by default), and log-transforms the result."
                                 ),
                                 column(
                                   6,
                                   selectInput(
                                     "normMethod",
                                     "Normalization Method",
                                     choices = list("LogNormalize"),
                                     selected = "LogNormalize"
                                   )
                                 ),
                                 column(6, numericInput("scaleFactor", "Scale Factor", value = 10000))
                                 ,
                                 tags$div(class = "clearBoth")
                                 )
                               
                           ),
                           hr(),
                           column(
                             12,
                             tags$div(
                               class = "BoxArea2",
                               h4(strong(
                                 "Detection of variable genes across the single cells"
                               )),
                               p(
                                 "Seurat calculates highly variable genes and focuses on these for downstream analysis. FindVariableGenes calculates the average expression and dispersion for each gene, places these genes into bins, and then calculates a z-score for dispersion within each bin. This helps control for the relationship between variability and average expression."
                               ),
                               p(
                                 "We suggest that users set these parameters to mark visual outliers on the dispersion plot, but the exact parameter settings may vary based on the data type, heterogeneity in the sample, and normalization strategy."
                               ),
                               column(
                                 6,
                                 selectInput(
                                   "meanFunction",
                                   "Mean Function",
                                   choices = list("ExpMean" = 1),
                                   selected = 1
                                 )
                               ),
                               column(
                                 6,
                                 selectInput(
                                   "dispersionFunction",
                                   "Dispersion Function",
                                   choices = list("LogVMR" = 1),
                                   selected = 1
                                 )
                               ),
                               column(
                                 6,
                                 numericInput("xlowcutoff", "X Low Cut-off value", value = 0.0125)
                               ),
                               column(6, numericInput(
                                 "xhighcutoff", "X High Cut-off value", value = 3
                               )),
                               column(6, numericInput("ycutoff", "Y Cut-off value", value = 0.5))
                               ,
                               tags$div(class = "clearBoth"),
                               conditionalPanel("output.findVariableGenesDone",
                                                h4(strong("Output"), style = "color: rgba(24, 188, 156, 1);"),
                                                tags$div(class = "BoxArea",strong(textOutput("varGenesPrint")), tags$div(class = "clearBoth"))
                                                
                               )
                             )
                             
                           )
                           ,
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
                           column(
                             12,
                             actionButton(
                               "findVariableGenes",
                               "Normalize / Find Var. Features / Scale Data",
                               class = "button button-3d button-block button-pill button-primary button-large",
                               style = "width: 100%"
                             )
                           )
                           ,
                           tags$div(class = "clearBoth")
                           
                           
                           )
                           
                           ),
          
          conditionalPanel("output.findVariableGenesDone || output.sctransformReactiveDone",
                           p(
                             #HTML("<span class='badge' style='font-size: 24px; background-color:#4877d2'>Next</span>"),
                             actionButton(
                               "nextRunPca",
                               "Next Step: Perform PCA Reduction",
                               class = "button button-3d button-pill button-caution"
                             )
                           ),
                           hr()
          )
          
          
        )))
