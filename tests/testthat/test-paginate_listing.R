testthat::test_that("pagination works vertically", {
  # pre-processing and ordering
  tmp_data <- ex_adae %>%
 ##   dplyr::select(USUBJID, AGE, BMRKR1) %>%
    dplyr::slice(1:30) %>%
    distinct(USUBJID, AGE, BMRKR1, .keep_all = TRUE)

  lsting <- as_listing(tmp_data,
    key_cols = c("USUBJID", "AGE")
  ) %>%
    add_listing_col("BMRKR1", format = "xx.x")

  pages_listings <- paginate_listing(lsting, lpp = 4, verbose = TRUE)

  page1_result <- toString(matrix_form(pages_listings[[1]]))
  page2_result <- toString(matrix_form(pages_listings[[2]]))

  page1_expected <- paste0(
    "Unique Subject Identifier   Age   Continous Level Biomarker 1\n",
    "—————————————————————————————————————————————————————————————\n",
    "AB12345-BRA-1-id-134        47                6.5            \n",
    "AB12345-BRA-1-id-141        35                7.5            \n"
  )
  page2_expected <- paste0(
    "Unique Subject Identifier   Age   Continous Level Biomarker 1\n",
    "—————————————————————————————————————————————————————————————\n",
    "AB12345-BRA-1-id-236        32                7.7            \n",
    "AB12345-BRA-1-id-265        25               10.3            \n"
  )
  testthat::expect_equal(page1_result, page1_expected)

  lsting2 <- lsting %>% add_listing_col("BMRKR2")
  pages_listings2 <- paginate_listing(lsting2, lpp = 4, cpp = 70, verbose = TRUE)
  testthat::expect_equal(toString(matrix_form(pages_listings2[[1]])),
                         page1_expected)
  testthat::expect_equal(length(pages_listings2), 6L)
  page6_expected <- paste0(
    "Unique Subject Identifier   Age   Categorical Level Biomarker 2\n",
    "———————————————————————————————————————————————————————————————\n",
    "AB12345-BRA-1-id-42         36               MEDIUM            \n",
    "AB12345-BRA-1-id-65         25               MEDIUM            \n"
    )
  testthat::expect_equal(toString(matrix_form(pages_listings2[[6]])),
                         page6_expected)

})

testthat::test_that("horizontal pagination with 0 or 1 key column specified works correctly", {
  # pre-processing and ordering
  tmp_data <- ex_adae %>%
    dplyr::slice(1:30) %>%
    distinct(USUBJID, AGE, BMRKR1, .keep_all = TRUE)

  lsting <- as_listing(tmp_data,
    key_cols = c("USUBJID")
  ) %>%
    add_listing_col("AGE") %>%
    add_listing_col("BMRKR1", format = "xx.x") %>%
    add_listing_col("BMRKR2")

  pages_listings <- paginate_listing(lsting, cpp = 70, verbose = TRUE)
  pg1_header <- strsplit(toString(matrix_form(pages_listings[[1]])), "\n")[[1]][1:2]
  pg2_header <- strsplit(toString(matrix_form(pages_listings[[2]])), "\n")[[1]][1:2]
  pg1_header_expected <- c(
    "Unique Subject Identifier   Age   Continous Level Biomarker 1",
    "—————————————————————————————————————————————————————————————"
  )
  pg2_header_expected <- c(
    "Unique Subject Identifier   Categorical Level Biomarker 2",
    "—————————————————————————————————————————————————————————"
  )

  testthat::expect_equal(pg1_header, pg1_header_expected)
  testthat::expect_equal(pg2_header, pg2_header_expected)
  testthat::expect_equal(length(pages_listings), 2L)

  lsting2 <- as_listing(tmp_data) %>%
    add_listing_col("USUBJID") %>%
    add_listing_col("AGE") %>%
    add_listing_col("BMRKR1", format = "xx.x") %>%
    add_listing_col("BMRKR2")

  pages_listings2 <- paginate_listing(lsting2, cpp = 70, verbose = TRUE)
  pg1_header2 <- strsplit(toString(matrix_form(pages_listings2[[1]])), "\n")[[1]][1:2]
  pg2_header2 <- strsplit(toString(matrix_form(pages_listings2[[2]])), "\n")[[1]][1:2]
  pg3_header2 <- strsplit(toString(matrix_form(pages_listings2[[3]])), "\n")[[1]][1:2]

  pg1_header2_expected <- c(
    "Study Identifier   Unique Subject Identifier   Age",
    "——————————————————————————————————————————————————"
  )
  pg2_header2_expected <- c(
    "Study Identifier   Continous Level Biomarker 1",
    "——————————————————————————————————————————————"
  )
  pg3_header2_expected <- c(
    "Study Identifier   Categorical Level Biomarker 2",
    "————————————————————————————————————————————————"
  )

  testthat::expect_equal(pg1_header2, pg1_header2_expected)
  testthat::expect_equal(pg2_header2, pg2_header2_expected)
  testthat::expect_equal(pg3_header2, pg3_header2_expected)
  testthat::expect_equal(length(pages_listings2), 3L)
})
