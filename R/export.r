#' Export results from as csv (tempfile)
#' 
#' @param tbl data frame with results from calc_probs
#' @return filename for temp file with csv results
#' @export
export_am_csv_tmp <- function(tbl) {
  res <- tbl %>% select(species, loiczid, prod_p, geomprod_p)
  fname <- paste0(tempfile(), ".csv")
  # "_", sub("\\s", "_", .latinname), ".csv")  
  message("exporting csv results to ", fname)  
  write.csv(res, file = fname, row.names = FALSE)
  return (fname)
}



