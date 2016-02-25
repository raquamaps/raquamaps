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



#' Half degree cell data (various bioclimate layers)
#'
#' A dataset containing identifiers and bioclimate layers  
#'
#' @format A data frame
#' \describe{
#'   \item{CsquareCode}{CsquareCode}
#'   \item{Basin}{Basin}
#'   \item{BasinOther}{BasinOther}
#'   \item{TempAnMean}{TempAnMean}
#'   \item{TempMonthMean}{TempMonthMean}
#'   \item{PrecipAnTotal}{PrecipAnTotal}
#'   \item{PrecipAnMean}{PrecipAnMean}
#'   \item{SoilpH}{SoilpH}
#'   \item{SoilMoisture}{SoilMoisture}
#'   \item{SoilCarbon}{SoilCarbon}
#'   \item{RunoffAnnual}{RunoffAnnual}
#'   \item{CTI}{CTI}
#'   \item{NPPAnnual}{NPPAnnual}
#'   \item{NPPAnnualAmericas}{NPPAnnualAmericas}
#'   \item{ID}{ID}
#'   \item{LOICZID}{LOICZID}
#'   \item{NLimit}{NLimit}
#'   \item{Slimit}{Slimit}
#'   \item{WLimit}{WLimit}
#'   \item{ELimit}{ELimit}
#'   \item{CenterLat}{CenterLat}
#'   \item{CenterLong}{CenterLong}
#'   \item{CellArea}{CellArea}
#'   \item{OceanArea}{OceanArea}
#'   \item{CellType}{CellType}
#'   \item{PWater}{PWater}
#'   \item{FAOAreaM}{FAOAreaM}
#'   \item{FAOAreaIn}{FAOAreaIn}
#'   \item{CountryMain}{CountryMain}
#'   \item{CountrySecond}{CountrySecond}
#'   \item{CountryThird}{CountryThird}
#'   \item{CountrySubMain}{CountrySubMain}
#'   \item{CountrySubSecond}{CountrySubSecond}
#'   \item{CountrySubThird}{CountrySubThird}
#'   \item{EEZFirst}{EEZFirst}
#'   \item{EEZSecond}{EEZSecond}
#'   \item{EEZThird}{EEZThird}
#'   \item{EEZFourth}{EEZFourth}
#'   \item{EEZFifth}{EEZFifth}
#'   \item{EEZSixth}{EEZSixth}
#'   \item{EEZAll}{EEZAll}
#'   \item{EEZRemark}{EEZRemark}
#'   \item{LME}{LME}
#'   \item{LME_2013_but never updated}{LME_2013_but never updated}
#'   \item{LME_2010}{LME_2010}
#'   \item{LMEBorder}{LMEBorder}
#'   \item{OceanBasin}{OceanBasin}
#'   \item{Longhurst}{Longhurst}
#'   \item{IslandsNo}{IslandsNo}
#'   \item{Area0_20}{Area0_20}
#'   \item{Area20_40}{Area20_40}
#'   \item{Area40_60}{Area40_60}
#'   \item{Area60_80}{Area60_80}
#'   \item{Area80_100}{Area80_100}
#'   \item{AreaBelow100}{AreaBelow100}
#'   \item{ElevationMin}{ElevationMin}
#'   \item{ElevationMax}{ElevationMax}
#'   \item{ElevationMean}{ElevationMean}
#'   \item{ElevationSD}{ElevationSD}
#'   \item{DepthMin}{DepthMin}
#'   \item{DepthMax}{DepthMax}
#'   \item{DepthMean}{DepthMean}
#'   \item{DepthSD}{DepthSD}
#'   \item{SSTMnMin}{SSTMnMin}
#'   \item{SSTMnMax}{SSTMnMax}
#'   \item{SSTAnMean}{SSTAnMean}
#'   \item{SSTAnSD}{SSTAnSD}
#'   \item{SSTMnRange}{SSTMnRange}
#'   \item{SBTAnMean}{SBTAnMean}
#'   \item{SalinityMin}{SalinityMin}
#'   \item{SalinityMax}{SalinityMax}
#'   \item{SalinityMean}{SalinityMean}
#'   \item{SalinitySD}{SalinitySD}
#'   \item{SalinityBMean}{SalinityBMean}
#'   \item{PrimProdMean}{PrimProdMean}
#'   \item{IceConAnn}{IceConAnn}
#'   \item{Shelf}{Shelf}
#'   \item{Slope}{Slope}
#'   \item{IceConSpr}{IceConSpr}
#'   \item{IceConSum}{IceConSum}
#'   \item{IceConFal}{IceConFal}
#'   \item{IceConWin}{IceConWin}
#'   \item{LandDist}{LandDist}
#'   \item{WaveHeight}{WaveHeight}
#'   \item{TidalRange}{TidalRange}
#'   \item{Abyssal}{Abyssal}
#'   \item{Coral}{Coral}
#'   \item{Estuary}{Estuary}
#'   \item{Seamount}{Seamount}
#'   \item{MPA}{MPA}
#'   \item{SST1950}{SST1950}
#'   \item{SBT1950}{SBT1950}
#'   \item{Salinity1950}{Salinity1950}
#'   \item{SalinityB1950}{SalinityB1950}
#'   \item{PrimProd1950}{PrimProd1950}
#'   \item{IceCon1950}{IceCon1950}
#'   \item{SST1999}{SST1999}
#'   \item{SBT1999}{SBT1999}
#'   \item{Salinity1999}{Salinity1999}
#'   \item{SalinityB1999}{SalinityB1999}
#'   \item{PrimProd1999}{PrimProd1999}
#'   \item{IceCon1999}{IceCon1999}
#'   \item{SST2050}{SST2050}
#'   \item{SBT2050}{SBT2050}
#'   \item{Salinity2050}{Salinity2050}
#'   \item{SalinityB2050}{SalinityB2050}
#'   \item{PrimProd2050}{PrimProd2050}
#'   \item{IceCon2050}{IceCon2050}
#'   \item{SST2100}{SST2100}
#'   \item{SBT2100}{SBT2100}
#'   \item{Salinity2100}{Salinity2100}
#'   \item{SalinityB2100}{SalinityB2100}
#'   \item{PrimProd2100}{PrimProd2100}
#'   \item{IceCon2100}{IceCon2100}
#'   \item{SST1950c}{SST1950c}
#'   \item{SBT1950c}{SBT1950c}
#'   \item{Salinity1950c}{Salinity1950c}
#'   \item{SalinityB1950c}{SalinityB1950c}
#'   \item{PrimProd1950c}{PrimProd1950c}
#'   \item{IceCon1950c}{IceCon1950c}
#'   \item{SST2050c}{SST2050c}
#'   \item{SBT2050c}{SBT2050c}
#'   \item{Salinity2050c}{Salinity2050c}
#'   \item{SalinityB2050c}{SalinityB2050c}
#'   \item{PrimProd2050c}{PrimProd2050c}
#'   \item{IceCon2050c}{IceCon2050c}
#'   \item{SST2100c}{SST2100c}
#'   \item{SBT2100c}{SBT2100c}
#'   \item{Salinity2100c}{Salinity2100c}
#'   \item{SalinityB2100c}{SalinityB2100c}
#'   \item{IceCon2100c}{IceCon2100c}
#'   \item{PrimProd2100c}{PrimProd2100c}
#' }
#' @source \url{https://www.aquamaps.org/}
"aquatic_hcaf"

