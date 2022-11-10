#' Paginate listings
#'
#' @description `r lifecycle::badge("experimental")`
#'
#' Pagination of a listing. This can be vertical for long listings with many
#' rows or horizontal if there are many columns.
#'
#' @param lsting (`listing_df`)\cr the listing to paginate.
#' @inheritParams formatters::pag_indices_inner
#' @inheritParams formatters::vert_pag_indices
#' @param lpp (`number` or `NULL`)\cr number of row lines (not counting titles and
#'   footers) to have per page. Standard is `15` while `NULL` disables vertical
#'   pagination.
#' @param colwidths (`numeric` or `NULL`)\cr print widths of columns, if manually
#'   set/previously known.
#'
#' @returns A list of listings' objects that are meant to be on separated pages.
#'
#' @examples
#' # Create a standard listing
#' library(tibble)
#' dat <- ex_adae
#'
#' lsting <- as_listing(dat[1:25, ],
#'   key_cols = c("USUBJID", "AGE", "AESOC")
#' ) %>%
#'   add_listing_col("AETOXGR") %>%
#'   add_listing_col("BMRKR1", format = "xx.x") %>%
#'   add_listing_col("AESER / AREL", fun = function(df) paste(df$AESER, df$AREL, sep = " / "))
#'
#' # Vertical pagination
#' paginate_listing(lsting, lpp = 10)
#'
#' # Horizontal pagination
#' # paginate_listing(lsting, cpp = 10, lpp = 40)
#'
#' @export
paginate_listing <- function(lsting, lpp = 15,
                             cpp = NULL,
                             min_siblings = 2,
                             nosplitin = character(),
                             colwidths = NULL,
                             verbose = FALSE) {
  # Input checks
  checkmate::assert_count(lpp)
  checkmate::assert_count(cpp, null.ok = TRUE)

  ## XXX TODO this is duplciated form pag_tt_indices
  ## refactor so its not
  dheight <- divider_height(lsting)

  cinfo_lines <- 1L
  if (any(nzchar(all_titles(lsting)))) {
    tlines <- length(all_titles(lsting)) + dheight + 1L
  } else {
    tlines <- 0
  }
  flines <- length(all_footers(lsting))
  if (flines > 0) {
    flines <- flines + dheight + 1L
  }
  ## row lines per page
  rlpp <- lpp - cinfo_lines - tlines - flines
  pagdf <- make_row_df(lsting, colwidths)

  inds <- pag_indices_inner(pagdf,
    rlpp = rlpp,
    min_siblings = min_siblings,
    nosplitin = nosplitin,
    verbose = verbose
  )

  ret <- lapply(inds, function(i) lsting[i, ])
  ## this is *very* similar to the relevant section of rtables::paginate_table
  ## TODO push down into formatters to avoid duplication
  if (!is.null(cpp)) {
    inds <- vert_pag_indices(lsting,
      cpp = cpp,
      colwidths = colwidths,
      verbose = verbose
    )
    ret <- lapply(
      ret,
      function(oneres) {
        lapply(
          inds,
          function(ii) oneres[, ii, drop = FALSE]
        )
      }
    )
    ret <- unlist(ret, recursive = FALSE)
  }
  ret
}
