
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
    
    plotVln = function() {
      lowthreshinput = input[[paste0("thresh",i)]][1]
      
      if(vlnsToPlot[i] != "nCount_RNA"){
        
        VlnPlot(object = pbmc, features = vlnsToPlot[i], ncol = 1, group.by = "orig.ident")  %>%
          + geom_hline(yintercept = input[[paste0("thresh",i)]][1],color = 'red',linetype = "dashed", size = 1) %>%
          + geom_text(x=1,y=input[[paste0("thresh",i)]][1], label="low.threshold", vjust=2, hjust=0,color = "red",size = 5,fontface = "bold",alpha = 0.7, family=c("serif", "mono")[2]) %>%
          + geom_hline(yintercept = input[[paste0("thresh",i)]][2],color = 'blue',linetype = "dashed", size = 1) %>%
          + geom_text(x=1,y=input[[paste0("thresh",i)]][2], label="high.threshold", vjust=-1, hjust=0, color = "blue",size = 5,fontface = "bold", alpha = 0.5, family=c("serif", "mono")[2]) %>%
          + scale_y_continuous(limits=c(minThresh - 0.05*(maxThresh - minThresh),maxThresh + 0.05*(maxThresh - minThresh)))
      }
      else {
        VlnPlot(object = pbmc, features = vlnsToPlot[i], ncol = 1, group.by = "orig.ident")
      }
    }

    output[[paste0("VlnPlot",i)]] <- renderPlot({
      plotVln()
    })
    
    output[[paste0("numGenesWithinThresh",i)]] <- renderText({
      dataColumn = round(pbmc[[vlnsToPlot[i]]][,1],4)
      
      numGenes = length(dataColumn[dataColumn >= input[[paste0("thresh",i)]][1] & dataColumn <= input[[paste0("thresh",i)]][2]])
      
      HTML(paste("Number of cells within gene detection thresholds<strong>",numGenes,"</strong>out of<strong>",NROW(dataColumn),"</strong>"))
    })
    
    output[[paste0(vlnsToPlot[i],"VlnDownloadPlot")]] <- downloadHandler(
      filename <- function() {
        paste(input$projectname, "_VlnPlot_", vlnsToPlot[i], input[[paste0(vlnsToPlot[i], "VlnDownloadAs")]], sep="")
      },
      content <- function(file) {
        ggsave(file, plotVln(), width = input[[paste0(vlnsToPlot[i],"VlnDownloadWidth")]], height = input[[paste0(vlnsToPlot[i],"VlnDownloadHeight")]], units = "cm", dpi = 300)
      },
      contentType = "image"
    )
    
    
    column(4,
           h4( strong(vlnsToPlot[i]) ),
           withSpinner(plotOutput(outputId = paste0("VlnPlot",i))),
           if(vlnsToPlot[i] != "nCount_RNA") {
             wellPanel(
               sliderInput(paste0("thresh",i), "Threshold:", min = minThresh, max = maxThresh, value = c(minThresh, maxThresh)),
               htmlOutput(paste0("numGenesWithinThresh",i) )
             )
           },
           wellPanel(
             h4("Plot Download Options"),
             column(6,
                    numericInput(inputId = paste0(vlnsToPlot[i],"VlnDownloadHeight"), "Plot height (in cm):", value = 10)
             ),
             column(6,
                    numericInput(inputId = paste0(vlnsToPlot[i],"VlnDownloadWidth"), "Plot width (in cm):", value = 15)
             ),
             fluidRow(
               radioButtons(inputId = paste0(vlnsToPlot[i], "VlnDownloadAs"), "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), inline = TRUE, selected = ".pdf"), style="padding-left:30px",
               downloadButton(outputId = paste0(vlnsToPlot[i], "VlnDownloadPlot"), "Download Plot")
             )
           )
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
    
    plotFeature = function() {
      FeatureScatter(object = pbmc, feature1 = "nCount_RNA", feature2 = featuresToPlot[i])
    }
    
    output[[paste0("ScatterFeaturePlot",i)]] <- renderPlot({
      plotFeature()
    })
    
    output[[paste0(featuresToPlot[i], "DownloadPlot")]] <- downloadHandler(
      filename <- function() {
        paste(input$projectname, "_FeatureScatterPlot_", featuresToPlot[i], input[[paste0(featuresToPlot[i], "DownloadAs")]], sep="")
      },
      content <- function(file) {
        ggsave(file, plotFeature(), width = input[[paste0(featuresToPlot[i],"DownloadWidth")]], height = input[[paste0(featuresToPlot[i],"DownloadHeight")]], units = "cm", dpi = 300)
      },
      contentType = "image"
    )
    
    column(4,
           h4( strong(featuresToPlot[i])),
           withSpinner(plotOutput(outputId = paste0("ScatterFeaturePlot",i))),
           wellPanel(
             h4("Plot Download Options"),
             column(6,
                    numericInput(inputId = paste0(featuresToPlot[i],"DownloadHeight"), "Plot height (in cm):", value = 10)
             ),
             column(6,
                    numericInput(inputId = paste0(featuresToPlot[i],"DownloadWidth"), "Plot width (in cm):", value = 15)
             ),
             fluidRow(
               radioButtons(inputId = paste0(featuresToPlot[i], "DownloadAs"), "Download File Type:", choices = list("PDF" = ".pdf", "SVG" = ".svg", "PNG" = ".png", "JPEG" = ".jpeg"), inline = TRUE, selected = ".pdf"), style="padding-left:30px",
               downloadButton(outputId = paste0(featuresToPlot[i], "DownloadPlot"), "Download Plot")
             )
           )
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
        
        if(grepl("^percent\\.",varName) )
          myValues$scriptCommands[[paste0('subset',i)]] = paste0('pbmc <- subset(x = pbmc, subset = ', varName, ' > ',lowThresh[i]*100,' & ', varName, ' < ',highThresh[i]*100,')')
        else
          myValues$scriptCommands[[paste0('subset',i)]] = paste0('pbmc <- subset(x = pbmc, subset = ', varName, ' > ',lowThresh[i],' & ', varName, ' < ',highThresh[i],')')
        
      }
      
      
      varsToRegressSelect = c("nFeature_RNA", "nCount_RNA")
      if(length(myValues$exprList) > 0)
        varsToRegressSelect = c(varsToRegressSelect, paste("percent.",names(myValues$exprList), sep = ""))
      
      if(length(input$filterSpecGenes) > 0)
        varsToRegressSelect = c(varsToRegressSelect,paste0("percent.",input$customGenesLabel))
      
      if(length(input$filterPasteGenes) > 0)
        varsToRegressSelect = c(varsToRegressSelect,paste0("percent.",input$pasteGenesLabel))
      
      updateSelectizeInput(session,'varsToRegress',
                           choices=varsToRegressSelect, selected= varsToRegressSelect[varsToRegressSelect != "nFeature_RNA"])
      updateSelectizeInput(session,'varsToRegressUmap',
                           choices=varsToRegressSelect, selected= NULL)
      
      
      shiny::setProgress(value = 0.9, detail = "Done.")
      
      
      js$addStatusIcon("vlnplot","done")
      
      
      js$addStatusIcon("filterNormSelectTab","next")
      #shinyjs::show(selector = "a[data-value=\"filterNormSelectTab\"]")
      GotoTab("filterNormSelectTab")
      
      return(list('pbmc'=pbmc))
      
    })
  })
