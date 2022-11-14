testthat::test_that("pagination works vertically", {
  # pre-processing and ordering
  tmp_data <- ex_adae %>%
    dplyr::select(USUBJID, AGE, BMRKR1) %>%
    dplyr::slice(1:30) %>%
    distinct()

  lsting <- as_listing(tmp_data,
    key_cols = c("USUBJID", "AGE")
  ) %>%
    add_listing_col("BMRKR1", format = "xx.x")

  pages_listings <- paginate_listing(lsting, lpp = 4)

  page1_result <- toString(matrix_form(pages_listings[[1]]))
  page2_result <- toString(matrix_form(pages_listings[[2]]))

  page1_expected <- paste0(
    "Unique Subject Identifier   Age   Continous Level Biomarker 1\n",
    "—————————————————————————————————————————————————————————————\n",
    "AB12345-BRA-1-id-134        47                6.5            \n",
    "AB12345-BRA-1-id-141        35                7.5            \n",
    "AB12345-BRA-1-id-236        32                7.7            \n"
  )
  page2_expected <- paste0(
    "Unique Subject Identifier   Age   Continous Level Biomarker 1\n",
    "—————————————————————————————————————————————————————————————\n",
    "AB12345-BRA-1-id-265        25               10.3            \n",
    "AB12345-BRA-1-id-42         36                2.3            \n",
    "AB12345-BRA-1-id-65         25                7.3            \n"
  )
  testthat::expect_equal(page1_result, page1_expected)
})
