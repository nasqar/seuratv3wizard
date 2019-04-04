
observe({
  clusterCellsReactive()
})

clusterCellsReactive <-
  eventReactive(input$clusterCells, {
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

      if(input$sctransformOption == 'sctransformPath')
        pbmc <- RunUMAP(object = pbmc, dims = input$clustPCDim1:input$clustPCDim2, verbose = FALSE)
      
      #v3
      pbmc <- FindNeighbors(object = pbmc, dims = input$clustPCDim1:input$clustPCDim2)
      myValues$clusterPrintOutput <- capture.output(pbmc <- FindClusters(object = pbmc, resolution = input$clustResolution))
      
      if(input$sctransformOption == 'sctransformPath')
      {shinyjs::show(selector = "a[data-value=\"umapTab\"]")
        js$addStatusIcon("umapTab","next")}
      else
      {shinyjs::show(selector = "a[data-value=\"tsneTab\"]")
        js$addStatusIcon("tsneTab","next")
        }
      
      updateNumericInput(session, "tsnePCDim1", value = input$clustPCDim1)
      updateNumericInput(session, "tsnePCDim2", value = input$clustPCDim2)
      updateNumericInput(session, "umapPCDim1", value = input$clustPCDim1)
      updateNumericInput(session, "umapPCDim2", value = input$clustPCDim2)
      
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
  if(input$sctransformOption == 'sctransformPath')
    GotoTab('umapTab')
  else
    GotoTab("tsneTab")
})