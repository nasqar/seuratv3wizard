tabItem(tabName = "filterNormSelectTab",

        fluidRow(column(
          12,
          h3(strong("Filter, Normalize, and Select Genes")),
          hr(),

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
                               tags$div(class = "BoxArea",strong(textOutput("varGenesPrint")), tags$div(class = "clearBoth")),
                               hr(),
                               p(
                                 #HTML("<span class='badge' style='font-size: 24px; background-color:#4877d2'>Next</span>"),
                                 actionButton(
                                   "nextRunPca",
                                   "Next Step: Scale Data and Perform PCA Reduction",
                                   class = "button button-3d button-pill button-caution"
                                 )
                                 )
                               )
            )

          )
          ,
          column(
            12,
            actionButton(
              "findVariableGenes",
              "Find Variable Genes",
              class = "button button-3d button-block button-pill button-primary button-large",
              style = "width: 100%"
            )
          )
          ,
          tags$div(class = "clearBoth")


          )
        )))
