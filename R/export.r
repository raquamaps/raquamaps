export_am_csv <- function(tbl) {
  res <- tbl %>% select(species, loiczid, prod_p, geomprod_p)
  fname <- paste0(tempfile(), ".csv")
  # "_", sub("\\s", "_", .latinname), ".csv")  
  message("exporting csv results to ", fname)  
  write.csv(res, file = fname, row.names = FALSE)    
}

presence_rgbif <- function(
  latinname = default_species(),
  maxlimit = 10000) {
  
  message("Getting data from gbif.org can be slow... ")
  
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

rasterize_presence <- function(occs = presence_rgbif()) {  
  o <- na.omit(data.frame(occs$decimalLongitude, occs$decimalLatitude))
  r <- rasterize(SpatialPoints(o), raster(ncol = 720, nrow = 360), fun = "count")
  return (r)
}

which_cells_in_raster <- function(r) {
  loiczids <- which(values(r) > 0)
  return (loiczids)
}

plot_am_raster <- function(r) { 
  breakpoints <- c(0, 0.2, 0.4, 0.6, 0.8, 1)
  colors <- brewer.pal(5, "PuRd")
  plot(r, ylim = c(20, 75), xlim = c(-5, 50), #main = species,
     col = colors, breaks = breakpoints)
}
