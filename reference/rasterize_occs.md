# Converts points in data frame into raster

Converts points in data frame into raster

## Usage

``` r
rasterize_occs(df)
```

## Arguments

- df:

  data frame with coordinates in decimalLongitude, decimalLatitude
  columns

## Value

a half degree terra SpatRaster grid with individual cell values
representing the count of occurrences within the grid cells
