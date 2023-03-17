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
                             font_size = 12,
                             lineheight = 1,
                             landscape = FALSE,
                             pg_width = NULL,
                             pg_height = NULL,
                             margins = c(top = .5, bottom = .5, left = .75, right = .75),
                             lpp,
                             cpp,
                             colwidths = propose_column_widths(lsting),
                             tf_wrap = FALSE,
                             max_width = NULL,
                             verbose = FALSE) {
  checkmate::assert_class(lsting, "listing_df")
  checkmate::assert_numeric(colwidths, lower = 0, len = length(listing_dispcols(lsting)), null.ok = TRUE)
  checkmate::assert_set_equal(names(colwidths), listing_dispcols(lsting))
  checkmate::assert_flag(tf_wrap)
  checkmate::assert_count(max_width, null.ok = TRUE)
  checkmate::assert_flag(verbose)

  if (missing(lpp) && missing(cpp) && !is.null(page_type) ||
    (!is.null(pg_width) && !is.null(pg_height))) {
    pg_lcpp <- page_lcpp(
      page_type = page_type,
      landscape = landscape,
      font_family = font_family,
      font_size = font_size,
      lineheight = lineheight,
      margins = margins,
      pg_width = pg_width,
      pg_height = pg_height
    )
    if (missing(lpp)) {
      lpp <- pg_lcpp$lpp
    }
    if (missing(cpp)) {
      cpp <- pg_lcpp$cpp
    }
  } else {
    if (missing(cpp)) {
      cpp <- NULL
    }
    if (missing(lpp)) {
      lpp <- 70
    }
  }

  if (is.null(colwidths)) {
    colwidths <- propose_column_widths(matrix_form(lsting, indent_rownames = TRUE))
  }

  if (!tf_wrap) {
    if (!is.null(max_width)) {
      warning("tf_wrap is FALSE - ignoring non-null max_width value.")
    }
    max_width <- NULL
  } else if (is.null(max_width)) {
    max_width <- cpp
  } else if (identical(max_width, "auto")) {
    # this 3 is column separator width.
    max_width <- sum(colwidths) + 3 * (length(colwidths) - 1)
  }
  if (!is.null(cpp) && !is.null(max_width) && max_width > cpp) {
    warning("max_width specified is wider than characters per page width (cpp).")
  }

  # row-space pagination.
  ret <- if (!is.null(lpp)) {
    inds <- pag_listing_indices(
      lsting = lsting,
      lpp = lpp,
      colwidths = colwidths,
      verbose = verbose,
      max_width = max_width
    )
    lapply(inds, function(i) lsting[i, ])
  } else {
    list(lsting)
  }

  # column-space pagination.
  if (!is.null(cpp)) {
    inds <- vert_pag_indices(
      lsting,
      cpp = cpp,
      colwidths = colwidths,
      verbose = verbose,
      rep_cols = length(get_keycols(lsting))
    )
    dispcols <- listing_dispcols(lsting)
    pag_cols <- lapply(inds, function(i) dispcols[i])
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

#' @rdname paginate
#' @export
pag_listing_indices <- function(lsting,
                                lpp = 15,
                                colwidths = NULL,
                                max_width = NULL,
                                verbose = FALSE) {
  checkmate::assert_class(lsting, "listing_df")
  checkmate::assert_numeric(colwidths, lower = 0, len = length(listing_dispcols(lsting)), null.ok = TRUE)
  checkmate::assert_set_equal(names(colwidths), listing_dispcols(lsting))
  checkmate::assert_count(max_width, null.ok = TRUE)
  checkmate::assert_flag(verbose)

  dheight <- divider_height(lsting)
  dcols <- listing_dispcols(lsting)
  cinfo_lines <- max(
    mapply(nlines, x = var_labels(lsting)[dcols], max_width = colwidths[dcols])
  ) + dheight
  tlines <- if (any(nzchar(all_titles(lsting)))) {
    length(all_titles(lsting)) + dheight + 1L
  } else {
    0
  }
  flines <- length(all_footers(lsting))
  if (flines > 0) {
    flines <- flines + dheight + 1L
  }
  rlpp <- lpp - cinfo_lines - tlines - flines
  if (verbose) {
    message("Adjusted Lines Per Page: ", rlpp, " (original lpp: ", lpp, ")")
  }

  pagdf <- make_row_df(lsting, colwidths)
  pag_indices_inner(
    pagdf = pagdf,
    rlpp = rlpp,
    min_siblings = 0,
    verbose = verbose,
    have_col_fnotes = FALSE,
    div_height = dheight
  )
}
