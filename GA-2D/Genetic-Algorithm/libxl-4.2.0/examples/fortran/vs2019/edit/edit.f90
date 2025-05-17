PROGRAM edit

USE libxl

TYPE(C_PTR) book, sheet, null
REAL(C_DOUBLE) d
INTEGER err
    
book = xlCreateXMLBook()

IF(xlBookLoad(book, "..\generate\example.xlsx").ne.0) THEN
    sheet = xlBookGetSheet(book, 0)        
    d = xlSheetReadNum(sheet, 3, 1, null)
    err = xlSheetWriteNum(sheet, 3, 1, d * 2, null)
    err = xlSheetWriteStr(sheet, 4, 1, "new string", null)        
    err = xlBookSave(book, "..\generate\example.xlsx")
END IF
CALL xlBookRelease(book)

END PROGRAM
    
    