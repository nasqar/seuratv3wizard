tabItem(tabName = "dispersionPlot", 
         fluidRow(
                  column(12,
                         h3(strong("Dispersion Plot")),
                         p("The average expression and dispersion for each gene"),
                         strong(textOutput("numVarGenesFound"))
                         #,
                         #withSpinner(plotOutput(outputId = "dispersionPlot", height = 500))
                         )
                  )
         
          )