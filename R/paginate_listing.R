#' Paginate listings
#'
#' @description `r lifecycle::badge("experimental")`
#'
#' Pagination of a listing. This can be vertical for long listings with many
#' rows and/or horizontal if there are many columns.
#'
#' @inheritParams formatters::pag_indices_inner
#' @inheritParams formatters::vert_pag_indices
#' @inheritParams formatters::page_lcpp
#' @inheritParams formatters::toString
#' @param lsting (`listing_df` or `list`)\cr the listing or list of listings to paginate.
#' @param lpp (`numeric(1)` or `NULL`)\cr number of rows/lines (excluding titles and footers)
#'   to include per page. Standard is `70` while `NULL` disables vertical pagination.
#' @param cpp (`numeric(1)` or `NULL`)\cr width (in characters) of the pages for horizontal
#'   pagination. `NULL` (the default) indicates no horizontal pagination should be done.
#'
#' @return A list of `listing_df` objects where each list element corresponds to a separate page.
#'
#' @examples
#' dat <- ex_adae
#' lsting <- as_listing(dat[1:25, ], disp_cols = c("USUBJID", "AESOC", "RACE", "AETOXGR", "BMRKR1"))
#' mat <- matrix_form(lsting)
#'
#' cat(toString(mat))
#'
#' paginate_listing(lsting, lpp = 10)
#'
#' paginate_listing(lsting, cpp = 100, lpp = 40)
#'
#' paginate_listing(lsting, cpp = 80, lpp = 40, verbose = TRUE)
#'
#' @export
#' @rdname paginate
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
                             colwidths = NULL,
                             tf_wrap = !is.null(max_width),
                             rep_cols = NULL,
                             max_width = NULL,
                             verbose = FALSE) {
  # Deprecation warning
  warning("The function `paginate_listing` is deprecated and will be removed in a future release. Please use `paginate_to_mpfs` instead.")

  checkmate::assert_class(lsting, "listing_df")
  checkmate::assert_numeric(colwidths, lower = 0, len = length(listing_dispcols(lsting)), null.ok = TRUE)
  checkmate::assert_flag(tf_wrap)
  checkmate::assert_count(max_width, null.ok = TRUE)
  checkmate::assert_flag(verbose)

  paginate_to_mpfs(lsting,
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
    rep_cols = rep_cols,
    verbose = verbose
  )

  # indx <- paginate_indices(lsting,
  #   page_type = page_type,
  #   font_family = font_family,
  #   font_size = font_size,
  #   lineheight = lineheight,
  #   landscape = landscape,
  #   pg_width = pg_width,
  #   pg_height = pg_height,
  #   margins = margins,
  #   lpp = lpp,
  #   cpp = cpp,
  #   colwidths = colwidths,
  #   tf_wrap = tf_wrap,
  #   max_width = max_width,
  #   rep_cols = rep_cols,
  #   verbose = verbose
  # )
  #
  # dispnames <- listing_dispcols(lsting)
  # full_pag <- lapply(
  #   vert_pags,
  #   function(onepag) {
  #     if (!is.null(indx$pag_col_indices)) {
  #       lapply(
  #         indx$pag_col_indices,
  #         function(jj) {
  #           res <- onepag[, dispnames[jj], drop = FALSE]
  #           listing_dispcols(res) <- intersect(dispnames, names(res))
  #           res
  #         }
  #       )
  #     } else {
  #       list(onepag)
  #     }
  #   }
  # )
  #
  # ret <- unlist(full_pag, recursive = FALSE)
  # ret
}

#' Defunct functions
#'
#' These functions are defunct and their symbols will be removed entirely in a future release.
#'
#' @inheritParams paginate_listing
#'
#' @export
#' @rdname defunct
pag_listing_indices <- function(lsting,
                                lpp = 15,
                                colwidths = NULL,
                                max_width = NULL,
                                verbose = FALSE) {
  .Defunct("paginate_indices", package = "formatters")
}
