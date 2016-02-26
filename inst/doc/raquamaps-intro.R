## ---- echo=TRUE, message=FALSE, warning=FALSE----------------------------

# plotting
require("classInt")
require("ggplot2")
require("raster")
require("RColorBrewer")

# data modelling
#require("rgbif")
require("raquamaps")

# data manipulation
#require("plyr")
require("dplyr")
require("reshape2")

# we set our preference for how 
# we choose to interpret string data 
# throughout this tutorial
options(stringsAsFactors = FALSE)


## ------------------------------------------------------------------------

# Inspect documentation for reference datasets
# that are bundled into the package with this ...

# data(package = "raquamaps")

# Get and print names of bundled datasets 
# in the raquamaps package
datasets <- data(package = "raquamaps")$results[ ,"Item"]
print(datasets)

# Load and unload one of the bundled datasets 
# into your current  environment
data("aquamaps_galemys_pyrenaicus")  # load
rm("aquamaps_galemys_pyrenaicus")  # unload

# If you want to load a dataset into your own variable you can ...
# Define a helper function to load reference data from 
# an R package as a data frame that displays nicely
get_data <- function(x) 
  tbl_df(get(data(list = x)))

# ... and use it to load a dataset into your own named variable
hcaf_eu <- get_data("aquamaps_hcaf_eu")
galemys <- get_data("aquamaps_galemys_pyrenaicus")

# Here we load the European cell authority fields, ie half degree cell
# data including geometry and an explicitly defined set of bioclimate 
# variables 
clim_vars <- c(
  "Elevation", 
  "TempMonthM", 
  "NPP", 
  "SoilpH", 
  "SoilMoistu", 
  "PrecipAnMe", 
  "CTI_Max", 
  "SoilCarbon")

hcaf <- 
  get_data("aquamaps_hcaf_eu") %>%
  # discard irrelevant fields
  # and rename the cell identifier column name to
  # harmonize with the other datasets
  dplyr::select(loiczid = LOICZID, one_of(clim_vars)) 

# Define a cleanup function, intended for use across columns
replace_9999 <- function(x) 
  ifelse(round(x) == -9999, NA, x)

# We apply the above cleanup function across columns, dplyr style
hcaf_eu <- 
  hcaf %>%
  # recode values across climate variable columns 
  # substitute -9999, use NA instead, exclude the "loiczid" column
  mutate_each(funs(replace_9999), -loiczid)

hcaf_eu

## ------------------------------------------------------------------------
# Suggested set of bioclimate variables
clim_vars <- default_clim_vars()

# One specific species name - the default species - Galemys pyrenaicus
species <- default_species()

# Several species names available in the reference data
species_list <- default_species_list()

# European half degree cell reference data for some relevant bioclimate variables
hcaf_eu <- default_hcaf()

# Presence data for all species in the bundled
# reference data, including grid cell identifiers (loiczids)
presence_occs <- default_presence()

# Showing a "dplyr inspired way" to load presence data
# which demonstrates using dplyr API with a
# "pipe" operator that chains operations together sequentially, 
# each step sending its output as input to the next step, 
# going from left to right
presence_galemys <- 
  default_presence() %>% 
  filter(lname == default_species())

# Yet another way to display grid cell identifiers (loiczids) 
# for the default species 
presence_loiczids <- 
  presence_occs %>%
  filter(lname == default_species()) %>%
  group_by(loiczid) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

# Another variant on the same thing
presence_galemys_pyrenaicus <- 
  presence_occs %>%
  # retain only records for a specific latin name
  filter(lname == "galemys pyrenaicus") %>%
  # in case of duplicate cell ids, retrieve only distinct ids
  distinct(loiczid) %>%
  #  group_by(loiczid) %>%
  dplyr::select(loiczid)

# Get a list of all latin names  for all species in the 
# bundled occurrence dataset ordered with the species with 
# the most dispersed distribution (ie highest number of distinct 
# different cells) at the top
presence_occs %>%
  group_by(lname) %>%
  summarise(count = n_distinct(loiczid)) %>%
  arrange(desc(count)) %>%
  dplyr::select(species = lname, count)


## ------------------------------------------------------------------------
# We find bioclimate variable data from half degree cells
# where a specific species has been present
hcaf_galemys <- hcaf_by_species("galemys pyrenaicus")

# We determine the spreads across these particular grid cells
# ie calculate the environmental envelope for the species
spreads_galemys <- calc_spreads(hcaf_galemys)

# We can also use this wrapper function for convenience
calc_spreads_by_species("galemys pyrenaicus")


## ------------------------------------------------------------------------
# Calculate probabilites across European grid cells, 
# given this particular species preference for environmental envelopes
hcaf_eu <- default_hcaf()

# You can inspect the model used by inspecting the calc_prob and calc_probs 
# functions, ie uncomment lines below and run in R to inspect the functions:
# calc_prob
# calc_probs
# You can see how prod_p is calculated in the calc_probs function, ie:
# prod_p = Elevation * TempMonthM * NPP * SoilpH * 
#        SoilMoistu * PrecipAnMe * CTI_Max * SoilCarbon
# where those factors are individual p values determined by calc_prob using
# the spread or environmental envelope preference
probs <- calc_probs(hcaf_eu, spreads_galemys)

# TODO: Calculate across whole world
# hcaf_world <- 
#   get_data("aquamaps_hcaf_world") %>%
#   rename(loiczid = LOICZID) %>% 
#   select(loiczid, one_of(clim_vars))
# x <- as.numeric(hcaf_world$CTI_Max)
# x[is.na(x)] <- -9999
# x[x == ""] <- -9999
# hcaf_world$CTI_Max <- x
# hcaf_world$NPP <- runif(nrow(hcaf_world), min = 0, max = 1)
# system.time(
#   probs <- calc_probs(hcaf_world, spreads_galemys)
# )

# Define custom plot style to use in ggplot2 plots
theme_raquamaps <- function() {
  theme <- theme_bw() + theme(
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10),
      panel.background = element_blank(), 
      plot.background = element_blank(),
      panel.grid.minor = element_blank(), 
      panel.grid.major = element_blank())
}

# Plot a histogram of the probabilities  
ggplot(probs, aes(x = probs$p)) + theme_raquamaps() +
  geom_bar(fill = "darkgreen", colour = "darkgray")


## ---- echo=TRUE----------------------------------------------------------

# Get presence data for Great White Shark from rgbif
# jagged_tooth <- "Carcharodon carcharias"
#gws <- presence_rgbif(jagged_tooth)
#gws <- get_data("rgbif_great_white_shark")
gws <- get_data("rgbif_galemys_pyrenaicus")

# Plot the point data, with a world map to provide context
world <- ggplot2::map_data("world")
ggplot(world, aes(x = long, y = lat, group = group)) +
  # paint country border
  geom_path(color = "gray50", alpha = 0.4) +
  # add general styling
  theme_raquamaps() + coord_cartesian() +
  # zoom in to Europe
  coord_cartesian(xlim = c(-20, 10), ylim = c(35, 50)) +
  # add point data
  geom_point(data = gws, 
     aes(x = gws$decimalLongitude, 
        y = gws$decimalLatitude, group = 0),
     alpha = 0.1, color = "darkgreen")

# We need at least 5 observations per half degree cell, 
# and need to find those grid cells where the species is present
r <- rasterize_presence(gws)
loiczids <- which_cells_in_raster(r, 5)

hcaf_gws <- 
  # use European half degree cell authority file
  default_hcaf() %>%
  # return only cells where there was presence
  filter(loiczid %in% loiczids)

# Now we know where this species is likely to be present 
# and we determine the corresponding bioclimate variable parameter 
# spread for the cells with known presence

spread_gws <- calc_spreads(hcaf_gws)

# Finally we calculate relative probabilities for presence in 
# other cells, assuming that cells with similar "environmental envelope" 
# is more likely to be a suitable habitat for this species 

hcaf_eu <- default_hcaf()
p <- calc_probs(hcaf_eu, spread_gws)

# Using half degree cell grid data for the whole world
# TODO: unfortunately we miss bioclimate variable data for the full
# world grid, this should be added
hdc_world <- 
  tbl_df(get(data("aquamaps_hc"))) %>%
  mutate(loiczid = LOICZID) %>%
  dplyr::select(-LOICZID)
rownames(hdc_world) <- hdc_world$loiczid

# TODO: Ask Sven K for reasonable habitat


## ------------------------------------------------------------------------

# Put the probabilities into a raster layer
r <- raster(ncol = 720, nrow = 360)
r[p$loiczid] <- p$prod_p

# Convert raster layer data to a data frame
# to simpligy plotting with ggplot2
cx <- coordinates(r)[ ,1]
cy <- coordinates(r)[ ,2]
df <- data.frame(x = cx, y = cy, p = values(r))

# Shows how to use Fisher-Jenks style class intervals
# for coloring in the plot
fisher_intervals <- classIntervals(df$p, n = 5, style = "fisher")
p_steps <- cut(df$p, breaks = fisher_intervals$brks)

# For now we just go with a standard five-stepped
# sequential color scheme
breakpoints <- c(0, 0.2, 0.4, 0.6, 0.8, 1)
colors <- brewer.pal(5, "YlOrRd")
p_steps <- cut(df$p, breaks = breakpoints)

# Plot raster data along with the world map
map_gws <- 
  ggplot(world, aes(x = long, y = lat, group = group)) +
  # zoom in to Europe
  coord_cartesian(xlim = c(-50, 50), ylim = c(20, 75)) +
  # use specific styling
  theme_bw() + theme(
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10),
      panel.background = element_blank(), 
      plot.background = element_blank(),
      panel.grid.minor = element_line(colour = "gray95"),
      panel.grid.major = element_line(colour = "gray95"),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      axis.line = element_blank(),
      axis.title = element_blank(),
      panel.border = element_blank()) +  
  # add the raster data that was converted to a data frame earlier
  geom_raster(data = df, aes(x, y, fill = p_steps, group = NULL)) +
  # this determines colors used, inspired by aquamaps.org
  scale_fill_brewer(type = "seq", palette = "YlOrRd", name = "Probabilities") +
  # outline country border with a light gray color
  geom_path(color = "gray70", alpha = 0.4) +
  # add grid lines to the map
  scale_y_continuous(breaks=(-2:2) * 30) +
  scale_x_continuous(breaks=(-4:4) * 45)

# We now display this plot
map_gws

# To export this map, ggsave can be used
#ggsave(filename = "map.png", plot = map_gws, 
#       width = 5, height = 4, units = "cm")

# To export the raster data one can save the raster
# or export the corresponding data frame to csv, like so:
# write.csv2(tbl_df(df), file = "rasterdata.csv")


## ------------------------------------------------------------------------
# Calculate spreads for several species at once
# dplyr style, limit calculation to top 10 species
species_list %>% 
  filter(count > 100) %>%
  head(10) %>%
  group_by(species) %>%
  do(calc_spreads_by_species(.$species))

# Create a function to wrap several steps into one
# first calculate environmental envelope for a species
# then calculate probabilities across European grid

calc_probs_species <- function(.latinname) {
#  hcaf_species <- hcaf_by_species(.latinname)
  spreads_species <- calc_spreads_by_species(.latinname)
  hcaf_eu <- default_hcaf()
  probs <- tbl_df(calc_probs(hcaf_eu, spreads_species))
  return (probs)
}

# Now we use the function above to calculate probabilities
# for just one species
calc_probs_species(species_list$species[2])

# However, we want to use the function above now 
# to calculate probabilities for several species,
# Here is how we do that, dplyr style, including
# how to limit to 10 species in one batch calculation
batch_of_ten <- 
  species_list %>%
  head(10) %>%
  group_by(species) %>%
  do(calc_probs_species(.$species))


## ------------------------------------------------------------------------

## ------------------------------------------------------------------------
# How to merge several species into one
# say we have two synonyms, use this technique
# which_cells(c("galemys pyrenaicus", "mergus merganser"))

