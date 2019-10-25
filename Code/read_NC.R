library(RColorBrewer)
library(lattice)
library(ncdf4)
library(chron)
library(RNetCDF)
library(tidyverse)
reanalys <- nc_open("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc")
print(reanalys)
# get lon and lat
lat <- ncvar_get(reanalys, "lat")
nlat <- dim(lat)
head(lat)
lon <- ncvar_get(reanalys, "lon")
nlon <- dim(lon)
head(lon)
print(c(nlon,nlat))
#get time
time <- ncvar_get(reanalys, "time")
head(time)
tunits <- ncatt_get(reanlys,"time","units")
nt <- dim(time)
nt
tunits
nc_close(reanalys)
