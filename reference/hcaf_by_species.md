# Default half degree cells reference data, including geometry and bioclimate measurements, for demonstrational purposes, filtered for a specific species and for specific bioclimate measurements

This function returns a data frame with reference data consisting of
environmental data for only those cells that have a specific species
present

## Usage

``` r
hcaf_by_species(.latinname = default_species(), .vars = default_clim_vars())
```

## Arguments

- .latinname:

  character string with latin name for species

- .vars:

  vector of climate variable names to use

## Examples

``` r
if (FALSE) { # \dontrun{
hcaf <- hcaf_by_species(default_species(), default_clim_vars())
} # }
```
