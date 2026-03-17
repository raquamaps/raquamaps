#' Plot raster data in raquamaps style
#' @param r a terra SpatRaster (discretized, e.g. from stepped_raster)
#' @param breaks vector with character strings describing intervals
#' @param trim boolean to indicate whether the raster layer should be cropped
#' @return plot of the raster
#' @export
plot_stepped_raster <- function(r, breaks, trim = FALSE) {
  if (trim) r <- terra::trim(r)
  colors <- RColorBrewer::brewer.pal(7, "YlOrRd")[3:7]
  terra::plot(r, col = colors, legend = FALSE)
}

raquamaps_theme_gridded <- function() {
  out <-
    ggplot2::theme_bw() + ggplot2::theme(
      axis.text.x = ggplot2::element_text(size = 10),
      axis.text.y = ggplot2::element_text(size = 10),
      panel.background = ggplot2::element_blank(),
      plot.background = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank()
    )
  return(out)
}

raquamaps_theme <- function() {
  out <-
    ggplot2::theme(
      legend.position = "bottom",
      legend.key = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      panel.background = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.background = ggplot2::element_blank()
    )
  return(out)
}

#' Plots an occurrence data frame with points as a map using ggplot
#' @param occs a data frame with occurrence points
#' @return a ggplot
#' @export
occs_ggmap_points <- function(occs) {
  o <- occs %>%
    dplyr::rename(lat = decimalLatitude, lon = decimalLongitude) %>%
    dplyr::filter(!is.na(lat), !is.na(lon))
  xmin <- min(o$lon)
  xmax <- max(o$lon)
  ymin <- min(o$lat)
  ymax <- max(o$lat)
  world <- ggplot2::map_data(map = "world")
  map <-
    ggplot2::ggplot(world, ggplot2::aes(x = long, y = lat, group = group)) +
    ggplot2::geom_polygon(fill = "gray70", alpha = 0.4) +
    ggplot2::coord_fixed(
      xlim = c(xmin, xmax),
      ylim = c(ymin, ymax)
    ) +
    raquamaps_theme_gridded() +
    ggplot2::geom_point(
      data = o,
      ggplot2::aes(x = lon, y = lat, group = 0),
      alpha = 0.1, color = RColorBrewer::brewer.pal(5, "YlOrRd")[5]
    )
  return(map)
}

#' Plots a raster layer as a gridded map using ggplot
#' @param r a terra SpatRaster with occurrence points
#' @param legend a boolean indicating whether to include the color legend
#' @param legend_title a character string explaining which variable is displayed
#' @param center optional coordinate (numeric vector c(lon, lat)) to center
#' the map on
#' @param padding distance in degrees around the center to include in the map
#' @return a ggplot
#' @export
occs_ggmap_gridded <- function(
  r, legend = TRUE,
  legend_title = "Occurrences (n)", center, padding = 10
) {
  # discretize raster
  sr <- stepped_raster(r)
  r_5 <- sr$raster
  message("This is the stepped raster: ", utils::str(r_5))
  breaks <- sr$breaks
  message("Stepped raster reports interval breaks: ", breaks)

  # convert to df with values as factors with class intervals
  df <- r2df_points(r_5)
  df$z <- as.factor(df$z)
  levels(df$z) <- breaks

  e <- as.vector(terra::ext(r))
  if (!missing(center)) {
    p <- center
    pts <- rbind(p, p + padding, p - padding)
    bb <- sf::st_bbox(
      sf::st_as_sf(as.data.frame(pts), coords = c(1, 2), crs = "EPSG:4326")
    )
    e <- c(
      xmin = bb[["xmin"]], xmax = bb[["xmax"]],
      ymin = bb[["ymin"]], ymax = bb[["ymax"]]
    )
  }

  world <- ggplot2::map_data(map = "world")
  map <-
    ggplot2::ggplot(world, ggplot2::aes(x = long, y = lat, group = group)) +
    ggplot2::geom_polygon(fill = "gray70", alpha = 0.4) +
    ggplot2::coord_fixed(
      xlim = c(e["xmin"], e["xmax"]),
      ylim = c(e["ymin"], e["ymax"])
    ) +
    raquamaps_theme_gridded() +
    ggplot2::geom_raster(
      data = df,
      ggplot2::aes(x, y, fill = z, group = NULL)
    ) +
    ggplot2::scale_fill_brewer(
      type = "seq", palette = "YlOrRd",
      name = legend_title
    )
  if (!legend) map <- map + ggplot2::guides(fill = "none")
  return(map)
}

#' Plots a raster grid using ggplot and polygons
#' @param r a terra SpatRaster
#' @return a ggplot
#' @export
occs_ggmap_gridded_polys <- function(r) {
  sr <- stepped_raster(r, 5, "fisher")
  r_disc <- sr$raster
  breaks <- sr$breaks
  e <- as.vector(terra::ext(r_disc))
  cols <- RColorBrewer::brewer.pal(7, "YlOrRd")[3:7]
  polyg <- r2df_polygons(r_disc)
  world <- ggplot2::map_data(map = "world")
  map <-
    ggplot2::ggplot() +
    ggplot2::geom_polygon(
      data = world,
      ggplot2::aes(long, lat, group = group),
      fill = "gray90", color = "gray90", linewidth = 0.2
    ) +
    ggplot2::geom_polygon(
      data = polyg,
      ggplot2::aes(
        x = long, y = lat, group = group,
        fill = as.factor(bin)
      ), alpha = 0.8
    ) +
    ggplot2::scale_fill_manual(
      name = NA,
      labels = breaks,
      values = cols
    ) +
    ggplot2::labs(x = "", y = "") +
    raquamaps_theme() +
    ggplot2::coord_fixed(
      ratio = 1,
      xlim = c(e["xmin"], e["xmax"]),
      ylim = c(e["ymin"], e["ymax"])
    )
  return(map)
}

#' Plots a raster grid using leaflet
#' @param r a terra SpatRaster
#' @param legend_title the title for the color legend,
#' default is NA
#' @return a web map using leaflet
#' @export
occs_webmap_gridded <- function(r, legend_title = NA) {
  colors <- RColorBrewer::brewer.pal(7, "YlOrRd")[3:7]
  vals <- stats::na.omit(unique(terra::values(r, mat = FALSE)))
  pal <- leaflet::colorBin(colors, vals,
    bins = 5, pretty = TRUE, na.color = "transparent"
  )
  e <- as.vector(terra::ext(r))
  map <-
    leaflet::leaflet() |>
    leaflet::addProviderTiles(provider = "CartoDB.Positron") |>
    leaflet::addRasterImage(r, colors = pal, opacity = 0.8) |>
    leaflet::addLegend(
      pal = pal, values = terra::values(r, mat = FALSE),
      title = legend_title
    ) |>
    leaflet::fitBounds(
      lng1 = e["xmin"], lat1 = e["ymin"],
      lng2 = e["xmax"], lat2 = e["ymax"]
    )
  return(map)
}
