testthat::test_that("pagination works vertically", {
  # pre-processing and ordering
  tmp_data <- ex_adae %>%
    dplyr::slice(1:30) %>%
    dplyr::distinct(USUBJID, AGE, BMRKR1, .keep_all = TRUE)

  lsting <- as_listing(tmp_data,
    key_cols = c("USUBJID", "AGE"),
    disp_cols = character()
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
  testthat::expect_equal(
    toString(matrix_form(pages_listings2[[1]])),
    page1_expected
  )
  testthat::expect_equal(length(pages_listings2), 6L)
  page6_expected <- paste0(
    "Unique Subject Identifier   Age   Categorical Level Biomarker 2\n",
    "———————————————————————————————————————————————————————————————\n",
    "AB12345-BRA-1-id-42         36               MEDIUM            \n",
    "AB12345-BRA-1-id-65         25               MEDIUM            \n"
  )
  testthat::expect_equal(
    toString(matrix_form(pages_listings2[[6]])),
    page6_expected
  )
})

testthat::test_that("horizontal pagination with 0 or 1 key column specified works correctly", {
  # pre-processing and ordering
  tmp_data <- ex_adae %>%
    dplyr::slice(1:30) %>%
    distinct(USUBJID, AGE, BMRKR1, .keep_all = TRUE)

  lsting <- as_listing(tmp_data,
    key_cols = c("USUBJID"),
    disp_cols = character()
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

  lsting2 <- as_listing(tmp_data,
    disp_cols = character()
  ) %>%
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

testthat::test_that("listing works with no vertical pagination", {
  # pre-processing and ordering
  tmp_data <- ex_adae %>%
    dplyr::slice(1:30) %>%
    dplyr::distinct(USUBJID, AGE, BMRKR1, .keep_all = TRUE)

  lsting <- as_listing(tmp_data,
    key_cols = c("USUBJID", "AGE"),
    disp_cols = character()
  ) %>%
    add_listing_col("BMRKR1", format = "xx.x")

  pages_listings <- paginate_listing(lsting, lpp = NULL, verbose = TRUE)
  page1_result <- matrix_form(pages_listings[[1]])

  testthat::expect_equal(length(pages_listings), 1)
  testthat::expect_equal(ncol(page1_result$spans), 3)
  testthat::expect_equal(nrow(page1_result$strings), 7)
})

testthat::test_that("checking vertical pagination line calculation.", {
  # pre-processing and ordering
  tmp_data <- ex_adae %>%
    dplyr::slice(1:30) %>%
    dplyr::distinct(USUBJID, AGE, BMRKR1, .keep_all = TRUE)

  lsting <- as_listing(tmp_data,
    key_cols = c("USUBJID", "AGE"),
    disp_cols = character(),
    main_footer = c("Main Footer A")
  ) %>%
    add_listing_col("BMRKR1", format = "xx.x")

  pages_listings <- paginate_listing(lsting, lpp = 8, verbose = TRUE)

  # there is always a gap between the end of the table and the footer. Line calculation is correct given this behavior
  page1_result <- matrix_form(pages_listings[[1]])
  page2_result <- matrix_form(pages_listings[[2]])

  testthat::expect_equal(sum(nrow(page1_result$strings), length(page1_result$main_footer)), 5)
  testthat::expect_equal(sum(nrow(page2_result$strings), length(page2_result$main_footer)), 5)
})

testthat::test_that("pagination: lpp and cpp correctly computed for pg_width and pg_height", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 24, cpp = 135)
  res <- paginate_listing(lsting, pg_width = 15, pg_height = 5)
  expect_identical(res, pag)
})

testthat::test_that("pagination: lpp and cpp correctly computed for page_type and font_size", {
  lsting <- h_lsting_adae()
  pag1 <- paginate_listing(lsting, lpp = 69, cpp = 73)
  res1 <- paginate_listing(lsting, page_type = "a4", font_size = 11)
  expect_identical(res1, pag1)

  pag2 <- paginate_listing(lsting, lpp = 85, cpp = 76)
  res2 <- paginate_listing(lsting, page_type = "legal", font_size = 11)
  expect_identical(res2, pag2)
})

testthat::test_that("pagination: lpp and cpp correctly computed for lineheight", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 20, cpp = 70)
  res <- paginate_listing(lsting, lineheight = 3)
  expect_identical(res, pag)
})

testthat::test_that("pagination: lpp and cpp correctly computed for landscape", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 45, cpp = 95)
  res <- paginate_listing(lsting, landscape = TRUE)
  expect_identical(res, pag)
})

testthat::test_that("pagination: lpp and cpp correctly computed for margins", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 42, cpp = 65)
  res <- paginate_listing(lsting, margins = c(top = 2, bottom = 2, left = 1, right = 1))
  expect_identical(res, pag)
})
