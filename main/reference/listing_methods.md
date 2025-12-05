# Methods for `listing_df` objects

See core documentation in
[formatters::formatters-package](https://insightsengineering.github.io/formatters/latest-tag/reference/formatters-package.html)
for descriptions of these functions.

## Usage

``` r
# S3 method for class 'listing_df'
print(
  x,
  widths = NULL,
  tf_wrap = FALSE,
  max_width = NULL,
  fontspec = NULL,
  col_gap = 3L,
  round_type = obj_round_type(x),
  ...
)

# S4 method for class 'listing_df'
toString(
  x,
  widths = NULL,
  fontspec = NULL,
  col_gap = 3L,
  round_type = obj_round_type(x),
  ...
)

# S4 method for class 'listing_df'
x[i, j, drop = FALSE]

# S4 method for class 'listing_df'
main_title(obj)

# S4 method for class 'listing_df'
subtitles(obj)

# S4 method for class 'listing_df'
main_footer(obj)

# S4 method for class 'listing_df'
prov_footer(obj)

# S4 method for class 'listing_df'
main_title(obj) <- value

# S4 method for class 'listing_df'
subtitles(obj) <- value

# S4 method for class 'listing_df'
main_footer(obj) <- value

# S4 method for class 'listing_df'
prov_footer(obj) <- value

# S4 method for class 'listing_df'
num_rep_cols(obj)

# S4 method for class 'listing_df'
obj_round_type(obj)

# S4 method for class 'listing_df'
obj_round_type(obj) <- value
```

## Arguments

- x:

  (`listing_df`)  
  the listing.

- widths:

  (`numeric` or `NULL`)  
  Proposed widths for the columns of `x`. The expected length of this
  numeric vector can be retrieved with `ncol(x) + 1` as the column of
  row names must also be considered.

- tf_wrap:

  (`flag`)  
  whether the text for title, subtitles, and footnotes should be
  wrapped.

- max_width:

  (`integer(1)`, `string` or `NULL`)  
  width that title and footer (including footnotes) materials should be
  word-wrapped to. If `NULL`, it is set to the current print width of
  the session (`getOption("width")`). If set to `"auto"`, the width of
  the table (plus any table inset) is used. Parameter is ignored if
  `tf_wrap = FALSE`.

- fontspec:

  (`font_spec`)  
  a font_spec object specifying the font information to use for
  calculating string widths and heights, as returned by
  [`font_spec()`](https://insightsengineering.github.io/formatters/latest-tag/reference/font_spec.html).

- col_gap:

  (`numeric(1)`)  
  space (in characters) between columns.

- round_type:

  (`string`)  
  The type of rounding to perform. Allowed values: (`"iec"`, `"iec_mod"`
  or `"sas"`) See
  [`round_fmt()`](https://insightsengineering.github.io/formatters/latest-tag/reference/round_fmt.html)
  for details.

- ...:

  additional parameters passed to
  [`formatters::toString()`](https://insightsengineering.github.io/formatters/latest-tag/reference/tostring.html).

- i:

  (`any`)  
  object passed to base `[` methods.

- j:

  (`any`)  
  object passed to base `[` methods.

- drop:

  relevant for matrices and arrays. If `TRUE` the result is coerced to
  the lowest possible dimension (see the examples). This only works for
  extracting elements, not for the replacement. See
  [`drop`](https://rdrr.io/r/base/drop.html) for further details.

- obj:

  (`listing_df`)  
  the listing.

- value:

  typically an array-like R object of a similar class as `x`.

## Value

- Accessor methods return the value of the aspect of `obj`.

- Setter methods return `obj` with the relevant element of the listing
  updated.

## Examples

``` r
lsting <- as_listing(mtcars)
main_title(lsting) <- "Hi there"

main_title(lsting)
#> [1] "Hi there"
```
