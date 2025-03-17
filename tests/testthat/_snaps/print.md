# Listing print correctly

    Code
      res
    Output
       [1] "       Unique            Description                                "
       [2] "       Subject                Of                                    "
       [3] "     Identifier          Planned Arm     Continous Level Biomarker 1"
       [4] "--------------------------------------------------------------------"
       [5] "AB12345-CHN-1-id-307    B: Placebo            4.57499101339464      "
       [6] "AB12345-CHN-11-id-220   B: Placebo            10.2627340069523      "
       [7] "AB12345-CHN-15-id-201   C: Combination         6.9067988141075      "
       [8] "AB12345-CHN-15-id-262   C: Combination        4.05546277230382      "
       [9] "AB12345-CHN-3-id-128    A: Drug X              14.424933692778      "
      [10] "AB12345-CHN-7-id-267    B: Placebo             6.2067627167943      "
      [11] "AB12345-NGA-11-id-173   C: Combination        4.99722573047567      "
      [12] "AB12345-RUS-3-id-378    C: Combination        2.80323956920649      "
      [13] "AB12345-USA-1-id-261    B: Placebo            2.85516419937308      "
      [14] " AB12345-USA-1-id-45    A: Drug X             0.463560441314472     "

# Listing print correctly with different widths

    Code
      cat(toString(matrix_form(lsting), widths = c(7, 8, 9), hsep = "-"))
    Output
                                    
                Descript            
      Unique      ion      Continous
      Subject      Of        Level  
      Identif   Planned    Biomarker
        ier       Arm          1    
      ------------------------------
      AB12345   B:         4.5749910
         -      Placebo     1339464 
      CHN-1-                        
      id-307                        
      AB12345   B:         10.262734
         -      Placebo     0069523 
      CHN-11-                       
      id-220                        
      AB12345   C: Combi   6.9067988
         -      nation      141075  
      CHN-15-                       
      id-201                        
      AB12345   C: Combi   4.0554627
         -      nation      7230382 
      CHN-15-                       
      id-262                        
      AB12345   A: Drug    14.424933
         -      X           692778  
      CHN-3-                        
      id-128                        
      AB12345   B:         6.2067627
         -      Placebo     167943  
      CHN-7-                        
      id-267                        
      AB12345   C: Combi   4.9972257
         -      nation      3047567 
      NGA-11-                       
      id-173                        
      AB12345   C: Combi   2.8032395
         -      nation      6920649 
      RUS-3-                        
      id-378                        
      AB12345   B:         2.8551641
         -      Placebo     9937308 
      USA-1-                        
      id-261                        
      AB12345   A: Drug    0.4635604
         -      X          41314472 
      USA-1-                        
       id-45                        

# as_listing produces correct output when default_formatting is specified

    Code
      res
    Output
       [1] "       Unique            Description                                "
       [2] "       Subject                Of                                    "
       [3] "     Identifier          Planned Arm     Continous Level Biomarker 1"
       [4] "--------------------------------------------------------------------"
       [5] "AB12345-CHN-1-id-307    B: Placebo                              4.57"
       [6] "AB12345-CHN-11-id-220   B: Placebo                         <No data>"
       [7] "AB12345-CHN-15-id-201   C: Combination                     <No data>"
       [8] "AB12345-CHN-15-id-262   C: Combination                          4.06"
       [9] "AB12345-CHN-3-id-128    A: Drug X                              14.42"
      [10] "AB12345-CHN-7-id-267    B: Placebo                         <No data>"
      [11] "AB12345-NGA-11-id-173   C: Combination                          5.00"
      [12] "AB12345-RUS-3-id-378    C: Combination                     <No data>"
      [13] "AB12345-USA-1-id-261    B: Placebo                              2.86"
      [14] "AB12345-USA-1-id-45     A: Drug X                               0.46"

# as_listing produces correct output when col_formatting is specified

    Code
      res
    Output
       [1] "       Unique           Description                              "
       [2] "       Subject              Of                                   "
       [3] "     Identifier         Planned Arm   Continous Level Biomarker 1"
       [4] "-----------------------------------------------------------------"
       [5] " AB12345-CHN-1-id-307   ARM #: 2           4.57499101339464      "
       [6] "AB12345-CHN-11-id-220   -                  10.2627340069523      "
       [7] "AB12345-CHN-15-id-201   -                   6.9067988141075      "
       [8] "AB12345-CHN-15-id-262   ARM #: 3           4.05546277230382      "
       [9] " AB12345-CHN-3-id-128   ARM #: 1            14.424933692778      "
      [10] " AB12345-CHN-7-id-267   -                   6.2067627167943      "
      [11] "AB12345-NGA-11-id-173   ARM #: 3           4.99722573047567      "
      [12] " AB12345-RUS-3-id-378   -                  2.80323956920649      "
      [13] " AB12345-USA-1-id-261   ARM #: 2           2.85516419937308      "
      [14] "  AB12345-USA-1-id-45   ARM #: 1           0.463560441314472     "

---

    Code
      cat(toString(matrix_form(lsting), hsep = "-"))
    Output
             Unique                                      
             Subject                                     
           Identifier         Continous Level Biomarker 1
      ---------------------------------------------------
      AB12345-CHN-1-id-307                 5             
      AB12345-CHN-11-id-220               10             
      AB12345-CHN-15-id-201                7             
      AB12345-CHN-15-id-262                4             
      AB12345-CHN-3-id-128                14             
      AB12345-CHN-7-id-267                 6             
      AB12345-NGA-11-id-173                5             
      AB12345-RUS-3-id-378                 3             
      AB12345-USA-1-id-261                 3             
       AB12345-USA-1-id-45                 0             

# listings support newline characters

    Code
      res
    Output
       [1] "main_title: argh"                                      
       [2] "asr"                                                   
       [3] "subtitle: argh"                                        
       [4] "asr"                                                   
       [5] "sada"                                                  
       [6] ""                                                      
       [7] "------------------------------------------------------"
       [8] "                                                      "
       [9] "                                                      "
      [10] "       Unique           Description          a        "
      [11] "       Subject              Of                        "
      [12] "     Identifier         Planned Arm          n        "
      [13] "------------------------------------------------------"
      [14] "AB12345-CHN-11-id-220   -             10.2627340069523"
      [15] "                        asd                           "
      [16] "AB12345-CHN-15-id-262   ARM #: 3      4.05546277230382"
      [17] " AB12345-RUS-3-id-378   -             2.80323956920649"
      [18] "                        asd                           "
      [19] "             aaatrial   ARM #: 1      14.424933692778 "
      [20] "                trial                                 "
      [21] "------------------------------------------------------"
      [22] ""                                                      
      [23] "main_footer: argh"                                     
      [24] "asr"                                                   
      [25] "sada"                                                  
      [26] ""                                                      
      [27] "prov_footer: argh"                                     
      [28] "asr"                                                   
      [29] "sada"                                                  

# listings supports horizontal separators

    Code
      as_listing(df = data.frame(one_col = c("aa", "aa", "b")), key_cols = "one_col",
      add_trailing_sep = "one_col", trailing_sep = "+")
    Output
      one_col
      ———————
        aa   
             
      +++++++
         b   

