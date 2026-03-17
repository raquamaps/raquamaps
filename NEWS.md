NEWS
====

For more fine-grained list of changes or to report a bug, consult

* [The issues log](https://github.com/raquamaps/raquamaps/issues)
* [The commit log](https://github.com/raquamaps/raquamaps/commits/master)

# v0.5.0

* Replace retired `raster` + `sp` packages with `terra` + `sf` throughout.
  All spatial functions (`rasterize_occs`, `rasterize_presence`,
  `stepped_raster`, `r2df_points`, `r2df_polygons`, `occs_webmap_gridded`,
  `occs_ggmap_gridded`) now accept and return `terra::SpatRaster` objects.
* Modernise dplyr/tidyr usage: `funs()`, `summarise_each()`, `mutate_each()`,
  `tbl_df()`, and `reshape2::melt/dcast` replaced with current equivalents
  (`across()`, `tibble::as_tibble()`, `pivot_longer/wider`).
* Fix bare-variable bug in `adjust_values()` (`idr` → `s$idr`).
* Add GitHub Actions CI (R-CMD-check on macOS, Windows, Ubuntu) and pkgdown
  site deployed to <https://raquamaps.github.io/raquamaps/>; remove Travis CI.
* Migrate testthat to edition 3; add spell-checking infrastructure.
* Rename R source files from `.r` to `.R` convention; apply styler formatting.
* Package check result: 0 errors, 0 warnings, 0 notes.

# v0.4.6

* Some adjustments to the scraping from aquamaps.org, thanks to PR from AndreMenegotto
* Minor adjustments to make some tests pass (catering for some API deprecations and changes etc)

# v0.4.5

* Fixed issue with vignettes not being properly bundled into the R package when installing from GitHub (due to .gitignore blocked inst/doc)

# v0.4.4

* Fixed issue with nativerange function when fetching Barracudas from aquamaps.org and added some tests

# v0.4.3

* Added web leaflet maps for raster data (also with class intervals) and static ggmap maps for raster (incl stepped) and point data. 
* Added some functions to convert points and polygons into dataframe and raster formats. 
* Added a function to scrape native range data from aquamaps.org, and showed usage in vignette but uncommented because of curl timeouts when building using travis-ci.

# v0.4.2

* Updated README, DESCRIPTION and various other project specific files to comply with the style used in the ropensci/rfishbase package. 
* Also added raw data from Kathy on FAO areas and the quarter degree cell grid. Also started to prepare for Travis CI by adding .travis.yml.





