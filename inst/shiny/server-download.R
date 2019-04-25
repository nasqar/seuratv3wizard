#myValues <- reactivemyValues()

observe({

  if(input$generateSeuratFile)
  {
    withProgress(message = "Generating Seurat Object, please wait",{
      print("Saving Seurat Object")

      js$addStatusIcon("finishTab","loading")

      pbmc <- myValues$finalData$pbmc
      filename = paste0(input$projectname,"_seuratObj_",session$token,"_", format(Sys.time(), "%y-%m-%d_%H-%M-%S"), '.rds')

      filepath = file.path(tempdir(), filename)
      cat(filepath)
      shiny::setProgress(value = 0.3, detail = "might take some time for large datasets ...")

      #save(pbmc, file = filepath)
      
      #v3
      saveRDS(pbmc, file = filepath)
      myValues$filepath <- filepath

      js$addStatusIcon("finishTab","done")
    })


  }
})



output$seuratFileExists <-
  reactive({
    return(!is.null(myValues$filepath))

  })
outputOptions(output, 'seuratFileExists', suspendWhenHidden=FALSE)



output$downloadRObj <- downloadHandler(
  filename = function() {

    paste(input$projectname,"_seuratObj_", format(Sys.time(), "%y-%m-%d_%H-%M-%S"), '.rds', sep='')
  },
  content = function(file) {

    file.copy(myValues$filepath, file)

    js$addStatusIcon("finishTab","done")
  }
)
