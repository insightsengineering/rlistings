# Utilities for formatting a listing column

For `vec_nlines`, calculate the number of lines each element of a column
vector will take to render. For `format_colvector`,

## Usage

``` r
format_colvector(
  df,
  colnm,
  colvec = df[[colnm]],
  round_type = valid_round_type
)

vec_nlines(
  vec,
  max_width = NULL,
  fontspec = dflt_courier,
  round_type = valid_round_type
)

# S4 method for class 'ANY'
vec_nlines(
  vec,
  max_width = NULL,
  fontspec = dflt_courier,
  round_type = valid_round_type
)
```

## Arguments

- df:

  (`listing_df`)  
  the listing.

- colnm:

  (`string`)  
  column name.

- colvec:

  (`vector`)  
  column values based on `colnm`.

- round_type:

  (`string`)  
  the type of rounding to perform. Allowed values are (`"iec"`
  (default), `"iec_mod"` or `"sas"`).  
  See
  [`formatters::format_value()`](https://insightsengineering.github.io/formatters/latest-tag/reference/format_value.html)
  for details.

- vec:

  (`vector`)  
  a vector.

- max_width:

  (`numeric(1)` or `NULL`)  
  the width to render the column with.

## Value

(`numeric`)  
a vector of the number of lines element-wise that will be needed to
render the elements of `vec` to width `max_width`.
