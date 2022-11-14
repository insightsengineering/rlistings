testthat::test_that("DSL01 listing is produced correctly", {
  dsl01 <- ex_adsl %>%
    mutate(
      ID = paste(SITEID, SUBJID, sep = "/"),
      ASR = paste(AGE, SEX, RACE, sep = "/"),
      SSADM = toupper(format(as.Date(TRTSDTM), format = "%d%b%Y")),
      STDWD = as.numeric(ceiling(difftime(TRTEDTM, TRTSDTM, units = "days"))),
      DISCONT = ifelse(!is.na(DCSREAS) & toupper(EOSSTT) == "DISCONTINUED", "Yes", "No")
    ) %>%
    select(ID, ASR, ARMCD, SSADM, STDWD, DISCONT)

  formatters::var_labels(dsl01) <- c(
    ID = "Center/Patient ID",
    ASR = "Age/Sex/Race",
    ARMCD = "Treatment",
    SSADM = "Date of First\nStudy Drug\nAdministration",
    STDWD = "Study Day\nof Withdrawal",
    DISCONT = "Discontinued\nEarly from Study?"
  )

  result <- testthat::expect_message(as_listing(
    dsl01,
    cols = names(dsl01),
    main_title = "Listing of Patients with Study Drug Withdrawn Due to Adverse Events",
    subtitles = "Population: All Patients",
    main_footer = c("Program: xxxx", "Output: xxxx"),
    prov_footer = "Page 1 of 1"
  ), "sorting incoming data by key columns")
  result_matrix <- matrix_form(head(result, 10))

  # Test DSL01 listing contents
  expected_strings <- matrix(
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
    nrow = 13
  )
  testthat::expect_identical(mf_strings(result_matrix), expected_strings)

  # Test DSL01 headers/footers
  expected_main_title <- "Listing of Patients with Study Drug Withdrawn Due to Adverse Events"
  expected_subtitles <- "Population: All Patients"
  expected_main_footer <- c("Program: xxxx", "Output: xxxx")
  expected_prov_footer <- "Page 1 of 1"

  testthat::expect_identical(main_title(result), expected_main_title)
  testthat::expect_identical(subtitles(result), expected_subtitles)
  testthat::expect_identical(main_footer(result), expected_main_footer)
  testthat::expect_identical(prov_footer(result), expected_prov_footer)

  # Test DSL01 attributes
  expected_rfnotes <- list()
  expected_nlheader <- 3
  expected_nrheader <- 1

  testthat::expect_identical(mf_rfnotes(result_matrix), expected_rfnotes)
  testthat::expect_equal(mf_nlheader(result_matrix), expected_nlheader)
  testthat::expect_equal(mf_nrheader(result_matrix), expected_nrheader)
})
