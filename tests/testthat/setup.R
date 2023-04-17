library(dplyr)

anl <- ex_adsl
anl <- anl[1:10, c("USUBJID", "ARM", "BMRKR1")]
anl <- var_relabel(anl,
  USUBJID = "Unique\nSubject\nIdentifier",
  ARM = "Description\nOf\nPlanned Arm"
)

# Helper function used in pagination tests
h_lsting_adae <- function(disp_cols = c("USUBJID", "AESOC", "RACE", "AETOXGR", "BMRKR1")) {
  as_listing(ex_adae[1:25, ], disp_cols = disp_cols)
}
