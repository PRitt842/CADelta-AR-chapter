## This code is to map stations with precip data to see their proximity to the Delta.
library(tidyverse)
library(ggplot2)
library(tmap)
library(tmaptools)
library(sf)
library(leaflet)
sta.dat <- read_csv('Data/CDEC_Precip_Stations.csv')
sta.dat
# Make markers for each station
leaflet(data = sta.dat) %>% addTiles() %>%
  addCircleMarkers(lng = ~Longitude, lat = ~Latitude)
# I can see that one station is far from study area so I need to remove it from the csv.
# "Station Name" = Crowder Flat" needs to be deleted from the table. It is row #34. How can I do that?
