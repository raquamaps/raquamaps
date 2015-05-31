get_data <- function(x) 
  tbl_df(get(data(list = x)))

#' Default bioclimate variable names in raquamaps
#' 
#' This function returns a vector with the default relevant 
#' environmental parameter names for demonstrational purposes
#' @examples
#' \dontrun{
#'  clim_vars <- default_clim_vars()
#' }
#' @export
default_clim_vars <- function() {
  c(
    "Elevation",
    "TempMonthM",
    "NPP",
    "SoilpH",
    "SoilMoistu",
    "PrecipAnMe",
    "CTI_Max",
    "SoilCarbon"
    #  "annual runoff"?
  )
  
}

#' Default species in raquamaps
#' 
#' This function returns the default species latin name
#' for demonstrational purposes
#' 
#' @examples
#' \dontrun{
#'  species <- default_species()
#' }
#' @export
default_species <- function() {
  "galemys pyrenaicus"
}

#' Default half degree cells reference data, including
#' geometry and bioclimate measurements, for demonstrational
#' purposes
#' 
#' This function returns a data frame with reference data
#' @examples
#' \dontrun{
#'  hcaf <- default_hcaf()
#' }
#' @export
default_hcaf <- function(.clim_vars = default_clim_vars()) {
  
  replace_9999 <- function(x) 
    ifelse(round(x) == -9999, NA, x)

  hcaf <- 
    get_data("aquamaps_hcaf_eu") %>%
    # discard irrelevant fields
    # and rename the cell identifier column name to
    # harmonize with the other datasets
    select(loiczid = LOICZID, one_of(.clim_vars))

    # TODO: FIXME so NA values are OK throughout calcs  
#  hcaf %>%
    # recode values across climate variable columns 
    # substitute -9999, use NA instead
#    mutate_each(funs(replace_9999), -loiczid)
  
  return (hcaf)
}

#' Default presence data for several species, for demonstrational
#' purposes
#' 
#' This function returns a data frame with reference data to
#' indicate cells with presence of species
#' @examples
#' \dontrun{
#'  presence <- default_presence()
#' }
#' @export
default_presence <- function() {

  res <- 
    get_data("aquamaps_presence_occurrences") %>%
    # use boolean instead of text to indicate presence
    mutate(occurrence = (occurrence == "t")) %>%
    # clean up input data - discard irrelevant fields
    select(-csquarecode)

  return (res)

}

#' Default set of species for demonstrational purposes
#' 
#' This function returns a data frame with reference data suggesting 
#' a set of species to be used in calculations
#' @examples
#' \dontrun{
#'  species_list <- default_species_list()
#' }
#' @export
default_species_list <- function() {
  
  res <-
    # for all species occurring in the default dataset
    default_presence() %>%
    # extract a list of all latin names 
    group_by(lname) %>%
    # calculate the widest distribution 
    summarise(count = n_distinct(loiczid)) %>%
    # order with those species at the top
    arrange(desc(count)) %>%
    # only return the species names and the counts
    select(species = lname, count)
  
  return (res)
}

#' Return all grid cells identifiers where the specified species occurs
#' @param .presence dataset with presence data for various speciess
#' @param .latinname latin name for species
#' @export
which_cells <- function(
  .presence = default_presence(),
  .latinname = default_species()) {
  
  res <- 
    .presence %>%
    filter(
      occurrence == TRUE, 
      lname %in% .latinname
    ) %>%
    distinct(loiczid) %>%
    arrange(desc(loiczid)) %>%
    select(loiczid)
  
  return (res)  
}

#' Default half degree cells reference data, including
#' geometry and bioclimate measurements, for demonstrational
#' purposes, filtered for a specific species and for specific
#' bioclimate measurements
#' 
#' This function returns a data frame with reference data consisting of
#' environmental data for only those cells that have a specific species present
#' 
#' @param .latinname character string with latin name for species
#' @param .vars vector of climate variable names to use
#' @examples
#' \dontrun{
#'  hcaf <- hcaf_by_species(default_species(), default_clim_vars())
#' }
#' @export
hcaf_by_species <- function(
  .latinname = default_species(), 
  .vars = default_clim_vars()) {  
  
  presence_cells <- which_cells(default_presence(), .latinname)
  hcaf <- default_hcaf(.vars)
  
  res <- inner_join(hcaf, presence_cells, by = "loiczid")
  
  return (res)
}

#' Calculate environmental data spread summaries
#' given environmental data for a species
#' 
#' @param .hcaf_species data frame with environmental data for one species

#' @examples
#' \dontrun{
#'  spreads <- calc_spreads(hcaf_by_species())
#' }
#' @export
calc_spreads <- function(.hcaf_species) {

  spread_measures <- funs(
    n = n(),
    n_distinct = n_distinct(.),
    n_NA = sum(is.na(.)),
    min = min(., na.rm = TRUE),  
    max = max(., na.rm = TRUE),
    q1 = quantile(., probs = c(0.25), names = FALSE, na.rm = TRUE),  
    q3 = quantile(., probs = c(0.75), names = FALSE, na.rm = TRUE),
    d1 = quantile(., probs = c(0.10), names = FALSE, na.rm = TRUE),
    d9 = quantile(., probs = c(0.90), names = FALSE, na.rm = TRUE)
  )
  
  res <- 
    # pivot the cell data to (loiczid, Measure, value) tuples
    tbl_df(melt(.hcaf_species, id.vars = "loiczid", variable.name = "Measure")) %>%
    # group by each bioclimate Measure and remove the cell id
    group_by(Measure) %>% select(-loiczid) %>%
    # apply a set of functions to each column (only numerical "value")
    summarise_each(spread_measures) %>%
    # add new columns with calculated range measures
    mutate(range = max - min, iqr = q3 - q1, idr = d9 - d1) %>%
    # round each column except the first one
    mutate_each(funs(round), -Measure)
  
  return (res)
}

#' Function to calculate probability per individual bioclimate
#' variable given "spread" summary stats for a single environment 
#' envelope parameter
#' 
#' @param x bioclimate parameter value
#' @param min the min statistics for this bioclimate variable
#' @param max the max statistics for this bioclimate variable
#' @param d1 the first decile for for this bioclimate variable
#' @param d9 the ninth decile for this bioclimate variable

#' @examples
#' \dontrun{
#'  p <- calc_prob(1, 1, 1, 1)
#' }
#' @export
calc_prob <- function(x, min, max, d1, d9) {  
  
  if (is.na(x)) 
    return (NA)
  
  if (length(x) > 1)
    warning("calc_prob is atomic, but got x = ", x)
  
  if (x < -9999 || x <= min || x >= max) 
    return (0)
  
  if (x == -9999 || (x >= d1 && x <= d9))
    return (1)
  
  p <- NA
  
  if (x >= min && x < d1 && ((d1 - min) != 0)) {
    p <- (x - min) / (d1 - min)
  }
  
  if (x >= d9 && x < max && ((max -d9) != 0)) {
    p <- (max - x) / (max - d9)
  }
  
  if (between(p, 0, 1)) return (p)
  if (p > 1) return (min(1, p))
  if (p < 0) return (max(0, p))
  
  # if none of the rules matched, return NA
  warning("Invalid data: x=", x, 
          " min=", min, " max=", max,
          " d1=", d1, " d9=", d9, 
          " returning NA")
  
  return (NA)
}

# TODO: How can I use this and evaluate it at runtime?
default_model <- paste(default_clim_vars(), collapse = " * ")

#' Function to calculate probabilities
#' 
#' @param hcaf_species data frame with half degree cell parameter values for relevant bioclimate variables
#' @param spreads data frame with environmental envelope information (spreads for relevant bioclimate variables)
#' 
#' @examples
#' \dontrun{
#'  p <- calc_probs(hcaf_by_species(), spreads)
#' }
#' @export
calc_probs <- function(hcaf_species, spreads) {   
  
  #t %>% filter(Measure == "NPP") %>% mutate(p = calc_prob(value, min, max, d1, d9))
  res <- 
    # pivot the cell data to (loiczid, Measure, value) tuples
    tbl_df(melt(hcaf_species, id.vars = "loiczid", variable.name = "Measure")) %>%
    # group by each bioclimate Measure and cell id
    group_by(Measure, loiczid) %>% 
    # add columns with relevant spread measures
    left_join(spreads, by = "Measure") %>%
    # apply a set of functions to relevant column (here "value")
    mutate(p = calc_prob(value, min, max, d1, d9)) %>%
    # use only resulting probabilites for all (measure, cell) tuples
    select(Measure, loiczid, p) %>% 
    # pivot (cast) to get probabilities in columns (wide instead of thin)
    dcast(formula = loiczid ~ Measure, value.var = "p") %>%
    # calculate the combined probabilities (the model) for each cell
    mutate(
      # TODO: make the model here pluggable, ie use default_model()
      prod_p = Elevation * TempMonthM * NPP * SoilpH * 
        SoilMoistu * PrecipAnMe * CTI_Max * SoilCarbon,
      #    prod_p_vif6 = Elevation * SoilMoistu * CTI_Max * NPP * Bio5 * Bio15,
      #    prod_p_vif9 = prod_p_vif6 * Bio8 * Bio8 * Bio18,         
      geomprod_p = prod_p ^ (1 / length(default_clim_vars()))
    ) 
  return (tbl_df(res))
}

#' Adjustment of climate summary stat values during envelope 
#' parameter calculation
#' 
#' This function takes a data frame with bioclimate parameter
#' spread data and returns a similar data frame but with
#' various adjustments for extreme values. This function works
#' using a set of correction rules defined inline and reflecting
#' adjustment limits as described in a separate paper (ref: Tamas Jantevik)
#' 
#' @param spreads data frame with spread data to adjust
#' 
#' @examples
#' \dontrun{
#'  adjusted_spreads <- adjust_spreads(spreads)
#' }
#' @export
adjust_spreads <- function(spreads) {
  
  # landcover special case: ? TODO understand if this is needed (int values 1 .. 23)
  # SoilpH, SoilCarbon, NPP: if -9999 reset to min of non-neg values
  
  # Adjustment of spread summary stats data
  adj_data <- read.csv(header = TRUE, textConnection(
    gsub("[ ]{3,}", "", x = 
           "Measure, MinRange, MaxRange, ErrTol, AdjDist
         Elevation, 0, 5669, 2, 1
         TempMonthM, -14, 36, 1, 1 / 2
         NPP, 6 / 1000, 1269 / 1000, NA, NA
         SoilpH, 0, 8522 / 1000, 1, 1 / 2
         SoilMoistu, 1 / 10, 300, 1, 1 / 2
         CTI_Max, 293, 2423, 2, 1
         PrecipAnMe, 0, 64019 / 100, 1, 1 / 2
         SoilCarbon, 0, 24876 / 1000, 1, 1 / 2"
         #"runoffannual", 0, 69, 2, 1   
    )))
  
  adjustments <- 
    tbl_df(adj_data) %>%
    # rowwise() %>%  # if this is used then there will be no Measure column
    group_by(Measure) %>%
    summarise_each(funs(eval(parse(text = .))), -Measure)
  
  adjust_values <- function(x) {
    
    s <- x
    
    # Extreme value adjustment due to out of bounds (min, max)
    if (s$min < s$MinRange)
      s$min <- max(s$MinRange, s$q1 - 3 / 2 * s$iqr)
    if (x$max > x$MaxRange)
      s$max <- min(s$MaxRange, s$q3 + 3 / 2 * s$iqr)
    s$range <- s$max - s$min
    
    # First / last decile value adjustments
    
    # due to low n
    if (s$n < 10) 
      warning("sample size of less than 10 cells not allowed!")
    #   if (s$n >= 10 && s$n <= 13) {
    #     s$d1 <- round((10 * s$n + 1)/100)  
    #     s$d9 <- round((90 * s$n + 1)/100 - 2)
    #   }
    #   if (s$n > 13) {
    #     s$d1 <- round((10 * s$n + 1)/100 - 1)  
    #     s$d9 <- round((90 * s$n + 1)/100 - 1)
    #   }
    
    # due to too small difference
    if (!is.na(s$ErrTol) && s$idr < s$ErrTol) {
      s$d1 <- idr - s$AdjDist
      s$d9 <- idr + s$AdjDist
    }  
    
    # update interdecile range
    s$idr <- s$d9 - s$d1
    
    return (s)
  }
  
  res <- 
    left_join(spreads, adjustments, by = "Measure") %>%
    group_by(Measure) %>%
    do(adjust_values(.)) %>%
    select(one_of(names(spreads))) %>%
    ungroup %>% 
    mutate_each(funs(round), -Measure)
  
  return(res)
}

#' Retrieve environmental data and determine spread
#' for a given species, using the bundled reference data
#' 
#' @param .latinname character string with latin name for species
#' 
#' @examples
#' \dontrun{
#'  spread_default <- calc_spreads_by_species(default_species())
#' }
#' @export
calc_spreads_by_species <- function(.latinname) {
  hs <- hcaf_by_species(.latinname)
  s <- calc_spreads(hs)
  #adjust_spreads(spreads_species)
  return (s)
}

#' Retrieve environmental, determine spread and return
#' probabilities for a given species, using the bundled reference data
#' 
#' @param .latinname character string with latin name for species
#' 
#' @examples
#' \dontrun{
#'  probs_default <- calc_probs_by_species(default_species())
#' }
#' @export
calc_probs_by_species <- function(.latinname) {
  hs <- hcaf_by_species(.latinname)
  s <- calc_spreads_by_species(.latinname)
  tbl_df(calc_probs(hs, s))
}



#FIXME! Onesime: It is strange to have -9999 in the spreadz data table
# maybe better to have NA values or rather min(values, na.rm = TRUE)

# first only for cells in the "bounding box", so that the user
# can see if it is necessary to adjust parameters

# at this point, the calculation should be made for either
# a) the whole world - all cells in there (SUITABLE HABITAT)
# b) the NATIVE HABITAT - using the presence_basins data

suitable_habitat <- function(species) {
  # by default return all 0.5 degree cells in the whole world
  # ie 259200 cells
  # but sometimes someone might want to restrict to
  # a) country (?)
  # b) europe or other continent
  # User needs to define:
  # I am working with fresh water only (so we can then reduce 
  # cells by removing all marine cells)
  # Land, Marine, Ocean, Island, all areas with glaciers, coastline
}

native_habitat <- function(species) {
  # by default return all cells in the presence_basins where
  # this species have presence  
}

