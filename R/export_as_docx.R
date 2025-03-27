old_paginate_listing <- function(lsting,
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
                                 colwidths = formatters::propose_column_widths(lsting),
                                 tf_wrap = !is.null(max_width),
                                 max_width = NULL,
                                 verbose = FALSE) {
  checkmate::assert_class(lsting, "listing_df")
  checkmate::assert_numeric(colwidths, lower = 0, len = length(listing_dispcols(lsting)), null.ok = TRUE)
  checkmate::assert_flag(tf_wrap)
  checkmate::assert_count(max_width, null.ok = TRUE)
  checkmate::assert_flag(verbose)

  indx <- formatters::paginate_indices(lsting,
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


#' convert listing to flextable
#' @export
to_flextable.listing_df <- function(x, cpp = 100, lpp = 200, ...) {
  col_width <- 100
  df = x
  pag_df <- old_paginate_listing(df) # cpp = cpp, lpp = lpp)
  print(length(pag_df))
  ft_list <- lapply(1:length(pag_df), function(x) {
    mf <- formatters::matrix_form(pag_df[[x]])
    nr_header <- attr(mf, "nrow_header")
    tmpdf <- as.data.frame(mf$strings[(nr_header + 1):(nrow(mf$strings)), , drop = FALSE])
    ft <- to_flextable.data.frame(tmpdf, col_width = col_width, ...)
    if (length(prov_footer(df)) == 0) {
      cat_foot <- main_footer(df)
    } else {
      cat_foot <- paste0(prov_footer(df), "\n", main_footer(df))
    }

    if (length(cat_foot) == 0) {
      cat_foot <- ""
    }
    list(
      ft = ft,
      header = ifelse(x == 1, main_title(df), paste(main_title(df), "(cont.)")),
      footnotes = cat_foot
    )
  })
  # force the width of the 1st column to be the widest of all paginated table
  # ft_list_resize <- set_width_widest(ft_list)
  # class(ft_list) <- "dflextable"

  ft_list
}


do_call <- function(fun, ...) {
  args <- list(...)
  do.call(fun, args[intersect(names(args), formalArgs(fun))])
}


#' s3 method for to_flextable
#' @param x object to to_flextable
#' @param ... additional arguments passed to methods
to_flextable <- function(x, ...) {
  UseMethod("to_flextable")
}


#' default method to to_flextable
#' @param x object to to_flextable
#' @param ... additional arguments. not used.
#'
#' @export
to_flextable.default <- function(x, ...) {
  stop("default to_flextable function does not exist")
}

#' data.frame method to to_flextable
#' @param x object to to_flextable
#'
#' @export
to_flextable.data.frame <- function(x, col_width = NULL, font_size = 9, ...) {
  df <- x
  ft <- do_call(flextable, data = df, ...)

    ft <- ft %>%
      autofit() %>%
      fit_to_width(10)

  return(ft)
}

#' Export to docx
#' @examples
#' lsting <- as_listing(iris, key_cols = "Species")
#' export_as_docx(lsting, "tmp.docx")
#' @export
export_as_docx <- function(listing,
                           file){
  flex_listing_list <- to_flextable(listing)
  doc <- officer::read_docx()
  for (flx in flex_listing_list){
    flex_to_doc(doc, content = flx$ft)
  }
  print(doc, target = file)
}


flex_to_doc <- function(doc, content){
  doc <- flextable::body_add_flextable(doc, content, align = "left")
}
