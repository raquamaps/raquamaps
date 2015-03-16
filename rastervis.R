# install.packages("dismo")
# install.packages("rasterVis")

library(dismo)
library(rasterVis)

g_map <-
  gmap(
    extent(c(-79, -58, 36, 50)), 
    type = "satellite",
    zoom = 7, lonlat = TRUE, scale = 1
  )

g_map <- trim(g_map)

g_map_lv <- 
  levelplot(
    g_map,
    maxpixel = ncell(g_map),
    col.regions = g_map@legend@colortable,
    at = 0:255, 
    panel = panel.levelplot.raster,
    interpolate = TRUE, 
    colorkey = FALSE, 
    margin = FALSE,
    scales="sliced"
  )

plot(g_map_lv)
