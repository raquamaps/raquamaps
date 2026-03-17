# Converts presence data from rgbif into raster data

Converts presence data from rgbif into raster data

## Usage

``` r
rasterize_presence(occs = presence_rgbif())
```

## Arguments

- occs:

  data frame with coordinates, from rgbif

## Value

a terra SpatRaster grid with individual cell values representing the
count of occurrences within the grid cells
