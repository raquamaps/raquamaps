#' Download a dropbox folder content as a zip-file
#'
#' This function downloads a dropbox folder into the given
#' destination directory.
#' 
#' @param pubshare a string with the dropbox public share, 
#' for example "7yzcbdgm5m9axht/PUnf7vugFc"
#' @param destdir path for destination, defaults to working dir
#' @examples
#'\dontrun{
#' get_dropbox_as_zip("7yzcbdgm5m9axht/PUnf7vugFc", "/tmp")
#'}
get_dropbox_as_zip <- function(pubshare, destdir = getwd()) {

  # TODO change to use httr instead
  requireNamespace("RCurl", quietly = FALSE)
  requireNamespace("stringr", quietly = FALSE)
    
  url <- paste0("https://www.dropbox.com/sh/", pubshare)
  htm <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  
  title.re <- ".*?<meta content=\"(.*?)\" property=\"og:title\".*"
  title <- str_replace(htm, pattern = title.re, "\\1")
  
  shz <- "https://dl.dropboxusercontent.com/shz/"
  
  hash.re <- paste0(".*?", shz, pubshare, "/", title, 
                    "\\?token_hash=(.*?)&amp;.*")
  
  hash <- str_replace(htm, hash.re, "\\1")
  
  destfile <- file.path(destdir, title)
  
  wget <- paste0("wget -O ", destfile, ".zip ", shz, pubshare, 
                 "/", title, "?token_hash=", hash)
  
  res <- system(wget)
}