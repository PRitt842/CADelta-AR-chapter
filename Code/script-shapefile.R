library(sf)
library(ggplot2)
delta_boundary <- st_read(
  "Data/Legal_Delta_Boundary.shp")
delta_boundary
ggplot() + 
  geom_sf(data = delta_boundary, size = 3, color = "black", fill = "cyan1") + 
  ggtitle("Delta Boundary Plot") + 
  coord_sf()
