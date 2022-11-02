library(dplyr)

result <- formatters::ex_adsl %>%
  mutate(
    ID = paste(SITEID, SUBJID, sep = "/"),
    ASR = paste(AGE, SEX, RACE, sep = "/"),
    DISCONT = ifelse(!is.na(DCSREAS) & EOSSTT != "COMPLETED", "Yes", "No"),
    SSADTM = as.POSIXct(
      strftime(TRTSDTM, format = "%Y-%m-%d %H:%M:%S"),
      format = "%Y-%m-%d",
      tz = "UTC"
    ),
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

testthat::test_that("DSL02 listing is produced correctly", {
  lsting <- testthat::expect_message(as_listing(
    result,
    cols = names(result),
    main_title = "Listing of Patients Who Discontinued Early from Study"
  ), "sorting incoming data by key columns")

  result_matrix <- matrix_form(head(lsting, 10))
  expected_strings <- structure(
    c(
      "", "", "", "", "Center/Patient ID", "BRA-1/id-105", "BRA-1/id-265", "BRA-1/id-93", "BRA-11/id-237",
      "BRA-2/id-296", "CAN-1/id-341", "CAN-14/id-104", "CHN-1/id-156", "CHN-1/id-163", "CHN-1/id-199", "", "", "", "",
      "Age/Sex/Race", "38/M/BLACK OR AFRICAN AMERICAN", "25/M/WHITE", "34/F/ASIAN", "64/F/ASIAN", "44/F/ASIAN",
      "43/F/ASIAN", "39/F/BLACK OR AFRICAN AMERICAN", "32/F/ASIAN", "41/F/ASIAN", "27/M/BLACK OR AFRICAN AMERICAN", "",
      "", "", "", "Treatment", "ARM A", "ARM C", "ARM A", "ARM C", "ARM A", "ARM B", "ARM A", "ARM B", "ARM B",
      "ARM A", "", "", "Date of First", "Study Drug", "Administration", "2020-10-12", "2020-05-13", "2021-01-24",
      "2020-10-15", "2021-08-28", "2019-12-27", "2020-02-01", "2021-04-12", "2020-12-31", "2020-08-14", "", "",
      "Day of Last", "Study Drug", "Administration", "347", "494", "244", "339", "28", "636", "602", "165", "265",
      "405", "Day of Study", "Discontinuation", "Relative to First", "Study Drug", "Administration", "347", "493",
      "243", "338", "27", "635", "602", "165", "265", "404", "", "Day of Study", "Discontinuation", "Relative to",
      "Randomization", "347", "497", "246", "338", "30", "638", "604", "166", "265", "405", "", "", "", "Reason for",
      "Discontinuation", "WITHDRAWAL BY PARENT/GUARDIAN", "WITHDRAWAL BY PARENT/GUARDIAN", "ADVERSE EVENT",
      "PROTOCOL VIOLATION", "WITHDRAWAL BY SUBJECT", "ADVERSE EVENT", "PROTOCOL VIOLATION", "PHYSICIAN DECISION",
      "PROTOCOL VIOLATION", "LACK OF EFFICACY"
    ),
    .Dim = c(15L, 8L)
  )
  testthat::expect_identical(result_matrix$strings, expected_strings)
})

testthat::test_that("DSL02 titles/footers are produced correctly", {
  lsting <- as_listing(
    result,
    cols = names(result),
    main_title = "Listing of Patients Who Discontinued Early from Study"
  )

  result_matrix <- matrix_form(head(lsting, 10))
  expected_ref_footnotes <- list()
  expected_main_title <- "Listing of Patients Who Discontinued Early from Study"
  expected_subtitles <- character(0)
  expected_page_titles <- NULL
  expected_main_footer <- character(0)
  expected_prov_footer <- character(0)

  testthat::expect_identical(result_matrix$ref_footnotes, expected_ref_footnotes)
  testthat::expect_identical(result_matrix$main_title, expected_main_title)
  testthat::expect_identical(result_matrix$subtitles, expected_subtitles)
  testthat::expect_identical(result_matrix$page_titles, expected_page_titles)
  testthat::expect_identical(result_matrix$main_footer, expected_main_footer)
  testthat::expect_identical(result_matrix$prov_footer, expected_prov_footer)
})

testthat::test_that("DSL02 attributes are correct", {
  lsting <- as_listing(
    result,
    cols = names(result),
    main_title = "Listing of Patients Who Discontinued Early from Study"
  )

  result_matrix <- matrix_form(head(lsting, 10))
  expected_nlines_header <- 5
  expected_nrow_header <- 1
  expected_ncols <- 8
  expected_class <- c("MatrixPrintForm", "list")

  testthat::expect_equal(attr(result_matrix, "nlines_header"), expected_nlines_header)
  testthat::expect_equal(attr(result_matrix, "nrow_header"), expected_nrow_header)
  testthat::expect_equal(attr(result_matrix, "ncols"), expected_ncols)
  testthat::expect_s3_class(result_matrix, c("MatrixPrintForm", "list"))
})
