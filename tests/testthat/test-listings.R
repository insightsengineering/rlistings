testthat::test_that("Column labels are the same", {

  ## listings var labels don't get mucked up by topleft machinery #262
  lsting <- as_listing(anl, key_cols = c("USUBJID"), cols = NULL) %>%
    add_listing_col("ARM")

  testthat::expect_identical(var_labels(anl), var_labels(lsting))

  matform <- matrix_form(lsting)

  testthat::expect_identical(
    matform$strings[1:3, 1, drop = TRUE],
    c("Unique", "Subject", "Identifier")
  )
  testthat::expect_identical(
    matform$strings[1:3, 2, drop = TRUE],
    c("Description", "Of", "Planned Arm")
  )
})


testthat::test_that("listings work well with different formats and attributes", {
  # (1) Error with NA values in numeric column when apply format
  anl_tmp <- anl
  var_labels(anl_tmp) <- var_labels(ex_adsl)[c("USUBJID", "ARM", "BMRKR1")]
  anl_tmp$BMRKR1[1:3] <- NA

  lsting <- as_listing(anl_tmp, key_cols = c("ARM", "USUBJID"), cols = NULL) %>%
    add_listing_col("ARM") %>%
    add_listing_col("USUBJID") %>%
    add_listing_col("BMRKR1", format = "xx.xx")

  main_title(lsting) <- "main title"
  subtitles(lsting) <- c("sub", "titles")
  main_footer(lsting) <- "main footer"
  prov_footer(lsting) <- "provenance"

  mat <- matrix_form(lsting)
  testthat::expect_identical(
    unname(mat$strings[2, 3, drop = TRUE]),
    "NA"
  )

  ## this tests that the format is applied correctly
  testthat::expect_identical(
    unname(mat$strings[3, 3, drop = TRUE]),
    format_value(lsting$BMRKR1[2], "xx.xx")
  )

  testthat::expect_identical(main_title(lsting), "main title")
  testthat::expect_identical(main_title(lsting), main_title(mat))

  testthat::expect_identical(subtitles(lsting), c("sub", "titles"))
  testthat::expect_identical(subtitles(lsting), subtitles(mat))

  testthat::expect_identical(main_footer(lsting), "main footer")
  testthat::expect_identical(main_footer(lsting), main_footer(mat))

  testthat::expect_identical(prov_footer(lsting), "provenance")
  testthat::expect_identical(prov_footer(lsting), prov_footer(mat))

  testthat::expect_error(
    {
      main_title(lsting) <- 1L
    },
    "value for main_title .*class: integer$"
  )

  testthat::expect_error(
    {
      main_title(lsting) <- c("lol", "silly")
    },
    "value for main_title .*got vector of length 2"
  )

  testthat::expect_error(
    {
      subtitles(lsting) <- 1L
    },
    "value for subtitles .*class: integer$"
  )

  testthat::expect_error(
    {
      main_footer(lsting) <- 1L
    },
    "value for main_footer .*class: integer$"
  )

  testthat::expect_error(
    {
      prov_footer(lsting) <- 1L
    },
    "value for prov_footer .*class: integer$"
  )

  main_title(lsting) <- NULL
  testthat::expect_identical(main_title(lsting), character())
})

testthat::test_that("Content of listings supports newlines", {
  ## newline support #16

  mydf <- data.frame(col1 = c(1, 1, 2), col2 = c("hi\nthere", "what", "who"))
  var_labels(mydf) <- c("column\n1", "column 2")
  mylst <- as_listing(mydf, cols = names(mydf), key_cols = "col1")

  mpf <- matrix_form(mylst)

  testthat::expect_identical(
    mpf$strings[1:2, 1, drop = TRUE],
    c("column", "1")
  )

  rdf <- make_row_df(mylst)

  testthat::expect_identical(
    rdf$self_extent,
    c(2L, 1L, 1L)
  )
})

testthat::test_that("regression test for keycols being lost due to `head()`", {
  ## causing #41
  rlst <- as_listing(mtcars,
    key_cols = c("gear", "carb"),
    cols = c("gear", "carb", "qsec")
  )

  testthat::expect_identical(
    dim(head(rlst, 5)),
    c(5L, ncol(mtcars))
  )
})

testthat::test_that("default values work with as_listing", {
  iiris <- iris[1:15, ]

  # All the columns, first as key_cols
  lst <- as_listing(iiris[, 1:2])
  testthat::expect_equal(ncol(lst), 2L)
  testthat::expect_equal(nrow(lst), 15L)
  testthat::expect_true(any(matrix_form(lst)$strings[, 1] == "")) # First is key_cols
  testthat::expect_equal(matrix_form(lst)$strings[, 1][1], "Sepal.Length")

  # Selecting other key_cols keeps all the listing
  lst <- as_listing(iiris, key_cols = "Species")
  testthat::expect_equal(ncol(lst), 5L)
  testthat::expect_equal(nrow(lst), 15L)
  testthat::expect_true(all(matrix_form(lst)$strings[c(-1, -2), 1] == "")) # First is key_cols
  testthat::expect_equal(matrix_form(lst)$strings[, 1][1], "Species")

  # Selecting disjointed key_cols and cols renders them both
  lst <- as_listing(iiris, cols = "Sepal.Width", key_cols = "Species")
  # testthat::expect_equal(ncol(lst), 2L) # Error? to fix
  testthat::expect_equal(nrow(lst), 15L)
  testthat::expect_true(all(matrix_form(lst)$strings[c(-1, -2), 1] == "")) # First is key_cols
  testthat::expect_equal(matrix_form(lst)$strings[, 1][1], "Species")

  # Using NULL for cols shows no other columns beside key_cols
  lst <- as_listing(iiris, cols = NULL, key_cols = "Species")
  # testthat::expect_equal(ncol(lst), 1L) # Error? to fix
  testthat::expect_equal(nrow(lst), 15L)
  testthat::expect_true(all(matrix_form(lst)$strings[c(-1, -2), 1] == "")) # First is key_cols
  testthat::expect_equal(matrix_form(lst)$strings[, 1][1], "Species")

  # Using both NULLs for cols and key_cols produces warning and prints first column
  lst <- testthat::expect_warning(as_listing(iiris, cols = NULL))
  # testthat::expect_equal(ncol(lst), 1L) # Error? to fix
  testthat::expect_equal(nrow(lst), 15L)
  testthat::expect_true(any(matrix_form(lst)$strings[, 1] == "")) # First is key_cols
  testthat::expect_equal(matrix_form(lst)$strings[, 1][1], "Sepal.Length")
})
