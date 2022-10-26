library(dplyr)

testthat::test_that("DSL02 is produced correctly", {
  result <- formatters::ex_adsl %>%
    mutate(
      ID = paste(SITEID, SUBJID, sep = "/"),
      ASR = paste(AGE, SEX, RACE, sep = "/"),
      DISCONT = ifelse(!is.na(DCSREAS) & EOSSTT != "COMPLETED", "Yes", "No"),
      SSADTM = as.POSIXct(
        strftime(TRTSDTM, format = "%Y-%m-%d %H:%M:%S"),
        format = "%Y-%m-%d",
        tz = "UTC"),
      SSAEDY = as.numeric(ceiling(difftime(EOSDT, SSADTM, units = "days"))),
      RANDEDY = as.numeric(ceiling(difftime(EOSDT, RANDDT, units = "days"))),
    ) %>%
    filter(DISCONT == "Yes") %>%
    select(ID, ASR, ARMCD, SSADTM, EOSDY, SSAEDY, RANDEDY, DCSREAS)

  formatters::var_labels(result) <- c(
    ID = "Center/Patient ID",
    ASR = "Age/Sex/Race",
    ARMCD = "Treatment",
    SSADTM = "Date of First\nStudy Drug\nAdministration",
    EOSDY = "Day of Last\nStudy Drug\nAdministration",
    SSAEDY = "Day of Study\nDiscontinuation\nRelative to First\nStudy Drug\nAdministration",
    RANDEDY = "Day of Study\nDiscontinuation\nRelative to\nRandomization",
    DCSREAS = "Reason for\nDiscontinuation"
  )

  lsting <- as_listing(
    result,
    cols = names(result),
    main_title = "Listing of Patients Who Discontinued Early from Study"
  )

  result_matrix <- matrix_form(head(lsting, 10))
  expected_title <- "Listing of Patients Who Discontinued Early from Study"
  expected_table <- structure(
    c(
      "", "", "", "", "Center/Patient ID", "BRA-1/id-105", "BRA-1/id-265", "BRA-1/id-93", "BRA-11/id-237",
      "BRA-2/id-296", "CAN-1/id-341", "CAN-14/id-104", "CHN-1/id-156", "CHN-1/id-163", "CHN-1/id-199", "", "", "", "",
      "Age/Sex/Race", "38/M/BLACK OR AFRICAN AMERICAN", "25/M/WHITE", "34/F/ASIAN", "64/F/ASIAN", "44/F/ASIAN",
      "43/F/ASIAN", "39/F/BLACK OR AFRICAN AMERICAN", "32/F/ASIAN", "41/F/ASIAN", "27/M/BLACK OR AFRICAN AMERICAN", "",
      "", "", "", "Treatment", "ARM A", "ARM C", "ARM A", "ARM C", "ARM A", "ARM B", "ARM A", "ARM B", "ARM B",
      "ARM A", "", "", "Date of First", "Study Drug", "Administration", "2020-10-12", "2020-05-13", "2021-01-24",
      "2020-10-15", "2021-08-28", "2019-12-27", "2020-02-01", "2021-04-12", "2020-12-31", "2020-08-14", "", "",
      "Day of Last", "Study Drug", "Administration", "347", "493", "244", "338", "28", "636", "602", "165", "265",
      "405", "Day of Study", "Discontinuation", "Relative to First", "Study Drug", "Administration", "347", "494",
      "243", "339", "27", "635", "602", "165", "265", "404", "", "Day of Study", "Discontinuation", "Relative to",
      "Randomization", "347", "497", "246", "338", "30", "638", "604", "166", "265", "405", "", "", "", "Reason for",
      "Discontinuation", "WITHDRAWAL BY PARENT/GUARDIAN", "WITHDRAWAL BY PARENT/GUARDIAN", "ADVERSE EVENT",
      "PROTOCOL VIOLATION", "WITHDRAWAL BY SUBJECT", "ADVERSE EVENT", "PROTOCOL VIOLATION", "PHYSICIAN DECISION",
      "PROTOCOL VIOLATION", "LACK OF EFFICACY"
    ),
    .Dim = c(15L, 8L)
  )
  testthat::expect_identical(result_matrix$main_title, expected_title)
  testthat::expect_identical(result_matrix$strings, expected_table)
})
