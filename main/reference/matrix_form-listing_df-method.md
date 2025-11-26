# Transform `rtable` to a list of matrices which can be used for outputting

Although `rtable`s are represented as a tree data structure when
outputting the table to ASCII or HTML, it is useful to map the `rtable`
to an in-between state with the formatted cells in a matrix form.

## Usage

``` r
# S4 method for class 'listing_df'
matrix_form(
  obj,
  indent_rownames = FALSE,
  expand_newlines = TRUE,
  fontspec = font_spec,
  col_gap = 3L,
  round_type = c("iec", "sas")
)
```

## Arguments

- obj:

  (`ANY`)  
  object to be transformed into a ready-to-render form (a
  [`MatrixPrintForm`](https://insightsengineering.github.io/formatters/latest-tag/reference/MatrixPrintForm.html)
  object).

- indent_rownames:

  (`flag`)  
  silently ignored, as listings do not have row names nor indenting
  structure.

- expand_newlines:

  (`flag`)  
  this should always be `TRUE` for listings. We keep it for debugging
  reasons.

- fontspec:

  (`font_spec`)  
  a font_spec object specifying the font information to use for
  calculating string widths and heights, as returned by
  [`font_spec()`](https://insightsengineering.github.io/formatters/latest-tag/reference/font_spec.html).

- col_gap:

  (`numeric(1)`)  
  the gap to be assumed between columns, in number of spaces with font
  specified by `fontspec`.

- round_type:

  (`"iec"` or `"sas"`)  
  the type of rounding to perform. iec, the default, peforms rounding
  compliant with IEC 60559 (see details), while sas performs
  nearest-value rounding consistent with rounding within SAS.

## Value

a
[formatters::MatrixPrintForm](https://insightsengineering.github.io/formatters/latest-tag/reference/MatrixPrintForm.html)
object.

## See also

[`formatters::matrix_form()`](https://insightsengineering.github.io/formatters/latest-tag/reference/matrix_form.html)

## Examples

``` r
lsting <- as_listing(mtcars)
mf <- matrix_form(lsting)
```
