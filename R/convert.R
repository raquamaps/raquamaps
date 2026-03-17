#' Converts presence data from rgbif into raster data
#'
#' @param occs data frame with coordinates, from rgbif
#' @return a terra SpatRaster grid with individual cell values representing
#' the count of occurrences within the grid cells
#' @export
rasterize_presence <- function(occs = presence_rgbif()) {
  o <- stats::na.omit(data.frame(x = occs$decimalLongitude, y = occs$decimalLatitude))
  v <- terra::vect(o, geom = c("x", "y"), crs = "EPSG:4326")
  hdc <- terra::rast(ncol = 720, nrow = 360, crs = "EPSG:4326")
  r <- terra::rasterize(v, hdc, fun = "count")
  return(r)
}

#' Converts points in data frame into raster
#'
#' @param df data frame with coordinates in
#' decimalLongitude, decimalLatitude columns
#' @return a half degree terra SpatRaster grid with individual cell values
#' representing the count of occurrences within the grid cells
#' @export
rasterize_occs <- function(df) {
  xy <- stats::na.omit(data.frame(x = df$decimalLongitude, y = df$decimalLatitude))
  v <- terra::vect(xy, geom = c("x", "y"), crs = "EPSG:4326")
  hdc <- terra::rast(ncol = 720, nrow = 360, crs = "EPSG:4326")
  r <- terra::rasterize(v, hdc, fun = "count")
  return(r)
}


#' Raster grid cell identifiers with presence
#' @param r a terra SpatRaster
#' @param lower_limit raster cell values higher than this parameter
#' is interpreted as presence
#' @return a vector of raster grid cell identifiers (loiczids)
#' @export
which_cells_in_raster <- function(r, lower_limit = 0) {
  loiczids <- which(terra::values(r, mat = FALSE) > lower_limit)
  return(loiczids)
}

#' Discretize a raster into intervals or steps for chloropeth maps
#' @param r a terra SpatRaster
#' @param n number of steps to use, default being five steps
#' @param interval_style a character string with classInt interval
#' styles, defaulting to "fisher", but can be "quantile", "equal"
#' (see classIntervals docs)
#' @return a list with the raster (discretized) and breaks (intervals)
#' @export
stepped_raster <- function(r, n = 5, interval_style = "fisher") {
  v <- stats::na.omit(terra::values(r, mat = FALSE))
  ints <- classInt::classIntervals(v,
    n = n,
    style = interval_style, na.rm = TRUE, unique = FALSE
  )
  n_obs <- cut(terra::values(r, mat = FALSE), breaks = ints$brks)
  breaks <- levels(n_obs)
  message("Discretizing this raster using intervals:\n", breaks)
  o <- terra::rast(r)
  terra::values(o) <- as.integer(n_obs)
  out <- list(raster = o, breaks = breaks)
  return(out)
}

#' Converts a raster grid into a dataframe of closed polygons which
#' can be plotted with ggplot
#' @param r a terra SpatRaster
#' @return a data frame with columns long, lat, group, bin
#' @export
r2df_polygons <- function(r) {
  r_masked <- terra::ifel(r > 0, r, NA)
  polys <- terra::as.polygons(r_masked, dissolve = FALSE)
  polys_sf <- sf::st_as_sf(polys)
  bin_col <- names(polys_sf)[1]

  out <- do.call(rbind, lapply(seq_len(nrow(polys_sf)), function(i) {
    coords <- sf::st_coordinates(polys_sf[i, ])
    data.frame(
      long  = coords[, "X"],
      lat   = coords[, "Y"],
      group = i,
      bin   = polys_sf[[bin_col]][i]
    )
  }))
  tibble::as_tibble(out)
}

#' Converts a raster grid into a dataframe of points which
#' can be plotted with ggplot
#' @param r a terra SpatRaster
#' @return a data frame with cell grid coordinates and values
#' in columns x, y, z
#' @export
r2df_points <- function(r) {
  crds <- terra::crds(r, na.rm = FALSE)
  vals <- terra::values(r, mat = FALSE)
  df <- tibble::tibble(x = crds[, 1], y = crds[, 2], z = vals)
  dplyr::filter(df, z > 0, !is.na(z))
}
