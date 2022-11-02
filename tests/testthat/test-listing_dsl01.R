library(dplyr)

result <- formatters::ex_adsl %>%
  mutate(
    ID = paste(SITEID, SUBJID, sep = "/"),
    ASR = paste(AGE, SEX, RACE, sep = "/"),
    SSADM = toupper(format(as.Date(TRTSDTM), format = "%d%b%Y")),
    STDWD = as.numeric(ceiling(difftime(TRTEDTM, TRTSDTM, units = "days"))),
    DISCONT = ifelse(!is.na(DCSREAS) & toupper(EOSSTT) == "DISCONTINUED", "Yes", "No")
  ) %>%
  select(ID, ASR, ARMCD, SSADM, STDWD, DISCONT)

formatters::var_labels(result) <- c(
  ID = "Center/Patient ID",
  ASR = "Age/Sex/Race",
  ARMCD = "Treatment",
  SSADM = "Date of First\nStudy Drug\nAdministration",
  STDWD = "Study Day\nof Withdrawal",
  DISCONT = "Discontinued\nEarly from Study?"
)

testthat::test_that("DSL01 listing is produced correctly", {
  lsting <- testthat::expect_message(as_listing(
    result,
    cols = names(result),
    main_title = "Listing of Patients with Study Drug Withdrawn Due to Adverse Events"
  ), "sorting incoming data by key columns")

  result_matrix <- matrix_form(head(lsting, 10))
  expected_strings <- structure(
    c(
      "", "", "Center/Patient ID", "BRA-1/id-105", "BRA-1/id-134", "BRA-1/id-141", "BRA-1/id-236", "BRA-1/id-265",
      "BRA-1/id-42", "BRA-1/id-65", "BRA-1/id-93", "BRA-11/id-171", "BRA-11/id-217", "", "", "Age/Sex/Race",
      "38/M/BLACK OR AFRICAN AMERICAN", "47/M/WHITE", "35/F/WHITE", "32/M/BLACK OR AFRICAN AMERICAN", "25/M/WHITE",
      "36/M/BLACK OR AFRICAN AMERICAN", "25/F/BLACK OR AFRICAN AMERICAN", "34/F/ASIAN", "40/F/ASIAN", "43/M/ASIAN",
      "", "", "Treatment", "ARM A", "ARM A", "ARM C", "ARM B", "ARM C", "ARM A", "ARM B", "ARM A", "ARM C", "ARM A",
      "Date of First", "Study Drug", "Administration", "12OCT2020", "10JUN2021", "28FEB2021", "21AUG2021", "13MAY2020",
      "07AUG2020", "18FEB2020", "24JAN2021", "08JUL2020", "03MAY2020", "", "Study Day", "of Withdrawal", "347", "731",
      "731", "731", "494", "NA", "731", "244", "NA", "NA", "", "Discontinued", "Early from Study?", "Yes", "No", "No",
      "No", "Yes", "No", "No", "Yes", "No", "No"
    ),
    .Dim = c(13L, 6L)
  )

  testthat::expect_identical(result_matrix$strings, expected_strings)
})

testthat::test_that("DSL01 titles/footers are produced correctly", {
  lsting <- as_listing(
    result,
    cols = names(result),
    main_title = "Listing of Patients with Study Drug Withdrawn Due to Adverse Events"
  )

  result_matrix <- matrix_form(head(lsting, 10))
  expected_ref_footnotes <- list()
  expected_main_title <- "Listing of Patients with Study Drug Withdrawn Due to Adverse Events"
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

testthat::test_that("DSL01 attributes are correct", {
  lsting <- as_listing(
    result,
    cols = names(result),
    main_title = "Listing of Patients with Study Drug Withdrawn Due to Adverse Events"
  )

  result_matrix <- matrix_form(head(lsting, 10))
  expected_nlines_header <- 3
  expected_nrow_header <- 1
  expected_ncols <- 6
  expected_class <- c("MatrixPrintForm", "list")

  testthat::expect_equal(attr(result_matrix, "nlines_header"), expected_nlines_header)
  testthat::expect_equal(attr(result_matrix, "nrow_header"), expected_nrow_header)
  testthat::expect_equal(attr(result_matrix, "ncols"), expected_ncols)
  testthat::expect_s3_class(result_matrix, c("MatrixPrintForm", "list"))
})
