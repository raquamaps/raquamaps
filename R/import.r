#' Get presence data using rgbif
#' 
#' @param latinname string with latin name for species
#' @param maxlimit upper limit for number of rows to return
#' @return data frame with coordinates, country and vernacular name
#' @export
presence_rgbif <- function(
  latinname = default_species(),
  maxlimit = 10000) {
  
  message("Patience please, getting data from gbif.org can be slow... ")
  
  key <- name_backbone(name = latinname)
  key <- key$speciesKey
  
  occs <- occ_search(taxonKey = key, 
                     results = "data", limit = maxlimit)
  
  # pick out only relevant fields 
  # for coords and country
  o <- 
    tbl_df(occs$data) %>%
    select(
      decimalLatitude, 
      decimalLongitude, 
      geodeticDatum, 
      countryCode, 
      vernacularName)
  
  return (o)
}
