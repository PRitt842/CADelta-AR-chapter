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
library(maps) 
library(sf)
library(readr)
library(raster)
library(sp)
library(lubridate)
# Read atmospheric river global data
global_ar <- read.csv('Data/globalAR_1980-2019.csv', header=TRUE)
# Select columns we want. Combine year, mont, day into one column.
colnames(global_ar)
# Rename Landfall_lat and _lon columns 
colnames(global_ar)[19] = "lon"
colnames(global_ar)[20] = "lat"
df <- global_ar %>% 
  select(Year, Month, Day, Hour, Equatorwd_end_lon, Equaterwd_end_lat, Polewd_end_lon, Polewd_end_lat, Total_IVT, lon, lat) %>%
  filter(is.finite(lon))
# Convert "lon" coordinates from 0-360 to -180 to 180
nlon <- ifelse(df$lon > 180, -360 + df$lon, df$lon) 
# Add nlon to df
df$nlon <- with(df, nlon)
# Make new variable "Date"
df$Date <- with(df, ymd(sprintf('%04d%02d%02d', Year, Month, Day))) 
# Filter to North America using the non-convereted longitude.
ar_data <- df %>% 
  select(Hour, Equatorwd_end_lon, Equaterwd_end_lat, Polewd_end_lon, Polewd_end_lat, Total_IVT, lon, lat, nlon, Date) %>%
  filter(lat > 20 & lat < 60, lon > 230 & lon < 300)
# Add dates of levee breaches in the region
leve_df <- read.csv("Data/levee-breaches-by-date.csv", header = TRUE)
# Make new variable "Date"
leve_df$Date <- with(leve_df, ymd(sprintf('%04d%02d%02d', Year, Month, Day))) 
# Error message about parsing failure. Do I need to filter na date? filter(is.na(Date))
# combine levee breach dates with dates in AR data
ar_breach <- ar_data %>% 
  inner_join(leve_df, by = "Date")
# Now I want to show dates when there were breaches and ARs. How can I pick dates that occur in both tables? 
# Also, I will need a 3-4 day window added between Date of AR and Date of levee failure.
ggplot(ar_breach, aes(Date, Total_IVT)) + # show dates of ARs and IVTs
  geom_point(aes(size = lat.y, nlon.y), alpha = 1/3) + # and points for floods
  coord_quickmap()
