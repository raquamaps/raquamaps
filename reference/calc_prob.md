# Function to calculate probability per individual bioclimate variable given "spread" summary stats for a single environment envelope parameter

Function to calculate probability per individual bioclimate variable
given "spread" summary stats for a single environment envelope parameter

## Usage

``` r
calc_prob(x, min, max, d1, d9)
```

## Arguments

- x:

  bioclimate parameter value

- min:

  the min statistics for this bioclimate variable

- max:

  the max statistics for this bioclimate variable

- d1:

  the first decile for for this bioclimate variable

- d9:

  the ninth decile for this bioclimate variable

## Examples

``` r
if (FALSE) { # \dontrun{
p <- calc_prob(1, 1, 1, 1)
} # }
```
