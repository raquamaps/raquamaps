# Download a dropbox folder content as a zip-file

This function downloads a dropbox folder into the given destination
directory.

## Usage

``` r
get_dropbox_file(pubshare, destfile = tempfile())
```

## Arguments

- pubshare:

  a string with the dropbox public share, for example
  "u4ipvf1tfo4izhq/AACVIxriWFkMfoliMtIyRUDPa"

- destfile:

  path for downloaded content, defaults to tempfile()

## Value

path to local file with the downloaded content

## Examples

``` r
if (FALSE) { # \dontrun{
get_dropbox_file("u4ipvf1tfo4izhq/AACVIxriWFkMfoliMtIyRUDPa", "/tmp/test.zip")
} # }
```
