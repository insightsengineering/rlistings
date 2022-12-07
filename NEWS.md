# rlistings 0.1.1.9013

### Enhancements
 * Corrected default behavior for `key_cols`. 

### Fixes
 * `matrix_form(lsting, TRUE)` is no longer an error, now silently has the same behavior as 
   `matrix_form(lsting, FALSE)`

### Enhancements
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
