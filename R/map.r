#' Plot raster data in raquamaps style
#' @param raster raster layer
#' @param breaks vector with character strings describing intervals
#' @param trim boolean to indicate whether the raster layer should be cropped
#' @return plot of the raster
#' @export
plot_stepped_raster <- function(raster, breaks, trim = FALSE) { 
  r <- raster
  if (trim) r <- trim(r)
  colors <- RColorBrewer::brewer.pal(7, "YlOrRd")[3:7]
  image(r, col = colors, breaks = levels(r), xlab = NA, ylab = NA)  
}

raquamaps_theme_gridded <- function() {
  out <- 
    ggplot2::theme_bw() + ggplot2::theme(
    axis.text.x = ggplot2::element_text(size = 10),
    axis.text.y = ggplot2::element_text(size = 10),
    panel.background = ggplot2::element_blank(), 
    plot.background = ggplot2::element_blank(),
#    panel.grid.minor = ggplot2::element_line(colour = "gray95"),
#    panel.grid.major = ggplot2::element_line(colour = "gray95"),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_blank(),
    axis.text = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    axis.title = ggplot2::element_blank(),
    panel.border = ggplot2::element_blank())
  return (out)
}

raquamaps_theme <- function() {
  out <- 
    ggplot2::theme(legend.position = "bottom", 
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
    plot.background = ggplot2::element_blank())
  return (out)
}

#' Plots an occurrence data frame with points as a map using ggplot
#' @param occs a data frame with occurrence points
#' @return a ggplot 
#' @export
occs_ggmap_points <- function(occs) {
  o <- occs %>% 
    rename(lat = decimalLatitude, lon = decimalLongitude) %>%
    filter(!is.na(lat), !is.na(lon))
  xmin <- min(o$lon)
  xmax <- max(o$lon)
  ymin <- min(o$lat)
  ymax <- max(o$lat)
  world <- ggplot2::map_data(map = "world")
  map <- 
    ggplot(world, aes(x = long, y = lat, group = group)) +
    geom_polygon(fill = "gray70", alpha = 0.4) +
    coord_fixed(
      xlim = c(xmin, xmax), 
      ylim = c(ymin, ymax)) +
    raquamaps_theme_gridded() +  
    geom_point(data = o, 
               aes(x = lon, y = lat, group = 0),
               alpha = 0.1, color = RColorBrewer::brewer.pal(5, "YlOrRd")[5]) 
  return (map)
}

#' Plots a raster layer as a gridded map using ggplot
#' @param r a raster layer with with occurrence points
#' @param legend a boolean indicting whether to include the color legend
#' @param legend_title a character string explaining which variable is displayed
#' @param center optional coordinate from geocode to center the map on
#' @param padding distance in degrees around the center to include in the map
#' @return a ggplot
#' @export
occs_ggmap_gridded <- function(r, legend = TRUE,
  legend_title = "Occurrences (n)", center, padding = 10) {
  
  # discretize raster
  sr <- stepped_raster(r)
  r_5 <- sr$raster
  message("This is the stepped raster: ", str(r_5))
  breaks <- sr$breaks
  message("Stepped raster reports interval breaks: ", breaks)
  
  # convert to df with values as factors with class intervals
  df <- r2df_points(r_5)
  df$z <- as.factor(df$z)
  levels(df$z) <- breaks
  
  bounds <- bbox(r)
  rownames(bounds) <- c("lon", "lat")
  if (!missing(center)) {
    p <- center
    points <- rbind(p, p + padding, p - padding)
    bounds <- bbox(SpatialPoints(points))
  } 
  ymin <- bounds["lat", "min"]
  ymax <- bounds["lat", "max"]
  xmin <- bounds["lon", "min"]
  xmax <- bounds["lon", "max"]
  
  world <- ggplot2::map_data(map = "world")
  map <- 
    ggplot(world, aes(x = long, y = lat, group = group)) +
    # add grid lines to the map
    #  scale_y_continuous(breaks=(-2:2) * 30) +
    #  scale_x_continuous(breaks=(-4:4) * 45)
    geom_polygon(fill = "gray70", alpha = 0.4) +
    coord_fixed(
      xlim = c(xmin, xmax), 
      ylim = c(ymin, ymax)) +
    raquamaps_theme_gridded() +  
    geom_raster(data = df, aes(x, y, fill = z, group = NULL)) +
    scale_fill_brewer(type = "seq", palette = "YlOrRd", name = legend_title)
  if (!legend) map <- map + guides(fill = FALSE)
  return (map)
}

#' Plots a raster grid using ggplot and polygons
#' @param raster a raster layer
#' @return a ggplot
#' @export
occs_ggmap_gridded_polys <- function(raster) {
  sr <-stepped_raster(raster, 5, "fisher")
  r <- sr$raster
  breaks <- sr$breaks
  e <- extent(r)
  cols <- RColorBrewer::brewer.pal(7, "YlOrRd")[3:7]
  polyg <- r2df_polygons(r)
  world <- ggplot2::map_data(map = "world")
  map <- 
    ggplot() +
    geom_polygon(data = world, 
                 aes(long, lat, group = group), 
                 fill = "gray90", color = "gray90", size = 0.2) +
    geom_polygon(data = polyg, 
                 aes(x = long, y = lat, group = group, 
                     fill = as.factor(bin)), alpha = 0.8) +
    scale_fill_manual(
      name = NA,
      labels = breaks,
      values = cols) +
    labs(x = "", y = "") +
    raquamaps_theme() + 
    coord_fixed(ratio = 1, 
                xlim = c(e@xmin, e@xmax),
                ylim = c(e@ymin, e@ymax))
  return (map)
}

#' Plots a raster grid using leaflet
#' @param r a raster layer
#' @param legend_title the title for the color legend, 
#' default is NA
#' @return a web map using leaflet
#' @export
occs_webmap_gridded <- function(r, legend_title = NA) {
  # colors - use 5-step palette similar to Aqua Maps
  #sr <- stepped_raster(r)
  #breaks <- levels(sr)[[1]]$VALUE
  colors <- RColorBrewer::brewer.pal(7, "YlOrRd")[3:7]
  #pal <- colorFactor(colors, levels = breaks, ordered = TRUE, na.color = "transparent")
  pal <- leaflet::colorBin(colors, na.omit(unique(values(r))), 
                  bins = 5, pretty = TRUE, na.color = "transparent")
  #  previewColors(pal, values(sr))
  e <- raster::extent(r)
  `%>%` <- leaflet::`%>%`
  map <- 
    leaflet::leaflet() %>% 
    leaflet::addProviderTiles(provider = "OpenStreetMap.BlackAndWhite") %>%
    #    addProviderTiles("Stamen.TonerLite", 
    #      options = providerTileOptions(noWrap = TRUE)) %>% 
    leaflet::addRasterImage(r, colors = pal, opacity = 0.8) %>% 
    leaflet::addLegend(pal = pal, values = values(r), title = legend_title) %>%
    leaflet::fitBounds(lng1 = e@xmin, lat1 = e@ymin, lng2 = e@xmax, lat2 = e@ymax)
  return (map)
}
