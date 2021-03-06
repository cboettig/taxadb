context("taxadb")

library(testthat)
library(taxadb)
library(dplyr)


test_that("we can set up a db and call basic functions", {
  db <- td_connect()
  df <- taxa_tbl(db = db, provider = "itis_test")

  sp <- df %>%
    filter(family == "Cebidae") %>%
    collect()

  df <- filter_rank(name = "Cebidae",
                    rank = "family",
                    db = db,
                    provider = "itis_test")  %>%
    filter(taxonomicStatus == "accepted")


  species <- filter_name(df$scientificName,
                         db = db,
                         provider = "itis_test") %>%
    filter(taxonomicStatus == "accepted")

  ## confirm order did not change
  expect_true(all(df$scientificName %in% species$scientificName))


  expect_is(df, "data.frame")
  expect_is(species, "data.frame")
  expect_is(sp, "data.frame")
  expect_gt(dim(df)[1], 1)
  expect_gt(dim(sp)[1], 1)

  ## we can opt out of ignore_case on ids():
  species <- filter_name(df$scientificName,
                 db = db,
                 ignore_case = FALSE) %>%
    filter(taxonomicStatus == "accepted")
  expect_is(species, "data.frame")
  expect_gt(dim(species)[1], 1)


  ## filter_id() takes IDs instead of names:
  names <- filter_id(id = df$taxonID,
                 db = db)
  expect_is(names, "data.frame")
  expect_gt(dim(names)[1], 1)
})

