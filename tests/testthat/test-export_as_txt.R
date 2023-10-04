testthat::test_that("export_as_txt works", {

  dat <- ex_adae
  # To check that both key columns formats are retained across page break.
  dat$AESOC[dat$USUBJID == "AB12345-BRA-1-id-42" & dat$AESOC == "cl B"] <- "cl A"

  lsting <- suppressMessages(
    as_listing(dat[1:25, c(1:6, 40)],
               key_cols = c("USUBJID", "AESOC"),
               main_title = "Example Title for Listing",
               subtitles = "This is the subtitle for this Adverse Events Table",
               main_footer = "Main footer for the listing",
               prov_footer = c(
                 "You can even add a subfooter", "Second element is place on a new line",
                 "Third string"
              ))
  )
  pages_listings <- export_as_txt(lsting, file = NULL, paginate = TRUE, lpp = 33, cpp = 550, min_siblings = 1)
  testthat::expect_snapshot(cat(pages_listings))
})
