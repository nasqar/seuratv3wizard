
observe({
  jackStrawReactive()
})

jackStrawReactive <-
  eventReactive(input$doJackStraw, {
    withProgress(message = "Processing , please wait",{
      print("Running JackStraw")
      
      js$addStatusIcon("jackStrawPlot","loading")
      #updateTabItems(session, "tabs", "jackStrawPlot")
      
      pbmc <- runPcaReactive()$pbmc
      
      #########
      shiny::setProgress(value = 0.3, detail = "Running JackStraw Procedure (this might take a while)...")
      
      #pbmc <- JackStraw(object = pbmc, num.replicate = input$numReplicates, do.par = T)
      
      #v3
      plan("multiprocess", workers = 3)
      pbmc <- JackStraw(object = pbmc, num.replicate = input$numReplicates)
      pbmc <- ScoreJackStraw(object = pbmc, dims = input$jsPcsToPlot1:input$jsPcsToPlot2)
      
      myValues$scriptCommands$jackstraw = paste0("JackStraw(object = pbmc, num.replicate = ",input$numReplicates,")")
      myValues$scriptCommands$scoreJackstraw = paste0("pbmc <- ScoreJackStraw(object = pbmc, dims = ",input$jsPcsToPlot1,':',input$jsPcsToPlot2,")")
      myValues$scriptCommands$jackstrawPlot = paste0("JackStrawPlot(pbmc, dims = ",input$jsPcsToPlot1,':',input$jsPcsToPlot2,")")
      ########
      
      shiny::setProgress(value = 0.9, detail = "Done.")
      
      
      shinyjs::show(selector = "a[data-value=\"clusterCells\"]")
      shinyjs::show(selector = "a[data-value=\"jackStrawPlot\"]")
      
      js$addStatusIcon("jackStrawPlot","done")
      js$addStatusIcon("clusterCells","next")
      
      return(list('pbmc'=pbmc))
    })}
  )

#Generate Elbow plot and its download handlers
elbowPlotFunc = reactive({
  pbmc <- runPcaReactive()$pbmc
  ElbowPlot(object = pbmc)
})

output$pcElbowPlot <- renderPlot({
  
  if(input$doElbowPlot > 0)
  {
    ##
    shinyjs::show(selector = "a[data-value=\"clusterCells\"]")
    shinyjs::show(selector = "a[data-value=\"jackStrawPlot\"]")
    
    myValues$scriptCommands$elbowPlot = "ElbowPlot(object = pbmc)"
    
    js$addStatusIcon("jackStrawPlot","done")
    js$addStatusIcon("clusterCells","next")
    ##
    
    elbowPlotFunc()
  }
})

output$downloadElbowPlot <- downloadHandler(
  filename <- function() {
    paste(input$projectname, "_ElbowPlot", input$elbowDownloadAs,sep="")
  },
  content <- function(file) {
    ggsave(file, elbowPlotFunc(), width = input$elbowDownloadWidth,
           height = input$elbowDownloadHeight, units = "cm", dpi = 300)
  },
  contentType = "image"
)


#Generate JackStraw plot and its download handlers
jackStrawPlotFunc = reactive({
  pbmc <- jackStrawReactive()$pbmc
  JackStrawPlot(object = pbmc, dims = isolate(input$jsPcsToPlot1:input$jsPcsToPlot2))
})

output$jackStrawPlot <- renderPlot({
  jackStrawPlotFunc()
})

output$jackStrawPlotAvailable <- reactive({
  if(is.null(jackStrawReactive()$pbmc))
    return(FALSE)
  return(TRUE)
})
outputOptions(output, 'jackStrawPlotAvailable', suspendWhenHidden=FALSE)

output$downloadJackStrawPlot <- downloadHandler(
  filename <- function() {
    paste(input$projectname, "_JackStrawPlot", input$jackStrawDownloadAs,sep="")
  },
  content <- function(file) {
    ggsave(file, jackStrawPlotFunc(), width = input$jackStrawDownloadWidth,
           height = input$jackStrawDownloadHeight, units = "cm", dpi = 300)
  },
  contentType = "image"
)


observe({
  if(input$nextClusterCells > 0)
    GotoTab("clusterCells")
  
  if(input$nextClusterCells1 > 0)
    GotoTab("clusterCells")
})
