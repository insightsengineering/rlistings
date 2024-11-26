# pagination works vertically

    Code
      fast_print(pages_listings[c(1, 2)])
    Output
      Page 1 
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134      47    6.5                        
        AB12345-BRA-1-id-141      35    7.5                        
      Page 2 
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-236      32    7.7                        
        AB12345-BRA-1-id-265      25    10.3                       

---

    Code
      fast_print(pages_listings2[c(1, 6)])
    Output
      Page 1 
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134      47    6.5                        
        AB12345-BRA-1-id-141      35    7.5                        
      Page 2 
      Unique Subject Identifier   Age   Categorical Level Biomarker 2
      ———————————————————————————————————————————————————————————————
         AB12345-BRA-1-id-42      36    MEDIUM                       
         AB12345-BRA-1-id-65      25    MEDIUM                       

# pagination repeats keycols in other pages

    Code
      cat(toString(mf_pages[[3]]))
    Output
      a   b 
      ——————
      1   17
          18
          19
          20
          21
          22
          23
          24

---

    Code
      cat(toString(mf_pages[[3]]))
    Output
      a   b 
      ——————
          17
          18
          19
          20
          21
          22
          23
          24

# paginate_to_mpfs works with wrapping on keycols

    Code
      null <- sapply(pgs, function(x) toString(x) %>% cat())
    Output
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.1           1.5     
            BREAKS PAGINATION                                    
                                           0.2           1.4     
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.2           1.4     
            BREAKS PAGINATION                                    
                                                         1.3     
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.2           1.5     
            BREAKS PAGINATION                                    
                                                         1.4     
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.2           1.5     
            BREAKS PAGINATION                                    
                                                         1.4     
                 Species               Petal.Width   Petal.Length
      ———————————————————————————————————————————————————————————
         SOMETHING VERY LONG THAT          0.3           1.4     
            BREAKS PAGINATION                                    
                                           0.4           1.7     

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
      

