tabItem(tabName = "qcFilterTab",

        fluidRow(

          column(12,
                 h3(strong("QC & Filter (Preprocessing)")),
                 hr(),

                 wellPanel(

                   column(12,
                          tags$div(class = "",
                                   h4(strong("Filter Cells")),
                                   p("Seurat allows you to easily explore QC metrics and filter cells based on any user-defined criteria.
                                     You can visualize gene and molecule counts, plot their relationship, and exclude cells with a clear outlier number of genes detected as potential multiplets.
                                     This is not a guaranteed method to exclude cell doublets, see tutorial for more information.
                                     As an example in the tutorial, you can filter cells based on the percentage of mitochondrial genes present."),
                                   hr(),
                                   h4("Filter Options:"),
                                   tags$div(class = "BoxArea2",
                                            h4(strong("1) By Regular Expression:")),
                                            column(7,
                                                   wellPanel(
                                                     column(12,
                                                            column(6,
                                                                   textInput("regexFilter", "By Regex Expression",
                                                                             placeholder = "Eg. ^MT- for genes that start with 'MT-'")
                                                            ),
                                                            column(6,
                                                                   textInput("regexFilterLabel", "Label (no spaces)",
                                                                             placeholder = "Eg. mito")
                                                            )
                                                     )
                                                     ,
                                                     column(12,
                                                            column(6,
                                                                   actionButton("testExpr","Test Regex", class = "button-primary button-pill",style = "width: 100%;")
                                                            ),
                                                            column(6,
                                                                   conditionalPanel("input.regexFilter.length > 0 && input.regexFilterLabel.length > 0",
                                                                                    actionButton("addExpr","Add Filter", style = "width: 100%;", class = "button-action button-pill", icon("plus")))
                                                            )
                                                     )
                                                     ,
                                                     tags$div(class = "clearBoth")
                                                     ,
                                                     hr(),
                                                     wellPanel(h4(strong("Genes that match Regex")),
                                                               htmlOutput("filteredGenesFound")
                                                               ,
                                                               tags$div(class = "clearBoth")
                                                     ),
                                                     tags$div(class = "clearBoth")
                                                   )
                                            ),
                                            column(5,
                                                   wellPanel(style = "background-color:lightblue;",
                                                     h4(strong("Filter Expressions")),
                                                     selectizeInput("filterExpressions", label="",
                                                                    choices=NULL,
                                                                    multiple=TRUE)
                                                   )

                                            ),
                                            tags$div(class = "clearBoth")
                                   ),
                                   tags$div(class = "BoxArea2",
                                            h4(strong("2) Select Specific Genes:")),
                                            wellPanel(style = "background-color:lightblue;",
                                                      textInput("customGenesLabel", "Label (no spaces)",
                                                                placeholder = "Eg. mito.genes"),
                                              selectizeInput("filterSpecGenes", label="Select Genes",
                                                             choices=NULL,
                                                             multiple=TRUE,
                                                             options = list(
                                                               placeholder =
                                                                 'Start typing gene name'
                                                             ))
                                            )
                                   )
                                   ,
                                   tags$div(class = "BoxArea2",


                                              h4(strong("3) Copy/Paste Specific Genes:")),

                                              column(8,
                                                     wellPanel(
                                                     textAreaInput("listPasteGenes", "Paste List Of Genes", width = "100%", rows = 5),
                                                     column(4,
                                                            textInput("pasteGenesLabel", "Label (no spaces)",placeholder = "Eg. ribosomal")
                                                            )
                                                     ,
                                                     column(4,
                                                            selectInput("delimeter", "Delimeter",
                                                                        choices = c("(comma)" = ",",
                                                                                    "(space)" = " ",
                                                                                    "(tab)" = "\t",
                                                                                    "(enter)" = "\n")
                                                                        , selected = ",")
                                                            ),
                                                     column(4,
                                                            actionButton("addFilterPaste","Add genes",class = "button button-3d button-primary", style = "width: 100%")
                                                            ),
                                                     div(style = "clear:both;")
                                                     )
                                              ),
                                              column(4,
                                                     selectizeInput("filterPasteGenes", label="Added Genes",
                                                                    choices=NULL,
                                                                    multiple=TRUE
                                                     ),

                                                     conditionalPanel("output.genesNotFound",

                                                                      tags$div(
                                                                        style = "padding:10px;border: 3px solid; border-color:red; border-radius:10px; background-color:#fdfdfd; opacity: 0.90;",
                                                                        h4("Genes not found"),
                                                                        verbatimTextOutput("value"),
                                                                        HTML("<i class=\"fa fa-info-circle\"> <small>Remove/Correct those genes that are not found and click \"Add Genes\"</small></i> "),
                                                                        div(style = "clear:both;")
                                                                      )

                                                     )
                                              ),
                                              hr(),

                                              div(style = "clear:both;")


                                   )
                                   ,
                                   tags$div(class = "clearBoth")
                          )
                   )
                   ,
                   column(12,
                          actionButton("submit_data","Submit Data",class = "button button-3d button-block button-pill button-primary button-large", style = "width: 100%"))
                   ,
                   tags$div(class = "clearBoth")


                 )
          )
        )
)
