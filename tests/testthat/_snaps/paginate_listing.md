# pagination works vertically

    Code
      pages_listings[c(1, 2)]
    Output
      [[1]]
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134      47    6.5                        
        AB12345-BRA-1-id-141      35    7.5                        
      
      [[2]]
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-236      32    7.7                        
        AB12345-BRA-1-id-265      25    10.3                       
      

---

    Code
      pages_listings2[c(1, 6)]
    Output
      [[1]]
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134      47    6.5                        
        AB12345-BRA-1-id-141      35    7.5                        
      
      [[2]]
      Unique Subject Identifier   Age   Categorical Level Biomarker 2
      ———————————————————————————————————————————————————————————————
         AB12345-BRA-1-id-42      36    MEDIUM                       
         AB12345-BRA-1-id-65      25    MEDIUM                       
      

