library(ncdf4)
library(raster)
ncin <- nc_open("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc")
print(ncin)
# get lon and lat
lat <- ncvar_get(ncin, "lat")
nlat <- dim(lat)
head(lat)
lon <- ncvar_get(ncin, "lon")
nlon <- dim(lon)
head(lon)
print(c(nlon,nlat))
#get time
time <- ncvar_get(ncin, "time")
head(time)
tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)
nt
tunits
# read raster
raster <- raster("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc", varname = 'lfloc')
nc_close(ncin)

