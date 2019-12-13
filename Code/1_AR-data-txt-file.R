library(tidyverse) 
library(ggplot2) 
library(readr)
library(lubridate)
# Read atmospheric river global data in csv file modified from Bin Guan's txt file
global_ar <- read.csv('Data/globalAR_1980-2019.csv', header=TRUE)
# Combine year, month, day into one column.
colnames(global_ar)
# colnames(global_ar)[19] = "lon" # This is landfall longitude
# colnames(global_ar)[20] = "lat" # This is landfall latititude
colnames(global_ar)[10] = "Equatorwd_end_lat" # correct mispelled column
df <- global_ar %>% 
  # select(Year, Month, Day, Hour, Equatorwd_end_lon, Equatorwd_end_lat, Polewd_end_lon, Polewd_end_lat, Total_IVT, lon, lat) %>%
  filter(is.finite(Landfall_lon))
# Convert "Landfall_lon" coordinates from 0-360 to -180 to 180
nLandfall_lon <- ifelse(df$Landfall_lon > 180, -360 + df$Landfall_lon, df$Landfall_lon) 
# Add nlon to df
df$nLandfall_lon <- with(df, nLandfall_lon)
# Make new variable "Date"
df$Date <- with(df, ymd(sprintf('%04d%02d%02d', Year, Month, Day))) 
# Filter to North America using the non-convereted longitude.
ar_data <- df %>% 
  filter(Landfall_lat > 20 & Landfall_lat < 60, Landfall_lon > 230 & Landfall_lon < 250)
  # select(Hour, Equatorwd_end_lon, Equaterwd_end_lat, Polewd_end_lon, Polewd_end_lat, Total_IVT, lon, lat, nlon, Date) %>%
  # filter(lat > 20 & lat < 60, lon > 130 & lon < 220) # This filters for origin of AR. Use it later!
# Add dates of levee breaches in the region
leve_df <- read.csv("Data/levee-breaches-by-date.csv", header = TRUE)
# Make new variable "Date" and ignore NA
leve_df$Date <- with(leve_df, ymd(sprintf('%04d%02d%02d', Year, Month, Day))) 
# Combine levee breach dates with dates in AR data
ar_breach <- ar_data %>% 
  inner_join(leve_df, by = "Date") 

# To do: Map all the ARs origin and end in the ar_breach table. Pick only ones that pass through CA.

# Now I want to show dates when there were breaches and ARs. How can I pick dates that occur in both tables? 
ggplot(ar_breach, aes(Date, Total_IVT)) + # show dates of ARs and IVTs
  geom_point(alpha = 1/3) 
ggplot(ar_breach, aes(Date, Total_IVT)) + # show dates of ARs and IVTs
  geom_line()
ggplot(ar_breach, aes(y = Landfall_lat, x = Landfall_lon, size = Total_IVT)) +
      geom_point() +
      coord_quickmap()
# Bar chart
ggplot(ar_breach, aes(Total_IVT)) + geom_bar(fill = "red") + theme_bw() +
  labs(title = "IVT by count") + theme_gray() 
# Categorize by IVT stregnth
  # create categories of IVT strength:  weak≥ 250–500, 
  # moderate≥ 500–750 strong≥ 750–1,000, extreme≥ 1,000–1,250, 
  # exceptional≥ 1,250 
catIVT <- cut(ar_breach$Total_IVT, breaks=c(250,500,750,1000,1250,1500), 
  labels=c("Weak", "Moderate","Strong", "Extreme", "Exceptional"), 
  right=FALSE) # this specifies starting at 250, 500, etc.
ar_breach$Total_IVT[1:10]
catIVT[1:10]
ggplot(ar_breach, aes(x = Date, y = Total_IVT, col = catIVT)) + #Need to group by dates!
  # geom_text(aes(label = lat.x, nlon.x)) + # How can I label lat, lon of points?
  geom_point() +
  ylim(250, NA) +
  labs(main = "AR Categories", x = "Year", y = "IVT kg m^-1 s^-1", col = "AR category \nbased on Ralph et al. 2019") 
# How do I get NA off the legend? How do I reverse order of legend?
# Need to add flood data post-2010!
# I want to show lat.x, lon.x for some points (adding text) 

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
