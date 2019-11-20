# download data 
dir.create("data-raw/", F, T)
# data
download.file(
  "https://ucla.app.box.com/v/ARcatalog/folder/16460775063",
  "data-raw/globalARcatalog_MERRA2_1980-2019_v1.0.txt"
)
# .txt file was taken into Excel, extra header rows were removed, solumns re-named, and saved as a .csv
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
global_ar <- read.csv('Data/globalAR_1980-2019.csv', header=TRUE)
head(global_ar)
global_ar
summary(global_ar)
names(global_ar)
str(global_ar)
# rename variables

# plot(global_ar)
# Need to make a subset for a smaller file
# Read the boundaries of the shapefile
bbox <- read_sf(dsn = "Data/Legal_Delta_Boundary.shp") %>% st_bbox()
bbox
# This is meant to if-then the data to the bounding box
global_ar %>% 
  filter(Landfall_lat >=37.62499 & Landfall_lat <=38.58916 & Landfall_lon >=-121.94045 & Landfall_lon <-121.19670)
