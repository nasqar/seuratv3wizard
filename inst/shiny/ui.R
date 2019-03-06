require(shinydashboard)
require(shinyjs)
require(shinyBS)
require(shinycssloaders)
require(DT)
require(shiny)
require(Seurat)
#v3
#require(Seurat, lib.loc="./Seurat")


require(dplyr)
require(Matrix)
require(V8)
require(sodium)
require(ggplot2)
require(reticulate)
require(uuid)

ui <- tagList(
  dashboardPage(
    dashboardHeader(title = "SeuratV3 Wizard"),
    dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem("User Guide", tabName = "introTab", icon = icon("info-circle")),
        menuItem("Input Data", tabName = "datainput", icon = icon("upload")),
        menuItem("QC & Filter", tabName = "qcFilterTab", icon = icon("th")),
        menuItem("VlnPlot (Filter Cells)", tabName = "vlnplot", icon = icon("bar-chart")),
        menuItem(
          "Filter & Normalize",
          tabName = "filterNormSelectTab",
          icon = icon("th")
        ),
        menuItem(
          "Dispersion Plot",
          tabName = "dispersionPlot",
          icon = icon("bar-chart")
        ),
        menuItem("Scale and Run PCA", tabName = "runPcaTab", icon = icon("th")),
        menuItem(
          "Viz PCA Plot",
          tabName = "vizPcaPlot",
          icon = icon("bar-chart")
        ),
        menuItem("PCA Plot", tabName = "pcaPlot", icon = icon("bar-chart")),
        menuItem(
          "PC Heatmap",
          tabName = "heatmapPlot",
          icon = icon("bar-chart")
        ),
        menuItem("JackStraw", tabName = "jackStrawPlot", icon = icon("th")),
        menuItem("Cluster Cells", tabName = "clusterCells", icon = icon("th")),
        menuItem(
          "TSNE (Non-linear)",
          tabName = "tsneTab",
          icon = icon("th")
        ),
        menuItem("Cluster Markers", tabName = "findMarkersTab", icon = icon("th")),
        menuItem(
          "Viz Markers",
          tabName = "vizMarkersTab",
          icon = icon("bar-chart")
        ),
        menuItem(
          "Download Seurat Obj",
          tabName = "finishTab",
          icon = icon("download")
        )
      )
    ),
    dashboardBody(
      shinyjs::useShinyjs(),
      extendShinyjs(script = "www/custom.js"),
      tags$head(
        tags$style(HTML(
          " .shiny-output-error-validation {color: darkred; } "
        )),
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
        tags$link(rel = "stylesheet", type = "text/css", href = "buttons.css")
      ),
      tabItems(
        source("ui-tab-intro.R", local = TRUE)$value,
        source("ui-tab-inputdata.R", local = TRUE)$value,
        source("ui-tab-qcfilter.R", local = TRUE)$value,
        source("ui-tab-vln.R", local = TRUE)$value,
        source("ui-tab-filterNormSelect.R", local = TRUE)$value,
        source("ui-tab-dispersionPlot.R", local = TRUE)$value,
        source("ui-tab-runPca.R", local = TRUE)$value,
        source("ui-tab-vizPcaPlot.R", local = TRUE)$value,
        source("ui-tab-pcaPlot.R", local = TRUE)$value,
        source("ui-tab-pcHeatmapPlot.R", local = TRUE)$value,
        source("ui-tab-jackStrawPlot.R", local = TRUE)$value,
        source("ui-tab-clusterCells.R", local = TRUE)$value,
        source("ui-tab-tsne.R", local = TRUE)$value,
        source("ui-tab-finish.R", local = TRUE)$value,
        source("ui-tab-findMarkers.R", local = TRUE)$value,
        source("ui-tab-vizMarkers.R", local = TRUE)$value
      )

    )

  ),
  tags$footer(
    wellPanel(
    HTML(
      '
      <p align="center" width="4">Developed and maintained by: Core Bioinformatics, Center for Genomics and Systems Biology, NYU Abu Dhabi</p>
      <p align="center" width="4">Copyright (C) 2016, code licensed under GPLv3</p>
      <p align="center" width="4">Using Seurat version 3.0-alpha </p>
      <p align="center" width="4"><strong>Acknowledgements: </strong></p>
      <p align="center" width="4">1) Rahul Satija, Andrew Butler and Paul Hoffman (2017). Seurat: Tools for Single Cell Genomics. <a href="https://CRAN.R-project.org/package=Seurat" target="_blank">https://CRAN.R-project.org/package=Seurat</a></p>
      <p align="center" width="4">2) <a href="http://satijalab.org/seurat/" target="_blank">Satija Lab</a></p>'
  )
  ),
  tags$script(src = "imgModal.js")
  )
  )
