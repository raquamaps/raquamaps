# Adjustment of climate summary stat values during envelope parameter calculation

This function takes a data frame with bioclimate parameter spread data
and returns a similar data frame but with various adjustments for
extreme values. This function works using a set of correction rules
defined inline and reflecting adjustment limits as described in a
separate paper (ref: Tamas Jantevik)

## Usage

``` r
adjust_spreads(spreads)
```

## Arguments

- spreads:

  data frame with spread data to adjust

## Examples

``` r
if (FALSE) { # \dontrun{
adjusted_spreads <- adjust_spreads(spreads)
} # }
```
