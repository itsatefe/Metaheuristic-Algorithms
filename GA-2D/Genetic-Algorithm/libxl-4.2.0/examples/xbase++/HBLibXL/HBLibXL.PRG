*********************************************************************
* HBLibXL.PRG - Klassendefinitionen für Xbase++ und LibXL.DLL
* HBLibXL.PRG - CLASS CODE for Xbase++ und LibXL.DLL         
*
* generiert mit LibXL_XB_MakeClass
*
* von / from Hubert Brandel  eMail: Hubert.Brandel@gmx.de
*
* Die Verwendung ist frei und kostenlos, bitte Fragen zu diesem code im Forum stellen.
* Fehler oder Verbesserungsvorschläge bitte an meine eMail-Adresse mit Betreff 'HBLibXL' senden.
* Fragen zu LibXL bitte beim Support stellen, ich habe damit wenig Erfahrung.
*
* This is free code. Send Questions about this code, errors etc. to my eMail-adress.
* Please send general questions about LibXL to there support.
*
* Version 2.00 - LibXL.DLL 3.9.4.3 vom 03.02.2022 (2022-02-03)
*
* Aufruf / usage :
*
*   xlCreateBook(cName,cKey)    => oBook => *.XLS ... 
*                               or oBook := xlCreateBook()  
*                                  oBook:BookSetKey(cName,cKey) 
*
*   xlCreateXMLBook(cName,cKey) => oBook => *.XLSX ... 
*                               or oBook := xlCreateXMLBook()  
*                                  oBook:BookSetKey(cName,cKey) 
*
*  Links:
*  - Xbase++ - Alaska Inc. www.alaska-software.com   compiler
*  - LibXL   - www.LibXL.com                         LibXL.dll (demo)
*  - ot4xb   - www.xbwin.com                         ot4xb.dll  
*
* My Homepage:  http://www.familie-brandel.de  (german   
*               http://www.familie-brandel.de/index_e.html (english) 
*
* German Forum: www.xbaseforum.de
*
*********************************************************************************


#include 'Gra.ch'               
#include 'Xbp.ch'               
#include 'Common.ch'            
#include 'ot4xb.ch'             
#include 'HBLibXL.CH'   

// Q, QQ etc. von/from Osvaldo Ramírez   
// ? xxxx => oSheet:Q(...xxxx...)        
#command  ?  [<list,...>]  =>  oSheet:Q( <list> )  
#command  ?? [<list,...>]  =>  oSheet:QQ( <list> ) 

*--------------------------------------------------------------------------------
function xlCreateBook(cName,cKey)          
   local oHBE, oBook                       
   oHBE  := HBLibXL(cName,cKey)            
   oBook := oHBE:CreateBook()              
return oBook                               
*--------------------------------------------------------------------------------
function xlCreateXMLBook(cName,cKey,UseMacros) 
   local oBook
   if empty(UseMacros)
      oBook := xlCreateXLSXBook(cName,cKey)
   else
      oBook := xlCreateXLSMBook(cName,cKey)
   endif
return oBook
*--------------------------------------------------------------------------------
function xlCreateXLSXBook(cName,cKey)      
   local oHBE, oBook                       
   oHBE  := HBLibXL(cName,cKey)            
   oBook := oHBE:CreateXMLBook(.f.)        
return oBook                               
*--------------------------------------------------------------------------------
function xlCreateXLSMBook(cName,cKey)      
   local oHBE, oBook                       
   oHBE  := HBLibXL(cName,cKey)            
   oBook := oHBE:CreateXMLBook(.t.)        
return oBook                               
*--------------------------------------------------------------------------------
function HBLibXL(cName,cKey)               
return _HBLibXL(cName,cKey):new()          
 
*********************************************************************************
CLASS _HBLibXL                             

   PROTECTED                               
      CLASS VAR LiName, LiKey, cDllName SHARED 
      METHOD ForceAnsi                     
      METHOD ReadString                    
      METHOD doCreateBook                  

   EXPORTED                                
      VAR hHandle                          
      CLASS METHOD initClass               
      METHOD init                          
      METHOD IsDemoMode                    
      METHOD IsAnsi                        
      METHOD CreateBook                    
      METHOD CreateXMLBook                 

ENDCLASS                                   
*--------------------------------------------------------------------------------
CLASS METHOD _HBLibXL:initClass(cName,cKey)
   if ! empty(cName) .and. ! empty(cKey)   
      ::LiName := cName                    
      ::LiKey  := cKey                     
   endif                                   
return self                                
*--------------------------------------------------------------------------------
METHOD _HBLibXL:init(cName,cKey)           
   if ! empty(cName) .and. ! empty(cKey)   
      ::LiName  := cName                   
      ::LiKey   := cKey                    
   endif                                   
   ::hHandle := 0                          
return self                                
*--------------------------------------------------------------------------------
METHOD _HBLibXL:IsDemoMode() 
   local lIsDemo := .t., cFile, oBook, oSheet 
   if ! empty(::LiName) .and. ! empty(::LiKey) 
      cFile := cGetTmpPath()+'XLTMP'+dtos(date())+'.XLS' 
      oBook := xlCreateBook() 
      if ! empty(oBook) 
         oSheet := oBook:BookAddSheet('Test')
         if ! empty(oSheet) 
            oSheet:SheetWriteStr( 5, 5, '5/5', nil)
         endif 
         oBook:BookSave( cFile ) 
         oBook:BookRelease() 
         oBook := xlCreateBook() 
         if ! empty(oBook) 
            if oBook:BookLoad( cFile ) 
               oSheet := oBook:BookGetSheet(0) 
               if ! empty(oSheet) 
                  if oSheet:SheetCellType(0,0) = CELLTYPE_EMPTY 
                     // no demo, Name and Key are set ! 
                     lIsDemo := .f. 
                  endif 
               endif 
            endif 
            oBook:BookRelease() 
         endif 
      endif 
      delete file (cFile) 
      if lIsDemo 
         ::LiName := nil 
         ::LiKey  := nil 
      endif 
   endif 
return lIsDemo 
*--------------------------------------------------------------------------------
METHOD _HBLibXL:IsAnsi()                   
return ( set(_SET_CHARSET) = 0 )           
*--------------------------------------------------------------------------------
METHOD _HBLibXL:ForceAnsi( cString )       
   DEFAULT cString TO ''                   
   if ! ::IsAnsi() // EXE liefert OEM !    
      cString := ConvToAnsiCP(cString)     
   endif                                   
Return cString                             
*--------------------------------------------------------------------------------
METHOD _HBLibXL:ReadString( cString )      
   DEFAULT cString TO ''                   
   if ! ::IsAnsi() // EXE braucht OEM !    
      cString := ConvToOemCP(cString)      
   endif                                   
Return cString                             
*--------------------------------------------------------------------------------
METHOD _HBLibXL:CreateBook()               
Return ::doCreateBook(.f.)                 
*--------------------------------------------------------------------------------
METHOD _HBLibXL:CreateXMLBook(NeedMacros)  
Return ::doCreateBook(.t.,NeedMacros)      
*--------------------------------------------------------------------------------
METHOD _HBLibXL:doCreateBook(IsXML,NeedMacros) 
   local oBook, hHandle, cFunc, cExt 
   local bSaveError := ErrorBlock( {|e| Break(e)} ) 
   if ! IsXML 
      cFunc := 'xlCreateBookCA' 
      cExt  := '.XLS' 
   else 
      cFunc := 'xlCreateXMLBookCA' 
      if empty(NeedMacros)
         cExt  := '.xlsx' 
      else
         cExt  := '.xlsm' 
      endif 
   endif 
   BEGIN SEQUENCE 
      hHandle := FpQCall( {'LibXL', cFunc },'__sl' ) 
   RECOVER 
      ErrorBlock( bSaveError ) 
      hHandle := 0 
   END SEQUENCE 
   ErrorBlock( bSaveError ) 
   if empty(hHandle) 
      oBook := NIL 
   else 
      oBook := xlBook():new() 
      oBook:hHandle  := hHandle 
      oBook:cFileExt := cExt 
      if ! empty(::LiName) .and. ! empty(::LiKey) 
         oBook:BookSetKey(::LiName, ::LiKey ) 
      endif 
   endif 
return oBook 
*--------------------------------------------------------------------------------

*********************************************************************************
CLASS xlBook FROM _HBLibXL       

   PROTECTED                               

   EXPORTED                                
      VAR cFileExt                         
      METHOD init                          
      METHOD destroy                       
      METHOD BookActiveSheet 
      METHOD BookAddCustomNumFormat 
      METHOD BookAddFont 
      METHOD BookAddFormat 
      METHOD BookAddPicture2 
      METHOD BookAddPicture 
      METHOD BookAddPictureAsLink 
      METHOD BookAddRichString 
      METHOD BookAddSheet 
      METHOD BookBiffVersion 
      METHOD BookCalcMode 
      METHOD BookColorPack 
      METHOD BookColorUnpack 
      METHOD BookCustomNumFormat 
      METHOD BookDatePack 
      METHOD BookDateUnpack 
      METHOD BookDefaultFont 
      METHOD BookDelSheet 
      METHOD BookErrorMessage 
      METHOD BookFont 
      METHOD BookFontSize 
      METHOD BookFormat 
      METHOD BookFormatSize 
      METHOD BookGetPicture 
      METHOD BookGetSheet 
      METHOD BookGetSheetName 
      METHOD BookInsertSheet 
      METHOD BookIsDate1904 
      METHOD BookIsTemplate 
      METHOD BookLoad 
      METHOD BookLoadInfo 
      METHOD BookLoadPartially 
      METHOD BookLoadPartiallyUsingTempFile 
      METHOD BookLoadRaw 
      METHOD BookLoadRawPartially 
      METHOD BookLoadUsingTempFile 
      METHOD BookMoveSheet 
      METHOD BookPictureSize 
      METHOD BookRefR1C1 
      METHOD BookRelease 
      METHOD BookRgbMode 
      METHOD BookSave 
      METHOD BookSaveRaw 
      METHOD BookSaveUsingTempFile 
      METHOD BookSetActiveSheet 
      METHOD BookSetCalcMode 
      METHOD BookSetDate1904 
      METHOD BookSetDefaultFont 
      METHOD BookSetKey 
      METHOD BookSetLocale 
      METHOD BookSetRefR1C1 
      METHOD BookSetRgbMode 
      METHOD BookSetTemplate 
      METHOD BookSheetCount 
      METHOD BookSheetType 

ENDCLASS                                   
*--------------------------------------------------------------------------------
METHOD xlBook:init()             
   ::cFileExt := ''                        
return self                                
*--------------------------------------------------------------------------------
METHOD xlBook:destroy() 
   if ! empty(::hHandle) 
      ::BookRelease() 
      ::hHandle := 0 
   endif 
return self 
*--------------------------------------------------------------------------------

*********************************************************************************
CLASS xlSheet FROM _HBLibXL       

   HIDDEN                                  
      VAR qRow //  row counter used by Q() and QQ() 
      VAR qCol //  col counter used by Q() and QQ() 

   PROTECTED                               

   EXPORTED                                
      VAR oBook                            
      METHOD init                          
      * eigene / my own spezial METHOD     
      METHOD SheetReadDate                 
      METHOD SheetWriteDate                
      * user spezial METHOD                
      // Q, QQ etc. von Osvaldo Ramírez    
      METHOD Q    // starts a new row and prints text                       
      METHOD QQ   // prints text starting at current Row and Col            
      METHOD QRow // returns current qRow                                   
      METHOD QCol // returns current qCol relative to current pitch setting 

      METHOD SheetAddDataValidation 
      METHOD SheetAddDataValidationDouble 
      METHOD SheetAddDataValidationDoubleEx 
      METHOD SheetAddDataValidationEx 
      METHOD SheetAddHyperlink 
      METHOD SheetAddIgnoredError 
      METHOD SheetAddrToRowCol 
      METHOD SheetApplyFilter 
      METHOD SheetAutoFilter 
      METHOD SheetCellFormat 
      METHOD SheetCellType 
      METHOD SheetClear 
      METHOD SheetClearPrintArea 
      METHOD SheetClearPrintRepeats 
      METHOD SheetColHidden 
      METHOD SheetColWidth 
      METHOD SheetColWidthPx 
      METHOD SheetCopyCell 
      METHOD SheetDelHyperlink 
      METHOD SheetDelMerge 
      METHOD SheetDelMergeByIndex 
      METHOD SheetDelNamedRange 
      METHOD SheetDisplayGridlines 
      METHOD SheetFirstCol 
      METHOD SheetFirstFilledCol 
      METHOD SheetFirstFilledRow 
      METHOD SheetFirstRow 
      METHOD SheetFooter 
      METHOD SheetFooterMargin 
      METHOD SheetGetHorPageBreak 
      METHOD SheetGetHorPageBreakSize 
      METHOD SheetGetMerge 
      METHOD SheetGetNamedRange 
      METHOD SheetGetPicture 
      METHOD SheetGetPrintFit 
      METHOD SheetGetTopLeftView 
      METHOD SheetGetVerPageBreak 
      METHOD SheetGetVerPageBreakSize 
      METHOD SheetGroupCols 
      METHOD SheetGroupRows 
      METHOD SheetGroupSummaryBelow 
      METHOD SheetGroupSummaryRight 
      METHOD SheetHCenter 
      METHOD SheetHeader 
      METHOD SheetHeaderMargin 
      METHOD SheetHidden 
      METHOD SheetHyperlink 
      METHOD SheetHyperlinkSize 
      METHOD SheetInsertCol 
      METHOD SheetInsertColAndKeepRanges 
      METHOD SheetInsertRow 
      METHOD SheetInsertRowAndKeepRanges 
      METHOD SheetIsDate 
      METHOD SheetIsFormula 
      METHOD SheetIsRichStr 
      METHOD SheetLandscape 
      METHOD SheetLastCol 
      METHOD SheetLastFilledCol 
      METHOD SheetLastFilledRow 
      METHOD SheetLastRow 
      METHOD SheetMarginBottom 
      METHOD SheetMarginLeft 
      METHOD SheetMarginRight 
      METHOD SheetMarginTop 
      METHOD SheetMerge 
      METHOD SheetMergeSize 
      METHOD SheetName 
      METHOD SheetNamedRange 
      METHOD SheetNamedRangeSize 
      METHOD SheetPaper 
      METHOD SheetPictureSize 
      METHOD SheetPrintArea 
      METHOD SheetPrintGridlines 
      METHOD SheetPrintRepeatCols 
      METHOD SheetPrintRepeatRows 
      METHOD SheetPrintRowCol 
      METHOD SheetPrintZoom 
      METHOD SheetProtect 
      METHOD SheetReadBlank 
      METHOD SheetReadBool 
      METHOD SheetReadComment 
      METHOD SheetReadError 
      METHOD SheetReadFormula 
      METHOD SheetReadNum 
      METHOD SheetReadRichStr 
      METHOD SheetReadStr 
      METHOD SheetRemoveCol 
      METHOD SheetRemoveColAndKeepRanges 
      METHOD SheetRemoveComment 
      METHOD SheetRemoveDataValidations 
      METHOD SheetRemoveFilter 
      METHOD SheetRemovePicture 
      METHOD SheetRemovePictureByIndex 
      METHOD SheetRemoveRowAndKeepRanges 
      METHOD SheetRemoveRow 
      METHOD SheetRightToLeft 
      METHOD SheetRowColToAddr 
      METHOD SheetRowHeight 
      METHOD SheetRowHeightPx 
      METHOD SheetRowHidden 
      METHOD SheetSetAutoFitArea 
      METHOD SheetSetCellFormat 
      METHOD SheetSetCol 
      METHOD SheetSetColHidden 
      METHOD SheetSetDisplayGridlines 
      METHOD SheetSetFooter 
      METHOD SheetSetGroupSummaryBelow 
      METHOD SheetSetGroupSummaryRight 
      METHOD SheetSetHCenter 
      METHOD SheetSetHeader 
      METHOD SheetSetHidden 
      METHOD SheetSetHorPageBreak 
      METHOD SheetSetLandscape 
      METHOD SheetSetMarginBottom 
      METHOD SheetSetMarginLeft 
      METHOD SheetSetMarginRight 
      METHOD SheetSetMarginTop 
      METHOD SheetSetMerge 
      METHOD SheetSetName 
      METHOD SheetSetNamedRange 
      METHOD SheetSetPaper 
      METHOD SheetSetPicture2 
      METHOD SheetSetPicture 
      METHOD SheetSetPrintArea 
      METHOD SheetSetPrintFit 
      METHOD SheetSetPrintGridlines 
      METHOD SheetSetPrintRepeatCols 
      METHOD SheetSetPrintRepeatRows 
      METHOD SheetSetPrintRowCol 
      METHOD SheetSetPrintZoom 
      METHOD SheetSetProtect 
      METHOD SheetSetProtectEx 
      METHOD SheetSetRightToLeft 
      METHOD SheetSetRow 
      METHOD SheetSetRowHidden 
      METHOD SheetSetTabColor 
      METHOD SheetSetTabRgbColor 
      METHOD SheetSetTopLeftView 
      METHOD SheetSetVCenter 
      METHOD SheetSetVerPageBreak 
      METHOD SheetSetZoom 
      METHOD SheetSplit 
      METHOD SheetSplitInfo 
      METHOD SheetTable 
      METHOD SheetTableSize 
      METHOD SheetVCenter 
      METHOD SheetWriteBlank 
      METHOD SheetWriteBool 
      METHOD SheetWriteComment 
      METHOD SheetWriteError 
      METHOD SheetWriteFormula 
      METHOD SheetWriteFormulaBool 
      METHOD SheetWriteFormulaNum 
      METHOD SheetWriteFormulaStr 
      METHOD SheetWriteNum 
      METHOD SheetWriteRichStr 
      METHOD SheetWriteStr 
      METHOD SheetZoom 

ENDCLASS 
*--------------------------------------------------------------------------------
METHOD xlSheet:init(oBook) 
   if ! empty(oBook) 
      ::oBook := oBook 
   endif 
   ::qRow := 0 
   ::qCol := 0 
return self 
*--------------------------------------------------------------------------------
*   Eigene Methoden für einfache Zugriffe / easy to use own methods.             
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetReadDate(nRow, nCol, hFormat) // CALL SheetReadDate(nRow, nCol, @hFormat) 
   local nDateDouble, dDate, nYear := NIL, nMonth := NIL, nDay := NIL 
   nDateDouble := ::SheetReadNum( nRow, nCol, @hFormat ) 
   if ::oBook:BookDateUnpack(nDateDouble,@nYear, @nMonth, @nDay )
      dDate := STOD( StrZero(nYear,4)+StrZero(nMonth,2)+StrZero(nDay,2) )
   endif
   if empty(dDate) 
      dDate := ctod('') 
   endif
RETURN dDate
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteDate(nRow, nCol, dDate, hFormat)
   local uRet, hInitFormat := 0 
   do case  
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
           if hFormat:FormatNumFormat(hFormat) <> NUMFORMAT_DATE 
              hInitFormat := hFormat 
              hFormat     := 0 // build new one 
           else 
              hFormat     := hFormat:hHandle 
           endif 
      case valtype(hFormat)='N' 
           // use it 
      otherwise      
           hFormat := 0 
   end    
   if empty(hFormat) 
      hFormat := ::SheetCellFormat(nRow, nCol) 
      if hFormat:FormatNumFormat(hFormat) <> NUMFORMAT_DATE 
         hFormat := ::oBook:BookaddFormat(hInitFormat) 
         hFormat:FormatSetNumFormat(NUMFORMAT_DATE) 
      endif 
   endif 
   do case 
      case valtype(dDate)='D' 
           // ok  
      case valtype(dDate)='C' .and. len(dDate)=8  // 'JJJJMMDD'
           dDate := stod(dDate) 
      case valtype(dDate)='C' .and. len(dDate)=10 // lokal date format
           dDate := ctod(dDate) 
      otherwise 
           dDate := NIL 
   end 
   if empty(dDate) 
      uRet := .f.  
   else 
      uRet := ::SheetWriteNum(nRow,nCol,::oBook:BookDatePack(year(dDate), month(dDate), day(dDate)), hFormat)
   endif
RETURN uRet 
*--------------------------------------------------------------------------------
*  Methoden von Anwendern / methodes from users                                  
*--------------------------------------------------------------------------------
// Q, QQ etc. von Osvaldo Ramírez    
*--------------------------------------------------------------------------------
METHOD xlSheet:QQ() 
   LOCAL i,nParams          
   LOCAL xValue             
   LOCAL aValues := {}      
   ******* how many params? 
   nParams := PCount()      
   IF nParams > 1           
      FOR i := 1 TO nParams 
          aadd( aValues , { PValue(i) , valtype( PValue(i) )})                   
      NEXT                                                                       
   ELSE                                                                          
      if nParams = 1                                                             
         xValue := PValue(1)                                                     
         // Vamos a ver si la separacion es por chr(19) *** HB *** TAB = chr(9)  
         do while ! empty( xValue )                                              
            if at( chr(9)  , xValue ) > 0                                        
               aadd( aValues , { substr( xValue , 1 , at( chr(9)  , xValue )-1) , 'C' }) 
               xValue := substr( xValue ,  at( chr(9)  , xValue )+1)             
            else                                                                 
               aadd( aValues , {  xValue , 'C' })                                
               exit                                                              
            endif                                                                
         enddo                                                                   
      endif                                                                      
   ENDIF                                                                         
   FOR i := 1 to len( aValues )                                                  
       IF     aValues[i][2] == 'C'                                               
          ::SheetWriteStr( ::qRow , ::qCol , aValues[i][1] )                     
       ELSEIF aValues[i][2] == 'D'                                               
          ::SheetWriteDate( ::qRow , ::qCol ,aValues[i][1] )                     
       ELSEIF aValues[i][2] == 'N'                                               
          ::SheetWriteNum( ::qRow , ::qCol , aValues[i][1])                      
       ELSEIF aValues[i][2] == 'L'                                               
          ::SheetWriteStr( ::qRow , ::qCol , var2char( aValues[i][1] ))          
       ENDIF                                                                     
       ::qCol ++                                                                 
   NEXT                                                                          
RETURN NIL                                                                       
*--------------------------------------------------------------------------------
METHOD xlSheet:Q()           
   LOCAL i,nParams           
   LOCAL xValue              
   LOCAL aValues := {}       
   ******* how many params?  
   nParams := PCount()       
   IF nParams > 1            
      FOR i := 1 TO nParams  
          aadd( aValues , { PValue(i) , valtype( PValue(i) )})                   
      NEXT                                                                       
   ELSE                                                                          
      if nParams = 1                                                             
         xValue := PValue(1)                                                     
         // Vamos a ver si la separacion es por chr(19) *** HB *** TAB = chr(9)  
         do while ! empty( xValue )                                              
            if at( chr(9)  , xValue ) > 0                                        
               aadd( aValues , { substr( xValue , 1 , at( chr(9)  , xValue )-1) , 'C' }) 
               xValue := substr( xValue ,  at( chr(9)  , xValue )+1)             
            else                                                                 
               aadd( aValues , {  xValue , 'C' })                                
               exit                                                              
            endif                                                                
         enddo                                                                   
      endif                                                                      
   ENDIF                                                                         
   FOR i := 1 to len( aValues )                                                  
       IF     aValues[i][2] == 'C'                                               
          ::SheetWriteStr( ::qRow , ::qCol , aValues[i][1] )                     
       ELSEIF aValues[i][2] == 'D'                                               
          ::SheetWriteDate( ::qRow , ::qCol ,aValues[i][1] )                     
       ELSEIF aValues[i][2] == 'N'                                               
          ::SheetWriteNum( ::qRow , ::qCol , aValues[i][1])                      
       ELSEIF aValues[i][2] == 'L'                                               
          ::SheetWriteStr( ::qRow , ::qCol , var2char( aValues[i][1] ))          
       ENDIF                                                                     
       ::qCol ++                                                                 
   NEXT                                                                          
   ::qCol := 0                                                                   
   ::qRow ++                                                                     
RETURN NIL                                                                       
*--------------------------------------------------------------------------------
METHOD xlSheet:QCol() ; RETURN ::qCol                                            
*--------------------------------------------------------------------------------
METHOD xlSheet:QRow() ; RETURN ::qRow                                            
*--------------------------------------------------------------------------------


*********************************************************************************
CLASS xlFormat FROM _HBLibXL       

   PROTECTED                               

   EXPORTED                                
      METHOD init                          
      METHOD FormatAlignH 
      METHOD FormatAlignV 
      METHOD FormatBorderBottom 
      METHOD FormatBorderBottomColor 
      METHOD FormatBorderDiagonal 
      METHOD FormatBorderDiagonalColor 
      METHOD FormatBorderDiagonalStyle 
      METHOD FormatBorderLeft 
      METHOD FormatBorderLeftColor 
      METHOD FormatBorderRight 
      METHOD FormatBorderRightColor 
      METHOD FormatBorderTop 
      METHOD FormatBorderTopColor 
      METHOD FormatFillPattern 
      METHOD FormatFont 
      METHOD FormatHidden 
      METHOD FormatIndent 
      METHOD FormatLocked 
      METHOD FormatNumFormat 
      METHOD FormatPatternBackgroundColor 
      METHOD FormatPatternForegroundColor 
      METHOD FormatRotation 
      METHOD FormatSetAlignH 
      METHOD FormatSetAlignV 
      METHOD FormatSetBorder 
      METHOD FormatSetBorderBottom 
      METHOD FormatSetBorderBottomColor 
      METHOD FormatSetBorderColor 
      METHOD FormatSetBorderDiagonal 
      METHOD FormatSetBorderDiagonalColor 
      METHOD FormatSetBorderDiagonalStyle 
      METHOD FormatSetBorderLeft 
      METHOD FormatSetBorderLeftColor 
      METHOD FormatSetBorderRight 
      METHOD FormatSetBorderRightColor 
      METHOD FormatSetBorderTop 
      METHOD FormatSetBorderTopColor 
      METHOD FormatSetFillPattern 
      METHOD FormatSetFont 
      METHOD FormatSetHidden 
      METHOD FormatSetIndent 
      METHOD FormatSetLocked 
      METHOD FormatSetNumFormat 
      METHOD FormatSetPatternBackgroundColor 
      METHOD FormatSetPatternForegroundColor 
      METHOD FormatSetRotation 
      METHOD FormatSetShrinkToFit 
      METHOD FormatSetWrap 
      METHOD FormatShrinkToFit 
      METHOD FormatWrap 

ENDCLASS                                   
*--------------------------------------------------------------------------------
METHOD xlFormat:init()             
return self                                
*--------------------------------------------------------------------------------

*********************************************************************************
CLASS xlFont FROM _HBLibXL       

   PROTECTED                               

   EXPORTED                                
      METHOD init                          
      METHOD FontBold 
      METHOD FontColor 
      METHOD FontItalic 
      METHOD FontName 
      METHOD FontScript 
      METHOD FontSetBold 
      METHOD FontSetColor 
      METHOD FontSetItalic 
      METHOD FontSetName 
      METHOD FontSetScript 
      METHOD FontSetSize 
      METHOD FontSetStrikeOut 
      METHOD FontSetUnderline 
      METHOD FontSize 
      METHOD FontStrikeOut 
      METHOD FontUnderline 

ENDCLASS                                   
*--------------------------------------------------------------------------------
METHOD xlFont:init()             
return self                                
*--------------------------------------------------------------------------------

*********************************************************************************
CLASS xlAutoFilter FROM _HBLibXL       

   PROTECTED                               

   EXPORTED                                
      METHOD init                          
      METHOD AutoFilterColumn 
      METHOD AutoFilterColumnByIndex 
      METHOD AutoFilterColumnSize 
      METHOD AutoFilterGetRef 
      METHOD AutoFilterGetSort 
      METHOD AutoFilterGetSortRange 
      METHOD AutoFilterSetRef 
      METHOD AutoFilterSetSort 

ENDCLASS                                   
*--------------------------------------------------------------------------------
METHOD xlAutoFilter:init()             
return self                                
*--------------------------------------------------------------------------------

*********************************************************************************
CLASS xlFilterColumn FROM _HBLibXL       

   PROTECTED                               

   EXPORTED                                
      METHOD init                          
      METHOD FilterColumnAddFilter 
      METHOD FilterColumnClear 
      METHOD FilterColumnFilter 
      METHOD FilterColumnFilterSize 
      METHOD FilterColumnFilterType 
      METHOD FilterColumnGetCustomFilter 
      METHOD FilterColumnGetTop10 
      METHOD FilterColumnIndex 
      METHOD FilterColumnSetCustomFilter 
      METHOD FilterColumnSetCustomFilterEx 
      METHOD FilterColumnSetTop10 

ENDCLASS                                   
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:init()             
return self                                
*--------------------------------------------------------------------------------

*********************************************************************************
CLASS xlRichString FROM _HBLibXL       

   PROTECTED                               

   EXPORTED                                
      METHOD init                          
      METHOD RichStringAddFont 
      METHOD RichStringAddText 
      METHOD RichStringGetText 
      METHOD RichStringTextSize 

ENDCLASS                                   
*--------------------------------------------------------------------------------
METHOD xlRichString:init()             
return self                                
*--------------------------------------------------------------------------------

*********************************************************************************
METHOD xlBook:BookActiveSheet()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookActiveSheetA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookAddCustomNumFormat( cCustomNumFormat )   
   LOCAL uRet := nil
   cCustomNumFormat := ::ForceAnsi(cCustomNumFormat)
   uRet := FpQCall( {'LibXL','xlBookAddCustomNumFormatA'},'__bo__sl__pt',::hHandle,cCustomNumFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookAddFont( hInitFont )   
   LOCAL uRet := nil
   LOCAL oFont := nil
   do case                                      
      case valtype(hInitFont)='O' .and. IsMemberVar(hInitFont,'hHandle') 
         hInitFont := hInitFont:hHandle 
      case valtype(hInitFont)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hInitFont := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlBookAddFontA'},'__sl__sl__sl',::hHandle,hInitFont) 
   if ! empty(uRet)                       
      oFont := xlFont():new()             
      oFont:hHandle := uRet               
   endif                                  
RETURN oFont                              
*--------------------------------------------------------------------------------
METHOD xlBook:BookAddFormat( hInitFormat )   
   LOCAL uRet := nil
   LOCAL oFormat := nil
   do case                                      
      case valtype(hInitFormat)='O' .and. IsMemberVar(hInitFormat,'hHandle') 
         hInitFormat := hInitFormat:hHandle 
      case valtype(hInitFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hInitFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlBookAddFormatA'},'__sl__sl__sl',::hHandle,hInitFormat) 
   if ! empty(uRet)                       
      oFormat := xlFormat():new()         
      oFormat:hHandle := uRet             
   endif                                  
RETURN oFormat                            
*--------------------------------------------------------------------------------
METHOD xlBook:BookAddPicture2( bData, nSize )   
   LOCAL uRet := nil
   DEFAULT nSize TO 0   
   uRet := FpQCall( {'LibXL','xlBookAddPicture2A'},'__sl__sl__pt__ul',::hHandle,bData,nSize) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookAddPicture( cFilename )   
   LOCAL uRet := nil
   cFilename := ::ForceAnsi(cFilename)
   uRet := FpQCall( {'LibXL','xlBookAddPictureA'},'__sl__sl__pt',::hHandle,cFilename) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookAddPictureAsLink( cFilename, nInsert )   
   LOCAL uRet := nil
   cFilename := ::ForceAnsi(cFilename)
   DEFAULT nInsert TO 0   
   uRet := FpQCall( {'LibXL','xlBookAddPictureAsLinkA'},'__sl__sl__pt__sl',::hHandle,cFilename,nInsert) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookAddRichString()
   LOCAL uRet := nil
   LOCAL oRichString := nil
   uRet := FpQCall( {'LibXL','xlBookAddRichStringA'},'__sl__sl',::hHandle) 
   if ! empty(uRet)                       
      oRichString := xlRichString():new() 
      oRichString:hHandle := uRet         
   endif                                  
RETURN oRichString                        
*--------------------------------------------------------------------------------
METHOD xlBook:BookAddSheet( cName, hInitSheet )   
   LOCAL uRet := nil
   LOCAL oSheet := nil
   cName := ::ForceAnsi(cName)
   do case                                      
      case valtype(hInitSheet)='O' .and. IsMemberVar(hInitSheet,'hHandle') 
         hInitSheet := hInitSheet:hHandle 
      case valtype(hInitSheet)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hInitSheet := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlBookAddSheetA'},'__sl__sl__pt__sl',::hHandle,cName,hInitSheet) 
   if ! empty(uRet)                       
      oSheet := xlSheet():new(SELF)       
      oSheet:hHandle := uRet              
   endif                                  
RETURN oSheet                             
*--------------------------------------------------------------------------------
METHOD xlBook:BookBiffVersion()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookBiffVersionA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookCalcMode()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookCalcModeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookColorPack( nRed, nGreen, nBlue )   
   LOCAL uRet := nil
   DEFAULT nRed TO 0   
   DEFAULT nGreen TO 0   
   DEFAULT nBlue TO 0   
   uRet := FpQCall( {'LibXL','xlBookColorPackA'},'__sl__sl__sl__sl__sl',::hHandle,nRed,nGreen,nBlue) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookColorUnpack( nColor, nRed, nGreen, nBlue )    // return values, call: @nRed, @nGreen, @nBlue
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   DEFAULT nRed TO 0   
   DEFAULT nGreen TO 0   
   DEFAULT nBlue TO 0   
   uRet := FpQCall( {'LibXL','xlBookColorUnpackA'},'__vo__sl__sl_@sl_@sl_@sl',::hHandle,nColor,@nRed,@nGreen,@nBlue) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookCustomNumFormat( nFmt )   
   LOCAL uRet := nil
   DEFAULT nFmt TO 0   
   uRet := FpQCall( {'LibXL','xlBookCustomNumFormatA'},'c_sz__sl__sl',::hHandle,nFmt) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlBook:BookDatePack( nYear, nMonth, nDay, nHour, nMin, nSec, nMsec )   
   LOCAL uRet := nil
   DEFAULT nYear TO 0   
   DEFAULT nMonth TO 0   
   DEFAULT nDay TO 0   
   DEFAULT nHour TO 0   
   DEFAULT nMin TO 0   
   DEFAULT nSec TO 0   
   DEFAULT nMsec TO 0   
   uRet := FpQCall( {'LibXL','xlBookDatePackA'},'__f8__sl__sl__sl__sl__sl__sl__sl__sl',::hHandle,nYear,nMonth,nDay,nHour,nMin,nSec,nMsec) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookDateUnpack( nValue, nYear, nMonth, nDay, nHour, nMin, nSec, nMsec )    // return values, call: @nYear, @nMonth, @nDay, @nHour, @nMin, @nSec, @nMsec
   LOCAL uRet := nil
   DEFAULT nValue TO 0   
   DEFAULT nYear TO 0   
   DEFAULT nMonth TO 0   
   DEFAULT nDay TO 0   
   DEFAULT nHour TO 0   
   DEFAULT nMin TO 0   
   DEFAULT nSec TO 0   
   DEFAULT nMsec TO 0   
   uRet := FpQCall( {'LibXL','xlBookDateUnpackA'},'__bo__sl__f8_@sl_@sl_@sl_@sl_@sl_@sl_@sl',::hHandle,nValue,@nYear,@nMonth,@nDay,@nHour,@nMin,@nSec,@nMsec) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookDefaultFont( nFontSize )    // return values, call: @nFontSize
   LOCAL uRet := nil
   DEFAULT nFontSize TO 0   
   uRet := FpQCall( {'LibXL','xlBookDefaultFontA'},'c_sz__sl_@sl',::hHandle,@nFontSize) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlBook:BookDelSheet( nIndex )   
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlBookDelSheetA'},'__bo__sl__sl',::hHandle,nIndex) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookErrorMessage()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookErrorMessageA'},'c_sz__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookFont( nIndex )   
   LOCAL uRet := nil
   LOCAL oFont := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlBookFontA'},'__sl__sl__sl',::hHandle,nIndex) 
   if ! empty(uRet)                       
      oFont := xlFont():new()             
      oFont:hHandle := uRet               
   endif                                  
RETURN oFont                              
*--------------------------------------------------------------------------------
METHOD xlBook:BookFontSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookFontSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookFormat( nIndex )   
   LOCAL uRet := nil
   LOCAL oFormat := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlBookFormatA'},'__sl__sl__sl',::hHandle,nIndex) 
   if ! empty(uRet)                       
      oFormat := xlFormat():new()         
      oFormat:hHandle := uRet             
   endif                                  
RETURN oFormat                            
*--------------------------------------------------------------------------------
METHOD xlBook:BookFormatSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookFormatSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookGetPicture(nIndex, bData, nSize) // call BookGetPicture(nIndex, @cData, @nSize) 
   local uRet := nil, p := 0     
   nSize := 0                    
   DEFAULT nIndex TO 0           
   uRet := FpQCall( {'LibXL','xlBookGetPictureA'},'__bo__sl__sl_@sl_@ul',::hHandle,nIndex,@p,@nSize ) 
   if uRet  .and. ! empty(p)     
      bData := PeekStr(p,,nSize) 
      nSize := len(bData)        
   endif                         
RETURN uRet                      
*--------------------------------------------------------------------------------
METHOD xlBook:BookGetSheet( nIndex )   
   LOCAL uRet := nil
   LOCAL oSheet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlBookGetSheetA'},'__sl__sl__sl',::hHandle,nIndex) 
   if ! empty(uRet)                       
      oSheet := xlSheet():new(SELF)       
      oSheet:hHandle := uRet              
   endif                                  
RETURN oSheet                             
*--------------------------------------------------------------------------------
METHOD xlBook:BookGetSheetName( nIndex )   
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlBookGetSheetNameA'},'c_sz__sl__sl',::hHandle,nIndex) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlBook:BookInsertSheet( nIndex, cName, hInitSheet )   
   LOCAL uRet := nil
   LOCAL oSheet := nil
   DEFAULT nIndex TO 0   
   cName := ::ForceAnsi(cName)
   do case                                      
      case valtype(hInitSheet)='O' .and. IsMemberVar(hInitSheet,'hHandle') 
         hInitSheet := hInitSheet:hHandle 
      case valtype(hInitSheet)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hInitSheet := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlBookInsertSheetA'},'__sl__sl__sl__pt__sl',::hHandle,nIndex,cName,hInitSheet) 
   if ! empty(uRet)                       
      oSheet := xlSheet():new(SELF)       
      oSheet:hHandle := uRet              
   endif                                  
RETURN oSheet                             
*--------------------------------------------------------------------------------
METHOD xlBook:BookIsDate1904()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookIsDate1904A'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookIsTemplate()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookIsTemplateA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookLoad( cFilename )   
   LOCAL uRet := nil
   cFilename := ::ForceAnsi(cFilename)
   uRet := FpQCall( {'LibXL','xlBookLoadA'},'__bo__sl__pt',::hHandle,cFilename) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookLoadInfo( cFilename )   
   LOCAL uRet := nil
   cFilename := ::ForceAnsi(cFilename)
   uRet := FpQCall( {'LibXL','xlBookLoadInfoA'},'__bo__sl__pt',::hHandle,cFilename) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookLoadPartially( cFilename, nSheetIndex, nFirstRow, nLastRow )   
   LOCAL uRet := nil
   cFilename := ::ForceAnsi(cFilename)
   DEFAULT nSheetIndex TO 0   
   DEFAULT nFirstRow TO 0   
   DEFAULT nLastRow TO 0   
   uRet := FpQCall( {'LibXL','xlBookLoadPartiallyA'},'__bo__sl__pt__sl__sl__sl',::hHandle,cFilename,nSheetIndex,nFirstRow,nLastRow) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookLoadPartiallyUsingTempFile( cFilename, nSheetIndex, nFirstRow, nLastRow, cTempFile )   
   LOCAL uRet := nil
   cFilename := ::ForceAnsi(cFilename)
   DEFAULT nSheetIndex TO 0   
   DEFAULT nFirstRow TO 0   
   DEFAULT nLastRow TO 0   
   cTempFile := ::ForceAnsi(cTempFile)
   uRet := FpQCall( {'LibXL','xlBookLoadPartiallyUsingTempFileA'},'__bo__sl__pt__sl__sl__sl__pt',::hHandle,cFilename,nSheetIndex,nFirstRow,nLastRow,cTempFile) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookLoadRaw( bData, nSize )   
   LOCAL uRet := nil
   DEFAULT nSize TO 0   
   uRet := FpQCall( {'LibXL','xlBookLoadRawA'},'__bo__sl__pt__ul',::hHandle,bData,nSize) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookLoadRawPartially( bData, nSize, nSheetIndex, nFirstRow, nLastRow )   
   LOCAL uRet := nil
   DEFAULT nSize TO 0   
   DEFAULT nSheetIndex TO 0   
   DEFAULT nFirstRow TO 0   
   DEFAULT nLastRow TO 0   
   uRet := FpQCall( {'LibXL','xlBookLoadRawPartiallyA'},'__bo__sl__pt__ul__sl__sl__sl',::hHandle,bData,nSize,nSheetIndex,nFirstRow,nLastRow) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookLoadUsingTempFile( cFilename, cTempFile )   
   LOCAL uRet := nil
   cFilename := ::ForceAnsi(cFilename)
   cTempFile := ::ForceAnsi(cTempFile)
   uRet := FpQCall( {'LibXL','xlBookLoadUsingTempFileA'},'__bo__sl__pt__pt',::hHandle,cFilename,cTempFile) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookMoveSheet( nSrcIndex, nDstIndex )   
   LOCAL uRet := nil
   DEFAULT nSrcIndex TO 0   
   DEFAULT nDstIndex TO 0   
   uRet := FpQCall( {'LibXL','xlBookMoveSheetA'},'__bo__sl__sl__sl',::hHandle,nSrcIndex,nDstIndex) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookPictureSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookPictureSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookRefR1C1()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookRefR1C1A'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookRelease()
   LOCAL uRet := nil 
   if ! empty(::hHandle)
      uRet := FpQCall( {'LibXL','xlBookReleaseA'},'__vo__sl',::hHandle)
      ::hHandle := 0 
   endif 
RETURN uRet 
*--------------------------------------------------------------------------------
METHOD xlBook:BookRgbMode()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookRgbModeA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSave(cFilename) 
   LOCAL uRet := nil                             
   cFilename := ::ForceAnsi(cFilename)           
   if ! empty(::cFileExt) .and. upper(right(cFilename,len(::cFileExt))) # upper(::cFileExt)
      cFileName += ::cFileExt                    
   endif                                         
   uRet := FpQCall( {'LibXL','xlBookSaveA'},'__bo__sl__pt',::hHandle,cFilename)
RETURN uRet                                      
*--------------------------------------------------------------------------------
METHOD xlBook:BookSaveRaw(bData, nSize) // call BookSaveRaw( @cData, @nSize) 
   local uRet := nil, p := 0     
   nSize := 0                    
   uRet := FpQCall( {'LibXL','xlBookSaveRawA'},'__bo__sl_@sl_@ul',::hHandle,@p,@nSize ) 
   if uRet  .and. ! empty(p)     
      bData := PeekStr(p,,nSize) 
      nSize := len(bData)        
   endif                         
RETURN uRet                      
*--------------------------------------------------------------------------------
METHOD xlBook:BookSaveUsingTempFile( cFilename, nUseTempFile )   
   LOCAL uRet := nil
   cFilename := ::ForceAnsi(cFilename)
   DEFAULT nUseTempFile TO 0   
   uRet := FpQCall( {'LibXL','xlBookSaveUsingTempFileA'},'__bo__sl__pt__sl',::hHandle,cFilename,nUseTempFile) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSetActiveSheet( nIndex )   
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlBookSetActiveSheetA'},'__vo__sl__sl',::hHandle,nIndex) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSetCalcMode( nCalcMode )   
   LOCAL uRet := nil
   DEFAULT nCalcMode TO 0   
   uRet := FpQCall( {'LibXL','xlBookSetCalcModeA'},'__vo__sl__sl',::hHandle,nCalcMode) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSetDate1904( lDate1904 )   
   LOCAL uRet := nil
   DEFAULT lDate1904 TO .t.
   lDate1904 := ! empty(lDate1904) 
   uRet := FpQCall( {'LibXL','xlBookSetDate1904A'},'__vo__sl__bo',::hHandle,lDate1904) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSetDefaultFont( cFontName, nFontSize )   
   LOCAL uRet := nil
   cFontName := ::ForceAnsi(cFontName)
   DEFAULT nFontSize TO 0   
   uRet := FpQCall( {'LibXL','xlBookSetDefaultFontA'},'__vo__sl__pt__sl',::hHandle,cFontName,nFontSize) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSetKey(cName, cKey)
   local uRet := nil 
   cName := ::ForceAnsi(cName) 
   cKey  := ::ForceAnsi(cKey) 
   if ! empty(cName) .and. ! empty(cKey) 
      ::LiName  := cName 
      ::LiKey   := cKey 
      uRet := FpQCall( {'LibXL','xlBookSetKeyA'},'__vo__sl__pt__pt',::hHandle,cName,cKey)
   endif 
RETURN uRet 
*--------------------------------------------------------------------------------
METHOD xlBook:BookSetLocale( bLocale )   
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookSetLocaleA'},'__bo__sl__pt',::hHandle,bLocale) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSetRefR1C1( lRefR1C1 )   
   LOCAL uRet := nil
   DEFAULT lRefR1C1 TO .t.
   lRefR1C1 := ! empty(lRefR1C1) 
   uRet := FpQCall( {'LibXL','xlBookSetRefR1C1A'},'__vo__sl__bo',::hHandle,lRefR1C1) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSetRgbMode( lRgbMode )   
   LOCAL uRet := nil
   DEFAULT lRgbMode TO .t.
   lRgbMode := ! empty(lRgbMode) 
   uRet := FpQCall( {'LibXL','xlBookSetRgbModeA'},'__vo__sl__bo',::hHandle,lRgbMode) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSetTemplate( lTmpl )   
   LOCAL uRet := nil
   DEFAULT lTmpl TO .t.
   lTmpl := ! empty(lTmpl) 
   uRet := FpQCall( {'LibXL','xlBookSetTemplateA'},'__vo__sl__bo',::hHandle,lTmpl) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSheetCount()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlBookSheetCountA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlBook:BookSheetType( nIndex )   
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlBookSheetTypeA'},'__sl__sl__sl',::hHandle,nIndex) 
RETURN uRet
*--------------------------------------------------------------------------------

*********************************************************************************
METHOD xlSheet:SheetAddDataValidation( nType, nOp, nRowFirst, nRowLast, nColFirst, nColLast, cValue1, cValue2 )   
   LOCAL uRet := nil
   DEFAULT nType TO 0   
   DEFAULT nOp TO 0   
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   cValue1 := ::ForceAnsi(cValue1)
   cValue2 := ::ForceAnsi(cValue2)
   uRet := FpQCall( {'LibXL','xlSheetAddDataValidationA'},'__vo__sl__sl__sl__sl__sl__sl__sl__pt__pt',::hHandle,nType,nOp,nRowFirst,nRowLast,nColFirst,nColLast,cValue1,cValue2) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetAddDataValidationDouble( nType, nOp, nRowFirst, nRowLast, nColFirst, nColLast, nValue1, nValue2 )   
   LOCAL uRet := nil
   DEFAULT nType TO 0   
   DEFAULT nOp TO 0   
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   DEFAULT nValue1 TO 0   
   DEFAULT nValue2 TO 0   
   uRet := FpQCall( {'LibXL','xlSheetAddDataValidationDoubleA'},'__vo__sl__sl__sl__sl__sl__sl__sl__f8__f8',::hHandle,nType,nOp,nRowFirst,nRowLast,nColFirst,nColLast,nValue1,nValue2) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetAddDataValidationDoubleEx( nType, nOp, nRowFirst, nRowLast, nColFirst, nColLast, nValue1, nValue2, lAllowBlank, lHideDropDown, lShowInputMessage, lShowErrorMessage, cPromptTitle, cPrompt, cErrorTitle, cError, nErrorStyle )   
   LOCAL uRet := nil
   DEFAULT nType TO 0   
   DEFAULT nOp TO 0   
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   DEFAULT nValue1 TO 0   
   DEFAULT nValue2 TO 0   
   DEFAULT lAllowBlank TO .t.
   lAllowBlank := ! empty(lAllowBlank) 
   DEFAULT lHideDropDown TO .f.
   lHideDropDown := ! empty(lHideDropDown) 
   DEFAULT lShowInputMessage TO .t.
   lShowInputMessage := ! empty(lShowInputMessage) 
   DEFAULT lShowErrorMessage TO .t.
   lShowErrorMessage := ! empty(lShowErrorMessage) 
   cPromptTitle := ::ForceAnsi(cPromptTitle)
   cPrompt := ::ForceAnsi(cPrompt)
   cErrorTitle := ::ForceAnsi(cErrorTitle)
   cError := ::ForceAnsi(cError)
   DEFAULT nErrorStyle TO 0   
   uRet := FpQCall( {'LibXL','xlSheetAddDataValidationDoubleExA'},'__vo__sl__sl__sl__sl__sl__sl__sl__f8__f8__bo__bo__bo__bo__pt__pt__pt__pt__sl',::hHandle,nType,nOp,nRowFirst,nRowLast,nColFirst,nColLast,nValue1,nValue2,lAllowBlank,lHideDropDown,lShowInputMessage,lShowErrorMessage,cPromptTitle,cPrompt,cErrorTitle,cError,nErrorStyle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetAddDataValidationEx( nType, nOp, nRowFirst, nRowLast, nColFirst, nColLast, cValue1, cValue2, lAllowBlank, lHideDropDown, lShowInputMessage, lShowErrorMessage, cPromptTitle, cPrompt, cErrorTitle, cError, nErrorStyle )   
   LOCAL uRet := nil
   DEFAULT nType TO 0   
   DEFAULT nOp TO 0   
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   cValue1 := ::ForceAnsi(cValue1)
   cValue2 := ::ForceAnsi(cValue2)
   DEFAULT lAllowBlank TO .t.
   lAllowBlank := ! empty(lAllowBlank) 
   DEFAULT lHideDropDown TO .f.
   lHideDropDown := ! empty(lHideDropDown) 
   DEFAULT lShowInputMessage TO .t.
   lShowInputMessage := ! empty(lShowInputMessage) 
   DEFAULT lShowErrorMessage TO .t.
   lShowErrorMessage := ! empty(lShowErrorMessage) 
   cPromptTitle := ::ForceAnsi(cPromptTitle)
   cPrompt := ::ForceAnsi(cPrompt)
   cErrorTitle := ::ForceAnsi(cErrorTitle)
   cError := ::ForceAnsi(cError)
   DEFAULT nErrorStyle TO 0   
   uRet := FpQCall( {'LibXL','xlSheetAddDataValidationExA'},'__vo__sl__sl__sl__sl__sl__sl__sl__pt__pt__bo__bo__bo__bo__pt__pt__pt__pt__sl',::hHandle,nType,nOp,nRowFirst,nRowLast,nColFirst,nColLast,cValue1,cValue2,lAllowBlank,lHideDropDown,lShowInputMessage,lShowErrorMessage,cPromptTitle,cPrompt,cErrorTitle,cError,nErrorStyle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetAddHyperlink( cHyperlink, nRowFirst, nRowLast, nColFirst, nColLast )   
   LOCAL uRet := nil
   cHyperlink := ::ForceAnsi(cHyperlink)
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetAddHyperlinkA'},'__vo__sl__pt__sl__sl__sl__sl',::hHandle,cHyperlink,nRowFirst,nRowLast,nColFirst,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetAddIgnoredError( nRowFirst, nColFirst, nRowLast, nColLast, nIError )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColLast TO 0   
   DEFAULT nIError TO 0   
   uRet := FpQCall( {'LibXL','xlSheetAddIgnoredErrorA'},'__bo__sl__sl__sl__sl__sl__sl',::hHandle,nRowFirst,nColFirst,nRowLast,nColLast,nIError) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetAddrToRowCol( cAddr, nRow, nCol, lRowRelative, lColRelative )    // return values, call: @nRow, @nCol
   LOCAL uRet := nil
   cAddr := ::ForceAnsi(cAddr)
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   lRowRelative := ! empty(lRowRelative) 
   lColRelative := ! empty(lColRelative) 
   uRet := FpQCall( {'LibXL','xlSheetAddrToRowColA'},'__vo__sl__pt_@sl_@sl_@bo_@bo',::hHandle,cAddr,@nRow,@nCol,@lRowRelative,@lColRelative) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetApplyFilter()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetApplyFilterA'},'__vo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetAutoFilter()
   LOCAL uRet := nil
   LOCAL oAutoFilter := nil
   uRet := FpQCall( {'LibXL','xlSheetAutoFilterA'},'__sl__sl',::hHandle) 
   if ! empty(uRet)                       
      oAutoFilter := xlAutoFilter():new() 
      oAutoFilter:hHandle := uRet         
   endif                                  
RETURN oAutoFilter                        
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetCellFormat( nRow, nCol )   
   LOCAL uRet := nil
   LOCAL oFormat := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetCellFormatA'},'__sl__sl__sl__sl',::hHandle,nRow,nCol) 
   if ! empty(uRet)                       
      oFormat := xlFormat():new()         
      oFormat:hHandle := uRet             
   endif                                  
RETURN oFormat                            
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetCellType( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetCellTypeA'},'__sl__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetClear( nRowFirst, nRowLast, nColFirst, nColLast )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetClearA'},'__sl__sl__sl__sl__sl__sl',::hHandle,nRowFirst,nRowLast,nColFirst,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetClearPrintArea()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetClearPrintAreaA'},'__vo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetClearPrintRepeats()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetClearPrintRepeatsA'},'__vo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetColHidden( nCol )   
   LOCAL uRet := nil
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetColHiddenA'},'__bo__sl__sl',::hHandle,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetColWidth( nCol )   
   LOCAL uRet := nil
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetColWidthA'},'__f8__sl__sl',::hHandle,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetColWidthPx( nCol )   
   LOCAL uRet := nil
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetColWidthPxA'},'__sl__sl__sl',::hHandle,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetCopyCell( nRowSrc, nColSrc, nRowDst, nColDst )   
   LOCAL uRet := nil
   DEFAULT nRowSrc TO 0   
   DEFAULT nColSrc TO 0   
   DEFAULT nRowDst TO 0   
   DEFAULT nColDst TO 0   
   uRet := FpQCall( {'LibXL','xlSheetCopyCellA'},'__bo__sl__sl__sl__sl__sl',::hHandle,nRowSrc,nColSrc,nRowDst,nColDst) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetDelHyperlink( nIndex )   
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlSheetDelHyperlinkA'},'__sl__sl__sl',::hHandle,nIndex) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetDelMerge( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetDelMergeA'},'__bo__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetDelMergeByIndex( nIndex )   
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlSheetDelMergeByIndexA'},'__sl__sl__sl',::hHandle,nIndex) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetDelNamedRange( cName, nScopeId )   
   LOCAL uRet := nil
   cName := ::ForceAnsi(cName)
   DEFAULT nScopeId TO 0   
   uRet := FpQCall( {'LibXL','xlSheetDelNamedRangeA'},'__bo__sl__pt__sl',::hHandle,cName,nScopeId) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetDisplayGridlines()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetDisplayGridlinesA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetFirstCol()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetFirstColA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetFirstFilledCol()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetFirstFilledColA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetFirstFilledRow()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetFirstFilledRowA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetFirstRow()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetFirstRowA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetFooter()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetFooterA'},'c_sz__sl',::hHandle) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetFooterMargin()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetFooterMarginA'},'__f8__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGetHorPageBreak( nIndex )   
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlSheetGetHorPageBreakA'},'__sl__sl__sl',::hHandle,nIndex) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGetHorPageBreakSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetGetHorPageBreakSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGetMerge( nRow, nCol, nRowFirst, nRowLast, nColFirst, nColLast )    // return values, call: @nRowFirst, @nRowLast, @nColFirst, @nColLast
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetGetMergeA'},'__bo__sl__sl__sl_@sl_@sl_@sl_@sl',::hHandle,nRow,nCol,@nRowFirst,@nRowLast,@nColFirst,@nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGetNamedRange( cName, nRowFirst, nRowLast, nColFirst, nColLast, nScopeId, lHidden )    // return values, call: @nRowFirst, @nRowLast, @nColFirst, @nColLast
   LOCAL uRet := nil
   cName := ::ForceAnsi(cName)
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   DEFAULT nScopeId TO 0   
   lHidden := ! empty(lHidden) 
   uRet := FpQCall( {'LibXL','xlSheetGetNamedRangeA'},'__bo__sl__pt_@sl_@sl_@sl_@sl__sl_@bo',::hHandle,cName,@nRowFirst,@nRowLast,@nColFirst,@nColLast,nScopeId,@lHidden) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGetPicture( nIndex, nRowTop, nColLeft, nRowBottom, nColRight, nWidth, nHeight, nOffset_x, nOffset_y )    // return values, call: @nRowTop, @nColLeft, @nRowBottom, @nColRight, @nWidth, @nHeight, @nOffset_x, @nOffset_y
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   DEFAULT nRowTop TO 0   
   DEFAULT nColLeft TO 0   
   DEFAULT nRowBottom TO 0   
   DEFAULT nColRight TO 0   
   DEFAULT nWidth TO 0   
   DEFAULT nHeight TO 0   
   DEFAULT nOffset_x TO 0   
   DEFAULT nOffset_y TO 0   
   uRet := FpQCall( {'LibXL','xlSheetGetPictureA'},'__sl__sl__sl_@sl_@sl_@sl_@sl_@sl_@sl_@sl_@sl',::hHandle,nIndex,@nRowTop,@nColLeft,@nRowBottom,@nColRight,@nWidth,@nHeight,@nOffset_x,@nOffset_y) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGetPrintFit( nWPages, nHPages )    // return values, call: @nWPages, @nHPages
   LOCAL uRet := nil
   DEFAULT nWPages TO 0   
   DEFAULT nHPages TO 0   
   uRet := FpQCall( {'LibXL','xlSheetGetPrintFitA'},'__bo__sl_@sl_@sl',::hHandle,@nWPages,@nHPages) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGetTopLeftView( nRow, nCol )    // return values, call: @nRow, @nCol
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetGetTopLeftViewA'},'__vo__sl_@sl_@sl',::hHandle,@nRow,@nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGetVerPageBreak( nIndex )   
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlSheetGetVerPageBreakA'},'__sl__sl__sl',::hHandle,nIndex) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGetVerPageBreakSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetGetVerPageBreakSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGroupCols( nColFirst, nColLast, lCollapsed )   
   LOCAL uRet := nil
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   DEFAULT lCollapsed TO .t.
   lCollapsed := ! empty(lCollapsed) 
   uRet := FpQCall( {'LibXL','xlSheetGroupColsA'},'__bo__sl__sl__sl__bo',::hHandle,nColFirst,nColLast,lCollapsed) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGroupRows( nRowFirst, nRowLast, lCollapsed )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT lCollapsed TO .t.
   lCollapsed := ! empty(lCollapsed) 
   uRet := FpQCall( {'LibXL','xlSheetGroupRowsA'},'__bo__sl__sl__sl__bo',::hHandle,nRowFirst,nRowLast,lCollapsed) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGroupSummaryBelow()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetGroupSummaryBelowA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetGroupSummaryRight()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetGroupSummaryRightA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetHCenter()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetHCenterA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetHeader()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetHeaderA'},'c_sz__sl',::hHandle) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetHeaderMargin()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetHeaderMarginA'},'__f8__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetHidden()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetHiddenA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetHyperlink( nIndex, nRowFirst, nRowLast, nColFirst, nColLast )    // return values, call: @nRowFirst, @nRowLast, @nColFirst, @nColLast
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetHyperlinkA'},'c_sz__sl__sl_@sl_@sl_@sl_@sl',::hHandle,nIndex,@nRowFirst,@nRowLast,@nColFirst,@nColLast) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetHyperlinkSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetHyperlinkSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetInsertCol( nColFirst, nColLast )   
   LOCAL uRet := nil
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetInsertColA'},'__bo__sl__sl__sl',::hHandle,nColFirst,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetInsertColAndKeepRanges( nColFirst, nColLast )   
   LOCAL uRet := nil
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetInsertColAndKeepRangesA'},'__bo__sl__sl__sl',::hHandle,nColFirst,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetInsertRow( nRowFirst, nRowLast )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetInsertRowA'},'__bo__sl__sl__sl',::hHandle,nRowFirst,nRowLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetInsertRowAndKeepRanges( nRowFirst, nRowLast )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetInsertRowAndKeepRangesA'},'__bo__sl__sl__sl',::hHandle,nRowFirst,nRowLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetIsDate( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetIsDateA'},'__bo__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetIsFormula( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetIsFormulaA'},'__bo__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetIsRichStr( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetIsRichStrA'},'__bo__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetLandscape()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetLandscapeA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetLastCol()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetLastColA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetLastFilledCol()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetLastFilledColA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetLastFilledRow()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetLastFilledRowA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetLastRow()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetLastRowA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetMarginBottom()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetMarginBottomA'},'__f8__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetMarginLeft()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetMarginLeftA'},'__f8__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetMarginRight()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetMarginRightA'},'__f8__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetMarginTop()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetMarginTopA'},'__f8__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetMerge( nIndex, nRowFirst, nRowLast, nColFirst, nColLast )    // return values, call: @nRowFirst, @nRowLast, @nColFirst, @nColLast
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetMergeA'},'__sl__sl__sl_@sl_@sl_@sl_@sl',::hHandle,nIndex,@nRowFirst,@nRowLast,@nColFirst,@nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetMergeSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetMergeSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetName()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetNameA'},'c_sz__sl',::hHandle) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetNamedRange( nIndex, nRowFirst, nRowLast, nColFirst, nColLast, nScopeId, lHidden )    // return values, call: @nRowFirst, @nRowLast, @nColFirst, @nColLast, @nScopeId
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   DEFAULT nScopeId TO 0   
   lHidden := ! empty(lHidden) 
   uRet := FpQCall( {'LibXL','xlSheetNamedRangeA'},'c_sz__sl__sl_@sl_@sl_@sl_@sl_@sl_@bo',::hHandle,nIndex,@nRowFirst,@nRowLast,@nColFirst,@nColLast,@nScopeId,@lHidden) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetNamedRangeSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetNamedRangeSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetPaper()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetPaperA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetPictureSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetPictureSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetPrintArea( nRowFirst, nRowLast, nColFirst, nColLast )    // return values, call: @nRowFirst, @nRowLast, @nColFirst, @nColLast
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetPrintAreaA'},'__bo__sl_@sl_@sl_@sl_@sl',::hHandle,@nRowFirst,@nRowLast,@nColFirst,@nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetPrintGridlines()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetPrintGridlinesA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetPrintRepeatCols( nColFirst, nColLast )    // return values, call: @nColFirst, @nColLast
   LOCAL uRet := nil
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetPrintRepeatColsA'},'__bo__sl_@sl_@sl',::hHandle,@nColFirst,@nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetPrintRepeatRows( nRowFirst, nRowLast )    // return values, call: @nRowFirst, @nRowLast
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetPrintRepeatRowsA'},'__bo__sl_@sl_@sl',::hHandle,@nRowFirst,@nRowLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetPrintRowCol()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetPrintRowColA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetPrintZoom()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetPrintZoomA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetProtect()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetProtectA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetReadBlank( nRow, nCol, hFormat )    // return values, call: @hFormat
   LOCAL uRet := nil
   LOCAL oTemp := nil 
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetReadBlankA'},'__bo__sl__sl__sl_@sl',::hHandle,nRow,nCol,@hFormat) 
   if empty(hFormat) 
      hFormat := NIL 
   else 
      oTemp := xlFormat():new() 
      oTemp:hHandle := hFormat
      hFormat := oTemp 
   endif 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetReadBool( nRow, nCol, hFormat )    // return values, call: @hFormat
   LOCAL uRet := nil
   LOCAL oTemp := nil 
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetReadBoolA'},'__bo__sl__sl__sl_@sl',::hHandle,nRow,nCol,@hFormat) 
   if empty(hFormat) 
      hFormat := NIL 
   else 
      oTemp := xlFormat():new() 
      oTemp:hHandle := hFormat
      hFormat := oTemp 
   endif 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetReadComment( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetReadCommentA'},'__pt__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetReadError( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetReadErrorA'},'__sl__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetReadFormula( nRow, nCol, hFormat )    // return values, call: @hFormat
   LOCAL uRet := nil
   LOCAL oTemp := nil 
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetReadFormulaA'},'c_sz__sl__sl__sl_@sl',::hHandle,nRow,nCol,@hFormat) 
   if empty(hFormat) 
      hFormat := NIL 
   else 
      oTemp := xlFormat():new() 
      oTemp:hHandle := hFormat
      hFormat := oTemp 
   endif 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetReadNum( nRow, nCol, hFormat )    // return values, call: @hFormat
   LOCAL uRet := nil
   LOCAL oTemp := nil 
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetReadNumA'},'__f8__sl__sl__sl_@sl',::hHandle,nRow,nCol,@hFormat) 
   if empty(hFormat) 
      hFormat := NIL 
   else 
      oTemp := xlFormat():new() 
      oTemp:hHandle := hFormat
      hFormat := oTemp 
   endif 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetReadRichStr( nRow, nCol, hFormat )    // return values, call: @hFormat
   LOCAL uRet := nil
   LOCAL oRichString := nil
   LOCAL oTemp := nil 
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetReadRichStrA'},'__sl__sl__sl__sl_@sl',::hHandle,nRow,nCol,@hFormat) 
   if empty(hFormat) 
      hFormat := NIL 
   else 
      oTemp := xlFormat():new() 
      oTemp:hHandle := hFormat
      hFormat := oTemp 
   endif 
   if ! empty(uRet)                       
      oRichString := xlRichString():new() 
      oRichString:hHandle := uRet         
   endif                                  
RETURN oRichString                        
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetReadStr( nRow, nCol, hFormat )    // return values, call: @hFormat
   LOCAL uRet := nil
   LOCAL oTemp := nil 
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetReadStrA'},'c_sz__sl__sl__sl_@sl',::hHandle,nRow,nCol,@hFormat) 
   if empty(hFormat) 
      hFormat := NIL 
   else 
      oTemp := xlFormat():new() 
      oTemp:hHandle := hFormat
      hFormat := oTemp 
   endif 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRemoveCol( nColFirst, nColLast )   
   LOCAL uRet := nil
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetRemoveColA'},'__bo__sl__sl__sl',::hHandle,nColFirst,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRemoveColAndKeepRanges( nColFirst, nColLast )   
   LOCAL uRet := nil
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetRemoveColAndKeepRangesA'},'__bo__sl__sl__sl',::hHandle,nColFirst,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRemoveComment( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetRemoveCommentA'},'__vo__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRemoveDataValidations()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetRemoveDataValidationsA'},'__vo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRemoveFilter()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetRemoveFilterA'},'__vo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRemovePicture( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetRemovePictureA'},'__bo__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRemovePictureByIndex( nIndex )   
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlSheetRemovePictureByIndexA'},'__bo__sl__sl',::hHandle,nIndex) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRemoveRowAndKeepRanges( nRowFirst, nRowLast )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetRemoveRowAndKeepRangesA'},'__bo__sl__sl__sl',::hHandle,nRowFirst,nRowLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRemoveRow( nRowFirst, nRowLast )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetRemoveRowA'},'__bo__sl__sl__sl',::hHandle,nRowFirst,nRowLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRightToLeft()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetRightToLeftA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRowColToAddr( nRow, nCol, lRowRelative, lColRelative )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   DEFAULT lRowRelative TO .f.
   lRowRelative := ! empty(lRowRelative) 
   DEFAULT lColRelative TO .f.
   lColRelative := ! empty(lColRelative) 
   uRet := FpQCall( {'LibXL','xlSheetRowColToAddrA'},'c_sz__sl__sl__sl__bo__bo',::hHandle,nRow,nCol,lRowRelative,lColRelative) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRowHeight( nRow )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   uRet := FpQCall( {'LibXL','xlSheetRowHeightA'},'__f8__sl__sl',::hHandle,nRow) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRowHeightPx( nRow )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   uRet := FpQCall( {'LibXL','xlSheetRowHeightPxA'},'__sl__sl__sl',::hHandle,nRow) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetRowHidden( nRow )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   uRet := FpQCall( {'LibXL','xlSheetRowHiddenA'},'__bo__sl__sl',::hHandle,nRow) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetAutoFitArea( nRowFirst, nColFirst, nRowLast, nColLast )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetAutoFitAreaA'},'__vo__sl__sl__sl__sl__sl',::hHandle,nRowFirst,nColFirst,nRowLast,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetCellFormat( nRow, nCol, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetSetCellFormatA'},'__vo__sl__sl__sl__sl',::hHandle,nRow,nCol,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetCol( nColFirst, nColLast, nWidth, hFormat, lHidden )   
   LOCAL uRet := nil
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   DEFAULT nWidth TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   DEFAULT lHidden TO .t.
   lHidden := ! empty(lHidden) 
   uRet := FpQCall( {'LibXL','xlSheetSetColA'},'__bo__sl__sl__sl__f8__sl__bo',::hHandle,nColFirst,nColLast,nWidth,hFormat,lHidden) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetColHidden( nCol, lHidden )   
   LOCAL uRet := nil
   DEFAULT nCol TO 0   
   DEFAULT lHidden TO .t.
   lHidden := ! empty(lHidden) 
   uRet := FpQCall( {'LibXL','xlSheetSetColHiddenA'},'__bo__sl__sl__bo',::hHandle,nCol,lHidden) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetDisplayGridlines( lShow )   
   LOCAL uRet := nil
   DEFAULT lShow TO .t.
   lShow := ! empty(lShow) 
   uRet := FpQCall( {'LibXL','xlSheetSetDisplayGridlinesA'},'__vo__sl__bo',::hHandle,lShow) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetFooter( cFooter, nMargin )   
   LOCAL uRet := nil
   cFooter := ::ForceAnsi(cFooter)
   DEFAULT nMargin TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetFooterA'},'__bo__sl__pt__f8',::hHandle,cFooter,nMargin) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetGroupSummaryBelow( nBelow )   
   LOCAL uRet := nil
   DEFAULT nBelow TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetGroupSummaryBelowA'},'__vo__sl__sl',::hHandle,nBelow) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetGroupSummaryRight( nRight )   
   LOCAL uRet := nil
   DEFAULT nRight TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetGroupSummaryRightA'},'__vo__sl__sl',::hHandle,nRight) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetHCenter( lHCenter )   
   LOCAL uRet := nil
   DEFAULT lHCenter TO .t.
   lHCenter := ! empty(lHCenter) 
   uRet := FpQCall( {'LibXL','xlSheetSetHCenterA'},'__vo__sl__bo',::hHandle,lHCenter) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetHeader( cHeader, nMargin )   
   LOCAL uRet := nil
   cHeader := ::ForceAnsi(cHeader)
   DEFAULT nMargin TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetHeaderA'},'__bo__sl__pt__f8',::hHandle,cHeader,nMargin) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetHidden( lHidden )   
   LOCAL uRet := nil
   DEFAULT lHidden TO .t.
   lHidden := ! empty(lHidden) 
   uRet := FpQCall( {'LibXL','xlSheetSetHiddenA'},'__bo__sl__bo',::hHandle,lHidden) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetHorPageBreak( nRow, lPageBreak )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT lPageBreak TO .t.
   lPageBreak := ! empty(lPageBreak) 
   uRet := FpQCall( {'LibXL','xlSheetSetHorPageBreakA'},'__bo__sl__sl__bo',::hHandle,nRow,lPageBreak) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetLandscape( lLandscape )   
   LOCAL uRet := nil
   DEFAULT lLandscape TO .t.
   lLandscape := ! empty(lLandscape) 
   uRet := FpQCall( {'LibXL','xlSheetSetLandscapeA'},'__vo__sl__bo',::hHandle,lLandscape) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetMarginBottom( nMargin )   
   LOCAL uRet := nil
   DEFAULT nMargin TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetMarginBottomA'},'__vo__sl__f8',::hHandle,nMargin) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetMarginLeft( nMargin )   
   LOCAL uRet := nil
   DEFAULT nMargin TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetMarginLeftA'},'__vo__sl__f8',::hHandle,nMargin) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetMarginRight( nMargin )   
   LOCAL uRet := nil
   DEFAULT nMargin TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetMarginRightA'},'__vo__sl__f8',::hHandle,nMargin) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetMarginTop( nMargin )   
   LOCAL uRet := nil
   DEFAULT nMargin TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetMarginTopA'},'__vo__sl__f8',::hHandle,nMargin) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetMerge( nRowFirst, nRowLast, nColFirst, nColLast )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetMergeA'},'__bo__sl__sl__sl__sl__sl',::hHandle,nRowFirst,nRowLast,nColFirst,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetName( cName )   
   LOCAL uRet := nil
   cName := ::ForceAnsi(cName)
   uRet := FpQCall( {'LibXL','xlSheetSetNameA'},'__vo__sl__pt',::hHandle,cName) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetNamedRange( cName, nRowFirst, nRowLast, nColFirst, nColLast, nScopeId )   
   LOCAL uRet := nil
   cName := ::ForceAnsi(cName)
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   DEFAULT nScopeId TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetNamedRangeA'},'__bo__sl__pt__sl__sl__sl__sl__sl',::hHandle,cName,nRowFirst,nRowLast,nColFirst,nColLast,nScopeId) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetPaper( nPaper )   
   LOCAL uRet := nil
   DEFAULT nPaper TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetPaperA'},'__vo__sl__sl',::hHandle,nPaper) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetPicture2( nRow, nCol, nPictureId, nWidth, nHeight, nOffset_x, nOffset_y )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   DEFAULT nPictureId TO 0   
   DEFAULT nWidth TO 0   
   DEFAULT nHeight TO 0   
   DEFAULT nOffset_x TO 0   
   DEFAULT nOffset_y TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetPicture2A'},'__vo__sl__sl__sl__sl__sl__sl__sl__sl',::hHandle,nRow,nCol,nPictureId,nWidth,nHeight,nOffset_x,nOffset_y) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetPicture( nRow, nCol, nPictureId, nScale, nOffset_x, nOffset_y )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   DEFAULT nPictureId TO 0   
   DEFAULT nScale TO 0   
   DEFAULT nOffset_x TO 0   
   DEFAULT nOffset_y TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetPictureA'},'__vo__sl__sl__sl__sl__f8__sl__sl',::hHandle,nRow,nCol,nPictureId,nScale,nOffset_x,nOffset_y) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetPrintArea( nRowFirst, nRowLast, nColFirst, nColLast )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetPrintAreaA'},'__vo__sl__sl__sl__sl__sl',::hHandle,nRowFirst,nRowLast,nColFirst,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetPrintFit( nWPages, nHPages )   
   LOCAL uRet := nil
   DEFAULT nWPages TO 0   
   DEFAULT nHPages TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetPrintFitA'},'__vo__sl__sl__sl',::hHandle,nWPages,nHPages) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetPrintGridlines( lPrint )   
   LOCAL uRet := nil
   DEFAULT lPrint TO .t.
   lPrint := ! empty(lPrint) 
   uRet := FpQCall( {'LibXL','xlSheetSetPrintGridlinesA'},'__vo__sl__bo',::hHandle,lPrint) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetPrintRepeatCols( nColFirst, nColLast )   
   LOCAL uRet := nil
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetPrintRepeatColsA'},'__vo__sl__sl__sl',::hHandle,nColFirst,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetPrintRepeatRows( nRowFirst, nRowLast )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetPrintRepeatRowsA'},'__vo__sl__sl__sl',::hHandle,nRowFirst,nRowLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetPrintRowCol( lPrint )   
   LOCAL uRet := nil
   DEFAULT lPrint TO .t.
   lPrint := ! empty(lPrint) 
   uRet := FpQCall( {'LibXL','xlSheetSetPrintRowColA'},'__vo__sl__bo',::hHandle,lPrint) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetPrintZoom( nZoom )   
   LOCAL uRet := nil
   DEFAULT nZoom TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetPrintZoomA'},'__vo__sl__sl',::hHandle,nZoom) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetProtect( lProtect )   
   LOCAL uRet := nil
   DEFAULT lProtect TO .t.
   lProtect := ! empty(lProtect) 
   uRet := FpQCall( {'LibXL','xlSheetSetProtectA'},'__vo__sl__bo',::hHandle,lProtect) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetProtectEx( lProtect, cPassword, nEnhancedProtection )   
   LOCAL uRet := nil
   DEFAULT lProtect TO .t.
   lProtect := ! empty(lProtect) 
   cPassword := ::ForceAnsi(cPassword)
   DEFAULT nEnhancedProtection TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetProtectExA'},'__vo__sl__bo__pt__sl',::hHandle,lProtect,cPassword,nEnhancedProtection) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetRightToLeft( lRightToLeft )   
   LOCAL uRet := nil
   DEFAULT lRightToLeft TO .t.
   lRightToLeft := ! empty(lRightToLeft) 
   uRet := FpQCall( {'LibXL','xlSheetSetRightToLeftA'},'__vo__sl__bo',::hHandle,lRightToLeft) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetRow( nRow, nHeight, hFormat, lHidden )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nHeight TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   DEFAULT lHidden TO .t.
   lHidden := ! empty(lHidden) 
   uRet := FpQCall( {'LibXL','xlSheetSetRowA'},'__bo__sl__sl__f8__sl__bo',::hHandle,nRow,nHeight,hFormat,lHidden) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetRowHidden( nRow, lHidden )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT lHidden TO .t.
   lHidden := ! empty(lHidden) 
   uRet := FpQCall( {'LibXL','xlSheetSetRowHiddenA'},'__bo__sl__sl__bo',::hHandle,nRow,lHidden) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetTabColor( nColor )   
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetTabColorA'},'__vo__sl__sl',::hHandle,nColor) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetTabRgbColor( nRed, nGreen, nBlue )   
   LOCAL uRet := nil
   DEFAULT nRed TO 0   
   DEFAULT nGreen TO 0   
   DEFAULT nBlue TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetTabRgbColorA'},'__vo__sl__sl__sl__sl',::hHandle,nRed,nGreen,nBlue) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetTopLeftView( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetTopLeftViewA'},'__vo__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetVCenter( lVCenter )   
   LOCAL uRet := nil
   DEFAULT lVCenter TO .t.
   lVCenter := ! empty(lVCenter) 
   uRet := FpQCall( {'LibXL','xlSheetSetVCenterA'},'__vo__sl__bo',::hHandle,lVCenter) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetVerPageBreak( nCol, lPageBreak )   
   LOCAL uRet := nil
   DEFAULT nCol TO 0   
   DEFAULT lPageBreak TO .t.
   lPageBreak := ! empty(lPageBreak) 
   uRet := FpQCall( {'LibXL','xlSheetSetVerPageBreakA'},'__bo__sl__sl__bo',::hHandle,nCol,lPageBreak) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSetZoom( nZoom )   
   LOCAL uRet := nil
   DEFAULT nZoom TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSetZoomA'},'__vo__sl__sl',::hHandle,nZoom) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSplit( nRow, nCol )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSplitA'},'__vo__sl__sl__sl',::hHandle,nRow,nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetSplitInfo( nRow, nCol )    // return values, call: @nRow, @nCol
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   uRet := FpQCall( {'LibXL','xlSheetSplitInfoA'},'__bo__sl_@sl_@sl',::hHandle,@nRow,@nCol) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetTable( nIndex, nRowFirst, nRowLast, nColFirst, nColLast, nHeaderRowCount, nTotalsRowCount )    // return values, call: @nRowFirst, @nRowLast, @nColFirst, @nColLast, @nHeaderRowCount, @nTotalsRowCount
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   DEFAULT nHeaderRowCount TO 0   
   DEFAULT nTotalsRowCount TO 0   
   uRet := FpQCall( {'LibXL','xlSheetTableA'},'c_sz__sl__sl_@sl_@sl_@sl_@sl_@sl_@sl',::hHandle,nIndex,@nRowFirst,@nRowLast,@nColFirst,@nColLast,@nHeaderRowCount,@nTotalsRowCount) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetTableSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetTableSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetVCenter()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetVCenterA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteBlank( nRow, nCol, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetWriteBlankA'},'__bo__sl__sl__sl__sl',::hHandle,nRow,nCol,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteBool( nRow, nCol, nValue, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   DEFAULT nValue TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetWriteBoolA'},'__bo__sl__sl__sl__sl__sl',::hHandle,nRow,nCol,nValue,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteComment( nRow, nCol, cValue, cAuthor, nWidth, nHeight )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   cValue := ::ForceAnsi(cValue)
   cAuthor := ::ForceAnsi(cAuthor)
   DEFAULT nWidth TO 0   
   DEFAULT nHeight TO 0   
   uRet := FpQCall( {'LibXL','xlSheetWriteCommentA'},'__vo__sl__sl__sl__pt__pt__sl__sl',::hHandle,nRow,nCol,cValue,cAuthor,nWidth,nHeight) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteError( nRow, nCol, nError, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   DEFAULT nError TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetWriteErrorA'},'__vo__sl__sl__sl__sl__sl',::hHandle,nRow,nCol,nError,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteFormula( nRow, nCol, cValue, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   cValue := ::ForceAnsi(cValue)
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetWriteFormulaA'},'__bo__sl__sl__sl__pt__sl',::hHandle,nRow,nCol,cValue,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteFormulaBool( nRow, nCol, cExpr, lValue, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   cExpr := ::ForceAnsi(cExpr)
   lValue := ! empty(lValue) 
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetWriteFormulaBoolA'},'__bo__sl__sl__sl__pt__bo__sl',::hHandle,nRow,nCol,cExpr,lValue,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteFormulaNum( nRow, nCol, cExpr, nValue, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   cExpr := ::ForceAnsi(cExpr)
   DEFAULT nValue TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetWriteFormulaNumA'},'__bo__sl__sl__sl__pt__f8__sl',::hHandle,nRow,nCol,cExpr,nValue,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteFormulaStr( nRow, nCol, cExpr, cValue, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   cExpr := ::ForceAnsi(cExpr)
   cValue := ::ForceAnsi(cValue)
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetWriteFormulaStrA'},'__bo__sl__sl__sl__pt__pt__sl',::hHandle,nRow,nCol,cExpr,cValue,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteNum( nRow, nCol, nValue, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   DEFAULT nValue TO 0   
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetWriteNumA'},'__bo__sl__sl__sl__f8__sl',::hHandle,nRow,nCol,nValue,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteRichStr( nRow, nCol, hRichString, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   do case                                      
      case valtype(hRichString)='O' .and. IsMemberVar(hRichString,'hHandle') 
         hRichString := hRichString:hHandle 
      case valtype(hRichString)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hRichString := 0                     
   end                                          
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetWriteRichStrA'},'__bo__sl__sl__sl__sl__sl',::hHandle,nRow,nCol,hRichString,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetWriteStr( nRow, nCol, cValue, hFormat )   
   LOCAL uRet := nil
   DEFAULT nRow TO 0   
   DEFAULT nCol TO 0   
   cValue := ::ForceAnsi(cValue)
   do case                                      
      case valtype(hFormat)='O' .and. IsMemberVar(hFormat,'hHandle') 
         hFormat := hFormat:hHandle 
      case valtype(hFormat)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFormat := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlSheetWriteStrA'},'__bo__sl__sl__sl__pt__sl',::hHandle,nRow,nCol,cValue,hFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlSheet:SheetZoom()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlSheetZoomA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------

*********************************************************************************
METHOD xlFormat:FormatAlignH()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatAlignHA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatAlignV()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatAlignVA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderBottom()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderBottomA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderBottomColor()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderBottomColorA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderDiagonal()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderDiagonalA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderDiagonalColor()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderDiagonalColorA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderDiagonalStyle()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderDiagonalStyleA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderLeft()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderLeftA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderLeftColor()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderLeftColorA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderRight()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderRightA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderRightColor()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderRightColorA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderTop()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderTopA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatBorderTopColor()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatBorderTopColorA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatFillPattern()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatFillPatternA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatFont()
   LOCAL uRet := nil
   LOCAL oFont := nil
   uRet := FpQCall( {'LibXL','xlFormatFontA'},'__sl__sl',::hHandle) 
   if ! empty(uRet)                       
      oFont := xlFont():new()             
      oFont:hHandle := uRet               
   endif                                  
RETURN oFont                              
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatHidden()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatHiddenA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatIndent()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatIndentA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatLocked()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatLockedA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatNumFormat()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatNumFormatA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatPatternBackgroundColor()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatPatternBackgroundColorA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatPatternForegroundColor()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatPatternForegroundColorA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatRotation()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatRotationA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetAlignH( nAlign )   
   LOCAL uRet := nil
   DEFAULT nAlign TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetAlignHA'},'__vo__sl__sl',::hHandle,nAlign) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetAlignV( nAlign )   
   LOCAL uRet := nil
   DEFAULT nAlign TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetAlignVA'},'__vo__sl__sl',::hHandle,nAlign) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorder( nStyle )   
   LOCAL uRet := nil
   DEFAULT nStyle TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderA'},'__vo__sl__sl',::hHandle,nStyle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderBottom( nStyle )   
   LOCAL uRet := nil
   DEFAULT nStyle TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderBottomA'},'__vo__sl__sl',::hHandle,nStyle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderBottomColor( nColor )   
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderBottomColorA'},'__vo__sl__sl',::hHandle,nColor) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderColor( nColor )   
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderColorA'},'__vo__sl__sl',::hHandle,nColor) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderDiagonal( nBorder )   
   LOCAL uRet := nil
   DEFAULT nBorder TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderDiagonalA'},'__vo__sl__sl',::hHandle,nBorder) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderDiagonalColor( nColor )   
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderDiagonalColorA'},'__vo__sl__sl',::hHandle,nColor) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderDiagonalStyle( nStyle )   
   LOCAL uRet := nil
   DEFAULT nStyle TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderDiagonalStyleA'},'__vo__sl__sl',::hHandle,nStyle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderLeft( nStyle )   
   LOCAL uRet := nil
   DEFAULT nStyle TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderLeftA'},'__vo__sl__sl',::hHandle,nStyle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderLeftColor( nColor )   
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderLeftColorA'},'__vo__sl__sl',::hHandle,nColor) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderRight( nStyle )   
   LOCAL uRet := nil
   DEFAULT nStyle TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderRightA'},'__vo__sl__sl',::hHandle,nStyle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderRightColor( nColor )   
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderRightColorA'},'__vo__sl__sl',::hHandle,nColor) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderTop( nStyle )   
   LOCAL uRet := nil
   DEFAULT nStyle TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderTopA'},'__vo__sl__sl',::hHandle,nStyle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetBorderTopColor( nColor )   
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetBorderTopColorA'},'__vo__sl__sl',::hHandle,nColor) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetFillPattern( nPattern )   
   LOCAL uRet := nil
   DEFAULT nPattern TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetFillPatternA'},'__vo__sl__sl',::hHandle,nPattern) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetFont( hFontHandle )   
   LOCAL uRet := nil
   do case                                      
      case valtype(hFontHandle)='O' .and. IsMemberVar(hFontHandle,'hHandle') 
         hFontHandle := hFontHandle:hHandle 
      case valtype(hFontHandle)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFontHandle := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlFormatSetFontA'},'__bo__sl__sl',::hHandle,hFontHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetHidden( lHidden )   
   LOCAL uRet := nil
   DEFAULT lHidden TO .t.
   lHidden := ! empty(lHidden) 
   uRet := FpQCall( {'LibXL','xlFormatSetHiddenA'},'__vo__sl__bo',::hHandle,lHidden) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetIndent( nIndent )   
   LOCAL uRet := nil
   DEFAULT nIndent TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetIndentA'},'__vo__sl__sl',::hHandle,nIndent) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetLocked( lLocked )   
   LOCAL uRet := nil
   DEFAULT lLocked TO .t.
   lLocked := ! empty(lLocked) 
   uRet := FpQCall( {'LibXL','xlFormatSetLockedA'},'__vo__sl__bo',::hHandle,lLocked) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetNumFormat( nNumFormat )   
   LOCAL uRet := nil
   DEFAULT nNumFormat TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetNumFormatA'},'__vo__sl__sl',::hHandle,nNumFormat) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetPatternBackgroundColor( nColor )   
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetPatternBackgroundColorA'},'__vo__sl__sl',::hHandle,nColor) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetPatternForegroundColor( nColor )   
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetPatternForegroundColorA'},'__vo__sl__sl',::hHandle,nColor) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetRotation( nRotation )   
   LOCAL uRet := nil
   DEFAULT nRotation TO 0   
   uRet := FpQCall( {'LibXL','xlFormatSetRotationA'},'__sl__sl__sl',::hHandle,nRotation) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetShrinkToFit( lShrinkToFit )   
   LOCAL uRet := nil
   DEFAULT lShrinkToFit TO .t.
   lShrinkToFit := ! empty(lShrinkToFit) 
   uRet := FpQCall( {'LibXL','xlFormatSetShrinkToFitA'},'__vo__sl__bo',::hHandle,lShrinkToFit) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatSetWrap( lWrap )   
   LOCAL uRet := nil
   DEFAULT lWrap TO .t.
   lWrap := ! empty(lWrap) 
   uRet := FpQCall( {'LibXL','xlFormatSetWrapA'},'__vo__sl__bo',::hHandle,lWrap) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatShrinkToFit()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatShrinkToFitA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFormat:FormatWrap()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFormatWrapA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------

*********************************************************************************
METHOD xlFont:FontBold()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFontBoldA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontColor()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFontColorA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontItalic()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFontItalicA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontName()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFontNameA'},'c_sz__sl',::hHandle) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlFont:FontScript()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFontScriptA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontSetBold( lBold )   
   LOCAL uRet := nil
   DEFAULT lBold TO .t.
   lBold := ! empty(lBold) 
   uRet := FpQCall( {'LibXL','xlFontSetBoldA'},'__vo__sl__bo',::hHandle,lBold) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontSetColor( nColor )   
   LOCAL uRet := nil
   DEFAULT nColor TO 0   
   uRet := FpQCall( {'LibXL','xlFontSetColorA'},'__vo__sl__sl',::hHandle,nColor) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontSetItalic( lItalic )   
   LOCAL uRet := nil
   DEFAULT lItalic TO .t.
   lItalic := ! empty(lItalic) 
   uRet := FpQCall( {'LibXL','xlFontSetItalicA'},'__vo__sl__bo',::hHandle,lItalic) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontSetName( cName )   
   LOCAL uRet := nil
   cName := ::ForceAnsi(cName)
   uRet := FpQCall( {'LibXL','xlFontSetNameA'},'__sl__sl__pt',::hHandle,cName) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontSetScript( nScript )   
   LOCAL uRet := nil
   DEFAULT nScript TO 0   
   uRet := FpQCall( {'LibXL','xlFontSetScriptA'},'__vo__sl__sl',::hHandle,nScript) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontSetSize( nSize )   
   LOCAL uRet := nil
   DEFAULT nSize TO 0   
   uRet := FpQCall( {'LibXL','xlFontSetSizeA'},'__vo__sl__sl',::hHandle,nSize) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontSetStrikeOut( lStrikeOut )   
   LOCAL uRet := nil
   DEFAULT lStrikeOut TO .t.
   lStrikeOut := ! empty(lStrikeOut) 
   uRet := FpQCall( {'LibXL','xlFontSetStrikeOutA'},'__vo__sl__bo',::hHandle,lStrikeOut) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontSetUnderline( nUnderline )   
   LOCAL uRet := nil
   DEFAULT nUnderline TO 0   
   uRet := FpQCall( {'LibXL','xlFontSetUnderlineA'},'__vo__sl__sl',::hHandle,nUnderline) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFontSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontStrikeOut()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFontStrikeOutA'},'__bo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFont:FontUnderline()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFontUnderlineA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------

*********************************************************************************
METHOD xlAutoFilter:AutoFilterColumn( nColId )   
   LOCAL uRet := nil
   LOCAL oFilterColumn := nil
   DEFAULT nColId TO 0   
   uRet := FpQCall( {'LibXL','xlAutoFilterColumnA'},'__sl__sl__sl',::hHandle,nColId) 
   if ! empty(uRet)                       
      oFilterColumn := xlFilterColumn():new() 
      oFilterColumn:hHandle := uRet       
   endif                                  
RETURN oFilterColumn                      
*--------------------------------------------------------------------------------
METHOD xlAutoFilter:AutoFilterColumnByIndex( nIndex )   
   LOCAL uRet := nil
   LOCAL oFilterColumn := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlAutoFilterColumnByIndexA'},'__sl__sl__sl',::hHandle,nIndex) 
   if ! empty(uRet)                       
      oFilterColumn := xlFilterColumn():new() 
      oFilterColumn:hHandle := uRet       
   endif                                  
RETURN oFilterColumn                      
*--------------------------------------------------------------------------------
METHOD xlAutoFilter:AutoFilterColumnSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlAutoFilterColumnSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlAutoFilter:AutoFilterGetRef( nRowFirst, nRowLast, nColFirst, nColLast )    // return values, call: @nRowFirst, @nRowLast, @nColFirst, @nColLast
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlAutoFilterGetRefA'},'__bo__sl_@sl_@sl_@sl_@sl',::hHandle,@nRowFirst,@nRowLast,@nColFirst,@nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlAutoFilter:AutoFilterGetSort( nColumnIndex, lDescending )    // return values, call: @nColumnIndex
   LOCAL uRet := nil
   DEFAULT nColumnIndex TO 0   
   lDescending := ! empty(lDescending) 
   uRet := FpQCall( {'LibXL','xlAutoFilterGetSortA'},'__bo__sl_@sl_@bo',::hHandle,@nColumnIndex,@lDescending) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlAutoFilter:AutoFilterGetSortRange( nRowFirst, nRowLast, nColFirst, nColLast )    // return values, call: @nRowFirst, @nRowLast, @nColFirst, @nColLast
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlAutoFilterGetSortRangeA'},'__bo__sl_@sl_@sl_@sl_@sl',::hHandle,@nRowFirst,@nRowLast,@nColFirst,@nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlAutoFilter:AutoFilterSetRef( nRowFirst, nRowLast, nColFirst, nColLast )   
   LOCAL uRet := nil
   DEFAULT nRowFirst TO 0   
   DEFAULT nRowLast TO 0   
   DEFAULT nColFirst TO 0   
   DEFAULT nColLast TO 0   
   uRet := FpQCall( {'LibXL','xlAutoFilterSetRefA'},'__vo__sl__sl__sl__sl__sl',::hHandle,nRowFirst,nRowLast,nColFirst,nColLast) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlAutoFilter:AutoFilterSetSort( nColumnIndex, nDescending )   
   LOCAL uRet := nil
   DEFAULT nColumnIndex TO 0   
   DEFAULT nDescending TO 0   
   uRet := FpQCall( {'LibXL','xlAutoFilterSetSortA'},'__bo__sl__sl__sl',::hHandle,nColumnIndex,nDescending) 
RETURN uRet
*--------------------------------------------------------------------------------

*********************************************************************************
METHOD xlFilterColumn:FilterColumnAddFilter( cValue )   
   LOCAL uRet := nil
   cValue := ::ForceAnsi(cValue)
   uRet := FpQCall( {'LibXL','xlFilterColumnAddFilterA'},'__vo__sl__pt',::hHandle,cValue) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:FilterColumnClear()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFilterColumnClearA'},'__vo__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:FilterColumnFilter( nIndex )   
   LOCAL uRet := nil
   DEFAULT nIndex TO 0   
   uRet := FpQCall( {'LibXL','xlFilterColumnFilterA'},'c_sz__sl__sl',::hHandle,nIndex) 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:FilterColumnFilterSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFilterColumnFilterSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:FilterColumnFilterType()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFilterColumnFilterTypeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:FilterColumnGetCustomFilter( nOp1, iV1, nOp2, iV2, nAndOp )    // return values, call: @nOp1, @iV1, @nOp2, @iV2, @nAndOp
   local uRet := nil 
   DEFAULT nOp1 TO 0 
   DEFAULT nOp2 TO 0 
   // we need an empty Pointer to a Stringpointer
   iV1 := 0            // Pablo thanks a lot :-) 
   iV2 := 0            // Pablo thanks a lot :-) 
   DEFAULT nAndOp TO 0 
   uRet := FpQCall( {'LibXL','xlFilterColumnGetCustomFilterA'},'__bo__sl_@sl_@sl_@sl_@sl_@sl',::hHandle,@nOp1,@iV1,@nOp2,@iV2,@nAndOp)
   // still under test 
   if uRet  .and. ! empty(iV1) 
      iV1 := PeekStr(iV1,,-1)  
   endif             
   if uRet  .and. ! empty(iV2) 
      iV2 := PeekStr(iV2,,-1)  
   endif 
RETURN uRet 
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:FilterColumnGetTop10( nValue, lTop, lPercent )   
   LOCAL uRet := nil
   DEFAULT nValue TO 0   
   lTop := ! empty(lTop) 
   lPercent := ! empty(lPercent) 
   uRet := FpQCall( {'LibXL','xlFilterColumnGetTop10A'},'__bo__sl_@f8_@bo_@bo',::hHandle,@nValue,@lTop,@lPercent) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:FilterColumnIndex()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlFilterColumnIndexA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:FilterColumnSetCustomFilter( nOp, cV )   
   LOCAL uRet := nil
   DEFAULT nOp TO 0   
   cV := ::ForceAnsi(cV)
   uRet := FpQCall( {'LibXL','xlFilterColumnSetCustomFilterA'},'__vo__sl__sl__pt',::hHandle,nOp,cV) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:FilterColumnSetCustomFilterEx( nOp1, cV1, nOp2, cV2, nAndOp )   
   LOCAL uRet := nil
   DEFAULT nOp1 TO 0   
   cV1 := ::ForceAnsi(cV1)
   DEFAULT nOp2 TO 0   
   cV2 := ::ForceAnsi(cV2)
   DEFAULT nAndOp TO 0   
   uRet := FpQCall( {'LibXL','xlFilterColumnSetCustomFilterExA'},'__vo__sl__sl__pt__sl__pt__sl',::hHandle,nOp1,cV1,nOp2,cV2,nAndOp) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlFilterColumn:FilterColumnSetTop10( nValue, lTop, lPercent )   
   LOCAL uRet := nil
   DEFAULT nValue TO 0   
   DEFAULT lTop TO .t.
   lTop := ! empty(lTop) 
   DEFAULT lPercent TO .f.
   lPercent := ! empty(lPercent) 
   uRet := FpQCall( {'LibXL','xlFilterColumnSetTop10A'},'__vo__sl__f8__bo__bo',::hHandle,nValue,lTop,lPercent) 
RETURN uRet
*--------------------------------------------------------------------------------

*********************************************************************************
METHOD xlRichString:RichStringAddFont( hInitFont )   
   LOCAL uRet := nil
   LOCAL oFont := nil
   do case                                      
      case valtype(hInitFont)='O' .and. IsMemberVar(hInitFont,'hHandle') 
         hInitFont := hInitFont:hHandle 
      case valtype(hInitFont)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hInitFont := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlRichStringAddFontA'},'__sl__sl__sl',::hHandle,hInitFont) 
   if ! empty(uRet)                       
      oFont := xlFont():new()             
      oFont:hHandle := uRet               
   endif                                  
RETURN oFont                              
*--------------------------------------------------------------------------------
METHOD xlRichString:RichStringAddText( cText, hFont )   
   LOCAL uRet := nil
   cText := ::ForceAnsi(cText)
   do case                                      
      case valtype(hFont)='O' .and. IsMemberVar(hFont,'hHandle') 
         hFont := hFont:hHandle 
      case valtype(hFont)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFont := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlRichStringAddTextA'},'__vo__sl__pt__sl',::hHandle,cText,hFont) 
RETURN uRet
*--------------------------------------------------------------------------------
METHOD xlRichString:RichStringGetText( nIndex, hFont )    // return values, call: @hFont
   LOCAL uRet := nil
   LOCAL oTemp := nil 
   DEFAULT nIndex TO 0   
   do case                                      
      case valtype(hFont)='O' .and. IsMemberVar(hFont,'hHandle') 
         hFont := hFont:hHandle 
      case valtype(hFont)='N'           
         // nHandle übergeben, direkt verwenden 
      otherwise                                 
         hFont := 0                     
   end                                          
   uRet := FpQCall( {'LibXL','xlRichStringGetTextA'},'c_sz__sl__sl_@sl',::hHandle,nIndex,@hFont) 
   if empty(hFont) 
      hFont := NIL 
   else 
      oTemp := xlFont():new() 
      oTemp:hHandle := hFont
      hFont := oTemp 
   endif 
RETURN ::ReadString( uRet ) 
*--------------------------------------------------------------------------------
METHOD xlRichString:RichStringTextSize()
   LOCAL uRet := nil
   uRet := FpQCall( {'LibXL','xlRichStringTextSizeA'},'__sl__sl',::hHandle) 
RETURN uRet
*--------------------------------------------------------------------------------
