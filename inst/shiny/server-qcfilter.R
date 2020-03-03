
output$filteredGenesFound <- renderUI({
  myValues$exprOut

})

myValues <- reactiveValues()

observe({
  if(input$addExpr > 0){

    validate(
      need( isolate(!(input$regexFilter %in% myValues$exprList)) ,
            message = "Regex already exists"),
      need( isolate(!(input$regexFilterLabel %in% names(myValues$exprList))) ,
            message = "Regex already exists")
    )

    test = isolate( c(input$regexFilter) )
    test = isolate( setNames(test,input$regexFilterLabel) )
    isolate({
      myValues$exprList <- c(myValues$exprList, test)
      updateSelectizeInput(session,'filterExpressions',
                           choices=myValues$exprList, selected=myValues$exprList)
    })


    updateTextInput(session, "regexFilter", value = "")
    updateTextInput(session, "regexFilterLabel", value = "")

    myValues$exprOut = ""

  }
})

observeEvent(input$filterExpressions,ignoreNULL=FALSE, {

  if (length(input$filterExpressions) < length(myValues$exprList))
  {
    myValues$exprList = myValues$exprList[ myValues$exprList %in% input$filterExpressions]
    updateSelectizeInput(session,'filterExpressions',
                         choices=myValues$exprList, selected=myValues$exprList)
  }

})


observe({

  pbmc = initSeuratObjReactive()$pbmc
  
  #updateSelectizeInput(session,'filterSpecGenes',
  #                     choices=rownames(x = pbmc@data), server = TRUE)
  #v3
  updateSelectizeInput(session,'filterSpecGenes',
                       choices=rownames(x = GetAssayData(object = pbmc)), server = TRUE)
  
})

observe({
  if(input$testExpr > 0 & isolate(input$regexFilter != "")){

    pbmc = initSeuratObjReactive()$pbmc

    test = grep(pattern = isolate(input$regexFilter), x = rownames(x = GetAssayData(object = pbmc)), value = TRUE)


    genes = unlist(lapply(test, function(x){ paste("<div class='col-sm-3'>", x, "</div>")}))

    genes = c("<h4>num of genes: ",length(genes),"</h4>",genes)
    myValues$exprOut <- HTML(genes)

  }
})


observe({
  analyzeDataReactive()
})

analyzeDataReactive <-
  eventReactive(input$submit_data,
                ignoreNULL = FALSE, {
                  withProgress(message = "Analyzing Single Cell data, please wait",{
                    print("analysisCountDataReactive")

                    pbmc <- initSeuratObjReactive()$pbmc

                    js$addStatusIcon("qcFilterTab","loading")

                    shiny::setProgress(value = 0.3, detail = " Applying Filters ...")

                    #######
                    pbmcRawData <- GetAssayData(object = pbmc, slot = "counts")
                    
                    if(length(myValues$exprList) > 0)
                    {
                      for (i in 1:length(myValues$exprList)) {

                        exprPattern = myValues$exprList[i]
                        exprName = names(myValues$exprList[i])

                        pattern.genes <- grep(pattern = exprPattern, x = rownames(x = GetAssayData(object = pbmc)), value = TRUE)
                        
                        #v3
                        if(length(pattern.genes) > 1)
                          percent.pattern <- Matrix::colSums(x = pbmcRawData[pattern.genes, ]) / Matrix::colSums(x = pbmcRawData)
                        else
                          percent.pattern <- pbmcRawData[pattern.genes, ] / Matrix::colSums(x = pbmcRawData)
                        
                        pbmc <- AddMetaData(object = pbmc, metadata = percent.pattern, col.name = paste("percent.",exprName, sep = ""))
                        
                        #v3
                        pbmc[[paste0("percent.",exprName)]] <- percent.pattern

                        myValues$scriptCommands[[paste0("metadata",i)]] = paste0('pbmc[[','"percent.',exprName,'"]] <- ','PercentageFeatureSet(pbmc, pattern = "',myValues$exprList[i],'")')
                      }
                    }

                    
                    if(length(input$filterSpecGenes) > 0)
                    {
                      
                      if(length(input$filterSpecGenes) > 1)
                        percent.pattern <- Matrix::colSums(pbmcRawData[input$filterSpecGenes, ])/Matrix::colSums(pbmcRawData)
                      else
                        percent.pattern <- pbmcRawData[input$filterSpecGenes, ]/Matrix::colSums(pbmcRawData)
                      
                      pbmc <- AddMetaData(object = pbmc, metadata = percent.pattern, col.name = paste0("percent.",input$customGenesLabel))

                    }

                    if(length(input$filterPasteGenes) > 0)
                    {

                      if(length(input$filterPasteGenes) > 1)
                        percent.pattern <- Matrix::colSums(pbmcRawData[input$filterPasteGenes, ])/Matrix::colSums(pbmcRawData)
                      else
                        percent.pattern <- pbmcRawData[input$filterPasteGenes, ]/Matrix::colSums(pbmcRawData)
                      
                      pbmc <- AddMetaData(object = pbmc, metadata = percent.pattern, col.name = paste0("percent.",input$pasteGenesLabel))

                    }

                    #######

                    shiny::setProgress(value = 0.9, detail = "Done.")

                    #shinyjs::show(selector = "a[data-value=\"vlnplot\"]")
                    GotoTab("vlnplot")

                    ###update subsetNames
                    subsetNames = c("nFeature_RNA")

                    if(length(myValues$exprList) > 0)
                      subsetNames = c(paste("percent.",names(myValues$exprList), sep = ""), subsetNames)
                    if(length(input$filterSpecGenes) > 0)
                      subsetNames = c(paste0("percent.",input$customGenesLabel), subsetNames)
                    if(length(input$filterPasteGenes) > 0)
                      subsetNames = c(paste0("percent.",input$pasteGenesLabel), subsetNames)

                    updateSelectizeInput(session,'subsetNames',
                                         choices=subsetNames, selected=subsetNames)
                    #####

                    myValues$scriptCommands$vln = paste0('VlnPlot(pbmc, features = ',vectorToStr(c(subsetNames,"nCount_RNA")),', ncol = ',length(subsetNames),')')

                    js$addStatusIcon("qcFilterTab","done")

                    js$addStatusIcon("vlnplot","next")

                    return(list('pbmc'=pbmc))
                  })
                  }
  )


observe({

  filterTextReactive()
})

filterTextReactive <- eventReactive(input$addFilterPaste, {

  validate(
    need(input$listPasteGenes != "", message = "list of genes empty"),
    need(input$pasteGenesLabel != "", message = "genes label empty")
  )

  pbmc <- initSeuratObjReactive()$pbmc

  genes = unlist(strsplit(input$listPasteGenes,input$delimeter))

  genes = gsub("^\\s+|\\s+$", "", genes)
  genes = gsub("\\n+$|^\\n+", "", genes)
  genes = gsub("^\"|\"$", "", genes)
  genesNotFound = genes[!(genes %in% rownames(x = GetAssayData(object = pbmc)))]

  if(length(genesNotFound) == 0){
    updateSelectizeInput(session,'filterPasteGenes',
                         choices=genes, selected=genes)

    updateTextInput(session, "listPasteGenes", value = "")
  }

  return(list('genes' =genes,'notfound'=genesNotFound))
})



output$value <- renderText(
  {

    if(length(filterTextReactive()$notfound) > 0)
      paste(filterTextReactive()$notfound, collapse='\n' )
  }
)

output$genesNotFound <-
  reactive({
    return(length(filterTextReactive()$notfound) > 0)
  }
)
outputOptions(output, 'genesNotFound', suspendWhenHidden=FALSE)
