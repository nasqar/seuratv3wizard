#!/usr/bin/env Rscript



if (!require(shinydashboard)){
  install.packages("shinydashboard")
  library(shinydashboard)
}
if(!require(shiny)){
  install.packages("shiny")
  library(shiny)
}
if(!require(shinyjs)){
  install.packages("shinyjs")
  library(shinyjs)
}
if(!require(shinyBS)){
  install.packages("shinyBS")
  library(shinyBS)
}
if(!require(shinycssloaders)){
  install.packages("shinycssloaders")
  library(shinycssloaders)
}
if(!require(DT)){
  install.packages("DT")
  library(DT)
}
if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}
if(!require(Matrix)){
  install.packages("Matrix")
  library(Matrix)
}
if(!require(V8)){
  install.packages('V8', repos='http://cran.rstudio.com/')
  library(V8)
}
if(!require(sodium)){
  install.packages("sodium")
  library(sodium)
}



if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}
