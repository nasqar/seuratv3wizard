
observe({
  tsneReactive()
})

tsneReactive <-
  eventReactive(input$runTSNE, {
    withProgress(message = "Processing , please wait",{
      print("Running TSNE")

      js$addStatusIcon("tsneTab","loading")

      pbmc <- clusterCellsReactive()$pbmc

      shiny::setProgress(value = 0.4, detail = "Running TSNE Reduction ...")

      pbmc <- RunTSNE(object = pbmc, dims.use = input$tsnePCDim1:input$tsnePCDim2, perplexity = input$tsnePerplexity, num_threads = parallel::detectCores()/2)

      updateSelectizeInput(session,'clusterNumCells',
                           choices=levels(pbmc), selected=NULL)

      shiny::setProgress(value = 0.9, detail = "Done.")


      shinyjs::show(selector = "a[data-value=\"finishTab\"]")
      shinyjs::show(selector = "a[data-value=\"findMarkersTab\"]")
      shinyjs::show(selector = "a[data-value=\"vizMarkersTab\"]")
      shinyjs::show(selector = "a[data-value=\"tsneTab\"]")


      js$addStatusIcon("tsneTab","done")
      js$addStatusIcon("finishTab","download")
      js$addStatusIcon("findMarkersTab","next")

      return(list('pbmc'=pbmc))
    })}
  )


output$tsnePlot <- renderPlot({

  pbmc <- tsneReactive()$pbmc

  #TSNEPlot(object = pbmc, do.label = TRUE)
  DimPlot(object = pbmc, reduction = 'tsne', do.label = TRUE)
})

output$tsnePlotAvailable <- reactive({
  return(!is.null(tsneReactive()$pbmc))
})
outputOptions(output, 'tsnePlotAvailable', suspendWhenHidden=FALSE)

### Cells in Clusters
output$clustercellsavailable <-
  reactive({
    return(!is.null(cellsInClusterReactive()$clustername))
  })
outputOptions(output, 'clustercellsavailable', suspendWhenHidden=FALSE)

observe({
  cellsInClusterReactive()
})

cellsInClusterReactive <- eventReactive(input$findCellsInCluster, {

  pbmc <- tsneReactive()$pbmc
  cellsInCluster <- WhichCells(object = pbmc, ident = input$clusterNumCells)


  print(length(cellsInCluster))

  ### Format the output to fit in a table
  extLength = round(length(cellsInCluster)/5)*5
  length(cellsInCluster) = extLength
  cellsInCluster = matrix(cellsInCluster,extLength/5,5)
  colnames(cellsInCluster) = c(" "," "," "," "," ")
  cellsInCluster[is.na(cellsInCluster)] = ""

  return(list("clustername" = paste0("cellsClusterId",input$clusterNumCells),"cellsInCluster"=cellsInCluster))
})

output$cellsInClusters <- renderDataTable({
  tmp <- cellsInClusterReactive()

  if(!is.null(tmp)){
    datatable(as.matrix(tmp$cellsInCluster),options = list(ordering=F))
  }

})

output$downloadClusterCells <- downloadHandler(

  filename = function() {paste0(cellsInClusterReactive()$clustername,".csv")},
  content = function(file) {
    csv = tail(cellsInClusterReactive()$cellsInCluster,-1)

    write.csv(csv, file, row.names=F)
    }

)

observeEvent(input$nextClusterMarkers, {
  GotoTab("findMarkersTab")
})

observeEvent(input$nextDownload, {
  GotoTab("finishTab")
})




