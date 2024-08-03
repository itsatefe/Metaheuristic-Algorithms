!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                                                                           !
!                         LibXL Fortran headers                             ! 
!                                                                           !
!                 Copyright (c) 2008 - 2022 XLware s.r.o.                   !
!                                                                           !
!   THIS FILE AND THE SOFTWARE CONTAINED HEREIN IS PROVIDED 'AS IS' AND     !
!                COMES WITH NO WARRANTIES OF ANY KIND.                      !
!                                                                           !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    
    
MODULE libxl

    USE, INTRINSIC::ISO_C_BINDING

    integer, parameter :: ALIGNH_GENERAL=0, ALIGNH_LEFT=1, ALIGNH_CENTER=2, ALIGNH_RIGHT=3, ALIGNH_FILL=4, ALIGNH_JUSTIFY=5, ALIGNH_MERGE=6, ALIGNH_DISTRIBUTED=7
    integer, parameter :: ALIGNV_TOP=0,ALIGNV_CENTER=1,ALIGNV_BOTTOM=2,ALIGNV_JUSTIFY=3,ALIGNV_DISTRIBUTED=4
    integer, parameter :: BORDERSTYLE_NONE=0,BORDERSTYLE_THIN=1,BORDERSTYLE_MEDIUM=2,BORDERSTYLE_DASHED=3,BORDERSTYLE_DOTTED=4,BORDERSTYLE_THICK=5,BORDERSTYLE_DOUBLE=6,BORDERSTYLE_HAIR=7,BORDERSTYLE_MEDIUMDASHED=8,BORDERSTYLE_DASHDOT=9,BORDERSTYLE_MEDIUMDASHDOT=10,BORDERSTYLE_DASHDOTDOT=11,BORDERSTYLE_MEDIUMDASHDOTDOT=12,BORDERSTYLE_SLANTDASHDOT=13
    integer, parameter :: BORDERDIAGONAL_NONE=0,BORDERDIAGONAL_DOWN=1,BORDERDIAGONAL_UP=2,BORDERDIAGONAL_BOTH=3
    integer, parameter :: FILLPATTERN_NONE=0,FILLPATTERN_SOLID=1,FILLPATTERN_GRAY50=2,FILLPATTERN_GRAY75=3,FILLPATTERN_GRAY25=4,FILLPATTERN_HORSTRIPE=5,FILLPATTERN_VERSTRIPE=6,FILLPATTERN_REVDIAGSTRIPE=7,FILLPATTERN_DIAGSTRIPE=8,FILLPATTERN_DIAGCROSSHATCH=9,FILLPATTERN_THICKDIAGCROSSHATCH=10,FILLPATTERN_THINHORSTRIPE=11,FILLPATTERN_THINVERSTRIPE=12,FILLPATTERN_THINREVDIAGSTRIPE=13,FILLPATTERN_THINDIAGSTRIPE=14,FILLPATTERN_THINHORCROSSHATCH=15,FILLPATTERN_THINDIAGCROSSHATCH=16,FILLPATTERN_GRAY12P5=17,FILLPATTERN_GRAY6P25=18
    integer, parameter :: NUMFORMAT_GENERAL=0,NUMFORMAT_NUMBER=1,NUMFORMAT_NUMBER_D2=2,NUMFORMAT_NUMBER_SEP=3,NUMFORMAT_NUMBER_SEP_D2=4,NUMFORMAT_CURRENCY_NEGBRA=5,NUMFORMAT_CURRENCY_NEGBRARED=6,NUMFORMAT_CURRENCY_D2_NEGBRA=7,NUMFORMAT_CURRENCY_D2_NEGBRARED=8,NUMFORMAT_PERCENT=9,NUMFORMAT_PERCENT_D2=10,NUMFORMAT_SCIENTIFIC_D2=11,NUMFORMAT_FRACTION_ONEDIG=12,NUMFORMAT_FRACTION_TWODIG=13,NUMFORMAT_DATE=14,NUMFORMAT_CUSTOM_D_MON_YY=15,NUMFORMAT_CUSTOM_D_MON=16,NUMFORMAT_CUSTOM_MON_YY=17,NUMFORMAT_CUSTOM_HMM_AM=18,NUMFORMAT_CUSTOM_HMMSS_AM=19,NUMFORMAT_CUSTOM_HMM=20,NUMFORMAT_CUSTOM_HMMSS=21,NUMFORMAT_CUSTOM_MDYYYY_HMM=22,NUMFORMAT_NUMBER_SEP_NEGBRA=37,NUMFORMAT_NUMBER_SEP_NEGBRARED=38,NUMFORMAT_NUMBER_D2_SEP_NEGBRA=39,NUMFORMAT_NUMBER_D2_SEP_NEGBRARED=40,NUMFORMAT_ACCOUNT=41,NUMFORMAT_ACCOUNTCUR=42,NUMFORMAT_ACCOUNT_D2=43,NUMFORMAT_ACCOUNT_D2_CUR=44,NUMFORMAT_CUSTOM_MMSS=45,NUMFORMAT_CUSTOM_H0MMSS=46,NUMFORMAT_CUSTOM_MMSS0=47,NUMFORMAT_CUSTOM_000P0E_PLUS0=48,NUMFORMAT_TEXT=49
    integer, parameter :: COLOR_BLACK=8,COLOR_WHITE=9,COLOR_RED=10,COLOR_BRIGHTGREEN=11,COLOR_BLUE=12,COLOR_YELLOW=13,COLOR_PINK=14,COLOR_TURQUOISE=15,COLOR_DARKRED=16,COLOR_GREEN=17,COLOR_DARKBLUE=18,COLOR_DARKYELLOW=19,COLOR_VIOLET=20,COLOR_TEAL=21,COLOR_GRAY25=22,COLOR_GRAY50=23,COLOR_PERIWINKLE_CF=24,COLOR_PLUM_CF=25,COLOR_IVORY_CF=26,COLOR_LIGHTTURQUOISE_CF=27,COLOR_DARKPURPLE_CF=28,COLOR_CORAL_CF=29,COLOR_OCEANBLUE_CF=30,COLOR_ICEBLUE_CF=31,COLOR_DARKBLUE_CL=32,COLOR_PINK_CL=33,COLOR_YELLOW_CL=34,COLOR_TURQUOISE_CL=35,COLOR_VIOLET_CL=36,COLOR_DARKRED_CL=37,COLOR_TEAL_CL=38,COLOR_BLUE_CL=39,COLOR_SKYBLUE=40,COLOR_LIGHTTURQUOISE=41,COLOR_LIGHTGREEN=42,COLOR_LIGHTYELLOW=43,COLOR_PALEBLUE=44,COLOR_ROSE=45,COLOR_LAVENDER=46,COLOR_TAN=47,COLOR_LIGHTBLUE=48,COLOR_AQUA=49,COLOR_LIME=50,COLOR_GOLD=51,COLOR_LIGHTORANGE=52,COLOR_ORANGE=53,COLOR_BLUEGRAY=54,COLOR_GRAY40=55,COLOR_DARKTEAL=56,COLOR_SEAGREEN=57,COLOR_DARKGREEN=58,COLOR_OLIVEGREEN=59,COLOR_BROWN=60,COLOR_PLUM=61,COLOR_INDIGO=62,COLOR_GRAY80=63,COLOR_DEFAULT_FOREGROUND=64,COLOR_DEFAULT_BACKGROUND=65,COLOR_TOOLTIP=81,COLOR_AUTO=32767
    integer, parameter :: CELLTYPE_EMPTY=0,CELLTYPE_NUMBER=1,CELLTYPE_STRING=2,CELLTYPE_BOOLEAN=3,CELLTYPE_BLANK=4,CELLTYPE_ERROR=5
    integer, parameter :: ERRORTYPE_NULL=0,ERRORTYPE_DIV_0=7,ERRORTYPE_VALUE=15,ERRORTYPE_REF=23,ERRORTYPE_NAME=29,ERRORTYPE_NUM=36,ERRORTYPE_NA=42,ERRORTYPE_NOERROR=255
    integer, parameter :: PANETYPE_BOTRIGHT=0,PANETYPE_TOPRIGHT=1,PANETYPE_BOTTOMLEFT=2,PANETYPE_TOPLEFT=3
    integer, parameter :: PAPER_DEFAULT=0,PAPER_LETTER=1,PAPER_LETTERSMALL=2,PAPER_TABLOID=3,PAPER_LEDGER=4,PAPER_LEGAL=5,PAPER_STATEMENT=6,PAPER_EXECUTIVE=7,PAPER_A3=8,PAPER_A4=9,PAPER_A4SMALL=10,PAPER_A5=11,PAPER_B4=12,PAPER_B5=13,PAPER_FOLIO=14,PAPER_QUATRO=15,PAPER_10x14=16,PAPER_10x17=17,PAPER_NOTE=18,PAPER_ENVELOPE_9=19,PAPER_ENVELOPE_10=20,PAPER_ENVELOPE_11=21,PAPER_ENVELOPE_12=22,PAPER_ENVELOPE_14=23,PAPER_C_SIZE=24,PAPER_D_SIZE=25,PAPER_E_SIZE=26,PAPER_ENVELOPE_DL=27,PAPER_ENVELOPE_C5=28,PAPER_ENVELOPE_C3=29,PAPER_ENVELOPE_C4=30,PAPER_ENVELOPE_C6=31,PAPER_ENVELOPE_C65=32,PAPER_ENVELOPE_B4=33,PAPER_ENVELOPE_B5=34,PAPER_ENVELOPE_B6=35,PAPER_ENVELOPE=36,PAPER_ENVELOPE_MONARCH=37,PAPER_US_ENVELOPE=38,PAPER_FANFOLD=39,PAPER_GERMAN_STD_FANFOLD=40,PAPER_GERMAN_LEGAL_FANFOLD=41,PAPER_B4_ISO=42,PAPER_JAPANESE_POSTCARD=43,PAPER_9x11=44,PAPER_10x11=45,PAPER_15x11=46,PAPER_ENVELOPE_INVITE=47,PAPER_US_LETTER_EXTRA=50,PAPER_US_LEGAL_EXTRA=51,PAPER_US_TABLOID_EXTRA=52,PAPER_A4_EXTRA=53,PAPER_LETTER_TRANSVERSE=54,PAPER_A4_TRANSVERSE=55,PAPER_LETTER_EXTRA_TRANSVERSE=56,PAPER_SUPERA=57,PAPER_SUPERB=58,PAPER_US_LETTER_PLUS=59,PAPER_A4_PLUS=60,PAPER_A5_TRANSVERSE=61,PAPER_B5_TRANSVERSE=62,PAPER_A3_EXTRA=63,PAPER_A5_EXTRA=64,PAPER_B5_EXTRA=65,PAPER_A2=66,PAPER_A3_TRANSVERSE=67,PAPER_A3_EXTRA_TRANSVERSE=68,PAPER_JAPANESE_DOUBLE_POSTCARD=69,PAPER_A6=70,PAPER_JAPANESE_ENVELOPE_KAKU2=71,PAPER_JAPANESE_ENVELOPE_KAKU3=72,PAPER_JAPANESE_ENVELOPE_CHOU3=73,PAPER_JAPANESE_ENVELOPE_CHOU4=74,PAPER_LETTER_ROTATED=75,PAPER_A3_ROTATED=76,PAPER_A4_ROTATED=77,PAPER_A5_ROTATED=78,PAPER_B4_ROTATED=79,PAPER_B5_ROTATED=80,PAPER_JAPANESE_POSTCARD_ROTATED=81,PAPER_DOUBLE_JAPANESE_POSTCARD_ROTATED=82,PAPER_A6_ROTATED=83,PAPER_JAPANESE_ENVELOPE_KAKU2_ROTATED=84,PAPER_JAPANESE_ENVELOPE_KAKU3_ROTATED=85,PAPER_JAPANESE_ENVELOPE_CHOU3_ROTATED=86,PAPER_JAPANESE_ENVELOPE_CHOU4_ROTATED=87,PAPER_B6=88,PAPER_B6_ROTATED=89,PAPER_12x11=90,PAPER_JAPANESE_ENVELOPE_YOU4=91,PAPER_JAPANESE_ENVELOPE_YOU4_ROTATED=92,PAPER_PRC16K=93,PAPER_PRC32K=94,PAPER_PRC32K_BIG=95,PAPER_PRC_ENVELOPE1=96,PAPER_PRC_ENVELOPE2=97,PAPER_PRC_ENVELOPE3=98,PAPER_PRC_ENVELOPE4=99,PAPER_PRC_ENVELOPE5=100,PAPER_PRC_ENVELOPE6=101,PAPER_PRC_ENVELOPE7=102,PAPER_PRC_ENVELOPE8=103,PAPER_PRC_ENVELOPE9=104,PAPER_PRC_ENVELOPE10=105,PAPER_PRC16K_ROTATED=106,PAPER_PRC32K_ROTATED=107,PAPER_PRC32KBIG_ROTATED=108,PAPER_PRC_ENVELOPE1_ROTATED=109,PAPER_PRC_ENVELOPE2_ROTATED=110,PAPER_PRC_ENVELOPE3_ROTATED=111,PAPER_PRC_ENVELOPE4_ROTATED=112,PAPER_PRC_ENVELOPE5_ROTATED=113,PAPER_PRC_ENVELOPE6_ROTATED=114,PAPER_PRC_ENVELOPE7_ROTATED=115,PAPER_PRC_ENVELOPE8_ROTATED=116,PAPER_PRC_ENVELOPE9_ROTATED=117,PAPER_PRC_ENVELOPE10_ROTATED=118
    integer, parameter :: UNDERLINE_NONE=0,UNDERLINE_SINGLE=1,UNDERLINE_DOUBLE=2,UNDERLINE_SINGLEACC=33,UNDERLINE_DOUBLEACC=34
    integer, parameter :: SCRIPT_NORMAL=0,SCRIPT_SUPER=1,SCRIPT_SUB=2
    
    INTERFACE
    
        TYPE(C_PTR) FUNCTION xlCreateBook() BIND(C, NAME='xlCreateBookCA')
        USE, INTRINSIC :: ISO_C_BINDING
        END FUNCTION
        
        TYPE(C_PTR) FUNCTION xlCreateXMLBook() BIND(C, NAME='xlCreateXMLBookCA')                
        USE, INTRINSIC :: ISO_C_BINDING
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlBookLoad(handle, filename) BIND(C, NAME='xlBookLoadA')                
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle 
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: filename
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlBookSave(handle, filename) BIND(C, NAME='xlBookSaveA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: filename
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlBookLoadRaw(handle, buf, size) BIND(C, NAME='xlBookLoadRawA') 
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        TYPE(C_PTR), INTENT(IN), value :: buf
        INTEGER(C_SIZE_T) size
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlBookSaveRaw(handle, buf, size) BIND(C,NAME='xlBookSaveRawA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        TYPE(C_PTR), INTENT(OUT) :: buf
        INTEGER(C_SIZE_T) size                
        END FUNCTION

        TYPE(C_PTR) FUNCTION xlBookAddSheet(handle, name, initSheet) BIND(C, NAME='xlBookAddSheetA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: name        
        TYPE(C_PTR), VALUE :: initSheet
        END FUNCTION
        
        TYPE(C_PTR) FUNCTION xlBookGetSheet(handle, index) BIND(C, NAME='xlBookGetSheetA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        integer(C_INT), VALUE :: index 
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlBookDelSheet(handle, index) BIND(C, NAME='xlBookDelSheetA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        integer(C_INT) index 
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlBookSheetCount(handle) BIND(C, NAME='xlBookSheetCountA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle
        END FUNCTION

        TYPE(C_PTR) FUNCTION xlBookAddFormat(handle, initFormat) BIND(C, NAME='xlBookAddFormatA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle
        TYPE(C_PTR), VALUE :: initFormat
        END FUNCTION

        TYPE(C_PTR) FUNCTION xlBookAddFont(handle, initFont) BIND(C, NAME='xlBookAddFontA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle
        TYPE(C_PTR), VALUE :: initFont
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlBookAddCustomNumFormat(handle, customNumFormat) BIND(C, NAME='xlBookAddCustomNumFormatA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: customNumFormat        
        END FUNCTION

        TYPE(C_PTR) FUNCTION xlBookCustomNumFormatPtr(handle, fmt) BIND(C, NAME='xlBookCustomNumFormatA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: fmt 
        END FUNCTION
        
        TYPE(C_PTR) FUNCTION xlBookFormat(handle, index) BIND(C, NAME='xlBookFormatA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: index 
        END FUNCTION
        
        INTEGER(C_INT) FUNCTION xlBookFormatSize(handle) BIND(C, NAME='xlBookFormatSizeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle        
        END FUNCTION
        
        TYPE(C_PTR) FUNCTION xlBookFont(handle, index) BIND(C, NAME='xlBookFontA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: index 
        END FUNCTION
        
        INTEGER(C_INT) FUNCTION xlBookFontSize(handle) BIND(C, NAME='xlBookFontSizeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle        
        END FUNCTION
                              
        REAL(C_DOUBLE) FUNCTION xlBookDatePack(handle, year, month, day, hour, min, sec, msec) BIND(C, NAME='xlBookDatePackA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: year
        INTEGER(C_INT), VALUE :: month
        INTEGER(C_INT), VALUE :: day
        INTEGER(C_INT), VALUE :: hour
        INTEGER(C_INT), VALUE :: min
        INTEGER(C_INT), VALUE :: sec
        INTEGER(C_INT), VALUE :: msec
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlBookDateUnpack(handle, val, year, month, day, hour, min, sec, msec) BIND(C, NAME='xlBookDateUnpackA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        REAL(C_DOUBLE), VALUE :: val
        INTEGER(C_INT) :: year
        INTEGER(C_INT) :: month
        INTEGER(C_INT) :: day
        INTEGER(C_INT) :: hour
        INTEGER(C_INT) :: min
        INTEGER(C_INT) :: sec
        INTEGER(C_INT) :: msec
        END FUNCTION
        
        INTEGER(C_INT) FUNCTION xlBookColorPack(handle, red, green, blue) BIND(C, NAME='xlBookColorPackA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: red
        INTEGER(C_INT), VALUE :: green
        INTEGER(C_INT), VALUE :: blue        
        END FUNCTION
        
        SUBROUTINE xlBookColorUnpack(handle, color, red, green, blue) BIND(C, NAME='xlBookColorUnpackA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: color
        INTEGER(C_INT) :: red
        INTEGER(C_INT) :: green
        INTEGER(C_INT) :: blue        
        END SUBROUTINE
                            
        INTEGER(C_INT) FUNCTION xlBookActiveSheet(handle) BIND(C, NAME='xlBookActiveSheetA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle
        END FUNCTION

        SUBROUTINE xlBookSetActiveSheet(handle, index) BIND(C, NAME='xlBookSetActiveSheetA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: index 
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlBookAddPicture(handle, filename) BIND(C, NAME='xlBookAddPictureA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: filename        
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlBookAddPicture2(handle, buf, size) BIND(C, NAME='xlBookAddPicture2A')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        TYPE(C_PTR), INTENT(IN), value :: buf
        INTEGER(C_SIZE_T) size
        END FUNCTION

        TYPE(C_PTR) FUNCTION xlBookDefaultFontPtr(handle, fontSize) BIND(C, NAME='xlBookDefaultFontA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT) :: fontSize 
        END FUNCTION

        SUBROUTINE xlBookSetDefaultFont(handle, fontName, fontSize) BIND(C, NAME='xlBookSetDefaultFontA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: fontName
        INTEGER(C_INT), VALUE :: fontSize
        END SUBROUTINE

        SUBROUTINE xlBookSetKey(handle, name, key) BIND(C, NAME='xlBookSetKeyA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: name
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: key        
        END SUBROUTINE
        
        INTEGER(C_INT) FUNCTION xlBookRgbMode(handle) BIND(C, NAME='xlBookRgbModeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle        
        END FUNCTION
    
        SUBROUTINE xlBookSetRgbMode(handle, rgbMode) BIND(C, NAME='xlBookSetRgbModeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        INTEGER(C_INT), VALUE :: rgbMode
        END SUBROUTINE
                             
        SUBROUTINE xlBookSetLocale(handle, locale) BIND(C, NAME='xlBookSetLocaleA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: locale              
        END SUBROUTINE

        TYPE(C_PTR) FUNCTION xlBookErrorMessagePtr(handle) BIND(C, NAME='xlBookErrorMessageA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle        
        END FUNCTION

        SUBROUTINE xlBookRelease(handle) BIND(C, NAME='xlBookReleaseA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle        
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetCellType(handle, row, col) BIND(C, NAME='xlSheetCellTypeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        END FUNCTION
        
        INTEGER(C_INT) FUNCTION xlSheetIsFormula(handle, row, col) BIND(C, NAME='xlSheetIsFormulaA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        END FUNCTION

        TYPE(C_PTR) FUNCTION xlSheetCellFormat(handle, row, col) BIND(C, NAME='xlSheetCellFormatA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        END FUNCTION
        
        SUBROUTINE xlSheetSetCellFormat(handle, row, col, f) BIND(C, NAME='xlSheetSetCellFormatA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        TYPE(C_PTR), VALUE :: f
        END SUBROUTINE
              
        TYPE(C_PTR) FUNCTION xlSheetReadStrPtr(handle, row, col, f) BIND(C, NAME='xlSheetReadStrA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        TYPE(C_PTR) :: f
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetWriteStr(handle, row, col, str, f) BIND(C, NAME='xlSheetWriteStrA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: str
        TYPE(C_PTR), VALUE :: f
        END FUNCTION

        REAL(C_DOUBLE) FUNCTION xlSheetReadNum(handle, row, col, f) BIND(C, NAME='xlSheetReadNumA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        TYPE(C_PTR) :: f
        END FUNCTION
            
        INTEGER(C_INT) FUNCTION xlSheetWriteNum(handle, row, col, num, f) BIND(C, NAME='xlSheetWriteNumA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        REAL(C_DOUBLE), VALUE :: num
        TYPE(C_PTR), VALUE :: f
        END FUNCTION
    
        INTEGER(C_INT) FUNCTION xlSheetReadBool(handle, row, col, f) BIND(C, NAME='xlSheetReadBoolA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        TYPE(C_PTR) :: f
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetWriteBool(handle, row, col, b, f) BIND(C, NAME='xlSheetWriteBoolA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        INTEGER(C_INT), VALUE :: b
        TYPE(C_PTR), VALUE :: f
        END FUNCTION
    
        INTEGER(C_INT) FUNCTION xlSheetReadBlank(handle, row, col, f) BIND(C, NAME='xlSheetReadBlankA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        TYPE(C_PTR) :: f
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetWriteBlank(handle, row, col, f) BIND(C, NAME='xlSheetWriteBlankA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        TYPE(C_PTR), VALUE :: f
        END FUNCTION

        TYPE(C_PTR) FUNCTION xlSheetReadFormulaPtr(handle, row, col, f) BIND(C, NAME='xlSheetReadFormulaA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        TYPE(C_PTR) :: f
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetWriteFormula(handle, row, col, formula, f) BIND(C, NAME='xlSheetWriteFormulaA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: formula
        TYPE(C_PTR), VALUE :: f
        END FUNCTION

        TYPE(C_PTR) FUNCTION xlSheetReadCommentPtr(handle, row, col) BIND(C, NAME='xlSheetReadCommentA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col        
        END FUNCTION

        SUBROUTINE xlSheetWriteComment(handle, row, col, comment, author, width, height) BIND(C, NAME='xlSheetWriteCommentA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: comment
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: author
        INTEGER(C_INT), VALUE :: width
        INTEGER(C_INT), VALUE :: height
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetIsDate(handle, row, col) BIND(C, NAME='xlSheetIsDateA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col        
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetReadError(handle, row, col) BIND(C, NAME='xlSheetReadErrorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col        
        END FUNCTION

        REAL(C_DOUBLE) FUNCTION xlSheetColWidth(handle, col) BIND(C, NAME='xlSheetColWidthA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle        
        INTEGER(C_INT), VALUE :: col        
        END FUNCTION

        REAL(C_DOUBLE) FUNCTION xlSheetRowHeight(handle, row) BIND(C, NAME='xlSheetRowHeightA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle        
        INTEGER(C_INT), VALUE :: row        
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetSetCol(handle, colFirst, colLast, width, f, hidden) BIND(C, NAME='xlSheetSetColA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: colFirst
        INTEGER(C_INT), VALUE :: colLast
        REAL(C_DOUBLE), VALUE :: width
        TYPE(C_PTR), VALUE :: f
        INTEGER(C_INT), VALUE :: hidden
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetSetRow(handle, row, height, f, hidden) BIND(C, NAME='xlSheetSetRowA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row        
        REAL(C_DOUBLE), VALUE :: height
        TYPE(C_PTR), VALUE :: f
        INTEGER(C_INT), VALUE :: hidden
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetGetMerge(handle, row, col, rowFirst, rowLast, colFirst, colLast) BIND(C, NAME='xlSheetGetMergeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        INTEGER(C_INT) :: rowFirst
        INTEGER(C_INT) :: rowLast
        INTEGER(C_INT) :: colFirst
        INTEGER(C_INT) :: colLast
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetSetMerge(handle, rowFirst, rowLast, colFirst, colLast) BIND(C, NAME='xlSheetSetMergeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle         
        INTEGER(C_INT), VALUE :: rowFirst
        INTEGER(C_INT), VALUE :: rowLast
        INTEGER(C_INT), VALUE :: colFirst
        INTEGER(C_INT), VALUE :: colLast
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetDelMerge(handle, row, col) BIND(C, NAME='xlSheetDelMergeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col        
        END FUNCTION

        SUBROUTINE xlSheetSetPicture(handle, row, col, pictureId, scale, offset_x, offset_y, pos) BIND(C, NAME='xlSheetSetPictureA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        INTEGER(C_INT), VALUE :: pictureId
        REAL(C_DOUBLE), VALUE :: scale
        INTEGER(C_INT), VALUE :: offset_x
        INTEGER(C_INT), VALUE :: offset_y
        INTEGER(C_INT), VALUE :: pos
        END SUBROUTINE

        SUBROUTINE xlSheetSetPicture2(handle, row, col, pictureId, width, height, offset_x, offset_y, pos) BIND(C, NAME='xlSheetSetPicture2A')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col
        INTEGER(C_INT), VALUE :: pictureId
        INTEGER(C_INT), VALUE :: width
        INTEGER(C_INT), VALUE :: height
        INTEGER(C_INT), VALUE :: offset_x
        INTEGER(C_INT), VALUE :: offset_y
        INTEGER(C_INT), VALUE :: pos
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetSetHorPageBreak(handle, row, pageBreak) BIND(C, NAME='xlSheetSetHorPageBreakA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: pageBreak        
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetSetVerPageBreak(handle, col, pageBreak) BIND(C, NAME='xlSheetSetVerPageBreakA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: col
        INTEGER(C_INT), VALUE :: pageBreak        
        END FUNCTION

        SUBROUTINE xlSheetSplit(handle, row, col) BIND(C, NAME='xlSheetSplitA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row
        INTEGER(C_INT), VALUE :: col        
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetGroupRows(handle, rowFirst, rowLast, collapsed) BIND(C, NAME='xlSheetGroupRowsA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: rowFirst
        INTEGER(C_INT), VALUE :: rowLast        
        INTEGER(C_INT), VALUE :: collapsed
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetGroupCols(handle, colFirst, colLast, collapsed) BIND(C, NAME='xlSheetGroupColsA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: colFirst
        INTEGER(C_INT), VALUE :: colLast        
        INTEGER(C_INT), VALUE :: collapsed
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetClear(handle, rowFirst, rowLast, colFirst, colLast) BIND(C, NAME='xlSheetClearA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: rowFirst
        INTEGER(C_INT), VALUE :: rowLast        
        INTEGER(C_INT), VALUE :: colFirst
        INTEGER(C_INT), VALUE :: colLast
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetInsertRow(handle, rowFirst, rowLast) BIND(C, NAME='xlSheetInsertRowA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: rowFirst
        INTEGER(C_INT), VALUE :: rowLast               
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetInsertCol(handle, colFirst, colLast) BIND(C, NAME='xlSheetInsertColA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: colFirst
        INTEGER(C_INT), VALUE :: colLast               
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetRemoveRow(handle, rowFirst, rowLast) BIND(C, NAME='xlSheetRemoveRowA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: rowFirst
        INTEGER(C_INT), VALUE :: rowLast               
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetRemoveCol(handle, colFirst, colLast) BIND(C, NAME='xlSheetRemoveColA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: colFirst
        INTEGER(C_INT), VALUE :: colLast               
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetCopyCell(handle, rowSrc, colSrc, rowDst, colDst) BIND(C, NAME='xlSheetCopyCellA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: rowSrc
        INTEGER(C_INT), VALUE :: colSrc
        INTEGER(C_INT), VALUE :: rowDst
        INTEGER(C_INT), VALUE :: colDst   
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetFirstRow(handle) BIND(C, NAME='xlSheetFirstRowA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetLastRow(handle) BIND(C, NAME='xlSheetLastRowA')
         USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetFirstCol(handle) BIND(C, NAME='xlSheetFirstColA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetLastCol(handle) BIND(C, NAME='xlSheetLastColA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetDisplayGridlines(handle) BIND(C, NAME='xlSheetDisplayGridlinesA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetDisplayGridlines(handle, show) BIND(C, NAME='xlSheetSetDisplayGridlinesA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle 
        INTEGER(C_INT), VALUE :: show
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetPrintGridlines(handle) BIND(C, NAME='xlSheetPrintGridlinesA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetPrintGridlines(handle, printGridlines) BIND(C, NAME='xlSheetSetPrintGridlinesA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        INTEGER(C_INT), VALUE :: printGridlines
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetZoom(handle) BIND(C, NAME='xlSheetZoomA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetZoom(handle, zoom) BIND(C, NAME='xlSheetSetZoomA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        INTEGER(C_INT), VALUE :: zoom
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetPrintZoom(handle) BIND(C, NAME='xlSheetPrintZoomA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetPrintZoom(handle, zoom) BIND(C, NAME='xlSheetSetPrintZoomA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        INTEGER(C_INT), VALUE :: zoom
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetLandscape(handle) BIND(C, NAME='xlSheetLandscapeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetLandscape(handle, landscape) BIND(C, NAME='xlSheetSetLandscapeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        INTEGER(C_INT), VALUE :: landscape
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetPaper(handle) BIND(C, NAME='xlSheetPaperA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetPaper(handle, paper) BIND(C, NAME='xlSheetSetPaperA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        INTEGER(C_INT), VALUE :: paper
        END SUBROUTINE

        TYPE(C_PTR) FUNCTION xlSheetHeaderPtr(handle) BIND(C, NAME='xlSheetHeaderA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetSetHeader(handle, header, margin) BIND(C, NAME='xlSheetSetHeaderA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle         
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: header
        REAL(C_DOUBLE), VALUE :: margin
        END FUNCTION

        REAL(C_DOUBLE) FUNCTION xlSheetHeaderMargin(handle) BIND(C, NAME='xlSheetHeaderMarginA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        TYPE(C_PTR) FUNCTION xlSheetFooterPtr(handle) BIND(C, NAME='xlSheetFooterA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetSetFooter(handle, footer, margin) BIND(C, NAME='xlSheetSetFooterA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle         
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: footer
        REAL(C_DOUBLE), VALUE :: margin
        END FUNCTION

        REAL(C_DOUBLE) FUNCTION xlSheetFooterMargin(handle) BIND(C, NAME='xlSheetFooterMarginA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlSheetHCenter(handle) BIND(C, NAME='xlSheetHCenterA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetHCenter(handle, hCenter) BIND(C, NAME='xlSheetSetHCenterA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: hCenter
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetVCenter(handle) BIND(C, NAME='xlSheetVCenterA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetVCenter(handle, vCenter) BIND(C, NAME='xlSheetSetVCenterA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: vCenter
        END SUBROUTINE

        REAL(C_DOUBLE) FUNCTION xlSheetMarginLeft(handle) BIND(C, NAME='xlSheetMarginLeftA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetMarginLeft(handle, margin) BIND(C, NAME='xlSheetSetMarginLeftA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        REAL(C_DOUBLE), VALUE :: margin
        END SUBROUTINE

        REAL(C_DOUBLE) FUNCTION xlSheetMarginRight(handle) BIND(C, NAME='xlSheetMarginRightA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetMarginRight(handle, margin) BIND(C, NAME='xlSheetSetMarginRightA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        REAL(C_DOUBLE), VALUE :: margin
        END SUBROUTINE

        REAL(C_DOUBLE) FUNCTION xlSheetMarginTop(handle) BIND(C, NAME='xlSheetMarginTopA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetMarginTop(handle, margin) BIND(C, NAME='xlSheetSetMarginTopA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        REAL(C_DOUBLE), VALUE :: margin
        END SUBROUTINE

        REAL(C_DOUBLE) FUNCTION xlSheetMarginBottom(handle) BIND(C, NAME='xlSheetMarginBottomA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetMarginBottom(handle, margin) BIND(C, NAME='xlSheetSetMarginBottomA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        REAL(C_DOUBLE), VALUE :: margin
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetPrintRowCol(handle) BIND(C, NAME='xlSheetPrintRowColA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetPrintRowCol(handle, printRowCol) BIND(C, NAME='xlSheetSetPrintRowColA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: printRowCol
        END SUBROUTINE

        TYPE(C_PTR) FUNCTION xlSheetNamePtr(handle) BIND(C, NAME='xlSheetNameA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetName(handle, name) BIND(C, NAME='xlSheetSetNameA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: name     
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlSheetProtect(handle) BIND(C, NAME='xlSheetProtectA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlSheetSetProtect(handle, protect) BIND(C, NAME='xlSheetSetProtectA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: protect
        END SUBROUTINE

        TYPE(C_PTR) FUNCTION xlFormatFont(handle) BIND(C, NAME='xlFormatFontA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlFormatSetFont(handle, font) BIND(C, NAME='xlFormatSetFontA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle
        TYPE(C_PTR), VALUE :: font
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlFormatNumFormat(handle) BIND(C, NAME='xlFormatNumFormatA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetNumFormat(handle, numFormat) BIND(C, NAME='xlFormatSetNumFormatA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: numFormat
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatAlignH(handle) BIND(C, NAME='xlFormatAlignHA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetAlignH(handle, alignH) BIND(C, NAME='xlFormatSetAlignHA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: alignH
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatAlignV(handle) BIND(C, NAME='xlFormatAlignVA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetAlignV(handle, alignV) BIND(C, NAME='xlFormatSetAlignVA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: alignV
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatWrap(handle) BIND(C, NAME='xlFormatWrapA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetWrap(handle, wrap) BIND(C, NAME='xlFormatSetWrapA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: wrap
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatRotation(handle) BIND(C, NAME='xlFormatRotationA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlFormatSetRotation(handle, rotation) BIND(C, NAME='xlFormatSetRotationA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: rotation
        END FUNCTION

        INTEGER(C_INT) FUNCTION xlFormatIndent(handle) BIND(C, NAME='xlFormatIndentA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetIndent(handle, indent) BIND(C, NAME='xlFormatSetIndentA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: indent
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatShrinkToFit(handle) BIND(C, NAME='xlFormatShrinkToFitA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetShrinkToFit(handle, shrinkToFit) BIND(C, NAME='xlFormatSetShrinkToFitA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: shrinkToFit
        END SUBROUTINE

        SUBROUTINE xlFormatSetBorder(handle, style) BIND(C, NAME='xlFormatSetBorderA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: style
        END SUBROUTINE

        SUBROUTINE xlFormatSetBorderColor(handle, color) BIND(C, NAME='xlFormatSetBorderColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: color
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatBorderLeft(handle) BIND(C, NAME='xlFormatBorderLeftA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetBorderLeft(handle, style) BIND(C, NAME='xlFormatSetBorderLeftA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: style
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatBorderRight(handle) BIND(C, NAME='xlFormatBorderRightA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetBorderRight(handle, style) BIND(C, NAME='xlFormatSetBorderRightA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: style
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatBorderTop(handle) BIND(C, NAME='xlFormatBorderTopA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetBorderTop(handle, style) BIND(C, NAME='xlFormatSetBorderTopA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: style
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatBorderBottom(handle) BIND(C, NAME='xlFormatBorderBottomA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetBorderBottom(handle, style) BIND(C, NAME='xlFormatSetBorderBottomA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: style
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatBorderLeftColor(handle) BIND(C, NAME='xlFormatBorderLeftColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetBorderLeftColor(handle, color) BIND(C, NAME='xlFormatSetBorderLeftColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: color
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatBorderRightColor(handle) BIND(C, NAME='xlFormatBorderRightColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetBorderRightColor(handle, color) BIND(C, NAME='xlFormatSetBorderRightColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: color
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatBorderTopColor(handle) BIND(C, NAME='xlFormatBorderTopColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetBorderTopColor(handle, color) BIND(C, NAME='xlFormatSetBorderTopColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: color
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatBorderBottomColor(handle) BIND(C, NAME='xlFormatBorderBottomColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetBorderBottomColor(handle, color) BIND(C, NAME='xlFormatSetBorderBottomColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: color
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatBorderDiagonal(handle) BIND(C, NAME='xlFormatBorderDiagonalA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetBorderDiagonal(handle, border) BIND(C, NAME='xlFormatSetBorderDiagonalA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: border
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatBorderDiagonalColor(handle) BIND(C, NAME='xlFormatBorderDiagonalColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetBorderDiagonalColor(handle, color) BIND(C, NAME='xlFormatSetBorderDiagonalColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: color
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatFillPattern(handle) BIND(C, NAME='xlFormatFillPatternA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetFillPattern(handle, pattern) BIND(C, NAME='xlFormatSetFillPatternA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: pattern
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatPatternForegroundColor(handle) BIND(C, NAME='xlFormatPatternForegroundColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetPatternForegroundColor(handle, color) BIND(C, NAME='xlFormatSetPatternForegroundColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: color
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatPatternBackgroundColor(handle) BIND(C, NAME='xlFormatPatternBackgroundColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetPatternBackgroundColor(handle, color) BIND(C, NAME='xlFormatSetPatternBackgroundColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: color
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatLocked(handle) BIND(C, NAME='xlFormatLockedA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetLocked(handle, locked) BIND(C, NAME='xlFormatSetLockedA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: locked
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFormatHidden(handle) BIND(C, NAME='xlFormatHiddenA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFormatSetHidden(handle, hidden) BIND(C, NAME='xlFormatSetHiddenA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: hidden
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFontSize(handle) BIND(C, NAME='xlFontSizeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFontSetSize(handle, size) BIND(C, NAME='xlFontSetSizeA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: size
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFontItalic(handle) BIND(C, NAME='xlFontItalicA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFontSetItalic(handle, italic) BIND(C, NAME='xlFontSetItalicA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: italic
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFontStrikeOut(handle) BIND(C, NAME='xlFontStrikeOutA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFontSetStrikeOut(handle, strikeOut) BIND(C, NAME='xlFontSetStrikeOutA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: strikeOut
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFontColor(handle) BIND(C, NAME='xlFontColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFontSetColor(handle, color) BIND(C, NAME='xlFontSetColorA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: color
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFontBold(handle) BIND(C, NAME='xlFontBoldA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFontSetBold(handle, bold) BIND(C, NAME='xlFontSetBoldA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: bold
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFontScript(handle) BIND(C, NAME='xlFontScriptA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFontSetScript(handle, script) BIND(C, NAME='xlFontSetScriptA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: script
        END SUBROUTINE

        INTEGER(C_INT) FUNCTION xlFontUnderline(handle) BIND(C, NAME='xlFontUnderlineA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFontSetUnderline(handle, underline) BIND(C, NAME='xlFontSetUnderlineA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle    
        INTEGER(C_INT), VALUE :: underline
        END SUBROUTINE

        TYPE(C_PTR) FUNCTION xlFontNamePtr(handle) BIND(C, NAME='xlFontNameA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle          
        END FUNCTION

        SUBROUTINE xlFontSetName(handle, name) BIND(C, NAME='xlFontSetNameA')
        USE, INTRINSIC :: ISO_C_BINDING
        TYPE(C_PTR), VALUE :: handle         
        CHARACTER(KIND=C_CHAR), DIMENSION(*) :: name        
        END SUBROUTINE

    END INTERFACE
    
    CONTAINS
    
    !
    ! thank you to haraldkl, Mike Sadler and Pap from https://stackoverflow.com/questions/9972743/creating-a-fortran-interface-to-a-c-function-that-returns-a-char
    !
    FUNCTION C_to_F_string(c_string_pointer) RESULT(f_string)
        USE, INTRINSIC :: ISO_C_BINDING, ONLY: C_PTR, C_F_POINTER, C_CHAR, C_NULL_CHAR
        type(C_PTR), INTENT(IN) :: c_string_pointer
        CHARACTER(LEN=:), ALLOCATABLE :: f_string
        CHARACTER(KIND=C_CHAR), DIMENSION(:), POINTER :: char_array_pointer => NULL()
        CHARACTER(LEN=255) :: aux_string
        INTEGER :: i, length    
        CALL C_F_POINTER(c_string_pointer, char_array_pointer, [255])
        IF (.NOT.ASSOCIATED(char_array_pointer)) THEN
            ALLOCATE(CHARACTER(LEN=4)::f_string); f_string="NULL"; return
        END IF
        aux_string=" "
        DO i=1,255
            IF (char_array_pointer(i)==c_null_char) THEN
                length=i-1; EXIT
            END IF
            aux_string(i:i)=char_array_pointer(i)
        END DO
        ALLOCATE(CHARACTER(LEN=length)::f_string)
        f_string=aux_string(1:length)
    END FUNCTION C_to_F_string
        
    FUNCTION xlBookCustomNumFormat(handle, fmt) RESULT(f_string)
        USE ISO_C_BINDING 
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: fmt   
        CHARACTER(:), ALLOCATABLE :: f_string
        f_string = C_to_F_string(xlBookCustomNumFormatPtr(handle, fmt))                   
    END FUNCTION
        
    FUNCTION xlBookDefaultFont(handle, fontSize) RESULT(f_string)
        USE ISO_C_BINDING 
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT) :: fontSize    
        CHARACTER(:), ALLOCATABLE :: f_string
        f_string = C_to_F_string(xlBookDefaultFontPtr(handle, fontSize))                   
    END FUNCTION
    
    FUNCTION xlBookErrorMessage(handle) RESULT(f_string)
        USE ISO_C_BINDING 
        TYPE(C_PTR), VALUE :: handle
        CHARACTER(:), ALLOCATABLE :: f_string
        f_string = C_to_F_string(xlBookErrorMessagePtr(handle)) 
    END FUNCTION
        
    FUNCTION xlSheetReadStr(handle, row, col, f) RESULT(f_string)
        USE ISO_C_BINDING 
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row    
        INTEGER(C_INT), VALUE :: col
        TYPE(C_PTR), VALUE :: f
        CHARACTER(:), ALLOCATABLE :: f_string
        f_string = C_to_F_string(xlSheetReadStrPtr(handle, row, col, f))                   
    END FUNCTION
    
    FUNCTION xlSheetReadFormula(handle, row, col, f) RESULT(f_string)
        USE ISO_C_BINDING 
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row    
        INTEGER(C_INT), VALUE :: col
        TYPE(C_PTR) :: f
        CHARACTER(:), ALLOCATABLE :: f_string
        f_string = C_to_F_string(xlSheetReadFormulaPtr(handle, row, col, f))                   
    END FUNCTION
    
    FUNCTION xlSheetReadComment(handle, row, col) RESULT(f_string)
        USE ISO_C_BINDING 
        TYPE(C_PTR), VALUE :: handle  
        INTEGER(C_INT), VALUE :: row    
        INTEGER(C_INT), VALUE :: col        
        CHARACTER(:), ALLOCATABLE :: f_string
        f_string = C_to_F_string(xlSheetReadCommentPtr(handle, row, col))                   
    END FUNCTION
    
    FUNCTION xlSheetHeader(handle) RESULT(f_string)
        USE ISO_C_BINDING 
        TYPE(C_PTR), VALUE :: handle          
        CHARACTER(:), ALLOCATABLE :: f_string
        f_string = C_to_F_string(xlSheetHeaderPtr(handle))    
    END FUNCTION
    
    FUNCTION xlSheetFooter(handle) RESULT(f_string)
        USE ISO_C_BINDING 
        TYPE(C_PTR), VALUE :: handle          
        CHARACTER(:), ALLOCATABLE :: f_string
        f_string = C_to_F_string(xlSheetFooterPtr(handle))    
    END FUNCTION
    
    FUNCTION xlSheetName(handle) RESULT(f_string)
        USE ISO_C_BINDING 
        TYPE(C_PTR), VALUE :: handle          
        CHARACTER(:), ALLOCATABLE :: f_string
        f_string = C_to_F_string(xlSheetNamePtr(handle))    
    END FUNCTION
    
    FUNCTION xlFontName(handle) RESULT(f_string)
        USE ISO_C_BINDING 
        TYPE(C_PTR), VALUE :: handle          
        CHARACTER(:), ALLOCATABLE :: f_string
        f_string = C_to_F_string(xlFontNamePtr(handle))    
    END FUNCTION
                        
END MODULE
