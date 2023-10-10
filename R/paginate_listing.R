#' Paginate listings
#'
#' @description `r lifecycle::badge("experimental")`
#'
#' Pagination of a listing. This can be vertical for long listings with many
#' rows or horizontal if there are many columns.
#'
#' @param lsting listing_df. The listing to paginate.
#' @param lpp numeric(1) or NULL. Number of row lines (not counting titles and
#'   footers) to have per page. Standard is `70` while `NULL` disables vertical
#'   pagination.
#' @param cpp numeric(1) or NULL. Width (in characters) of the pages for
#'   horizontal pagination. `NULL` (the default) indicates no horizontal
#'   pagination should be done.
#' @inheritParams formatters::pag_indices_inner
#' @inheritParams formatters::vert_pag_indices
#' @inheritParams formatters::page_lcpp
#' @inheritParams formatters::toString
#'
#' @returns A list of listings' objects that are meant to be on separated pages.
#'   For `pag_tt_indices` a list of paginated-groups of row-indices of `lsting`.
#'
#' @rdname paginate
#'
#' @examples
#' dat <- ex_adae
#' lsting <- as_listing(dat[1:25, ], disp_cols = c("USUBJID", "AESOC", "RACE", "AETOXGR", "BMRKR1"))
#'
#' mat <- matrix_form(lsting)
#'
#' cat(toString(mat))
#'
#' paginate_listing(lsting, lpp = 10)
#'
#' paginate_listing(lsting, cpp = 100, lpp = 40)
#'
#' paginate_listing(lsting, cpp = 80, lpp = 40, verbose = TRUE)
#' @export
#'
#' @return for `paginate_listing` a list containing separate
#' `listing_df` objects for each page, for `pag_listing_indices`,
#' a list of indices in the direction being paginated corresponding
#' to the individual pages in that dimension.
paginate_listing <- function(lsting,
                             page_type = "letter",
                             font_family = "Courier",
                             font_size = 8,
                             lineheight = 1,
                             landscape = FALSE,
                             pg_width = NULL,
                             pg_height = NULL,
                             margins = c(top = .5, bottom = .5, left = .75, right = .75),
                             lpp = NA_integer_,
                             cpp = NA_integer_,
                             colwidths = propose_column_widths(lsting),
                             tf_wrap = !is.null(max_width),
                             max_width = NULL,
                             verbose = FALSE) {
  checkmate::assert_class(lsting, "listing_df")
  checkmate::assert_numeric(colwidths, lower = 0, len = length(listing_dispcols(lsting)), null.ok = TRUE)
  checkmate::assert_flag(tf_wrap)
  checkmate::assert_count(max_width, null.ok = TRUE)
  checkmate::assert_flag(verbose)

  indx <- paginate_indices(lsting,
    page_type = page_type,
    font_family = font_family,
    font_size = font_size,
    lineheight = lineheight,
    landscape = landscape,
    pg_width = pg_width,
    pg_height = pg_height,
    margins = margins,
    lpp = lpp,
    cpp = cpp,
    colwidths = colwidths,
    tf_wrap = tf_wrap,
    max_width = max_width,
    rep_cols = length(get_keycols(lsting)),
    verbose = verbose
  )

  vert_pags <- lapply(
    indx$pag_row_indices,
    function(ii) lsting[ii, ]
  )
  dispnames <- listing_dispcols(lsting)
  full_pag <- lapply(
    vert_pags,
    function(onepag) {
      if (!is.null(indx$pag_col_indices)) {
        lapply(
          indx$pag_col_indices,
          function(jj) {
            res <- onepag[, dispnames[jj], drop = FALSE]
            listing_dispcols(res) <- intersect(dispnames, names(res))
            res
          }
        )
      } else {
        list(onepag)
      }
    }
  )

  ret <- unlist(full_pag, recursive = FALSE)
  ret
}

#' @title Defunct functions
#'
#' @description
#' These functions are defunct and their symbols will be removed entirely
#' in a future release.
#' @rdname defunct
#' @inheritParams paginate_listing
#' @export
pag_listing_indices <- function(lsting,
                                lpp = 15,
                                colwidths = NULL,
                                max_width = NULL,
                                verbose = FALSE) {
  .Defunct("paginate_indices", package = "formatters")
}
