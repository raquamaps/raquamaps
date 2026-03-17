# Raster grid cell identifiers with presence

Raster grid cell identifiers with presence

## Usage

``` r
which_cells_in_raster(r, lower_limit = 0)
```

## Arguments

- r:

  a terra SpatRaster

- lower_limit:

  raster cell values higher than this parameter is interpreted as
  presence

## Value

a vector of raster grid cell identifiers (loiczids)
