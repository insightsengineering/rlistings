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
#' @param df data.frame or listing_df. The (non-listing) data.frame to be converted to a listing or
#'   the listing_df to be modified.
#' @param key_cols character. Names of columns which should be treated as *key columns*
#'   when rendering the listing. Key columns allow you to group repeat occurrences.
#' @param disp_cols character or NULL. Names of non-key columns which should be displayed when
#'   the listing is rendered. Defaults to all columns of `df` not named in `key_cols` or
#'   `non_disp_cols`.
#' @param non_disp_cols character or NULL. Names of non-key columns to be excluded as display
#'   columns. All other non-key columns are then treated as display columns. Invalid if
#'   `disp_cols` is non-NULL.
#' @param unique_rows logical(1). Should only unique rows be included in the listing. Defaults to `FALSE`.
#' @param default_formatting list. A named list of default column format configurations to apply when rendering the
#'   listing. Each name-value pair consists of a name corresponding to a data class (or "numeric" for all unspecified
#'   numeric classes) and a value of type `fmt_config` with the format configuration that should be implemented for
#'   columns of that class. If named element "all" is included in the list, this configuration will be used for all
#'   data classes not specified. Objects of type `fmt_config` can take 3 arguments: `format`, `na_str`, and `align`.
#' @param col_formatting list. A named list of custom column formatting configurations to apply to specific columns
#'   when rendering the listing. Each name-value pair consists of a name corresponding to a column name and a value of
#'   type `fmt_config` with the formatting configuration that should be implemented for that column. Objects of type
#'   `fmt_config` can take 3 arguments: `format`, `na_str`, and `align`. Defaults to `NULL`.
#' @param main_title character(1) or NULL. The main title for the listing, or
#'   `NULL` (the default). Must be length 1 non-NULL.
#' @param subtitles character or NULL. A vector of subtitle(s) for the
#'   listing, or `NULL` (the default).
#' @param main_footer character or NULL. A vector of main footer lines
#'   for the listing, or `NULL` (the default).
#' @param prov_footer character or NULL. A vector of provenance strings
#'   for the listing, or `NULL` (the default). Each string element is placed on a new line.
#' @param vec any. A column vector from a `listing_df` to be annotated as a key column.
#'
#' @return A `listing_df` object, sorted by the key columns.
#'
#' @details At its core, a `listing_df` object is a `tbl_df` object with a customized
#' print method  and support for the formatting and pagination machinery provided by
#' the `formatters` package.
#'
#' `listing_df` objects have two 'special' types of columns: key columns and display columns.
#'
#' Key columns act as indexes, which means a number of things in practice.
#'
#' All key columns are also display columns.
#'
#' `listing_df` objects are always sorted by their set of key_columns at creation time.
#' Any `listing_df` object which is not sorted by its full set of key columns (e.g.,
#' one  whose rows have been reordered explicitly creation) is invalid and the behavior
#' when rendering or paginating that object is undefined.
#'
#' Each value of a key column is printed only once per page and per unique combination of
#' values for all higher-priority (i.e., to the left of it) key columns. Locations
#' where a repeated value would have been printed within a key column for the same
#' higher-priority-key combination on the same page are rendered as empty space.
#' Note, determination of which elements to display within a key column at rendering is
#' based on the underlying value; any non-default formatting applied to the column
#' has no effect on this behavior.
#'
#' Display columns are columns which should be rendered, but are not key columns. By
#' default this is all non-key columns in the incoming data, but in need not be.
#' Columns in the underlying data which are neither key nor display columns remain
#' within the object available for computations but *are not rendered during
#' printing or export of the listing*.
#'
#'
#' @examples
#' dat <- ex_adae
#'
#' # This example demonstrates the listing with key_cols (values are grouped by USUBJID) and
#' # multiple lines in prov_footer
#' lsting <- as_listing(dat[1:25, ],
#'   key_cols = c("USUBJID", "AESOC"),
#'   main_title = "Example Title for Listing",
#'   subtitles = "This is the subtitle for this Adverse Events Table",
#'   main_footer = "Main footer for the listing",
#'   prov_footer = c(
#'     "You can even add a subfooter", "Second element is place on a new line",
#'     "Third string"
#'   )
#' ) %>%
#'   add_listing_col("AETOXGR") %>%
#'   add_listing_col("BMRKR1", format = "xx.x") %>%
#'   add_listing_col("AESER / AREL", fun = function(df) paste(df$AESER, df$AREL, sep = " / "))
#'
#' mat <- matrix_form(lsting)
#'
#' cat(toString(mat))
#'
#' # This example demonstrates the listing table without key_cols
#' # and specifying the cols with disp_cols.
#' dat <- ex_adae
#' lsting <- as_listing(dat[1:25, ],
#'   disp_cols = c("USUBJID", "AESOC", "RACE", "AETOXGR", "BMRKR1")
#' )
#'
#' mat <- matrix_form(lsting)
#'
#' cat(toString(mat))
#'
#' # This example demonstrates a listing with format configurations specified
#' # via the default_formatting and col_formatting arguments
#' dat <- ex_adae
#' dat$AENDY[3:6] <- NA
#' lsting <- as_listing(dat[1:25, ],
#'   key_cols = c("USUBJID", "AESOC"),
#'   disp_cols = c("STUDYID", "SEX", "ASEQ", "RANDDT", "ASTDY", "AENDY"),
#'   default_formatting = list(
#'     all = fmt_config(align = "left"),
#'     numeric = fmt_config(
#'       format = "xx.xx",
#'       na_str = "<No data>",
#'       align = "right"
#'     )
#'   )
#' ) %>%
#'   add_listing_col("BMRKR1", format = "xx.x", align = "center")
#'
#' mat <- matrix_form(lsting)
#'
#' cat(toString(mat))
#'
#' @export
as_listing <- function(df,
                       key_cols = names(df)[1],
                       disp_cols = NULL,
                       non_disp_cols = NULL,
                       unique_rows = FALSE,
                       default_formatting = list(all = fmt_config()),
                       col_formatting = NULL,
                       main_title = NULL,
                       subtitles = NULL,
                       main_footer = NULL,
                       prov_footer = NULL) {
  if (length(non_disp_cols) > 0 && length(intersect(key_cols, non_disp_cols)) > 0) {
    stop(
      "Key column also listed in non_disp_cols. All key columns are by",
      " definition display columns."
    )
  }
  if (!is.null(disp_cols) && !is.null(non_disp_cols)) {
    stop("Got non-null values for both disp_cols and non_disp_cols. This is not supported.")
  } else if (is.null(disp_cols)) {
    ## non_disp_cols NULL is ok here
    cols <- setdiff(names(df), c(key_cols, non_disp_cols))
  } else {
    ## disp_cols non-null, non_disp_cols NULL
    cols <- disp_cols
  }
  if (!all(sapply(default_formatting, is, class2 = "fmt_config"))) {
    stop(
      "All format configurations supplied in `default_formatting`",
      " must be of type `fmt_config`."
    )
  }
  if (!(is.null(col_formatting) || all(sapply(col_formatting, is, class2 = "fmt_config")))) {
    stop(
      "All format configurations supplied in `col_formatting`",
      " must be of type `fmt_config`."
    )
  }

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

  ## key cols must be leftmost cols
  cols <- c(key_cols, setdiff(cols, key_cols))

  row_all_na <- apply(df[cols], 1, function(x) all(is.na(x)))
  if (any(row_all_na)) {
    message("rows that only contain NA values have been trimmed")
    df <- df[!row_all_na, ]
  }

  # set col format configs
  df[cols] <- lapply(cols, function(col) {
    col_class <- tail(class(df[[col]]), 1)
    col_fmt_class <- if (!col_class %in% names(default_formatting) && is.numeric(df[[col]])) "numeric" else col_class
    col_fmt <- if (col %in% names(col_formatting)) {
      col_formatting[[col]]
    } else if (col_fmt_class %in% names(default_formatting)) {
      default_formatting[[col_fmt_class]]
    } else {
      if (!"all" %in% names(default_formatting)) {
        stop(
          "Format configurations must be supplied for all listing columns. ",
          "To cover all remaining columns please add an 'all' configuration",
          " to `default_formatting`."
        )
      }
      default_formatting[["all"]]
    }
    # ANY attr <- fmt_config slot
    obj_format(df[[col]]) <- obj_format(col_fmt)
    obj_na_str(df[[col]]) <- if (is.null(obj_na_str(col_fmt))) "NA" else obj_na_str(col_fmt)
    obj_align(df[[col]]) <- if (is.null(obj_align(col_fmt))) "left" else obj_align(col_fmt)
    df[[col]]
  })

  if (unique_rows) df <- df[!duplicated(df[, cols]), ]

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
#' @rdname listings
is_keycol <- function(vec) {
  inherits(vec, "listing_keycol")
}



#' @export
#' @rdname listings
get_keycols <- function(df) {
  names(which(sapply(df, is_keycol)))
}

#' @export
#' @inherit formatters::matrix_form
#' @seealso [formatters::matrix_form()]
#' @param indent_rownames logical(1). Silently ignored, as listings do not have row names
#' nor indenting structure.
#'
#' @examples
#'
#' lsting <- as_listing(mtcars)
#' mf <- matrix_form(lsting)
#'
#' @return a `MatrixPrintForm` object
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
      kcolvec <- vapply(kcolvec, format_value, "", format = obj_format(kcolvec), na_str = obj_na_str(kcolvec))
      curkey <- paste0(curkey, kcolvec)
      disp <- c(TRUE, tail(curkey, -1) != head(curkey, -1))
      bodymat[disp, kcol] <- kcolvec[disp]
    }

    nonkeycols <- setdiff(names(listing), keycols)
    if (length(nonkeycols) > 0) {
      for (nonk in nonkeycols) {
        vec <- listing[[nonk]]
        vec <- vapply(vec, format_value, "", format = obj_format(vec), na_str = obj_na_str(vec))
        bodymat[, nonk] <- vec
      }
    }


    fullmat <- rbind(
      var_labels(listing, fill = TRUE),
      bodymat
    )

    colaligns <- rbind(
      rep("center", length(cols)),
      matrix(sapply(listing, obj_align),
        ncol = length(cols),
        nrow = nrow(fullmat) - 1,
        byrow = TRUE
      )
    )

    MatrixPrintForm(
      strings = fullmat,
      spans = matrix(1,
        nrow = nrow(fullmat),
        ncol = ncol(fullmat)
      ),
      ref_fnotes = list(),
      aligns = colaligns,
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



#' @rdname listings
#'
#' @param name character(1). Name of the existing or new column to be
#'   displayed when the listing is rendered.
#' @param fun function or NULL. A function which accepts \code{df} and
#'   returns the vector for a new column, which is added to \code{df} as
#'   \code{name}, or NULL if marking an existing column as
#'   a listing column.
#' @inheritParams formatters::fmt_config
#'
#' @return `df`, with `name` created (if necessary) and marked for
#'   display during rendering.
#'
#' @export
add_listing_col <- function(df,
                            name,
                            fun = NULL,
                            format = NULL,
                            na_str = "NA",
                            align = "left") {
  if (!is.null(fun)) {
    vec <- with_label(fun(df), name)
  } else if (name %in% names(df)) {
    vec <- df[[name]]
  } else {
    stop(
      "Column '", name, "' not found. name argument must specify an existing column when ",
      "no generating function (fun argument) is specified."
    )
  }

  if (!is.null(format)) {
    obj_format(vec) <- format
  }

  obj_na_str(vec) <- na_str
  obj_align(vec) <- align

  ## this works for both new and existing columns
  df[[name]] <- vec
  df <- add_listing_dispcol(df, name)
  df
}
