require("rgbif")

# get the key for a specific taxon name
key <- name_backbone(name = "Galemys pyrenaicus")
key <- key$speciesKey

# use the key to get at the most 10 000 occurrence places
occs <- occ_search(taxonKey = key, results = "data", limit = 10000)

# pick out only relevant fields for coords and country
o <- 
  tbl_df(occs$data) %>%
  select(
    decimalLatitude, 
    decimalLongitude, 
    geodeticDatum, 
    countryCode, 
    vernacularName)

# quickly plot the data
require("ggplot2")
qplot(data = o, x = decimalLongitude, y = decimalLatitude)

# get the half degree cell grid data

hdc <- get(data("aquamapsdata_Hdc_grid"))
hdc <- rename(hdc, loiczid = LOICZID)
rownames(hdc) <- hdc$loiczid

require("raster")
require("sp")

hdc_points <- SpatialPointsDataFrame(
  proj4string = CRS("+init=epsg:4326"),
  data = hdc, coords = data.frame(hdc$CenterLong, hdc$CenterLat))

# turns out that the loiczid ids match the raster id values!
# so no need to do a mapping
r3 <- rasterize(hdc_points, r, field = "loiczid")
lookup <- data.frame(id = 1:ncell(r3), loiczid = values(r3))
#mapping <- data.frame(val = getValues(hdc_points), id = hdc_points@data$loiczid)



points <- SpatialPoints(na.omit(data.frame(o$decimalLongitude, o$decimalLatitude)))
r2 <- rasterize(points, r, fun = "count")
loiczids <- which(values(r2) > 0)
r2[loiczids]
image(r2)

export_probs_as_raster <- function(.latinnames) {
  
  require("raster")
  
  # LOICZ ID numbers are long integers from 1 to 259200. 
  # They begin with the cell centered at 89.75 degrees N latitude 
  # and 179.75 degrees W latitude and proceed from West to East. 
  # When a full circle of 720 cells is completed, 
  # the numbering steps one cell south 
  # along the -180 meridian and continues sequentially west to east.
  
  r <- raster(ncol = 720, nrow = 360)
  # res(r)
  # ncell(r)
  #loiczids <- goodcellz[species][[1]]$loiczid
    
  #a <- area(r)
  #lat <- yFromRow(r, 1:nrow(r))
  #long <- xFromCol(r, 1:ncol(r))
  #area <- a[,1]
  #plot(area, lat)

  
  
  # calc probs for a specific species
  # retrieve all the loiczid (cells) 
  # plot the p values in those cells  
  
#  loiczids <- hcaf_df$loiczid
#  p <- probz[species][[1]]$geomprod_p  
#  values(r)[loiczids] <- p  
  return(r)
}

# change the species variable and run the code below to 
# inspect the raster

species <- species_list$species[4]
r <- export_probs_as_raster(species)
require("RColorBrewer")
#breakpoints <- c(0, 0.01, 0.05, 0.2, 0.4, 1)
breakpoints <- c(0, 0.2, 0.4, 0.6, 0.8, 1)
colors <- RColorBrewer::brewer.pal(5, "PuRd")
plot(r, ylim = c(20, 75), xlim = c(-5, 50), main = species,
     col = colors, breaks = breakpoints)

