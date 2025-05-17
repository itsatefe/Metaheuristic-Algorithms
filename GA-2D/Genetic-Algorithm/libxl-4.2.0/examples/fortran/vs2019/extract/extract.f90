PROGRAM extract

USE libxl

TYPE(C_PTR) book, sheet, null
character(:), allocatable :: str
REAL(C_DOUBLE) d
INTEGER err
 
book = xlCreateXMLBook()
IF(xlBookLoad(book, "..\generate\example.xlsx").ne.0) THEN    
    sheet = xlBookGetSheet(book, 0)        
    str = xlSheetReadStr(sheet, 2, 1, null)
    PRINT *, str
    d = xlSheetReadNum(sheet, 3, 1, null)
    PRINT *, d        
END IF       
CALL xlBookRelease(book)

END PROGRAM