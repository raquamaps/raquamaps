#' Get native range dataset from aquamaps.org given latin name
#' 
#' aquamaps.org provides native range data downloads on a per species basis
#' and this function scrapes the website for this information and returns
#' it as a dataframe
#' 
#' @param latinname a character vector with the latin name for the species
#' @param identifier aquamaps.org sometimes provide several internal
#' identifiers for the same latin name, if missing the first match will be used, but this can be overridden by using this parameter... 
#' @return dplyr layouted data frame with lat, long, native range p-value (0..1) and species name
#' @examples
#' \dontrun{
#'    native_range_df <- nativerange("Gadus morhua")
#'    native_range_df <- nativerange("Sphyraena sphyraena")
#' }
#' @export
nativerange <- function(latinname = default_species(), identifier) {
  #latinname <- "Sphyraena sphyraena"
  
  ##AM: The <else> condition was missing here, so the 'ids' receiving 'identifier' would be replaced in the next line
  if (!missing(identifier))
    ids <- identifier
  else
    ids <- get_am_name_uris(latinname)
  
  if (length(ids) < 1)
    stop("Found no match for ", latinname)
  
  ##AM: This should not happen now since only matches to accepted species names will be returned
  if (length(ids) > 1) {
    warning("More than one match found for ", latinname,
      " so the first one will be used out of ", 
      paste(ids, collapse = ", "), " ... so, if you meant to use ",
      "another, call instead nativerange('", latinname, "', identifier = '",
      ids[2], "') ie specify the identifier parameter.")
    ids <- ids[1]
  }

  maps <- get_am_nativerangemap_uris(ids)
  
  if (length(maps) < 1)
    stop("Found no native range data for ", latinname,
         " at ", res$url)
  
  if (length(maps) > 1) {
    warning("Found several range maps: \n", paste(collapse = "\n", maps), 
            "\n... so will proceed to use the first one")
    maps <- maps[1]
  }
  
  csv_url <- get_am_csv_dl_url(maps)
  ##AM: Some species have an identifier, and the 'maps' link exists, but there is no range projection on the website
  ##AM: Trying to retrieve the data for these species was leading to an error
  if(is.null(csv_url))
    return(cat("Although the name you entered exists in the Catalogue of Life: 2018 annual checklist, there are not enough good cells for prediction or it is not a marine species."))

  #message("Retrieving and parsing native range data from:\n", csv_url)
  res <- parse_am_csv(csv_url)
  return (res)  
}

#nativerange("Sphyraena sphyraena", "Fis-23821")

get_am_csv_dl_url <- function(am_nativerangemap_identifier) {

  url <- am_nativerangemap_identifier
  #message("Downloading .csv with native range maps data from ", url)
  map <- httr::GET(url) ##AM
  htm <- httr::content(map, as = "text", encoding = "utf-8") ##AM

  ##AM: Some species have an identifier but don't have a range projection on the website
  ##AM: Ignoring this will lead to an error
  if(grepl('there are not enough good cells for prediction',htm))
    return()

  # extract download link from JS
  csv_dl <- unlist(stringr::str_extract_all(htm, "window.open\\(.*?CreateCSV.php.*?\\)"))
  re <- ".*window.open\\(&quot;(.*?)&quot;.*"
  csv_dl <- paste0(gsub(re, "\\1", csv_dl), "&download_option=all")
  csv_dl <- paste("http:",csv_dl,sep = "") ##AM
  res <- httr::GET(csv_dl) ##AM
  htm <- httr::content(res, as = "text", encoding = "utf-8") ##AM
    
  # extract CSV link location from htm
  re <- "a href=(CSV/\\d+.csv)"
  csv <- unlist(stringr::str_extract_all(htm, re))
  csv <- gsub(re, "\\1", csv)
  dl <- paste0("http://www.aquamaps.org/", csv)
  return (dl)  
}


parse_am_csv <- function(url) {
  
  dl <- httr::GET(url) ##AM
  csv <- httr::content(dl, as = "text", encoding = "latin1") ##AM
  
  rows <- unlist(strsplit(csv, "\n"))
  
  extract <- function(re) gsub(re, "\\1", grep(re, rows, value = TRUE))
  #message("extracting model parameters")
  re <- "Map type: (.*?),"
  map_type <- extract(re)
  re <- "Map Option: (.*?)"
  map_option <- extract(re)
  re <- "FAOAreas: (.*?),"
  fao_areas <- as.numeric(unlist(strsplit(fixed = TRUE, trimws(extract(re)), " | ")))
  re <- "Bounding Box [(]NSWE[)]: (.*?)"
  bbox <- na.omit(as.numeric(unlist(strsplit(fixed = TRUE, trimws(extract(re)), ","))))
  re <- "Pelagic: (.*),"
  pelagic <- extract(re)
  re <- "Layer used to generate probabilities: (.*?),"
  layer <- extract(re)
  
  #message("extracting species envelope dataframe")
  extract_df <- function(beg, end) {
    res <- read.csv(file = textConnection(rows[beg : end]),
      stringsAsFactors = FALSE)
    ##AM: Update deprecated function
    return (tibble::as_tibble(res))
  }
  hspen_beg <- grep("Species Envelope [(]HSPEN[)]:", rows) + 1
  hspen_end <- grep("Map data (HSPEC) for predicted occurrences", rows, fixed = TRUE)
  hspen <- extract_df(hspen_beg, hspen_end - 1)
  hspen <- hspen[hspen$X!=' ',] ##AM
  
  #message("extracting predicted occurrences dataframe")
  re <- "Map data [(]HSPEC[)] for predicted occurrences [(]n = (.*?)[)]:"
  n_hspec <- as.numeric(extract(re))
  hspec_beg <- hspen_end + 1
  hspec_end <- hspec_beg + n_hspec
  hspec <- extract_df(hspec_beg, hspec_end)

  ##AM: Some species have a different table, so the code above will not work
  ##AM: We can detect this through ncol and apply a correction
  if(ncol(hspec)==1)
  {
    hspec_beg <- hspen_end + 8
    hspec_end <- hspec_beg + n_hspec
    hspec <- extract_df(hspec_beg, hspec_end)
  }

  #message("extracting occurrence cells that created species envelope as data frame")
  re <- "Occurrence cells used for creating environmental envelope [(]n = (.*?)[)]"
  n_occ <- as.numeric(extract(re))
  occ_beg <- grep(re, rows) + 1
  occ_end <- occ_beg + n_occ
  occ <- extract_df(occ_beg, occ_end)

  # Martin asks for tuples with lat, long, p, latinname
  #  res <- dplyr::tbl_df(data.frame(lat = df$Center.Lat, long = df$Center.Long, 
  #    p = df$Overall.Probability, latinname = paste(df$Genus, df$Species)))
  
  res <- list(
    map_type = map_type, 
    map_option = map_option,
    fao_areas = fao_areas,
    bbox = bbox,
    pelagic = pelagic,
    layer = layer,
    hspen = hspen,
    hspec = hspec,
    occ = occ)

  return (res)
}

get_am_nativerangemap_uris <- function(am_identifier) {

  id <- am_identifier
  url <- paste0("http://aquamaps.org/preMap2.php?cache=1&SpecID=", id)
  message("Finding aquamaps.org native range maps at ", url)
  res <- httr::GET(url) ##AM
  
  if (res$status != 200)
    stop("Can not retrieve data for ", latinname, 
         " from ", res$url)
  #message("Got ", res, " for ", id)
  htm <- httr::content(res, as = "text", encoding = "latin1") ##AM
  
  # extract href (case 1)
  re <- "href='(.*?pre[mM]ap.php?.*?)'"
  hits <- unlist(stringr::str_extract_all(htm, re))
  href <- gsub(re, "\\1", hits)
  
  # extract refresh Content = urls
  re <- "Content='0; URL=(.*?pre[mM]ap.php?.*?)'"
  hits <- unlist(stringr::str_extract_all(htm, re))
  meta <- gsub(re, "\\1", hits)
  if (length(meta) > 0) meta <- paste0("http://www.aquamaps.org/", meta)
  
  # combine both href and meta urls found
  maps <- c(href, meta)
  return (maps)    
}

#' Get aqua maps identifiers for a latin name
#' 
#' aquamaps.org uses internal identifiers for species, 
#' and this function scrapes the website and resolves a given 
#' latinname into one of these identifiers, which can be used 
#' to get a specific nativerange map in the case there are several
#' available for a specific given latinname
#' 
#' @param latinname a character vector with the latin name for the species
#' @return character vector with aquamaps.org internal identifier(s)
#' @examples
#' \dontrun{
#'    get_am_name_uris("Gadus morhua")
#'    get_am_name_uris("Sphyraena sphyraena")
#' }
#' @export
get_am_name_uris <- function(latinname = default_species()) {
  
  genus <- stringr::word(latinname, 1)
  species <- stringr::word(latinname, 2)
  
  resolver_uri <- 
    paste0("http://aquamaps.org/ScientificNameSearchList.php?",
    "Crit1_FieldName=scientific_names.Genus&Crit1_FieldType=CHAR&",
    "Crit2_FieldName=scientific_names.Species&Crit2_FieldType=CHAR&",
    "Group=All&",
    "Crit1_Operator=EQUAL&Crit1_Value=", genus, 
    "&Crit2_Operator=EQUAL&Crit2_Value=", species)

  res <- httr::GET(resolver_uri) ##AM
  
  htm <- httr::content(res, as = "text", encoding = "utf-8") ##AM
  ##AM: The code 'Fis' is not universal. Different taxonomic groups have different codes
  re <- "'preMap2.php\\?cache=1&SpecID=(.*?)'"
  ##AM: Get all identifiers, then select the target identifier based on the accepted species name
  identifiers <- gsub(re, "\\1", unlist(stringr::str_extract_all(htm, re)))
  ac <- "<td width='200' valign='top'><i>(.*?) </i></td>"
  sp <- gsub(ac, "\\1", unlist(stringr::str_extract_all(htm, ac)))
  sp <- gsub('-',' ',sp)
  identifiers <- unique(identifiers[which(sp==latinname)])

  return (identifiers)
}
