# Referential Footnotes

------------------------------------------------------------------------

## Introduction

There is currently no formal method for adding referential footnotes to
a listing object. This vignette demonstrates how referential footnotes
can be added to a `listing_df` object via a workaround applied during
pre-processing.

To learn more about how listings are constructed using the `rlistings`
package, see the [Getting Started
vignette](https://insightsengineering.github.io/rlistings/articles/rlistings.md).

------------------------------------------------------------------------

## Referential Footnotes Workaround

When creating a listing with the `rlistings` package, you may want to
add referential footnotes, similar to how referential footnotes can be
added to `rtable` objects. Since there is no formal method in
`rlistings` for applying referential footnotes to a `listing_df` object,
we will demonstrate how a workaround can be applied to add a set of
pseudo-referential footnotes to your listing.

To demonstrate, we will create a basic listing below.

We begin by loading in the `rlistings` package.

``` r
library(rlistings)
library(dplyr)
```

For this example, we will use the dummy ADAE dataset provided within the
`formatters` package as our data frame, which consists of 48 columns of
adverse event patient data, and one or more rows per patient. For the
purpose of this example, we will subset the data and only use the first
30 records of the dataset.

``` r
adae <- ex_adae[1:30, ]
```

Now we will create a basic listing.

``` r
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASEQ", "ASTDY"),
  disp_cols = c("BMRKR1", "AESEV"),
)

lsting
#> Description of Planned Arm   Unique Subject Identifier   Analysis Sequence Number   Analysis Start Relative Day   Continous Level Biomarker 1   Severity/Intensity
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>         A: Drug X              AB12345-BRA-1-id-134                 1                           251                    6.46299057842479              MODERATE     
#>                                                                     2                           304                    6.46299057842479              MODERATE     
#>                                                                     3                           497                    6.46299057842479              MODERATE     
#>                                                                     4                           608                    6.46299057842479              MODERATE     
#>                                 AB12345-BRA-1-id-42                 1                           39                     2.26753940777848              MODERATE     
#>                                                                     2                           65                     2.26753940777848               SEVERE      
#>                                                                     3                           95                     2.26753940777848              MODERATE     
#>                                                                     4                           160                    2.26753940777848              MODERATE     
#>                                                                     5                           292                    2.26753940777848                MILD       
#>                                                                     6                           460                    2.26753940777848              MODERATE     
#>                                                                     7                           470                    2.26753940777848               SEVERE      
#>                                                                     8                           476                    2.26753940777848              MODERATE     
#>                                                                     9                           497                    2.26753940777848               SEVERE      
#>                                                                     10                          642                    2.26753940777848               SEVERE      
#>         B: Placebo             AB12345-BRA-1-id-236                 1                           22                     7.66300121077566               SEVERE      
#>                                                                     2                           181                    7.66300121077566               SEVERE      
#>                                                                     3                           702                    7.66300121077566               SEVERE      
#>                                 AB12345-BRA-1-id-65                 1                           145                    7.34091885189189              MODERATE     
#>                                                                     2                           191                    7.34091885189189                MILD       
#>                                                                     3                           233                    7.34091885189189               SEVERE      
#>       C: Combination           AB12345-BRA-1-id-141                 1                           259                    7.51607612428241              MODERATE     
#>                                                                     2                           303                    7.51607612428241                MILD       
#>                                                                     3                           493                    7.51607612428241                MILD       
#>                                                                     4                           600                    7.51607612428241              MODERATE     
#>                                                                     5                           635                    7.51607612428241                MILD       
#>                                                                     6                           730                    7.51607612428241               SEVERE      
#>                                AB12345-BRA-1-id-265                 1                           48                      10.323346349886              MODERATE     
#>                                                                     2                           200                     10.323346349886              MODERATE     
#>                                                                     3                           392                     10.323346349886               SEVERE      
#>                                                                     4                           403                     10.323346349886               SEVERE
```

For this example, we will add 4 referential footnotes.

1.  In the `ARM` column, for all records with `ARM = "A: Drug X"` and
    `ASEQ` equal to 1 or 2.
2.  In the `ASTDY` column, for imputed dates, where imputed dates are
    indicated by the `ASTDTF` variable.
3.  In the `AESEV` column, for all records with `AETOXGR` equal to 5.
4.  In the `USUBJID` column header.

Footnote text can be supplied either as a vector, where each element is
a new footnote, or as a single string with footnotes separated by the
new line (`\n`) character. For example, see the following list of
referential footnotes:

``` r
ref_fns <- "*   ASEQ 1 or 2\n**  Analysis start date is imputed\n***  Records with ATOXGR = 5\n**** ID column"
```

We start with our first footnote in the `ARM` column for records with
arm “A: Drug X” which also have analysis sequence number 1 or 2.
Referential footnotes can be added to any variable by converting the
variable to a factor, editing the variable values, and adding a
corresponding footnote below the listing. We will add our first
referential footnote in the `ARM` column. To ensure that levels are
correctly ordered, be sure to specify the new level order when mutating
your variable.

``` r
# Save variable labels for your data to add back in after mutating dataset
df_lbls <- var_labels(adae)

# Mutate variable where referential footnotes are to be added according to your conditions
# Specify order of levels with new referential footnotes added
adae <- adae %>% dplyr::mutate(
  ARM = factor(
    ifelse(ARM == "A: Drug X" & ASEQ %in% 1:2, paste0(ARM, " (1)"), as.character(ARM)),
    levels = c(sapply(levels(adae$ARM), paste0, c("", "(1)")))
  )
)

# Add data variable labels back in
var_labels(adae) <- df_lbls

# Generate listing
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASEQ", "ASTDY"),
  disp_cols = c("BMRKR1", "AESEV"),
  main_footer = "(1)   ASEQ 1 or 2"
)

lsting
#> Description of Planned Arm   Unique Subject Identifier   Analysis Sequence Number   Analysis Start Relative Day   Continous Level Biomarker 1   Severity/Intensity
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>         A: Drug X              AB12345-BRA-1-id-134                 3                           497                    6.46299057842479              MODERATE     
#>                                                                     4                           608                    6.46299057842479              MODERATE     
#>                                 AB12345-BRA-1-id-42                 3                           95                     2.26753940777848              MODERATE     
#>                                                                     4                           160                    2.26753940777848              MODERATE     
#>                                                                     5                           292                    2.26753940777848                MILD       
#>                                                                     6                           460                    2.26753940777848              MODERATE     
#>                                                                     7                           470                    2.26753940777848               SEVERE      
#>                                                                     8                           476                    2.26753940777848              MODERATE     
#>                                                                     9                           497                    2.26753940777848               SEVERE      
#>                                                                     10                          642                    2.26753940777848               SEVERE      
#>         B: Placebo             AB12345-BRA-1-id-236                 1                           22                     7.66300121077566               SEVERE      
#>                                                                     2                           181                    7.66300121077566               SEVERE      
#>                                                                     3                           702                    7.66300121077566               SEVERE      
#>                                 AB12345-BRA-1-id-65                 1                           145                    7.34091885189189              MODERATE     
#>                                                                     2                           191                    7.34091885189189                MILD       
#>                                                                     3                           233                    7.34091885189189               SEVERE      
#>       C: Combination           AB12345-BRA-1-id-141                 1                           259                    7.51607612428241              MODERATE     
#>                                                                     2                           303                    7.51607612428241                MILD       
#>                                                                     3                           493                    7.51607612428241                MILD       
#>                                                                     4                           600                    7.51607612428241              MODERATE     
#>                                                                     5                           635                    7.51607612428241                MILD       
#>                                                                     6                           730                    7.51607612428241               SEVERE      
#>                                AB12345-BRA-1-id-265                 1                           48                      10.323346349886              MODERATE     
#>                                                                     2                           200                     10.323346349886              MODERATE     
#>                                                                     3                           392                     10.323346349886               SEVERE      
#>                                                                     4                           403                     10.323346349886               SEVERE      
#>             NA                 AB12345-BRA-1-id-134                 1                           251                    6.46299057842479              MODERATE     
#>                                                                     2                           304                    6.46299057842479              MODERATE     
#>                                 AB12345-BRA-1-id-42                 1                           39                     2.26753940777848              MODERATE     
#>                                                                     2                           65                     2.26753940777848               SEVERE      
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> (1)   ASEQ 1 or 2
```

Additional referential footnotes can be added to the data be repeating
the above steps.

For example, we can add the second referential footnote to the `ASTDY`
column for imputed analysis start days. We use dummy variable `ASTDTF`
to indicate imputed analysis start dates. When adding referential
footnotes to numeric variables, the variables must be converted to
factors.

``` r
set.seed(1)

# Save variable labels for your data to add back in after mutating dataset
df_lbls <- var_labels(adae)

# Mutate variable where referential footnotes are to be added according to your conditions
# Specify order of levels with new referential footnotes added
adae <- adae %>%
  dplyr::mutate(ASTDTF = sample(c("Y", NA), nrow(.), replace = TRUE, prob = c(0.25, 0.75))) %>%
  dplyr::mutate(ASTDY = factor(
    ifelse(!is.na(ASTDTF), paste0(as.character(ASTDY), "**"), as.character(ASTDY)),
    levels = c(sapply(sort(unique(adae$ASTDY)), paste0, c("", "**")))
  )) %>%
  dplyr::select(-ASTDTF)

# Add data variable labels back in
var_labels(adae) <- df_lbls

# Generate listing
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASEQ", "ASTDY"),
  disp_cols = c("BMRKR1", "AESEV"),
)

lsting
#> Description of Planned Arm   Unique Subject Identifier   Analysis Sequence Number   Analysis Start Relative Day   Continous Level Biomarker 1   Severity/Intensity
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>         A: Drug X              AB12345-BRA-1-id-134                 3                           497                    6.46299057842479              MODERATE     
#>                                                                     4                          608**                   6.46299057842479              MODERATE     
#>                                 AB12345-BRA-1-id-42                 3                          95**                    2.26753940777848              MODERATE     
#>                                                                     4                          160**                   2.26753940777848              MODERATE     
#>                                                                     5                           292                    2.26753940777848                MILD       
#>                                                                     6                           460                    2.26753940777848              MODERATE     
#>                                                                     7                           470                    2.26753940777848               SEVERE      
#>                                                                     8                           476                    2.26753940777848              MODERATE     
#>                                                                     9                           497                    2.26753940777848               SEVERE      
#>                                                                     10                          642                    2.26753940777848               SEVERE      
#>         B: Placebo             AB12345-BRA-1-id-236                 1                           22                     7.66300121077566               SEVERE      
#>                                                                     2                           181                    7.66300121077566               SEVERE      
#>                                                                     3                           702                    7.66300121077566               SEVERE      
#>                                 AB12345-BRA-1-id-65                 1                           145                    7.34091885189189              MODERATE     
#>                                                                     2                          191**                   7.34091885189189                MILD       
#>                                                                     3                           233                    7.34091885189189               SEVERE      
#>       C: Combination           AB12345-BRA-1-id-141                 1                           259                    7.51607612428241              MODERATE     
#>                                                                     2                          303**                   7.51607612428241                MILD       
#>                                                                     3                          493**                   7.51607612428241                MILD       
#>                                                                     4                           600                    7.51607612428241              MODERATE     
#>                                                                     5                           635                    7.51607612428241                MILD       
#>                                                                     6                           730                    7.51607612428241               SEVERE      
#>                                AB12345-BRA-1-id-265                 1                           48                      10.323346349886              MODERATE     
#>                                                                     2                          200**                    10.323346349886              MODERATE     
#>                                                                     3                           392                     10.323346349886               SEVERE      
#>                                                                     4                           403                     10.323346349886               SEVERE      
#>             NA                 AB12345-BRA-1-id-134                 1                           251                    6.46299057842479              MODERATE     
#>                                                                     2                           304                    6.46299057842479              MODERATE     
#>                                 AB12345-BRA-1-id-42                 1                          39**                    2.26753940777848              MODERATE     
#>                                                                     2                           65                     2.26753940777848               SEVERE
```

Next we can add our third referential footnote to the `AESEV` column for
records with analysis toxicity grade 5.

``` r
# Save variable labels for your data to add back in after mutating dataset
df_lbls <- var_labels(adae)

# Mutate variable where referential footnotes are to be added according to your conditions
# Specify order of levels with new referential footnotes added
adae <- adae %>% dplyr::mutate(
  AESEV = factor(
    ifelse(AETOXGR == 5, paste0(AESEV, "***"), as.character(AESEV)),
    levels = c(sapply(levels(adae$AESEV), paste0, c("", "***")))
  )
)

# Add data variable labels back in
var_labels(adae) <- df_lbls

# Generate listing
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASEQ", "ASTDY"),
  disp_cols = c("BMRKR1", "AESEV"),
)

lsting
#> Description of Planned Arm   Unique Subject Identifier   Analysis Sequence Number   Analysis Start Relative Day   Continous Level Biomarker 1   Severity/Intensity
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>         A: Drug X              AB12345-BRA-1-id-134                 3                           497                    6.46299057842479              MODERATE     
#>                                                                     4                          608**                   6.46299057842479              MODERATE     
#>                                 AB12345-BRA-1-id-42                 3                          95**                    2.26753940777848              MODERATE     
#>                                                                     4                          160**                   2.26753940777848              MODERATE     
#>                                                                     5                           292                    2.26753940777848                MILD       
#>                                                                     6                           460                    2.26753940777848              MODERATE     
#>                                                                     7                           470                    2.26753940777848             SEVERE***     
#>                                                                     8                           476                    2.26753940777848              MODERATE     
#>                                                                     9                           497                    2.26753940777848               SEVERE      
#>                                                                     10                          642                    2.26753940777848             SEVERE***     
#>         B: Placebo             AB12345-BRA-1-id-236                 1                           22                     7.66300121077566             SEVERE***     
#>                                                                     2                           181                    7.66300121077566             SEVERE***     
#>                                                                     3                           702                    7.66300121077566             SEVERE***     
#>                                 AB12345-BRA-1-id-65                 1                           145                    7.34091885189189              MODERATE     
#>                                                                     2                          191**                   7.34091885189189                MILD       
#>                                                                     3                           233                    7.34091885189189             SEVERE***     
#>       C: Combination           AB12345-BRA-1-id-141                 1                           259                    7.51607612428241              MODERATE     
#>                                                                     2                          303**                   7.51607612428241                MILD       
#>                                                                     3                          493**                   7.51607612428241                MILD       
#>                                                                     4                           600                    7.51607612428241              MODERATE     
#>                                                                     5                           635                    7.51607612428241                MILD       
#>                                                                     6                           730                    7.51607612428241             SEVERE***     
#>                                AB12345-BRA-1-id-265                 1                           48                      10.323346349886              MODERATE     
#>                                                                     2                          200**                    10.323346349886              MODERATE     
#>                                                                     3                           392                     10.323346349886             SEVERE***     
#>                                                                     4                           403                     10.323346349886               SEVERE      
#>             NA                 AB12345-BRA-1-id-134                 1                           251                    6.46299057842479              MODERATE     
#>                                                                     2                           304                    6.46299057842479              MODERATE     
#>                                 AB12345-BRA-1-id-42                 1                          39**                    2.26753940777848              MODERATE     
#>                                                                     2                           65                     2.26753940777848             SEVERE***
```

Referential footnotes can also be added to column header labels. Suppose
we want to add our fourth referential footnote to the `USUBJID` column
label. We can do so by editing the `USUBJID` variable label and adding
the footnote text as follows:

``` r
# Modify data variable label
adae <- adae %>% var_relabel(
  USUBJID = paste0(var_labels(adae)[["USUBJID"]], "****")
)

# Generate listing
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASTDY", "ASEQ"),
  disp_cols = c("BMRKR1", "AESEV")
)

lsting
#> Description of Planned Arm   Unique Subject Identifier****   Analysis Start Relative Day   Analysis Sequence Number   Continous Level Biomarker 1   Severity/Intensity
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>         A: Drug X                AB12345-BRA-1-id-134                    497                          3                    6.46299057842479              MODERATE     
#>                                                                         608**                         4                    6.46299057842479              MODERATE     
#>                                   AB12345-BRA-1-id-42                   95**                          3                    2.26753940777848              MODERATE     
#>                                                                         160**                         4                    2.26753940777848              MODERATE     
#>                                                                          292                          5                    2.26753940777848                MILD       
#>                                                                          460                          6                    2.26753940777848              MODERATE     
#>                                                                          470                          7                    2.26753940777848             SEVERE***     
#>                                                                          476                          8                    2.26753940777848              MODERATE     
#>                                                                          497                          9                    2.26753940777848               SEVERE      
#>                                                                          642                          10                   2.26753940777848             SEVERE***     
#>         B: Placebo               AB12345-BRA-1-id-236                    22                           1                    7.66300121077566             SEVERE***     
#>                                                                          181                          2                    7.66300121077566             SEVERE***     
#>                                                                          702                          3                    7.66300121077566             SEVERE***     
#>                                   AB12345-BRA-1-id-65                    145                          1                    7.34091885189189              MODERATE     
#>                                                                         191**                         2                    7.34091885189189                MILD       
#>                                                                          233                          3                    7.34091885189189             SEVERE***     
#>       C: Combination             AB12345-BRA-1-id-141                    259                          1                    7.51607612428241              MODERATE     
#>                                                                         303**                         2                    7.51607612428241                MILD       
#>                                                                         493**                         3                    7.51607612428241                MILD       
#>                                                                          600                          4                    7.51607612428241              MODERATE     
#>                                                                          635                          5                    7.51607612428241                MILD       
#>                                                                          730                          6                    7.51607612428241             SEVERE***     
#>                                  AB12345-BRA-1-id-265                    48                           1                     10.323346349886              MODERATE     
#>                                                                         200**                         2                     10.323346349886              MODERATE     
#>                                                                          392                          3                     10.323346349886             SEVERE***     
#>                                                                          403                          4                     10.323346349886               SEVERE      
#>             NA                   AB12345-BRA-1-id-134                    251                          1                    6.46299057842479              MODERATE     
#>                                                                          304                          2                    6.46299057842479              MODERATE     
#>                                   AB12345-BRA-1-id-42                   39**                          1                    2.26753940777848              MODERATE     
#>                                                                          65                           2                    2.26753940777848             SEVERE***
```

Finally, we add in the referential footnote text below the listing as
follows.

``` r
# Generate listing
lsting <- as_listing(
  df = adae,
  key_cols = c("ARM", "USUBJID", "ASTDY", "ASEQ"),
  disp_cols = c("BMRKR1", "AESEV")
)

main_footer(lsting) <- c(main_footer(lsting), ref_fns)

lsting
#> Description of Planned Arm   Unique Subject Identifier****   Analysis Start Relative Day   Analysis Sequence Number   Continous Level Biomarker 1   Severity/Intensity
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>         A: Drug X                AB12345-BRA-1-id-134                    497                          3                    6.46299057842479              MODERATE     
#>                                                                         608**                         4                    6.46299057842479              MODERATE     
#>                                   AB12345-BRA-1-id-42                   95**                          3                    2.26753940777848              MODERATE     
#>                                                                         160**                         4                    2.26753940777848              MODERATE     
#>                                                                          292                          5                    2.26753940777848                MILD       
#>                                                                          460                          6                    2.26753940777848              MODERATE     
#>                                                                          470                          7                    2.26753940777848             SEVERE***     
#>                                                                          476                          8                    2.26753940777848              MODERATE     
#>                                                                          497                          9                    2.26753940777848               SEVERE      
#>                                                                          642                          10                   2.26753940777848             SEVERE***     
#>         B: Placebo               AB12345-BRA-1-id-236                    22                           1                    7.66300121077566             SEVERE***     
#>                                                                          181                          2                    7.66300121077566             SEVERE***     
#>                                                                          702                          3                    7.66300121077566             SEVERE***     
#>                                   AB12345-BRA-1-id-65                    145                          1                    7.34091885189189              MODERATE     
#>                                                                         191**                         2                    7.34091885189189                MILD       
#>                                                                          233                          3                    7.34091885189189             SEVERE***     
#>       C: Combination             AB12345-BRA-1-id-141                    259                          1                    7.51607612428241              MODERATE     
#>                                                                         303**                         2                    7.51607612428241                MILD       
#>                                                                         493**                         3                    7.51607612428241                MILD       
#>                                                                          600                          4                    7.51607612428241              MODERATE     
#>                                                                          635                          5                    7.51607612428241                MILD       
#>                                                                          730                          6                    7.51607612428241             SEVERE***     
#>                                  AB12345-BRA-1-id-265                    48                           1                     10.323346349886              MODERATE     
#>                                                                         200**                         2                     10.323346349886              MODERATE     
#>                                                                          392                          3                     10.323346349886             SEVERE***     
#>                                                                          403                          4                     10.323346349886               SEVERE      
#>             NA                   AB12345-BRA-1-id-134                    251                          1                    6.46299057842479              MODERATE     
#>                                                                          304                          2                    6.46299057842479              MODERATE     
#>                                   AB12345-BRA-1-id-42                   39**                          1                    2.26753940777848              MODERATE     
#>                                                                          65                           2                    2.26753940777848             SEVERE***     
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> *   ASEQ 1 or 2
#> **  Analysis start date is imputed
#> ***  Records with ATOXGR = 5
#> **** ID column
```

Now our listing is complete, with all four referential footnotes denoted
within the listing and described in the footnotes section below.

------------------------------------------------------------------------

## Summary

In this vignette, you have learned how a pre-processing workaround can
be applied to add referential footnotes to listings.

**For more information please explore the [rlistings
website](https://insightsengineering.github.io/rlistings/main/).**
