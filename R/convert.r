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

#' Converts points in data frame into raster
#' 
#' @param df data frame with coordinates in 
#' decimalLongitude, decimalLatitude columns
#' @return a half degree raster grid with individual cell values representing 
#' the count of occurrences within the grid cells
#' @export
rasterize_occs <- function(df) {
  lon <- df$decimalLongitude
  lat <- df$decimalLatitude
  xy <- na.omit(data.frame(lon, lat))
  leaflet_crs <- sp::CRS(leaflet:::epsg4326)
  points <- sp::SpatialPoints(proj4string = leaflet_crs, coords = xy)
  # rasterize the points that have coordinates
  hdc <- raster(ncol = 720, nrow = 360, crs = leaflet_crs)
  r <- rasterize(points, hdc, fun = "count")
  return(r)
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

#' Discretize a raster into intervals or steps for chloropeth maps
#' @param r raster
#' @param n number of steps to use, default being five steps
#' @param interval_style a character string with classInt interval
#' styles, defaulting to "fisher", but can be "quantile", "equal" 
#' (see classIntervals docs)
#' @return a list with the raster (discretized) and breaks (intervals)
#' @export
stepped_raster <- function(r, n = 5, interval_style = "fisher") {
  v <- na.omit(values(r))
  ints <- classInt::classIntervals(v, n = 5, 
                                   style = interval_style, na.rm = TRUE, unique = FALSE)
  #n_obs <- .bincode(values(r), breaks = ints$brks)
  n_obs <- cut(values(r), breaks = ints$brks)
  breaks <- levels(n_obs)
  message("Discretizing this raster using intervals:\n", breaks)
  o <- raster(r)
  values(o) <- n_obs
  out <- list(raster = o, breaks = breaks)
  return (out)
}

#' Converts a raster grid into a dataframe of closed polygons which 
#' can be plotted with ggplot
#' @param raster a raster layer
#' @return a data frame with the cell grid as polygons
#' @export
r2df_polygons <- function(raster) {
  r <- raster
  # convert the raster to closed polygons 
  # which could become geoJSON
  #pps <- rasterToPolygons(r)
  #wkt <- rgeos::writeWKT(pps)
  # limit to cells with values, ie only for cells with values > 0?
  cid <- which(values(r) > 0)
  polygons <- NULL
  for (i in cid) {
    cell <- rasterFromCells(r, i)
    e <- extent(cell)
    x <- c(e@xmin, e@xmax, e@xmax, e@xmin, e@xmin)
    y <- c(e@ymax, e@ymax, e@ymin, e@ymin, e@ymax)
    p <- Polygon(cbind(x, y), hole = FALSE)
    ps <- Polygons(list(p), i)
    df <- ggplot2::fortify(ps)
    df$group <- i
    df$bin <- values(r)[i]
    polygons <- rbind(polygons, df)
  }
  return (tbl_df(polygons))
}

#' Converts a raster grid into a dataframe of points which 
#' can be plotted with ggplot
#' @param raster a raster layer
#' @return a data frame with the cell grid coordinates and values 
#' in a data frame with columns x, y, z
#' @export
r2df_points <- function(raster) {
  r <- raster
  cx <- coordinates(r)[ ,1]
  cy <- coordinates(r)[ ,2]
  df <- data.frame(x = cx, y = cy, z = values(r))
  res <- 
    tbl_df(df) %>% 
    filter(z > 0, !is.na(z))
  return(res)
}