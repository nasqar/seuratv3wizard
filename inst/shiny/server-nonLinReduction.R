
observe({
  tsneReactive()
})

tsneReactive <-
  eventReactive(input$runTSNE, {
      withProgress(message = "Processing , please wait",{
        print("Running TSNE")
        
        js$addStatusIcon("nonLinReductTab","loading")
        
        pbmc <- clusterCellsReactive()$pbmc
        
        shiny::setProgress(value = 0.4, detail = "Running TSNE Reduction ...")
        
        pbmc <- RunTSNE(object = pbmc, dims.use = as.numeric(c(input$tsnePCDim)), 
                        perplexity = input$tsnePerplexity, 
                        reduction = input$reducType,
                        num_threads = 3)
        
        myValues$scriptCommands$runTsne = paste0("pbmc <- RunTSNE(object = pbmc, dims.use = as.numeric(",vectorToStr(input$tsnePCDim),"), perplexity = ",input$tsnePerplexity,", reduction = '",input$reducType,"')")
        
        updateSelectizeInput(session,'clusterNumCells', choices=levels(pbmc), selected=NULL)
        
        shiny::setProgress(value = 0.9, detail = "Done.")
        
        shinyjs::show(selector = "a[data-value=\"finishTab\"]")
        shinyjs::show(selector = "a[data-value=\"vizMarkersTab\"]")
        shinyjs::show(selector = "a[data-value=\"findMarkersTab\"]")
        shinyjs::show(selector = "a[data-value=\"nonLinReductTab\"]")
        
        js$addStatusIcon("nonLinReductTab","done")
        js$addStatusIcon("finishTab","download")
        js$addStatusIcon("findMarkersTab","next")
        
        myValues$finalData = list('pbmc'=pbmc)
        return(list('pbmc'=pbmc))
      })}
  )

observe({
  umapReactive()
})

umapReactive <-
  eventReactive({
    input$runUmap
  }, {
      withProgress(message = "Processing , please wait",{
        print("Umap")
        
        js$addStatusIcon("nonLinReductTab","loading")
        
        pbmc <- clusterCellsReactive()$pbmc
        
        shiny::setProgress(value = 0.4, detail = "Running UMAP Reduction ...")
        
        shiny::setProgress(value = 0.9, detail = "Done.")
        
        shinyjs::show(selector = "a[data-value=\"finishTab\"]")
        shinyjs::show(selector = "a[data-value=\"vizMarkersTab\"]")
        shinyjs::show(selector = "a[data-value=\"findMarkersTab\"]")
        shinyjs::show(selector = "a[data-value=\"nonLinReductTab\"]")
        
        js$addStatusIcon("nonLinReductTab","done")
        js$addStatusIcon("finishTab","download")
        js$addStatusIcon("findMarkersTab","next")
        
        myValues$finalData = list('pbmc'=pbmc)
        
        return(list('pbmc'=pbmc))
      })}
  )

#TSNE Plot output
tsnePlotFunc = reactive({
  pbmc <- tsneReactive()$pbmc
  
  DimPlot(object = pbmc, reduction = 'tsne', label = TRUE, group.by = input$tsneGroupBy)
  #TSNEPlot(object = pbmc, do.label = TRUE)
  #DimPlot(object = pbmc, reduction = 'tsne', do.label = TRUE, group.by = input$tsneGroupBy)
})

output$tsnePlot <- renderPlot({
  tsnePlotFunc()
})

#TSNE Plot Download handler
output$downloadTsne <- downloadHandler(
  filename <- function() {
    paste(input$projectname, "_TsnePlot", input$tsneDownloadAs, sep="")
  },
  content <- function(file) {
    ggsave(file, tsnePlotFunc(), width = input$tsneDownloadWidth,
           height = input$tsneDownloadHeight, units = "cm", dpi = 300)
  },
  contentType = "image"
)

output$tsnePlotAvailable <- reactive({
  return(!is.null(tsneReactive()$pbmc))
})
outputOptions(output, 'tsnePlotAvailable', suspendWhenHidden=FALSE)

#UMAP Plot output
UmapPlotFunc = reactive({
  pbmc <- umapReactive()$pbmc
  
  DimPlot(object = pbmc,reduction = "umap", label = TRUE, group.by = input$umapGroupBy)
  #TSNEPlot(object = pbmc, do.label = TRUE)
  #DimPlot(object = pbmc, reduction = 'tsne', do.label = TRUE, group.by = input$tsneGroupBy)
})

output$umapPlot <- renderPlot({
  UmapPlotFunc()
})

#UMAP Plot Download handler
output$downloadUmap <- downloadHandler(
  filename <- function() {
    paste(input$projectname, "_UmapPlot", input$UmapDownloadAs, sep="")
  },
  content <- function(file) {
    ggsave(file, UmapPlotFunc(), width = input$UmapDownloadWidth,
           height = input$UmapDownloadWidth, units = "cm", dpi = 300)
  },
  contentType = "image"
)


output$umapPlotAvailable <- reactive({
  return(!is.null(umapReactive()$pbmc))
})
outputOptions(output, 'umapPlotAvailable', suspendWhenHidden=FALSE)

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
  if(input$reductionMethod == 'tsne')
    pbmc <- tsneReactive()$pbmc
  else
    pbmc <- umapReactive()$pbmc
  
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


observe({
  if(input$nextClusterMarkers > 0 )
    GotoTab("findMarkersTab")
})

observe({
  if(input$nextDownload > 0 )
    GotoTab("finishTab")
})




