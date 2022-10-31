# rlistings

[![WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

## Listings with R

The `rlistings` R package is a package that was designed to create and display listings with R. The focus of this package is to provide functionality for value formatting and ASCII rendering infrastructure for tables and listings. Many of the functions contained in `rlistings` depend on the [`formatters`](https://insightsengineering.github.io/formatters/) package, which provides a framework for ASCII rendering and is available on CRAN.

`rlistings` development is driven by the need to create regulatory ready listings for health authority review. Some of the key requirements for this undertaking are listed below:

- flexible formatting (pagesize, column widths, alignment, labels, etc.)
- multiple output formats (csv, out, txt)
- repeated key columns
- flexible pagination in both horizontal and vertical directions
- titles and footnotes

`rlistings` currently covers some of these requirements, and remains under active development.

## Installation

For releases from October 2022 it is recommended that you [create and use a Github PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to install the latest version of this package. Once you have the PAT, run the following:

```r
Sys.setenv(GITHUB_PAT = "your_access_token_here")
if (!require("remotes")) install.packages("remotes")
remotes::install_github("insightsengineering/rlistings@*release")
```

The `rlistings` package was not a part of the October 2022 stable release of all `NEST` packages, but the list of these `NEST` packages is available [here](https://github.com/insightsengineering/depository#readme).

See [the Get started page](https://insightsengineering.github.io/rlistings/main/articles/rlistings.html) for an introduction to creating listings using this package.

## Acknowledgment

This package is a result of a joint effort by many developers and stakeholders. We would like to thank everyone who contributed so far!

## Stargazers and Forkers

### Stargazers over time

[![Stargazers over time](https://starchart.cc/insightsengineering/rlistings.svg)](https://starchart.cc/insightsengineering/rlistings)

### Stargazers

[![Stargazers repo roster for @insightsengineering/rlistings](https://reporoster.com/stars/insightsengineering/rlistings)](https://github.com/insightsengineering/rlistings/stargazers)

[![Forkers repo roster for @insightsengineering/rlistings](https://reporoster.com/forks/insightsengineering/rlistings)](https://github.com/insightsengineering/rlistings/network/members)
