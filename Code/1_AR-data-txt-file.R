# download data 
dir.create("data-raw/", F, T)
# data
download.file(
  "https://ucla.app.box.com/v/ARcatalog/folder/16460775063",
  "data-raw/globalARcatalog_MERRA2_1980-2019_v1.0.txt"
)
# File was transformed in excel in three ways and then saved as CSV: Dates and times were put into seperate columns and one single line of headers was created. Extra header lines were deleted.
library(tidyverse) 
library(ggplot2) 
library(scatterpie) 
library(maps) 
library(rgdal) 
library(sf)
library(readr)
library(raster)
library(sp)
# Read atmospheric river global data
global_ar <- read.fwf('Data/globalAR_1980-2019.csv', c(4, 2, 2, 2, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6))
global_ar
summary(global_ar)
names(global_ar)
str(global_ar)

