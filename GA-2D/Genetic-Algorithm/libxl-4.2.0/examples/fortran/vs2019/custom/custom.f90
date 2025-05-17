PROGRAM custom

USE libxl

TYPE(C_PTR) book, sheet, f(6), null
INTEGER c(6), err

book = xlCreateXMLBook()

c(1) = xlBookAddCustomNumFormat(book, "0.0")
c(2) = xlBookAddCustomNumFormat(book, "0.00")
c(3) = xlBookAddCustomNumFormat(book, "0.000")
c(4) = xlBookAddCustomNumFormat(book, "0.0000")
c(5) = xlBookAddCustomNumFormat(book, "#,###.00 $")
c(6) = xlBookAddCustomNumFormat(book, "#,###.00 $[Black][<1000];#,###.00 $[Red][>=1000]")

DO i = 1, 6  
  f(i) = xlBookAddFormat(book, null)
  CALL xlFormatSetNumFormat(f(i), c(i))
END DO

sheet = xlBookAddSheet(book, "Custom formats", null)

err = xlSheetSetCol(sheet, 0, 0, 20, null, 0);

err = xlSheetWriteNum(sheet, 2, 0, 25.718, f(1));
err = xlSheetWriteNum(sheet, 3, 0, 25.718, f(2));
err = xlSheetWriteNum(sheet, 4, 0, 25.718, f(3));
err = xlSheetWriteNum(sheet, 5, 0, 25.718, f(4));
err = xlSheetWriteNum(sheet, 7, 0, 1800.5, f(5));
err = xlSheetWriteNum(sheet, 9, 0, 500, f(6));
err = xlSheetWriteNum(sheet, 10, 0, 1600, f(6));    

err = xlBookSave(book, "custom.xlsx")

CALL xlBookRelease(book)
    
END PROGRAM
    