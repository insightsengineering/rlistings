#' Export as plain text with page break symbol
#'
#' @inheritParams paginate_listing
#' @param file character(1). File to write.
#' @param paginate logical(1). Should \code{tt} be paginated before writing the file. Defaults to `TRUE` if any sort of page dimension is specified.
#' @param \dots Passed directly to \code{\link{paginate_listing}}
#' @param page_break character(1). Page break symbol (defaults to outputting \code{"\\s"}).
#' @return \code{file} (this function is called for the side effect of writing the file.
#'
#' @note When specified, `font_size` is used *only* to determine pagination based
#' on page dimensions. The written file is populated in raw ASCII text, which
#' does not have the concept of font size.
#'
#' @export
#'
#'
#' @examples
#'
#' dat <- ex_adae
#' lsting <- as_listing(dat[1:25, ], key_cols = c("USUBJID", "AESOC")) %>%
#'   add_listing_col("AETOXGR") %>%
#'   add_listing_col("BMRKR1", format = "xx.x") %>%
#'   add_listing_col("AESER / AREL", fun = function(df) paste(df$AESER, df$AREL, sep = " / "))
#' main_title(lsting) <- "this is some title"
#' main_footer(lsting) <- "this is some footer"
#' cat(export_as_txt(lsting, file = NULL, paginate = TRUE))
#'
export_as_txt <- function(tt, file = NULL,
                          page_type = NULL,
                          landscape = FALSE,
                          pg_width = page_dim(page_type)[if(landscape) 2 else 1],
                          pg_height = page_dim(page_type)[if(landscape) 1 else 2],
                          font_family = "Courier",
                          font_size = 8,  # grid parameters
                          paginate = .need_pag(page_type, pg_width, pg_height, lpp, cpp),
                          cpp = NULL,
                          lpp = NULL,
                          ..., page_break = "\\s\\n",
                          hsep = default_hsep(),
                          indent_size = 2,
                          tf_wrap = paginate,
                          max_width = cpp,
                          colwidths = propose_column_widths(matrix_form(tt, TRUE))) {
  if(!is.null(colwidths) && length(colwidths) != ncol(tt) )
    stop("non-null colwidths argument must have length ncol(tt) [",
         ncol(tt), "], got length ", length(colwidths))
  if(paginate) {
    gp_plot <- gpar(fontsize = font_size, fontfamily = font_family)

    pdf(file = tempfile(), width = pg_width, height = pg_height)
    on.exit(dev.off())
    grid.newpage()
    pushViewport(plotViewport(margins = c(0, 0, 0, 0), gp = gp_plot))

    cur_gpar <-  get.gpar()
    if(is.null(page_type) && is.null(pg_width) && is.null(pg_height) &&
       (is.null(cpp) || is.null(lpp))) {
      page_type <- "letter"
      pg_width <- page_dim(page_type)[if(landscape) 2 else 1]
      pg_height <- page_dim(page_type)[if(landscape) 1 else 2]
    }

    if (is.null(lpp)) {
      lpp <- floor(convertHeight(unit(1, "npc"), "lines", valueOnly = TRUE) /
                     (cur_gpar$cex * cur_gpar$lineheight))
    }
    if(is.null(cpp)) {
      cpp <- floor(convertWidth(unit(1, "npc"), "inches", valueOnly = TRUE) *
                     font_lcpi(font_family, font_size, cur_gpar$lineheight)$cpi)
    }
    if(tf_wrap && is.null(max_width))
      max_width <- cpp

    tbls <- paginate_listing(tt, lpp = lpp, cpp = cpp,
                             min_siblings = 2,
                             nosplitin = character(),
                             colwidths = propose_column_widths(lsting),
                             verbose = FALSE)
  } else {
    tbls <- list(tt)
  }

  res <- paste(mapply(function(tb, ...) {
    ## 1 and +1 are because cwidths includes rowlabel 'column'
    # cinds <- c(1, .figure_out_colinds(tb, tt) + 1L)
    toString(tb, ...)
  },
  MoreArgs = list(hsep = hsep
                  ),
  SIMPLIFY = FALSE,
  tb = tbls),
  collapse = page_break)

  if(!is.null(file))
    cat(res, file = file)
  else
    res
}


.do_inset <- function(x, inset) {
  if (inset == 0 || !any(nzchar(x))) {
    return(x)
  }
  padding <- strrep(" ", inset)
  if (is.character(x)) {
    x <- paste0(padding, x)
  } else if (is(x, "matrix")) {
    x[, 1] <- .do_inset(x[, 1, drop = TRUE], inset)
  }
  x
}


.paste_no_na <- function(x, ...) {
  paste(na.omit(x), ...)
}

