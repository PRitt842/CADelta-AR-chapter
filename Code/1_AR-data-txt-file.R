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
# Bar chart
ggplot(ar_breach, aes(Total_IVT)) + geom_bar(fill = "red") + theme_bw() +
  labs(title = "IVT by count") + theme_gray() # dont know why this is not shpwing more counts
# categorize by IVT stregnth
summary(ar_breach)

# create categories of IVT strength:  weak≥ 250–500, 
# moderate≥ 500–750 strong≥ 750–1,000, extreme≥ 1,000–1,250, 
# exceptional≥ 1,250 
catIVT <- cut(ar_breach$Total_IVT, breaks=c(250,500,750,1000,1250,1500), 
  labels=c("Weak", "Moderate","Strong", "Extreme", "Exceptional"), 
  right=FALSE) #specify start 250, 500, etc.
ar_breach$Total_IVT[1:10]
catIVT[1:10]
ggplot(ar_breach, aes(x = Date, y = Total_IVT, col = catIVT)) +
  geom_point() +
  ylim(250,NA) +
  labs(main = "AR Categories", x = "Year", y = "IVT", col = "IVT strength\nkg m^-1 s^-1") 
# How do I get NA off the legend?
# I want to show lat.x, lon.x for each point (adding text) 

# Bar chart
ggplot(ar_breach, aes(Total_IVT)) + geom_bar(fill = "red")+theme_bw()+
  scale_x_continuous("IVT", breaks = seq(250,1500)) +
  scale_y_continuous("Year", breaks = seq(1980,2010,5)) +
  coord_flip()+ labs(title = "Bar Chart") + theme_gray()


  #c("250-500", "501-750", "751-1000", "1001-1250", "1250-NA")
  #scale_y_continuous("Total_IVT", breaks = seq(250, 1250, by 500)) +

# Map ARs (landfall locations) on dates of flood events. Plot by flood years?

# I will need a 3-4 day window added between Date of AR and Date of levee failure.
leve_df %>% mutate(Date_prior1 = Date - 1)
