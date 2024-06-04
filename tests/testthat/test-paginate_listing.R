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

  pages_listings <- suppressMessages(paginate_listing(lsting, lpp = 4, verbose = TRUE, print_pages = FALSE))

  testthat::expect_snapshot(fast_print(pages_listings[c(1, 2)]))

  lsting2 <- lsting %>% add_listing_col("BMRKR2")
  pages_listings2 <- paginate_listing(lsting2, lpp = 4, cpp = 70, print_pages = FALSE)

  testthat::expect_equal(length(pages_listings2), 6L)
  testthat::expect_snapshot(fast_print(pages_listings2[c(1, 6)]))
})

testthat::test_that("horizontal pagination with 0 or 1 key column specified works correctly", {
  # pre-processing and ordering
  tmp_data <- ex_adae %>%
    dplyr::slice(1:30) %>%
    dplyr::distinct(USUBJID, AGE, BMRKR1, .keep_all = TRUE)

  lsting <- as_listing(tmp_data,
    key_cols = c("USUBJID"),
    disp_cols = character()
  ) %>%
    add_listing_col("AGE") %>%
    add_listing_col("BMRKR1", format = "xx.x") %>%
    add_listing_col("BMRKR2")

  pages_listings <- paginate_listing(lsting, cpp = 70, print_pages = FALSE)
  pg1_header <- strsplit(toString(pages_listings[[1]], hsep = "-"), "\n")[[1]][seq(2)]
  pg2_header <- strsplit(toString(pages_listings[[2]], hsep = "-"), "\n")[[1]][seq(2)]
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

  pages_listings2 <- paginate_listing(lsting2, cpp = 70, print_pages = FALSE)
  pg1_header2 <- strsplit(toString(pages_listings2[[1]], hsep = "-"), "\n")[[1]][seq(2)]
  pg2_header2 <- strsplit(toString(pages_listings2[[2]], hsep = "-"), "\n")[[1]][seq(2)]
  pg3_header2 <- strsplit(toString(pages_listings2[[3]], hsep = "-"), "\n")[[1]][seq(2)]

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

  pages_listings <- paginate_listing(lsting, lpp = NULL, print_pages = FALSE)
  page1_result <- pages_listings[[1]]

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

  pages_listings <- paginate_listing(lsting, lpp = 8, print_pages = FALSE)

  # there is always a gap between the end of the table and the footer. Line calculation
  # is correct given this behavior
  page1_result <- pages_listings[[1]]
  page2_result <- pages_listings[[2]]

  testthat::expect_equal(sum(nrow(page1_result$strings), length(page1_result$main_footer)), 5)
  testthat::expect_equal(sum(nrow(page2_result$strings), length(page2_result$main_footer)), 5)
})

testthat::test_that("pagination: lpp and cpp correctly computed for pg_width and pg_height", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 24, cpp = 135, print_pages = FALSE)
  res <- paginate_listing(lsting, pg_width = 15, pg_height = 5, font_size = 12, print_pages = FALSE)
  compare_paginations(pag, res)
})

testthat::test_that("pagination: lpp and cpp correctly computed for page_type and font_size", {
  lsting <- h_lsting_adae()
  pag1 <- paginate_listing(lsting, lpp = 69, cpp = 73, print_pages = FALSE)
  res1 <- paginate_listing(lsting, page_type = "a4", font_size = 11, print_pages = FALSE)
  compare_paginations(pag1, res1)

  pag2 <- paginate_listing(lsting, lpp = 85, cpp = 76, print_pages = FALSE)
  res2 <- paginate_listing(lsting, page_type = "legal", font_size = 11, print_pages = FALSE)
  compare_paginations(pag2, res2)
})

testthat::test_that("pagination: lpp and cpp correctly computed for lineheight", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 20, cpp = 70, font_size = 12, print_pages = FALSE)
  res <- paginate_listing(lsting, lineheight = 3, font_size = 12, print_pages = FALSE)
  compare_paginations(pag, res)
})

testthat::test_that("pagination: lpp and cpp correctly computed for landscape", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 45, cpp = 95, font_size = 12, print_pages = FALSE)
  res <- paginate_listing(lsting, landscape = TRUE, font_size = 12, print_pages = FALSE)
  testthat::expect_identical(res, pag)
})

testthat::test_that("pagination: lpp and cpp correctly computed for margins", {
  lsting <- h_lsting_adae()
  pag <- paginate_listing(lsting, lpp = 42, cpp = 65, font_size = 12, print_pages = FALSE)
  res <- paginate_listing(lsting,
    margins = c(top = 2, bottom = 2, left = 1, right = 1),
    font_size = 12, print_pages = FALSE
  )
  testthat::expect_identical(res, pag)
})

testthat::test_that("pagination works with col wrapping", {
  lsting <- h_lsting_adae(disp_cols = c("USUBJID", "AESOC", "RACE"))

  testthat::expect_silent(
    pag <- paginate_listing(
      lsting,
      colwidths = c(15, 15, 15, 15),
      font_size = 12,
      col_gap = 4,
      print_pages = FALSE
    )
  )
  pag_no_wrapping <- paginate_listing(lsting, font_size = 12, col_gap = 4, print_pages = FALSE)

  testthat::expect_equal(length(pag), length(pag_no_wrapping) + 1)
  testthat::expect_error(paginate_listing(lsting, colwidths = c(12, 15)))
})

testthat::test_that("pagination repeats keycols in other pages", {
  dat <- ex_adae
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

  # Simplified test
  mf_pages <- as_listing(tibble("a" = rep("1", 25), "b" = seq(25)), key_cols = "a") %>%
    paginate_to_mpfs(lpp = 10)

  testthat::expect_snapshot(cat(toString(mf_pages[[3]])))

  # Warning from empty key col
  mf_pages <- suppressWarnings(
    testthat::expect_warning(
      as_listing(tibble("a" = rep("", 25), "b" = seq(25)), key_cols = "a") %>%
        paginate_to_mpfs(lpp = 10)
    )
  )
  mf_pages <- suppressWarnings(
    as_listing(tibble("a" = rep("", 25), "b" = seq(25)), key_cols = "a") %>%
      paginate_to_mpfs(lpp = 10)
  )

  testthat::expect_snapshot(
    cat(toString(mf_pages[[3]]))
  )
})

testthat::test_that("paginate_to_mpfs works with wrapping on keycols", {
  iris2 <- iris[1:10, 3:5]
  iris2$Species <- "SOMETHING VERY LONG THAT BREAKS PAGINATION"

  lst <- as_listing(iris2, key_cols = c("Species", "Petal.Width"))

  pgs <- paginate_to_mpfs(lst, colwidths = c(30, 11, 12), lpp = 5)

  testthat::expect_equal(
    sapply(pgs, function(x) strsplit(toString(x), "\n")[[1]] %>% length()),
    rep(5, 5)
  )
  testthat::expect_snapshot(null <- sapply(pgs, function(x) toString(x) %>% cat()))

  # Errors
  testthat::expect_error(
    suppressMessages(pgs <- paginate_to_mpfs(lst, colwidths = c(30, 11, 12), lpp = 3, verbose = TRUE))
  )
  testthat::expect_error(
    suppressMessages(pgs <- paginate_to_mpfs(lst, colwidths = c(30, 11, 12), lpp = 8, cpp = 5, verbose = TRUE))
  )

  # Test 2 with double wrapping
  tmp_fct <- factor(iris2$Petal.Width)
  levels(tmp_fct) <- paste0("Very long level name ", levels(tmp_fct))
  iris2$Petal.Width <- as.character(tmp_fct)

  lst <- as_listing(iris2, key_cols = c("Species", "Petal.Width"))

  pgs <- paginate_to_mpfs(lst, colwidths = c(30, 15, 12), lpp = 8)

  testthat::expect_equal(
    sapply(pgs, function(x) strsplit(toString(x), "\n")[[1]] %>% length()),
    seq(8, 6)
  )
})

testthat::test_that("paginate_to_mpfs works with wrapping on keycols when doing horizontal pagination", {
  iris2 <- iris[1:10, 3:5]
  iris2$Species <- "SOMETHING VERY LONG THAT BREAKS PAGINATION"
  iris2 <- cbind("Petal.L3ngth" = iris2$Petal.Length, iris2)

  lst <- as_listing(iris2, key_cols = c("Species", "Petal.Width"))
  cw <- propose_column_widths(lst)
  cw[1] <- 30
  colgap <- matrix_form(lst)$col_gap
  expected_min_cpp <- sum(cw[seq_len(3)]) + 2 * colgap
  pgs <- paginate_to_mpfs(lst, colwidths = cw, lpp = 150, cpp = expected_min_cpp + 3) # why + 3? -> + colgap

  testthat::expect_equal(
    sapply(pgs, function(x) strsplit(toString(x), "\n")[[1]][1] %>% nchar()),
    rep(expected_min_cpp, 2) # no colgap
  )

  pgs <- paginate_to_mpfs(lst, colwidths = cw, lpp = 5, cpp = expected_min_cpp + 3)

  # testing nrow
  testthat::expect_equal(
    sapply(pgs, function(x) strsplit(toString(x), "\n")[[1]] %>% length()),
    rep(5, 10)
  )
  # testing nchars
  testthat::expect_equal(
    sapply(pgs, function(x) strsplit(toString(x), "\n")[[1]][1] %>% nchar()),
    rep(expected_min_cpp, 10)
  )
})

testthat::test_that("paginate_listing works with split_into_pages_by_var", {
  tmp_data <- ex_adae[1:10, ]

  lsting <- as_listing(
    tmp_data,
    key_cols = c("USUBJID", "AGE"),
    disp_cols = "SEX",
    main_title = "title",
    main_footer = "foot"
  ) %>%
    add_listing_col("BMRKR1", format = "xx.x") %>%
    split_into_pages_by_var("SEX", page_prefix = "Patient Subset - Sex")

  pag_listing <- paginate_listing(lsting, lpp = 20, cpp = 65, print_pages = FALSE)[[3]]
  testthat::expect_equal(main_title(pag_listing), "title")
  testthat::expect_equal(subtitles(pag_listing), "Patient Subset - Sex: F")
  testthat::expect_equal(main_footer(pag_listing), "foot")
  testthat::expect_true(all(pag_listing$strings[-1, 3] == "F"))
  testthat::expect_snapshot(fast_print(list(pag_listing)))

  # This works also for the pagination print
  testthat::expect_snapshot(paginate_listing(lsting, lpp = 330, cpp = 365, print_pages = TRUE))
})
