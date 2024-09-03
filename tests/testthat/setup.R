anl <- ex_adsl
anl <- anl[1:10, c("USUBJID", "ARM", "BMRKR1")]
anl <- var_relabel(anl,
  USUBJID = "Unique\nSubject\nIdentifier",
  ARM = "Description\nOf\nPlanned Arm"
)

# Helper function used in pagination tests
h_lsting_adae <- function(disp_cols = c("USUBJID", "AESOC", "RACE", "AETOXGR", "BMRKR1")) {
  as_listing(ex_adae[1:25, ], disp_cols = disp_cols)
}

# Helper function to print output from paginate_listings
fast_print <- function(x) {
  nothing <- lapply(seq_along(x), function(pg_num) {
    cat("Page", pg_num, "\n")
    cat(toString(x[[pg_num]]))
  })
}


compare_paginations <- function(paglst1, paglst2) {
  if (length(paglst1) != length(paglst2)) {
    indres <- FALSE
  } else {
    indres <- vapply(seq_along(paglst1),
                     function(i) compare_mpfs_no_fontspec(paglst1[[i]], paglst2[[i]]),
                     TRUE)
  }
  expect_true(all(indres), "paginations are not equivalent as expected")
}

compare_mpfs_no_fontspec <- function(mpf1, mpf2) {
  mf_fontspec(mpf1) <- NULL
  mf_fontspec(mpf2) <- NULL
  identical(mpf1, mpf2)
}
