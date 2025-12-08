# Paginate listings

**\[experimental\]**

Pagination of a listing. This can be vertical for long listings with
many rows and/or horizontal if there are many columns. This function is
a wrapper of
[`formatters::paginate_to_mpfs()`](https://insightsengineering.github.io/formatters/latest-tag/reference/paginate_indices.html)
and it is mainly meant for exploration and testing.

## Usage

``` r
paginate_listing(
  lsting,
  page_type = "letter",
  font_family = "Courier",
  font_size = 8,
  lineheight = 1,
  landscape = FALSE,
  pg_width = NULL,
  pg_height = NULL,
  margins = c(top = 0.5, bottom = 0.5, left = 0.75, right = 0.75),
  lpp = NA_integer_,
  cpp = NA_integer_,
  colwidths = NULL,
  tf_wrap = !is.null(max_width),
  rep_cols = NULL,
  max_width = NULL,
  col_gap = 3,
  fontspec = font_spec(font_family, font_size, lineheight),
  verbose = FALSE,
  print_pages = TRUE
)
```

## Arguments

- lsting:

  (`listing_df` or `list`)  
  the listing or list of listings to paginate.

- page_type:

  (`string`)  
  name of a page type. See
  [`page_types`](https://insightsengineering.github.io/formatters/latest-tag/reference/page_types.html).
  Ignored when `pg_width` and `pg_height` are set directly.

- font_family:

  (`string`)  
  name of a font family. An error will be thrown if the family named is
  not monospaced. Defaults to `"Courier"`.

- font_size:

  (`numeric(1)`)  
  font size. Defaults to `12`.

- lineheight:

  (`numeric(1)`)  
  line height. Defaults to `1`.

- landscape:

  (`flag`)  
  whether the dimensions of `page_type` should be inverted for landscape
  orientation. Defaults to `FALSE`, ignored when `pg_width` and
  `pg_height` are set directly.

- pg_width:

  (`numeric(1)`)  
  page width in inches.

- pg_height:

  (`numeric(1)`)  
  page height in inches.

- margins:

  (`numeric(4)`)  
  named numeric vector containing `"bottom"`, `"left"`, `"top"`, and
  `"right"` margins in inches. Defaults to `.5` inches for both vertical
  margins and `.75` for both horizontal margins.

- lpp:

  (`numeric(1)` or `NULL`)  
  number of rows/lines (excluding titles and footers) to include per
  page. Standard is `70` while `NULL` disables vertical pagination.

- cpp:

  (`numeric(1)` or `NULL`)  
  width (in characters) of the pages for horizontal pagination. `NULL`
  (the default) indicates no horizontal pagination should be done.

- colwidths:

  (`numeric`)  
  vector of column widths (in characters) for use in vertical
  pagination.

- tf_wrap:

  (`flag`)  
  whether the text for title, subtitles, and footnotes should be
  wrapped.

- rep_cols:

  (`numeric(1)`)  
  number of *columns* (not including row labels) to be repeated on every
  page. Defaults to 0.

- max_width:

  (`integer(1)`, `string` or `NULL`)  
  width that title and footer (including footnotes) materials should be
  word-wrapped to. If `NULL`, it is set to the current print width of
  the session (`getOption("width")`). If set to `"auto"`, the width of
  the table (plus any table inset) is used. Parameter is ignored if
  `tf_wrap = FALSE`.

- col_gap:

  (`numeric(1)`)  
  width of gap between columns, in same units as extent in `pagdf`
  (spaces under a particular font specification).

- fontspec:

  (`font_spec`)  
  a font_spec object specifying the font information to use for
  calculating string widths and heights, as returned by
  [`font_spec()`](https://insightsengineering.github.io/formatters/latest-tag/reference/font_spec.html).

- verbose:

  (`flag`)  
  whether additional informative messages about the search for
  pagination breaks should be shown. Defaults to `FALSE`.

- print_pages:

  (`flag`)  
  whether the paginated listing should be printed to the console
  (`cat(toString(x))`).

## Value

A list of `listing_df` objects where each list element corresponds to a
separate page.

## Examples

``` r
dat <- ex_adae
lsting <- as_listing(dat[1:25, ], disp_cols = c("USUBJID", "AESOC", "RACE", "AETOXGR", "BMRKR1"))
mat <- matrix_form(lsting)
cat(toString(mat))
#> Study Identifier   Unique Subject Identifier   Primary System Organ Class             Race              Analysis Toxicity Grade   Continous Level Biomarker 1
#> —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>     AB12345          AB12345-BRA-1-id-134                 cl B                        WHITE                        3                   6.46299057842479      
#>                      AB12345-BRA-1-id-134                 cl D                        WHITE                        3                   6.46299057842479      
#>                      AB12345-BRA-1-id-134                 cl A                        WHITE                        2                   6.46299057842479      
#>                      AB12345-BRA-1-id-134                 cl A                        WHITE                        2                   6.46299057842479      
#>                      AB12345-BRA-1-id-141                 cl B                        WHITE                        3                   7.51607612428241      
#>                      AB12345-BRA-1-id-141                 cl D                        WHITE                        1                   7.51607612428241      
#>                      AB12345-BRA-1-id-141                 cl A                        WHITE                        1                   7.51607612428241      
#>                      AB12345-BRA-1-id-141                 cl A                        WHITE                        2                   7.51607612428241      
#>                      AB12345-BRA-1-id-141                 cl A                        WHITE                        1                   7.51607612428241      
#>                      AB12345-BRA-1-id-141                 cl D                        WHITE                        5                   7.51607612428241      
#>                      AB12345-BRA-1-id-236                 cl B              BLACK OR AFRICAN AMERICAN              5                   7.66300121077566      
#>                      AB12345-BRA-1-id-236                 cl B              BLACK OR AFRICAN AMERICAN              5                   7.66300121077566      
#>                      AB12345-BRA-1-id-236                 cl B              BLACK OR AFRICAN AMERICAN              5                   7.66300121077566      
#>                      AB12345-BRA-1-id-265                 cl C                        WHITE                        2                    10.323346349886      
#>                      AB12345-BRA-1-id-265                 cl D                        WHITE                        3                    10.323346349886      
#>                      AB12345-BRA-1-id-265                 cl D                        WHITE                        5                    10.323346349886      
#>                      AB12345-BRA-1-id-265                 cl C                        WHITE                        4                    10.323346349886      
#>                       AB12345-BRA-1-id-42                 cl C              BLACK OR AFRICAN AMERICAN              2                   2.26753940777848      
#>                       AB12345-BRA-1-id-42                 cl D              BLACK OR AFRICAN AMERICAN              5                   2.26753940777848      
#>                       AB12345-BRA-1-id-42                 cl C              BLACK OR AFRICAN AMERICAN              2                   2.26753940777848      
#>                       AB12345-BRA-1-id-42                 cl A              BLACK OR AFRICAN AMERICAN              2                   2.26753940777848      
#>                       AB12345-BRA-1-id-42                 cl B              BLACK OR AFRICAN AMERICAN              1                   2.26753940777848      
#>                       AB12345-BRA-1-id-42                 cl A              BLACK OR AFRICAN AMERICAN              2                   2.26753940777848      
#>                       AB12345-BRA-1-id-42                 cl B              BLACK OR AFRICAN AMERICAN              5                   2.26753940777848      
#>                       AB12345-BRA-1-id-42                 cl A              BLACK OR AFRICAN AMERICAN              2                   2.26753940777848      

paginate_listing(lsting, lpp = 10)
#> --- Page 1/8 ---
#> Study Identifier   Unique Subject Identifier   Primary System Organ Class             Race           
#> —————————————————————————————————————————————————————————————————————————————————————————————————————
#>     AB12345          AB12345-BRA-1-id-134                 cl B                        WHITE          
#>                      AB12345-BRA-1-id-134                 cl D                        WHITE          
#>                      AB12345-BRA-1-id-134                 cl A                        WHITE          
#>                      AB12345-BRA-1-id-134                 cl A                        WHITE          
#>                      AB12345-BRA-1-id-141                 cl B                        WHITE          
#>                      AB12345-BRA-1-id-141                 cl D                        WHITE          
#>                      AB12345-BRA-1-id-141                 cl A                        WHITE          
#>                      AB12345-BRA-1-id-141                 cl A                        WHITE          
#> 
#> --- Page 2/8 ---
#> Study Identifier   Analysis Toxicity Grade   Continous Level Biomarker 1
#> ————————————————————————————————————————————————————————————————————————
#>     AB12345                   3                   6.46299057842479      
#>                               3                   6.46299057842479      
#>                               2                   6.46299057842479      
#>                               2                   6.46299057842479      
#>                               3                   7.51607612428241      
#>                               1                   7.51607612428241      
#>                               1                   7.51607612428241      
#>                               2                   7.51607612428241      
#> 
#> --- Page 3/8 ---
#> Study Identifier   Unique Subject Identifier   Primary System Organ Class             Race           
#> —————————————————————————————————————————————————————————————————————————————————————————————————————
#>     AB12345          AB12345-BRA-1-id-141                 cl A                        WHITE          
#>                      AB12345-BRA-1-id-141                 cl D                        WHITE          
#>                      AB12345-BRA-1-id-236                 cl B              BLACK OR AFRICAN AMERICAN
#>                      AB12345-BRA-1-id-236                 cl B              BLACK OR AFRICAN AMERICAN
#>                      AB12345-BRA-1-id-236                 cl B              BLACK OR AFRICAN AMERICAN
#>                      AB12345-BRA-1-id-265                 cl C                        WHITE          
#>                      AB12345-BRA-1-id-265                 cl D                        WHITE          
#>                      AB12345-BRA-1-id-265                 cl D                        WHITE          
#> 
#> --- Page 4/8 ---
#> Study Identifier   Analysis Toxicity Grade   Continous Level Biomarker 1
#> ————————————————————————————————————————————————————————————————————————
#>     AB12345                   1                   7.51607612428241      
#>                               5                   7.51607612428241      
#>                               5                   7.66300121077566      
#>                               5                   7.66300121077566      
#>                               5                   7.66300121077566      
#>                               2                    10.323346349886      
#>                               3                    10.323346349886      
#>                               5                    10.323346349886      
#> 
#> --- Page 5/8 ---
#> Study Identifier   Unique Subject Identifier   Primary System Organ Class             Race           
#> —————————————————————————————————————————————————————————————————————————————————————————————————————
#>     AB12345          AB12345-BRA-1-id-265                 cl C                        WHITE          
#>                       AB12345-BRA-1-id-42                 cl C              BLACK OR AFRICAN AMERICAN
#>                       AB12345-BRA-1-id-42                 cl D              BLACK OR AFRICAN AMERICAN
#>                       AB12345-BRA-1-id-42                 cl C              BLACK OR AFRICAN AMERICAN
#>                       AB12345-BRA-1-id-42                 cl A              BLACK OR AFRICAN AMERICAN
#>                       AB12345-BRA-1-id-42                 cl B              BLACK OR AFRICAN AMERICAN
#>                       AB12345-BRA-1-id-42                 cl A              BLACK OR AFRICAN AMERICAN
#>                       AB12345-BRA-1-id-42                 cl B              BLACK OR AFRICAN AMERICAN
#> 
#> --- Page 6/8 ---
#> Study Identifier   Analysis Toxicity Grade   Continous Level Biomarker 1
#> ————————————————————————————————————————————————————————————————————————
#>     AB12345                   4                    10.323346349886      
#>                               2                   2.26753940777848      
#>                               5                   2.26753940777848      
#>                               2                   2.26753940777848      
#>                               2                   2.26753940777848      
#>                               1                   2.26753940777848      
#>                               2                   2.26753940777848      
#>                               5                   2.26753940777848      
#> 
#> --- Page 7/8 ---
#> Study Identifier   Unique Subject Identifier   Primary System Organ Class             Race           
#> —————————————————————————————————————————————————————————————————————————————————————————————————————
#>     AB12345           AB12345-BRA-1-id-42                 cl A              BLACK OR AFRICAN AMERICAN
#> 
#> --- Page 8/8 ---
#> Study Identifier   Analysis Toxicity Grade   Continous Level Biomarker 1
#> ————————————————————————————————————————————————————————————————————————
#>     AB12345                   2                   2.26753940777848      
#> 

paginate_listing(lsting, cpp = 100, lpp = 40)
#> --- Page 1/2 ---
#> Study Identifier   Unique Subject Identifier   Primary System Organ Class
#> —————————————————————————————————————————————————————————————————————————
#>     AB12345          AB12345-BRA-1-id-134                 cl B           
#>                      AB12345-BRA-1-id-134                 cl D           
#>                      AB12345-BRA-1-id-134                 cl A           
#>                      AB12345-BRA-1-id-134                 cl A           
#>                      AB12345-BRA-1-id-141                 cl B           
#>                      AB12345-BRA-1-id-141                 cl D           
#>                      AB12345-BRA-1-id-141                 cl A           
#>                      AB12345-BRA-1-id-141                 cl A           
#>                      AB12345-BRA-1-id-141                 cl A           
#>                      AB12345-BRA-1-id-141                 cl D           
#>                      AB12345-BRA-1-id-236                 cl B           
#>                      AB12345-BRA-1-id-236                 cl B           
#>                      AB12345-BRA-1-id-236                 cl B           
#>                      AB12345-BRA-1-id-265                 cl C           
#>                      AB12345-BRA-1-id-265                 cl D           
#>                      AB12345-BRA-1-id-265                 cl D           
#>                      AB12345-BRA-1-id-265                 cl C           
#>                       AB12345-BRA-1-id-42                 cl C           
#>                       AB12345-BRA-1-id-42                 cl D           
#>                       AB12345-BRA-1-id-42                 cl C           
#>                       AB12345-BRA-1-id-42                 cl A           
#>                       AB12345-BRA-1-id-42                 cl B           
#>                       AB12345-BRA-1-id-42                 cl A           
#>                       AB12345-BRA-1-id-42                 cl B           
#>                       AB12345-BRA-1-id-42                 cl A           
#> 
#> --- Page 2/2 ---
#> Study Identifier             Race              Analysis Toxicity Grade   Continous Level Biomarker 1
#> ————————————————————————————————————————————————————————————————————————————————————————————————————
#>     AB12345                  WHITE                        3                   6.46299057842479      
#>                              WHITE                        3                   6.46299057842479      
#>                              WHITE                        2                   6.46299057842479      
#>                              WHITE                        2                   6.46299057842479      
#>                              WHITE                        3                   7.51607612428241      
#>                              WHITE                        1                   7.51607612428241      
#>                              WHITE                        1                   7.51607612428241      
#>                              WHITE                        2                   7.51607612428241      
#>                              WHITE                        1                   7.51607612428241      
#>                              WHITE                        5                   7.51607612428241      
#>                    BLACK OR AFRICAN AMERICAN              5                   7.66300121077566      
#>                    BLACK OR AFRICAN AMERICAN              5                   7.66300121077566      
#>                    BLACK OR AFRICAN AMERICAN              5                   7.66300121077566      
#>                              WHITE                        2                    10.323346349886      
#>                              WHITE                        3                    10.323346349886      
#>                              WHITE                        5                    10.323346349886      
#>                              WHITE                        4                    10.323346349886      
#>                    BLACK OR AFRICAN AMERICAN              2                   2.26753940777848      
#>                    BLACK OR AFRICAN AMERICAN              5                   2.26753940777848      
#>                    BLACK OR AFRICAN AMERICAN              2                   2.26753940777848      
#>                    BLACK OR AFRICAN AMERICAN              2                   2.26753940777848      
#>                    BLACK OR AFRICAN AMERICAN              1                   2.26753940777848      
#>                    BLACK OR AFRICAN AMERICAN              2                   2.26753940777848      
#>                    BLACK OR AFRICAN AMERICAN              5                   2.26753940777848      
#>                    BLACK OR AFRICAN AMERICAN              2                   2.26753940777848      
#> 

paginate_listing(lsting, cpp = 80, lpp = 40, verbose = TRUE)
#> Determining lines required for header content: 0 title and 2 table header lines
#> Determining lines required for footer content: 0 lines
#> Lines per page available for tables rows: 38 (original: 40)
#> --------- ROW-WISE: Checking possible pagination for page 1
#> -> Attempting pagination between 1 and 25 row
#>   OK [25 lines]
#> Adjusted characters per page: 80 [original: 80, table inset: 0]
#> ========= COLUMN-WISE: Checking possible pagination for page 1
#> -> Attempting pagination between 1 and 6 column
#>   FAIL: selected 6 columns require 172 chars, while only 80 are available. 
#>         details: [raw: 157 chars (6 cols), rep. cols: 0 chars (0 cols), tot. colgap: 15 chars].
#> -> Attempting pagination between 1 and 5 column
#>   FAIL: selected 5 columns require 139 chars, while only 80 are available. 
#>         details: [raw: 127 chars (5 cols), rep. cols: 0 chars (0 cols), tot. colgap: 12 chars].
#> -> Attempting pagination between 1 and 4 column
#>   FAIL: selected 4 columns require 110 chars, while only 80 are available. 
#>         details: [raw: 101 chars (4 cols), rep. cols: 0 chars (0 cols), tot. colgap: 9 chars].
#> -> Attempting pagination between 1 and 3 column
#>   OK [73 chars]
#> ========= COLUMN-WISE: Checking possible pagination for page 2
#> -> Attempting pagination between 4 and 6 column
#>   FAIL: selected 3 columns require 109 chars, while only 80 are available. 
#>         details: [raw: 84 chars (3 cols), rep. cols: 16 chars (1 cols), tot. colgap: 9 chars].
#> -> Attempting pagination between 4 and 5 column
#>   OK [70 chars]
#> ========= COLUMN-WISE: Checking possible pagination for page 3
#> -> Attempting pagination between 6 and 6 column
#>   OK [46 chars]
#> --- Page 1/3 ---
#> Study Identifier   Unique Subject Identifier   Primary System Organ Class
#> —————————————————————————————————————————————————————————————————————————
#>     AB12345          AB12345-BRA-1-id-134                 cl B           
#>                      AB12345-BRA-1-id-134                 cl D           
#>                      AB12345-BRA-1-id-134                 cl A           
#>                      AB12345-BRA-1-id-134                 cl A           
#>                      AB12345-BRA-1-id-141                 cl B           
#>                      AB12345-BRA-1-id-141                 cl D           
#>                      AB12345-BRA-1-id-141                 cl A           
#>                      AB12345-BRA-1-id-141                 cl A           
#>                      AB12345-BRA-1-id-141                 cl A           
#>                      AB12345-BRA-1-id-141                 cl D           
#>                      AB12345-BRA-1-id-236                 cl B           
#>                      AB12345-BRA-1-id-236                 cl B           
#>                      AB12345-BRA-1-id-236                 cl B           
#>                      AB12345-BRA-1-id-265                 cl C           
#>                      AB12345-BRA-1-id-265                 cl D           
#>                      AB12345-BRA-1-id-265                 cl D           
#>                      AB12345-BRA-1-id-265                 cl C           
#>                       AB12345-BRA-1-id-42                 cl C           
#>                       AB12345-BRA-1-id-42                 cl D           
#>                       AB12345-BRA-1-id-42                 cl C           
#>                       AB12345-BRA-1-id-42                 cl A           
#>                       AB12345-BRA-1-id-42                 cl B           
#>                       AB12345-BRA-1-id-42                 cl A           
#>                       AB12345-BRA-1-id-42                 cl B           
#>                       AB12345-BRA-1-id-42                 cl A           
#> 
#> --- Page 2/3 ---
#> Study Identifier             Race              Analysis Toxicity Grade
#> ——————————————————————————————————————————————————————————————————————
#>     AB12345                  WHITE                        3           
#>                              WHITE                        3           
#>                              WHITE                        2           
#>                              WHITE                        2           
#>                              WHITE                        3           
#>                              WHITE                        1           
#>                              WHITE                        1           
#>                              WHITE                        2           
#>                              WHITE                        1           
#>                              WHITE                        5           
#>                    BLACK OR AFRICAN AMERICAN              5           
#>                    BLACK OR AFRICAN AMERICAN              5           
#>                    BLACK OR AFRICAN AMERICAN              5           
#>                              WHITE                        2           
#>                              WHITE                        3           
#>                              WHITE                        5           
#>                              WHITE                        4           
#>                    BLACK OR AFRICAN AMERICAN              2           
#>                    BLACK OR AFRICAN AMERICAN              5           
#>                    BLACK OR AFRICAN AMERICAN              2           
#>                    BLACK OR AFRICAN AMERICAN              2           
#>                    BLACK OR AFRICAN AMERICAN              1           
#>                    BLACK OR AFRICAN AMERICAN              2           
#>                    BLACK OR AFRICAN AMERICAN              5           
#>                    BLACK OR AFRICAN AMERICAN              2           
#> 
#> --- Page 3/3 ---
#> Study Identifier   Continous Level Biomarker 1
#> ——————————————————————————————————————————————
#>     AB12345             6.46299057842479      
#>                         6.46299057842479      
#>                         6.46299057842479      
#>                         6.46299057842479      
#>                         7.51607612428241      
#>                         7.51607612428241      
#>                         7.51607612428241      
#>                         7.51607612428241      
#>                         7.51607612428241      
#>                         7.51607612428241      
#>                         7.66300121077566      
#>                         7.66300121077566      
#>                         7.66300121077566      
#>                          10.323346349886      
#>                          10.323346349886      
#>                          10.323346349886      
#>                          10.323346349886      
#>                         2.26753940777848      
#>                         2.26753940777848      
#>                         2.26753940777848      
#>                         2.26753940777848      
#>                         2.26753940777848      
#>                         2.26753940777848      
#>                         2.26753940777848      
#>                         2.26753940777848      
#> 
```
