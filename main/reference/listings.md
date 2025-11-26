# Create a listing from a `data.frame` or `tibble`

**\[experimental\]**

Create listings displaying `key_cols` and `disp_cols` to produce a
compact and elegant representation of the input `data.frame` or
`tibble`.

## Usage

``` r
as_listing(
  df,
  key_cols = names(df)[1],
  disp_cols = NULL,
  non_disp_cols = NULL,
  sort_cols = key_cols,
  unique_rows = FALSE,
  default_formatting = list(all = fmt_config()),
  col_formatting = NULL,
  align_colnames = FALSE,
  add_trailing_sep = NULL,
  trailing_sep = " ",
  main_title = NULL,
  subtitles = NULL,
  main_footer = NULL,
  prov_footer = NULL,
  split_into_pages_by_var = NULL,
  spanning_col_labels = no_spans_df
)

spanning_col_label_df(df)

spanning_col_label_df(df) <- value

as_keycol(vec)

is_keycol(vec)

get_keycols(df)

listing_dispcols(df)

add_listing_dispcol(df, new)

listing_dispcols(df) <- value

align_colnames(df)

align_colnames(df) <- value

add_listing_col(
  df,
  name,
  fun = NULL,
  format = NULL,
  na_str = "NA",
  align = "left"
)
```

## Arguments

- df:

  (`data.frame` or `listing_df`)  
  the `data.frame` to be converted to a listing or `listing_df` to be
  modified.

- key_cols:

  (`character`)  
  vector of names of columns which should be treated as *key columns*
  when rendering the listing. Key columns allow you to group repeat
  occurrences.

- disp_cols:

  (`character` or `NULL`)  
  vector of names of non-key columns which should be displayed when the
  listing is rendered. Defaults to all columns of `df` not named in
  `key_cols` or `non_disp_cols`.

- non_disp_cols:

  (`character` or `NULL`)  
  vector of names of non-key columns to be excluded as display columns.
  All other non-key columns are treated as display columns. Ignored if
  `disp_cols` is non-`NULL`.

- sort_cols:

  (`character` or `NULL`)  
  vector of names of columns (in order) which should be used to sort the
  listing. Defaults to `key_cols`. If `NULL`, no sorting will be
  performed.

- unique_rows:

  (`flag`)  
  whether only unique rows should be included in the listing. Defaults
  to `FALSE`.

- default_formatting:

  (`list`)  
  a named list of default column format configurations to apply when
  rendering the listing. Each name-value pair consists of a name
  corresponding to a data class (or "numeric" for all unspecified
  numeric classes) and a value of type `fmt_config` with the format
  configuration that should be implemented for columns of that class. If
  named element "all" is included in the list, this configuration will
  be used for all data classes not specified. Objects of type
  `fmt_config` can take 3 arguments: `format`, `na_str`, and `align`.

- col_formatting:

  (`list`)  
  a named list of custom column formatting configurations to apply to
  specific columns when rendering the listing. Each name-value pair
  consists of a name corresponding to a column name and a value of type
  `fmt_config` with the formatting configuration that should be
  implemented for that column. Objects of type `fmt_config` can take 3
  arguments: `format`, `na_str`, and `align`. Defaults to `NULL`.

- align_colnames:

  (`flag`)  
  whether the column titles should have the same alignment as their
  columns. All titles default to `"center"` alignment if `FALSE`
  (default). This can be changed with `align_colnames()`.

- add_trailing_sep:

  (`character` or `numeric` or `NULL`)  
  If it is assigned to one or more column names, a trailing separator
  will be added between groups with identical values for that column.
  Numeric option allows the user to specify in which rows it can be
  added. Defaults to `NULL`.

- trailing_sep:

  (`character(1)`)  
  The separator to be added between groups. The character will be
  repeated to fill the row.

- main_title:

  (`string` or `NULL`)  
  the main title for the listing, or `NULL` (the default).

- subtitles:

  (`character` or `NULL`)  
  a vector of subtitles for the listing, or `NULL` (the default).

- main_footer:

  (`character` or `NULL`)  
  a vector of main footer lines for the listing, or `NULL` (the
  default).

- prov_footer:

  (`character` or `NULL`)  
  a vector of provenance footer lines for the listing, or `NULL` (the
  default). Each string element is placed on a new line.

- split_into_pages_by_var:

  (`character` or `NULL`)  
  the name of a variable for on the listing should be split into pages,
  with each page corresponding to one unique value/level of the
  variable. See
  [`split_into_pages_by_var()`](https://insightsengineering.github.io/rlistings/reference/split_into_pages_by_var.md)
  for more details.

- spanning_col_labels:

  (`data.frame`)  
  A data.frame with the columns `span_level`, `label`, `start`, and
  `span` defining 0 or more levels of addition spanning (ie grouping) of
  columns. Defaults to no additional spanning labels.

- value:

  (`string`)  
  new value.

- vec:

  (`string`)  
  name of a column vector from a `listing_df` object to be annotated as
  a key column.

- new:

  (`character`)  
  vector of names of columns to be added to the set of display columns.

- name:

  (`string`)  
  name of the existing or new column to be displayed when the listing is
  rendered.

- fun:

  (`function` or `NULL`)  
  a function which accepts `df` and returns the vector for a new column,
  which is added to `df` as `name`, or `NULL` if marking an existing
  column as a listing column.

- format:

  (`string` or `function`)  
  a format label (string) or formatter function.

- na_str:

  (`string`)  
  string that should be displayed in place of missing values.

- align:

  (`string`)  
  alignment values should be rendered with.

## Value

A `listing_df` object, sorted by its key columns.

`df` with `name` created (if necessary) and marked for display during
rendering.

## Details

At its core, a `listing_df` object is a `tbl_df` object with a
customized print method and support for the formatting and pagination
machinery provided by the `formatters` package.

`listing_df` objects have two 'special' types of columns: key columns
and display columns.

Key columns act as indexes, which means a number of things in practice.

All key columns are also display columns.

`listing_df` objects are always sorted by their set of key columns at
creation time. Any `listing_df` object which is not sorted by its full
set of key columns (e.g., one whose rows have been reordered explicitly
during creation) is invalid and the behavior when rendering or
paginating that object is undefined.

Each value of a key column is printed only once per page and per unique
combination of values for all higher-priority (i.e., to the left of it)
key columns. Locations where a repeated value would have been printed
within a key column for the same higher-priority-key combination on the
same page are rendered as empty space. Note, determination of which
elements to display within a key column at rendering is based on the
underlying value; any non-default formatting applied to the column has
no effect on this behavior.

Display columns are columns which should be rendered, but are not key
columns. By default this is all non-key columns in the incoming data,
but in need not be. Columns in the underlying data which are neither key
nor display columns remain within the object available for computations
but *are not rendered during printing or export of the listing*.

Spanning column labels are displayed centered above the individual
labels of the columns they span across. `span_level` 1 is placed
directly above the column labels, with higher "span_levels\` displayed
above it in ascending order.

IF spanning column labels are present, a single spanning label cannot
span across both key and non-key displayed columns simultaneously due to
key columns' repetition after page breaks during horizontal pagination.
Attempting to set a spanning column label which does so will result in
an error.

## Note

Unlike in the `rtables` sister package, spanning labels here are purely
decorative and do not reflect any structure among the columns modeled by
`rlistings`. Thus, we cannot, e.g., use pathing to select columns under
a certain spanning column label, or restrict horizontal pagination to
leave 'groups' of columns implied by a spanning label intact.

## Examples

``` r
dat <- ex_adae

# This example demonstrates the listing with key_cols (values are grouped by USUBJID) and
# multiple lines in prov_footer
lsting <- as_listing(dat[1:25, ],
  key_cols = c("USUBJID", "AESOC"),
  main_title = "Example Title for Listing",
  subtitles = "This is the subtitle for this Adverse Events Table",
  main_footer = "Main footer for the listing",
  prov_footer = c(
    "You can even add a subfooter", "Second element is place on a new line",
    "Third string"
  )
) %>%
  add_listing_col("AETOXGR") %>%
  add_listing_col("BMRKR1", format = "xx.x") %>%
  add_listing_col("AESER / AREL", fun = function(df) paste(df$AESER, df$AREL, sep = " / "))

mat <- matrix_form(lsting)

cat(toString(mat))
#> Example Title for Listing
#> This is the subtitle for this Adverse Events Table
#> 
#> —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Study Identifier   Subject Identifier for the Study   Study Site Identifier   Age   Sex             Race              Country   Investigator Identifier   Description of Planned Arm   Planned Arm Code   Description of Actual Arm   Actual Arm Code   Stratification Factor 1   Stratification Factor 2   Continous Level Biomarker 1   Categorical Level Biomarker 2   Intent-To-Treat Population Flag   Safety Population Flag   Response Evaluable Population Flag   Biomarker Evaluable Population Flag   Date of Randomization   Datetime of First Exposure to Treatment   Datetime of Last Exposure to Treatment   End of Study Status   End of Study Date   End of Study Relative Day   Reason for Discontinuation from Study   Date of Death   Date Last Known Alive   NOT A STANDARD BUT NEEDED FOR RCD   Analysis Sequence Number   Sponsor-Defined Identifier   Reported Term for the Adverse Event   Lowest Level Term   Dictionary-Derived Term   High Level Term   High Level Group Term   Body System or Organ Class   Severity/Intensity   Serious Event   Analysis Causality   Analysis Start Datetime   Analysis End Datetime   Analysis Start Relative Day   Analysis End Relative Day   Analysis Toxicity Grade   AESER / AREL
#> —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                  AB12345                     id-134                        BRA-1           47     M              WHITE               BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S2              6.5                                        LOW                               Y                            Y                              Y                                     N                         2021-06-09               2021-06-10 13:26:53.956201                2023-06-11 01:05:17.956201              COMPLETED           2023-06-11                  731                               NA                      2023-06-11          2023-06-29                     63113904                           3                           3                           trm A.1.1.1.2                llt A.1.1.1.2          dcd A.1.1.1.2          hlt A.1.1.1          hlgt A.1.1                   cl A.1                  MODERATE              Y                 N                  2022-10-20               2023-06-05                     497                          725              2                         Y / N       
#>                                                              AB12345                     id-134                        BRA-1           47     M              WHITE               BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S2              6.5                                        LOW                               Y                            Y                              Y                                     N                         2021-06-09               2021-06-10 13:26:53.956201                2023-06-11 01:05:17.956201              COMPLETED           2023-06-11                  731                               NA                      2023-06-11          2023-06-29                     63113904                           4                           4                           trm A.1.1.1.2                llt A.1.1.1.2          dcd A.1.1.1.2          hlt A.1.1.1          hlgt A.1.1                   cl A.1                  MODERATE              Y                 N                  2023-02-08               2023-04-15                     608                          674              2                         Y / N       
#>                                        cl B                  AB12345                     id-134                        BRA-1           47     M              WHITE               BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S2              6.5                                        LOW                               Y                            Y                              Y                                     N                         2021-06-09               2021-06-10 13:26:53.956201                2023-06-11 01:05:17.956201              COMPLETED           2023-06-11                  731                               NA                      2023-06-11          2023-06-29                     63113904                           1                           1                           trm B.2.1.2.1                llt B.2.1.2.1          dcd B.2.1.2.1          hlt B.2.1.2          hlgt B.2.1                   cl B.2                  MODERATE              N                 N                  2022-02-16               2022-11-10                     251                          518              3                         N / N       
#>                                        cl D                  AB12345                     id-134                        BRA-1           47     M              WHITE               BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S2              6.5                                        LOW                               Y                            Y                              Y                                     N                         2021-06-09               2021-06-10 13:26:53.956201                2023-06-11 01:05:17.956201              COMPLETED           2023-06-11                  731                               NA                      2023-06-11          2023-06-29                     63113904                           2                           2                           trm D.1.1.4.2                llt D.1.1.4.2          dcd D.1.1.4.2          hlt D.1.1.4          hlgt D.1.1                   cl D.1                  MODERATE              N                 N                  2022-04-10               2022-12-21                     304                          559              3                         N / N       
#>   AB12345-BRA-1-id-141                 cl A                  AB12345                     id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1              7.5                                       HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           3                           3                           trm A.1.1.1.1                llt A.1.1.1.1          dcd A.1.1.1.1          hlt A.1.1.1          hlgt A.1.1                   cl A.1                    MILD                N                 N                  2022-07-06               2022-07-29                     493                          516              1                         N / N       
#>                                                              AB12345                     id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1              7.5                                       HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           4                           4                           trm A.1.1.1.2                llt A.1.1.1.2          dcd A.1.1.1.2          hlt A.1.1.1          hlgt A.1.1                   cl A.1                  MODERATE              Y                 N                  2022-10-21               2023-01-22                     600                          693              2                         Y / N       
#>                                                              AB12345                     id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1              7.5                                       HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           5                           5                           trm A.1.1.1.1                llt A.1.1.1.1          dcd A.1.1.1.1          hlt A.1.1.1          hlgt A.1.1                   cl A.1                    MILD                N                 N                  2022-11-25               2023-01-07                     635                          678              1                         N / N       
#>                                        cl B                  AB12345                     id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1              7.5                                       HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           1                           1                           trm B.2.1.2.1                llt B.2.1.2.1          dcd B.2.1.2.1          hlt B.2.1.2          hlgt B.2.1                   cl B.2                  MODERATE              N                 N                  2021-11-14               2021-11-21                     259                          266              3                         N / N       
#>                                        cl D                  AB12345                     id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1              7.5                                       HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           2                           2                           trm D.2.1.5.3                llt D.2.1.5.3          dcd D.2.1.5.3          hlt D.2.1.5          hlgt D.2.1                   cl D.2                    MILD                N                 Y                  2021-12-28               2023-02-21                     303                          723              1                         N / Y       
#>                                                              AB12345                     id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1              7.5                                       HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           6                           6                           trm D.1.1.1.1                llt D.1.1.1.1          dcd D.1.1.1.1          hlt D.1.1.1          hlgt D.1.1                   cl D.1                   SEVERE               Y                 N                  2023-02-28               2023-03-01                     730                          731              5                         Y / N       
#>   AB12345-BRA-1-id-236                 cl B                  AB12345                     id-236                        BRA-1           32     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    B: Placebo                ARM B                B: Placebo                ARM B                   A                        S2              7.7                                       HIGH                               Y                            Y                              Y                                     Y                         2021-08-17               2021-08-21 18:13:25.956201                2023-08-22 05:51:49.956201              COMPLETED           2023-08-22                  731                               NA                      2023-08-22          2023-09-14                     63113904                           1                           1                           trm B.1.1.1.1                llt B.1.1.1.1          dcd B.1.1.1.1          hlt B.1.1.1          hlgt B.1.1                   cl B.1                   SEVERE               N                 Y                  2021-09-12               2022-10-27                     22                           432              5                         N / Y       
#>                                                              AB12345                     id-236                        BRA-1           32     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    B: Placebo                ARM B                B: Placebo                ARM B                   A                        S2              7.7                                       HIGH                               Y                            Y                              Y                                     Y                         2021-08-17               2021-08-21 18:13:25.956201                2023-08-22 05:51:49.956201              COMPLETED           2023-08-22                  731                               NA                      2023-08-22          2023-09-14                     63113904                           2                           2                           trm B.1.1.1.1                llt B.1.1.1.1          dcd B.1.1.1.1          hlt B.1.1.1          hlgt B.1.1                   cl B.1                   SEVERE               N                 Y                  2022-02-18               2023-07-20                     181                          698              5                         N / Y       
#>                                                              AB12345                     id-236                        BRA-1           32     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    B: Placebo                ARM B                B: Placebo                ARM B                   A                        S2              7.7                                       HIGH                               Y                            Y                              Y                                     Y                         2021-08-17               2021-08-21 18:13:25.956201                2023-08-22 05:51:49.956201              COMPLETED           2023-08-22                  731                               NA                      2023-08-22          2023-09-14                     63113904                           3                           3                           trm B.1.1.1.1                llt B.1.1.1.1          dcd B.1.1.1.1          hlt B.1.1.1          hlgt B.1.1                   cl B.1                   SEVERE               N                 Y                  2023-07-24               2023-07-28                     702                          706              5                         N / Y       
#>   AB12345-BRA-1-id-265                 cl C                  AB12345                     id-265                        BRA-1           25     M              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   A                        S2              10.3                                     MEDIUM                              Y                            Y                              Y                                     N                         2020-05-09               2020-05-13 00:38:12.956201                2021-09-18 15:23:35.956201            DISCONTINUED          2021-09-18                  494                  WITHDRAWAL BY PARENT/GUARDIAN        2021-09-18          2021-10-08                     63113904                           1                           1                           trm C.2.1.2.1                llt C.2.1.2.1          dcd C.2.1.2.1          hlt C.2.1.2          hlgt C.2.1                   cl C.2                  MODERATE              N                 Y                  2020-06-30               2020-08-13                     48                           92               2                         N / Y       
#>                                                              AB12345                     id-265                        BRA-1           25     M              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   A                        S2              10.3                                     MEDIUM                              Y                            Y                              Y                                     N                         2020-05-09               2020-05-13 00:38:12.956201                2021-09-18 15:23:35.956201            DISCONTINUED          2021-09-18                  494                  WITHDRAWAL BY PARENT/GUARDIAN        2021-09-18          2021-10-08                     63113904                           4                           4                           trm C.1.1.1.3                llt C.1.1.1.3          dcd C.1.1.1.3          hlt C.1.1.1          hlgt C.1.1                   cl C.1                   SEVERE               N                 Y                  2021-06-20               2021-07-27                     403                          440              4                         N / Y       
#>                                        cl D                  AB12345                     id-265                        BRA-1           25     M              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   A                        S2              10.3                                     MEDIUM                              Y                            Y                              Y                                     N                         2020-05-09               2020-05-13 00:38:12.956201                2021-09-18 15:23:35.956201            DISCONTINUED          2021-09-18                  494                  WITHDRAWAL BY PARENT/GUARDIAN        2021-09-18          2021-10-08                     63113904                           2                           2                           trm D.1.1.4.2                llt D.1.1.4.2          dcd D.1.1.4.2          hlt D.1.1.4          hlgt D.1.1                   cl D.1                  MODERATE              N                 N                  2020-11-29               2021-05-10                     200                          362              3                         N / N       
#>                                                              AB12345                     id-265                        BRA-1           25     M              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   A                        S2              10.3                                     MEDIUM                              Y                            Y                              Y                                     N                         2020-05-09               2020-05-13 00:38:12.956201                2021-09-18 15:23:35.956201            DISCONTINUED          2021-09-18                  494                  WITHDRAWAL BY PARENT/GUARDIAN        2021-09-18          2021-10-08                     63113904                           3                           3                           trm D.1.1.1.1                llt D.1.1.1.1          dcd D.1.1.1.1          hlt D.1.1.1          hlgt D.1.1                   cl D.1                   SEVERE               Y                 N                  2021-06-09               2021-06-30                     392                          413              5                         Y / N       
#>    AB12345-BRA-1-id-42                 cl A                  AB12345                     id-42                         BRA-1           36     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S1              2.3                                      MEDIUM                              Y                            Y                              Y                                     Y                         2020-08-06               2020-08-07 06:44:59.956201                            NA                           ONGOING                NA                      NA                                NA                          NA                  NA                         63113904                           4                           4                           trm A.1.1.1.2                llt A.1.1.1.2          dcd A.1.1.1.2          hlt A.1.1.1          hlgt A.1.1                   cl A.1                  MODERATE              Y                 N                  2021-01-14               2021-09-30                     160                          419              2                         Y / N       
#>                                                              AB12345                     id-42                         BRA-1           36     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S1              2.3                                      MEDIUM                              Y                            Y                              Y                                     Y                         2020-08-06               2020-08-07 06:44:59.956201                            NA                           ONGOING                NA                      NA                                NA                          NA                  NA                         63113904                           6                           6                           trm A.1.1.1.2                llt A.1.1.1.2          dcd A.1.1.1.2          hlt A.1.1.1          hlgt A.1.1                   cl A.1                  MODERATE              Y                 N                  2021-11-10               2022-05-23                     460                          654              2                         Y / N       
#>                                                              AB12345                     id-42                         BRA-1           36     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S1              2.3                                      MEDIUM                              Y                            Y                              Y                                     Y                         2020-08-06               2020-08-07 06:44:59.956201                            NA                           ONGOING                NA                      NA                                NA                          NA                  NA                         63113904                           8                           8                           trm A.1.1.1.2                llt A.1.1.1.2          dcd A.1.1.1.2          hlt A.1.1.1          hlgt A.1.1                   cl A.1                  MODERATE              Y                 N                  2021-11-26               2022-03-18                     476                          588              2                         Y / N       
#>                                        cl B                  AB12345                     id-42                         BRA-1           36     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S1              2.3                                      MEDIUM                              Y                            Y                              Y                                     Y                         2020-08-06               2020-08-07 06:44:59.956201                            NA                           ONGOING                NA                      NA                                NA                          NA                  NA                         63113904                           5                           5                           trm B.2.2.3.1                llt B.2.2.3.1          dcd B.2.2.3.1          hlt B.2.2.3          hlgt B.2.2                   cl B.2                    MILD                Y                 N                  2021-05-26               2021-07-15                     292                          342              1                         Y / N       
#>                                                              AB12345                     id-42                         BRA-1           36     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S1              2.3                                      MEDIUM                              Y                            Y                              Y                                     Y                         2020-08-06               2020-08-07 06:44:59.956201                            NA                           ONGOING                NA                      NA                                NA                          NA                  NA                         63113904                           7                           7                           trm B.1.1.1.1                llt B.1.1.1.1          dcd B.1.1.1.1          hlt B.1.1.1          hlgt B.1.1                   cl B.1                   SEVERE               N                 Y                  2021-11-20               2022-03-30                     470                          600              5                         N / Y       
#>                                        cl C                  AB12345                     id-42                         BRA-1           36     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S1              2.3                                      MEDIUM                              Y                            Y                              Y                                     Y                         2020-08-06               2020-08-07 06:44:59.956201                            NA                           ONGOING                NA                      NA                                NA                          NA                  NA                         63113904                           1                           1                           trm C.2.1.2.1                llt C.2.1.2.1          dcd C.2.1.2.1          hlt C.2.1.2          hlgt C.2.1                   cl C.2                  MODERATE              N                 Y                  2020-09-15               2022-02-03                     39                           545              2                         N / Y       
#>                                                              AB12345                     id-42                         BRA-1           36     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S1              2.3                                      MEDIUM                              Y                            Y                              Y                                     Y                         2020-08-06               2020-08-07 06:44:59.956201                            NA                           ONGOING                NA                      NA                                NA                          NA                  NA                         63113904                           3                           3                           trm C.2.1.2.1                llt C.2.1.2.1          dcd C.2.1.2.1          hlt C.2.1.2          hlgt C.2.1                   cl C.2                  MODERATE              N                 Y                  2020-11-10               2021-09-12                     95                           401              2                         N / Y       
#>                                        cl D                  AB12345                     id-42                         BRA-1           36     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S1              2.3                                      MEDIUM                              Y                            Y                              Y                                     Y                         2020-08-06               2020-08-07 06:44:59.956201                            NA                           ONGOING                NA                      NA                                NA                          NA                  NA                         63113904                           2                           2                           trm D.1.1.1.1                llt D.1.1.1.1          dcd D.1.1.1.1          hlt D.1.1.1          hlgt D.1.1                   cl D.1                   SEVERE               Y                 N                  2020-10-11               2022-07-02                     65                           694              5                         Y / N       
#> —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> Main footer for the listing
#> 
#> You can even add a subfooter
#> Second element is place on a new line
#> Third string

# This example demonstrates the listing table without key_cols
# and specifying the cols with disp_cols.
dat <- ex_adae
lsting <- as_listing(dat[1:25, ],
  disp_cols = c("USUBJID", "AESOC", "RACE", "AETOXGR", "BMRKR1")
)

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

# This example demonstrates a listing with format configurations specified
# via the default_formatting and col_formatting arguments
dat <- ex_adae
dat$AENDY[3:6] <- NA
lsting <- as_listing(dat[1:25, ],
  key_cols = c("USUBJID", "AESOC"),
  disp_cols = c("STUDYID", "SEX", "ASEQ", "RANDDT", "ASTDY", "AENDY"),
  default_formatting = list(
    all = fmt_config(align = "left"),
    numeric = fmt_config(
      format = "xx.xx",
      na_str = "<No data>",
      align = "right"
    )
  )
) %>%
  add_listing_col("BMRKR1", format = "xx.x", align = "center")

mat <- matrix_form(lsting)

cat(toString(mat))
#> Unique Subject Identifier   Primary System Organ Class   Study Identifier   Sex   Analysis Sequence Number   Date of Randomization   Analysis Start Relative Day   Analysis End Relative Day   Continous Level Biomarker 1
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> AB12345-BRA-1-id-134        cl A                         AB12345            M                         3.00   2021-06-09                                   497.00                   <No data>               6.5            
#>                                                          AB12345            M                         4.00   2021-06-09                                   608.00                   <No data>               6.5            
#>                             cl B                         AB12345            M                         1.00   2021-06-09                                   251.00                      518.00               6.5            
#>                             cl D                         AB12345            M                         2.00   2021-06-09                                   304.00                      559.00               6.5            
#> AB12345-BRA-1-id-141        cl A                         AB12345            F                         3.00   2021-02-25                                   493.00                      516.00               7.5            
#>                                                          AB12345            F                         4.00   2021-02-25                                   600.00                      693.00               7.5            
#>                                                          AB12345            F                         5.00   2021-02-25                                   635.00                      678.00               7.5            
#>                             cl B                         AB12345            F                         1.00   2021-02-25                                   259.00                   <No data>               7.5            
#>                             cl D                         AB12345            F                         2.00   2021-02-25                                   303.00                   <No data>               7.5            
#>                                                          AB12345            F                         6.00   2021-02-25                                   730.00                      731.00               7.5            
#> AB12345-BRA-1-id-236        cl B                         AB12345            M                         1.00   2021-08-17                                    22.00                      432.00               7.7            
#>                                                          AB12345            M                         2.00   2021-08-17                                   181.00                      698.00               7.7            
#>                                                          AB12345            M                         3.00   2021-08-17                                   702.00                      706.00               7.7            
#> AB12345-BRA-1-id-265        cl C                         AB12345            M                         1.00   2020-05-09                                    48.00                       92.00              10.3            
#>                                                          AB12345            M                         4.00   2020-05-09                                   403.00                      440.00              10.3            
#>                             cl D                         AB12345            M                         2.00   2020-05-09                                   200.00                      362.00              10.3            
#>                                                          AB12345            M                         3.00   2020-05-09                                   392.00                      413.00              10.3            
#> AB12345-BRA-1-id-42         cl A                         AB12345            M                         4.00   2020-08-06                                   160.00                      419.00               2.3            
#>                                                          AB12345            M                         6.00   2020-08-06                                   460.00                      654.00               2.3            
#>                                                          AB12345            M                         8.00   2020-08-06                                   476.00                      588.00               2.3            
#>                             cl B                         AB12345            M                         5.00   2020-08-06                                   292.00                      342.00               2.3            
#>                                                          AB12345            M                         7.00   2020-08-06                                   470.00                      600.00               2.3            
#>                             cl C                         AB12345            M                         1.00   2020-08-06                                    39.00                      545.00               2.3            
#>                                                          AB12345            M                         3.00   2020-08-06                                    95.00                      401.00               2.3            
#>                             cl D                         AB12345            M                         2.00   2020-08-06                                    65.00                      694.00               2.3            
```
