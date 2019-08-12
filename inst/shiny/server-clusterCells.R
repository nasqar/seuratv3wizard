
observe({
  clusterCellsReactive()
})

clusterCellsReactive <-
  eventReactive(input$clusterCells, {
    validate(
      need(length(input$clustPCDim) > 0, message = "Select at least two PC to use.")
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

       pbmc <- RunUMAP(object = pbmc, dims = as.numeric(c(input$clustPCDim)), verbose = FALSE)
      
      #v3
      pbmc <- FindNeighbors(object = pbmc, dims = as.numeric(c(input$clustPCDim)))
      myValues$clusterPrintOutput <- capture.output(pbmc <- FindClusters(object = pbmc, resolution = input$clustResolution))
      
      updateSelectInput(session, "tsnePCDim", selected = c(input$clustPCDim))
      # updateNumericInput(session, "umapPCDim1", value = input$clustPCDim1)
      # updateNumericInput(session, "umapPCDim2", value = input$clustPCDim2)
      
      shinyjs::show(selector = "a[data-value=\"clusterCells\"]")

      js$addStatusIcon("clusterCells","done")
      
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