#include "Gra.ch"
#include "Xbp.ch"
#include "Common.ch"
#include "Inkey.ch"

*************************
#include "ot4xb.ch"
#include "HBLibXl.CH"
*************************

procedure main()
   local oBook, oSheet, cFile
   local oFormat, cCell, nRow, nCol, dDate
   local cLName := GETENV("LIBXL_NAME") // nur fr meine Entwicklung, normalerweise fest einbauen (Funktion, *.CH, etc.)
   local cLKey  := GETENV("LIBXL_KEY")  // only for my testing, normaly you will write it in the code (function, *.CH, etc.)


   set date german

   set alternate to (cPathRemoveExt(appname())+".txt")
   set alternate on

   cFile := "Test-Macro"  // OEM

   ? "Test mit XbpCrt() / Console / OEM Anwendung !"
   ?
   ? "ot4xb() ? = ",ot4xb()
   ?
   ? "Erstelle XLSM Datei direkt mit den gegebenen Funktionen (oBook KANN NIL sein !):"
   ?
   ? "Dateiname: ",cFile," kann man die Endung weg lassen ? "
   ?

   oBook := xlCreateXLSMBook(cLName, cLKey)       // Macros m”glich ! Entspricht xlCreateXMLBook(cLName, cLKey, .t. )
   * oBook := xlCreateXMLBook(cLName, cLKey, .t. )  // Macros m”glich !

   if oBook # NIL
      ? "oBook XML erstellt !"
      oSheet := oBook:BookAddSheet("Test1 Ž™š ")
      if ! empty(oSheet)
        oSheet:SheetWriteStr(1,1, "Macros sind erlaubt !")
        ? "Writing date ... create double ... format ... not very usefull !"
        oSheet:SheetWriteStr(15,4, "Date:")
        oFormat := oBook:BookaddFormat()
        oFormat:FormatSetNumFormat(NUMFORMAT_DATE)
        * oFormat:FormatSetShrinkToFit(.t.) // verkleinert den Text bis er passt / smaller text size if needed
        ? "Datum schreiben     25.12.2013 ..."
        nRow := 15
        nCol := 5
        oSheet:SheetWriteNum(nRow,nCol,oBook:BookDatePack(2013, 12, 25), oFormat)
        ? oSheet:SheetSetCol(5,5,-1) // Spalte 5 auf automatische Breite einstellen.
        ? "Datum wieder lesen  "
        dDate := oSheet:SheetReadDate(nRow,nCol)
        ?? dtoc(dDate)," das wurde ausgelesen, + 5 Tage ..."
        dDate += 5 // add 5 days
        nRow++
        ? " + 5 days  ...     ",dDate
        oSheet:SheetWriteDate(nRow,nCol,dDate)
        cCell := "AA5"
        oSheet:SheetAddrToRowCol(cCell,@nRow, @nCol)
        ? "=>",cCell,;
        oSheet:SheetWriteStr( nRow, nCol, cCell+" = R:"+str(nRow,3)+" C:"+str(nCol,3))
        cCell := "IV5"
        oSheet:SheetAddrToRowCol(cCell,@nRow, @nCol)
        ? "=>",cCell,;
        oSheet:SheetWriteStr( nRow, nCol, cCell+" = R:"+str(nRow,3)+" C:"+str(nCol,3))
      endif
      ? "oBook save: "
        if ! oBook:BookSave( cFile )  // oBook kennt die richtige Endung, oBook knows the right extension
           ? "Fehler beim Speichern '",oBook:BookErrorMessage(),"'"
        else
           ?? " gespeichert !"
        endif
        oBook:destroy()        // => xlBookRelease()
      // KEIN ELSE Zweig, keine Fehlermeldung ... no error message if you don't need it
   endif

   ? "Ende in 10 Sekunden, oder durch Tastendruck ..."

   inkey(10)

return


