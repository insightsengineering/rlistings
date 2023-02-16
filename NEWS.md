# rlistings 0.1.1.9016
 * `cols` argument renamed to `disp_cols` in `as_listing`
 * `as_listing` gains `non_disp_cols` argument 
 * `disp_cols` argument now defaults to all columns not included in `key_cols`
 * columns named in `key_cols` no longer need to also be listed in `disp_cols`
 * pagination is now calculated based on formatted cells values (including wrapping) rather than raw cell contents
 * key columns are now guaranteed to be the leftmost columns (both stored and displayed) in `listing_df` objects.
 
### Enhancements
 * `matrix_form(lsting, TRUE)` is no longer an error, now silently has the same behavior as 
   `matrix_form(lsting, FALSE)`
 * Add test for `paginate_listing`.
 * Add development cycle with `lifecycle` support. Add of experimental badges.
 * Now all functions have `markdown` support.
 * Add initial installments for `checkmate` assertion support.
 * Add of main package page with all the relevant imports and descriptions (`rlistings-package`).
 * Add Get Started vignette and update README.
 * Add regression tests.

## rlistings 0.1.1
 * Add title, subtitle, and (main and prov) footer support.
 * Now depends on `dplyr` instead of `magrittr` to hopefully avoid `var_labels` droppage issues.
 * `paginate_listing` now supports pagination in both directions.

## rlistings 0.1.0
 * Initial experimental rlistings API. Everything subject to change.
