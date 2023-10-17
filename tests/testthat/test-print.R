testthat::test_that("Listing print correctly", {
  lsting <- as_listing(anl, key_cols = c("USUBJID")) %>%
    add_listing_col("ARM")

  res <- strsplit(toString(matrix_form(lsting), hsep = "-"), "\\n")[[1]]

  testthat::expect_snapshot(res)
})

testthat::test_that("Listing print correctly with different widths", {
  lsting <- as_listing(anl, key_cols = c("USUBJID")) %>%
    add_listing_col("ARM")

  res <- strsplit(toString(matrix_form(lsting), widths = c(7, 8, 9), hsep = "-"), "\\n")[[1]]
  res2 <- strsplit(toString(lsting, widths = c(7, 8, 9), hsep = "-"), "\\n")[[1]]

  testthat::expect_identical(res, res2)

  testthat::expect_snapshot(cat(toString(matrix_form(lsting), widths = c(7, 8, 9), hsep = "-")))
})
testthat::test_that("as_listing produces correct output when default_formatting is specified", {
  anl$BMRKR1[3:6] <- NA
  lsting <- as_listing(
    anl,
    key_cols = "USUBJID",
    default_formatting = list(
      all = fmt_config(align = "left"),
      numeric = fmt_config(format = "xx.xx", na_str = "<No data>", align = "right")
    )
  )

  res <- strsplit(toString(matrix_form(lsting), hsep = "-"), "\\n")[[1]]

  testthat::expect_snapshot(res)

  testthat::expect_error(
    {
      as_listing(
        anl,
        key_cols = "USUBJID",
        default_formatting = list(all = list(align = "left"))
      )
    },
    "All format configurations supplied in `default_formatting` must be of type `fmt_config`."
  )

  testthat::expect_error(
    res <- as_listing(
      anl,
      key_cols = "USUBJID",
      default_formatting = list(numeric = fmt_config(align = "left"))
    ),
    regexp = paste0(
      "Format configurations must be supplied for all listing columns. ",
      "To cover all remaining columns please add an ",
      "'all' configuration to `default_formatting`."
    )
  ) %>%
    suppressMessages()
})

testthat::test_that("as_listing produces correct output when col_formatting is specified", {
  anl$ARM[3:6] <- NA
  lsting <- as_listing(
    anl,
    key_cols = "USUBJID",
    col_formatting = list(
      USUBJID = fmt_config(align = "right"),
      ARM = fmt_config(format = sprintf_format("ARM #: %s"), na_str = "-", align = "left")
    )
  )

  res <- strsplit(toString(matrix_form(lsting), hsep = "-"), "\\n")[[1]]
  testthat::expect_snapshot(res)

  # Mixed behavior
  # Note: all is rightfully masked by the more specific numeric assignment
  lsting <- as_listing(
    anl,
    key_cols = "USUBJID", disp_cols = "BMRKR1",
    default_formatting = list(
      numeric = fmt_config(align = "right"),
      all = fmt_config(na_str = "default na")
    ),
    col_formatting = list(
      BMRKR1 = fmt_config(na_str = "bmrkr1 special", format = "xx.") # This has precedence
    )
  )

  testthat::expect_snapshot(cat(toString(matrix_form(lsting), hsep = "-")))

  testthat::expect_error(
    {
      as_listing(
        anl,
        key_cols = "USUBJID",
        col_formatting = list(all = list(align = "left"))
      )
    },
    "All format configurations supplied in `col_formatting` must be of type `fmt_config`."
  )

  # Other error
  testthat::expect_error(
    {
      as_listing(
        anl,
        key_cols = "USUBJID",
        col_formatting = list(USUBJID = list(numeric = fmt_config(align = "left")))
      )
    },
    "All format configurations supplied in `col_formatting` must be of type `fmt_config`."
  )
})

testthat::test_that("listings support newline characters", {
  anl$ARM[3:6] <- NA
  anl$USUBJID[1] <- "aaatrial\ntrial\n" # last \n is trimmed
  vl <- var_labels(anl)
  vl[3] <- "\n\na\n\nn\n"
  var_labels(anl) <- vl
  anl_tmp <- anl[1:4, ]
  lsting <- as_listing(
    anl_tmp,
    key_cols = "USUBJID",
    col_formatting = list(
      USUBJID = fmt_config(align = "right"),
      ARM = fmt_config(format = sprintf_format("ARM #: %s"), na_str = "-\nasd\n", align = "left")
    )
  )

  res <- strsplit(toString(matrix_form(lsting), hsep = "-"), "\\n")[[1]]
  testthat::expect_snapshot(res)

  res_txt <- strsplit(export_as_txt(lsting, hsep = "-"), "\\n")[[1]]
  testthat::expect_identical(res, res_txt)
})

testthat::test_that("listings supports wrapping", {
  lsting <- as_listing(
    anl,
    key_cols = "USUBJID",
    col_formatting = list(
      USUBJID = fmt_config(align = "right"),
      ARM = fmt_config(format = sprintf_format("ARM #: %s"), na_str = "-\nasd\n", align = "left")
    )
  )

  cw <- c(5, 8, 2)
  ts_wrap <- strsplit(toString(lsting, widths = cw), "\n")[[1]]
  testthat::expect_equal(length(ts_wrap), 98)
  eat_wrap <- strsplit(export_as_txt(lsting, colwidths = cw), "\n")[[1]]
  testthat::expect_equal(length(eat_wrap), 98 + 2 + 15) # 2 is the page separator, 15 is header
  testthat::expect_equal(eat_wrap[-seq(116 - 9 - 17, 115 - 9)], ts_wrap) # 9 is in second page

  # Fix C stack inf rec loop
  testthat::expect_silent(toString(lsting, widths = c(10, 10, 1)))
})
