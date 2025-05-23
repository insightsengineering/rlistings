setOldClass(c("listing_df", "tbl_df", "tbl", "data.frame"))
setOldClass(c("MatrixPrintForm", "list"))

no_spans_df <- data.frame(
  span_level = numeric(),
  label = character(),
  start = numeric(),
  span = numeric(),
  stringsAsFactors = FALSE
)

#' Create a listing from a `data.frame` or `tibble`
#'
#' @description `r lifecycle::badge("experimental")`
#'
#' Create listings displaying `key_cols` and `disp_cols` to produce a compact and
#' elegant representation of the input `data.frame` or `tibble`.
#'
#' @param df (`data.frame` or `listing_df`)\cr the `data.frame` to be converted to a listing or
#'   `listing_df` to be modified.
#' @param key_cols (`character`)\cr vector of names of columns which should be treated as *key columns*
#'   when rendering the listing. Key columns allow you to group repeat occurrences.
#' @param disp_cols (`character` or `NULL`)\cr vector of names of non-key columns which should be
#'   displayed when the listing is rendered. Defaults to all columns of `df` not named in `key_cols` or
#'   `non_disp_cols`.
#' @param non_disp_cols (`character` or `NULL`)\cr vector of names of non-key columns to be excluded as display
#'   columns. All other non-key columns are treated as display columns. Ignored if `disp_cols` is non-`NULL`.
#' @param sort_cols (`character` or `NULL`)\cr vector of names of columns (in order) which should be used to sort the
#'   listing. Defaults to `key_cols`. If `NULL`, no sorting will be performed.
#' @param unique_rows (`flag`)\cr whether only unique rows should be included in the listing. Defaults to `FALSE`.
#' @param default_formatting (`list`)\cr a named list of default column format configurations to apply when rendering
#'   the listing. Each name-value pair consists of a name corresponding to a data class (or "numeric" for all
#'   unspecified numeric classes) and a value of type `fmt_config` with the format configuration that should be
#'   implemented for columns of that class. If named element "all" is included in the list, this configuration will be
#'   used for all data classes not specified. Objects of type `fmt_config` can take 3 arguments: `format`, `na_str`,
#'   and `align`.
#' @param col_formatting (`list`)\cr a named list of custom column formatting configurations to apply to specific
#'   columns when rendering the listing. Each name-value pair consists of a name corresponding to a column name and a
#'   value of type `fmt_config` with the formatting configuration that should be implemented for that column. Objects
#'   of type `fmt_config` can take 3 arguments: `format`, `na_str`, and `align`. Defaults to `NULL`.
#' @param align_colnames (`flag`)\cr whether the column titles should have the same alignment as their columns. All
#'   titles default to `"center"` alignment if `FALSE` (default). This can be changed with `align_colnames()`.
#' @param add_trailing_sep (`character` or `numeric` or `NULL`)\cr If it is assigned to one or more column names,
#'   a trailing separator will be added between groups with identical values for that column. Numeric option allows
#'   the user to specify in which rows it can be added. Defaults to `NULL`.
#' @param trailing_sep (`character(1)`)\cr The separator to be added between groups. The character will be repeated to
#'   fill the row.
#' @param main_title (`string` or `NULL`)\cr the main title for the listing, or `NULL` (the default).
#' @param subtitles (`character` or `NULL`)\cr a vector of subtitles for the listing, or `NULL` (the default).
#' @param main_footer (`character` or `NULL`)\cr a vector of main footer lines for the listing, or `NULL` (the default).
#' @param prov_footer (`character` or `NULL`)\cr a vector of provenance footer lines for the listing, or `NULL`
#'   (the default). Each string element is placed on a new line.
#' @param split_into_pages_by_var (`character` or `NULL`)\cr the name of a variable for on the listing should be split
#'   into pages, with each page corresponding to one unique value/level of the variable. See
#'   [split_into_pages_by_var()] for more details.
#' @param vec (`string`)\cr name of a column vector from a `listing_df` object to be annotated as a key column.
#' @param spanning_col_labels (`data.frame`)\cr A data.frame with the columns
#'   `span_level`, `label`, `start`, and `span` defining 0 or more levels of
#'   addition spanning (ie grouping) of columns. Defaults to no additional spanning labels.
#'
#' @return A `listing_df` object, sorted by its key columns.
#'
#' @details
#' At its core, a `listing_df` object is a `tbl_df` object with a customized
#' print method  and support for the formatting and pagination machinery provided by
#' the `formatters` package.
#'
#' `listing_df` objects have two 'special' types of columns: key columns and display columns.
#'
#' Key columns act as indexes, which means a number of things in practice.
#'
#' All key columns are also display columns.
#'
#' `listing_df` objects are always sorted by their set of key columns at creation time.
#' Any `listing_df` object which is not sorted by its full set of key columns (e.g.,
#' one whose rows have been reordered explicitly during creation) is invalid and the behavior
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
#' Spanning column labels are displayed centered above the individual labels
#' of the columns they span across. `span_level` 1 is placed directly above
#' the column labels, with higher "span_levels` displayed above it in ascending
#' order.
#'
#' IF spanning column labels are present, a single spanning label cannot span
#' across both key and non-key displayed columns simultaneously due to key
#' columns' repetition after page breaks during horizontal pagination. Attempting
#' to set a spanning column label which does so will result in an error.
#'
#' @note Unlike in the `rtables` sister package, spanning labels here are purely
#' decorative and do not reflect any structure among the columns modeled by
#' `rlistings`. Thus, we cannot, e.g., use pathing to select columns under
#' a certain spanning column label, or restrict horizontal pagination to
#' leave 'groups' of columns implied by a spanning label intact.
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
#' @rdname listings
as_listing <- function(df,
                       key_cols = names(df)[1],
                       disp_cols = NULL,
                       non_disp_cols = NULL,
                       sort_cols = key_cols,
                       unique_rows = FALSE,
                       default_formatting = list(all = fmt_config()),
                       col_formatting = NULL,
                       align_colnames = FALSE,
                       add_trailing_sep = NULL,
                       trailing_sep = " ",
                       main_title = NULL,
                       subtitles = NULL,
                       main_footer = NULL,
                       prov_footer = NULL,
                       split_into_pages_by_var = NULL,
                       spanning_col_labels = no_spans_df) {
  checkmate::assert_multi_class(add_trailing_sep, c("character", "numeric"), null.ok = TRUE)
  checkmate::assert_string(trailing_sep, n.chars = 1)

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

  if (any(sapply(df, inherits, "difftime"))) {
    stop("One or more variables in the dataframe have class 'difftime'. Please convert to factor or character.")
  }

  df <- as_tibble(df)
  varlabs <- var_labels(df, fill = TRUE)
  if (!is.null(sort_cols)) {
    sort_miss <- setdiff(sort_cols, names(df))
    if (length(sort_miss) > 0) {
      stop(
        "The following columns were specified as sorting columns (sort_cols) but are missing from df: ",
        paste0("`", sort_miss, "`", collapse = ", ")
      )
    }
    o <- do.call(order, df[sort_cols])
    if (is.unsorted(o)) {
      if (interactive()) {
        message(paste(
          "sorting incoming data by",
          if (identical(sort_cols, key_cols)) {
            "key columns"
          } else {
            paste0("column", if (length(sort_cols) > 1) "s", " ", paste0("`", sort_cols, "`", collapse = ", "))
          }
        ))
      }
      df <- df[o, ]
    }
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
    warning("rows that only contain NA values have been trimmed")
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

  # Check and set align_colnames
  checkmate::assert_flag(align_colnames)
  align_colnames(df) <- align_colnames

  if (unique_rows) df <- df[!duplicated(df[, cols]), ]

  class(df) <- c("listing_df", class(df))

  ## these all work even when the value is NULL
  main_title(df) <- main_title
  main_footer(df) <- main_footer
  subtitles(df) <- subtitles
  prov_footer(df) <- prov_footer
  listing_dispcols(df) <- cols
  spanning_col_label_df(df) <- spanning_col_labels

  if (!is.null(split_into_pages_by_var)) {
    df <- split_into_pages_by_var(df, split_into_pages_by_var)
  }

  # add trailing separators to the df object
  if (!is.null(add_trailing_sep)) {
    if (class(df)[1] == "list") {
      df <- lapply(
        df, .do_add_trailing_sep,
        add_trailing_sep = add_trailing_sep,
        trailing_sep = trailing_sep
      )
    } else {
      df <- .do_add_trailing_sep(df, add_trailing_sep, trailing_sep)
    }
  }

  df
}

# Helper function to add trailing separators to the dataframe
.do_add_trailing_sep <- function(df_tmp, add_trailing_sep, trailing_sep) {
  if (is.character(add_trailing_sep)) {
    if (!all(add_trailing_sep %in% names(df_tmp))) {
      stop(
        "The column specified in `add_trailing_sep` does not exist in the dataframe."
      )
    }
    row_ind_for_trail_sep <- apply(
      apply(as.data.frame(df_tmp)[, add_trailing_sep, drop = FALSE], 2, function(col_i) {
        diff(as.numeric(as.factor(col_i)))
      }),
      1, function(row_i) any(row_i != 0)
    ) %>%
      which()
    listing_trailing_sep(df_tmp) <- list(
      "var_trailing_sep" = add_trailing_sep,
      "where_trailing_sep" = row_ind_for_trail_sep,
      "what_to_separe" = trailing_sep
    )
  } else if (is.numeric(add_trailing_sep)) {
    if (any(!add_trailing_sep %in% seq_len(nrow(df_tmp)))) {
      stop(
        "The row indices specified in `add_trailing_sep` are not valid."
      )
    }
    listing_trailing_sep(df_tmp) <- list(
      "var_trailing_sep" = NULL, # If numeric only
      "where_trailing_sep" = add_trailing_sep,
      "what_to_separe" = trailing_sep
    )
  }

  df_tmp
}

#' @export
#' @rdname listings
spanning_col_label_df <- function(df) {
  ret <- attr(df, "colspan_label_df")
  if (is.null(ret)) {
    ret <- no_spans_df
  }
  ret
}

#' @export
#' @rdname listings
`spanning_col_label_df<-` <- function(df, value) {
  if (is.null(value))
    value <- no_spans_df

  checkmate::assert_data_frame(value, min.cols = 4, max.cols = 4, col.names = "named")
  checkmate::assert_set_equal(names(value), c("span_level", "label", "start", "span"))
  if (NROW(value)) {
    ## can't have spanning labels that span across both key and non-key cols
    ## because then what would we do after horizontal pagination???
    ## not clear people should *really* be horizontally paginatting listings
    ## but we support it so here we are...

    nkeycols <- length(get_keycols(df))
    badrow_lgl <- nzchar(value$label) &
      value$start <= nkeycols &
      value$start + value$span - 1 > nkeycols
    if (any(badrow_lgl)) {
      badrow <- value[which(badrow_lgl)[1], ]
      stop(
        "A spanning column label cannot span across both key and non-key displayed columns of a listing.\n",
        "First issue - span_level: ", badrow$span_level,
        " label: ", badrow$label,
        " start: ", badrow$start,
        "cols spanned: ", badrow$span,
        " key columns: ", nkeycols
      )
    }
  }
  attr(df, "colspan_label_df") <- value
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

#' @inherit formatters::matrix_form
#' @param indent_rownames (`flag`)\cr silently ignored, as listings do not have row names
#'   nor indenting structure.
#' @param expand_newlines (`flag`)\cr this should always be `TRUE` for listings. We keep it
#'   for debugging reasons.
#'
#' @return a [formatters::MatrixPrintForm] object.
#'
#' @seealso [formatters::matrix_form()]
#'
#' @examples
#' lsting <- as_listing(mtcars)
#' mf <- matrix_form(lsting)
#'
#' @export
setMethod(
  "matrix_form", "listing_df",
  rix_form <- function(obj,
                       indent_rownames = FALSE,
                       expand_newlines = TRUE,
                       fontspec = font_spec,
                       col_gap = 3L,
                       round_type = c("iec", "sas")) {
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
      kcolvec <- vapply(kcolvec, format_value, "",
        format = obj_format(kcolvec),
        na_str = obj_na_str(kcolvec),
        round_type = round_type
      )
      curkey <- paste0(curkey, kcolvec)
      disp <- c(TRUE, tail(curkey, -1) != head(curkey, -1))
      bodymat[disp, kcol] <- kcolvec[disp]
    }

    nonkeycols <- setdiff(names(listing), keycols)
    if (length(nonkeycols) > 0) {
      for (nonk in nonkeycols) {
        vec <- listing[[nonk]]
        vec <- vapply(vec, format_value, "",
          format = obj_format(vec),
          na_str = obj_na_str(vec),
          round_type = round_type
        )
        bodymat[, nonk] <- vec
      }
    }

    fullmat <- rbind(
      var_labels(listing, fill = TRUE),
      bodymat
    )

    col_alignment_values <- sapply(listing, obj_align)
    colnames_align <- if (isFALSE(align_colnames(obj))) {
      rep("center", length(cols))
    } else {
      col_alignment_values
    }
    colaligns <- rbind(
      unname(colnames_align),
      matrix(col_alignment_values,
        ncol = length(cols),
        nrow = nrow(fullmat) - 1,
        byrow = TRUE
      )
    )

    if (any(grepl("([{}])", fullmat))) {
      stop(
        "Labels cannot contain { or } due to their use for indicating referential footnotes.\n",
        "These are not supported at the moment in {rlistings}."
      )
    }

    # trailing sep setting
    row_info <- make_row_df(obj, fontspec = fontspec)
    if (!is.null(listing_trailing_sep(obj))) {
      lts <- listing_trailing_sep(obj)

      # We need to make sure that the trailing separator is not beyond the number of rows (cases like head())
      lts$where_trailing_sep <- lts$where_trailing_sep[lts$where_trailing_sep <= nrow(row_info)]
      row_info$trailing_sep[lts$where_trailing_sep] <- lts$what_to_separe
    }

    span_hdr <- make_span_hdr_mats(spanning_col_label_df(obj), length(listing_dispcols(obj)))
    span_hdr_mat <- span_hdr$strings
    span_hdr_spans <- span_hdr$spans

    MatrixPrintForm(
      strings = rbind(
        span_hdr_mat,
        fullmat
      ),
      spans = rbind(
        span_hdr_spans,
        matrix(1,
          nrow = nrow(fullmat),
          ncol = ncol(fullmat)
        )
      ),
      ref_fnotes = list(),
      aligns = rbind(
        matrix("center", nrow = NROW(span_hdr_mat), ncol = ncol(fullmat)),
        colaligns
      ),
      formats = matrix(1,
        nrow = nrow(fullmat) + NROW(span_hdr_mat),
        ncol = ncol(fullmat)
      ),
      listing_keycols = keycols, # It is always something
      row_info = row_info,
      nlines_header = 1 + nrow(span_hdr_mat),
      nrow_header = 1 + nrow(span_hdr_mat),
      has_topleft = FALSE,
      has_rowlabs = FALSE,
      expand_newlines = expand_newlines,
      main_title = main_title(obj),
      subtitles = subtitles(obj),
      page_titles = page_titles(obj),
      main_footer = main_footer(obj),
      prov_footer = prov_footer(obj),
      col_gap = col_gap,
      fontspec = fontspec,
      rep_cols = length(keycols)
    )
  }
)

make_span_hdr_mats <- function(spandf, ncol) {
  if (NROW(spandf) == 0) {
    return(list(
      strings = matrix("", ncol = ncol, nrow = 0),
      spans = matrix(1, ncol = ncol, nrow = 0)
    ))
  }

  spldf <- split(spandf, spandf$span_level)
  ## "span_level" 1 should be directly above col lables, ie last
  res_mats <- rev(lapply(spldf, handle_one_lblspan_row, ncol = ncol))
  list(
    strings = do.call(
      rbind,
      lapply(seq_along(res_mats), function(i) res_mats[[i]]$strings)
    ),
    spans = do.call(
      rbind,
      lapply(seq_along(res_mats), function(i) res_mats[[i]]$spans)
    )
  )
}

handle_one_lblspan_row <- function(df, ncol) {
  strings <- matrix("", nrow = 1, ncol = ncol)
  spans <- matrix(1, nrow = 1, ncol = ncol)
  for (i in seq_len(nrow(df))) {
    spanlen <- df[i, "span", drop = TRUE]
    spaninds <- seq(df[i, "start", drop = TRUE], length.out = spanlen)
    strings[1, spaninds] <- df[i, "label", drop = TRUE]
    spans[1, spaninds] <- spanlen
  }
  list(strings = strings, spans = spans)
}

#' @export
#' @rdname listings
listing_dispcols <- function(df) attr(df, "listing_dispcols") %||% character()

#' @param new (`character`)\cr vector of names of columns to be added to
#'   the set of display columns.
#'
#' @export
#' @rdname listings
add_listing_dispcol <- function(df, new) {
  listing_dispcols(df) <- c(listing_dispcols(df), new)
  df
}

#' @param value (`string`)\cr new value.
#'
#' @export
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
#' @rdname listings
align_colnames <- function(df) attr(df, "align_colnames") %||% FALSE

#' @param value (`string`)\cr new value.
#'
#' @export
#' @rdname listings
`align_colnames<-` <- function(df, value) {
  checkmate::assert_flag(value)
  attr(df, "align_colnames") <- value
  df
}

#' @keywords internal
listing_trailing_sep <- function(df) attr(df, "listing_trailing_sep") %||% NULL

# xxx @param value (`list`)\cr List of names or rows to be separated and their separator.
#'
#' @keywords internal
`listing_trailing_sep<-` <- function(df, value) {
  checkmate::assert_list(value, len = 3, null.ok = TRUE)
  if (is.null(value)) {
    attr(df, "listing_trailing_sep") <- NULL
    return(df)
  }
  checkmate::assert_set_equal(
    names(value),
    c("var_trailing_sep", "where_trailing_sep", "what_to_separe")
  )
  attr(df, "listing_trailing_sep") <- value
  df
}

#' @inheritParams formatters::fmt_config
#' @param name (`string`)\cr name of the existing or new column to be
#'   displayed when the listing is rendered.
#' @param fun (`function` or `NULL`)\cr a function which accepts `df` and
#'   returns the vector for a new column, which is added to `df` as
#'   `name`, or `NULL` if marking an existing column as a listing column.
#'
#' @return `df` with `name` created (if necessary) and marked for
#'   display during rendering.
#'
#' @export
#' @rdname listings
add_listing_col <- function(df,
                            name,
                            fun = NULL,
                            format = NULL,
                            na_str = "NA",
                            align = "left") {
  if (class(df)[1] == "list") {
    out <- lapply(
      df, add_listing_col,
      name = name, fun = fun, format = format, na_str = na_str, align = align
    )
    return(out)
  }

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

#' Split Listing by Values of a Variable
#'
#' @description `r lifecycle::badge("experimental")`
#'
#' Split is performed based on unique values of the given parameter present in the listing.
#' Each listing can only be split by variable once. If this function is applied prior to
#' pagination, parameter values will be separated by page.
#'
#' @param lsting (`listing_df`)\cr the listing to split.
#' @param var (`string`)\cr name of the variable to split on. If the column is a factor,
#'   the resulting list follows the order of the levels.
#' @param page_prefix (`string`)\cr prefix to be appended with the split value (`var` level),
#'   at the end of the subtitles, corresponding to each resulting list element (listing).
#'
#' @return A list of `lsting_df` objects each corresponding to a unique value of `var`.
#'
#' @note This function should only be used after the complete listing has been created. The
#'   listing cannot be modified further after applying this function.
#'
#' @examples
#' dat <- ex_adae[1:20, ]
#'
#' lsting <- as_listing(
#'   dat,
#'   key_cols = c("USUBJID", "AGE"),
#'   disp_cols = "SEX",
#'   main_title = "title",
#'   main_footer = "footer"
#' ) %>%
#'   add_listing_col("BMRKR1", format = "xx.x") %>%
#'   split_into_pages_by_var("SEX")
#'
#' lsting
#'
#' @export
split_into_pages_by_var <- function(lsting, var, page_prefix = var) {
  checkmate::assert_class(lsting, "listing_df")
  checkmate::assert_choice(var, names(lsting))

  # Pre-processing in case of factor variable
  levels_or_vals <- if (is.factor(lsting[[var]])) {
    lvls <- levels(lsting[[var]])
    lvls[lvls %in% unique(lsting[[var]])] # Filter out missing values
  } else {
    unique(lsting[[var]])
  }

  # Main list creator (filters rows by var)
  lsting_by_var <- list()
  for (lvl in levels_or_vals) {
    var_desc <- paste0(page_prefix, ": ", lvl)
    lsting_by_var[[lvl]] <- lsting[lsting[[var]] == lvl, ]
    subtitles(lsting_by_var[[lvl]]) <- c(subtitles(lsting), var_desc)
    spanning_col_label_df(lsting_by_var[[lvl]]) <- spanning_col_label_df(lsting)
  }

  # Correction for cases with trailing separators
  if (!is.null(listing_trailing_sep(lsting))) {
    trailing_sep_directives <- listing_trailing_sep(lsting)
    if (is.null(trailing_sep_directives$var_trailing_sep)) {
      stop(
        "Current lsting did have add_trailing_sep directives with numeric indexes. ",
        "This is not supported for split_into_pages_by_var. Please use the <var> method."
      )
    }
    add_trailing_sep <- trailing_sep_directives$var_trailing_sep
    trailing_sep <- trailing_sep_directives$trailing_sep
    lsting_by_var <- lapply(lsting_by_var, .do_add_trailing_sep, add_trailing_sep, trailing_sep)
  }

  lsting_by_var
}
