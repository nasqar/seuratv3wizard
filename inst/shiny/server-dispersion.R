

# output$dispersionPlot <- renderPlot({
# 
#   pbmc <- findVariableGenesReactive()$pbmc
# 
#   #dispersionPlot = FindVariableGenes(object = pbmc, mean.function = ExpMean, dispersion.function = LogVMR,
#   #                                  x.low.cutoff = input$xlowcutoff, x.high.cutoff = input$xhighcutoff,
#   #                                 y.cutoff = input$ycutoff)
#   varGenes = VariableGenePlot(pbmc)
#   js$addStatusIcon("dispersionPlot","done")
# 
#   varGenes
# })

output$numVarGenesFound <- renderText({

  pbmc <- findVariableGenesReactive()$pbmc
  #print(paste("number of variable genes found: ", length(x = pbmc@var.genes)))
  paste("Number of variable genes/features found: ", length(x = VariableFeatures(object = pbmc)))
})
