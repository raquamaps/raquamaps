context("scrape")

test_that("dl of Barracuda native range works", {
  df <- nativerange("Sphyraena sphyraena")
  expect_gt(nrow(df$occ), 0)
})

test_that("listing Barracuta native range maps works", {
  ids <- get_am_name_uris("Sphyraena sphyraena")
  maps1 <- raquamaps:::get_am_nativerangemap_uris(ids[1])
  maps2 <- raquamaps:::get_am_nativerangemap_uris(ids[2])
  success <- (length(maps1) > 0 && length(maps2) > 0)
  expect_true(success)
})

test_that("resolution of latin names into aquamaps.org identifiers work", {
  ids <- get_am_name_uris("Sphyraena sphyraena")  
  expect_gt(length(ids), 1)
})

test_that("dl of native range works for various species under Sphyraena ", {
  
  a <- nativerange("Sphyraena acutipinnis")
  b <- nativerange("Sphyraena ensis")
  c <- nativerange("Sphyraena vulgaris")
  d <- nativerange("Sphyraena sphyraena picuda")
  e <- nativerange("Sphyraena sphyraena picuda", "Fis-23821")
  
  success <- 
    (nrow(a$occ) > 0 && nrow(b$occ) > 0 &&
    nrow(c$occ) > 0 && nrow(d$occ) > 0 &&
    nrow(e$occ) > 0)
  
  expect_true(success)
    
})

test_that("dl of Sphyraena helleri errors out", {
  expect_error(nativerange("Sphyraena helleri"))
})
