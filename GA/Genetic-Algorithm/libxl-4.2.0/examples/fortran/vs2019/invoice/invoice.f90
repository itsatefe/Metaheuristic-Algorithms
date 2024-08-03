PROGRAM invoice

USE libxl

TYPE(C_PTR) book, sheet, boldFont, titleFont, titleFormat, headerFormat, descriptionFormat, amountFormat, totalLabelFormat, totalFormat, signatureFormat, null
REAL(C_DOUBLE) d
INTEGER err

book = xlCreateXMLBook()

boldFont = xlBookAddFont(book, null)
CALL xlFontSetBold(boldFont, 1)

titleFont = xlBookAddFont(book, null)
CALL xlFontSetName(titleFont, "Arial Black")
CALL xlFontSetSize(titleFont, 16)

titleFormat = xlBookAddFormat(book, null)
err = xlFormatSetFont(titleFormat, titleFont)

headerFormat = xlBookAddFormat(book, null)
CALL xlFormatSetAlignH(headerFormat, ALIGNH_CENTER)
CALL xlFormatSetBorder(headerFormat, BORDERSTYLE_THIN)
err = xlFormatSetFont(headerFormat, boldFont)
CALL xlFormatSetFillPattern(headerFormat, FILLPATTERN_SOLID)
CALL xlFormatSetPatternForegroundColor(headerFormat, COLOR_TAN)

descriptionFormat = xlBookAddFormat(book, null)
CALL xlFormatSetBorderLeft(descriptionFormat, BORDERSTYLE_THIN)

amountFormat = xlBookAddFormat(book, null)
CALL xlFormatSetNumFormat(amountFormat, NUMFORMAT_CURRENCY_NEGBRA)
CALL xlFormatSetBorderLeft(amountFormat, BORDERSTYLE_THIN)
CALL xlFormatSetBorderRight(amountFormat, BORDERSTYLE_THIN)

totalLabelFormat = xlBookAddFormat(book, null)
CALL xlFormatSetBorderTop(totalLabelFormat, BORDERSTYLE_THIN)
CALL xlFormatSetAlignH(totalLabelFormat, ALIGNH_RIGHT)
err = xlFormatSetFont(totalLabelFormat, boldFont)

totalFormat = xlBookAddFormat(book, null)
CALL xlFormatSetNumFormat(totalFormat, NUMFORMAT_CURRENCY_NEGBRA)
CALL xlFormatSetBorder(totalFormat, BORDERSTYLE_THIN)
err = xlFormatSetFont(totalFormat, boldFont)
CALL xlFormatSetFillPattern(totalFormat, FILLPATTERN_SOLID)
CALL xlFormatSetPatternForegroundColor(totalFormat, COLOR_YELLOW)

signatureFormat = xlBookAddFormat(book, null)
CALL xlFormatSetAlignH(signatureFormat, ALIGNH_CENTER)
CALL xlFormatSetBorderTop(signatureFormat, BORDERSTYLE_THIN)

sheet = xlBookAddSheet(book, "Invoice", null)

err = xlSheetWriteStr(sheet, 2, 1, "Invoice No. 3568", titleFormat)
err = xlSheetWriteStr(sheet, 4, 1, "Name: John Smith", null)
err = xlSheetWriteStr(sheet, 5, 1, "Address: San Ramon, CA 94583 USA", null)
err = xlSheetWriteStr(sheet, 7, 1, "Description", headerFormat)
err = xlSheetWriteStr(sheet, 7, 2, "Amount", headerFormat)
err = xlSheetWriteStr(sheet, 8, 1, "Ball-Point Pens", descriptionFormat)
err = xlSheetWriteNum(sheet, 8, 2, 85, amountFormat)
err = xlSheetWriteStr(sheet, 9, 1, "T-Shirts", descriptionFormat)
err = xlSheetWriteNum(sheet, 9, 2, 150, amountFormat)
err = xlSheetWriteStr(sheet, 10, 1, "Tea cups", descriptionFormat)
err = xlSheetWriteNum(sheet, 10, 2, 45, amountFormat)
err = xlSheetWriteStr(sheet, 11, 1, "Total:", totalLabelFormat)
err = xlSheetWriteFormula(sheet, 11, 2, "=SUM(C9:C11)", totalFormat)
err = xlSheetWriteStr(sheet, 14, 2, "Signature", signatureFormat)

err = xlSheetSetCol(sheet, 1, 1, 40, null, 0);
err = xlSheetSetCol(sheet, 2, 2, 15, null, 0);

err = xlBookSave(book, "invoice.xlsx")

CALL xlBookRelease(book)

END PROGRAM
    
    