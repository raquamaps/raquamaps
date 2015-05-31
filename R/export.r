#' Export results from as csv (tempfile)
#' 
#' @param tbl data frame with results from calc_probs
#' @return filename for temp file with csv results
#' @export
export_am_csv_tmp <- function(tbl) {
  res <- tbl %>% select(species, loiczid, prod_p, geomprod_p)
  fname <- paste0(tempfile(), ".csv")
  # "_", sub("\\s", "_", .latinname), ".csv")  
  message("exporting csv results to ", fname)  
  write.csv(res, file = fname, row.names = FALSE)
  return (fname)
}

#' Get presence data using rgbif
#' 
#' @param latinname string with latin name for species
#' @param maxlimit upper limit for number of rows to return
#' @return data frame with coordinates, country and vernacular name
#' @export
presence_rgbif <- function(
  latinname = default_species(),
  maxlimit = 10000) {
  
  message("Patience please, getting data from gbif.org can be slow... ")
  
  key <- name_backbone(name = latinname)
  key <- key$speciesKey

  occs <- occ_search(taxonKey = key, 
    results = "data", limit = maxlimit)

  # pick out only relevant fields 
  # for coords and country
  o <- 
    tbl_df(occs$data) %>%
    select(
      decimalLatitude, 
      decimalLongitude, 
      geodeticDatum, 
      countryCode, 
      vernacularName)
  
  return (o)
}



# # get the half degree cell grid data
# hdc <- get(data("aquamapsdata_Hdc_grid"))
# hdc <- rename(hdc, loiczid = LOICZID)
# rownames(hdc) <- hdc$loiczid

# require("raster")
# require("sp")
# 
# hdc_points <- SpatialPointsDataFrame(
#   proj4string = CRS("+init=epsg:4326"),
#   data = hdc, coords = data.frame(hdc$CenterLong, hdc$CenterLat))
# 
# # turns out that the loiczid ids match the raster id values!
# # so no need to do a mapping
# r3 <- rasterize(hdc_points, r, field = "loiczid")
# lookup <- data.frame(id = 1:ncell(r3), loiczid = values(r3))
# #mapping <- data.frame(val = getValues(hdc_points), id = hdc_points@data$loiczid)

#' Converts presence data from rgbif into raster data 
#' 
#' @param occs data frame with coordinates, from rgbif
#' @return a raster grid with individual cell values representing 
#' the count of occurrences within the grid cells
#' @export
rasterize_presence <- function(occs = presence_rgbif()) {  
  o <- na.omit(data.frame(occs$decimalLongitude, occs$decimalLatitude))
  r <- rasterize(SpatialPoints(o), 
    raster(ncol = 720, nrow = 360), fun = "count")
  return (r)
}

#' Raster grid cell identifiers with presence
#' @param r raster
#' @param lower_limit raster cell values higher than this parameter
#' is interpreted as presence
#' @return a vector of raster grid cell identifiers (loiczids)
#' @export
which_cells_in_raster <- function(r, lower_limit = 0) {
  loiczids <- which(values(r) > lower_limit)
  return (loiczids)
}

#' Plot raster data in raquamaps style
#' @param r raster
#' @return plot of the raster
#' @export
plot_am_raster <- function(r) { 
  breakpoints <- c(0, 0.2, 0.4, 0.6, 0.8, 1)
  colors <- brewer.pal(5, "PuRd")
  plot(r, ylim = c(20, 75), xlim = c(-5, 50), #main = species,
     col = colors, breaks = breakpoints)
}
