# Get native range dataset from aquamaps.org given latin name

aquamaps.org provides native range data downloads on a per species basis
and this function scrapes the website for this information and returns
it as a dataframe

## Usage

``` r
nativerange(latinname = default_species(), identifier)
```

## Arguments

- latinname:

  a character vector with the latin name for the species

- identifier:

  aquamaps.org sometimes provide several internal identifiers for the
  same latin name, if missing the first match will be used, but this can
  be overridden by using this parameter...

## Value

dplyr layouted data frame with lat, long, native range p-value (0..1)
and species name

## Examples

``` r
if (FALSE) { # \dontrun{
native_range_df <- nativerange("Gadus morhua")
native_range_df <- nativerange("Sphyraena sphyraena")
} # }
```
