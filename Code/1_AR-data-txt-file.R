library(tidyverse) 
library(ggplot2) 
# library(maps) 
# library(sf)
library(readr)
# library(sp)
library(lubridate)
# Read atmospheric river global data in csv file modified from Bin Guan's txt file
global_ar <- read.csv('Data/globalAR_1980-2019.csv', header=TRUE)
# Select columns we want. Combine year, mont, day into one column.
colnames(global_ar)
# Rename Landfall_lat and _lon columns and correct mispelled column
colnames(global_ar)[19] = "lon"
colnames(global_ar)[20] = "lat"
colnames(global_ar)[10] = "Equatorwd_end_lat"
df <- global_ar %>% 
  # select(Year, Month, Day, Hour, Equatorwd_end_lon, Equatorwd_end_lat, Polewd_end_lon, Polewd_end_lat, Total_IVT, lon, lat) %>%
  filter(is.finite(lon))
# Convert "lon" coordinates from 0-360 to -180 to 180
# nlon <- ifelse(df$lon > 180, -360 + df$lon, df$lon) 
# Add nlon to df
# df$nlon <- with(df, nlon)
# Make new variable "Date"
df$Date <- with(df, ymd(sprintf('%04d%02d%02d', Year, Month, Day))) 
# Filter to North America using the non-convereted longitude.
ar_data <- df %>% 
  # select(Hour, Equatorwd_end_lon, Equaterwd_end_lat, Polewd_end_lon, Polewd_end_lat, Total_IVT, lon, lat, nlon, Date) %>%
  filter(lat > 20 & lat < 60, lon > 130 & lon < 220)
# Add dates of levee breaches in the region
leve_df <- read.csv("Data/levee-breaches-by-date.csv", header = TRUE)
# Make new variable "Date" and ignore NA
leve_df$Date <- with(leve_df, ymd(sprintf('%04d%02d%02d', Year, Month, Day))) 
# combine levee breach dates with dates in AR data
ar_breach <- ar_data %>% 
  inner_join(leve_df, by = "Date") 
# Map all the ARs origin and end in the ar_breach table. Pick only ones that pass through CA.
# Now I want to show dates when there were breaches and ARs. How can I pick dates that occur in both tables? 
ggplot(ar_breach, aes(Date, Total_IVT)) + # show dates of ARs and IVTs
  geom_point(alpha = 1/3) 
ggplot(ar_breach, aes(Date, Total_IVT)) + # show dates of ARs and IVTs
  geom_line()
ggplot(ar_breach, aes(y = lat.x, x = lon.x, size = Total_IVT)) +
      geom_point() +
      coord_quickmap()
# categorize IVT stregnth
p <- ggplot(ar_breach, aes(Date, Total_IVT)) +
  geom_point(aes(colour = Total_IVT)) +
  coord_quickmap()
p + 
  labs(x = "Year", y = "IVT", colour = "IVT strength\nkg m^-1 s^-1")
  
weak =  Total_IVT ≥ 250–500 
moderate =  Total_IVT ≥ 500–750
strong =  Total_IVT ≥ 750–1,000
extreme =  Total_IVT ≥ 1,000–1,250 
exceptional =  Total_IVT ≥ 1,250 
# Map ARs (landfall locations) on dates of flood events. Plot by flood years?

# I will need a 3-4 day window added between Date of AR and Date of levee failure.
leve_df %>% mutate(Date_prior1 = Date - 1)
