testthat::test_that("matrix_form keeps relevant information and structure about the listing", {
  my_iris <- iris %>%
    slice(c(16, 3)) %>%
    mutate("fake_rownames" = c("mean", "mean"))

  lsting <- as_listing(my_iris,
    key_cols = c("fake_rownames", "Petal.Width"),
    disp_cols = c("Petal.Length")
  )
  mat <- matrix_form(lsting) ## to match basic_listing_mfb

  # IMPORTANT: the following is coming directly from spoof matrix form for rlistings coming from {formatters}
  mat_rebuilt <- basic_listing_mf(my_iris[c("fake_rownames", "Petal.Width", "Petal.Length")],
    keycols = c("fake_rownames", "Petal.Width"), add_decoration = FALSE, fontspec = NULL
  )

  testthat::expect_equal(names(mat_rebuilt), names(mat))

  mat_rebuilt$row_info$pos_in_siblings <- mat$row_info$pos_in_siblings # not relevant in listings
  mat_rebuilt$row_info$n_siblings <- mat$row_info$n_siblings # not relevant in listings
  testthat::expect_equal(mf_rinfo(mat_rebuilt), mf_rinfo(mat))

  mat_rebuilt["page_titles"] <- list(NULL)

  testthat::expect_equal(mat, mat_rebuilt)

  testthat::expect_equal(toString(mat), toString(mat_rebuilt))


  # The same but with rownames
  lmf <- basic_listing_mf(mtcars)
  testthat::expect_equal(ncol(lmf), length(lmf$col_widths))
  testthat::expect_equal(ncol(lmf), ncol(lmf$strings))
  testthat::expect_false(mf_has_rlabels(lmf))

  rlmf <- as_listing(mtcars) %>% matrix_form() # rownames are always ignored!!!
  testthat::expect_equal(ncol(rlmf), length(rlmf$col_widths))
  testthat::expect_equal(ncol(rlmf), ncol(rlmf$strings))
  testthat::expect_false(mf_has_rlabels(rlmf))
})
