# This file documents various steps during the package 
# development that may be important for future maintenance reasons

# create(path="~/aqua-maps/raquamaps")

require("devtools")
load_all()
document()
test()

build()
install()
check()

build_vignettes()

require("raquamaps")
dev_help("get_dropbox_as_zip")
data(package = "raquamaps")



# Documentation of procedures for getting reference data into the package

# Onesimme dropbox folder: https://www.dropbox.com/sh/shnwvh1126f4wi9/_8Wf9m0atV
# The HCAF shapefile: https://www.dropbox.com/sh/7yzcbdgm5m9axht/PUnf7vugFc

# get_dropbox_as_zip("7yzcbdgm5m9axht/PUnf7vugFc", "data-raw")
# clean ref data for Galemys pyrenaicus (shapefiles w HCAF, HDC grids)

store_dbf_as_rds <- function(dbf) {
  zipfile <- file.path(getwd(), "data-raw/Files.zip")  
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
  f <- file.path(getwd(), "data-raw/", csvfile)
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
install_data_from_zip("data-raw/Files.zip")

# adding explicit reference data to package
hcaf <- read.dbf("data-raw/HCAF_EU_Grid_WGS84.dbf")
saveRDS(hcaf, "data/hcaf.rds")

# getting sqlite3 data from converted mdb into a data frame
library("dplyr")
devtools::use_data_raw()
# data-raw contains to shell scripts that a) download the
# full hcaf data from dropbox b) converts to sqlite3 db format
# after which the following reads the data and stores it in the pkg
refdata <- src_sqlite("data-raw/hcaf.db")
#src_tbls(refdata)
aquamaps_hcaf_world <- 
  collect(tbl(refdata, "HCAF")) %>%
  # Filtering out columns, but all could be included if needed
  select(LOICZID, FAO = FAOAreaM, CountryMain, CountrySecond, CountryThird,
         # Renaming to comply with the EU grid col names
         CsquareCod = CsquareCode, 
         Islands = IslandsNo, 
         Basins = Basin, 
         # Bioclimate variable names as used in the EU grid
         SoilpH, SoilCarbon, 
         CTI_Max = CTI,
         Elevation = ElevationMean, 
         TempMonthM = TempMonthMean,
         NPP = NPPAnnual,
         SoilMoistu = SoilMoisture,
         PrecipAnMe = PrecipAnMean)

aquamaps_npp <- collect(tbl(refdata, "NPP"))
aquamaps_commoncells <- collect(tbl(refdata, "CommonCells_EuropeAsia_XY"))

n1 <- names(tbl_df(aquamapsdata_HCAF_EU_Grid_WGS84))
n2 <- names(aquamaps_hcaf_world)
require("raquamaps")
n3 <- default_clim_vars()

intersect(n2, n3)
setdiff(n2, n1)
setdiff(n1, n2)

setdiff(intersect(n2, n3), n3)
grep("emp", n2, value = TRUE)

gen_dox_dataset_rows <- function(cols) {
  template <- "#'   \\item{__COL__}{__COL__}"
  res <- sapply(cols, function(x) gsub("__COL__", x, template))
  out <- paste0(collapse = "\n", res)
  message("Paste this into your dataset dox")
  message("in data/aquamaps_refdata.r")
  message(out)
}

# Generete dox for dataset cols to paste into data/aquamaps_refdata.r
gen_dox_dataset_rows(names(aquamaps_hcaf_world))
# Save dataset into R package distro
use_data(internal = FALSE, aquamaps_hcaf_world, overwrite = TRUE)

aquamaps_hcaf_eu <- 
  tbl_df(aquamapsdata_HCAF_EU_Grid_WGS84) %>%
  select(CsquareCod, LOICZID, 
         Elevation, TempMonthM, PrecipAnMe, SoilpH, SoilMoistu, 
         SoilCarbon, CTI_Max, NPP, Islands, Basins)
n_eu <- names(aquamaps_hcaf_eu)
n_world <- names(aquamaps_hcaf_world)
message(paste0(collapse = ", ", intersect(n_eu, n_world)))
gen_dox_dataset_rows(names(aquamaps_hcaf_eu))
use_data(internal = FALSE, aquamaps_hcaf_eu, overwrite = TRUE)

# Package half degree cell metadata
aquamaps_hc <- 
  tbl_df(aquamapsdata_Hdc_grid) %>%
    select(-Id, -ET_ID)

gen_dox_dataset_rows(names(aquamaps_hc))
use_data(internal = FALSE, aquamaps_hc, overwrite = TRUE)

# tbl_df(aquamapsdata_presence_basins)
# [410,288 x 5]
# Contains info of cells with a species of a 
# certain category being present in a basin 
# Should be possible to get via rgbif instead?

aquamaps_presence_basins <-
  tbl_df(read.csv2("data-raw/presence_basins.csv"))
gen_dox_dataset_rows(names(aquamaps_presence_basins))
use_data(internal = FALSE, aquamaps_presence_basins, overwrite = TRUE)


# tbl_df(aquamapsdata_presence_occurrences)
# [39,307 x 4]
# Contains info of cells with latin names
# for species with presence
# Should be possible to get via rgbif instead?

aquamaps_presence_occurrences <-
  tbl_df(read.csv2("data-raw/presence_occurrences.csv"))
gen_dox_dataset_rows(names(aquamaps_presence_occurrences))
use_data(internal = FALSE, aquamaps_presence_occurrences, overwrite = TRUE)


# tbl_df(aquamapsdata_IUCN_galemys_pyrenaicus_WGS84)
# [1 x 16]
# Should be possible to get from web service?

# tbl_df(aquamapsdata_GoodCelles_galemys_pyrenaicus_WGS84)
# Source: local data frame [359 x 5]
# CsquareCod LOICZID InBassin GoodCell            Species
# 1  1300:380:3   73801        1        0 Galemys pyrenaicus
# What is the meaning of GoodCell?

aquamaps_galemys_pyrenaicus <- 
  tbl_df(aquamapsdata_GoodCelles_galemys_pyrenaicus_WGS84) %>%
  rename(InBasin = InBassin)
gen_dox_dataset_rows(names(aquamaps_galemys_pyrenaicus))
use_data(internal = FALSE, aquamaps_galemys_pyrenaicus, overwrite = TRUE)

rgbif_galemys_pyrenaicus <- 
  presence_rgbif("Galemys pyrenaicus")
gen_dox_dataset_rows(names(rgbif_galemys_pyrenaicus))
use_data(internal = FALSE, rgbif_galemys_pyrenaicus, overwrite = TRUE)

rgbif_great_white_shark <- 
  presence_rgbif("Carcharodon carcharias")
gen_dox_dataset_rows(names(rgbif_great_white_shark))
use_data(internal = FALSE, rgbif_great_white_shark, overwrite = TRUE)


# tbl_df(aquamapsdata_GBIF_galemys_pyrenaicus_WGS84)
# Source: local data frame [493 x 15]
# This contains rgbif type data, should replace with new data
# from rgbif!


# presenting suggestions for logos for the raquamaps pkg
browseURL(system.file("www/index.html", package="raquamaps"))



# Explicit listing of names of relevant datasets 
# that are bundled into the package
ds <- c(
  # half degree cell authority file w bioclimate data for EUR
  "aquamapsdata_HCAF_EU_Grid_WGS84", 
  # presence data for one species
  "aquamapsdata_GoodCelles_galemys_pyrenaicus_WGS84",  
  # presence data for several species
  "aquamapsdata_presence_occurrences",
  # 493 occ of "Galemys pyrenaicus" with coords from GBIF Spain
  "aquamapsdata_GBIF_galemys_pyrenaicus_WGS84",
  # world grid in half degree cells including identifiers ("loiczid" etc)
  "aquamapsdata_Hdc_grid",
  # one row of IUCN info on Galemys pyrenaicus (to be removed)
  "aquamapsdata_IUCN_galemys_pyrenaicus_WGS84",
  # refdata for some species, including their cateogry and
  # presence (loiczid) with waster basin flag
  "aquamapsdata_presence_basins"
)



