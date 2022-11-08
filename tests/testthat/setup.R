library(dplyr)

## listings var labels don't get mucked up by topleft machinery #262
anl <- ex_adsl
anl <- anl[1:10, c("USUBJID", "ARM", "BMRKR1")]
anl <- var_relabel(anl,
  USUBJID = "Unique\nSubject\nIdentifier",
  ARM = "Description\nOf\nPlanned Arm"
)
