# Utilities for formatting a listing column

For `vec_nlines`, calculate the number of lines each element of a column
vector will take to render. For `format_colvector`,

## Usage

``` r
format_colvector(df, colnm, colvec = df[[colnm]], round_type = c("iec", "sas"))

vec_nlines(
  vec,
  max_width = NULL,
  fontspec = dflt_courier,
  round_type = c("iec", "sas")
)

# S4 method for class 'ANY'
vec_nlines(
  vec,
  max_width = NULL,
  fontspec = dflt_courier,
  round_type = c("iec", "sas")
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
