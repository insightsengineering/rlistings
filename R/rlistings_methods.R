## #' Print a listing to the terminal
## #' @param x listing_df. the listing
## #' @param ... ANY. unused
## #' @return prints the listing object to the screen and silently returns the object
## #' @export
## setMethod("print", "listing_df",
##           function(x, ...) {
##     cat(toString(listing_matrix_form(x)))
##     invisible(x)
## })

#' Methods for `listing_df` objects
#'
#' See core documentation in \code{formatters} for descriptions
#' of these functions.
#'
#' @param x listing_df. The listing.
#' @param ... dots. Unused
#' @method print listing_df
#' @name listing_methods
#' @export
print.listing_df <- function(x, ...) {
  cat(toString(matrix_form(x)))
  invisible(x)
}

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

#' @rdname listing_methods
#' @param df listing_df. The listing.
#' @param colnm Column name
#' @param colvec Column values based on colnm
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

#' @rdname listing_methods
#' @param vec A vector.
#' @keywords internal
setGeneric("vec_nlines", function(vec, max_width = NULL) standardGeneric("vec_nlines"))

#' @rdname listing_methods
#' @param vec A vector.
#' @keywords internal
setMethod("vec_nlines", "ANY", function(vec, max_width = NULL) {
  strvec <- wrap_txt(format_colvector(colvec = vec), max_width = max_width, hard = TRUE)
  mtchs <- gregexpr("\n", strvec, fixed = TRUE)
  1L + vapply(mtchs, function(vi) sum(vi > 0), 1L)
})

## setMethod("vec_nlines", "character", function(vec, max_width = NULL) {
##     strvec <- wrap_txt(format_colvector(colvec = vec), max_width = max_width, hard = TRUE)
##     mtchs <- gregexpr("\n", strvec, fixed = TRUE)
##     1L + vapply(mtchs, function(vi) sum(vi > 0), 1L)
## })

## setMethod("vec_nlines", "factor", function(vec, max_width = NULL) {
##   lvl_nlines <- vec_nlines(levels(vec), max_width = max_width)
##   ret <- lvl_nlines[vec]
##   ret[is.na(ret)] <- format_value(NA_character
## })

#' @inheritParams formatters::make_row_df
#' @rdname listing_methods
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
           nsibs = NA_integer_) {
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
      col_ext <- vec_nlines(tt[[col]], max_width = colwidths[col])
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

#' @rdname listing_methods
#' @param x listing_df. The listing.
#' @inheritParams base::Extract
#' @param i ANY. Passed to base `[` methods.
#' @param j ANY. Passed to base `[` methods.
#' @aliases [,listing_df-method
#' @export
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
#' @param obj The object.
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
