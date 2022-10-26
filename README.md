# rlistings

## Creating listings with R

The `rlistings` R package is an experimental packages that was designed to create and display listings with R. The focus of this package is to provide functionality for value formatting and ASCII rendering infrastructure for tables and listings. Many of the functions contained in `rlistings` depend on the [`formatters`](https://insightsengineering.github.io/formatters/) package, which provides a framework for ASCII rendering and is available on CRAN.

## Installation

For releases from October 2022 it is recommended that you [create and use a Github PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to install the latest version of this package. Once you have the PAT, run the following:

```r
Sys.setenv(GITHUB_PAT = "your_access_token_here")
if (!require("remotes")) install.packages("remotes")
remotes::install_github("insightsengineering/rlistings@*release")
```

The `rlistings` package is experimental and was not a part of the October 2022 stable release of all `NEST` packages, but the list of these `NEST` packages is available [here](https://github.com/insightsengineering/depository#readme).

See package vignettes `browseVignettes(package = "rlistings")` for usage of this package.
