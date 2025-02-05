# pagination works vertically

    Code
      fast_print(pages_listings[c(1, 2)])
    Output
      Page 1 
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134      47    6.5                        
      —————————————————————————————————————————————————————————————
      
                                                                                                    page 1 of 6
      Page 2 
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-141      35    7.5                        
      —————————————————————————————————————————————————————————————
      
                                                                                                    page 2 of 6

---

    Code
      fast_print(pages_listings2[c(1, 6)])
    Output
      Page 1 
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134      47    6.5                        
        AB12345-BRA-1-id-141      35    7.5                        
        AB12345-BRA-1-id-236      32    7.7                        
      —————————————————————————————————————————————————————————————
      
                                                                 page 1 of 4
      Page 2 

# pagination repeats keycols in other pages

    Code
      cat(toString(mf_pages[[3]]))
    Output
      a   b 
      ——————
      1   11
          12
          13
          14
          15
      ——————
      
                                                                                                    page 3 of 5

---

    Code
      cat(toString(mf_pages[[3]]))
    Output
      a   b 
      ——————
          11
          12
          13
          14
          15
      ——————
      
                                                                                                    page 3 of 5

# pagination repeats keycols in other pages (longer test)

    Code
      cat(toString(lst))
    Output
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      —————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Study Identifier
      —————————————————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134                 cl A                  AB12345     
                                                                   AB12345     
                                             cl B                  AB12345     
                                             cl D                  AB12345     
        AB12345-BRA-1-id-141                 cl A                  AB12345     
                                                                   AB12345     
                                                                   AB12345     
                                             cl B                  AB12345     
                                             cl D                  AB12345     
                                                                   AB12345     
        AB12345-BRA-1-id-236                 cl B                  AB12345     
                                                                   AB12345     
                                                                   AB12345     
        AB12345-BRA-1-id-265                 cl C                  AB12345     
                                                                   AB12345     
                                             cl D                  AB12345     
      —————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 1 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      —————————————————————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Subject Identifier for the Study
      —————————————————————————————————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134                 cl A                           id-134             
                                                                            id-134             
                                             cl B                           id-134             
                                             cl D                           id-134             
        AB12345-BRA-1-id-141                 cl A                           id-141             
                                                                            id-141             
                                                                            id-141             
                                             cl B                           id-141             
                                             cl D                           id-141             
                                                                            id-141             
        AB12345-BRA-1-id-236                 cl B                           id-236             
                                                                            id-236             
                                                                            id-236             
        AB12345-BRA-1-id-265                 cl C                           id-265             
                                                                            id-265             
                                             cl D                           id-265             
      —————————————————————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 2 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      ——————————————————————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Study Site Identifier   Age   Sex
      ——————————————————————————————————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134                 cl A                      BRA-1           47     M 
                                                                       BRA-1           47     M 
                                             cl B                      BRA-1           47     M 
                                             cl D                      BRA-1           47     M 
        AB12345-BRA-1-id-141                 cl A                      BRA-1           35     F 
                                                                       BRA-1           35     F 
                                                                       BRA-1           35     F 
                                             cl B                      BRA-1           35     F 
                                             cl D                      BRA-1           35     F 
                                                                       BRA-1           35     F 
        AB12345-BRA-1-id-236                 cl B                      BRA-1           32     M 
                                                                       BRA-1           32     M 
                                                                       BRA-1           32     M 
        AB12345-BRA-1-id-265                 cl C                      BRA-1           25     M 
                                                                       BRA-1           25     M 
                                             cl D                      BRA-1           25     M 
      ——————————————————————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 3 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      —————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Study Identifier
      —————————————————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-265                 cl D                  AB12345     
         AB12345-BRA-1-id-42                 cl A                  AB12345     
                                                                   AB12345     
                                                                   AB12345     
                                             cl B                  AB12345     
                                                                   AB12345     
                                                                   AB12345     
                                             cl C                  AB12345     
                                                                   AB12345     
                                                                   AB12345     
                                             cl D                  AB12345     
         AB12345-BRA-1-id-65                 cl B                  AB12345     
                                             cl C                  AB12345     
                                                                   AB12345     
                                             cl D                  AB12345     
         AB12345-BRA-1-id-93                 cl A                  AB12345     
      —————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 4 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      —————————————————————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Subject Identifier for the Study
      —————————————————————————————————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-265                 cl D                           id-265             
         AB12345-BRA-1-id-42                 cl A                           id-42              
                                                                            id-42              
                                                                            id-42              
                                             cl B                           id-42              
                                                                            id-42              
                                                                            id-42              
                                             cl C                           id-42              
                                                                            id-42              
                                                                            id-42              
                                             cl D                           id-42              
         AB12345-BRA-1-id-65                 cl B                           id-65              
                                             cl C                           id-65              
                                                                            id-65              
                                             cl D                           id-65              
         AB12345-BRA-1-id-93                 cl A                           id-93              
      —————————————————————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 5 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      ——————————————————————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Study Site Identifier   Age   Sex
      ——————————————————————————————————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-265                 cl D                      BRA-1           25     M 
         AB12345-BRA-1-id-42                 cl A                      BRA-1           36     M 
                                                                       BRA-1           36     M 
                                                                       BRA-1           36     M 
                                             cl B                      BRA-1           36     M 
                                                                       BRA-1           36     M 
                                                                       BRA-1           36     M 
                                             cl C                      BRA-1           36     M 
                                                                       BRA-1           36     M 
                                                                       BRA-1           36     M 
                                             cl D                      BRA-1           36     M 
         AB12345-BRA-1-id-65                 cl B                      BRA-1           25     F 
                                             cl C                      BRA-1           25     F 
                                                                       BRA-1           25     F 
                                             cl D                      BRA-1           25     F 
         AB12345-BRA-1-id-93                 cl A                      BRA-1           34     F 
      ——————————————————————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 6 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      —————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Study Identifier
      —————————————————————————————————————————————————————————————————————————
         AB12345-BRA-1-id-93                 cl B                  AB12345     
                                                                   AB12345     
                                             cl C                  AB12345     
                                             cl D                  AB12345     
                                                                   AB12345     
                                                                   AB12345     
                                                                   AB12345     
                                                                   AB12345     
        AB12345-BRA-11-id-237                cl B                  AB12345     
                                             cl C                  AB12345     
                                             cl D                  AB12345     
        AB12345-BRA-11-id-321                cl A                  AB12345     
                                                                   AB12345     
                                                                   AB12345     
                                                                   AB12345     
                                             cl C                  AB12345     
      —————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 7 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      —————————————————————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Subject Identifier for the Study
      —————————————————————————————————————————————————————————————————————————————————————————
         AB12345-BRA-1-id-93                 cl B                           id-93              
                                                                            id-93              
                                             cl C                           id-93              
                                             cl D                           id-93              
                                                                            id-93              
                                                                            id-93              
                                                                            id-93              
                                                                            id-93              
        AB12345-BRA-11-id-237                cl B                           id-237             
                                             cl C                           id-237             
                                             cl D                           id-237             
        AB12345-BRA-11-id-321                cl A                           id-321             
                                                                            id-321             
                                                                            id-321             
                                                                            id-321             
                                             cl C                           id-321             
      —————————————————————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 8 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      ——————————————————————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Study Site Identifier   Age   Sex
      ——————————————————————————————————————————————————————————————————————————————————————————
         AB12345-BRA-1-id-93                 cl B                      BRA-1           34     F 
                                                                       BRA-1           34     F 
                                             cl C                      BRA-1           34     F 
                                             cl D                      BRA-1           34     F 
                                                                       BRA-1           34     F 
                                                                       BRA-1           34     F 
                                                                       BRA-1           34     F 
                                                                       BRA-1           34     F 
        AB12345-BRA-11-id-237                cl B                     BRA-11           64     F 
                                             cl C                     BRA-11           64     F 
                                             cl D                     BRA-11           64     F 
        AB12345-BRA-11-id-321                cl A                     BRA-11           33     F 
                                                                      BRA-11           33     F 
                                                                      BRA-11           33     F 
                                                                      BRA-11           33     F 
                                             cl C                     BRA-11           33     F 
      ——————————————————————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 9 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      —————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Study Identifier
      —————————————————————————————————————————————————————————————————————————
        AB12345-BRA-11-id-321                cl D                  AB12345     
                                                                   AB12345     
      —————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 10 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      —————————————————————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Subject Identifier for the Study
      —————————————————————————————————————————————————————————————————————————————————————————
        AB12345-BRA-11-id-321                cl D                           id-321             
                                                                            id-321             
      —————————————————————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 11 of 12
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      ——————————————————————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Study Site Identifier   Age   Sex
      ——————————————————————————————————————————————————————————————————————————————————————————
        AB12345-BRA-11-id-321                cl D                     BRA-11           33     F 
                                                                      BRA-11           33     F 
      ——————————————————————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
                                                                                      
      page 12 of 12

# paginate_to_mpfs works with wrapping on keycols

    Code
      null <- sapply(pgs, function(x) toString(x) %>% cat())
    Output
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.1           1.5     
            BREAKS PAGINATION                                    
      ———————————————————————————————————————————————————————————
      
                                                                                                   page 1 of 10
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.2           1.4     
            BREAKS PAGINATION                                    
      ———————————————————————————————————————————————————————————
      
                                                                                                   page 2 of 10
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.2           1.4     
            BREAKS PAGINATION                                    
      ———————————————————————————————————————————————————————————
      
                                                                                                   page 3 of 10
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.2           1.3     
            BREAKS PAGINATION                                    
      ———————————————————————————————————————————————————————————
      
                                                                                                   page 4 of 10
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.2           1.5     
            BREAKS PAGINATION                                    
      ———————————————————————————————————————————————————————————
      
                                                                                                   page 5 of 10
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.2           1.4     
            BREAKS PAGINATION                                    
      ———————————————————————————————————————————————————————————
      
                                                                                                   page 6 of 10
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.2           1.5     
            BREAKS PAGINATION                                    
      ———————————————————————————————————————————————————————————
      
                                                                                                   page 7 of 10
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.2           1.4     
            BREAKS PAGINATION                                    
      ———————————————————————————————————————————————————————————
      
                                                                                                   page 8 of 10
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.3           1.4     
            BREAKS PAGINATION                                    
      ———————————————————————————————————————————————————————————
      
                                                                                                   page 9 of 10
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.4           1.7     
            BREAKS PAGINATION                                    
      ———————————————————————————————————————————————————————————
      
                                                                                                  page 10 of 10

# paginate_listing works with split_into_pages_by_var

    Code
      fast_print(list(pag_listing))
    Output
      Page 1 
      title
      Patient Subset - Sex: M
      
      —————————————————————————————————————
      Unique Subject Identifier   Age   Sex
      —————————————————————————————————————
        AB12345-BRA-1-id-134      47     M 
                                         M 
                                         M 
                                         M 
      —————————————————————————————————————
      
      foot
      
                                                            page 3 of 4

---

    Code
      paginate_listing(lsting, lpp = 330, cpp = 365, print_pages = TRUE)
    Output
      --- Page 1/2 ---
      title
      Patient Subset - Sex: F
      
      ———————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Age   Sex   Continous Level Biomarker 1
      ———————————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-141      35     F    7.5                        
                                         F    7.5                        
                                         F    7.5                        
                                         F    7.5                        
                                         F    7.5                        
                                         F    7.5                        
      ———————————————————————————————————————————————————————————————————
      
      foot
      
                                                                                                                                                                                                                                                                                                                                                                        page 1 of 2
      
      --- Page 2/2 ---
      title
      Patient Subset - Sex: M
      
      ———————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Age   Sex   Continous Level Biomarker 1
      ———————————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134      47     M    6.5                        
                                         M    6.5                        
                                         M    6.5                        
                                         M    6.5                        
      ———————————————————————————————————————————————————————————————————
      
      foot
      
                                                                                                                                                                                                                                                                                                                                                                        page 2 of 2
      

