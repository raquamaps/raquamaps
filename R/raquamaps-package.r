#' raquamaps
#' 
#' raquamaps provides tools that make it easier to produce Aqua Maps.
#' 
#' AquaMaps is a project involving tools for generating model-based, 
#' large-scale predictions of natural occurrences of species.
#' For marine species, the model uses estimates of environmental preferences 
#' with respect to depth, water temperature, salinity, primary productivity, 
#' and association with sea ice or coastal areas.
#' These estimates of species preferences, called environmental envelopes, 
#' are derived from large sets of occurrence data available from online 
#' collection databases.
#' @references Kaschner, K., R. Watson, A.W. Trites and D. Pauly. 2006. 
#'  Mapping worldwide distributions of marine mammals using a Relative 
#'  Environmental Suitability (RES) model. Mar. Ecol. Prog. Ser. 316:285-310.
#' @references Ready, J., K. Kaschner, A.B. South, P.D. Eastwood, 
#'  T. Rees, J. Rius, E. Agbayani, S. Kullander, and R. Froese. 2010. 
#'  Predicting the distributions of marine organisms at the global scale. 
#'  Ecol. Model. 221: 467-478, doi:10.1016/j.ecolmodel.2009.10.025
#' @references Kesner-Reyes, K., K. Kaschner, S. Kullander, C. Garilao, 
#'  J. Barile, and R. Froese. 2012. AquaMaps: algorithm and data sources 
#'  for aquatic organisms. In: Froese, R. and D. Pauly. Editors. 2012. FishBase. 
#'  World Wide Web electronic publication. www.fishbase.org, version (04/2012).
#' @references Östergren J, Kullander S O, Prud'homme O, Reyes K K, 
#'  Kaschner K and Froese R (in preparation) Predicting freshwater-dependent 
#'  species distributions in Europe
#' @name raquamaps
#' @import dplyr reshape2 crayon httr
#' @docType package
NULL