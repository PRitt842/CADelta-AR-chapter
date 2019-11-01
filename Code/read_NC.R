library(ncdf4)
library(raster)
# open nc file
ncin <- nc_open("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc")
ncin
varname <- names(ncin$var)
varname
b <- brick("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc", varname = 'lfloc', level=3)

# b <- brick("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc", varname = 'lfloc', lvar=4)
# NAvalue(b) <- 9e+20
plot(b)
# I get: Error in ncvar_get_inner(ncid2use, varid2use, nc$var[[li]]$missval, addOffset,  : 
# Error: variable has 5 dims, but start has 4 entries.  They must match!
# read raster
ARras <- raster("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc", varname = 'lfloc', band = 1)
# Again, I get: Warning message:
  # In .rasterObjectFromCDF(x, type = objecttype, band = band, ...) :
  # lfloc has more than 4 dimensions, I do not know what to do with these data
ARras

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
