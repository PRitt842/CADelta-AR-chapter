library(ncdf4)
library(raster)
# open nc file
ncin <- nc_open("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc")
ncin
# read raster
ARras <- raster("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc", varname = 'lfloc', band = 1)
ARras
plot(ARras)

b <- brick("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc", varname = 'lfloc')

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
nc_close(ncin)
