# Discretize a raster into intervals or steps for chloropeth maps

Discretize a raster into intervals or steps for chloropeth maps

## Usage

``` r
stepped_raster(r, n = 5, interval_style = "fisher")
```

## Arguments

- r:

  a terra SpatRaster

- n:

  number of steps to use, default being five steps

- interval_style:

  a character string with classInt interval styles, defaulting to
  "fisher", but can be "quantile", "equal" (see classIntervals docs)

## Value

a list with the raster (discretized) and breaks (intervals)
