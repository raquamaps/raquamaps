% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert.r
\name{rasterize_presence}
\alias{rasterize_presence}
\title{Converts presence data from rgbif into raster data}
\usage{
rasterize_presence(occs = presence_rgbif())
}
\arguments{
\item{occs}{data frame with coordinates, from rgbif}
}
\value{
a raster grid with individual cell values representing 
the count of occurrences within the grid cells
}
\description{
Converts presence data from rgbif into raster data
}

