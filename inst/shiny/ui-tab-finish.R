tabItem(tabName = "finishTab",
        fluidRow(column(
          12,
          h3(strong("Download R Object/Script")),
          hr(),
          tags$div(
            class = "BoxArea2",

            p(
              "You can save the object at this point so that it can easily be loaded back in R for further analysis & exploration without having to rerun the computationally intensive steps performed above, or easily shared with collaborators."
            ),

            p("It is also recommended that you keep it as a reference."),

            column(12,
                   column(
                     6,
                     actionButton('generateSeuratFile', 'Generate Seurat Robj', class = "button button-3d button-block button-pill button-royal button-large")
                   ),
                   
                   column(
                     6,
                     conditionalPanel(
                       "output.seuratFileExists",
                       downloadButton('downloadRObj', 'Download Seurat Obj', class = "button button-3d button-block button-pill button-action button-large")
                     )
                   )
             ),
            column(12,
                   hr(),
                   p("Generate and Download the R script to reproduce these steps in R/RStudio"),
                   p("Please note that you need to edit the data file(s)/directory path in the script before you run it in R/RStudio"),
                   column(
                     6,
                     actionButton('generateSeuratScript', 'Generate Seurat Script', class = "button button-3d button-block button-pill button-highlight button-large")
                   ),
                   
                   column(
                     6,
                     conditionalPanel(
                       "output.seuratScriptExists",
                       downloadButton('downloadScript', 'Download Seurat Script', class = "button button-3d button-block button-pill button-action button-large")
                     )
                   )
                   )
            ,
            div(style = "clear:both;")

          )
        )))
