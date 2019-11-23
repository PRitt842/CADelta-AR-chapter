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
library(ggthemes)
# Read atmospheric river global data
global_ar <- read.csv('Data/globalAR_1980-2019.csv', header=TRUE)
# head(global_ar)
# global_ar
# summary(global_ar)
# names(global_ar)
# str(global_ar)
# Select columns we want
colnames(global_ar)
northam <- global_ar %>% 
  select(Year, Month, Day, Hour, Equatorwd_end_lon, Equaterwd_end_lat, Polewd_end_lon, Polewd_end_lat, Total_IVT, Landfall_lon, Landfall_lat) %>%
  filter(is.finite(Landfall_lon))
# set bounding box for ARs we want to see
usamap <- map_data('usa')
usamap
xlim <- c(-  127, -60) 
ylim <- c(20, 50) 
usbbox <- ggplot(usamap, aes('Landfall_lon','Landfall_lat')) +   
  geom_map(map=usamap, aes(map_id=region), fill=3, color=1) +   
  xlim(xlim)+   ylim(ylim)+   
  coord_quickmap() 
usbbox
# map ARs in US
armap <- ggplot(northam, aes(x = Landfall_lat, y = Landfall_lon)) +
  borders("world", colour = "gray80", fill = "gray80", size = 0.3) +
  geom_point(alpha = 0.3, size = 2, colour = "aquamarine3") 
armap
# summarise(TotalIVT = max(TotalIVT))

# Read the boundaries of the shapefile
bbox <- read_sf(dsn = "Data/Legal_Delta_Boundary.shp") %>% st_bbox()
bbox
# Filter to a bounding box
global_ar %>% 
  filter(Landfall_lat >= 37.62499 & Landfall_lat <= 38.58916 & Landfall_lon >= -121.94045 & Landfall_lon <-121.19670)
# Remove all groups in the pipe
ungroup()

