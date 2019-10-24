# download AR nc data
dir.create("data-raw/", F, T)
# AR data
download.file(
  "https://ucla.app.box.com/v/ARcatalog/folder/16460775063",
  "data-raw/globalARcatalog_MERRA2_1980-2019_v2.0.nc"
)