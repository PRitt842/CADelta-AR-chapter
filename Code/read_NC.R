library(ncdf4)
library(raster)
# open nc file
ncin <- nc_open("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc")
ncin
varname <- names(ncin$var)
varname
b <- brick("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc", varname = 'lfloc', level=3)
b
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
# convert time -- split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
library(chron)
chron(time,origin=c(tmonth, tday, tyear))
# create raster brick
b <- brick("data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc", varname = 'lfloc')
# b <- crop(b, extent(-121, -122, 37, 38))
b <- crop(b, extent(144, 146, 14, 16))

# get lfloc
dname <- "lfloc"  
# lf_array <- ncvar_get(ncin,dname)
# dlname <- ncatt_get(ncin,dname,"long_name")
# dunits <- ncatt_get(ncin,dname,"units")
# fillvalue <- ncatt_get(ncin,dname,"_FillValue")
# dim(lf_array)
# replace netCDF fill values with NA's
# lf_array[lf_array==fillvalue$value] <- NA
# length(na.omit(as.vector(lf_array[,,1])))
nc_close(ncin)

