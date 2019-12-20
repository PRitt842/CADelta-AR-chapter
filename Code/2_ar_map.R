# Make map showing all storms that pass through the region. Facet by year.
library(maps)
library(ggplot2)
library(sf)

global_ar <- read.csv('Data/globalAR_1980-2019.csv', header=TRUE) #read AR global data (csv file modified from Bin Guan's txt file)
colnames(global_ar)[10] = "Equatorwd_end_lat" #correct mispelled column
colnames(global_ar)
#convert longitude coordinates from 0-360 to -180 to 180: Centroid_lon, Equatorwd_end_lon

ncent_lon <- ifelse(global_ar$Centroid_lon > 180, -360 + global_ar$Centroid_lon, global_ar$Centroid_lon) 
global_ar$ncent_lon <- with(global_ar, ncent_lon) #add to global_ar
nequat_lon <- ifelse(global_ar$Equatorwd_end_lon > 180, -360 + global_ar$Equatorwd_end_lon, global_ar$Equatorwd_end_lon) 
global_ar$nequat_lon <- with(global_ar, nequat_lon) #add to global_ar
colnames(global_ar)

delta_boundary <- st_read("Data/Legal_Delta_Boundary.shp")
colnames(delta_boundary)

ggplot(delta_boundary) +
  geom_sf()


###
ggplot() + 
  geom_sf(data = delta_boundary, size = 3, color = "black", fill = "cyan1") + 
  ggtitle("Delta Boundary Plot") + 
  coord_sf()

usa <- map_data('usa')
ggplot(usa) + 
  geom_sf() 

p <- ggplot(usa, aes(x=long, y=lat)) + 
  geom_polygon(usa, aes(x=long, y=lat, group=group)) +
  geom_point(data=countries, aes(x=Longitude, y=Latitude, colour="blue"), size=5, alpha=I(0.7))
