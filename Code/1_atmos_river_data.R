library(tidyverse) 
library(ggplot2) 
library(readr)
global_ar <- read.csv('Data/globalAR_1980-2019.csv', header=TRUE) #read AR global data (csv file modified from Bin Guan's txt file)
colnames(global_ar) #get column names
colnames(global_ar)[19] = "lfloc_lon" #change name of Landfall_lon
colnames(global_ar)[20] = "lfloc_lat" #change name of Landfall_lat
colnames(global_ar)[10] = "Equatorwd_end_lat" #correct mispelled column
library(lubridate)
nlfloc_lon <- ifelse(global_ar$lfloc_lon > 180, -360 + global_ar$lfloc_lon, global_ar$lfloc_lon) #convert coordinates from 0-360 to -180 to 180
global_ar$nlfloc_lon <- with(global_ar, nlfloc_lon) #add nlfloc_lon to global_ar
global_ar$Date <- with(global_ar, ymd(sprintf('%04d%02d%02d', Year, Month, Day)))  ##make new variable "Date" combining year, month, day
ar_west <- global_ar %>% 
  filter(lfloc_lat > 30 & lfloc_lat < 50, lfloc_lon > 230 & lfloc_lon < 250) #look at only ARs that landed in the US west coast
  
floods <- read.csv('Data/flood_sheet.csv', header=TRUE) #read data of known floods
floods$Date <- with(floods, ymd(sprintf('%04d%02d%02d', Year, Month, Day))) #add variable Date
floods$nFlood_date <- with(floods, ymd(sprintf('%04d%02d%02d', Year, Month, Day))) #correct formate for flood only dates
#winter_floods <- floods %>% 
  #mutate(stat_year = ifelse(month(Date) %in% c(9:12), year(Date) + 1, year(Date))) %>% #add varaible for seasonal year classificiation
  #filter(month(Date) %in% c(1:3, 9:12)) #only look at winter months

daily_ivt <- ar_west %>% 
  group_by(Date) %>% #group by Date
  summarise(TIVT = max(Total_IVT)) #aggregate daily IVT by highest value

dmatch <- floods %>% #join data tables
  right_join(daily_ivt, copy = TRUE) %>% #add flood dates; keep all observations in daily_ivt
  mutate(flood_year = ifelse(month(Date) %in% c(9:12), year(Date) + 1, year(Date))) %>% #add flood years
  filter(month(Date) %in% c(1:3, 9:12)) #only look at winter months
# I will need an 7 day window added before Date of flood
# sample: df %>% mutate(Date_prior1 = Date - 1)

catIVT <- cut(dmatch$TIVT, breaks=c(250,500,750,1000,1250,1500), #set categories for AR strength
              labels=c("Weak", "Moderate","Strong", "Extreme", "Exceptional"), 
              right=FALSE) # this specifies starting at 250, 500, etc.
dmatch$TIVT_max[1:10]
catIVT[1:10]

ggplot(dmatch) +
  geom_histogram(aes(x = flood_year), binwidth = 0.5) + #count of #of ARs by water year
  labs(title = "ARs making landfall in the region", x = "Water Year", y = "# of ARs") 

#What were conditions in the week prior to each flood?
dmatch <- dmatch %>%
  mutate(prior_week = nFlood_date - weeks(1)) #create variable for 7 days prior to each flood date
##pick up here
ggplot(dmatch, aes(Flood_date_prior, TIVT)) + 
  geom_boxplot(aes(x = Flood_date)) #IVT around time of floods


ggplot(dmatch, aes(Date, TIVT, col = catIVT)) + 
  geom_point(aes(group = nFlood_date)) + #plot points=flood dates +
  ylim(250, 1500) +
  scale_colour_discrete(na.translate = F) + #remove NA from legend
  labs(title = "ARs in the D \ncategories from Ralph et al. 2019", x = "Year", y = "IVT kg m^-1 s^-1", col = "Strength") 

daily_precip <- read.csv('Data/daily-precip-1940-2018.csv', header=TRUE) #read daily precipitation data
dmy()
###
#stop here
#facet test below
ggplot(dmatch, aes(Flood_date, TIVT, col = catIVT)) + 
  geom_point() + #plot points=flood dates
  ylim(250, 1500) +
  scale_colour_discrete(na.translate = F) + #remove NA from legend
  labs(title = "ARs in the D \ncategories from Ralph et al. 2019", x = "Year", y = "IVT kg m^-1 s^-1", col = "Strength") + #subset flood years  
  facet_wrap(~ flood_year)

usa <- map_data("usa")
usa
p <- ggplot() + 
  geom_polygon(usa, aes(x=long, y=lat, group=group)) +
  geom_point(ar_west, aes(x=Centroid_lon, y=Centroid_lat, colour="blue"), size=5, alpha=I(0.7))


#sample
ggplot(dmatch, aes(nFlood_date, Date)) + 
  geom_boxplot() +
  geom_line(aes(group = Total_IVT_max), colour = "#3366FF", alpha = 0.5)
  
# geom_text(aes(label = lat.x, nlon.x)) + # How can I label lat, lon of points?

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

# Bar chart
ggplot(ar_breach, aes(Total_IVT)) + geom_bar(fill = "red") + theme_bw() +
  labs(title = "IVT by count") + theme_gray() 
 
# How do I reverse order of legend?
# Need to add flood data post-2010!
# I want to show lat.x, lon.x for some points (adding text) 

# Bar chart
ggplot(ar_breach, aes(Total_IVT)) + geom_bar(fill = "red")+theme_bw()+
  scale_x_continuous("IVT", breaks = seq(250,1500)) +
  scale_y_continuous("Year", breaks = seq(1980,2010,5)) +
  coord_flip()+ labs(title = "Bar Chart") + theme_gray()

# Map ARs (landfall locations) on dates of flood events. Plot by flood years?


# What ARs led to catastrophic flooding? Then, look for other ARs of similar IVT not aligned w/ floods.
