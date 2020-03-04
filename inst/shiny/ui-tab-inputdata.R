tabItem(tabName = "datainput",
         hr(),
         fluidRow(column(3,
                         box(title = "Upload Data", solidHeader = T, status = "primary", width = 12, collapsible = T,id = "uploadbox",

                             #downloadLink("instructionspdf",label="Download Instructions (pdf)"),
                             radioButtons('data_file_type','Use example file or upload your own data',
                                          c(
                                            #'Upload Data (Dropseq)'="uploadDropseq",
                                            'Upload Data (nonUMI)'="uploadNonUmi",
                                            'Upload Data (10X)'="upload10x",
                                            'Example Data (PBMC)'="examplecounts"
                                          ),selected = "uploadNonUmi"),
                             conditionalPanel(condition="input.data_file_type=='upload10x'",
                                              p("10X Data, 1 .mtx.gz file, and 2 .tsv.gz files")
                                              #fileInput('datafile', 'Choose File Containing Data (.mtx, .tsv)', multiple = TRUE)
                             ),

                             conditionalPanel(condition="input.data_file_type=='uploadNonUmi'",
                                              p("CSV counts file")

                             ),
                             conditionalPanel(condition = "input.data_file_type=='uploadNonUmi' || input.data_file_type=='upload10x'",
                                              fileInput('datafile', 'Choose File(s) Containing Data', multiple = TRUE)
                             )

                         ),
                         conditionalPanel("output.fileUploaded",
                                          box(title = "Initial Parameters", solidHeader = T, status = "primary", width = 12, collapsible = T,id = "uploadbox",

                                              textInput("projectname",
                                                        value = "Project1", label = "Project Name"),
                                              numericInput("mincells",
                                                           label="Minimum number of cells per gene",min=1,max=200,value=3),
                                              numericInput("mingenes",
                                                           label="Minimum number of genes per cell",min=1,max=Inf,value=200),
                                              actionButton("upload_data","Next Step: QC & Filter Cells", class = "button button-3d button-block button-pill button-caution", style = "width: 100%")

                                          )
                         )
         ),#column
         column(9,
                bsCollapse(id="input_collapse_panel",open="data_panel",multiple = FALSE,
                           bsCollapsePanel(title="Data Contents Table:",value="data_panel",
                                           p("Note: if there are more than 20 columns, only the first 20 will show here"),
                                           textOutput("inputInfo"),
                                           withSpinner(dataTableOutput('countdataDT'))
                           )
                )#bscollapse
         )#column
         )#fluidrow
)#tabpanel
