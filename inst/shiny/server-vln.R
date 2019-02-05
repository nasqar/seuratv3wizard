
output$vlnPlotsUI <- renderUI({
  # If missing input, return to avoid error later in function
  if(is.null(input$subsetNames))
    return()

  
  vlnsToPlot = c(input$subsetNames, "nCount_RNA")
  pbmc = analyzeDataReactive()$pbmc
  
  outputUI = lapply(seq(length(vlnsToPlot)), function(i) {

    minThreshA = round(min(pbmc[[vlnsToPlot[i]]][,1]),4)
    maxThreshA = round(max(pbmc[[vlnsToPlot[i]]][,1]),4)

    minThresh = minThreshA - 0.05*(maxThreshA - minThreshA)
    maxThresh = maxThreshA + 0.05*(maxThreshA - minThreshA)
    
    output[[paste0("VlnPlot",i)]] <- renderPlot({

      lowthreshinput = input[[paste0("thresh",i)]][1]

      if(vlnsToPlot[i] != "nCount_RNA"){
        
        VlnPlot(object = pbmc, features = vlnsToPlot[i], ncol = 1)  %>%
           + geom_hline(yintercept = input[[paste0("thresh",i)]][1],color = 'red',linetype = "dashed", size = 1) %>%
           + geom_text(x=1,y=input[[paste0("thresh",i)]][1], label="low.threshold", vjust=2, hjust=0,color = "red",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
           + geom_hline(yintercept = input[[paste0("thresh",i)]][2],color = 'blue',linetype = "dashed", size = 1) %>%
           + geom_text(x=1,y=input[[paste0("thresh",i)]][2], label="high.threshold", vjust=-1, hjust=0, color = "blue",size = 5,fontface = "bold", alpha = 0.5, family=c("serif", "mono")[2]) %>%
          + scale_y_continuous(limits=c(minThresh - 0.05*(maxThresh - minThresh),maxThresh + 0.05*(maxThresh - minThresh)))
      }
      else
        VlnPlot(object = pbmc, features = vlnsToPlot[i], ncol = 1)

    })

    output[[paste0("numGenesWithinThresh",i)]] <- renderText({
      dataColumn = round(pbmc[[vlnsToPlot[i]]][,1],4)

      numGenes = length(dataColumn[dataColumn >= input[[paste0("thresh",i)]][1] & dataColumn <= input[[paste0("thresh",i)]][2]])

      HTML(paste("Number of cells within gene detection thresholds<strong>",numGenes,"</strong>out of<strong>",NROW(dataColumn),"</strong>"))
    })


    column(4,

           h4( strong(vlnsToPlot[i]) ),
           withSpinner(plotOutput(outputId = paste0("VlnPlot",i))),
           if(vlnsToPlot[i] != "nCount_RNA")
           {
             wellPanel(
               sliderInput( paste0("thresh",i), "Threshold:",
                            min = minThresh, max = maxThresh,
                            value = c(minThresh, maxThresh)),
               htmlOutput(paste0("numGenesWithinThresh",i)   )
             )
           }
    )


  })

  outputUI

})


output$featureScatterUI <- renderUI({
  # If missing input, return to avoid error later in function
  if(is.null(input$subsetNames))
    return()
  
  
  featuresToPlot = c(input$subsetNames)
  pbmc = analyzeDataReactive()$pbmc
  
  outputUI = lapply(seq(length(featuresToPlot)), function(i) {
    
    output[[paste0("ScatterFeaturePlot",i)]] <- renderPlot({
      
      
      FeatureScatter(object = pbmc, feature1 = "nCount_RNA", feature2 = featuresToPlot[i])
    })
    
    column(4,
           
           h4( strong(featuresToPlot[i]) ),
           withSpinner(plotOutput(outputId = paste0("ScatterFeaturePlot",i)))
    )
  })
  
  outputUI
  
})

output$highLowThresholdsUI <- renderUI({
  # If missing input, return to avoid error later in function
  if(is.null(input$subsetNames))
    return()

  outputUI = lapply(seq(length(input$subsetNames)), function(i) {

    column(4,
           tags$div(class = "BoxArea",
                    h4( strong(input$subsetNames[i]) ),
                    textInput( paste0("lowThresh",i), "Low Threshold", value = "-Inf"),
                    textInput(paste0("highThresh",i), "High Threshold", value = "Inf"))
    )
  })

  outputUI

})


observe({
  filterCellsReactive()
})

filterCellsReactive <-
  eventReactive(input$filterCells,{
    withProgress(message = "Processing , please wait",{


      pbmc <- analyzeDataReactive()$pbmc

      js$addStatusIcon("vlnplot","loading")

      shiny::setProgress(value = 0.3, detail = "Filtering Cells ...")

      lowThresh = lapply(seq(length(input$subsetNames)), function(i){
        input[[paste0("thresh",i)]][1]
      })


      highThresh = lapply(seq(length(input$subsetNames)), function(i){
        input[[paste0("thresh",i)]][2]
      })

      lowThresh = unlist(lowThresh)
      highThresh = unlist(highThresh)
      shiny::setProgress(value = 0.6, detail = "Filtering Cells ...")

      # pbmc <- FilterCells(object = pbmc, subset.names = input$subsetNames,
      #                     low.thresholds = lowThresh, high.thresholds = highThresh)
      
      #####
      #v3
      for (i in 1:length(input$subsetNames)) {
        varName = input$subsetNames[i]
        expr <- FetchData(object = pbmc, vars = varName)
        
        pbmc = pbmc[, which(x = expr >  lowThresh[i] & expr < highThresh[i])]
        
      }
      
      
      shiny::setProgress(value = 0.9, detail = "Done.")


      js$addStatusIcon("vlnplot","done")


      js$addStatusIcon("filterNormSelectTab","next")
      #shinyjs::show(selector = "a[data-value=\"filterNormSelectTab\"]")
      GotoTab("filterNormSelectTab")

      return(list('pbmc'=pbmc))

    })
  })
