

observe({
  findVariableGenesReactive()
})

findVariableGenesReactive <-
  eventReactive(input$findVariableGenes, {
    withProgress(message = "Processing , please wait",{
      print("analysisCountDataReactive")

      pbmc <- filterCellsReactive()$pbmc


      js$addStatusIcon("filterNormSelectTab","loading")


      shiny::setProgress(value = 0.4, detail = "Normalizing Data ...")

      pbmc <- NormalizeData(object = pbmc, normalization.method = input$normMethod,
                            scale.factor = input$scaleFactor)


      shiny::setProgress(value = 0.8, detail = "Finding Variable Genes ...")

      # pbmc <- FindVariableGenes(object = pbmc, mean.function = ExpMean, dispersion.function = LogVMR,
      #                           x.low.cutoff = input$xlowcutoff, x.high.cutoff = input$xhighcutoff,
      #                           y.cutoff = input$ycutoff, do.plot = FALSE)
      # 
      # print(paste("number of genes found: ", length(x = pbmc@var.genes)))

      #v3
      pbmc <- FindVariableFeatures(object = pbmc, selection.method = 'mean.var.plot', mean.cutoff = c( input$xlowcutoff, input$xhighcutoff), dispersion.cutoff = c(input$ycutoff, Inf))
      print(paste("number of genes found: ", length(x = VariableFeatures(object = pbmc))))


      shinyjs::show(selector = "a[data-value=\"runPcaTab\"]")
      shinyjs::show(selector = "a[data-value=\"filterNormSelectTab\"]")


      varsToRegressSelect = c("nFeature_RNA", "nCount_RNA")
      if(length(myValues$exprList) > 0)
        varsToRegressSelect = c(varsToRegressSelect, paste("percent.",names(myValues$exprList), sep = ""))

      if(length(input$filterSpecGenes) > 0)
        varsToRegressSelect = c(varsToRegressSelect,paste0("percent.",input$customGenesLabel))

      if(length(input$filterPasteGenes) > 0)
        varsToRegressSelect = c(varsToRegressSelect,paste0("percent.",input$pasteGenesLabel))

      updateSelectizeInput(session,'varsToRegress',
                           choices=varsToRegressSelect, selected= varsToRegressSelect[varsToRegressSelect != "nFeature_RNA"])

      #js$addStatusIcon("dispersionPlot","loading")
      js$addStatusIcon("filterNormSelectTab","done")
      js$addStatusIcon("runPcaTab","next")
      return(list('pbmc'=pbmc))
    })}
  )


output$findVariableGenesDone <- reactive({
  if(is.null(findVariableGenesReactive()$pbmc))
    return(FALSE)
  return(TRUE)
})
outputOptions(output, 'findVariableGenesDone', suspendWhenHidden=FALSE)

output$varGenesPrint <- renderText({
  
  pbmc <- findVariableGenesReactive()$pbmc
  paste("Number of variable genes/features found: ", length(x = VariableFeatures(object = pbmc)))
  
})

observeEvent(input$nextRunPca, {
  GotoTab("runPcaTab")
})
