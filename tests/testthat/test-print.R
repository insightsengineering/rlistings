testthat::test_that("Listing print correctly", {
  lsting <- as_listing(anl, key_cols = c("USUBJID")) %>%
    add_listing_col("ARM")
  result <- print(lsting)
  testthat::expect_snapshot(result)
})