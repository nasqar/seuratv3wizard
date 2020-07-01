vizPcaPlotFunc = reactive({
  pbmc <- runPcaReactive()$pbmc

  VizDimLoadings(object = pbmc, dims = input$pcsToPlotStart:input$pcsToPlotEnd)
})


output$vizPcaPlot <- renderPlot({
  vizPcaPlotFunc()
})

output$downloadVizPcaPlot <- downloadHandler(
  filename <- function() {
    paste(input$projectname, "_vizPcaPlot", input$vizPcaDownloadAs, sep = "")
  },
  content <- function(file) {
    ggsave(file, vizPcaPlotFunc(), width = input$vizPcaDownloadWidth,
           height = input$vizPcaDownloadHeight, units = "cm", dpi = 300)
  },
  contentType = "image"
)

# output$pcaPlot <- renderPlot({
# 
#   pbmc <- runPcaReactive()$pbmc
# 
#   DimPlot(object = pbmc, dims = c(input$dim1,input$dim2),reduction = "pca")
# })

#PCA plot output and download handler
pcaPlotFunc = reactive({
  pbmc <- runPcaReactive()$pbmc
  DimPlot(object = pbmc, dims = c(input$dim1ica,input$dim2ica), reduction = "pca")
})

output$pcaPlot <- renderPlot({
  pcaPlotFunc()
})

output$downloadPcaPlot <- downloadHandler(
  filename <- function() {
    paste(input$projectname, "_PcaPlot", input$pcaDownloadAs,sep="")
  },
  content <- function(file) {
    ggsave(file, pcaPlotFunc(), width = input$pcaDownloadWidth,
           height = input$pcaDownloadHeight, units = "cm", dpi = 300)
  },
  contentType = "image"
)


#ICA plot output and download handler
icaPlotFunc = reactive({
  pbmc <- runPcaReactive()$pbmc
  DimPlot(object = pbmc, dims = c(input$dim1ica,input$dim2ica), reduction = "ica")
})

output$icaPlot <- renderPlot({
  icaPlotFunc()
})

output$downloadIcaPlot <- downloadHandler(
  filename <- function() {
    paste(input$projectname, "_IcaPlot", input$icaDownloadAs,sep="")
  },
  content <- function(file) {
    ggsave(file, icaPlotFunc(), width = input$icaDownloadWidth,
           height = input$icaDownloadHeight, units = "cm", dpi = 300)
  },
  contentType = "image"
)


#PCA heatmap output and download handler
output$heatmapPlot <- renderPlot({

  pbmc <- runPcaReactive()$pbmc

  DimHeatmap(object = pbmc, dims = input$pcsToUse1:input$pcsToUse2, cells = input$cellsToUse, balanced = TRUE)
})

output$downloadHeatmap <- downloadHandler(
  filename <- function() {
    paste(input$projectname, "_PcaHeatMap", input$heatmapDownloadAs,sep="")
  },
  content <- function(file) {
    pbmc <- runPcaReactive()$pbmc
    if (input$heatmapDownloadAs == ".svg") {
      svglite(file, width = input$heatmapDownloadWidth, height = input$heatmapDownloadHeight, res = 300)
    } else if (input$heatmapDownloadAs == ".jpeg") {
      jpeg(file, width = input$heatmapDownloadWidth, height = input$heatmapDownloadHeight, units = 'cm', res = 200)
    }else {
      png(file, width = input$heatmapDownloadWidth, height = input$heatmapDownloadHeight, units = 'cm', res = 300)
    }
    DimHeatmap(object = pbmc, dims = input$pcsToUse1:input$pcsToUse2, cells = input$cellsToUse, balanced = TRUE)
    dev.off()
  },
  contentType = "image"
)
