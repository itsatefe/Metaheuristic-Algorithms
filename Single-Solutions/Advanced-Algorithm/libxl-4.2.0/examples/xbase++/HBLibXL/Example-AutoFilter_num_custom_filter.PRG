#include "Gra.ch"
#include "Xbp.ch"
#include "Common.ch"
#include "Inkey.ch"

*************************
#include "ot4xb.ch"
#include "HBLibXl.CH"
*************************

* Example from Homepage: https://www.libxl.com/autoFilterExampleNumCustom.html

procedure main()
   // here is my license info, replace it with your data
   local cLName := GETENV("LIBXL_NAME") // nur für meine Entwicklung, normalerweise fest einbauen (Funktion, *.CH, etc.)
   local cLKey  := GETENV("LIBXL_KEY")  // only for my testing, normaly you will write it in the code (function, *.CH, etc.)
   local cFile  := "EX_AutoFilter_NumCustom.xlsx"

   set date german
   set charset to ansi       // ANSI

   cls
   ? "Name ~"+cLName+"~"
   ? "Key  ~"+cLKey+"~"

   set alternate to Test_LogFile.txt
   set alternate on

   ? "Write ",cFile

   test( cFile, cLName, cLKey )

   ? "Ende in 3 Sekunden, oder durch Tastendruck ..."

   inkey(3)

return

procedure test( cFile, cLName, cLKey  )
   local oBook, oSheet, oAutoFilter, oFilterColumn
   // my extension
   local nOp1, iV1, nOp2, iV2, nAndOp

// Create example data array

   oBook := xlCreateXLSXBook(cLName,cLKey)
   if oBook <> NIL
      oSheet := oBook:BookAddSheet( "Example Number Custom Filter" )

      oSheet:SheetWriteStr( 2, 1, "Country")
      oSheet:SheetWriteStr( 2, 2, "Road injures")
      oSheet:SheetWriteStr( 2, 3, "Smoking")
      oSheet:SheetWriteStr( 2, 4, "Suicide")

      oSheet:SheetWriteStr( 3, 1, "USA")
      oSheet:SheetWriteNum( 3, 2, 64)
      oSheet:SheetWriteNum( 3, 3, 69)
      oSheet:SheetWriteNum( 3, 4, 49)

      oSheet:SheetWriteStr( 4, 1, "UK")
      oSheet:SheetWriteNum( 4, 2, 94)
      oSheet:SheetWriteNum( 4, 3, 55)
      oSheet:SheetWriteNum( 4, 4, 64)

      oSheet:SheetWriteStr( 5, 1, "Germany")
      oSheet:SheetWriteNum( 5, 2, 88)
      oSheet:SheetWriteNum( 5, 3, 46)
      oSheet:SheetWriteNum( 5, 4, 55)

      oSheet:SheetWriteStr( 6, 1, "Switzerland")
      oSheet:SheetWriteNum( 6, 2, 93)
      oSheet:SheetWriteNum( 6, 3, 54)
      oSheet:SheetWriteNum( 6, 4, 50)

      oSheet:SheetWriteStr( 7, 1, "Spain")
      oSheet:SheetWriteNum( 7, 2, 86)
      oSheet:SheetWriteNum( 7, 3, 47)
      oSheet:SheetWriteNum( 7, 4, 69)

      oSheet:SheetWriteStr( 8, 1, "Italy")
      oSheet:SheetWriteNum( 8, 2, 75)
      oSheet:SheetWriteNum( 8, 3, 52)
      oSheet:SheetWriteNum( 8, 4, 71)

      oSheet:SheetWriteStr( 9, 1, "Greece")
      oSheet:SheetWriteNum( 9, 2, 67)
      oSheet:SheetWriteNum( 9, 3, 23)
      oSheet:SheetWriteNum( 9, 4, 87)

      oSheet:SheetWriteStr( 10, 1, "Japan")
      oSheet:SheetWriteNum( 10, 2, 91)
      oSheet:SheetWriteNum( 10, 3, 57)
      oSheet:SheetWriteNum( 10, 4, 36)

      oAutoFilter := oSheet:SheetAutoFilter()
      oAutoFilter:AutoFilterSetRef(2, 10, 1, 4)

      // shows countries with road injures < 70 or with road injures > 90
      // column->setCustomFilter(OPERATOR_LESS_THAN, L"70", OPERATOR_GREATER_THAN, L"90");   // 4 Parameters, this need the EX function

      oFilterColumn := oAutoFilter:AutoFilterColumn(1)
//       This just use the OPERATOR_LESS_THAN, "70"
//       oFilterColumn:FilterColumnSetCustomFilter( OPERATOR_LESS_THAN, "70", OPERATOR_GREATER_THAN, "90" )
      oFilterColumn:FilterColumnSetCustomFilterEX( OPERATOR_LESS_THAN, "70", OPERATOR_GREATER_THAN, "90" )  // the extended version
      oAutoFilter:AutoFilterSetSort(1, .t. )

      // my extension, look for the filter expression

      nOp1   := 0
      iV1    := 0
      nOp2   := 0
      iV2    := 0
      nAndOp := 0

      if oFilterColumn:FilterColumnGetCustomFilter( @nOp1, @iV1, @nOp2, @iV2, @nAndOp ) // Gets the custom filter criteria:
         ? "GetCustomFilter: ",nOp1, iV1, nOp2, iV2, nAndOp
         msgbox("GetCustomFilter: OK !")
      else
         ? "GetCustomFilter - Error: ", oBook:BookErrorMessage()
         msgbox("GetCustomFilter: "+oBook:BookErrorMessage())
      endif

      oSheet:SheetApplyFilter()

      oBook:BookSave( cFile )
      oBook:BookRelease()
      oBook:Destroy()

   endif
return
