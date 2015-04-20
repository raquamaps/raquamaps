
# The dropbox folder: https://www.dropbox.com/sh/shnwvh1126f4wi9/_8Wf9m0atV
# The HCAF shapefile: https://www.dropbox.com/sh/7yzcbdgm5m9axht/PUnf7vugFc


#create(path="~/aqua-maps/raquamaps")

require("devtools")
load_all()
document()
test()

build()
install()
check()

require("raquamaps")
dev_help("get_dropbox_as_zip")
data(package = "raquamaps")

#get_dropbox_as_zip("7yzcbdgm5m9axht/PUnf7vugFc", "inst/extdata")
# clean ref data for Galemys pyrenaicus (shapefiles w HCAF, HDC grids)

store_dbf_as_rds <- function(dbf) {
  zipfile <- file.path(getwd(), "inst/extdata/Files.zip")  
  destdir <- tempdir()
  tmp <- unzip(zipfile, files=dbf, overwrite=TRUE, exdir=destdir)
  require("foreign")  
  require("tools")
  varname <- paste0("aquamapsdata_", file_path_sans_ext(basename(dbf)))
  assign(varname, read.dbf(file=tmp))
  unlink(tmp)  
  rdafile <- file.path("data", paste0(varname, ".rda"))  
  save(list=as.vector(varname), file=rdafile)
}

store_csv_as_rda <- function(csvfile) {
  require("tools")
  f <- file.path(getwd(), "inst/extdata/", csvfile)
  varname <- paste0("aquamapsdata_", file_path_sans_ext(basename(f)))
  assign(varname, read.csv2(file = f))
  rdafile <- file.path(getwd(), "data", paste0(varname, ".rda"))
  save(list = as.vector(varname), file = rdafile)  
}

store_csv_as_rda("presence_basins.csv")
store_csv_as_rda("presence_occurrences.csv")

rdsfiles <- dir(pattern="*.rds")

load_rds_like_rda <- function(rdsfile) {
  require("tools")
  varname <- file_path_sans_ext(basename(rdsfile))
  assign(varname, readRDS(rdsfile))
}

sapply(rdsfiles, load_rds_like_rda)

install_data_from_zip <- function(zipfile) {
  zfiles <- unzip(zipfile, list = TRUE)
  idx <- grep(zfiles$Name, pattern="*.dbf")
  dbfs <- zfiles[idx, ]$Name
  require("plyr")
  a_ply(dbfs, 1, store_dbf_as_rds)  
}

#get_dropbox_as_zip("rls0susnj7knpak/hivLtqOHRA", "inst/extdata") 
install_data_from_zip("inst/extdata/Files.zip")

# adding explicit reference data to package
hcaf <- read.dbf("inst/extdata/HCAF_EU_Grid_WGS84.dbf")
saveRDS(hcaf, "data/hcaf.rds")

# presenting suggestions for logos for the raquamaps pkg

browseURL(system.file("www/index.html", package="raquamaps"))

require("devtools")
devtools::build_vignettes()
