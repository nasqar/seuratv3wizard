
output$vizPcaPlot <- renderPlot({

  pbmc <- runPcaReactive()$pbmc

  VizDimLoadings(object = pbmc, dims = input$pcsToPlotStart:input$pcsToPlotEnd)
})

output$pcaPlot <- renderPlot({

  pbmc <- runPcaReactive()$pbmc

  DimPlot(object = pbmc, dims = c(input$dim1,input$dim2))
})

output$heatmapPlot <- renderPlot({

  pbmc <- runPcaReactive()$pbmc

  DimHeatmap(object = pbmc, dims = input$pcsToUse1:input$pcsToUse2, cells = input$cellsToUse, balanced = TRUE)
})
