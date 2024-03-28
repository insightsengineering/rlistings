# key columns repeat with export_as_txt

    Code
      cat(listing_exp)
    Output
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134      47    6.5                        
        AB12345-BRA-1-id-141      35    7.5                        
      
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-236      32    7.7                        
        AB12345-BRA-1-id-265      25    10.3                       
      
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
         AB12345-BRA-1-id-42      36    2.3                        
         AB12345-BRA-1-id-65      25    7.3                        

# key columns repeat with pagination with export_as_txt

    Code
      cat(listing)
    Output
      Species   Sepal.Length   Sepal.Width
      ————————————————————————————————————
      setosa        5.1            3.5    
                    4.9             3     
                    4.7            3.2    
                    4.6            3.1    
                     5             3.6    
                    5.4            3.9    
      
      Species   Petal.Length   Petal.Width
      ————————————————————————————————————
      setosa        1.4            0.2    
                    1.4            0.2    
                    1.3            0.2    
                    1.5            0.2    
                    1.4            0.2    
                    1.7            0.4    

# export_as_txt works and repeats the correct lines in pagination

    Code
      cat(pages_listings)
    Output
      Example Title for Listing
      This is the subtitle for this Adverse Events Table
      
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Study Identifier   Subject Identifier for the Study
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134                 cl A                  AB12345                     id-134             
                                                                   AB12345                     id-134             
                                             cl B                  AB12345                     id-134             
                                             cl D                  AB12345                     id-134             
        AB12345-BRA-1-id-141                 cl A                  AB12345                     id-141             
                                                                   AB12345                     id-141             
                                                                   AB12345                     id-141             
                                             cl B                  AB12345                     id-141             
                                             cl D                  AB12345                     id-141             
                                                                   AB12345                     id-141             
        AB12345-BRA-1-id-236                 cl B                  AB12345                     id-236             
                                                                   AB12345                     id-236             
                                                                   AB12345                     id-236             
        AB12345-BRA-1-id-265                 cl C                  AB12345                     id-265             
                                                                   AB12345                     id-265             
                                             cl D                  AB12345                     id-265             
                                                                   AB12345                     id-265             
         AB12345-BRA-1-id-42                 cl A                  AB12345                     id-42              
                                                                   AB12345                     id-42              
                                                                   AB12345                     id-42              
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string
      \s\nExample Title for Listing
      This is the subtitle for this Adverse Events Table
      
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————
      Unique Subject Identifier   Primary System Organ Class   Study Identifier   Subject Identifier for the Study
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————
         AB12345-BRA-1-id-42                 cl B                  AB12345                     id-42              
                                                                   AB12345                     id-42              
                                             cl C                  AB12345                     id-42              
                                                                   AB12345                     id-42              
                                             cl D                  AB12345                     id-42              
      ————————————————————————————————————————————————————————————————————————————————————————————————————————————
      
      Main footer for the listing
      
      You can even add a subfooter
      Second element is place on a new line
      Third string

# export_as_txt works with split_into_pages_by_var

    Code
      cat(pages_listings)
    Output
      title
      Patient Subset - Sex: M
      
      —————————————————————————————————————
      Unique Subject Identifier   Age   Sex
      —————————————————————————————————————
        AB12345-BRA-1-id-134      47     M 
                                         M 
                                         M 
                                         M 
        AB12345-BRA-1-id-236      32     M 
                                         M 
                                         M 
        AB12345-BRA-1-id-265      25     M 
                                         M 
                                         M 
                                         M 
         AB12345-BRA-1-id-42      36     M 
                                         M 
                                         M 
                                         M 
                                         M 
                                         M 
                                         M 
                                         M 
                                         M 
                                         M 
      —————————————————————————————————————
      
      foot
      \s\ntitle
      Patient Subset - Sex: M
      
      —————————————————————————————————————————————————————————————
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-134      47    6.5                        
                                        6.5                        
                                        6.5                        
                                        6.5                        
        AB12345-BRA-1-id-236      32    7.7                        
                                        7.7                        
                                        7.7                        
        AB12345-BRA-1-id-265      25    10.3                       
                                        10.3                       
                                        10.3                       
                                        10.3                       
         AB12345-BRA-1-id-42      36    2.3                        
                                        2.3                        
                                        2.3                        
                                        2.3                        
                                        2.3                        
                                        2.3                        
                                        2.3                        
                                        2.3                        
                                        2.3                        
                                        2.3                        
      —————————————————————————————————————————————————————————————
      
      foot
      \s\ntitle
      Patient Subset - Sex: F
      
      —————————————————————————————————————
      Unique Subject Identifier   Age   Sex
      —————————————————————————————————————
        AB12345-BRA-1-id-141      35     F 
                                         F 
                                         F 
                                         F 
                                         F 
                                         F 
         AB12345-BRA-1-id-65      25     F 
                                         F 
                                         F 
                                         F 
         AB12345-BRA-1-id-93      34     F 
                                         F 
                                         F 
                                         F 
                                         F 
                                         F 
                                         F 
                                         F 
                                         F 
        AB12345-BRA-11-id-237     64     F 
                                         F 
      —————————————————————————————————————
      
      foot
      \s\ntitle
      Patient Subset - Sex: F
      
      —————————————————————————————————————————————————————————————
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-1-id-141      35    7.5                        
                                        7.5                        
                                        7.5                        
                                        7.5                        
                                        7.5                        
                                        7.5                        
         AB12345-BRA-1-id-65      25    7.3                        
                                        7.3                        
                                        7.3                        
                                        7.3                        
         AB12345-BRA-1-id-93      34    3.9                        
                                        3.9                        
                                        3.9                        
                                        3.9                        
                                        3.9                        
                                        3.9                        
                                        3.9                        
                                        3.9                        
                                        3.9                        
        AB12345-BRA-11-id-237     64    5.3                        
                                        5.3                        
      —————————————————————————————————————————————————————————————
      
      foot
      \s\ntitle
      Patient Subset - Sex: F
      
      —————————————————————————————————————
      Unique Subject Identifier   Age   Sex
      —————————————————————————————————————
        AB12345-BRA-11-id-237     64     F 
        AB12345-BRA-11-id-321     33     F 
                                         F 
                                         F 
                                         F 
                                         F 
                                         F 
                                         F 
      —————————————————————————————————————
      
      foot
      \s\ntitle
      Patient Subset - Sex: F
      
      —————————————————————————————————————————————————————————————
      Unique Subject Identifier   Age   Continous Level Biomarker 1
      —————————————————————————————————————————————————————————————
        AB12345-BRA-11-id-237     64    5.3                        
        AB12345-BRA-11-id-321     33    1.8                        
                                        1.8                        
                                        1.8                        
                                        1.8                        
                                        1.8                        
                                        1.8                        
                                        1.8                        
      —————————————————————————————————————————————————————————————
      
      foot

