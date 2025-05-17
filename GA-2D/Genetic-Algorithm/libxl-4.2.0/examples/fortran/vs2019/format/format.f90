PROGRAM xformat

USE libxl

TYPE(C_PTR) book, sheet, format1, font1, null
INTEGER err
   
book = xlCreateXMLBook()

font1 = xlBookAddFont(book, null)
CALL xlFontSetName(font1, "Impact")
CALL xlFontSetSize(font1, 36)

format1 = xlBookAddFormat(book, null)
CALL xlFormatSetAlignH(format1, ALIGNH_CENTER)
CALL xlFormatSetBorder(format1, BORDERSTYLE_MEDIUMDASHDOTDOT)
CALL xlFormatSetBorderColor(format1, COLOR_RED)
err = xlFormatSetFont(format1, font1)

sheet = xlBookAddSheet(book, "Custom", null)    
err = xlSheetWriteStr(sheet, 2, 1, "Format", format1)
err = xlSheetSetCol(sheet, 1, 1, 25, null, 0)
err = xlBookSave(book, "format.xlsx");

END PROGRAM

    
    