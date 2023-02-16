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

  testthat::expect_message(as_listing(
    dsl01,
    disp_cols = names(dsl01),
    main_title = "Listing of Patients with Study Drug Withdrawn Due to Adverse Events",
    subtitles = "Population: All Patients",
    main_footer = c("Program: xxxx", "Output: xxxx"),
    prov_footer = "Page 1 of 1"
  ), "sorting incoming data by key columns")

  result <- as_listing(
    dsl01,
    disp_cols = names(dsl01),
    main_title = "Listing of Patients with Study Drug Withdrawn Due to Adverse Events",
    subtitles = "Population: All Patients",
    main_footer = c("Program: xxxx", "Output: xxxx"),
    prov_footer = "Page 1 of 1"
  )
  testthat::expect_snapshot(result)

  # Test DSL01 headers/footers
  expected_main_title <- "Listing of Patients with Study Drug Withdrawn Due to Adverse Events"
  expected_subtitles <- "Population: All Patients"
  expected_main_footer <- c("Program: xxxx", "Output: xxxx")
  expected_prov_footer <- "Page 1 of 1"

  testthat::expect_identical(main_title(result), expected_main_title)
  testthat::expect_identical(subtitles(result), expected_subtitles)
  testthat::expect_identical(main_footer(result), expected_main_footer)
  testthat::expect_identical(prov_footer(result), expected_prov_footer)
})
