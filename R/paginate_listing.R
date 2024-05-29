#' Paginate listings
#'
#' @description `r lifecycle::badge("experimental")`
#'
#' Pagination of a listing. This can be vertical for long listings with many
#' rows and/or horizontal if there are many columns. This function is a wrapper of
#' [formatters::paginate_to_mpfs()] and it is mainly meant for exploration and testing.
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
#' @param print_pages (`flag`)\cr whether the paginated listing should be printed to the console
#'   (`cat(toString(x))`).
#'
#' @return A list of `listing_df` objects where each list element corresponds to a separate page.
#'
#' @examples
#' dat <- ex_adae
#' lsting <- as_listing(dat[1:25, ], disp_cols = c("USUBJID", "AESOC", "RACE", "AETOXGR", "BMRKR1"))
#' mat <- matrix_form(lsting)
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
                             col_gap = 3,
                             fontspec = font_spec(font_family, font_size, lineheight),
                             verbose = FALSE,
                             print_pages = TRUE) {
  checkmate::assert_multi_class(lsting, c("listing_df", "list"))
  checkmate::assert_numeric(colwidths, lower = 0, len = length(listing_dispcols(lsting)), null.ok = TRUE)
  checkmate::assert_flag(tf_wrap)
  checkmate::assert_count(max_width, null.ok = TRUE)
  checkmate::assert_flag(verbose)
  checkmate::assert_flag(print_pages)

  pages <- paginate_to_mpfs(lsting,
    page_type = page_type,
    fontspec = fontspec,
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
    col_gap = col_gap,
    verbose = verbose
  )

  if (print_pages) {
    nothing <- lapply(seq_along(pages), function(pagi) {
      cat("--- Page", paste0(pagi, "/", length(pages)), "---\n")
      # It is NULL because paginate_mpfs takes care of it
      cat(toString(pages[[pagi]], widths = NULL, tf_wrap = tf_wrap, max_width = max_width, col_gap = col_gap))
      cat("\n")
    })
  }
  invisible(pages)
}
