PROGRAM generate

USE libxl

TYPE(C_PTR) book, sheet, null
INTEGER err

book = xlCreateXMLBook()
sheet = xlBookAddSheet(book, "mySheet", null)    
err = xlSheetWriteStr(sheet, 2, 1, "Hello, World !", null);
err = xlSheetWriteNum(sheet, 3, 1, 1000, null);    
err = xlBookSave(book, "example.xlsx")
CALL xlBookRelease(book)
 
END PROGRAM
