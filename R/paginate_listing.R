#' Paginate listings
#'
#' @description `r lifecycle::badge("experimental")`
#'
#' Pagination of a listing. This can be vertical for long listings with many
#' rows or horizontal if there are many columns.
#'
#' @param lsting listing_df. The listing to paginate.
#' @inheritParams formatters::pag_indices_inner
#' @inheritParams formatters::vert_pag_indices
#' @param lpp numeric(1) or NULL. Number of row lines (not counting titles and
#'   footers) to have per page. Standard is `15` while `NULL` disables vertical
#'   pagination.
#' @param colwidths numeric or NULL. Print widths of columns, if manually
#'   set/previously known.
#'
#' @returns A list of listings' objects that are meant to be on separated pages.
#'
#' @examples
#' # Create a standard listing
#' dat <- ex_adae
#' lsting <- as_listing(dat[1:25, ], disp_cols = c("USUBJID", "AESOC", "RACE", "AETOXGR", "BMRKR1"))
#'
#' mat <- matrix_form(lsting)
#'
#' cat(toString(mat))
#'
#' # Vertical pagination
#' paginate_listing(lsting, lpp = 10)
#'
#' #Horizontal pagination
#' paginate_listing(lsting, cpp = 100, lpp = 40)
#'
#' # Use `verbose = TRUE` to display more descriptive warnings or errors
#' # paginate_listing(lsting, cpp = 80, lpp = 40, verbose = TRUE)
#' @export
paginate_listing <- function(lsting, lpp = 15,
                             cpp = NULL,
                             min_siblings = 2,
                             nosplitin = character(),
                             colwidths = propose_column_widths(lsting), #NULL,
                             verbose = FALSE) {
  # Input checks
  checkmate::assert_count(lpp, null.ok = TRUE)
  checkmate::assert_count(cpp, null.ok = TRUE)

  ## XXX TODO this is duplciated form pag_tt_indices
  ## refactor so its not
  dheight <- divider_height(lsting)
  cinfo_lines <- max(mapply(nlines,
                            x = var_labels(lsting)[listing_dispcols(lsting)],
                            max_width = colwidths)) + dheight
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
  pagdf <- make_row_df(lsting, colwidths)
  if (is.null(lpp)) {
    rlpp <- sum(c(pagdf$self_extent, pagdf$nreflines))
  } else {
    rlpp <- lpp - cinfo_lines - tlines - flines
  }

  inds <- pag_indices_inner(pagdf,
                            rlpp = rlpp,
                            min_siblings = min_siblings,
                            nosplitin = nosplitin,
                            verbose = verbose)
  dcols <- listing_dispcols(lsting)

  kcols <- get_keycols(lsting)
  non_key_dispcols <- setdiff(dcols, kcols)
  ret <- lapply(inds, function(i) lsting[i, ])
  ## this is *very* similar to the relevant section of rtables::paginate_table
  ## TODO push down into formatters to avoid duplication
  if (!is.null(cpp)) {
    tmp_df <- lsting[, listing_dispcols(lsting), drop = FALSE]
    raw_inds <- vert_pag_indices(tmp_df,
      cpp = cpp,
      colwidths = colwidths,
      verbose = verbose,
      rep_cols = length(get_keycols(lsting))
    )
    pag_cols <- lapply(raw_inds, function(jj) dcols[jj]) ## listing_dispcols(c(kcols, non_key_dispcols[jj]))
    ret <- lapply(
      ret,
      function(oneres) {
        lapply(
          pag_cols,
          function(cnames) {
            ret <- oneres[, cnames, drop = FALSE]
            listing_dispcols(ret) <- cnames
            ret
          }
        )
      }
    )
    ret <- unlist(ret, recursive = FALSE)
  }
  ret
}
