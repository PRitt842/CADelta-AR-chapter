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
library(lubridate)
# Read atmospheric river global data
global_ar <- read.csv('Data/globalAR_1980-2019.csv', header=TRUE)
# head(global_ar)
# global_ar
# summary(global_ar)
# names(global_ar)
# str(global_ar)
# Select columns we want. Combine year, mont, day into one column.
colnames(global_ar)
# Rename Landfall_lat and _lon columns 
colnames(global_ar)[19] = "lon"
colnames(global_ar)[20] = "lat"
df <- global_ar %>% 
  select(Year, Month, Day, Hour, Equatorwd_end_lon, Equaterwd_end_lat, Polewd_end_lon, Polewd_end_lat, Total_IVT, lon, lat) %>%
  filter(is.finite(lon))
# class(df)
# Convert "lon" coordinates from 0-360 to -180 to 180
nlon <- ifelse(df$lon > 180, -360 + df$lon, df$lon) 
# Add nlon to df
df$nlon <- with(df, nlon)
# Make new variable "Date"
df$Date <- with(df, ymd(sprintf('%04d%02d%02d', Year, Month, Day))) 
df
# Need to combine Hours based on max Total_IVT for each Day if Landfall location is the same. Would this be: 
# by_date <- group_by(date, lat, lon) %>% summarise(by_day, IVT = max(Total_IVT, na.rm = TRUE)) 
# How do we specify per Date if Landfall_lat and Landfall_lon are the same?
# Preview of time series. What we want is time series of ARs making landfall, ts of IVT, and ts of floods.
ggplot(df, aes(Year, Total_IVT)) +
  geom_line(colour = "grey50")
# Visualize on world map
dfmap <- ggplot(df, aes(x = nlon, y = lat)) +
  borders("world", colour = "gray80", fill = "gray80", size = 0.3) +
  geom_point(alpha = 0.3, size = 2, colour = "aquamarine3") 
dfmap
#Keep only the data for North America 
# usamap <- map_data('usa')
# xlim <- c(-127, -60) 
# ylim <- c(20, 50) 
# usbbox <- ggplot(usamap, aes('nlon','lat')) +   
 # geom_map(map=usamap, aes(map_id=region), fill=3, color=1) +   
 # xlim(xlim)+   ylim(ylim)+   
 # coord_quickmap() 
# usbbox
# Read the boundaries of the shapefile
# bbox <- read_sf(dsn = "Data/Legal_Delta_Boundary.shp") %>% st_bbox()
# bbox
# first attempt of selcting spatial data
# ardat2 <- which(df[,11] > 20 & df[,11] < 60 & df[,12] > -60 & df[,12] < -130)
# dim(df)
# length(ardat2)
# str(ardat2)
#[1] 160 $4 latitude bends and 20 longitude bends
# noramdat=df[ardat2,855:1454]
# Filter to North America. I am using the non-convereted longitude.
ar_data <- df %>% 
  select(Hour, Equatorwd_end_lon, Equaterwd_end_lat, Polewd_end_lon, Polewd_end_lat, Total_IVT, lon, lat, nlon, Date) %>%
  filter(lat > 20 & lat < 60, lon > 230 & lon < 300)
str(ar_data)
plot(ar_data)
# Add dates of levee breaches in the region
leve_df <- read.csv("Data/levee-breaches-by-date.csv", header = TRUE)
# Make new variable "Date"
leve_df$Date <- with(leve_df, ymd(sprintf('%04d%02d%02d', Year, Month, Day))) 
leve_df
# See if any date of levee breaches are same as dates in AR data

# Remove all groups in the pipe
ungroup()

