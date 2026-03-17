# Get aqua maps identifiers for a latin name

aquamaps.org uses internal identifiers for species, and this function
scrapes the website and resolves a given latinname into one of these
identifiers, which can be used to get a specific nativerange map in the
case there are several available for a specific given latinname

## Usage

``` r
get_am_name_uris(latinname = default_species())
```

## Arguments

- latinname:

  a character vector with the latin name for the species

## Value

character vector with aquamaps.org internal identifier(s)

## Examples

``` r
if (FALSE) { # \dontrun{
get_am_name_uris("Gadus morhua")
get_am_name_uris("Sphyraena sphyraena")
} # }
```
