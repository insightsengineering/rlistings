#' @import formatters
#' @import dplyr
#' @import methods
NULL

setOldClass(c("listing_df", "data.frame"))
setOldClass(c("MatrixPrintForm", "list"))
#' Create a Listing from a data.frame or tibble
#'
#'
#'
#' @export
#' @param df data.frame. The (non-listing) data.frame to be converted to a listing
#' @param cols character. Names of columns (including but not limited to key columns)
#' which should be displayed when the listing is rendered.
#' @param key_cols character. Names of columns which should be treated as *key columns*
#' when rendering the listing.
#' @param main_title character(1) or NULL. The main title for the listing, or
#'   `NULL` (the default). Must be length 1 non-NULL.
#' @param subtitles character or NULL. A vector of subtitle(s) for the listing, or
#'   NULL (the default).
#' @param main_footer character or NULL. A vector of main footer lines for the
#'   listing, or `NULL` (the default).
#' @param prov_footer character or NULL. A vector of provenance strings for the
#'   listing, or `NULL` (the default).
#'
#' @return A `listing_df` object, sorted by the key columns.
#' @rdname listings
#' @examples
#'
#'
#' dat <- ex_adae
#'
#' lsting <- as_listing(dat[1:25,], key_cols = c("USUBJID", "AESOC")) %>%
#'     add_listing_col("AETOXGR") %>%
#'     add_listing_col("BMRKR1", format = "xx.x") %>%
#'     add_listing_col("AESER / AREL", fun = function(df) paste(df$AESER, df$AREL, sep = " / "))
#'
#'
#' mat <- matrix_form(lsting)
#'
#' cat(toString(mat))
as_listing <- function(df,
                       cols = key_cols,
                       key_cols = names(df)[1],
                       main_title = NULL,
                       subtitles = NULL,
                       main_footer = NULL,
                       prov_footer = NULL
                       ) {
    varlabs <- var_labels(df, fill = TRUE)
    o <- do.call(order, df[key_cols])
    if(is.unsorted(o)) {
        message("sorting incoming data by key columns")
        df <- df[o,]
    }

    ## reorder the full set of cols to ensure key columns are first
    ordercols <- c(key_cols, setdiff(names(df), key_cols))
    df <- df[,ordercols]
    var_labels(df) <- varlabs[ordercols]

    for(cnm in key_cols) {
        df[[cnm]] <- as_keycol(df[[cnm]])
    }



    class(df) <- c("listing_df", class(df))
    ## these all work even when the value is NULL
    main_title(df) <- main_title
    main_footer(df) <- main_footer
    subtitles(df) <- subtitles
    prov_footer(df) <- prov_footer
    listing_dispcols(df) <- cols
    df
}


#' @export
#' @param vec vector. The column vector to be annotated as a keycolumn
#' @rdname listings
as_keycol <- function(vec) {
    if(is.factor(vec)) {
        lab <- obj_label(vec)
        vec <- as.character(vec)
        obj_label(vec) <- lab
    }
    class(vec) <- c("listing_keycol", class(vec))
    vec
}


#' @export
#' @param vec any. A column vector from a `listing_df`
#'
#' @rdname listings
is_keycol <- function(vec) {
    inherits(vec, "listing_keycol")
}



#' @export
#' @param df listing_df. The listing
#' @rdname listings
get_keycols <- function(df) {
    names(which(sapply(df, is_keycol)))
}

#' @export
#' @inheritParams formatters::matrix_form
#' @rdname listings
setMethod("matrix_form", "listing_df",
          rix_form <- function(obj, indent_rownames = FALSE) {
    if(indent_rownames)
        stop("indenting rownames is not supported for listings")
    cols <- attr(obj, "listing_dispcols")
    listing <- obj[,cols]
    atts <- attributes(obj)
    atts$names <- cols
    attributes(listing) <- atts

    keycols <- get_keycols(listing)


    bodymat <- matrix("", nrow = nrow(listing),
                      ncol = ncol(listing))

    colnames(bodymat) <- names(listing)


    curkey <- ""
    for(i in seq_along(keycols)) {

        kcol <- keycols[i]
        kcolvec <- listing[[kcol]]
        curkey <- paste0(curkey, kcolvec)
        disp <- c(TRUE, tail(curkey, -1) != head(curkey, -1))
        bodymat[disp, kcol] <- kcolvec[disp]
    }

    nonkeycols <- setdiff(names(listing), keycols)
    if(length(nonkeycols) > 0) {
        for(nonk in nonkeycols) {
            vec <- listing[[nonk]]
            vec <- vapply(vec, format_value, "", format = obj_format(vec))
            bodymat[,nonk] <- vec
        }
    }


    fullmat <- rbind(var_labels(listing, fill = TRUE),
                     bodymat)

    keycolaligns <- rbind(rep("center", length(keycols)),
                          matrix("left", ncol = length(keycols),
                           nrow = nrow(fullmat) - 1))
    MatrixPrintForm(strings = fullmat,
                    spans = matrix(1, nrow = nrow(fullmat),
                                   ncol = ncol(fullmat)),
                    ref_fnotes =list(),
                    aligns = cbind(keycolaligns,
                                   matrix("center", nrow = nrow(fullmat),
                                          ncol = ncol(fullmat)- length(keycols))),
                    formats = matrix(1, nrow = nrow(fullmat),
                                     ncol = ncol(fullmat)),
                    row_info = make_row_df(obj),
                    nlines_header = 1, ## XXX this is probably wrong!!!
                    nrow_header = 1,
                    has_topleft = FALSE,
                    has_rowlabs = FALSE,
                    expand_newlines = TRUE,
                    main_title = main_title(obj),
                    subtitles = subtitles(obj),
                    page_titles = page_titles(obj),
                    main_footer = main_footer(obj),
                    prov_footer = prov_footer(obj))
})


#' @export
#' @rdname listings
listing_dispcols <- function(df) attr(df, "listing_dispcols") %||% character()

#' @export
#' @param new character. Names of columns to be added to
#' the set of display columns.
#' @rdname listings
add_listing_dispcol <- function(df, new) {
    listing_dispcols(df) <- c(listing_dispcols(df), new)
    df
}
#' @export
#' @param value character. New value.
#' @rdname listings
`listing_dispcols<-` <-  function(df, value) {
    if(!is.character(value))
        stop("dispcols must be a character vector of column names, got ",
             "object of class: ", paste(class(value), collapse =","))
    chk <- setdiff(value, names(df)) ## remember setdiff is not symmetrical
    if(length(chk) > 0)
        stop("listing display columns must be columns in the underlying data. ",
             "Column(s) ", paste(chk, collapse = ", "), " not present in the data.")
    attr(df, "listing_dispcols") <- unique(value)
    df
}


#' @export
#' @param df listing_df. The listing to modify.
#' @param name character(1). Name of the existing or new column to be
#' displayed when the listing is rendered
#' @param fun function or NULL. A function which accepts \code{df} and
#' returns the vector for a new column, which is added to \code{df} as
#' \code{name}, or NULL if marking an existing column as
#' a listing column
#' @param format FormatSpec. A format specification (format string,
#' function, or sprintf format) for use when displaying the column
#' during rendering.
#'
#' @return `df`, with `name` created (if necessary) and marked for
#' display during rendering.
#' @rdname listings
add_listing_col <- function(df, name, fun = NULL, format = NULL) {
    if(!is.null(fun))
        df[[name]] <- fun(df)

    if(!is.null(format)) {
        vec <- df[[name]]
        attr(vec, "format") <- format
        df[[name]] <- vec
    }
    df <- add_listing_dispcol(df, name)
    df
}

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
#' @export
#' @param ... dots. Unused
#' @method print listing_df
#' @name listing_methods
print.listing_df <- function(x, ...) {
    cat(toString(matrix_form(x)))
    invisible(x)
}


## because rle in base base is too much of a stickler for being atomic
basic_run_lens <- function(x) {

    n <- length(x)
    if(n == 0) {
        return(integer())
    }

    y <- x[-1L] != x[-n]
    i <- c(which(y), n)
    diff(c(0L, i))
}

setGeneric("vec_nlines",  function(vec) standardGeneric("vec_nlines"))

setMethod("vec_nlines", "ANY", function(vec) rep(1L, length(vec)))

setMethod("vec_nlines", "character", function(vec) {
    mtchs <- gregexpr("\n", vec, fixed = TRUE)
    1L + vapply(mtchs, function(vi) sum(vi > 0), 1L)
})

setMethod("vec_nlines", "factor", function(vec) {

    lvl_nlines <- vec_nlines(levels(vec))
    lvl_nlines[vec]
})

#' @inheritParams formatters::make_row_df
#' @export
#' @rdname listing_methods
setMethod("make_row_df", "listing_df",
           function(tt, colwidths = NULL, visible_only = TRUE,
                    rownum = 0,
                    indent = 0L,
                    path = character(),
                    incontent = FALSE,
                    repr_ext = 0L,
                    repr_inds = integer(),
                    sibpos = NA_integer_,
                    nsibs = NA_integer_){

    ## assume sortedness by keycols
    keycols <- get_keycols(tt)
    abs_rownumber <- seq_along(tt[[1]])
    runlens <- basic_run_lens(tt[[tail(keycols,1)]])
    sibpos <- unlist(lapply(runlens, seq_len))
    nsibs <- rep(runlens, times = runlens)
    extents <- rep(1L, nrow(tt))
    for(col in listing_dispcols(tt)) {
        col_ext <- vec_nlines(tt[[col]])
        extents <- ifelse(col_ext > extents, col_ext, extents)
    }
    ret <- data.frame(label = "", name = "",
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
                      trailing_sep = NA_character_)
    stopifnot(identical(names(ret),
                        names(pagdfrow(nm = "", lab = "", rnum = 1L, pth = NA_character_, extent = 1L,
                                       rclass = ""))))
    ret
})


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


#' @export
#' @param x listing_df. The listing.
#' @inheritParams base::Extract
#' @param i ANY. Passed to base `[` methods.
#' @param j ANY. Passed to base `[` methods.
#' @aliases [,listing_df-method
#' @rdname listing_methods
setMethod("[", "listing_df",
          function(x, i, j, drop = FALSE) {
    xattr <- attributes(x)
    xattr$names <- xattr$names[j]
    res <- NextMethod()
    if(!drop)
        attributes(res) <- xattr
    res
})

#' @rdname listing_methods
#' @param obj The object.
#' @export
setMethod("main_title", "listing_df",
          function(obj) attr(obj, "main_title") %||% character())

#' @rdname listing_methods
#' @export
setMethod("subtitles", "listing_df",
          function(obj) attr(obj, "subtitles") %||% character())
#' @rdname listing_methods
#' @export
setMethod("main_footer", "listing_df",
          function(obj) attr(obj, "main_footer") %||% character())
#' @rdname listing_methods
#' @export
setMethod("prov_footer", "listing_df",
          function(obj) attr(obj, "prov_footer") %||% character())

.chk_value <- function(val, fname, len_one = FALSE, null_ok = TRUE) {
    if(null_ok && is.null(val))
        return(TRUE)
    if(!is.character(val))
        stop("value for ", fname, " must be a character, got ",
             "object of class: ", paste(class(val), collapse = ","),
             call. = FALSE)
    if(len_one && length(val) > 1)
        stop("value for ", fname, " must be length <= 1, got ",
             "vector of length ", length(val))
    TRUE
}

#' @rdname listing_methods
#' @param obj The object.
#' @export
setMethod("main_title<-", "listing_df",
          function(obj, value) {
    ## length 1 restriction is to match rtables behavior
    ## which currently enforces this (though incompletely)
    .chk_value(value, "main_title", len_one = TRUE)
    attr(obj, "main_title") <- value
    obj
})

#' @rdname listing_methods
#' @export
setMethod("subtitles<-", "listing_df",
          function(obj, value) {
    .chk_value(value, "subtitles")
    attr(obj, "subtitles") <- value
    obj
})

#' @rdname listing_methods
#' @export
setMethod("main_footer<-", "listing_df",
          function(obj, value) {
    .chk_value(value, "main_footer")
    attr(obj, "main_footer") <- value
    obj
})

#' @rdname listing_methods
#' @export
setMethod("prov_footer<-", "listing_df",
          function(obj, value) {
    .chk_value(value, "prov_footer")
    attr(obj, "prov_footer") <- value
    obj
})


#' @rdname listing_methods
#' @param lsting listing_df. The listing to paginate.
#' @inheritParams formatters::pag_indices_inner
#' @inheritParams formatters::vert_pag_indices
#' @param lpp numeric(1). Number of row lines (not counting titles and
#'     footers) to have per page.
#' @param colwidths  numeric. Print  widths of  columns, if  manually
#'     set/previously known.
#'
#' @export
paginate_listing <- function(lsting, lpp = 15,
                             cpp = NULL,
                             min_siblings = 2,
                             nosplitin = character(),
                             colwidths = NULL,
                             verbose = FALSE) {

    ## XXX TODO this is duplciated form pag_tt_indices
    ## refactor so its not
    dheight <- divider_height(lsting)

    cinfo_lines <- 1L
    if(any(nzchar(all_titles(lsting)))) {
        tlines <- length(all_titles(lsting)) + dheight + 1L
    } else {
        tlines <- 0
    }
    flines <- length(all_footers(lsting))
    if(flines > 0)
        flines <- flines + dheight + 1L
    ## row lines per page
    rlpp <- lpp - cinfo_lines - tlines - flines
    pagdf <- make_row_df(lsting, colwidths)

    inds <- pag_indices_inner(pagdf,
                              rlpp = rlpp,
                              min_siblings = min_siblings,
                              nosplitin = nosplitin,
                              verbose = verbose)

    ret <- lapply(inds, function(i) lsting[i,])
    ## this is *very* similar to the relevant section of rtables::paginate_table
    ## TODO push down into formatters to avoid duplication
    if(!is.null(cpp)) {
        inds <- vert_pag_indices(lsting,
                                 cpp = cpp,
                                 colwidths = colwidths,
                                 verbose = verbose)
        ret <- lapply(ret,
                      function(oneres) {
            lapply(inds,
                   function(ii) oneres[, ii, drop = FALSE])
        })
        ret <- unlist(ret, recursive = FALSE)
    }
    ret
}
