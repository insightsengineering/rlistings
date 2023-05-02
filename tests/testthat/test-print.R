testthat::test_that("Listing print correctly", {
  lsting <- as_listing(anl, key_cols = c("USUBJID")) %>%
    add_listing_col("ARM")

  res <- strsplit(toString(matrix_form(lsting), hsep = "-"), "\\n")[[1]]
  exp <- c(
    "       Unique            Description                                ",
    "       Subject                Of                                    ",
    "     Identifier          Planned Arm     Continous Level Biomarker 1",
    "--------------------------------------------------------------------",
    "AB12345-CHN-1-id-307      B: Placebo          4.57499101339464      ",
    "AB12345-CHN-11-id-220     B: Placebo          10.2627340069523      ",
    "AB12345-CHN-15-id-201   C: Combination         6.9067988141075      ",
    "AB12345-CHN-15-id-262   C: Combination        4.05546277230382      ",
    "AB12345-CHN-3-id-128      A: Drug X            14.424933692778      ",
    "AB12345-CHN-7-id-267      B: Placebo           6.2067627167943      ",
    "AB12345-NGA-11-id-173   C: Combination        4.99722573047567      ",
    "AB12345-RUS-3-id-378    C: Combination        2.80323956920649      ",
    "AB12345-USA-1-id-261      B: Placebo          2.85516419937308      ",
    "AB12345-USA-1-id-45       A: Drug X           0.463560441314472     "
  )

  testthat::expect_identical(res, exp)
})

testthat::test_that("Listing print correctly with different widths", {
  lsting <- as_listing(anl, key_cols = c("USUBJID")) %>%
    add_listing_col("ARM")

  res <- strsplit(toString(matrix_form(lsting), widths = c(7, 8, 9), hsep = "-"), "\\n")[[1]]
  res2 <- strsplit(toString(lsting, widths = c(7, 8, 9), hsep = "-"), "\\n")[[1]]

  exp <- c(
    "          Descript            ",
    "Unique      ion               ",
    "Subject      Of               ",
    "Identif   Planned    Continous",
    "  ier       Arm        Level  ",
    "                     Biomarker",
    "                         1    ",
    "------------------------------",
    "AB12345      B:      4.5749910",
    "-CHN-1-   Placebo     1339464 ",
    "id-307                        ",
    "AB12345      B:      10.262734",
    "-CHN-11   Placebo     0069523 ",
    "-id-220                       ",
    "AB12345   C: Combi   6.9067988",
    "-CHN-15    nation     141075  ",
    "-id-201                       ",
    "AB12345   C: Combi   4.0554627",
    "-CHN-15    nation     7230382 ",
    "-id-262                       ",
    "AB12345   A: Drug    14.424933",
    "-CHN-3-      X        692778  ",
    "id-128                        ",
    "AB12345      B:      6.2067627",
    "-CHN-7-   Placebo     167943  ",
    "id-267                        ",
    "AB12345   C: Combi   4.9972257",
    "-NGA-11    nation     3047567 ",
    "-id-173                       ",
    "AB12345   C: Combi   2.8032395",
    "-RUS-3-    nation     6920649 ",
    "id-378                        ",
    "AB12345      B:      2.8551641",
    "-USA-1-   Placebo     9937308 ",
    "id-261                        ",
    "AB12345   A: Drug    0.4635604",
    "-USA-1-      X       41314472 ",
    "id-45                         "
  )

  testthat::expect_identical(res, res2)
  testthat::expect_identical(res, exp)
  testthat::expect_identical(res2, exp)
})
