# align_colnames can change alignment for column titles

    Code
      cat(toString(out[[2]]))
    Output
      Unique Subject Identifier      A   
      ———————————————————————————————————
        AB12345-BRA-1-id-134      AB12345

---

    Code
      cat(toString(out[[2]]))
    Output
      Unique Subject Identifier   A      
      ———————————————————————————————————
        AB12345-BRA-1-id-134      AB12345

