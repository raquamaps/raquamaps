#' Download a dropbox folder content as a zip-file
#'
#' This function downloads a dropbox folder into the given
#' destination directory.
#' 
#' @param pubshare a string with the dropbox public share, 
#' for example "u4ipvf1tfo4izhq/AACVIxriWFkMfoliMtIyRUDPa"
#' @param destfile path for downloaded content, defaults to tempfile()
#' @return path to local file with the downloaded content
#' @examples
#'\dontrun{
#' get_dropbox_file("u4ipvf1tfo4izhq/AACVIxriWFkMfoliMtIyRUDPa", "/tmp/test.zip")
#'}
get_dropbox_file <- function(pubshare, destfile = tempfile()) {

  # make sure we start with a dropbox base url
  base_url <- "https://www.dropbox.com/sh/"
  url <- pubshare
  if (!grepl(base_url, pubshare, fixed = TRUE)) 
    url <- paste0(base_url, pubshare)

  # make sure we end with ?dl=1
  url <- gsub("(\\?dl=\\d+)", "\\?dl=1", url)
  if (!grepl("\\?dl=\\d+", url))
    url <- paste0(url, "?dl=1")
  
  dl <- httr::GET(url)
  writeBin(httr::content(dl), destfile)
  message("Downloaded content from ", dl$url, " into ", destfile)
  return(destfile)
}