#include "Gra.ch"
#include "Xbp.ch"
#include "Common.ch"
#include "Inkey.ch"

*************************
#include "ot4xb.ch"
#include "HBLibXl.CH"
*************************

procedure main()
   // here are my license infos
   local cLName := GETENV("LIBXL_NAME") // nur für meine Entwicklung, normalerweise fest einbauen (Funktion, *.CH, etc.)
   local cLKey  := GETENV("LIBXL_KEY")  // only for my testing, normaly you will write it in the code (function, *.CH, etc.)


   set date german
   set charset to ansi       // ANSI

   cls
   ? "Name ~"+cLName+"~"
   ? "Key  ~"+cLKey+"~"


   ? "Write Test3.xls"

   test( "Test3.xls", cLName, cLKey )

   ? "Ende in 3 Sekunden, oder durch Tastendruck ..."

   inkey(3)

return

procedure test( cFile, cLName, cLKey  )
   local oBook, oSheet, n, nRow, oFont, oHeader, aHeader, aData, aTotal, oAlign, aWidth
   local nDataRows, nDataCols, k, xValue, nRowIni, nRowEnd, cFormula

   DEFAULT cFile TO "Test.xls"

// Create example data array
   aData := {}
   FOR n := 1 TO 6
      AAdd( aData, { Date()+(n-1), "Description "+str(n,2), n*100, Sqrt(n*100) } )
   NEXT
   aHeader   := { "DATE", "DESCRIPTION", "INTEGER", "FLOAT" }
   aWidth    := { 12, 30, 15, 15 }
   aTotal    := { 3, 4 }
   nDataRows := Len( aData )
   nDataCols := Len( aData[1] )

   oBook := xlCreateBook(cLName,cLKey)
   if oBook <> NIL
      oSheet := oBook:BookAddSheet( "Test1" )
      oSheet:SheetWriteStr( 0, 0, "Hello World XL" )
      oSheet:SheetWriteStr( 1, 0, DTOC(Date())+" "+Time() )

      oFont := oBook:BookAddFont()
      oFont:FontSetBold()
      oFont:FontSetColor(COLOR_RED)
//    oFont:FontSetName("Arial")
//    oFont:FontSetSize(12)

      oAlign := oBook:BookAddFormat()
      oAlign:FormatSetAlignH(ALIGNH_CENTER)

      nRow := 4
      for k := 1 to nDataCols
         oAlign  := oBook:BookAddFormat()
         oHeader := oBook:BookAddFormat()
         oHeader:FormatSetNumFormat( NUMFORMAT_TEXT )
         oHeader:FormatSetFont( oFont )
         oHeader:FormatSetFillPattern( FILLPATTERN_SOLID )
         oHeader:FormatSetPatternForegroundColor( COLOR_LIGHTGREEN )

         xValue := aData[1,k]
         do case
         case ValType( xValue ) == "C"
            oAlign:FormatSetAlignH( ALIGNH_LEFT )
            oHeader:FormatSetAlignH( ALIGNH_LEFT )
         case ValType( xValue ) == "N"
            oAlign:FormatSetAlignH( ALIGNH_RIGHT )
//          oAlign:FormatSetNumFormat( NUMFORMAT_NUMBER_SEP_D2 )
            oAlign:FormatSetNumFormat( oBook:BookAddCustomNumFormat( "###,###,###.000" ) )
            oHeader:FormatSetAlignH( ALIGNH_RIGHT )
         case ValType( xValue ) == "D"
            oAlign:FormatSetAlignH( ALIGNH_CENTER )
            oAlign:FormatSetNumFormat( NUMFORMAT_DATE )
            oHeader:FormatSetAlignH( ALIGNH_CENTER )
         endcase
         oSheet:SheetSetCol( k-1, k-1, aWidth[k], oAlign )
         oSheet:SheetWriteStr( nRow, k-1, aHeader[k], oHeader )
         oAlign  := NIL
         oHeader := NIL
      next
      nRow++
      nRowIni := nRow
      nRowEnd := nRow
      for n := 1 to nDataRows
         for k := 1 to nDataCols
            xValue := aData[n,k]
            do case
            case ValType( xValue ) == "C"
               oSheet:SheetWriteStr( nRow,  k-1, xValue )
            case ValType( xValue ) == "N"
               oSheet:SheetWriteNum( nRow,  k-1, xValue )
            case ValType( xValue ) == "D"
               oSheet:SheetWriteDate( nRow, k-1, xValue )
            endcase
         next
         nRowEnd := nRow
         nRow++
      next
//    oSheet:SheetSetRow( nRow, 15 )
      nRow++
      for n := 1 to Len(aTotal)
         k := aTotal[n] - 1
         cFormula := "=SUM(" + oSheet:SheetRowColToAddr( nRowIni, k ) + ":" + oSheet:SheetRowColToAddr( nRowEnd, k ) + ")"
//         cFormula := "SUM(" + oSheet:SheetRowColToAddr( nRowIni, k ) + ":" + oSheet:SheetRowColToAddr( nRowEnd, k ) + ")"
         oSheet:SheetWriteFormula( nRow, k, cFormula )
      next

      oBook:BookSave( cFile )
      oBook:BookRelease()
      oBook:Destroy()

//    StartFile( cFile )

   endif
return
