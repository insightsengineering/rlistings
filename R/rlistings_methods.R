
## XXX this historically has been 1, but it actually should be 1.2!!!!!
dflt_courier <- font_spec("Courier", 9, 1)

#' Methods for `listing_df` objects
#'
#' See core documentation in [formatters::formatters-package] for descriptions of these functions.
#'
#' @inheritParams formatters::toString
#' @param x (`listing_df`)\cr the listing.
#' @param ... additional parameters passed to [formatters::toString()].
#'
#' @method print listing_df
#'
#' @export
#' @name listing_methods
print.listing_df <- function(x, widths = NULL, tf_wrap = FALSE, max_width = NULL, fontspec = NULL, col_gap = 3L,  ...) {
  cat(
    toString(
      matrix_form(x, fontspec = fontspec, col_gap = col_gap),
      widths = widths,
      tf_wrap = tf_wrap,
      max_width = max_width,
      fontspec = fontspec,
      col_gap = col_gap,
      ...
    )
  )
  invisible(x)
}

#' @exportMethod toString
#' @name listing_methods
#' @aliases toString,listing_df-method
setMethod("toString", "listing_df", function(x, widths = NULL, fontspec = NULL, col_gap = 3L,  ...) {
  toString(
    matrix_form(x, fontspec = fontspec, col_gap = col_gap),
    fontspec = fontspec,
    col_gap = col_gap,
    widths = widths,
    ...
  )
})

## because rle in base is too much of a stickler for being atomic
basic_run_lens <- function(x) {
  n <- length(x)
  if (n == 0) {
    return(integer())
  }

  y <- x[-1L] != x[-n]
  i <- c(which(y), n)
  diff(c(0L, i))
}

#' @param df (`listing_df`)\cr the listing.
#' @param colnm (`string`)\cr column name.
#' @param colvec (`vector`)\cr column values based on `colnm`.
#'
#' @rdname vec_nlines
#' @keywords internal
format_colvector <- function(df, colnm, colvec = df[[colnm]]) {
  if (missing(colvec) && !(colnm %in% names(df))) {
    stop("column ", colnm, " not found")
  }
  na_str <- obj_na_str(colvec)
  if (is.null(na_str) || all(is.na(na_str))) {
    na_str <- rep("-", max(1L, length(na_str)))
  }

  strvec <- vapply(colvec, format_value, "", format = obj_format(colvec), na_str = na_str)
  strvec
}

#' Utilities for formatting a listing column
#'
#' For `vec_nlines`, calculate the number of lines each element of a column vector will
#' take to render. For `format_colvector`,
#'
#' @param vec (`vector`)\cr a column vector to be rendered into ASCII.
#' @param max_width (`numeric(1)` or `NULL`)\cr the width to render the column with.
#' @return (`numeric`)\cr a vector of the number of lines element-wise that will be
#'   needed to render the elements of `vec` to width `max_width`.
#'
#' @keywords internal
setGeneric("vec_nlines", function(vec, max_width = NULL, fontspec = dflt_courier) standardGeneric("vec_nlines"))

#' @param vec (`vector`)\cr a vector.
#'
#' @rdname vec_nlines
#' @keywords internal
setMethod("vec_nlines", "ANY", function(vec, max_width = NULL, fontspec = dflt_courier) {
  if (is.null(max_width)) {
    max_width <- floor(0.9 * getOption("width")) # default of base::strwrap
    # NB: flooring as it is used as <= (also in base::strwrap)
  }
  # in formatters for characters
  unlist(lapply(format_colvector(colvec = vec), nlines, max_width = max_width, fontspec = fontspec))
})

## setMethod("vec_nlines", "character", function(vec, max_width = NULL) {
##     strvec <- wrap_txt(format_colvector(colvec = vec), width = max_width, collapse = "\n")
##     mtchs <- gregexpr("\n", strvec, fixed = TRUE)
##     1L + vapply(mtchs, function(vi) sum(vi > 0), 1L)
## })

## setMethod("vec_nlines", "factor", function(vec, max_width = NULL) {
##   lvl_nlines <- vec_nlines(levels(vec), max_width = max_width)
##   ret <- lvl_nlines[vec]
##   ret[is.na(ret)] <- format_value(NA_character
## })

#' Make pagination data frame for a listing
#'
#' @inheritParams formatters::make_row_df
#' @param tt (`listing_df`)\cr the listing to be rendered.
#' @param visible_only (`flag`)\cr ignored, as listings do not have
#'   non-visible structural elements.
#'
#' @return a `data.frame` with pagination information.
#'
#' @seealso [formatters::make_row_df()]
#'
#' @examples
#' lsting <- as_listing(mtcars)
#' mf <- matrix_form(lsting)
#'
#' @export
setMethod(
  "make_row_df", "listing_df",
  function(tt, colwidths = NULL, visible_only = TRUE,
           rownum = 0,
           indent = 0L,
           path = character(),
           incontent = FALSE,
           repr_ext = 0L,
           repr_inds = integer(),
           sibpos = NA_integer_,
           nsibs = NA_integer_,
           fontspec = dflt_courier) {
    ## assume sortedness by keycols
    keycols <- get_keycols(tt)
    dispcols <- listing_dispcols(tt)
    abs_rownumber <- seq_along(tt[[1]])
    if (length(keycols) >= 1) {
      runlens <- basic_run_lens(tt[[tail(keycols, 1)]])
    } else {
      runlens <- rep(1, NROW(tt))
    }
    sibpos <- unlist(lapply(runlens, seq_len))
    nsibs <- rep(runlens, times = runlens)
    extents <- rep(1L, nrow(tt))
    if (length(colwidths) > 0 && length(colwidths) != length(dispcols)) {
      stop(
        "Non-null colwidths vector must be the same length as the number of display columns.\n",
        "Got: ", length(colwidths), "(", length(dispcols), " disp cols)."
      )
    }
    if (length(colwidths) > 0) {
      names(colwidths) <- dispcols
    }
    ## extents is a row-wise vector of extents, for each col, we update
    ## if that column has any rows wider than the previously recorded extent.
    for (col in dispcols) {
      ## duplicated from matrix_form method, refactor!
      col_ext <- vec_nlines(tt[[col]], max_width = colwidths[col], fontspec = fontspec)
      extents <- ifelse(col_ext > extents, col_ext, extents)
    }
    ret <- data.frame(
      label = "", name = "",
      abs_rownumber = abs_rownumber,
      path = I(as.list(rep(NA_character_, NROW(tt)))),
      pos_in_siblings = sibpos,
      n_siblings = nsibs,
      self_extent = extents,
      par_extent = 0L,
      reprint_inds = I(replicate(NROW(tt), list(integer()))),
      node_class = "listing_df",
      indent = 0L,
      nrowrefs = 0L, ## XXX this doesn't support footnotes
      ncellrefs = 0L, ## XXX this doesn't support footnotes
      nreflines = 0L, ## XXX this doesn't support footnotes
      force_page = FALSE,
      page_title = NA_character_,
      trailing_sep = NA_character_
    )
    stopifnot(identical(
      names(ret),
      names(pagdfrow(
        nm = "", lab = "", rnum = 1L, pth = NA_character_, extent = 1L,
        rclass = ""
      ))
    ))
    ret
  }
)

##     tt$sibpos <- unlist(lapply(
##     ## don't support pathing for now
##     tt$path <- I(lapply(1:NROW(tt),
##                     function(i) {
##         retpath <- character(2*length(keycols))
##         for(j in seq_along(keycols)) {
##             retpath[2*j - 1] <- keycols[j]
##             retpath[2*j] <- tt[i, keycols[j], drop = TRUE]
##         }
##         retpath
##     }))
##     spl <- split(tt, tt[keycols])
##     spl <- spl[vapply(spl, function(y) NROW(y) > 0, NA)]
##     dfs <- lapply(spl, function(df) {
##         df <- df[order(df$abs_rownumber),]
##         ndf <- NROW(df)
##         lapply(1:ndf, function(i) {
##             rw <- df[i,]
##             stopifnot(nrow(rw) == 1)
##             pagdfrow(nm = "",
##                      lab = "",
##                      rnum = rw$abs_rownumber,
##                      pth = NA_character_,
##                      sibpos = i,
##                      nsibs = ndf,
##                      extent = 1L,
##                      rclass = "listing_df",
##                      repind = integer())
##         })
##     })
##     ret <- do.call(rbind, unlist(dfs, recursive = FALSE))
##     ret <- ret[order(ret$abs_rownumber),]
##     ret
## })

#' @inheritParams base::Extract
#' @param x (`listing_df`)\cr the listing.
#' @param i (`any`)\cr object passed to base `[` methods.
#' @param j (`any`)\cr object passed to base `[` methods.
#'
#' @export
#' @aliases [,listing_df-method
#' @rdname listing_methods
setMethod(
  "[", "listing_df",
  function(x, i, j, drop = FALSE) {
    xattr <- attributes(x)
    xattr$names <- xattr$names[j]
    res <- NextMethod()
    if (!drop) {
      attributes(res) <- xattr
    }
    res
  }
)

#' @rdname listing_methods
#' @param obj (`listing_df`)\cr the listing.
#'
#' @return
#' * Accessor methods return the value of the aspect of `obj`.
#' * Setter methods return `obj` with the relevant element of the listing updated.
#'
#' @examples
#' lsting <- as_listing(mtcars)
#' main_title(lsting) <- "Hi there"
#'
#' main_title(lsting)
#'
#' @export
setMethod(
  "main_title", "listing_df",
  function(obj) attr(obj, "main_title") %||% character()
)

#' @rdname listing_methods
#' @export
setMethod(
  "subtitles", "listing_df",
  function(obj) attr(obj, "subtitles") %||% character()
)

#' @rdname listing_methods
#' @export
setMethod(
  "main_footer", "listing_df",
  function(obj) attr(obj, "main_footer") %||% character()
)

#' @rdname listing_methods
#' @export
setMethod(
  "prov_footer", "listing_df",
  function(obj) attr(obj, "prov_footer") %||% character()
)

.chk_value <- function(val, fname, len_one = FALSE, null_ok = TRUE) {
  if (null_ok && is.null(val)) {
    return(TRUE)
  }
  if (!is.character(val)) {
    stop("value for ", fname, " must be a character, got ",
      "object of class: ", paste(class(val), collapse = ","),
      call. = FALSE
    )
  }
  if (len_one && length(val) > 1) {
    stop(
      "value for ", fname, " must be length <= 1, got ",
      "vector of length ", length(val)
    )
  }
  TRUE
}

#' @rdname listing_methods
#' @export
setMethod(
  "main_title<-", "listing_df",
  function(obj, value) {
    ## length 1 restriction is to match rtables behavior
    ## which currently enforces this (though incompletely)
    .chk_value(value, "main_title", len_one = TRUE)
    attr(obj, "main_title") <- value
    obj
  }
)

#' @rdname listing_methods
#' @export
setMethod(
  "subtitles<-", "listing_df",
  function(obj, value) {
    .chk_value(value, "subtitles")
    attr(obj, "subtitles") <- value
    obj
  }
)

#' @rdname listing_methods
#' @export
setMethod(
  "main_footer<-", "listing_df",
  function(obj, value) {
    .chk_value(value, "main_footer")
    attr(obj, "main_footer") <- value
    obj
  }
)

#' @rdname listing_methods
#' @export
setMethod(
  "prov_footer<-", "listing_df",
  function(obj, value) {
    .chk_value(value, "prov_footer")
    attr(obj, "prov_footer") <- value
    obj
  }
)

#' @rdname listing_methods
#' @export
setMethod(
  "num_rep_cols", "listing_df",
  function(obj) {
    length(get_keycols(obj))
  }
)
