#' Half degree cell authority file for the world (259,200 cells) with bioclimate data
#'
#' A dataset containing reference data for bioclimate variables 
#'
#' @format A data frame [259,200 x 16]
#' \describe{
#'   \item{LOICZID}{LOICZID}
#'   \item{FAO}{FAO}
#'   \item{CountryMain}{CountryMain}
#'   \item{CountrySecond}{CountrySecond}
#'   \item{CountryThird}{CountryThird}
#'   \item{CsquareCod}{CsquareCod}
#'   \item{Islands}{Islands}
#'   \item{Basins}{Basins}
#'   \item{SoilpH}{SoilpH}
#'   \item{SoilCarbon}{SoilCarbon}
#'   \item{CTI_Max}{CTI_Max}
#'   \item{Elevation}{Elevation}
#'   \item{TempMonthM}{TempMonthM}
#'   \item{NPP}{NPP}
#'   \item{SoilMoistu}{SoilMoistu}
#'   \item{PrecipAnMe}{PrecipAnMe}
#'   ...
#' }
#' @source \url{https://www.aquamaps.org/}
"aquamaps_hcaf_world"

#' Half degree cell authority file for EU with bioclimate data (8,493 cells)
#'
#' A dataset containing reference data for bioclimate variables 
#'
#' @format A data frame [8,593 x 12]
#' \describe{
#'   \item{CsquareCod}{CsquareCod}
#'   \item{LOICZID}{LOICZID}
#'   \item{Elevation}{Elevation}
#'   \item{TempMonthM}{TempMonthM}
#'   \item{PrecipAnMe}{PrecipAnMe}
#'   \item{SoilpH}{SoilpH}
#'   \item{SoilMoistu}{SoilMoistu}
#'   \item{SoilCarbon}{SoilCarbon}
#'   \item{CTI_Max}{CTI_Max}
#'   \item{NPP}{NPP}
#'   \item{Islands}{Islands}
#'   \item{Basins}{Basins}
#'   ...
#' }
#' @source \url{https://www.aquamaps.org/}
"aquamaps_hcaf_eu"

#' Half degree cell metadata (only identifiers and coordinates)
#'
#' A dataset containing metadata such as identifiers (CsquareCod, LOICZID) and bbox coords  
#'
#' @format A data frame [8,593 x 12]
#' \describe{
#'   \item{CsquareCod}{CsquareCod}
#'   \item{LOICZID}{LOICZID}
#'   \item{NLimit}{NLimit}
#'   \item{Slimit}{Slimit}
#'   \item{WLimit}{WLimit}
#'   \item{ELimit}{ELimit}
#'   \item{CenterLat}{CenterLat}
#'   \item{CenterLong}{CenterLong}
#'   ...
#' }
#' @source \url{https://www.aquamaps.org/}
"aquamaps_hc"

#' Example grid cell data for various species of a certain category with presence in a basin (approx 410 000 rows)
#'
#' A dataset that should be possible to get via rgbif, would be nice to show that instead?
#'
#' @format A data frame [410,288 x 5]
#' \describe{
#'   \item{loiczid}{loiczid is the unique cell identifier}
#'   \item{csquarecode}{csquarecode is also a cell identifier}
#'   \item{lname}{lname is the latin name for a species}
#'   \item{category}{category is a category for a species}
#'   \item{inbassin}{inbassin states whether the presence is in a basin}
#'   ...
#' }
#' @source \url{https://www.aquamaps.org/}
"aquamaps_presence_basins"

#' Example grid cell data for various species (approx 40 000 rows)
#'
#' A dataset that should be possible to get from rgbif, should show how to do it.
#'
#' @format A data frame [39,307 x 4]
#' \describe{
#'   \item{loiczid}{loiczid}
#'   \item{csquarecode}{csquarecode}
#'   \item{lname}{lname}
#'   \item{occurrence}{occurrence}
#'   ...
#' }
#' @source \url{https://www.aquamaps.org/}
"aquamaps_presence_occurrences"

#' Example grid cell data for one specific species (Galemys pyrenaicus), approx 359 rows
#'
#' A dataset that should be possible to get from rgbif, should show how to do it.
#'
#' @format A data frame [359 x 5]
#' \describe{
#'   \item{CsquareCod}{CsquareCod}
#'   \item{LOICZID}{LOICZID}
#'   \item{InBasin}{InBasin}
#'   \item{GoodCell}{GoodCell}
#'   \item{Species}{Species}
#'   ...
#' }
#' @source \url{https://www.aquamaps.org/}
"aquamaps_galemys_pyrenaicus"

#' Example grid cell data for one specific species (Galemys pyrenaicus)
#'
#' A dataset fetched using rgbif on 31st of May 2015
#'
#' @format A data frame
#' \describe{
#'   \item{decimalLatitude}{decimalLatitude}
#'   \item{decimalLongitude}{decimalLongitude}
#'   \item{geodeticDatum}{geodeticDatum}
#'   \item{countryCode}{countryCode}
#'   \item{vernacularName}{vernacularName}
#'   ...
#' }
#' @source \url{https://www.aquamaps.org/}
"rgbif_galemys_pyrenaicus"

#' Example grid cell data for one specific species (Great White Shark)
#'
#' A dataset fetched using rgbif on 31st of May 2015
#'
#' @format A data frame
#' \describe{
#'   \item{decimalLatitude}{decimalLatitude}
#'   \item{decimalLongitude}{decimalLongitude}
#'   \item{geodeticDatum}{geodeticDatum}
#'   \item{countryCode}{countryCode}
#'   \item{vernacularName}{vernacularName}
#'   ...
#' }
#' @source \url{https://www.aquamaps.org/}
"rgbif_great_white_shark"

#' Quarter degree cell metadata (only identifiers and coordinates)
#'
#' A dataset containing metadata such as identifiers and bbox coords  
#'
#' @format A data frame
#' \describe{

#'   \item{OBJECTID}{OBJECTID}
#'   \item{Quadrant}{Quadrant}
#'   \item{Global_Quadrant}{Global_Quadrant}
#'   \item{c_square_code}{c_square_code}
#'   \item{N_limit}{N_limit}
#'   \item{E_limit}{E_limit}
#'   \item{S_limit}{S_limit}
#'   \item{W_limit}{W_limit}
#'   \item{area__km2_}{area__km2_}
#'   \item{centrelatitude}{centrelatitude}
#'   \item{centrelongitude}{centrelongitude}
#'   \item{Northern}{Northern}
#'   \item{Southern}{Southern}
#'   \item{Eastern}{Eastern}
#'   \item{Western}{Western}
#'   \item{Area}{Area}
#'   \item{CenterLat}{CenterLat}
#'   \item{CenterLon}{CenterLon}
#'   \item{Shape}{Shape}
#'   ...
#' }
#' @source \url{https://www.aquamaps.org/}
"aquamaps_qc"
