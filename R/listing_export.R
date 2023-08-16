#' @importFrom formatters export_as_txt
#'
#' @export
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
formatters::export_as_txt
