testthat::test_that("matrix_form keeps relevant information and structure about the listing", {
  my_iris <- iris %>%
    slice(c(16, 3)) %>%
    mutate("fake_rownames" = c("mean", "mean"))

  lsting <- as_listing(my_iris,
    key_cols = c("fake_rownames", "Petal.Width"),
    disp_cols = c("Petal.Length")
  )
  mat <- matrix_form(lsting)

  # IMPORTANT: the following is coming directly from spoof matrix form for rlistings coming from {formatters}
  mat_rebuilt <- basic_listing_mf(my_iris[c("fake_rownames", "Petal.Width", "Petal.Length")],
    keycols = c("fake_rownames", "Petal.Width"), add_decoration = FALSE
  )

  expect_equal(names(mat_rebuilt), names(mat))

  mat_rebuilt$row_info$pos_in_siblings <- mat$row_info$pos_in_siblings # not relevant in listings
  mat_rebuilt$row_info$n_siblings <- mat$row_info$n_siblings # not relevant in listings
  expect_equal(mf_rinfo(mat_rebuilt), mf_rinfo(mat))

  mat_rebuilt["page_titles"] <- list(NULL)

  expect_equal(mat, mat_rebuilt)

  expect_equal(toString(mat), toString(mat_rebuilt))


  # The same but with rownames
  lmf <- basic_listing_mf(mtcars)
  expect_equal(ncol(lmf), length(lmf$col_widths))
  expect_equal(ncol(lmf), ncol(lmf$strings))
  expect_false(mf_has_rlabels(lmf))

  rlmf <- as_listing(mtcars) %>% matrix_form() # rownames are always ignored!!!
  expect_equal(ncol(rlmf), length(rlmf$col_widths))
  expect_equal(ncol(rlmf), ncol(rlmf$strings))
  expect_false(mf_has_rlabels(rlmf))
})
