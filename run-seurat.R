#!/usr/bin/env Rscript

library(devtools);
devtools::load_all()
# library(seuratOnline)
ip = '0.0.0.0'
portNumber = 5555
SeuratWizard(ip,portNumber)