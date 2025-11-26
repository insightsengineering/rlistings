# Make pagination data frame for a listing

Make pagination data frame for a listing

## Usage

``` r
# S4 method for class 'listing_df'
make_row_df(
  tt,
  colwidths = NULL,
  visible_only = TRUE,
  rownum = 0,
  indent = 0L,
  path = character(),
  incontent = FALSE,
  repr_ext = 0L,
  repr_inds = integer(),
  sibpos = NA_integer_,
  nsibs = NA_integer_,
  fontspec = dflt_courier,
  round_type = c("iec", "sas")
)
```

## Arguments

- tt:

  (`listing_df`)  
  the listing to be rendered.

- colwidths:

  (`numeric`)  
  internal detail, do not set manually.

- visible_only:

  (`flag`)  
  ignored, as listings do not have non-visible structural elements.

- rownum:

  (`numeric(1)`)  
  internal detail, do not set manually.

- indent:

  (`integer(1)`)  
  internal detail, do not set manually.

- path:

  (`character`)  
  path to the (sub)table represented by `tt`. Defaults to
  [`character()`](https://rdrr.io/r/base/character.html).

- incontent:

  (`flag`)  
  internal detail, do not set manually.

- repr_ext:

  (`integer(1)`)  
  internal detail, do not set manually.

- repr_inds:

  (`integer`)  
  internal detail, do not set manually.

- sibpos:

  (`integer(1)`)  
  internal detail, do not set manually.

- nsibs:

  (`integer(1)`)  
  internal detail, do not set manually.

- fontspec:

  (`font_spec`)  
  a font_spec object specifying the font information to use for
  calculating string widths and heights, as returned by
  [`font_spec()`](https://insightsengineering.github.io/formatters/latest-tag/reference/font_spec.html).

- round_type:

  (`"iec"` or `"sas"`)  
  the type of rounding to perform. iec, the default, peforms rounding
  compliant with IEC 60559 (see details), while sas performs
  nearest-value rounding consistent with rounding within SAS.

## Value

a `data.frame` with pagination information.

## See also

[`formatters::make_row_df()`](https://insightsengineering.github.io/formatters/latest-tag/reference/make_row_df.html)

## Examples

``` r
lsting <- as_listing(mtcars)
mf <- matrix_form(lsting)
```
