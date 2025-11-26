# Split Listing by Values of a Variable

**\[experimental\]**

Split is performed based on unique values of the given parameter present
in the listing. Each listing can only be split by variable once. If this
function is applied prior to pagination, parameter values will be
separated by page.

## Usage

``` r
split_into_pages_by_var(lsting, var, page_prefix = var)
```

## Arguments

- lsting:

  (`listing_df`)  
  the listing to split.

- var:

  (`string`)  
  name of the variable to split on. If the column is a factor, the
  resulting list follows the order of the levels.

- page_prefix:

  (`string`)  
  prefix to be appended with the split value (`var` level), at the end
  of the subtitles, corresponding to each resulting list element
  (listing).

## Value

A list of `lsting_df` objects each corresponding to a unique value of
`var`.

## Note

This function should only be used after the complete listing has been
created. The listing cannot be modified further after applying this
function.

## Examples

``` r
dat <- ex_adae[1:20, ]

lsting <- as_listing(
  dat,
  key_cols = c("USUBJID", "AGE"),
  disp_cols = "SEX",
  main_title = "title",
  main_footer = "footer"
) %>%
  add_listing_col("BMRKR1", format = "xx.x") %>%
  split_into_pages_by_var("SEX")

lsting
#> $F
#> title
#> SEX: F
#> 
#> ———————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Age   Sex   Continous Level Biomarker 1
#> ———————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-141      35     F    7.5                        
#>                                    F    7.5                        
#>                                    F    7.5                        
#>                                    F    7.5                        
#>                                    F    7.5                        
#>                                    F    7.5                        
#> ———————————————————————————————————————————————————————————————————
#> 
#> footer
#> 
#> $M
#> title
#> SEX: M
#> 
#> ———————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Age   Sex   Continous Level Biomarker 1
#> ———————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134      47     M    6.5                        
#>                                    M    6.5                        
#>                                    M    6.5                        
#>                                    M    6.5                        
#>   AB12345-BRA-1-id-236      32     M    7.7                        
#>                                    M    7.7                        
#>                                    M    7.7                        
#>   AB12345-BRA-1-id-265      25     M    10.3                       
#>                                    M    10.3                       
#>                                    M    10.3                       
#>                                    M    10.3                       
#>    AB12345-BRA-1-id-42      36     M    2.3                        
#>                                    M    2.3                        
#>                                    M    2.3                        
#> ———————————————————————————————————————————————————————————————————
#> 
#> footer
#> 
```
