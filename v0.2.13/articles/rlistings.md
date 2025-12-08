# Getting Started

## Introduction

This vignette shows the general purpose and basic functionality of the
`rlistings` R package.

The `rlistings` R package contains value formatting and ASCII rendering
infrastructure for tables and listings useful for clinical trials and
other statistical analysis. The core functionality is built on top of
the [`formatters`
package](https://insightsengineering.github.io/formatters/latest-tag/).

Some of the key features currently available to customize listings
created using the `rlistings` package include:

- Key columns
- Titles and footnotes

For information on listing column formatting see the [Column Formatting
vignette](https://insightsengineering.github.io/rlistings/articles/col_formatting.md).
To learn about listing pagination see the [Pagination
vignette](https://insightsengineering.github.io/rlistings/articles/pagination.md).

The index of all available `rlistings` functions can be found on the
[rlistings website functions
reference](https://insightsengineering.github.io/rlistings/main/reference/index.html).

The `rlistings` package is intended for use in creating simple
one-dimensional listings. For construction of more complex tables see
the [`rtables` package](https://insightsengineering.github.io/rtables/).

------------------------------------------------------------------------

## Building a Listing

With the basic framework provided in this package, a `data.frame` object
can be easily converted into a listing using the `as_listing` function
with several optional customizations available.

A listing, at its core, is a set of observation-level data which is to
be rendered with particular formatting but without any sort of
aggregation or further analysis. In practice, this translates to to a
classed `data.frame` (or `tbl_df`) object with a specialized print
method. This means that, unlike tables created with `rlistings`’ sibling
package `rtables`, a listing object is fundamentally the incoming
`data.frame` with a few annotations attached to it.

In the R code below we will give a basic example of how to create an
`rlistings` listing from a pre-processed data frame.

We first load in the `rlistings` package.

``` r
library(rlistings)
#> Loading required package: formatters
#> 
#> Attaching package: 'formatters'
#> The following object is masked from 'package:base':
#> 
#>     %||%
#> Loading required package: tibble
```

For the purpose of this example we will use the dummy ADAE dataset
provided within the `formatters` package as our data frame, which
consists of 48 columns of adverse event patient data, and one or more
rows per patient.

``` r
adae <- ex_adae
```

Now we will create our listing.

The `df` parameter sets our `data.frame` object. The `disp_cols`
argument takes a vector of names of any columns taken from the data
frame that should be included in the listing. Column headers are set by
the `label` attribute of each given variable. If there is no label
associated with a given variable then the variable name will be taken as
a header instead. For this example we will choose 8 arbitrary columns to
display - 5 specific to the patient and 3 relating to the adverse event.

Since the dataset consists of 1934 rows in total, we will use the `head`
function to print only the first 15 rows of the listing.

``` r
lsting <- as_listing(
  df = adae,
  disp_cols = c("USUBJID", "AETOXGR", "ARM", "AGE", "SEX", "RACE", "AEDECOD", "AESEV"),
)

head(lsting, 15)
#> Study Identifier   Unique Subject Identifier   Analysis Toxicity Grade   Description of Planned Arm   Age   Sex             Race              Dictionary-Derived Term   Severity/Intensity
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>     AB12345          AB12345-BRA-1-id-134                 3                      A: Drug X            47     M              WHITE                  dcd B.2.1.2.1             MODERATE     
#>                      AB12345-BRA-1-id-134                 3                      A: Drug X            47     M              WHITE                  dcd D.1.1.4.2             MODERATE     
#>                      AB12345-BRA-1-id-134                 2                      A: Drug X            47     M              WHITE                  dcd A.1.1.1.2             MODERATE     
#>                      AB12345-BRA-1-id-134                 2                      A: Drug X            47     M              WHITE                  dcd A.1.1.1.2             MODERATE     
#>                      AB12345-BRA-1-id-141                 3                    C: Combination         35     F              WHITE                  dcd B.2.1.2.1             MODERATE     
#>                      AB12345-BRA-1-id-141                 1                    C: Combination         35     F              WHITE                  dcd D.2.1.5.3               MILD       
#>                      AB12345-BRA-1-id-141                 1                    C: Combination         35     F              WHITE                  dcd A.1.1.1.1               MILD       
#>                      AB12345-BRA-1-id-141                 2                    C: Combination         35     F              WHITE                  dcd A.1.1.1.2             MODERATE     
#>                      AB12345-BRA-1-id-141                 1                    C: Combination         35     F              WHITE                  dcd A.1.1.1.1               MILD       
#>                      AB12345-BRA-1-id-141                 5                    C: Combination         35     F              WHITE                  dcd D.1.1.1.1              SEVERE      
#>                      AB12345-BRA-1-id-236                 5                      B: Placebo           32     M    BLACK OR AFRICAN AMERICAN        dcd B.1.1.1.1              SEVERE      
#>                      AB12345-BRA-1-id-236                 5                      B: Placebo           32     M    BLACK OR AFRICAN AMERICAN        dcd B.1.1.1.1              SEVERE      
#>                      AB12345-BRA-1-id-236                 5                      B: Placebo           32     M    BLACK OR AFRICAN AMERICAN        dcd B.1.1.1.1              SEVERE      
#>                      AB12345-BRA-1-id-265                 2                    C: Combination         25     M              WHITE                  dcd C.2.1.2.1             MODERATE     
#>                      AB12345-BRA-1-id-265                 3                    C: Combination         25     M              WHITE                  dcd D.1.1.4.2             MODERATE
```

In the listing output above you can see that there are several rows
associated with each patient, resulting in many instances of repeated
values over several columns. This can cleaned up by setting key columns
with the `key_cols` argument.

We can also declare the set of (non-key) display columns by compliment,
via the `non_disp_col` argument. If specifies this argument accepts
names of columns which will non be displayed. All other non-key columns
are then displayed.

``` r
lsting <- as_listing(
  df = adae,
  non_disp_cols = tail(names(adae), 8)
)
head(lsting, 15)
#> Study Identifier   Unique Subject Identifier   Subject Identifier for the Study   Study Site Identifier   Age   Sex             Race              Country   Investigator Identifier   Description of Planned Arm   Planned Arm Code   Description of Actual Arm   Actual Arm Code   Stratification Factor 1   Stratification Factor 2   Continous Level Biomarker 1   Categorical Level Biomarker 2   Intent-To-Treat Population Flag   Safety Population Flag   Response Evaluable Population Flag   Biomarker Evaluable Population Flag   Date of Randomization   Datetime of First Exposure to Treatment   Datetime of Last Exposure to Treatment   End of Study Status   End of Study Date   End of Study Relative Day   Reason for Discontinuation from Study   Date of Death   Date Last Known Alive   NOT A STANDARD BUT NEEDED FOR RCD   Analysis Sequence Number   Sponsor-Defined Identifier   Reported Term for the Adverse Event   Lowest Level Term   Dictionary-Derived Term   High Level Term   High Level Group Term   Body System or Organ Class   Primary System Organ Class
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>     AB12345          AB12345-BRA-1-id-134                   id-134                        BRA-1           47     M              WHITE               BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S2                   6.46299057842479                      LOW                               Y                            Y                              Y                                     N                         2021-06-09               2021-06-10 13:26:53.956201                2023-06-11 01:05:17.956201              COMPLETED           2023-06-11                  731                               NA                      2023-06-11          2023-06-29                     63113904                           1                           1                           trm B.2.1.2.1                llt B.2.1.2.1          dcd B.2.1.2.1          hlt B.2.1.2          hlgt B.2.1                   cl B.2                        cl B           
#>                      AB12345-BRA-1-id-134                   id-134                        BRA-1           47     M              WHITE               BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S2                   6.46299057842479                      LOW                               Y                            Y                              Y                                     N                         2021-06-09               2021-06-10 13:26:53.956201                2023-06-11 01:05:17.956201              COMPLETED           2023-06-11                  731                               NA                      2023-06-11          2023-06-29                     63113904                           2                           2                           trm D.1.1.4.2                llt D.1.1.4.2          dcd D.1.1.4.2          hlt D.1.1.4          hlgt D.1.1                   cl D.1                        cl D           
#>                      AB12345-BRA-1-id-134                   id-134                        BRA-1           47     M              WHITE               BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S2                   6.46299057842479                      LOW                               Y                            Y                              Y                                     N                         2021-06-09               2021-06-10 13:26:53.956201                2023-06-11 01:05:17.956201              COMPLETED           2023-06-11                  731                               NA                      2023-06-11          2023-06-29                     63113904                           3                           3                           trm A.1.1.1.2                llt A.1.1.1.2          dcd A.1.1.1.2          hlt A.1.1.1          hlgt A.1.1                   cl A.1                        cl A           
#>                      AB12345-BRA-1-id-134                   id-134                        BRA-1           47     M              WHITE               BRA              BRA-1                    A: Drug X                 ARM A                 A: Drug X                ARM A                   B                        S2                   6.46299057842479                      LOW                               Y                            Y                              Y                                     N                         2021-06-09               2021-06-10 13:26:53.956201                2023-06-11 01:05:17.956201              COMPLETED           2023-06-11                  731                               NA                      2023-06-11          2023-06-29                     63113904                           4                           4                           trm A.1.1.1.2                llt A.1.1.1.2          dcd A.1.1.1.2          hlt A.1.1.1          hlgt A.1.1                   cl A.1                        cl A           
#>                      AB12345-BRA-1-id-141                   id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1                   7.51607612428241                     HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           1                           1                           trm B.2.1.2.1                llt B.2.1.2.1          dcd B.2.1.2.1          hlt B.2.1.2          hlgt B.2.1                   cl B.2                        cl B           
#>                      AB12345-BRA-1-id-141                   id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1                   7.51607612428241                     HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           2                           2                           trm D.2.1.5.3                llt D.2.1.5.3          dcd D.2.1.5.3          hlt D.2.1.5          hlgt D.2.1                   cl D.2                        cl D           
#>                      AB12345-BRA-1-id-141                   id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1                   7.51607612428241                     HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           3                           3                           trm A.1.1.1.1                llt A.1.1.1.1          dcd A.1.1.1.1          hlt A.1.1.1          hlgt A.1.1                   cl A.1                        cl A           
#>                      AB12345-BRA-1-id-141                   id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1                   7.51607612428241                     HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           4                           4                           trm A.1.1.1.2                llt A.1.1.1.2          dcd A.1.1.1.2          hlt A.1.1.1          hlgt A.1.1                   cl A.1                        cl A           
#>                      AB12345-BRA-1-id-141                   id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1                   7.51607612428241                     HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           5                           5                           trm A.1.1.1.1                llt A.1.1.1.1          dcd A.1.1.1.1          hlt A.1.1.1          hlgt A.1.1                   cl A.1                        cl A           
#>                      AB12345-BRA-1-id-141                   id-141                        BRA-1           35     F              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   B                        S1                   7.51607612428241                     HIGH                               Y                            Y                              Y                                     Y                         2021-02-25               2021-02-28 23:47:16.956201                2023-03-01 11:25:40.956201              COMPLETED           2023-03-01                  731                               NA                      2023-03-01          2023-03-30                     63113904                           6                           6                           trm D.1.1.1.1                llt D.1.1.1.1          dcd D.1.1.1.1          hlt D.1.1.1          hlgt D.1.1                   cl D.1                        cl D           
#>                      AB12345-BRA-1-id-236                   id-236                        BRA-1           32     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    B: Placebo                ARM B                B: Placebo                ARM B                   A                        S2                   7.66300121077566                     HIGH                               Y                            Y                              Y                                     Y                         2021-08-17               2021-08-21 18:13:25.956201                2023-08-22 05:51:49.956201              COMPLETED           2023-08-22                  731                               NA                      2023-08-22          2023-09-14                     63113904                           1                           1                           trm B.1.1.1.1                llt B.1.1.1.1          dcd B.1.1.1.1          hlt B.1.1.1          hlgt B.1.1                   cl B.1                        cl B           
#>                      AB12345-BRA-1-id-236                   id-236                        BRA-1           32     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    B: Placebo                ARM B                B: Placebo                ARM B                   A                        S2                   7.66300121077566                     HIGH                               Y                            Y                              Y                                     Y                         2021-08-17               2021-08-21 18:13:25.956201                2023-08-22 05:51:49.956201              COMPLETED           2023-08-22                  731                               NA                      2023-08-22          2023-09-14                     63113904                           2                           2                           trm B.1.1.1.1                llt B.1.1.1.1          dcd B.1.1.1.1          hlt B.1.1.1          hlgt B.1.1                   cl B.1                        cl B           
#>                      AB12345-BRA-1-id-236                   id-236                        BRA-1           32     M    BLACK OR AFRICAN AMERICAN     BRA              BRA-1                    B: Placebo                ARM B                B: Placebo                ARM B                   A                        S2                   7.66300121077566                     HIGH                               Y                            Y                              Y                                     Y                         2021-08-17               2021-08-21 18:13:25.956201                2023-08-22 05:51:49.956201              COMPLETED           2023-08-22                  731                               NA                      2023-08-22          2023-09-14                     63113904                           3                           3                           trm B.1.1.1.1                llt B.1.1.1.1          dcd B.1.1.1.1          hlt B.1.1.1          hlgt B.1.1                   cl B.1                        cl B           
#>                      AB12345-BRA-1-id-265                   id-265                        BRA-1           25     M              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   A                        S2                    10.323346349886                    MEDIUM                              Y                            Y                              Y                                     N                         2020-05-09               2020-05-13 00:38:12.956201                2021-09-18 15:23:35.956201            DISCONTINUED          2021-09-18                  494                  WITHDRAWAL BY PARENT/GUARDIAN        2021-09-18          2021-10-08                     63113904                           1                           1                           trm C.2.1.2.1                llt C.2.1.2.1          dcd C.2.1.2.1          hlt C.2.1.2          hlgt C.2.1                   cl C.2                        cl C           
#>                      AB12345-BRA-1-id-265                   id-265                        BRA-1           25     M              WHITE               BRA              BRA-1                  C: Combination              ARM C              C: Combination              ARM C                   A                        S2                    10.323346349886                    MEDIUM                              Y                            Y                              Y                                     N                         2020-05-09               2020-05-13 00:38:12.956201                2021-09-18 15:23:35.956201            DISCONTINUED          2021-09-18                  494                  WITHDRAWAL BY PARENT/GUARDIAN        2021-09-18          2021-10-08                     63113904                           2                           2                           trm D.1.1.4.2                llt D.1.1.4.2          dcd D.1.1.4.2          hlt D.1.1.4          hlgt D.1.1                   cl D.1                        cl D
```

## Key Columns

Key columns act as contextual identifiers for observations. Their core
behavioral feature is that sequentially repeated values are not
displayed when they do not add information.

In practice, this means that each value of a key column is printed only
once per unique combination of values for all higher-priority (i.e., to
the left of it) key columns (per page). Locations where a repeated value
would have been printed within a key column for the same
higher-priority-key combination on the same page are rendered as empty
space. Note, determination of which elements to display within a key
column at rendering is based on the underlying value; any non-default
formatting applied to the column has no effect on this behavior.

The `key_cols` argument takes a vector of column names identifying the
key columns for the listing. A listing is always sorted by its key
columns (with order defining the sort precedence). Below we specify
trial arm and patient ID as key columns to improve readability.

``` r
lsting <- as_listing(
  df = adae,
  disp_cols = c("ARM", "AGE", "SEX", "RACE", "AEDECOD", "AESEV"),
  key_cols = c("USUBJID", "AETOXGR")
)

head(lsting, 15)
#> Unique Subject Identifier   Analysis Toxicity Grade   Description of Planned Arm   Age   Sex             Race              Dictionary-Derived Term   Severity/Intensity
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 2                      A: Drug X            47     M              WHITE                  dcd A.1.1.1.2             MODERATE     
#>                                                               A: Drug X            47     M              WHITE                  dcd A.1.1.1.2             MODERATE     
#>                                        3                      A: Drug X            47     M              WHITE                  dcd B.2.1.2.1             MODERATE     
#>                                                               A: Drug X            47     M              WHITE                  dcd D.1.1.4.2             MODERATE     
#>   AB12345-BRA-1-id-141                 1                    C: Combination         35     F              WHITE                  dcd D.2.1.5.3               MILD       
#>                                                             C: Combination         35     F              WHITE                  dcd A.1.1.1.1               MILD       
#>                                                             C: Combination         35     F              WHITE                  dcd A.1.1.1.1               MILD       
#>                                        2                    C: Combination         35     F              WHITE                  dcd A.1.1.1.2             MODERATE     
#>                                        3                    C: Combination         35     F              WHITE                  dcd B.2.1.2.1             MODERATE     
#>                                        5                    C: Combination         35     F              WHITE                  dcd D.1.1.1.1              SEVERE      
#>   AB12345-BRA-1-id-236                 5                      B: Placebo           32     M    BLACK OR AFRICAN AMERICAN        dcd B.1.1.1.1              SEVERE      
#>                                                               B: Placebo           32     M    BLACK OR AFRICAN AMERICAN        dcd B.1.1.1.1              SEVERE      
#>                                                               B: Placebo           32     M    BLACK OR AFRICAN AMERICAN        dcd B.1.1.1.1              SEVERE      
#>   AB12345-BRA-1-id-265                 2                    C: Combination         25     M              WHITE                  dcd C.2.1.2.1             MODERATE     
#>                                        3                    C: Combination         25     M              WHITE                  dcd D.1.1.4.2             MODERATE
```

## Titles and Footers

Additionally, an `rlistings` listing can be annotated with two types of
header information (main title and subtitles) and two types of footer
information (main footers and provenance footers). A single title can be
set using the `main_title` argument, while one or more subtitles, main
footers, and provenance footers can be set by the `subtitles`,
`main_footer` and `prov_footer` arguments respectively. These are
demonstrated in the following updated listing.

``` r
lsting <- as_listing(
  df = adae,
  disp_cols = c("ARM", "AGE", "SEX", "RACE", "AEDECOD", "AESEV"),
  key_cols = c("USUBJID", "AETOXGR"),
  main_title = "Main Title",
  subtitles = c("Subtitle A", "Subtitle B"),
  main_footer = c("Main Footer A", "Main Footer B", "Main Footer C"),
  prov_footer = c("Provenance Footer A", "Provenance Footer B")
)

head(lsting, 15)
#> Main Title
#> Subtitle A
#> Subtitle B
#> 
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Analysis Toxicity Grade   Description of Planned Arm   Age   Sex             Race              Dictionary-Derived Term   Severity/Intensity
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 2                      A: Drug X            47     M              WHITE                  dcd A.1.1.1.2             MODERATE     
#>                                                               A: Drug X            47     M              WHITE                  dcd A.1.1.1.2             MODERATE     
#>                                        3                      A: Drug X            47     M              WHITE                  dcd B.2.1.2.1             MODERATE     
#>                                                               A: Drug X            47     M              WHITE                  dcd D.1.1.4.2             MODERATE     
#>   AB12345-BRA-1-id-141                 1                    C: Combination         35     F              WHITE                  dcd D.2.1.5.3               MILD       
#>                                                             C: Combination         35     F              WHITE                  dcd A.1.1.1.1               MILD       
#>                                                             C: Combination         35     F              WHITE                  dcd A.1.1.1.1               MILD       
#>                                        2                    C: Combination         35     F              WHITE                  dcd A.1.1.1.2             MODERATE     
#>                                        3                    C: Combination         35     F              WHITE                  dcd B.2.1.2.1             MODERATE     
#>                                        5                    C: Combination         35     F              WHITE                  dcd D.1.1.1.1              SEVERE      
#>   AB12345-BRA-1-id-236                 5                      B: Placebo           32     M    BLACK OR AFRICAN AMERICAN        dcd B.1.1.1.1              SEVERE      
#>                                                               B: Placebo           32     M    BLACK OR AFRICAN AMERICAN        dcd B.1.1.1.1              SEVERE      
#>                                                               B: Placebo           32     M    BLACK OR AFRICAN AMERICAN        dcd B.1.1.1.1              SEVERE      
#>   AB12345-BRA-1-id-265                 2                    C: Combination         25     M              WHITE                  dcd C.2.1.2.1             MODERATE     
#>                                        3                    C: Combination         25     M              WHITE                  dcd D.1.1.4.2             MODERATE     
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> Main Footer A
#> Main Footer B
#> Main Footer C
#> 
#> Provenance Footer A
#> Provenance Footer B
```

------------------------------------------------------------------------

## Summary

In this vignette you have learned how to implement the basic listing
framework provided by the `rlistings` package to build a simple listing.
You have also seen examples demonstrating how the optional parameters of
the `as_listing` function can be set to customize and annotate your
listings.

**For more information please explore the [rlistings
website](https://insightsengineering.github.io/rlistings/main/).**
