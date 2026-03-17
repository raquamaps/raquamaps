require("plyr")
require("dplyr")
require("reshape2")

# tools::showNonASCII(readLines("R/raquamaps-package.r"))

options(stringsAsFactors = FALSE)

# relevant environmental parameters
clim_vars <- c(
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

# load demo data from raquamaps

get_am_data <- function(x) 
  tbl_df(get(data(list = x)))

ds <- c(
  # half degree cell authority files w bioclimate data for EUR
  "aquamapsdata_HCAF_EU_Grid_WGS84", 
  # presence data for one species
  "aquamapsdata_GoodCelles_galemys_pyrenaicus_WGS84",  
  # presence data for several species
  "aquamapsdata_presence_occurrences",
  # 493 occ of "Galemys pyrenaicus" with coords from GBIF Spain
  "aquamapsdata_GBIF_galemys_pyrenaicus_WGS84",
  # world grid in half degree cells including identifiers ("loiczid" etc)
  "aquamapsdata_Hdc_grid",
  # one row of IUCN info on Galemys pyrenaicus (to be removed)
  "aquamapsdata_IUCN_galemys_pyrenaicus_WGS84",
  # refdata for some species, including their cateogry and
  # presence (loiczid) with waster basin flag
  "aquamapsdata_presence_basins"
)

# load the cell authority fields, data for half degree cells
# including geometry and bioclimate mesurements and clean up



replace_9999 <- function(x) 
  ifelse(round(x) == -9999, NA, x)

hcaf <- get_am_data(ds[1]) %>%
  # discard irrelevant fields
  # and rename the cell identifier column name to
  # harmonize with the other datasets
  select(loiczid = LOICZID, mget(clim_vars)) 

hcaf %>%
  # recode values across climate variable columns 
  # substitute -9999, use NA instead
  mutate_each(funs(replace_9999), -loiczid)

# load presence data for one species - Galemys pyrenaicus
presence_tbl <- get_am_data(ds[2])

# load occurrence data for several species
presence_occs <- get_am_data(ds[3]) %>%
  # use boolean instead of text to indicate presence
  mutate(occurrence = (occurrence == "t")) %>%
  # clean up input data - discard irrelevant fields
  select(-csquarecode)

# free memory - remove unneeded variables
rm(list = ds, ds, presence_occs_tbl)

# get the grid cell ids with presence for a given species
presence_galemys_pyrenaicus <- 
  presence_occs %>%
  # retain only records for a specific latin name
  filter(lname == "galemys pyrenaicus") %>%
  # in case of duplicate cell ids, retrieve only distinct ids
  distinct(loiczid) %>%
  #  group_by(loiczid) %>%
  select(loiczid)

# inspect the first few rows
head(hcaf, 3)

# extract a list of all latin names 
# for all species in the occurrence dataset
# ordered with the species with the widest
# distribution at the top
species_list <-
  presence_occs %>%
  group_by(lname) %>%
  summarise(count = n_distinct(loiczid)) %>%
  arrange(desc(count)) %>%
  select(species = lname, count)

# how do I generate this from gbif-data
# using taxize and the new gbif api?



# find all grid cells where the specified species occurrs
which_cells <- function(.latinname) {
  presence_occs %>%
    filter(
      occurrence == TRUE, 
      lname %in% .latinname
    ) %>%
    distinct(loiczid) %>%
    arrange(desc(loiczid)) %>%
    select(loiczid)
}

# let's pretend we have two synonyms, get cells for this taxon
which_cells(c("galemys pyrenaicus", "mergus merganser"))


get_hcaf_species <- function(.latinname) {
  
  # get environmental data for only those 
  # cells that have species present
  
  if (missing(.latinname)) {
    .latinname <- "galemys pyrenaicus"
    warning("No latin name provided, defaulting to ", .latinname)
  }
  presence_cells <- which_cells(.latinname)
  res <- inner_join(hcaf, presence_cells, by = "loiczid")
  
  return (res)
}

hcaf_species <- get_hcaf_species()
hcaf_species <- get_hcaf_species(species_list$species[1])

calc_spreads <- function(hcaf_species) {
  
  # calculate environmental data spreads
  # given environmental data for a species
  
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
  
  # pivot the cell data to (loiczid, Measure, value) tuples
  tbl_df(melt(hcaf_species, id.vars = "loiczid", variable.name = "Measure")) %>%
    # group by each bioclimate Measure and remove the cell id
    group_by(Measure) %>% select(-loiczid) %>%
    # apply a set of functions to each column (only numerical "value")
    summarise_each(spread_measures) %>%
    # add new columns with calculated range measures
    mutate(range = max - min, iqr = q3 - q1, idr = d9 - d1) %>%
    # round each column except the first one
    mutate_each(funs(round), -Measure)
}

calc_spreads(hcaf_species)

spreads <- calc_spreads(hcaf_species)
#adj_spreads(spreads)


# calculate probabilities per individual bioclimate
# variable given summary stats for a single env envelope parameter
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

# How can I use this and evaluate it at runtime?
p_model <- paste(clim_vars, collapse = " * ")

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
      prod_p = Elevation * TempMonthM * NPP * SoilpH * 
        SoilMoistu * PrecipAnMe * CTI_Max * SoilCarbon,
      #    prod_p_vif6 = Elevation * SoilMoistu * CTI_Max * NPP * Bio5 * Bio15,
      #    prod_p_vif9 = prod_p_vif6 * Bio8 * Bio8 * Bio18,         
      geomprod_p = prod_p ^ (1 / length(clim_vars))
    ) 
  return (tbl_df(res))
}

system.time(
  p <- calc_probs(hcaf_species, spreads)
)

p
hist(p$prod_p)

# TODO try with other species and their respective spreads

adjust_spreads <- function(spreads) {
  
  # Adjustment of climate summary stat values during envelope calculation
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

# trial run - do everything from start to end

adj_spreads <- adjust_spreads(spreads)

spreads

# Now lets put it all together and do it for all species!

species_list

which_cells(.latinname = species_list$species[1])

# retrieve environmental data and determine spread
# for a given species
calc_spreads_species <- function(.latinname) {
  hcaf_species <- get_hcaf_species(.latinname)
  spreads_species <- calc_spreads(hcaf_species)
  #adjust_spreads(spreads_species)
  return (spreads_species)
}

calc_spreads_species(species_list$species[1])
calc_spreads_species(species_list$species[2])


# for each species, use its cells to calculate the envelope stats
species_list %>% 
  filter(count > 100) %>%
  group_by(species) %>%
  do(calc_spreads_species(.$species))

calc_probs_species <- function(.latinname) {
  hcaf_species <- get_hcaf_species(.latinname)
  spreads_species <- calc_spreads_species(.latinname)
  tbl_df(calc_probs(hcaf_species, spreads_species))
}

a <- calc_probs_species(species_list$species[2])

# for each species, use its cells to calculate the probs
species_list[2, ] %>%
  group_by(species) %>%
  do(calc_probs_species(.$species))

all_probs <- function() {
  res <- 
    species_list %>% 
    # filter(count > 10) %>%
    group_by(species) %>%
    do(calc_probs_species(.$species))  
  return (tbl_df(res))
}

system.time(
  p <- all_probs()
)

#FIXME! Onesime: It is strange to have -9999 in the spread data
# maybe better to have NA values or rather min(values, na.rm = TRUE)?

# first only for cells in the "bounding box", so that the user
# can see if it is necessary to adjust parameters

# bounding_box <- goodcellz

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

#install.packages("reshape2")
require("reshape2")

test <- data.frame(loiczid = c(1, 2), 
  Country1 = c("Sweden", "Norway"), 
  Country2 = c("Denmark", NA), 
  Country3 = c("France", "Belgium"))

reshape2::melt(test, c("loiczid"))


# have datasets with loiczid sets for various companies or other 
# geographical areas of interest

# then it is time to run the probability calculations / model
# for larger areas - like Europe or the full range of all of the world

# TODO!

export_probs_as_csv2 <- function(.latinname) {
  
  p <- all_probs()
  
  res <- 
    p %>%
    filter(species == .latinname) %>%
    select(species, loiczid, prod_p, geomprod_p)
  
  fname <- paste0(tempfile(), "_", 
                  sub("\\s", "_", .latinname), ".csv")
  
  message("exporting csv results for ", .latinname, 
          " to ", fname, "\n")
  
  write.csv(res, file = fname, row.names = FALSE)  
  
}

export_probs_as_csv2("galemys pyrenaicus")

# TODO

# raster output
# shiny map of raster
# now for loiczid cells, create raster 

# require("googleVis")
# df <- 
#   calc_spreads() %>% 
#   filter(Measure == "Elevation") %>% 
#   select(Measure, min, d1, d9, max)
# require("reshape2")
# df <- melt(df)
# df <- reshape2::dcast(df, variable ~ Measure, sum)
# linechart <- googleVis::gvisLineChart(df, xvar = "variable")
# plot(linechart)

# plot envelope per var as trapezoid curve googlevis

# shiny interactive chg of envelope using sliders
# followed by adjust_spread validation
