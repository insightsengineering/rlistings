# Objects exported from other packages

These objects are imported from other packages. Follow the links below
to see their documentation.

- formatters:

  [`export_as_txt`](https://insightsengineering.github.io/formatters/latest-tag/reference/export_as_txt.html)

## Examples

``` r
dat <- ex_adae

lsting <- as_listing(dat[1:25, ], key_cols = c("USUBJID", "AESOC")) %>%
  add_listing_col("AETOXGR") %>%
  add_listing_col("BMRKR1", format = "xx.x") %>%
  add_listing_col("AESER / AREL", fun = function(df) paste(df$AESER, df$AREL, sep = " / "))
main_title(lsting) <- "this is some title"
main_footer(lsting) <- "this is some footer"

cat(export_as_txt(lsting, file = NULL, paginate = TRUE))
#> this is some title
#> 
#> —————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Study Identifier
#> —————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                  AB12345     
#>                                                              AB12345     
#>                                        cl B                  AB12345     
#>                                        cl D                  AB12345     
#>   AB12345-BRA-1-id-141                 cl A                  AB12345     
#>                                                              AB12345     
#>                                                              AB12345     
#>                                        cl B                  AB12345     
#>                                        cl D                  AB12345     
#>                                                              AB12345     
#>   AB12345-BRA-1-id-236                 cl B                  AB12345     
#>                                                              AB12345     
#>                                                              AB12345     
#>   AB12345-BRA-1-id-265                 cl C                  AB12345     
#>                                                              AB12345     
#>                                        cl D                  AB12345     
#>                                                              AB12345     
#>    AB12345-BRA-1-id-42                 cl A                  AB12345     
#>                                                              AB12345     
#>                                                              AB12345     
#>                                        cl B                  AB12345     
#>                                                              AB12345     
#>                                        cl C                  AB12345     
#>                                                              AB12345     
#>                                        cl D                  AB12345     
#> —————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> —————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Subject Identifier for the Study
#> —————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                           id-134             
#>                                                                       id-134             
#>                                        cl B                           id-134             
#>                                        cl D                           id-134             
#>   AB12345-BRA-1-id-141                 cl A                           id-141             
#>                                                                       id-141             
#>                                                                       id-141             
#>                                        cl B                           id-141             
#>                                        cl D                           id-141             
#>                                                                       id-141             
#>   AB12345-BRA-1-id-236                 cl B                           id-236             
#>                                                                       id-236             
#>                                                                       id-236             
#>   AB12345-BRA-1-id-265                 cl C                           id-265             
#>                                                                       id-265             
#>                                        cl D                           id-265             
#>                                                                       id-265             
#>    AB12345-BRA-1-id-42                 cl A                           id-42              
#>                                                                       id-42              
#>                                                                       id-42              
#>                                        cl B                           id-42              
#>                                                                       id-42              
#>                                        cl C                           id-42              
#>                                                                       id-42              
#>                                        cl D                           id-42              
#> —————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ——————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Study Site Identifier   Age   Sex
#> ——————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                      BRA-1           47     M 
#>                                                                  BRA-1           47     M 
#>                                        cl B                      BRA-1           47     M 
#>                                        cl D                      BRA-1           47     M 
#>   AB12345-BRA-1-id-141                 cl A                      BRA-1           35     F 
#>                                                                  BRA-1           35     F 
#>                                                                  BRA-1           35     F 
#>                                        cl B                      BRA-1           35     F 
#>                                        cl D                      BRA-1           35     F 
#>                                                                  BRA-1           35     F 
#>   AB12345-BRA-1-id-236                 cl B                      BRA-1           32     M 
#>                                                                  BRA-1           32     M 
#>                                                                  BRA-1           32     M 
#>   AB12345-BRA-1-id-265                 cl C                      BRA-1           25     M 
#>                                                                  BRA-1           25     M 
#>                                        cl D                      BRA-1           25     M 
#>                                                                  BRA-1           25     M 
#>    AB12345-BRA-1-id-42                 cl A                      BRA-1           36     M 
#>                                                                  BRA-1           36     M 
#>                                                                  BRA-1           36     M 
#>                                        cl B                      BRA-1           36     M 
#>                                                                  BRA-1           36     M 
#>                                        cl C                      BRA-1           36     M 
#>                                                                  BRA-1           36     M 
#>                                        cl D                      BRA-1           36     M 
#> ——————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class             Race              Country
#> ————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                        WHITE               BRA  
#>                                                                    WHITE               BRA  
#>                                        cl B                        WHITE               BRA  
#>                                        cl D                        WHITE               BRA  
#>   AB12345-BRA-1-id-141                 cl A                        WHITE               BRA  
#>                                                                    WHITE               BRA  
#>                                                                    WHITE               BRA  
#>                                        cl B                        WHITE               BRA  
#>                                        cl D                        WHITE               BRA  
#>                                                                    WHITE               BRA  
#>   AB12345-BRA-1-id-236                 cl B              BLACK OR AFRICAN AMERICAN     BRA  
#>                                                          BLACK OR AFRICAN AMERICAN     BRA  
#>                                                          BLACK OR AFRICAN AMERICAN     BRA  
#>   AB12345-BRA-1-id-265                 cl C                        WHITE               BRA  
#>                                                                    WHITE               BRA  
#>                                        cl D                        WHITE               BRA  
#>                                                                    WHITE               BRA  
#>    AB12345-BRA-1-id-42                 cl A              BLACK OR AFRICAN AMERICAN     BRA  
#>                                                          BLACK OR AFRICAN AMERICAN     BRA  
#>                                                          BLACK OR AFRICAN AMERICAN     BRA  
#>                                        cl B              BLACK OR AFRICAN AMERICAN     BRA  
#>                                                          BLACK OR AFRICAN AMERICAN     BRA  
#>                                        cl C              BLACK OR AFRICAN AMERICAN     BRA  
#>                                                          BLACK OR AFRICAN AMERICAN     BRA  
#>                                        cl D              BLACK OR AFRICAN AMERICAN     BRA  
#> ————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Investigator Identifier
#> ————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                       BRA-1         
#>                                                                   BRA-1         
#>                                        cl B                       BRA-1         
#>                                        cl D                       BRA-1         
#>   AB12345-BRA-1-id-141                 cl A                       BRA-1         
#>                                                                   BRA-1         
#>                                                                   BRA-1         
#>                                        cl B                       BRA-1         
#>                                        cl D                       BRA-1         
#>                                                                   BRA-1         
#>   AB12345-BRA-1-id-236                 cl B                       BRA-1         
#>                                                                   BRA-1         
#>                                                                   BRA-1         
#>   AB12345-BRA-1-id-265                 cl C                       BRA-1         
#>                                                                   BRA-1         
#>                                        cl D                       BRA-1         
#>                                                                   BRA-1         
#>    AB12345-BRA-1-id-42                 cl A                       BRA-1         
#>                                                                   BRA-1         
#>                                                                   BRA-1         
#>                                        cl B                       BRA-1         
#>                                                                   BRA-1         
#>                                        cl C                       BRA-1         
#>                                                                   BRA-1         
#>                                        cl D                       BRA-1         
#> ————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Description of Planned Arm   Planned Arm Code
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                      A: Drug X                 ARM A      
#>                                                                  A: Drug X                 ARM A      
#>                                        cl B                      A: Drug X                 ARM A      
#>                                        cl D                      A: Drug X                 ARM A      
#>   AB12345-BRA-1-id-141                 cl A                    C: Combination              ARM C      
#>                                                                C: Combination              ARM C      
#>                                                                C: Combination              ARM C      
#>                                        cl B                    C: Combination              ARM C      
#>                                        cl D                    C: Combination              ARM C      
#>                                                                C: Combination              ARM C      
#>   AB12345-BRA-1-id-236                 cl B                      B: Placebo                ARM B      
#>                                                                  B: Placebo                ARM B      
#>                                                                  B: Placebo                ARM B      
#>   AB12345-BRA-1-id-265                 cl C                    C: Combination              ARM C      
#>                                                                C: Combination              ARM C      
#>                                        cl D                    C: Combination              ARM C      
#>                                                                C: Combination              ARM C      
#>    AB12345-BRA-1-id-42                 cl A                      A: Drug X                 ARM A      
#>                                                                  A: Drug X                 ARM A      
#>                                                                  A: Drug X                 ARM A      
#>                                        cl B                      A: Drug X                 ARM A      
#>                                                                  A: Drug X                 ARM A      
#>                                        cl C                      A: Drug X                 ARM A      
#>                                                                  A: Drug X                 ARM A      
#>                                        cl D                      A: Drug X                 ARM A      
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Description of Actual Arm   Actual Arm Code
#> ————————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                      A: Drug X                ARM A     
#>                                                                  A: Drug X                ARM A     
#>                                        cl B                      A: Drug X                ARM A     
#>                                        cl D                      A: Drug X                ARM A     
#>   AB12345-BRA-1-id-141                 cl A                   C: Combination              ARM C     
#>                                                               C: Combination              ARM C     
#>                                                               C: Combination              ARM C     
#>                                        cl B                   C: Combination              ARM C     
#>                                        cl D                   C: Combination              ARM C     
#>                                                               C: Combination              ARM C     
#>   AB12345-BRA-1-id-236                 cl B                     B: Placebo                ARM B     
#>                                                                 B: Placebo                ARM B     
#>                                                                 B: Placebo                ARM B     
#>   AB12345-BRA-1-id-265                 cl C                   C: Combination              ARM C     
#>                                                               C: Combination              ARM C     
#>                                        cl D                   C: Combination              ARM C     
#>                                                               C: Combination              ARM C     
#>    AB12345-BRA-1-id-42                 cl A                      A: Drug X                ARM A     
#>                                                                  A: Drug X                ARM A     
#>                                                                  A: Drug X                ARM A     
#>                                        cl B                      A: Drug X                ARM A     
#>                                                                  A: Drug X                ARM A     
#>                                        cl C                      A: Drug X                ARM A     
#>                                                                  A: Drug X                ARM A     
#>                                        cl D                      A: Drug X                ARM A     
#> ————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Stratification Factor 1
#> ————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                         B           
#>                                                                     B           
#>                                        cl B                         B           
#>                                        cl D                         B           
#>   AB12345-BRA-1-id-141                 cl A                         B           
#>                                                                     B           
#>                                                                     B           
#>                                        cl B                         B           
#>                                        cl D                         B           
#>                                                                     B           
#>   AB12345-BRA-1-id-236                 cl B                         A           
#>                                                                     A           
#>                                                                     A           
#>   AB12345-BRA-1-id-265                 cl C                         A           
#>                                                                     A           
#>                                        cl D                         A           
#>                                                                     A           
#>    AB12345-BRA-1-id-42                 cl A                         B           
#>                                                                     B           
#>                                                                     B           
#>                                        cl B                         B           
#>                                                                     B           
#>                                        cl C                         B           
#>                                                                     B           
#>                                        cl D                         B           
#> ————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Stratification Factor 2
#> ————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                        S2           
#>                                                                    S2           
#>                                        cl B                        S2           
#>                                        cl D                        S2           
#>   AB12345-BRA-1-id-141                 cl A                        S1           
#>                                                                    S1           
#>                                                                    S1           
#>                                        cl B                        S1           
#>                                        cl D                        S1           
#>                                                                    S1           
#>   AB12345-BRA-1-id-236                 cl B                        S2           
#>                                                                    S2           
#>                                                                    S2           
#>   AB12345-BRA-1-id-265                 cl C                        S2           
#>                                                                    S2           
#>                                        cl D                        S2           
#>                                                                    S2           
#>    AB12345-BRA-1-id-42                 cl A                        S1           
#>                                                                    S1           
#>                                                                    S1           
#>                                        cl B                        S1           
#>                                                                    S1           
#>                                        cl C                        S1           
#>                                                                    S1           
#>                                        cl D                        S1           
#> ————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Continous Level Biomarker 1
#> ————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A              6.5                        
#>                                                          6.5                        
#>                                        cl B              6.5                        
#>                                        cl D              6.5                        
#>   AB12345-BRA-1-id-141                 cl A              7.5                        
#>                                                          7.5                        
#>                                                          7.5                        
#>                                        cl B              7.5                        
#>                                        cl D              7.5                        
#>                                                          7.5                        
#>   AB12345-BRA-1-id-236                 cl B              7.7                        
#>                                                          7.7                        
#>                                                          7.7                        
#>   AB12345-BRA-1-id-265                 cl C              10.3                       
#>                                                          10.3                       
#>                                        cl D              10.3                       
#>                                                          10.3                       
#>    AB12345-BRA-1-id-42                 cl A              2.3                        
#>                                                          2.3                        
#>                                                          2.3                        
#>                                        cl B              2.3                        
#>                                                          2.3                        
#>                                        cl C              2.3                        
#>                                                          2.3                        
#>                                        cl D              2.3                        
#> ————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ——————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Categorical Level Biomarker 2
#> ——————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                           LOW             
#>                                                                       LOW             
#>                                        cl B                           LOW             
#>                                        cl D                           LOW             
#>   AB12345-BRA-1-id-141                 cl A                          HIGH             
#>                                                                      HIGH             
#>                                                                      HIGH             
#>                                        cl B                          HIGH             
#>                                        cl D                          HIGH             
#>                                                                      HIGH             
#>   AB12345-BRA-1-id-236                 cl B                          HIGH             
#>                                                                      HIGH             
#>                                                                      HIGH             
#>   AB12345-BRA-1-id-265                 cl C                         MEDIUM            
#>                                                                     MEDIUM            
#>                                        cl D                         MEDIUM            
#>                                                                     MEDIUM            
#>    AB12345-BRA-1-id-42                 cl A                         MEDIUM            
#>                                                                     MEDIUM            
#>                                                                     MEDIUM            
#>                                        cl B                         MEDIUM            
#>                                                                     MEDIUM            
#>                                        cl C                         MEDIUM            
#>                                                                     MEDIUM            
#>                                        cl D                         MEDIUM            
#> ——————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Intent-To-Treat Population Flag
#> ————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                             Y               
#>                                                                         Y               
#>                                        cl B                             Y               
#>                                        cl D                             Y               
#>   AB12345-BRA-1-id-141                 cl A                             Y               
#>                                                                         Y               
#>                                                                         Y               
#>                                        cl B                             Y               
#>                                        cl D                             Y               
#>                                                                         Y               
#>   AB12345-BRA-1-id-236                 cl B                             Y               
#>                                                                         Y               
#>                                                                         Y               
#>   AB12345-BRA-1-id-265                 cl C                             Y               
#>                                                                         Y               
#>                                        cl D                             Y               
#>                                                                         Y               
#>    AB12345-BRA-1-id-42                 cl A                             Y               
#>                                                                         Y               
#>                                                                         Y               
#>                                        cl B                             Y               
#>                                                                         Y               
#>                                        cl C                             Y               
#>                                                                         Y               
#>                                        cl D                             Y               
#> ————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ———————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Safety Population Flag
#> ———————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                        Y           
#>                                                                    Y           
#>                                        cl B                        Y           
#>                                        cl D                        Y           
#>   AB12345-BRA-1-id-141                 cl A                        Y           
#>                                                                    Y           
#>                                                                    Y           
#>                                        cl B                        Y           
#>                                        cl D                        Y           
#>                                                                    Y           
#>   AB12345-BRA-1-id-236                 cl B                        Y           
#>                                                                    Y           
#>                                                                    Y           
#>   AB12345-BRA-1-id-265                 cl C                        Y           
#>                                                                    Y           
#>                                        cl D                        Y           
#>                                                                    Y           
#>    AB12345-BRA-1-id-42                 cl A                        Y           
#>                                                                    Y           
#>                                                                    Y           
#>                                        cl B                        Y           
#>                                                                    Y           
#>                                        cl C                        Y           
#>                                                                    Y           
#>                                        cl D                        Y           
#> ———————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ———————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Response Evaluable Population Flag
#> ———————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                              Y                 
#>                                                                          Y                 
#>                                        cl B                              Y                 
#>                                        cl D                              Y                 
#>   AB12345-BRA-1-id-141                 cl A                              Y                 
#>                                                                          Y                 
#>                                                                          Y                 
#>                                        cl B                              Y                 
#>                                        cl D                              Y                 
#>                                                                          Y                 
#>   AB12345-BRA-1-id-236                 cl B                              Y                 
#>                                                                          Y                 
#>                                                                          Y                 
#>   AB12345-BRA-1-id-265                 cl C                              Y                 
#>                                                                          Y                 
#>                                        cl D                              Y                 
#>                                                                          Y                 
#>    AB12345-BRA-1-id-42                 cl A                              Y                 
#>                                                                          Y                 
#>                                                                          Y                 
#>                                        cl B                              Y                 
#>                                                                          Y                 
#>                                        cl C                              Y                 
#>                                                                          Y                 
#>                                        cl D                              Y                 
#> ———————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Biomarker Evaluable Population Flag
#> ————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                               N                 
#>                                                                           N                 
#>                                        cl B                               N                 
#>                                        cl D                               N                 
#>   AB12345-BRA-1-id-141                 cl A                               Y                 
#>                                                                           Y                 
#>                                                                           Y                 
#>                                        cl B                               Y                 
#>                                        cl D                               Y                 
#>                                                                           Y                 
#>   AB12345-BRA-1-id-236                 cl B                               Y                 
#>                                                                           Y                 
#>                                                                           Y                 
#>   AB12345-BRA-1-id-265                 cl C                               N                 
#>                                                                           N                 
#>                                        cl D                               N                 
#>                                                                           N                 
#>    AB12345-BRA-1-id-42                 cl A                               Y                 
#>                                                                           Y                 
#>                                                                           Y                 
#>                                        cl B                               Y                 
#>                                                                           Y                 
#>                                        cl C                               Y                 
#>                                                                           Y                 
#>                                        cl D                               Y                 
#> ————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ——————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Date of Randomization
#> ——————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                   2021-06-09      
#>                                                               2021-06-09      
#>                                        cl B                   2021-06-09      
#>                                        cl D                   2021-06-09      
#>   AB12345-BRA-1-id-141                 cl A                   2021-02-25      
#>                                                               2021-02-25      
#>                                                               2021-02-25      
#>                                        cl B                   2021-02-25      
#>                                        cl D                   2021-02-25      
#>                                                               2021-02-25      
#>   AB12345-BRA-1-id-236                 cl B                   2021-08-17      
#>                                                               2021-08-17      
#>                                                               2021-08-17      
#>   AB12345-BRA-1-id-265                 cl C                   2020-05-09      
#>                                                               2020-05-09      
#>                                        cl D                   2020-05-09      
#>                                                               2020-05-09      
#>    AB12345-BRA-1-id-42                 cl A                   2020-08-06      
#>                                                               2020-08-06      
#>                                                               2020-08-06      
#>                                        cl B                   2020-08-06      
#>                                                               2020-08-06      
#>                                        cl C                   2020-08-06      
#>                                                               2020-08-06      
#>                                        cl D                   2020-08-06      
#> ——————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Datetime of First Exposure to Treatment
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                    2021-06-10 13:26:53.956201       
#>                                                                2021-06-10 13:26:53.956201       
#>                                        cl B                    2021-06-10 13:26:53.956201       
#>                                        cl D                    2021-06-10 13:26:53.956201       
#>   AB12345-BRA-1-id-141                 cl A                    2021-02-28 23:47:16.956201       
#>                                                                2021-02-28 23:47:16.956201       
#>                                                                2021-02-28 23:47:16.956201       
#>                                        cl B                    2021-02-28 23:47:16.956201       
#>                                        cl D                    2021-02-28 23:47:16.956201       
#>                                                                2021-02-28 23:47:16.956201       
#>   AB12345-BRA-1-id-236                 cl B                    2021-08-21 18:13:25.956201       
#>                                                                2021-08-21 18:13:25.956201       
#>                                                                2021-08-21 18:13:25.956201       
#>   AB12345-BRA-1-id-265                 cl C                    2020-05-13 00:38:12.956201       
#>                                                                2020-05-13 00:38:12.956201       
#>                                        cl D                    2020-05-13 00:38:12.956201       
#>                                                                2020-05-13 00:38:12.956201       
#>    AB12345-BRA-1-id-42                 cl A                    2020-08-07 06:44:59.956201       
#>                                                                2020-08-07 06:44:59.956201       
#>                                                                2020-08-07 06:44:59.956201       
#>                                        cl B                    2020-08-07 06:44:59.956201       
#>                                                                2020-08-07 06:44:59.956201       
#>                                        cl C                    2020-08-07 06:44:59.956201       
#>                                                                2020-08-07 06:44:59.956201       
#>                                        cl D                    2020-08-07 06:44:59.956201       
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ———————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Datetime of Last Exposure to Treatment
#> ———————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                    2023-06-11 01:05:17.956201      
#>                                                                2023-06-11 01:05:17.956201      
#>                                        cl B                    2023-06-11 01:05:17.956201      
#>                                        cl D                    2023-06-11 01:05:17.956201      
#>   AB12345-BRA-1-id-141                 cl A                    2023-03-01 11:25:40.956201      
#>                                                                2023-03-01 11:25:40.956201      
#>                                                                2023-03-01 11:25:40.956201      
#>                                        cl B                    2023-03-01 11:25:40.956201      
#>                                        cl D                    2023-03-01 11:25:40.956201      
#>                                                                2023-03-01 11:25:40.956201      
#>   AB12345-BRA-1-id-236                 cl B                    2023-08-22 05:51:49.956201      
#>                                                                2023-08-22 05:51:49.956201      
#>                                                                2023-08-22 05:51:49.956201      
#>   AB12345-BRA-1-id-265                 cl C                    2021-09-18 15:23:35.956201      
#>                                                                2021-09-18 15:23:35.956201      
#>                                        cl D                    2021-09-18 15:23:35.956201      
#>                                                                2021-09-18 15:23:35.956201      
#>    AB12345-BRA-1-id-42                 cl A                                NA                  
#>                                                                            NA                  
#>                                                                            NA                  
#>                                        cl B                                NA                  
#>                                                                            NA                  
#>                                        cl C                                NA                  
#>                                                                            NA                  
#>                                        cl D                                NA                  
#> ———————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   End of Study Status   End of Study Date
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                   COMPLETED           2023-06-11    
#>                                                               COMPLETED           2023-06-11    
#>                                        cl B                   COMPLETED           2023-06-11    
#>                                        cl D                   COMPLETED           2023-06-11    
#>   AB12345-BRA-1-id-141                 cl A                   COMPLETED           2023-03-01    
#>                                                               COMPLETED           2023-03-01    
#>                                                               COMPLETED           2023-03-01    
#>                                        cl B                   COMPLETED           2023-03-01    
#>                                        cl D                   COMPLETED           2023-03-01    
#>                                                               COMPLETED           2023-03-01    
#>   AB12345-BRA-1-id-236                 cl B                   COMPLETED           2023-08-22    
#>                                                               COMPLETED           2023-08-22    
#>                                                               COMPLETED           2023-08-22    
#>   AB12345-BRA-1-id-265                 cl C                 DISCONTINUED          2021-09-18    
#>                                                             DISCONTINUED          2021-09-18    
#>                                        cl D                 DISCONTINUED          2021-09-18    
#>                                                             DISCONTINUED          2021-09-18    
#>    AB12345-BRA-1-id-42                 cl A                    ONGOING                NA        
#>                                                                ONGOING                NA        
#>                                                                ONGOING                NA        
#>                                        cl B                    ONGOING                NA        
#>                                                                ONGOING                NA        
#>                                        cl C                    ONGOING                NA        
#>                                                                ONGOING                NA        
#>                                        cl D                    ONGOING                NA        
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ——————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   End of Study Relative Day
#> ——————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                         731           
#>                                                                     731           
#>                                        cl B                         731           
#>                                        cl D                         731           
#>   AB12345-BRA-1-id-141                 cl A                         731           
#>                                                                     731           
#>                                                                     731           
#>                                        cl B                         731           
#>                                        cl D                         731           
#>                                                                     731           
#>   AB12345-BRA-1-id-236                 cl B                         731           
#>                                                                     731           
#>                                                                     731           
#>   AB12345-BRA-1-id-265                 cl C                         494           
#>                                                                     494           
#>                                        cl D                         494           
#>                                                                     494           
#>    AB12345-BRA-1-id-42                 cl A                         NA            
#>                                                                     NA            
#>                                                                     NA            
#>                                        cl B                         NA            
#>                                                                     NA            
#>                                        cl C                         NA            
#>                                                                     NA            
#>                                        cl D                         NA            
#> ——————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ——————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Reason for Discontinuation from Study
#> ——————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                               NA                  
#>                                                                           NA                  
#>                                        cl B                               NA                  
#>                                        cl D                               NA                  
#>   AB12345-BRA-1-id-141                 cl A                               NA                  
#>                                                                           NA                  
#>                                                                           NA                  
#>                                        cl B                               NA                  
#>                                        cl D                               NA                  
#>                                                                           NA                  
#>   AB12345-BRA-1-id-236                 cl B                               NA                  
#>                                                                           NA                  
#>                                                                           NA                  
#>   AB12345-BRA-1-id-265                 cl C                  WITHDRAWAL BY PARENT/GUARDIAN    
#>                                                              WITHDRAWAL BY PARENT/GUARDIAN    
#>                                        cl D                  WITHDRAWAL BY PARENT/GUARDIAN    
#>                                                              WITHDRAWAL BY PARENT/GUARDIAN    
#>    AB12345-BRA-1-id-42                 cl A                               NA                  
#>                                                                           NA                  
#>                                                                           NA                  
#>                                        cl B                               NA                  
#>                                                                           NA                  
#>                                        cl C                               NA                  
#>                                                                           NA                  
#>                                        cl D                               NA                  
#> ——————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ——————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Date of Death   Date Last Known Alive
#> ——————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A               2023-06-11          2023-06-29      
#>                                                           2023-06-11          2023-06-29      
#>                                        cl B               2023-06-11          2023-06-29      
#>                                        cl D               2023-06-11          2023-06-29      
#>   AB12345-BRA-1-id-141                 cl A               2023-03-01          2023-03-30      
#>                                                           2023-03-01          2023-03-30      
#>                                                           2023-03-01          2023-03-30      
#>                                        cl B               2023-03-01          2023-03-30      
#>                                        cl D               2023-03-01          2023-03-30      
#>                                                           2023-03-01          2023-03-30      
#>   AB12345-BRA-1-id-236                 cl B               2023-08-22          2023-09-14      
#>                                                           2023-08-22          2023-09-14      
#>                                                           2023-08-22          2023-09-14      
#>   AB12345-BRA-1-id-265                 cl C               2021-09-18          2021-10-08      
#>                                                           2021-09-18          2021-10-08      
#>                                        cl D               2021-09-18          2021-10-08      
#>                                                           2021-09-18          2021-10-08      
#>    AB12345-BRA-1-id-42                 cl A                   NA                  NA          
#>                                                               NA                  NA          
#>                                                               NA                  NA          
#>                                        cl B                   NA                  NA          
#>                                                               NA                  NA          
#>                                        cl C                   NA                  NA          
#>                                                               NA                  NA          
#>                                        cl D                   NA                  NA          
#> ——————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ——————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   NOT A STANDARD BUT NEEDED FOR RCD
#> ——————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                          63113904             
#>                                                                      63113904             
#>                                        cl B                          63113904             
#>                                        cl D                          63113904             
#>   AB12345-BRA-1-id-141                 cl A                          63113904             
#>                                                                      63113904             
#>                                                                      63113904             
#>                                        cl B                          63113904             
#>                                        cl D                          63113904             
#>                                                                      63113904             
#>   AB12345-BRA-1-id-236                 cl B                          63113904             
#>                                                                      63113904             
#>                                                                      63113904             
#>   AB12345-BRA-1-id-265                 cl C                          63113904             
#>                                                                      63113904             
#>                                        cl D                          63113904             
#>                                                                      63113904             
#>    AB12345-BRA-1-id-42                 cl A                          63113904             
#>                                                                      63113904             
#>                                                                      63113904             
#>                                        cl B                          63113904             
#>                                                                      63113904             
#>                                        cl C                          63113904             
#>                                                                      63113904             
#>                                        cl D                          63113904             
#> ——————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> —————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Analysis Sequence Number
#> —————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                         3            
#>                                                                     4            
#>                                        cl B                         1            
#>                                        cl D                         2            
#>   AB12345-BRA-1-id-141                 cl A                         3            
#>                                                                     4            
#>                                                                     5            
#>                                        cl B                         1            
#>                                        cl D                         2            
#>                                                                     6            
#>   AB12345-BRA-1-id-236                 cl B                         1            
#>                                                                     2            
#>                                                                     3            
#>   AB12345-BRA-1-id-265                 cl C                         1            
#>                                                                     4            
#>                                        cl D                         2            
#>                                                                     3            
#>    AB12345-BRA-1-id-42                 cl A                         4            
#>                                                                     6            
#>                                                                     8            
#>                                        cl B                         5            
#>                                                                     7            
#>                                        cl C                         1            
#>                                                                     3            
#>                                        cl D                         2            
#> —————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ———————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Sponsor-Defined Identifier
#> ———————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                          3             
#>                                                                      4             
#>                                        cl B                          1             
#>                                        cl D                          2             
#>   AB12345-BRA-1-id-141                 cl A                          3             
#>                                                                      4             
#>                                                                      5             
#>                                        cl B                          1             
#>                                        cl D                          2             
#>                                                                      6             
#>   AB12345-BRA-1-id-236                 cl B                          1             
#>                                                                      2             
#>                                                                      3             
#>   AB12345-BRA-1-id-265                 cl C                          1             
#>                                                                      4             
#>                                        cl D                          2             
#>                                                                      3             
#>    AB12345-BRA-1-id-42                 cl A                          4             
#>                                                                      6             
#>                                                                      8             
#>                                        cl B                          5             
#>                                                                      7             
#>                                        cl C                          1             
#>                                                                      3             
#>                                        cl D                          2             
#> ———————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Reported Term for the Adverse Event
#> ————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                         trm A.1.1.1.2           
#>                                                                     trm A.1.1.1.2           
#>                                        cl B                         trm B.2.1.2.1           
#>                                        cl D                         trm D.1.1.4.2           
#>   AB12345-BRA-1-id-141                 cl A                         trm A.1.1.1.1           
#>                                                                     trm A.1.1.1.2           
#>                                                                     trm A.1.1.1.1           
#>                                        cl B                         trm B.2.1.2.1           
#>                                        cl D                         trm D.2.1.5.3           
#>                                                                     trm D.1.1.1.1           
#>   AB12345-BRA-1-id-236                 cl B                         trm B.1.1.1.1           
#>                                                                     trm B.1.1.1.1           
#>                                                                     trm B.1.1.1.1           
#>   AB12345-BRA-1-id-265                 cl C                         trm C.2.1.2.1           
#>                                                                     trm C.1.1.1.3           
#>                                        cl D                         trm D.1.1.4.2           
#>                                                                     trm D.1.1.1.1           
#>    AB12345-BRA-1-id-42                 cl A                         trm A.1.1.1.2           
#>                                                                     trm A.1.1.1.2           
#>                                                                     trm A.1.1.1.2           
#>                                        cl B                         trm B.2.2.3.1           
#>                                                                     trm B.1.1.1.1           
#>                                        cl C                         trm C.2.1.2.1           
#>                                                                     trm C.2.1.2.1           
#>                                        cl D                         trm D.1.1.1.1           
#> ————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Lowest Level Term   Dictionary-Derived Term
#> ————————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                llt A.1.1.1.2          dcd A.1.1.1.2     
#>                                                            llt A.1.1.1.2          dcd A.1.1.1.2     
#>                                        cl B                llt B.2.1.2.1          dcd B.2.1.2.1     
#>                                        cl D                llt D.1.1.4.2          dcd D.1.1.4.2     
#>   AB12345-BRA-1-id-141                 cl A                llt A.1.1.1.1          dcd A.1.1.1.1     
#>                                                            llt A.1.1.1.2          dcd A.1.1.1.2     
#>                                                            llt A.1.1.1.1          dcd A.1.1.1.1     
#>                                        cl B                llt B.2.1.2.1          dcd B.2.1.2.1     
#>                                        cl D                llt D.2.1.5.3          dcd D.2.1.5.3     
#>                                                            llt D.1.1.1.1          dcd D.1.1.1.1     
#>   AB12345-BRA-1-id-236                 cl B                llt B.1.1.1.1          dcd B.1.1.1.1     
#>                                                            llt B.1.1.1.1          dcd B.1.1.1.1     
#>                                                            llt B.1.1.1.1          dcd B.1.1.1.1     
#>   AB12345-BRA-1-id-265                 cl C                llt C.2.1.2.1          dcd C.2.1.2.1     
#>                                                            llt C.1.1.1.3          dcd C.1.1.1.3     
#>                                        cl D                llt D.1.1.4.2          dcd D.1.1.4.2     
#>                                                            llt D.1.1.1.1          dcd D.1.1.1.1     
#>    AB12345-BRA-1-id-42                 cl A                llt A.1.1.1.2          dcd A.1.1.1.2     
#>                                                            llt A.1.1.1.2          dcd A.1.1.1.2     
#>                                                            llt A.1.1.1.2          dcd A.1.1.1.2     
#>                                        cl B                llt B.2.2.3.1          dcd B.2.2.3.1     
#>                                                            llt B.1.1.1.1          dcd B.1.1.1.1     
#>                                        cl C                llt C.2.1.2.1          dcd C.2.1.2.1     
#>                                                            llt C.2.1.2.1          dcd C.2.1.2.1     
#>                                        cl D                llt D.1.1.1.1          dcd D.1.1.1.1     
#> ————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   High Level Term   High Level Group Term
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                hlt A.1.1.1          hlgt A.1.1      
#>                                                            hlt A.1.1.1          hlgt A.1.1      
#>                                        cl B                hlt B.2.1.2          hlgt B.2.1      
#>                                        cl D                hlt D.1.1.4          hlgt D.1.1      
#>   AB12345-BRA-1-id-141                 cl A                hlt A.1.1.1          hlgt A.1.1      
#>                                                            hlt A.1.1.1          hlgt A.1.1      
#>                                                            hlt A.1.1.1          hlgt A.1.1      
#>                                        cl B                hlt B.2.1.2          hlgt B.2.1      
#>                                        cl D                hlt D.2.1.5          hlgt D.2.1      
#>                                                            hlt D.1.1.1          hlgt D.1.1      
#>   AB12345-BRA-1-id-236                 cl B                hlt B.1.1.1          hlgt B.1.1      
#>                                                            hlt B.1.1.1          hlgt B.1.1      
#>                                                            hlt B.1.1.1          hlgt B.1.1      
#>   AB12345-BRA-1-id-265                 cl C                hlt C.2.1.2          hlgt C.2.1      
#>                                                            hlt C.1.1.1          hlgt C.1.1      
#>                                        cl D                hlt D.1.1.4          hlgt D.1.1      
#>                                                            hlt D.1.1.1          hlgt D.1.1      
#>    AB12345-BRA-1-id-42                 cl A                hlt A.1.1.1          hlgt A.1.1      
#>                                                            hlt A.1.1.1          hlgt A.1.1      
#>                                                            hlt A.1.1.1          hlgt A.1.1      
#>                                        cl B                hlt B.2.2.3          hlgt B.2.2      
#>                                                            hlt B.1.1.1          hlgt B.1.1      
#>                                        cl C                hlt C.2.1.2          hlgt C.2.1      
#>                                                            hlt C.2.1.2          hlgt C.2.1      
#>                                        cl D                hlt D.1.1.1          hlgt D.1.1      
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Body System or Organ Class   Severity/Intensity
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                        cl A.1                  MODERATE     
#>                                                                    cl A.1                  MODERATE     
#>                                        cl B                        cl B.2                  MODERATE     
#>                                        cl D                        cl D.1                  MODERATE     
#>   AB12345-BRA-1-id-141                 cl A                        cl A.1                    MILD       
#>                                                                    cl A.1                  MODERATE     
#>                                                                    cl A.1                    MILD       
#>                                        cl B                        cl B.2                  MODERATE     
#>                                        cl D                        cl D.2                    MILD       
#>                                                                    cl D.1                   SEVERE      
#>   AB12345-BRA-1-id-236                 cl B                        cl B.1                   SEVERE      
#>                                                                    cl B.1                   SEVERE      
#>                                                                    cl B.1                   SEVERE      
#>   AB12345-BRA-1-id-265                 cl C                        cl C.2                  MODERATE     
#>                                                                    cl C.1                   SEVERE      
#>                                        cl D                        cl D.1                  MODERATE     
#>                                                                    cl D.1                   SEVERE      
#>    AB12345-BRA-1-id-42                 cl A                        cl A.1                  MODERATE     
#>                                                                    cl A.1                  MODERATE     
#>                                                                    cl A.1                  MODERATE     
#>                                        cl B                        cl B.2                    MILD       
#>                                                                    cl B.1                   SEVERE      
#>                                        cl C                        cl C.2                  MODERATE     
#>                                                                    cl C.2                  MODERATE     
#>                                        cl D                        cl D.1                   SEVERE      
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ———————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Serious Event   Analysis Causality
#> ———————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                    Y                 N         
#>                                                                Y                 N         
#>                                        cl B                    N                 N         
#>                                        cl D                    N                 N         
#>   AB12345-BRA-1-id-141                 cl A                    N                 N         
#>                                                                Y                 N         
#>                                                                N                 N         
#>                                        cl B                    N                 N         
#>                                        cl D                    N                 Y         
#>                                                                Y                 N         
#>   AB12345-BRA-1-id-236                 cl B                    N                 Y         
#>                                                                N                 Y         
#>                                                                N                 Y         
#>   AB12345-BRA-1-id-265                 cl C                    N                 Y         
#>                                                                N                 Y         
#>                                        cl D                    N                 N         
#>                                                                Y                 N         
#>    AB12345-BRA-1-id-42                 cl A                    Y                 N         
#>                                                                Y                 N         
#>                                                                Y                 N         
#>                                        cl B                    Y                 N         
#>                                                                N                 Y         
#>                                        cl C                    N                 Y         
#>                                                                N                 Y         
#>                                        cl D                    Y                 N         
#> ———————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Analysis Start Datetime   Analysis End Datetime
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                    2022-10-20               2023-06-05      
#>                                                                2023-02-08               2023-04-15      
#>                                        cl B                    2022-02-16               2022-11-10      
#>                                        cl D                    2022-04-10               2022-12-21      
#>   AB12345-BRA-1-id-141                 cl A                    2022-07-06               2022-07-29      
#>                                                                2022-10-21               2023-01-22      
#>                                                                2022-11-25               2023-01-07      
#>                                        cl B                    2021-11-14               2021-11-21      
#>                                        cl D                    2021-12-28               2023-02-21      
#>                                                                2023-02-28               2023-03-01      
#>   AB12345-BRA-1-id-236                 cl B                    2021-09-12               2022-10-27      
#>                                                                2022-02-18               2023-07-20      
#>                                                                2023-07-24               2023-07-28      
#>   AB12345-BRA-1-id-265                 cl C                    2020-06-30               2020-08-13      
#>                                                                2021-06-20               2021-07-27      
#>                                        cl D                    2020-11-29               2021-05-10      
#>                                                                2021-06-09               2021-06-30      
#>    AB12345-BRA-1-id-42                 cl A                    2021-01-14               2021-09-30      
#>                                                                2021-11-10               2022-05-23      
#>                                                                2021-11-26               2022-03-18      
#>                                        cl B                    2021-05-26               2021-07-15      
#>                                                                2021-11-20               2022-03-30      
#>                                        cl C                    2020-09-15               2022-02-03      
#>                                                                2020-11-10               2021-09-12      
#>                                        cl D                    2020-10-11               2022-07-02      
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Analysis Start Relative Day
#> ————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                          497            
#>                                                                      608            
#>                                        cl B                          251            
#>                                        cl D                          304            
#>   AB12345-BRA-1-id-141                 cl A                          493            
#>                                                                      600            
#>                                                                      635            
#>                                        cl B                          259            
#>                                        cl D                          303            
#>                                                                      730            
#>   AB12345-BRA-1-id-236                 cl B                          22             
#>                                                                      181            
#>                                                                      702            
#>   AB12345-BRA-1-id-265                 cl C                          48             
#>                                                                      403            
#>                                        cl D                          200            
#>                                                                      392            
#>    AB12345-BRA-1-id-42                 cl A                          160            
#>                                                                      460            
#>                                                                      476            
#>                                        cl B                          292            
#>                                                                      470            
#>                                        cl C                          39             
#>                                                                      95             
#>                                        cl D                          65             
#> ————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ——————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Analysis End Relative Day
#> ——————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A                         725           
#>                                                                     674           
#>                                        cl B                         518           
#>                                        cl D                         559           
#>   AB12345-BRA-1-id-141                 cl A                         516           
#>                                                                     693           
#>                                                                     678           
#>                                        cl B                         266           
#>                                        cl D                         723           
#>                                                                     731           
#>   AB12345-BRA-1-id-236                 cl B                         432           
#>                                                                     698           
#>                                                                     706           
#>   AB12345-BRA-1-id-265                 cl C                         92            
#>                                                                     440           
#>                                        cl D                         362           
#>                                                                     413           
#>    AB12345-BRA-1-id-42                 cl A                         419           
#>                                                                     654           
#>                                                                     588           
#>                                        cl B                         342           
#>                                                                     600           
#>                                        cl C                         545           
#>                                                                     401           
#>                                        cl D                         694           
#> ——————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
#> \s\nthis is some title
#> 
#> ———————————————————————————————————————————————————————————————————————————————————————————————
#> Unique Subject Identifier   Primary System Organ Class   Analysis Toxicity Grade   AESER / AREL
#> ———————————————————————————————————————————————————————————————————————————————————————————————
#>   AB12345-BRA-1-id-134                 cl A              2                         Y / N       
#>                                                          2                         Y / N       
#>                                        cl B              3                         N / N       
#>                                        cl D              3                         N / N       
#>   AB12345-BRA-1-id-141                 cl A              1                         N / N       
#>                                                          2                         Y / N       
#>                                                          1                         N / N       
#>                                        cl B              3                         N / N       
#>                                        cl D              1                         N / Y       
#>                                                          5                         Y / N       
#>   AB12345-BRA-1-id-236                 cl B              5                         N / Y       
#>                                                          5                         N / Y       
#>                                                          5                         N / Y       
#>   AB12345-BRA-1-id-265                 cl C              2                         N / Y       
#>                                                          4                         N / Y       
#>                                        cl D              3                         N / N       
#>                                                          5                         Y / N       
#>    AB12345-BRA-1-id-42                 cl A              2                         Y / N       
#>                                                          2                         Y / N       
#>                                                          2                         Y / N       
#>                                        cl B              1                         Y / N       
#>                                                          5                         N / Y       
#>                                        cl C              2                         N / Y       
#>                                                          2                         N / Y       
#>                                        cl D              5                         Y / N       
#> ———————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> this is some footer
```
