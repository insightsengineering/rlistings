## rlistings 0.2.5.9002
* Fixed bug in pagination preventing key column values to appear in paginated listings when `export_as_txt` was used.
* Added tests to cover for `export_as_txt` outputs.
* Integrated support for newline characters.

## rlistings 0.2.5
 * Fixed bug in `as_listing` preventing custom formatting from being applied to key columns.
 * Updated `matrix_form` to allow `NA` values in key columns.
 * Updated `as_listing` to trim any rows containing only NA values and print an informative message.

## rlistings 0.2.4
 * Added `num_rep_cols` method for listings. Resolves error with key column repetition during pagination .
 * Fixed a bug when exporting a degenerative list, which is a data frame of a single row and a single column.
 * Specified minimal version of package dependencies.

## rlistings 0.2.3
 * Added new arguments `default_formatting` and `col_formatting` to `as_listing` to specify column format configurations.
 * Added new argument `unique_rows` to `as_listing` to remove duplicate rows from listing.
 * Default alignment is now `left` across all types. Reinstate `NA` as default.
 * Introduced `testthat` edition 3.

## rlistings 0.2.2
 * Moved `export_as_txt` to `formatters`. Added to reexports. 

## rlistings 0.2.1

### Enhancements
 * Extend page-size machinery in pagination by allowing the page specification (`page_type`, `pg_width`,
   `pg_height`, `font_family`, `font_size`) to be transformed into `lpp` (lines per page) and `cpp` (characters per page).
 * New function `export_as_txt` to support output saved in plain text.
 * `cols` argument renamed to `disp_cols` in the function `as_listing`.
 * New argument `non_disp_cols` in the function `as_listing`.
 * `disp_cols` argument now defaults to all columns not included in `key_cols`.
 * Columns named in `key_cols` no longer need to also be listed in `disp_cols`.
 * Pagination is now calculated based on formatted cells values (including wrapping) rather than raw cell contents.
 * Key columns are now guaranteed to be the leftmost columns (both stored and displayed) in `listing_df` objects.
 * Added tests for `paginate_listing`.
 * Added development cycle with `lifecycle` support, and experimental badges.
 * Added initial installments for `checkmate` assertion support.
 * Added a main package page with all the relevant imports and descriptions (`rlistings-package`).
 * Added "Get Started" vignette and updated README.
 * Added `markdown` support to all functions.

### Bug fixes
 * `matrix_form(lsting, TRUE)` no longer throws an error.

## rlistings 0.1.1
 * Add title, subtitle, and (main and prov) footer support.
 * Now depends on `dplyr` instead of `magrittr` to hopefully avoid `var_labels` droppage issues.
 * `paginate_listing` now supports pagination in both directions.

## rlistings 0.1.0
 * Initial experimental rlistings API. Everything subject to change.
