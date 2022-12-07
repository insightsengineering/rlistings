setOldClass(c("listing_df", "tbl_df", "tbl", "data.frame"))
setOldClass(c("MatrixPrintForm", "list"))

#' @rdname listings
#' @title Create a Listing from a `data.frame` or `tibble`
#'
#' @description `r lifecycle::badge("experimental")`
#'
#' Creates listings by using `cols` and `key_cols` to produce a compact and
#' elegant representation of the `data.frame` or `tibble` in input.
#'
#' @param df data.frame. The (non-listing) data.frame to be converted to a listing.
#' @param cols character. Names of columns (including but not limited to key columns)
#'   which should be displayed when the listing is rendered.
#' @param key_cols character. Names of columns which should be treated as *key columns*
#'   when rendering the listing.
#' @param main_title character(1) or NULL. The main title for the listing, or
#'   `NULL` (the default). Must be length 1 non-NULL.
#' @param subtitles character or NULL. A vector of subtitle(s) for the
#'   listing, or `NULL` (the default).
#' @param main_footer character or NULL. A vector of main footer lines
#'   for the listing, or `NULL` (the default).
#' @param prov_footer character or NULL. A vector of provenance strings
#'   for the listing, or `NULL` (the default).
#'
#' @return A `listing_df` object, sorted by the key columns.
#'
#' @examples
#' dat <- ex_adae
#'
#' lsting <- as_listing(dat[1:25, ], key_cols = c("USUBJID", "AESOC")) %>%
#'   add_listing_col("AETOXGR") %>%
#'   add_listing_col("BMRKR1", format = "xx.x") %>%
#'   add_listing_col("AESER / AREL", fun = function(df) paste(df$AESER, df$AREL, sep = " / "))
#'
#' mat <- matrix_form(lsting)
#'
#' cat(toString(mat))
#'
#' @export
as_listing <- function(df,
                       cols = key_cols,
                       key_cols = names(df)[1],
                       main_title = NULL,
                       subtitles = NULL,
                       main_footer = NULL,
                       prov_footer = NULL) {
  df <- as_tibble(df)
  varlabs <- var_labels(df, fill = TRUE)
  o <- do.call(order, df[key_cols])
  if (is.unsorted(o)) {
    message("sorting incoming data by key columns")
    df <- df[o, ]
  }

  ## reorder the full set of cols to ensure key columns are first
  ordercols <- c(key_cols, setdiff(names(df), key_cols))
  df <- df[, ordercols]
  var_labels(df) <- varlabs[ordercols]

  for (cnm in key_cols) {
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
  if (is.factor(vec)) {
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
#' @param indent_rownames logical(1). Silently ignored, as listings do not have row names
#' nor indenting structure.
#' @rdname listings
setMethod(
  "matrix_form", "listing_df",
  rix_form <- function(obj, indent_rownames = FALSE) {
    ##  we intentionally silently ignore indent_rownames because listings have
    ## no rownames, but formatters::vert_pag_indices calls matrix_form(obj, TRUE)
    ## unconditionally.
    cols <- attr(obj, "listing_dispcols")
    listing <- obj[, cols]
    atts <- attributes(obj)
    atts$names <- cols
    attributes(listing) <- atts

    keycols <- get_keycols(listing)


    bodymat <- matrix("",
      nrow = nrow(listing),
      ncol = ncol(listing)
    )

    colnames(bodymat) <- names(listing)


    curkey <- ""
    for (i in seq_along(keycols)) {
      kcol <- keycols[i]
      kcolvec <- listing[[kcol]]
      curkey <- paste0(curkey, kcolvec)
      disp <- c(TRUE, tail(curkey, -1) != head(curkey, -1))
      bodymat[disp, kcol] <- kcolvec[disp]
    }

    nonkeycols <- setdiff(names(listing), keycols)
    if (length(nonkeycols) > 0) {
      for (nonk in nonkeycols) {
        vec <- listing[[nonk]]
        vec <- vapply(vec, format_value, "", format = obj_format(vec))
        bodymat[, nonk] <- vec
      }
    }


    fullmat <- rbind(
      var_labels(listing, fill = TRUE),
      bodymat
    )

    keycolaligns <- rbind(
      rep("center", length(keycols)),
      matrix("left",
        ncol = length(keycols),
        nrow = nrow(fullmat) - 1
      )
    )
    MatrixPrintForm(
      strings = fullmat,
      spans = matrix(1,
        nrow = nrow(fullmat),
        ncol = ncol(fullmat)
      ),
      ref_fnotes = list(),
      aligns = cbind(
        keycolaligns,
        matrix("center",
          nrow = nrow(fullmat),
          ncol = ncol(fullmat) - length(keycols)
        )
      ),
      formats = matrix(1,
        nrow = nrow(fullmat),
        ncol = ncol(fullmat)
      ),
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
      prov_footer = prov_footer(obj)
    )
  }
)


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
`listing_dispcols<-` <- function(df, value) {
  if (!is.character(value)) {
    stop(
      "dispcols must be a character vector of column names, got ",
      "object of class: ", paste(class(value), collapse = ",")
    )
  }
  chk <- setdiff(value, names(df)) ## remember setdiff is not symmetrical
  if (length(chk) > 0) {
    stop(
      "listing display columns must be columns in the underlying data. ",
      "Column(s) ", paste(chk, collapse = ", "), " not present in the data."
    )
  }
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
#' function, or `sprintf` format) for use when displaying the column
#' during rendering.
#'
#' @return `df`, with `name` created (if necessary) and marked for
#' display during rendering.
#' @rdname listings
add_listing_col <- function(df, name, fun = NULL, format = NULL, na_str = "-") {
    if (!is.null(fun)) {
      vec <- fun(df)
    } else if (name %in% names(df)) {
        vec <- df[[vec]]
    } else {
        stop("Column '", name, "' not found. name argument must specify an existing column when ",
             "no generating function (fun argument) is specified.")
    }


    if (!is.null(format)) {
        vec <- df[[name]]
        obj_format(vec) <- format
    }

    obj_na_str(vec) <- na_str

    ## this works for both new and existing columns
    df[[name]] <- vec
    df <- add_listing_dispcol(df, name)
    df
}
