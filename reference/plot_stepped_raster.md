# Plot raster data in raquamaps style

Plot raster data in raquamaps style

## Usage

``` r
plot_stepped_raster(r, breaks, trim = FALSE)
```

## Arguments

- r:

  a terra SpatRaster (discretized, e.g. from stepped_raster)

- breaks:

  vector with character strings describing intervals

- trim:

  boolean to indicate whether the raster layer should be cropped

## Value

plot of the raster
