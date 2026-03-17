# Plots a raster layer as a gridded map using ggplot

Plots a raster layer as a gridded map using ggplot

## Usage

``` r
occs_ggmap_gridded(
  r,
  legend = TRUE,
  legend_title = "Occurrences (n)",
  center,
  padding = 10
)
```

## Arguments

- r:

  a terra SpatRaster with occurrence points

- legend:

  a boolean indicating whether to include the color legend

- legend_title:

  a character string explaining which variable is displayed

- center:

  optional coordinate (numeric vector c(lon, lat)) to center the map on

- padding:

  distance in degrees around the center to include in the map

## Value

a ggplot
