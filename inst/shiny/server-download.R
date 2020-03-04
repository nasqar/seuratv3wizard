
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


generateSeuratScript <- function(filepath)
{
  scriptLines = unlist(myValues$scriptCommands)
  
  scriptLines = c("library(Seurat)",scriptLines,'saveRDS(pbmc, file = "final_seurat_object.rds")')
  
  str_replace_all(scriptLines, "pbmc","seuratObject")
  
  scriptLines = c(paste("# R script produced by SeuratV3Wizard for Project: ",input$projectname,"; ", format(Sys.time(), "%y-%m-%d_%H-%M-%S")),
                  scriptLines)
  
  fileConn<-file(filepath)
  writeLines(scriptLines, fileConn, sep = "\n\n")
  close(fileConn)
}


observe({
  
  if(input$generateSeuratScript)
  {
    withProgress(message = "Generating Seurat Script, please wait",{
      print("Generating Seurat Script")
      
      js$addStatusIcon("finishTab","loading")
      
      filename = paste0(input$projectname,"_seuratScript_",session$token,"_", format(Sys.time(), "%y-%m-%d_%H-%M-%S"), '.R')
      
      filepath = file.path(tempdir(), filename)
      cat(filepath)
      
      shiny::setProgress(value = 0.3, detail = " ...")
      
      generateSeuratScript(filepath)
      
      
      #save(pbmc, file = filepath)
      
      #v3
      myValues$scriptfilepath <- filepath
      
      js$addStatusIcon("finishTab","done")
    })
    
    
  }
})



output$seuratScriptExists <-
  reactive({
    if(!is.null(myValues$scriptfilepath))
      return(file.exists(myValues$scriptfilepath))
    return(F)
    
  })
outputOptions(output, 'seuratScriptExists', suspendWhenHidden=F)



output$downloadScript <- downloadHandler(
  filename = function() {
    
    paste0(input$projectname,"_seuratScript_", format(Sys.time(), "%y-%m-%d_%H-%M-%S"), '.R')
  },
  content = function(file) {
    
    file.copy(myValues$scriptfilepath, file)
    
    js$addStatusIcon("finishTab","done")
  }
)
