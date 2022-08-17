## listings var labels don't get mucked up by topleft machinery #262
    anl <- ex_adsl
    anl <- anl[1:10, c("USUBJID", "ARM", "BMRKR1")]
    anl <- var_relabel(anl,
            USUBJID = "Unique\nSubject\nIdentifier",
            ARM = "Description\nOf\nPlanned Arm"
            )

    lsting <- as_listing(anl, key_cols = c("USUBJID")) %>%
        add_listing_col("ARM")
    expect_identical(var_labels(anl), var_labels(lsting))

    matform <- matrix_form(lsting)
    expect_identical(matform$strings[1:3, 1, drop = TRUE],
                     c("Unique", "Subject", "Identifier"))



anl <- ex_adsl %>%
    select(USUBJID, ARM, BMRKR1) %>%
    slice(1:10)

anl$BMRKR1[1:3] <- NA

                                        # (1) Error with NA values in numeric column when apply format
lsting <- as_listing(anl, key_cols = c("ARM", "USUBJID")) %>%
    add_listing_col("ARM") %>%
    add_listing_col("USUBJID") %>%
    add_listing_col("BMRKR1", format = "xx.xx")

mat <- matrix_form(lsting)
expect_identical(unname(mat$strings[2,3, drop = TRUE]),
                 "NA")
