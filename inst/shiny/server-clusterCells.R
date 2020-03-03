
observe({
  clusterCellsReactive()
})

clusterCellsReactive <-
  eventReactive(input$clusterCells, {
    validate(
      need(length(input$clustPCDim) > 1, message = "Select at least two PC to use.")
    )
    withProgress(message = "Processing , please wait",{
      print("Finding Clusters")

      if(input$doJackStraw)
        pbmc <- jackStrawReactive()$pbmc
      else
        pbmc <- runPcaReactive()$pbmc

      js$addStatusIcon("clusterCells","loading")

      shiny::setProgress(value = 0.4, detail = "Finding Cell Clusters ...")

      # pbmc <- FindClusters(object = pbmc, reduction.type = input$reducType, dims.use = input$clustPCDim1:input$clustPCDim2,
      #                      resolution = input$clustResolution, print.output = 0, save.SNN = TRUE)

      #pbmc <- RunUMAP(object = pbmc, dims = as.numeric(c(input$clustPCDim)), verbose = FALSE)
      pbmc <- RunUMAP(object = pbmc, dims = as.numeric(c(input$clustPCDim)), reduction = input$reducType,verbose = FALSE)
      
      #v3
      pbmc <- FindNeighbors(object = pbmc, dims = as.numeric(c(input$clustPCDim)))
      myValues$clusterPrintOutput <- capture.output(pbmc <- FindClusters(object = pbmc, resolution = input$clustResolution))
      
      myValues$scriptCommands$runUmap = paste0("pbmc <- RunUMAP(object = pbmc, dims = as.numeric(",vectorToStr(input$clustPCDim),"), reduction = '",input$reducType,"')")
      myValues$scriptCommands$findNei = paste0("pbmc <- FindNeighbors(object = pbmc, dims = as.numeric(",vectorToStr(input$clustPCDim),"))")
      myValues$scriptCommands$findClusters = paste0("pbmc <- FindClusters(object = pbmc, resolution = ",input$clustResolution,")")
      
      myValues$scriptCommands$dimplotUmap = paste0('DimPlot(pbmc, reduction = "umap")')
      
      updateSelectInput(session, "tsnePCDim", selected = c(input$clustPCDim))
      
      shinyjs::show(selector = "a[data-value=\"nonLinReductTab\"]")
      shinyjs::show(selector = "a[data-value=\"clusterCells\"]")

      #updateSelectizeInput(session, "tsnePCDim", choices = 1:50, selected = input$clustPCDim)
      updateSelectInput(session, "tsnePCDim", selected = c(input$clustPCDim))
      
      js$addStatusIcon("clusterCells","done")
      js$addStatusIcon("nonLinReductTab","next")
      
      return(list('pbmc'=pbmc))
    })}
  )


output$clustParamsAvailable <- reactive({
  if(is.null(myValues$clusterPrintOutput))
    return(FALSE)
  return(TRUE)
})
outputOptions(output, 'clustParamsAvailable', suspendWhenHidden=FALSE)

output$clustParamsPrint <- renderText({

  pbmc <- clusterCellsReactive()$pbmc

  #printStr = capture.output(PrintFindClustersParams(object = pbmc))
  printStr = myValues$clusterPrintOutput
  printStr = gsub("\\[1\\]","",printStr)
  printStr = paste(printStr, collapse = "<br>")

  HTML(printStr)
})

observeEvent(input$nextRunTsne, {
  GotoTab("nonLinReductTab")
})