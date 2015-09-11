#' Get native range dataset from aquamaps.org given latin name
#' 
#' aquamaps.org provides native range data downloads on a per species basis
#' and this function scrapes the website for this information and returns
#' it as a dataframe
#' 
#' @param latinname a character vector with the latin name for the species
#' @return dplyr layouted data frame with lat, long, native range p-value (0..1) and species name
#' @examples
#' \dontrun{
#'    native_range_df <- nativerange("Gadus morhua")
#' }
#' @export

nativerange <- function(latinname = default_species()) {
  
  ids <- get_am_name_uris(latinname)
  
  if (length(ids) < 1)
    stop("Found no match for ", latinname)
  
  if (length(ids) > 1) {
    warning("More than one match found for ", latinname,
            " so the first one will be used out of ", paste(ids, collapse = ", "))
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
  
  df <- get_am_csv_dl(maps)
  
  return (df)
  
}

get_am_csv_dl <- function(am_nativerangemap_identifier) {

  url <- am_nativerangemap_identifier
  message("Downloading .csv with native range maps data from ", url)
  map <- GET(url)
  htm <- content(map, as = "text", encoding = "utf-8")
  
  # extract download link from JS
  csv_dl <- unlist(stringr::str_extract_all(htm, "window.open\\(.*?CreateCSV.php.*?\\)"))
  re <- ".*window.open\\(&quot;(.*?)&quot;.*"
  csv_dl <- paste0(gsub(re, "\\1", csv_dl), "&download_option=all")
  res <- GET(csv_dl)
  htm <- content(res, as = "text", encoding = "utf-8")
    
  # extract CSV link location from htm
  re <- "a href=(CSV/\\d+.csv)"
  csv <- unlist(stringr::str_extract_all(htm, re))
  csv <- gsub(re, "\\1", csv)
  dl <- paste0("http://www.aquamaps.org/", csv)
  df <- read.csv(dl, skip = 23)  # is 23 always the magic nr from aquamaps.org csvs?
  
  # Martin asks for tuples with lat, long, p, latinname
  res <- dplyr::tbl_df(data.frame(lat = df$Center.Lat, long = df$Center.Long, 
    p = df$Overall.Probability, latinname = paste(df$Genus, df$Species)))
  
  return (res)
  
}

get_am_nativerangemap_uris <- function(am_identifier) {

  id <- am_identifier
  url <- paste0("http://aquamaps.org/preMap2.php?cache=1&SpecID=", id)
  message("Finding aquamaps.org native range maps at ", url)
  res <- GET(url)
  
  if (res$status != 200)
    stop("Can not retrieve data for ", latinname, 
         " from ", res$url)
  
  htm <- content(res, as = "text", encoding = "utf-8")
  re <- "href='(.*?premap.php?.*?)'"
  hits <- unlist(stringr::str_extract_all(htm, re))
  maps <- gsub(re, "\\1", hits)
  
  return(maps)    
}

get_am_name_uris <- function(latinname = default_species()) {
  
  genus <- stringr::word(latinname, 1)
  species <- stringr::word(latinname, 2)
  
  resolver_uri <- paste0("http://aquamaps.org/ScientificNameSearchList.php?",
    "Crit1_FieldName=scientific_names.Genus&Crit1_FieldType=CHAR&",
    "Crit2_FieldName=scientific_names.Species&Crit2_FieldType=CHAR&",
    "Group=All&",
    "Crit1_Operator=EQUAL&Crit1_Value=", genus, 
    "&Crit2_Operator=EQUAL&Crit2_Value=", species)

  res <- GET(resolver_uri)
  
  htm <- content(res, as = "text", encoding = "utf-8")
  re <- "href='preMap2.php\\?cache=1&SpecID=(Fis-\\d+)'"
  identifiers <- unique(gsub(re, "\\1", unlist(stringr::str_extract_all(htm, re))))

  return (identifiers)
}
