#' Lookup coordinates using the Nominatim OSM API
#'
#' This looks up location data (© OpenStreetMap contributors) including coordinates from the Nomination OSM API.
#'
#' Data from this service is provided under the ODbL license which requires to share alike
#'
#' See attribution and license here: \url{https://www.openstreetmap.org/copyright}
#'
#' See usage policy here: \url{https://operations.osmfoundation.org/policies/nominatim/}
#'
#' @param address character string for the address
#' @return tibble with results
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr as_tibble
#' @importFrom utils URLencode
#' @export
geocode_nominatim <- function(address) {
  if (suppressWarnings(is.null(address))) {
    return(data.frame())
  }

  api <-
    "https://nominatim.openstreetmap.org/search.php?q=%s&format=json&addressdetails=1&limit=1" |>
    sprintf(URLencode(address))

  d <- tryCatch(
    jsonlite::fromJSON(api, simplifyDataFrame = TRUE, flatten = TRUE),
    error = function(e) {
      return(data.frame())
    }
  )

  if (length(d) == 0) {
    return(data.frame())
  }

  return(as_tibble(d))
}
