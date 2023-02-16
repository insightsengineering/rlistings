testthat::test_that("Listing print correctly", {
  lsting <- as_listing(anl, key_cols = c("USUBJID")) %>%
    add_listing_col("ARM")
  main_title(lsting) <- "this is some title"
  main_footer(lsting) <- "this is some footer"
  result <- export_as_txt(lsting, file = NULL)
  testthat::expect_snapshot(cat(result))
})
