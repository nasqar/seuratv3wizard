

observe({
  findVariableGenesReactive()
})

findVariableGenesReactive <-
  eventReactive(input$findVariableGenes, {
    withProgress(message = "Processing , please wait",{
      print("analysisCountDataReactive")
      
      pbmc <- filterCellsReactive()$pbmc
      
      disable("sctransformOption")
      
      js$addStatusIcon("filterNormSelectTab","loading")
      
      
      shiny::setProgress(value = 0.4, detail = "Normalizing Data ...")
      
      plan("multiprocess", workers = 3)
      
      pbmc <- NormalizeData(object = pbmc, normalization.method = input$normMethod,
                            scale.factor = input$scaleFactor)
      
      
      shiny::setProgress(value = 0.6, detail = "Finding Variable Genes ...")
      
      # pbmc <- FindVariableGenes(object = pbmc, mean.function = ExpMean, dispersion.function = LogVMR,
      #                           x.low.cutoff = input$xlowcutoff, x.high.cutoff = input$xhighcutoff,
      #                           y.cutoff = input$ycutoff, do.plot = FALSE)
      # 
      # print(paste("number of genes found: ", length(x = pbmc@var.genes)))
      
      #v3
      pbmc <- FindVariableFeatures(object = pbmc, selection.method = 'mean.var.plot', mean.cutoff = c( input$xlowcutoff, input$xhighcutoff), dispersion.cutoff = c(input$ycutoff, Inf))
      print(paste("number of genes found: ", length(x = VariableFeatures(object = pbmc))))
      
      
      shiny::setProgress(value = 0.8, detail = "Scaling Data (this might take a while)...")
      
      #pbmc <- ScaleData(object = pbmc, vars.to.regress = input$varsToRegress, do.par = T)
      
      #v3
      plan("multiprocess", workers = 3)
      pbmc <- ScaleData(object = pbmc, vars.to.regress = input$varsToRegress)
      
      shinyjs::show(selector = "a[data-value=\"runPcaTab\"]")
      shinyjs::show(selector = "a[data-value=\"filterNormSelectTab\"]")
      
      #js$addStatusIcon("dispersionPlot","loading")
      js$addStatusIcon("filterNormSelectTab","done")
      js$addStatusIcon("runPcaTab","next")
      return(list('pbmc'=pbmc))
    })
  }
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


observe({
  sctransformReactive()
})

sctransformReactive <-
  eventReactive(input$scTransform, {
    withProgress(message = "Processing , please wait",{
      
      
      pbmc <- filterCellsReactive()$pbmc
      
      disable("sctransformOption")
      
      js$addStatusIcon("filterNormSelectTab","loading")
      
      
      shiny::setProgress(value = 0.4, detail = "Running SCTransform ...")
      
      pbmc <- SCTransform(object = pbmc, verbose = F, vars.to.regress = input$varsToRegressUmap)
      
      shinyjs::show(selector = "a[data-value=\"runPcaTab\"]")
      #shinyjs::show(selector = "a[data-value=\"filterNormSelectTab\"]")
      
      js$addStatusIcon("filterNormSelectTab","done")
      js$addStatusIcon("runPcaTab","next")
      return(list('pbmc'=pbmc))
    })}
  )

output$sctransformReactiveDone <- reactive({
  if(is.null(sctransformReactive()$pbmc))
    return(FALSE)
  return(TRUE)
})
outputOptions(output, 'sctransformReactiveDone', suspendWhenHidden=FALSE)


observeEvent(input$nextRunPca, {
  GotoTab("runPcaTab")
})
