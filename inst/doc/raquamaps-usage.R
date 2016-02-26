## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------
# in this session we need a few packages
# for data manipulation, raster operations
# and we load raquamaps, of course
require("ggplot2")
require("leaflet")
require("dplyr")
require("raster")
require("sp")
require("raquamaps")
require("ggmap")

# helper to load data from the package
get_data <- function(x) tbl_df(get(data(list = x)))

# get occurrence data (points) for The Great White Shark
o <- get_data("rgbif_great_white_shark")

o

## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------
occs_ggmap_points(o)

## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------
r <- rasterize_occs(o)

## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------
#occs_ggmap_gridded_polys(r)
occs_ggmap_gridded(r, legend = FALSE)

## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------

# are there observations outside Cape Town?
p <- ggmap::geocode("Cape Town", source = "google")
occs_ggmap_gridded(r, center = p, padding = 15)

# what about outside SF?
p <- ggmap::geocode("San Francisco", source = "google")
occs_ggmap_gridded(r, center = p, padding = 20)

# around the Seychelles?
p <- ggmap::geocode("Seychelles", source = "google")
occs_ggmap_gridded(r, center = p, padding = 30)

# Australian East-Coast?
p <- ggmap::geocode("Surfer's Paradise", source = "google")
occs_ggmap_gridded(r, center = p, padding = 10)


## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------
occs_webmap_gridded(trim(r))

## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------
o <- get_data("rgbif_galemys_pyrenaicus")
occs_ggmap_points(o)

## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------
qplot(data = o, x = decimalLatitude, 
      y = decimalLongitude, xlab = "", ylab = "")

## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------
o <- o %>% 
  filter((!is.na(decimalLatitude)), (!is.na(decimalLongitude))) %>%
  filter(!(decimalLatitude == 0 & decimalLongitude == 0)) %>%
  filter(decimalLatitude < 45)

# look at histograms for coordinates for a sanity check
hist(o$decimalLatitude)
hist(o$decimalLongitude)

# compile the summary grid, 
# trim the grid and map it
r <- rasterize_occs(o)
occs_ggmap_gridded(trim(r), legend = FALSE)
occs_ggmap_gridded(trim(r), legend_title = "Galemys pyrenaicus (n)")

## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------
# look at frequencies of different values represented in the raster
freq(r)

# look at a histogram of values in the raster
hist(values(r))

# quickly plot the raster
image(trim(r), xlab = NA, ylab = NA)
#spplot(trim(r))
#quantile(r, na.rm = TRUE)

## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------

