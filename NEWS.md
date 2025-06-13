## rlistings 0.2.12
 * Added parameter `align_colnames` to `as_listings()`, along with post-processing functions `align_colnames()` and `align_colnames()<-`. This flag allows to align colnames as the column content is aligned.
 * `as_listing` now accepts a `spanning_col_labels` argument which can declare decorative spanning labels to appear above the individual column labels when a `listing_df` is rendered. #263 by @gmbecker

## rlistings 0.2.11
 * Added parameter `sort_cols` to `as_listing` to specify columns to sort the listing by. Previously listings were always sorted by key columns.
 * Addition of separators between values in `as_listings(add_trailing_sep = <col_names>)` with determined values `as_listings(trailing_sep = <single_character>)`.
 * Added a vignette with tips for exporting large listings.

## rlistings 0.2.10
 * Added an error message for listings with variables of `difftime` class.
 * Added message when the listing object has zero row.

## rlistings 0.2.9
 * Added `truetype` font support based on new `formatters` api, by @gmbecker.
 * Fixed tests so that paginations based on different fonts and page sizes can be compared, by @gmbecker.
 * `paginate_listing` now accepts `col_gap` argument and passes it down correctly to pagination machinery in `formatters`, by @gmbecker.

## rlistings 0.2.8
 * Added relevant tests for pagination when key columns need to be repeated in each page and when they are all empty.
 * Added relevant tests for new line characters' handling in footnotes and titles.
 * Added a cheatsheet.
 * Added function `split_into_pages_by_var` to split a listing into a list of listings according to values of a given 
   variable. This enables page splits by variable when paginating.
 * Removed defunct function `pag_listing_indices`.
 * Changed title of "Getting Started with rlistings" vignette to "Getting Started".
 * Refactored `paginate_listing` to use directly `paginate_to_mpfs` function from `formatters` package.

## rlistings 0.2.7
 * Applied `styler` and resolved package lint. Changed default indentation from 4 spaces to 2.
 * Fixed bug in `add_listing_col` when both a function and a format are specified.
 * Added a vignette on referential footnotes workaround.
 * Added a vignette on formatting columns.
 * Added a vignette on pagination.

## rlistings 0.2.6
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
