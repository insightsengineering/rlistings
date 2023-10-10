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

  pages_listings <- suppressMessages(paginate_listing(lsting, lpp = 4, verbose = TRUE))

  testthat::expect_snapshot(pages_listings[c(1, 2)])

  lsting2 <- lsting %>% add_listing_col("BMRKR2")
  pages_listings2 <- suppressMessages(paginate_listing(lsting2, lpp = 4, cpp = 70, verbose = TRUE))

  testthat::expect_equal(length(pages_listings2), 6L)
  testthat::expect_snapshot(pages_listings2[c(1, 6)])
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

  pages_listings <- suppressMessages(paginate_listing(lsting, cpp = 70, verbose = TRUE))
  pg1_header <- strsplit(toString(matrix_form(pages_listings[[1]]), hsep = "-"), "\n")[[1]][1:2]
  pg2_header <- strsplit(toString(matrix_form(pages_listings[[2]]), hsep = "-"), "\n")[[1]][1:2]
  pg1_header_expected <- c(
    "Unique Subject Identifier   Age   Continous Level Biomarker 1",
    "-------------------------------------------------------------"
  )
  pg2_header_expected <- c(
    "Unique Subject Identifier   Categorical Level Biomarker 2",
    "---------------------------------------------------------"
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

  pages_listings2 <- paginate_listing(lsting2, cpp = 70)
  pg1_header2 <- strsplit(toString(matrix_form(pages_listings2[[1]]), hsep = "-"), "\n")[[1]][1:2]
  pg2_header2 <- strsplit(toString(matrix_form(pages_listings2[[2]]), hsep = "-"), "\n")[[1]][1:2]
  pg3_header2 <- strsplit(toString(matrix_form(pages_listings2[[3]]), hsep = "-"), "\n")[[1]][1:2]

  pg1_header2_expected <- c(
    "Study Identifier   Unique Subject Identifier   Age",
    "--------------------------------------------------"
  )
  pg2_header2_expected <- c(
    "Study Identifier   Continous Level Biomarker 1",
    "----------------------------------------------"
  )
  pg3_header2_expected <- c(
    "Study Identifier   Categorical Level Biomarker 2",
    "------------------------------------------------"
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

  pages_listings <- paginate_listing(lsting, lpp = NULL)
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

  pages_listings <- paginate_listing(lsting, lpp = 8)

  # there is always a gap between the end of the table and the footer. Line calculation is correct given this behavior
  page1_result <- matrix_form(pages_listings[[1]])
  page2_result <- matrix_form(pages_listings[[2]])

  testthat::expect_equal(sum(nrow(page1_result$strings), length(page1_result$main_footer)), 5)
  testthat::expect_equal(sum(nrow(page2_result$strings), length(page2_result$main_footer)), 5)
})

testthat::test_that("pagination: lpp and cpp correctly computed for pg_width and pg_height", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 24, cpp = 135)
  res <- paginate_listing(lsting, pg_width = 15, pg_height = 5, font_size = 12) # 12 no longer default!!!
  testthat::expect_identical(res, pag)
})

testthat::test_that("pagination: lpp and cpp correctly computed for page_type and font_size", {
  lsting <- h_lsting_adae()
  pag1 <- paginate_listing(lsting, lpp = 69, cpp = 73)
  res1 <- paginate_listing(lsting, page_type = "a4", font_size = 11)
  testthat::expect_identical(res1, pag1)

  pag2 <- paginate_listing(lsting, lpp = 85, cpp = 76)
  res2 <- paginate_listing(lsting, page_type = "legal", font_size = 11)
  testthat::expect_identical(res2, pag2)
})

testthat::test_that("pagination: lpp and cpp correctly computed for lineheight", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 20, cpp = 70, font_size = 12)
  res <- paginate_listing(lsting, lineheight = 3, font_size = 12)
  testthat::expect_identical(res, pag)
})

testthat::test_that("pagination: lpp and cpp correctly computed for landscape", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 45, cpp = 95, font_size = 12)
  res <- paginate_listing(lsting, landscape = TRUE, font_size = 12)
  testthat::expect_identical(res, pag)
})

testthat::test_that("pagination: lpp and cpp correctly computed for margins", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 42, cpp = 65, font_size = 12)
  res <- paginate_listing(lsting, margins = c(top = 2, bottom = 2, left = 1, right = 1), font_size = 12)
  testthat::expect_identical(res, pag)
})


testthat::test_that("pagination works with col wrapping", {
  lsting <- h_lsting_adae(disp_cols = c("USUBJID", "AESOC", "RACE"))

  testthat::expect_silent(pag <- paginate_listing(lsting, colwidths = c(15, 15, 15, 15), font_size = 12))
  pag_no_wrapping <- paginate_listing(lsting, font_size = 12)

  testthat::expect_equal(length(pag), length(pag_no_wrapping) + 1)
  testthat::expect_error(paginate_listing(lsting, colwidths = c(12, 15)))
})

testthat::test_that("pagination repeats keycols in other pages", {
  dat <- formatters::ex_adae
  lsting <- as_listing(dat[1:25, c(1:6, 40)],
    key_cols = c("USUBJID", "AESOC"),
    main_title = "Example Title for Listing",
    subtitles = "This is the subtitle for this Adverse Events Table",
    main_footer = "Main footer for the listing",
    prov_footer = c(
      "You can even add a subfooter", "Second element is place on a new line",
      "Third string"
    )
  )
  testthat::expect_true(grepl(
    "AB12345-BRA-1-id-42",
    paginate_to_mpfs(lsting, lpp = 33, cpp = 550)[[2]]$strings
  )[2])
})

testthat::test_that("defunct is defunct", {
  expect_error(pag_listing_indices(), "defunct")
})
