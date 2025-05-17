///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                    LibXL Delphi unit version 4.1.2                        //
//                                                                           //
//       Copyright (c) 2008 - 2023 Dmytro Skrypnyk and XLware s.r.o.         //
//                         All rights reserved.                              //
//                                                                           //
// This file forms part of LibXL product. It may not be used independenty.   //
// See the LibXL licence agreement for further restrictions.                 //
//                                                                           //
// THIS FILE AND THE SOFTWARE CONTAINED HEREIN IS PROVIDED 'AS IS' AND       //
// COMES WITH NO WARRANTIES OF ANY KIND.                                     //
//                                                                           //
// XLWARE SHALL NOT BE LIABLE FOR ANY DAMAGES SUFFERED BY ANYONE             //
// OR ANYTHING DUE TO THE USE OF THIS FILE HOWEVER THEY MAY BE CAUSED.       //
//                                                                           //
// For more information on the LibXL, go to: http://www.libxl.com            //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

unit LibXL;

{$Z4}

interface

uses SysUtils;

type
  AlignH = (ALIGNH_GENERAL, ALIGNH_LEFT, ALIGNH_CENTER, ALIGNH_RIGHT, ALIGNH_FILL, ALIGNH_JUSTIFY,
            ALIGNH_MERGE, ALIGNH_DISTRIBUTED);
type
  AlignV = (ALIGNV_TOP, ALIGNV_CENTER, ALIGNV_BOTTOM, ALIGNV_JUSTIFY, ALIGNV_DISTRIBUTED);

type
  BorderStyle = (BORDERSTYLE_NONE, BORDERSTYLE_THIN, BORDERSTYLE_MEDIUM, BORDERSTYLE_DASHED,
                 BORDERSTYLE_DOTTED, BORDERSTYLE_THICK, BORDERSTYLE_DOUBLE, BORDERSTYLE_HAIR,
                 BORDERSTYLE_MEDIUMDASHED, BORDERSTYLE_DASHDOT, BORDERSTYLE_MEDIUMDASHDOT,
                 BORDERSTYLE_DASHDOTDOT, BORDERSTYLE_MEDIUMDASHDOTDOT, BORDERSTYLE_SLANTDASHDOT);
type
  BorderDiagonal = (BORDERDIAGONAL_NONE, BORDERDIAGONAL_DOWN, BORDERDIAGONAL_UP,
                    BORDERDIAGONAL_BOTH);
type
  FillPattern = (FILLPATTERN_NONE, FILLPATTERN_SOLID, FILLPATTERN_GRAY50, FILLPATTERN_GRAY75,
                 FILLPATTERN_GRAY25, FILLPATTEN_HORSTRIPE, FILLPATTERN_VERSTRIPE,
                 FILLPATTERN_REVDIAGSTRIPE, FILLPATTERN_DIAGSTRIPE, FILLPATTERN_DIAGCROSSHATCH,
                 FILLPATTERN_THICKDIAGCROSSHATCH, FILLPATTERN_THINHORSTRIPE,
                 FILLPATTERN_THINVERSTRIPE, FILLPATTERN_THINREVDIAGSTRIPE,
                 FILLPATTERN_THINDIAGSTRIPE, FILLPATTERN_THINHORCROSSHATCH,
                 FILLPATTERN_THINDIAGCROSSHATCH, FILLPATTERN_GRAY12P5, FILLPATTERN_GRAY6P25);
type
  NumFormat = (NUMFORMAT_GENERAL, NUMFORMAT_NUMBER, NUMFORMAT_NUMBER_D2, NUMFORMAT_NUMBER_SEP,
               NUMFORMAT_NUMBER_SEP_D2, NUMFORMAT_CURRENCY_NEGBRA, NUMFORMAT_CURRENCY_NEGBRARED,
               NUMFORMAT_CURRENCY_D2_NEGBRA, NUMFORMAT_CURRENCY_D2_NEGBRARED, NUMFORMAT_PERCENT,
               NUMFORMAT_PERCENT_D2, NUMFORMAT_SCIENTIFIC_D2, NUMFORMAT_FRACTION_ONEDIG,
               NUMFORMAT_FRACTION_TWODIG, NUMFORMAT_DATE, NUMFORMAT_CUSTOM_D_MON_YY,
               NUMFORMAT_CUSTOM_D_MON, NUMFORMAT_CUSTOM_MON_YY, NUMFORMAT_CUSTOM_HMM_AM,
               NUMFORMAT_CUSTOM_HMMSS_AM, NUMFORMAT_CUSTOM_HMM, NUMFORMAT_CUSTOM_HMMSS,
               NUMFORMAT_CUSTOM_MDYYYY_HMM, NUMFORMAT_NUMBER_SEP_NEGBRA = 37,
               NUMFORMAT_NUMBER_SEP_NEGBRARED, NUMFORMAT_NUMBER_D2_SEP_NEGBRA,
               NUMFORMAT_NUMBER_D2_SEP_NEGBRARED, NUMFORMAT_ACCOUNT, NUMFORMAT_ACCOUNTCUR,
               NUMFORMAT_ACCOUNT_D2, NUMFORMAT_ACCOUNT_D2_CUR, NUMFORMAT_CUSTOM_MMSS,
               NUMFORMAT_CUSTOM_H0MMSS, NUMFORMAT_CUSTOM_MMSS0, NUMFORMAT_CUSTOM_000P0E_PLUS0,
               NUMFORMAT_TEXT);
type
  Color = (COLOR_BLACK = 8, COLOR_WHITE, COLOR_RED, COLOR_BRIGHTGREEN, COLOR_BLUE, COLOR_YELLOW,
           COLOR_PINK, COLOR_TURQUOISE, COLOR_DARKRED, COLOR_GREEN, COLOR_DARKBLUE,
           COLOR_DARKYELLOW, COLOR_VIOLET, COLOR_TEAL, COLOR_GRAY25, COLOR_GRAY50,
           COLOR_PERIWINKLE_CF, COLOR_PLUM_CF, COLOR_IVORY_CF, COLOR_LIGHTTURQUOISE_CF,
           COLOR_DARKPURPLE_CF, COLOR_CORAL_CF, COLOR_OCEANBLUE_CF, COLOR_ICEBLUE_CF,
           COLOR_DARKBLUE_CL, COLOR_PINK_CL, COLOR_YELLOW_CL, COLOR_TURQUOISE_CL, COLOR_VIOLET_CL,
           COLOR_DARKRED_CL, COLOR_TEAL_CL, COLOR_BLUE_CL, COLOR_SKYBLUE, COLOR_LIGHTTURQUOISE,
           COLOR_LIGHTGREEN, COLOR_LIGHTYELLOW, COLOR_PALEBLUE, COLOR_ROSE, COLOR_LAVENDER,
           COLOR_TAN, COLOR_LIGHTBLUE, COLOR_AQUA, COLOR_LIME, COLOR_GOLD, COLOR_LIGHTORANGE,
           COLOR_ORANGE, COLOR_BLUEGRAY, COLOR_GRAY40, COLOR_DARKTEAL, COLOR_SEAGREEN,
           COLOR_DARKGREEN, COLOR_OLIVEGREEN, COLOR_BROWN, COLOR_PLUM, COLOR_INDIGO, COLOR_GRAY80,
           COLOR_DEFAULT_FOREGROUND = $0040, COLOR_DEFAULT_BACKGROUND = $0041,
           COLOR_TOOLTIP = $0051, COLOR_AUTO = $7FFF);

type
  SheetType = (SHEETTYPE_SHEET, SHEETTYPE_CHART, SHEETTYPE_UNKNOWN);

type
  CellType = (CELLTYPE_EMPTY, CELLTYPE_NUMBER, CELLTYPE_STRING, CELLTYPE_BOOLEAN, CELLTYPE_BLANK,
              CELLTYPE_ERROR);
type
  ErrorType = (ERRORTYPE_NULL = $00, ERRORTYPE_DIV_0 = $07, ERRORTYPE_VALUE = $0F,
               ERRORTYPE_REF = $17, ERRORTYPE_NAME = $1D, ERRORTYPE_NUM = $24, ERRORTYPE_NA = $2A,
               ERRORTYPE_NOERROR = $FF);
type
  PictureType = (PICTURETYPE_PNG, PICTURETYPE_JPEG, PICTURETYPE_WMF, PICTURETYPE_DIB, PICTURETYPE_EMF,
                 PICTURETYPE_PICT, PICTURETYPE_TIFF, PICTURETYPE_ERROR = $FF);
type
  SheetState = (SHEETSTATE_VISIBLE, SHEETSTATE_HIDDEN, SHEETSTATE_VERYHIDDEN);
type
  Paper = (PAPER_DEFAULT, PAPER_LETTER, PAPER_LETTERSMALL, PAPER_TABLOID, PAPER_LEDGER, PAPER_LEGAL,
           PAPER_STATEMENT, PAPER_EXECUTIVE, PAPER_A3, PAPER_A4, PAPER_A4SMALL, PAPER_A5, PAPER_B4,
           PAPER_B5, PAPER_FOLIO, PAPER_QUATRO, PAPER_10x14, PAPER_10x17, PAPER_NOTE,
           PAPER_ENVELOPE_9, PAPER_ENVELOPE_10, PAPER_ENVELOPE_11, PAPER_ENVELOPE_12,
           PAPER_ENVELOPE_14, PAPER_C_SIZE, PAPER_D_SIZE, PAPER_E_SIZE, PAPER_ENVELOPE_DL,
           PAPER_ENVELOPE_C5, PAPER_ENVELOPE_C3, PAPER_ENVELOPE_C4, PAPER_ENVELOPE_C6,
           PAPER_ENVELOPE_C65, PAPER_ENVELOPE_B4, PAPER_ENVELOPE_B5, PAPER_ENVELOPE_B6,
           PAPER_ENVELOPE, PAPER_ENVELOPE_MONARCH, PAPER_US_ENVELOPE, PAPER_FANFOLD,
           PAPER_GERMAN_STD_FANFOLD, PAPER_GERMAN_LEGAL_FANFOLD, PAPER_B4_ISO,
           PAPER_JAPANESE_POSTCARD, PAPER_9x11, PAPER_10x11, PAPER_15x11, PAPER_ENVELOPE_INVITE,
           PAPER_US_LETTER_EXTRA = 50, PAPER_US_LEGAL_EXTRA, PAPER_US_TABLOID_EXTRA, PAPER_A4_EXTRA,
           PAPER_LETTER_TRANSVERSE, PAPER_A4_TRANSVERSE, PAPER_LETTER_EXTRA_TRANSVERSE,
           PAPER_SUPERA, PAPER_SUPERB, PAPER_US_LETTER_PLUS, PAPER_A4_PLUS, PAPER_A5_TRANSVERSE,
           PAPER_B5_TRANSVERSE, PAPER_A3_EXTRA, PAPER_A5_EXTRA, PAPER_B5_EXTRA, PAPER_A2,
           PAPER_A3_TRANSVERSE, PAPER_A3_EXTRA_TRANSVERSE, PAPER_JAPANESE_DOUBLE_POSTCARD, PAPER_A6,
           PAPER_JAPANESE_ENVELOPE_KAKU2, PAPER_JAPANESE_ENVELOPE_KAKU3,
           PAPER_JAPANESE_ENVELOPE_CHOU3, PAPER_JAPANESE_ENVELOPE_CHOU4, PAPER_LETTER_ROTATED,
           PAPER_A3_ROTATED, PAPER_A4_ROTATED, PAPER_A5_ROTATED, PAPER_B4_ROTATED, PAPER_B5_ROTATED,
           PAPER_JAPANESE_POSTCARD_ROTATED, PAPER_DOUBLE_JAPANESE_POSTCARD_ROTATED,
           PAPER_A6_ROTATED, PAPER_JAPANESE_ENVELOPE_KAKU2_ROTATED,
           PAPER_JAPANESE_ENVELOPE_KAKU3_ROTATED, PAPER_JAPANESE_ENVELOPE_CHOU3_ROTATED,
           PAPER_JAPANESE_ENVELOPE_CHOU4_ROTATED, PAPER_B6, PAPER_B6_ROTATED, PAPER_12x11,
           PAPER_JAPANESE_ENVELOPE_YOU4, PAPER_JAPANESE_ENVELOPE_YOU4_ROTATED, PAPER_PRC16K,
           PAPER_PRC32K, PAPER_PRC32K_BIG, PAPER_PRC_ENVELOPE1, PAPER_PRC_ENVELOPE2,
           PAPER_PRC_ENVELOPE3, PAPER_PRC_ENVELOPE4, PAPER_PRC_ENVELOPE5, PAPER_PRC_ENVELOPE6,
           PAPER_PRC_ENVELOPE7, PAPER_PRC_ENVELOPE8, PAPER_PRC_ENVELOPE9, PAPER_PRC_ENVELOPE10,
           PAPER_PRC16K_ROTATED, PAPER_PRC32K_ROTATED, PAPER_PRC32KBIG_ROTATED,
           PAPER_PRC_ENVELOPE1_ROTATED, PAPER_PRC_ENVELOPE2_ROTATED, PAPER_PRC_ENVELOPE3_ROTATED,
           PAPER_PRC_ENVELOPE4_ROTATED, PAPER_PRC_ENVELOPE5_ROTATED, PAPER_PRC_ENVELOPE6_ROTATED,
           PAPER_PRC_ENVELOPE7_ROTATED, PAPER_PRC_ENVELOPE8_ROTATED, PAPER_PRC_ENVELOPE9_ROTATED,
           PAPER_PRC_ENVELOPE10_ROTATED);
type
  Underline = (UNDERLINE_NONE, UNDERLINE_SINGLE, UNDERLINE_DOUBLE,
               UNDERLINE_SINGLEACC = $21, UNDERLINE_DOUBLEACC = $22);
type
  Script = (SCRIPT_NORMAL, SCRIPT_SUPER, SCRIPT_SUB);
type
  Scope = (SCOPE_UNDEFINED = -2, SCOPE_WORKBOOK = -1);
type
  Op = (OPERATOR_EQUAL, OPERATOR_GREATER_THAN, OPERATOR_GREATER_THAN_OR_EQUAL, OPERATOR_LESS_THAN, OPERATOR_LESS_THAN_OR_EQUAL, OPERATOR_NOT_EQUAL );

type
  Filter = (FILTER_VALUE, FILTER_TOP10, FILTER_CUSTOM, FILTER_DYNAMIC, FILTER_COLOR, FILTER_ICON, FILTER_EXT, FILTER_NOT_SET);

type
  EnhancedProtection = (PROT_DEFAULT = -1, PROT_ALL = 0, PROT_OBJECTS = 1, PROT_SCENARIOS = 2, PROT_FORMAT_CELLS = 4, PROT_FORMAT_COLUMNS = 8, PROT_FORMAT_ROWS = 16,
                        PROT_INSERT_COLUMNS = 32, PROT_INSERT_ROWS = 64, PROT_INSERT_HYPERLINKS = 128, PROT_DELETE_COLUMNS = 256, PROT_DELETE_ROWS = 512,
                        PROT_SEL_LOCKED_CELLS = 1024, PROT_SORT = 2048, PROT_AUTOFILTER = 4096, PROT_PIVOTTABLES = 8192, PROT_SEL_UNLOCKED_CELLS = 16384);
type
  IgnoredError = (IERR_NO_ERROR = 0, IERR_EVAL_ERROR = 1, IERR_EMPTY_CELLREF = 2, IERR_NUMBER_STORED_AS_TEXT = 4, IERR_INCONSIST_RANGE = 8,
                  IERR_INCONSIST_FMLA = 16, IERR_TWODIG_TEXTYEAR = 32, IERR_UNLOCK_FMLA = 64, IERR_DATA_VALIDATION = 128);

type
  DataValidationType = (VALIDATION_TYPE_NONE, VALIDATION_TYPE_WHOLE, VALIDATION_TYPE_DECIMAL, VALIDATION_TYPE_LIST,
                        VALIDATION_TYPE_DATE, VALIDATION_TYPE_TIME, VALIDATION_TYPE_TEXTLENGTH, VALIDATION_TYPE_CUSTOM);

type
  DataValidationOperator = (VALIDATION_OP_BETWEEN, VALIDATION_OP_NOTBETWEEN, VALIDATION_OP_EQUAL, VALIDATION_OP_NOTEQUAL,
                            VALIDATION_OP_LESSTHAN, VALIDATION_OP_LESSTHANOREQUAL, VALIDATION_OP_GREATERTHAN, VALIDATION_OP_GREATERTHANOREQUAL);

type
  DataValidationErrorStyle = (VALIDATION_ERRSTYLE_STOP, VALIDATION_ERRSTYLE_WARNING, VALIDATION_ERRSTYLE_INFORMATION);

type
  CalcModeType = (CALCMODE_MANUAL, CALCMODE_AUTO, CALCMODE_AUTONOTABLE);
type
  CheckedType = (CHECKEDTYPE_UNCHECKED, CHECKEDTYPE_CHECKED, CHECKEDTYPE_MIXED);
type
  ObjectType = (OBJECT_UNKNOWN, OBJECT_BUTTON, OBJECT_CHECKBOX, OBJECT_DROP, OBJECT_GBOX, OBJECT_LABEL, OBJECT_LIST, OBJECT_RADIO, OBJECT_SCROLL, OBJECT_SPIN, OBJECT_EDITBOX, OBJECT_DIALOG);
type
  CFormatType = (CFORMAT_BEGINWITH, CFORMAT_CONTAINSBLANKS, CFORMAT_CONTAINSERRORS, CFORMAT_CONTAINSTEXT, CFORMAT_DUPLICATEVALUES, CFORMAT_ENDSWITH, CFORMAT_EXPRESSION,
                 CFORMAT_NOTCONTAINSBLANKS, CFORMAT_NOTCONTAINSERRORS, CFORMAT_NOTCONTAINSTEXT, CFORMAT_UNIQUEVALUES);
type
  CFormatOperator = (CFOPERATOR_LESSTHAN, CFOPERATOR_LESSTHANOREQUAL, CFOPERATOR_EQUAL, CFOPERATOR_NOTEQUAL, CFOPERATOR_GREATERTHANOREQUAL, CFOPERATOR_GREATERTHAN, CFOPERATOR_BETWEEN,
                     CFOPERATOR_NOTBETWEEN, CFOPERATOR_CONTAINSTEXT, CFOPERATOR_NOTCONTAINS, CFOPERATOR_BEGINSWITH, CFOPERATOR_ENDSWITH);
type
  CFormatTimePeriod = (CFTP_LAST7DAYS, CFTP_LASTMONTH, CFTP_LASTWEEK, CFTP_NEXTMONTH, CFTP_NEXTWEEK, CFTP_THISMONTH, CFTP_THISWEEK, CFTP_TODAY, CFTP_TOMORROW, CFTP_YESTERDAY);
type
  CFVOType = (CFVO_MIN, CFVO_MAX, CFVO_FORMULA, CFVO_NUMBER, CFVO_PERCENT, CFVO_PERCENTILE);
type
  BookHandle = Pointer;
type
  SheetHandle = Pointer;
type
  FormatHandle = Pointer;
type
  FontHandle = Pointer;
type
  RichStringHandle = Pointer;
type
  PFormatHandle = ^FormatHandle;
type
  PFontHandle = ^FontHandle;
type
  AutoFilterHandle = Pointer;
type
  FilterColumnHandle = Pointer;
type
  ConditionalFormatHandle = Pointer;
type
  FormControlHandle = Pointer;
type
  ConditionalFormattingHandle = Pointer;
type
  ByteArray = array of byte;
type
  PByteArray = ^ByteArray;
type
  PCardinal = ^Cardinal;
type
  PInteger = ^Integer;
type
  PBoolean = ^boolean;
type
  PDouble = ^double;

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                                 Book
//
////////////////////////////////////////////////////////////////////////////////////////////////////

function xlCreateBookC(): BookHandle cdecl;
external 'libxl' name 'xlCreateBookCW';

function xlCreateXMLBookC(): BookHandle cdecl;
external 'libxl' name 'xlCreateXMLBookCW';

function xlBookLoad(handle: BookHandle; filename: PWideChar): Integer cdecl;
external 'libxl' name 'xlBookLoadW';

function xlBookSave(handle: BookHandle; filename: PWideChar): Integer cdecl;
external 'libxl' name 'xlBookSaveW';

function xlBookLoadUsingTempFile(handle: BookHandle; filename: PWideChar; tempFile: PWideChar): Integer cdecl;
external 'libxl' name 'xlBookLoadUsingTempFileW';

function xlBookSaveUsingTempFile(handle: BookHandle; filename: PWideChar; useTempFile: Integer): Integer cdecl;
external 'libxl' name 'xlBookSaveUsingTempFileW';

function xlBookLoadPartially(handle: BookHandle; filename: PWideChar; sheetIndex, firstRow, lastRow: Integer): Integer cdecl;
external 'libxl' name 'xlBookLoadPartiallyW';

function xlBookLoadPartiallyUsingTempFile(handle: BookHandle; filename: PWideChar; sheetIndex, firstRow, lastRow: Integer; tempFile: PWideChar): Integer cdecl;
external 'libxl' name 'xlBookLoadPartiallyUsingTempFileW';

function xlBookLoadWithoutEmptyCells(handle: BookHandle; filename: PWideChar): Integer cdecl;
external 'libxl' name 'xlBookLoadWithoutEmptyCellsW';

function xlBookLoadInfo(handle: BookHandle; filename: PWideChar): Integer cdecl;
external 'libxl' name 'xlBookLoadInfoW';

function xlBookLoadRaw(handle: BookHandle; data: PByteArray; size: Cardinal): Integer cdecl;
external 'libxl' name 'xlBookLoadRawW';

function xlBookLoadRawPartially(handle: BookHandle; data: PByteArray; size: Cardinal; sheetIndex, firstRow, lastRow: Integer): Integer cdecl;
external 'libxl' name 'xlBookLoadRawPartiallyW';

function xlBookSaveRaw(handle: BookHandle; data: PByteArray; size: PCardinal): Integer cdecl;
external 'libxl' name 'xlBookSaveRawW';

function xlBookAddSheet(handle: BookHandle; name: PWideChar; initSheet: SheetHandle): SheetHandle cdecl;
external 'libxl' name 'xlBookAddSheetW';

function xlBookInsertSheet(handle: BookHandle; index: Integer; name: PWideChar; initSheet: SheetHandle): SheetHandle cdecl;
external 'libxl' name 'xlBookInsertSheetW';

function xlBookGetSheet(handle: BookHandle; index: Integer): SheetHandle cdecl;
external 'libxl' name 'xlBookGetSheetW';

function xlBookGetSheetName(handle: BookHandle; index: Integer): PWideChar cdecl;
external 'libxl' name 'xlBookGetSheetNameW';

function xlBookSheetType(handle: BookHandle; index: Integer): Integer cdecl;
external 'libxl' name 'xlBookSheetTypeW';

function xlBookMoveSheet(handle: BookHandle; srcIndex: Integer; dstIndex: Integer): Integer cdecl;
external 'libxl' name 'xlBookMoveSheetW';

function xlBookDelSheet(handle: BookHandle; index: Integer): Integer cdecl;
external 'libxl' name 'xlBookDelSheetW';

function xlBookSheetCount(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookSheetCountW';

function xlBookAddFormat(handle: BookHandle; initFormat: FormatHandle): FormatHandle cdecl;
external 'libxl' name 'xlBookAddFormatW';

function xlBookAddFont(handle: BookHandle; initFont: FontHandle): FontHandle cdecl;
external 'libxl' name 'xlBookAddFontW';

function xlBookAddRichString(handle: BookHandle): RichStringHandle cdecl;
external 'libxl' name 'xlBookAddRichStringW';

function xlBookAddCustomNumFormat(handle: BookHandle; const customNumFormat: PWideChar): Integer cdecl;
external 'libxl' name 'xlBookAddCustomNumFormatW';

function xlBookCustomNumFormat(handle: BookHandle; fmt: Integer): PWideChar cdecl;
external 'libxl' name 'xlBookCustomNumFormatW';

function xlBookFormat(handle: BookHandle; index: Integer): FormatHandle cdecl;
external 'libxl' name 'xlBookFormatW';

function xlBookFormatSize(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookFormatSizeW';

function xlBookFont(handle: BookHandle; index: Integer): FontHandle cdecl;
external 'libxl' name 'xlBookFontW';

function xlBookFontSize(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookFontSizeW';

function xlBookAddConditionalFormat(handle: BookHandle): ConditionalFormatHandle cdecl;
external 'libxl' name 'xlBookAddConditionalFormatW';

function xlBookDatePack(handle: BookHandle; year: Integer; month: Integer; day: Integer; hour: Integer; min: Integer; sec: Integer; msec: Integer): double cdecl;
external 'libxl' name 'xlBookDatePackW';

function xlBookDateUnpack(handle: BookHandle; value: double; year: PInteger; month: PInteger; day: PInteger; hour: PInteger; min: PInteger; sec: PInteger; msec: PInteger): Integer cdecl;
external 'libxl' name 'xlBookDateUnpackW';

function xlBookColorPack(handle: BookHandle; red: Integer; green: Integer; blue: Integer): Integer cdecl;
external 'libxl' name 'xlBookColorPackW';

procedure xlBookColorUnpack(handle: BookHandle; color: Integer; red: PInteger; green: PInteger; blue: PInteger) cdecl;
external 'libxl' name 'xlBookColorUnpackW';

function xlBookActiveSheet(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookActiveSheetW';

procedure xlBookSetActiveSheet(handle: BookHandle; index: Integer) cdecl;
external 'libxl' name 'xlBookSetActiveSheetW';

function xlBookPictureSize(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookPictureSizeW';

function xlBookGetPicture(hanlde: BookHandle; index: Integer; data: PByteArray; size: PCardinal): Integer cdecl;
external 'libxl' name 'xlBookGetPictureW';

function xlBookAddPicture(handle: BookHandle; filename: PWideChar): Integer cdecl;
external 'libxl' name 'xlBookAddPictureW';

function xlBookAddPicture2(handle: BookHandle; data: PByteArray; size: Cardinal): Integer cdecl;
external 'libxl' name 'xlBookAddPicture2W';

function xlBookAddPictureAsLink(handle: BookHandle; filename: PWideChar; insert: Integer): Integer cdecl;
external 'libxl' name 'xlBookAddPictureAsLinkW';

function xlBookDefaultFont(handle: BookHandle; fontSize: PInteger): PWideChar cdecl;
external 'libxl' name 'xlBookDefaultFontW';

procedure xlBookSetDefaultFont(handle: BookHandle; const name: PWideChar; fontSize: Integer) cdecl;
external 'libxl' name 'xlBookSetDefaultFontW';

function xlBookRefR1C1(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookRefR1C1W';

procedure xlBookSetRefR1C1(handle: BookHandle; refR1C1: Integer) cdecl;
external 'libxl' name 'xlBookSetRefR1C1W';

procedure xlBookSetKey(handle: BookHandle; const name: PWideChar; const key: PWideChar) cdecl;
external 'libxl' name 'xlBookSetKeyW';

function xlBookRgbMode(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookRgbModeW';

procedure xlBookSetRgbMode(handle: BookHandle; rgbMode: Integer) cdecl;
external 'libxl' name 'xlBookSetRgbModeW';

function xlBookCalcMode(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookCalcModeW';

procedure xlBookSetCalcMode(handle: BookHandle; calcMode: Integer) cdecl;
external 'libxl' name 'xlBookSetCalcModeW';

function xlBookVersion(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookVersionW';

function xlBookBiffVersion(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookBiffVersionW';

function xlBookIsDate1904(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookIsDate1904W';

procedure xlBookSetDate1904(handle: BookHandle; date1904: Integer) cdecl;
external 'libxl' name 'xlBookSetDate1904W';

function xlBookIsTemplate(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookIsTemplateW';

procedure xlBookSetTemplate(handle: BookHandle; tmpl: Integer) cdecl;
external 'libxl' name 'xlBookSetTemplateW';

function xlBookIsWriteProtected(handle: BookHandle): Integer cdecl;
external 'libxl' name 'xlBookIsWriteProtectedW';

function xlBookSetLocale(handle: BookHandle; const locale: PAnsiChar): Integer cdecl;
external 'libxl' name 'xlBookSetLocaleW';

function xlBookErrorMessage(handle: BookHandle): PAnsiChar cdecl;
external 'libxl' name 'xlBookErrorMessageW';

procedure xlBookRelease(handle: BookHandle) cdecl;
external 'libxl' name 'xlBookReleaseW';

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                                     Sheet
//
////////////////////////////////////////////////////////////////////////////////////////////////////

function xlSheetCellType(handle: SheetHandle; row: Integer; col: Integer): Integer cdecl;
external 'libxl' name 'xlSheetCellTypeW';

function xlSheetIsFormula(handle: SheetHandle; row: Integer; col: Integer): Integer cdecl;
external 'libxl' name 'xlSheetIsFormulaW';

function xlSheetCellFormat(handle: SheetHandle; row: Integer; col: Integer): FormatHandle cdecl;
external 'libxl' name 'xlSheetCellFormatW';

procedure xlSheetSetCellFormat(handle: SheetHandle; row: Integer; col: Integer; format: FormatHandle) cdecl;
external 'libxl' name 'xlSheetSetCellFormatW';

function xlSheetReadStr(handle: SheetHandle; row: Integer; col: Integer; format: PFormatHandle): PWideChar cdecl;
external 'libxl' name 'xlSheetReadStrW';

function xlSheetWriteStr(handle: SheetHandle; row: Integer; col: Integer; value: PWideChar; format: FormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetWriteStrW';

function xlSheetWriteStrAsNum(handle: SheetHandle; row: Integer; col: Integer; value: PWideChar; format: FormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetWriteStrAsNumW';

function xlSheetReadRichStr(handle: SheetHandle; row: Integer; col: Integer; format: PFormatHandle): RichStringHandle cdecl;
external 'libxl' name 'xlSheetReadRichStrW';

function xlSheetWriteRichStr(handle: SheetHandle; row: Integer; col: Integer; value: RichStringHandle; format: FormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetWriteRichStrW';

function xlSheetReadNum(handle: SheetHandle; row: Integer; col: Integer; format: PFormatHandle): double cdecl;
external 'libxl' name 'xlSheetReadNumW';

function xlSheetWriteNum(handle: SheetHandle; row: Integer; col: Integer; value: double; format: FormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetWriteNumW';

function xlSheetReadBool(handle: SheetHandle; row: Integer; col: Integer; format: PFormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetReadBoolW';

function xlSheetWriteBool(handle: SheetHandle; row: Integer; col: Integer; value: Integer; format: FormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetWriteBoolW';

function xlSheetReadBlank(handle: SheetHandle; row: Integer; col: Integer; format: PFormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetReadBlankW';

function xlSheetWriteBlank(handle: SheetHandle; row: Integer; col: Integer; format: FormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetWriteBlankW';

function xlSheetReadFormula(handle: SheetHandle; row: Integer; col: Integer; format: PFormatHandle): PWideChar cdecl;
external 'libxl' name 'xlSheetReadFormulaW';

function xlSheetWriteFormula(handle: SheetHandle; row: Integer; col: Integer; value: PWideChar; format: FormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetWriteFormulaW';

function xlSheetWriteFormulaNum(handle: SheetHandle; row: Integer; col: Integer; expr: PWideChar; value: double; format: FormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetWriteFormulaNumW';

function xlSheetWriteFormulaStr(handle: SheetHandle; row: Integer; col: Integer; expr: PWideChar; value: PWideChar; format: FormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetWriteFormulaStrW';

function xlSheetWriteFormulaBool(handle: SheetHandle; row: Integer; col: Integer; expr: PWideChar; value: Integer; format: FormatHandle): Integer cdecl;
external 'libxl' name 'xlSheetWriteFormulaBoolW';

function xlSheetReadComment(handle: SheetHandle; row: Integer; col: Integer): PWideChar cdecl;
external 'libxl' name 'xlSheetReadCommentW';

procedure xlSheetWriteComment(handle: SheetHandle; row: Integer; col: Integer; const value: PWideChar; const author: PWideChar; width: Integer; height: Integer) cdecl;
external 'libxl' name 'xlSheetWriteCommentW';

procedure xlSheetRemoveComment(handle: SheetHandle; row: Integer; col: Integer) cdecl;
external 'libxl' name 'xlSheetRemoveCommentW';

function xlSheetIsDate(handle: SheetHandle; row: Integer; col: Integer): Integer cdecl;
external 'libxl' name 'xlSheetIsDateW';

function xlSheetIsRichStr(handle: SheetHandle; row: Integer; col: Integer): Integer cdecl;
external 'libxl' name 'xlSheetIsRichStrW';

function xlSheetReadError(handle: SheetHandle; row: Integer; col: Integer): Integer cdecl;
external 'libxl' name 'xlSheetReadErrorW';

procedure xlSheetWriteError(handle: SheetHandle; row: Integer; col: Integer; error: Integer; format: FormatHandle) cdecl;
external 'libxl' name 'xlSheetWriteErrorW';

function xlSheetColWidth(handle: SheetHandle; col: Integer): double cdecl;
external 'libxl' name 'xlSheetColWidthW';

function xlSheetRowHeight(handle: SheetHandle; row: Integer): double cdecl;
external 'libxl' name 'xlSheetRowHeightW';

function xlSheetColWidthPx(handle: SheetHandle; col: Integer): Integer cdecl;
external 'libxl' name 'xlSheetColWidthPxA';

function xlSheetRowHeightPx(handle: SheetHandle; row: Integer): Integer cdecl;
external 'libxl' name 'xlSheetRowHeightPxA';

function xlSheetSetCol(handle: SheetHandle; colFirst: Integer; colLast: Integer; width: double; format: FormatHandle; hidden: Integer): Integer cdecl;
external 'libxl' name 'xlSheetSetColW';

function xlSheetSetRow(handle: SheetHandle; row: Integer; height: double; format: FormatHandle; hidden: Integer): Integer cdecl;
external 'libxl' name 'xlSheetSetRowW';

function xlSheetRowHidden(handle: SheetHandle; row: Integer): Integer cdecl;
external 'libxl' name 'xlSheetRowHiddenW';

function xlSheetSetRowHidden(handle: SheetHandle; row: Integer; hidden: Integer): Integer cdecl;
external 'libxl' name 'xlSheetSetRowHiddenW';

function xlSheetColHidden(handle: SheetHandle; col: Integer): Integer cdecl;
external 'libxl' name 'xlSheetColHiddenW';

function xlSheetSetColHidden(handle: SheetHandle; col: Integer; hidden: Integer): Integer cdecl;
external 'libxl' name 'xlSheetSetColHiddenW';

function xlSheetDefaultRowHeight(handle: SheetHandle): double cdecl;
external 'libxl' name 'xlSheetDefaultRowHeightW';

procedure xlSheetSetDefaultRowHeight(handle: SheetHandle; height: double) cdecl;
external 'libxl' name 'xlSheetSetDefaultRowHeightW';

function xlSheetGetMerge(handle: SheetHandle; row: Integer; col: Integer; rowFirst: PInteger; rowLast: PInteger; colFirst: PInteger; colLast: PInteger) : Integer cdecl;
external 'libxl' name 'xlSheetGetMergeW';

function xlSheetSetMerge(handle: SheetHandle; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer): Integer cdecl;
external 'libxl' name 'xlSheetSetMergeW';

function xlSheetDelMerge(handle: SheetHandle; row: Integer; col: Integer): Integer cdecl;
external 'libxl' name 'xlSheetDelMergeW';

function xlSheetMergeSize(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetMergeSizeW';

function xlSheetMerge(handle: SheetHandle; index: Integer; rowFirst, rowLast, colFirst, colLast: PInteger): Integer cdecl;
external 'libxl' name 'xlSheetMergeW';

function xlSheetDelMergeByIndex(handle: SheetHandle; index: Integer): Integer cdecl;
external 'libxl' name 'xlSheetDelMergeByIndexW';

function xlSheetPictureSize(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetPictureSizeW';

function xlSheetGetPicture(handle: SheetHandle; index: Integer; rowTop: PInteger; colLeft: PInteger; rowBottom: PInteger; colRight: PInteger;
                                                 width: PInteger; height: PInteger; offset_x: PInteger; offset_y: PInteger): Integer cdecl;
external 'libxl' name 'xlSheetGetPictureW';

function xlSheetRemovePictureByIndex(handle: SheetHandle; index: Integer): Integer cdecl;
external 'libxl' name 'xlSheetRemovePictureByIndexW';

procedure xlSheetSetPicture(handle: SheetHandle; row: Integer; col: Integer; pictureId: Integer; scale: double; offset_x: Integer; offset_y: Integer; pos: Integer) cdecl;
external 'libxl' name 'xlSheetSetPictureW';

procedure xlSheetSetPicture2(handle: SheetHandle; row: Integer; col: Integer; pictureId: Integer; widht: Integer; height: Integer; offset_x: Integer; offset_y: Integer; pos: Integer) cdecl;
external 'libxl' name 'xlSheetSetPicture2W';

function xlSheetRemovePicture(handle: SheetHandle; row: Integer; col: Integer): Integer cdecl;
external 'libxl' name 'xlSheetRemovePictureW';

function xlSheetGetHorPageBreak(handle: SheetHandle; index: Integer): Integer cdecl;
external 'libxl' name 'xlSheetGetHorPageBreakW';

function xlSheetGetHorPageBreakSize(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetGetHorPageBreakSizeW';

function xlSheetGetVerPageBreak(handle: SheetHandle; index: Integer): Integer cdecl;
external 'libxl' name 'xlSheetGetVerPageBreakW';

function xlSheetGetVerPageBreakSize(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetGetVerPageBreakSizeW';

function xlSheetSetHorPageBreak(handle: SheetHandle; row: Integer; pageBreak: Integer): Integer cdecl;
external 'libxl' name 'xlSheetSetHorPageBreakW';

function xlSheetSetVerPageBreak(handle: SheetHandle; col: Integer; pageBreak: Integer): Integer cdecl;
external 'libxl' name 'xlSheetSetVerPageBreakW';

procedure xlSheetSplit(handle: SheetHandle; row: Integer; col: Integer) cdecl;
external 'libxl' name 'xlSheetSplitW';

function xlSheetSplitInfo(handle: SheetHandle; row, col: PInteger): Integer cdecl;
external 'libxl' name 'xlSheetSplitInfoW';

function xlSheetGroupRows(handle: SheetHandle; rowFirst: Integer; rowLast: Integer; collapsed: Integer): Integer cdecl;
external 'libxl' name 'xlSheetGroupRowsW';

function xlSheetGroupCols(handle: SheetHandle; colFirst: Integer; colLast: Integer; collapsed: Integer): Integer cdecl;
external 'libxl' name 'xlSheetGroupColsW';

function xlSheetGroupSummaryBelow(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetGroupSummaryBelowW';

procedure xlSheetSetGroupSummaryBelow(handle: SheetHandle; below: Integer) cdecl;
external 'libxl' name 'xlSheetSetGroupSummaryBelowW';

function xlSheetGroupSummaryRight(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetGroupSummaryRightW';

procedure xlSheetSetGroupSummaryRight(handle: SheetHandle; right: Integer) cdecl;
external 'libxl' name 'xlSheetSetGroupSummaryRightW';

function xlSheetClear(handle: SheetHandle; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer): Integer cdecl;
external 'libxl' name 'xlSheetClearW';

function xlSheetInsertCol(handle: SheetHandle; colFirst: Integer; colLast: Integer): Integer cdecl;
external 'libxl' name 'xlSheetInsertColW';

function xlSheetInsertRow(handle: SheetHandle; rowFirst: Integer; rowLast: Integer): Integer cdecl;
external 'libxl' name 'xlSheetInsertRowW';

function xlSheetRemoveCol(handle: SheetHandle; colFirst: Integer; colLast: Integer): Integer cdecl;
external 'libxl' name 'xlSheetRemoveColW';

function xlSheetRemoveRow(handle: SheetHandle; rowFirst: Integer; rowLast: Integer): Integer cdecl;
external 'libxl' name 'xlSheetRemoveRowW';

function xlSheetInsertColAndKeepRanges(handle: SheetHandle; colFirst: Integer; colLast: Integer): Integer cdecl;
external 'libxl' name 'xlSheetInsertColAndKeepRangesW';

function xlSheetInsertRowAndKeepRanges(handle: SheetHandle; rowFirst: Integer; rowLast: Integer): Integer cdecl;
external 'libxl' name 'xlSheetInsertRowAndKeepRangesW';

function xlSheetRemoveColAndKeepRanges(handle: SheetHandle; colFirst: Integer; colLast: Integer): Integer cdecl;
external 'libxl' name 'xlSheetRemoveColAndKeepRangesW';

function xlSheetRemoveRowAndKeepRanges(handle: SheetHandle; rowFirst: Integer; rowLast: Integer): Integer cdecl;
external 'libxl' name 'xlSheetInsertColAndKeepRangesW';

function xlSheetCopyCell(handle: SheetHandle; rowSrc, colSrc, rowDst, colDst: Integer): Integer cdecl;
external 'libxl' name 'xlSheetCopyCellW';

function xlSheetFirstRow(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetFirstRowW';

function xlSheetLastRow(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetLastRowW';

function xlSheetFirstCol(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetFirstColW';

function xlSheetLastCol(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetLastColW';

function xlSheetFirstFilledRow(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetFirstFilledRowW';

function xlSheetLastFilledRow(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetLastFilledRowW';

function xlSheetFirstFilledCol(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetFirstFilledColW';

function xlSheetLastFilledCol(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetLastFilledColW';

function xlSheetDisplayGridlines(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetDisplayGridlinesW';

procedure xlSheetSetDisplayGridlines(handle: SheetHandle; show: Integer) cdecl;
external 'libxl' name 'xlSheetSetDisplayGridlinesW';

function xlSheetPrintGridlines(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetPrintGridlinesW';

procedure xlSheetSetPrintGridlines(handle: SheetHandle; print: Integer) cdecl;
external 'libxl' name 'xlSheetSetPrintGridlinesW';

function xlSheetZoom(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetZoomW';

procedure xlSheetSetZoom(handle: SheetHandle; print: Integer) cdecl;
external 'libxl' name 'xlSheetSetZoomW';

function xlSheetPrintZoom(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetPrintZoomW';

procedure xlSheetSetPrintZoom(handle: SheetHandle; print: Integer) cdecl;
external 'libxl' name 'xlSheetSetPrintZoomW';

function xlSheetGetPrintFit(handle: SheetHandle; wPages: PInteger; hPages: PInteger): Integer cdecl;
external 'libxl' name 'xlSheetGetPrintFitW';

procedure xlSheetSetPrintFit(handle: SheetHandle; wPages: Integer; hPages: Integer) cdecl;
external 'libxl' name 'xlSheetSetPrintFitW';

function xlSheetLandscape(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetLandscapeW';

procedure xlSheetSetLandscape(handle: SheetHandle; landscape: Integer) cdecl;
external 'libxl' name 'xlSheetSetLandscapeW';

function xlSheetPaper(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetPaperW';

procedure xlSheetSetPaper(handle: SheetHandle; Paper: Integer) cdecl;
external 'libxl' name 'xlSheetSetPaperW';

function xlSheetHeader(handle: SheetHandle): PWideChar cdecl;
external 'libxl' name 'xlSheetHeaderW';

function xlSheetSetHeader(handle: SheetHandle; const header: PWideChar; margin: double): Integer cdecl;
external 'libxl' name 'xlSheetSetHeaderW';

function xlSheetHeaderMargin(handle: SheetHandle): double cdecl;
external 'libxl' name 'xlSheetHeaderMarginW';

function xlSheetFooter(handle: SheetHandle): PWideChar cdecl;
external 'libxl' name 'xlSheetFooterW';

function xlSheetSetFooter(handle: SheetHandle; const footer: PWideChar; margin: double): Integer cdecl;
external 'libxl' name 'xlSheetSetFooterW';

function xlSheetFooterMargin(handle: SheetHandle): double cdecl;
external 'libxl' name 'xlSheetFooterMarginW';

function xlSheetHCenter(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetHCenterW';

procedure xlSheetSetHCenter(handle: SheetHandle; hCenter: Integer) cdecl;
external 'libxl' name 'xlSheetSetHCenterW';

function xlSheetVCenter(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetVCenterW';

procedure xlSheetSetVCenter(handle: SheetHandle; vCenter: Integer) cdecl;
external 'libxl' name 'xlSheetSetVCenterW';

function xlSheetMarginLeft(handle: SheetHandle): double cdecl;
external 'libxl' name 'xlSheetMarginLeftW';

procedure xlSheetSetMarginLeft(handle: SheetHandle; margin: double) cdecl;
external 'libxl' name 'xlSheetSetMarginLeftW';

function xlSheetMarginRight(handle: SheetHandle): double cdecl;
external 'libxl' name 'xlSheetMarginRightW';

procedure xlSheetSetMarginRight(handle: SheetHandle; margin: double) cdecl;
external 'libxl' name 'xlSheetSetMarginRightW';

function xlSheetMarginTop(handle: SheetHandle): double cdecl;
external 'libxl' name 'xlSheetMarginTopW';

procedure xlSheetSetMarginTop(handle: SheetHandle; margin: double) cdecl;
external 'libxl' name 'xlSheetSetMarginTopW';

function xlSheetMarginBottom(handle: SheetHandle): double cdecl;
external 'libxl' name 'xlSheetMarginBottomW';

procedure xlSheetSetMarginBottom(handle: SheetHandle; margin: double) cdecl;
external 'libxl' name 'xlSheetSetMarginBottomW';

function xlSheetPrintRowCol(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetPrintRowColW';

procedure xlSheetSetPrintRowCol(handle: SheetHandle; print: Integer) cdecl;
external 'libxl' name 'xlSheetSetPrintRowColW';

function xlSheetPrintRepeatRows(handle: SheetHandle; rowFirst, rowLast: PInteger): Integer cdecl;
external 'libxl' name 'xlSheetPrintRepeatRowsW';

procedure xlSheetSetPrintRepeatRows(handle: SheetHandle; rowFirst, rowLast: Integer) cdecl;
external 'libxl' name 'xlSheetSetPrintRepeatRowsW';

function xlSheetPrintRepeatCols(handle: SheetHandle; colFirst, colLast: PInteger): Integer cdecl;
external 'libxl' name 'xlSheetPrintRepeatColsW';

procedure xlSheetSetPrintRepeatCols(handle: SheetHandle; colFirst, colLast: Integer) cdecl;
external 'libxl' name 'xlSheetSetPrintRepeatColsW';

function xlSheetPrintArea(handle: SheetHandle; rowFirst: PInteger; rowLast: PInteger; colFirst: PInteger; colLast: PInteger): Integer cdecl;
external 'libxl' name 'xlSheetPrintAreaW';

procedure xlSheetSetPrintArea(handle: SheetHandle; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer) cdecl;
external 'libxl' name 'xlSheetSetPrintAreaW';

procedure xlSheetClearPrintRepeats(handle: SheetHandle) cdecl;
external 'libxl' name 'xlSheetClearPrintRepeatsW';

procedure xlSheetClearPrintArea(handle: SheetHandle) cdecl;
external 'libxl' name 'xlSheetClearPrintAreaW';

function xlSheetGetNamedRange(handle: SheetHandle; const name: PWideChar; rowFirst: PInteger; rowLast: PInteger; colFirst: PInteger; colLast: PInteger; scopeId: Integer; hidden: PBoolean): Integer cdecl;
external 'libxl' name 'xlSheetGetNamedRangeW';

function xlSheetSetNamedRange(handle: SheetHandle; const name: PWideChar; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; scopeId: Integer): Integer cdecl;
external 'libxl' name 'xlSheetSetNamedRangeW';

function xlSheetDelNamedRange(handle: SheetHandle; const name: PWideChar; scopeId: Integer): Integer cdecl;
external 'libxl' name 'xlSheetDelNamedRangeW';

function xlSheetNamedRangeSize(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetNamedRangeSizeW';

function xlSheetNamedRange(handle: SheetHandle; index: Integer; rowFirst: PInteger; rowLast: PInteger; colFirst: PInteger; colLast: PInteger; scopeId: PInteger; hidden: PBoolean): PWideChar cdecl;
external 'libxl' name 'xlSheetNamedRangeW';

function xlSheetTableSize(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetTableSizeW';

function xlSheetTable(handle: SheetHandle; index: Integer; rowFirst: PInteger; rowLast: PInteger; colFirst: PInteger; colLast: PInteger; headerRowCount: PInteger; totalsRowCount: PInteger): PWideChar cdecl;
external 'libxl' name 'xlSheetTableW';

function xlSheetHyperlinkSize(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetHyperlinkSizeW';

function xlSheetHyperlink(handle: SheetHandle; index: Integer; rowFirst: PInteger; rowLast: PInteger; colFirst: PInteger; colLast: PInteger): PWideChar cdecl;
external 'libxl' name 'xlSheetHyperlinkW';

function xlSheetDelHyperlink(handle: SheetHandle; index: Integer): Integer cdecl;
external 'libxl' name 'xlSheetDelHyperlinkW';

procedure xlSheetAddHyperlink(handle: SheetHandle; const hyperlink: PWideChar; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer) cdecl;
external 'libxl' name 'xlSheetAddHyperlinkW';

function xlSheetHyperlinkIndex(handle: SheetHandle; row, col: Integer): Integer cdecl;
external 'libxl' name 'xlSheetHyperlinkIndexW';

function xlSheetIsAutoFilter(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetIsAutoFilterW';

function xlSheetAutoFilter(handle: SheetHandle): AutoFilterHandle cdecl;
external 'libxl' name 'xlSheetAutoFilterW';

procedure xlSheetApplyFilter(handle: SheetHandle) cdecl;
external 'libxl' name 'xlSheetApplyFilterW';

procedure xlSheetRemoveFilter(handle: SheetHandle) cdecl;
external 'libxl' name 'xlSheetRemoveFilterW';

function xlSheetName(handle: SheetHandle): PWideChar cdecl;
external 'libxl' name 'xlSheetNameW';

procedure xlSheetSetName(handle: SheetHandle; const name: PWideChar) cdecl;
external 'libxl' name 'xlSheetSetNameW';

function xlSheetProtect(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetProtectW';

procedure xlSheetSetProtect(handle: SheetHandle; protect: Integer) cdecl;
external 'libxl' name 'xlSheetSetProtectW';

procedure xlSheetSetProtectEx(handle: SheetHandle; protect: Integer; const name: PWideChar; enhancedProtection: Integer) cdecl;
external 'libxl' name 'xlSheetSetProtectExW';

function xlSheetHidden(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetHiddenW';

function xlSheetSetHidden(handle: SheetHandle; hidden: Integer): Integer cdecl;
external 'libxl' name 'xlSheetSetHiddenW';

procedure xlSheetGetTopLeftView(handle: SheetHandle; row: PInteger; col: PInteger) cdecl;
external 'libxl' name 'xlSheetGetTopLeftViewW';

procedure xlSheetSetTopLeftView(handle: SheetHandle; row: Integer; col: Integer) cdecl;
external 'libxl' name 'xlSheetSetTopLeftViewW';

function xlSheetRightToLeft(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetRightToLeftW';

procedure xlSheetSetRightToLeft(handle: SheetHandle; rightToLeft: Integer) cdecl;
external 'libxl' name 'xlSheetSetRightToLeftW';

procedure xlSheetSetAutoFitArea(handle: SheetHandle; rowFirst: Integer; colFirst: Integer; rowLast: Integer; colLast: Integer) cdecl;
external 'libxl' name 'xlSheetSetAutoFitAreaW';

procedure xlSheetAddrToRowCol(handle: SheetHandle; const name: PWideChar; row: PInteger; col: PInteger; rowRelative: PInteger; colRelative: PInteger) cdecl;
external 'libxl' name 'xlSheetAddrToRowColW';

function xlSheetRowColToAddr(handle: SheetHandle; row: Integer; col: Integer; rowRelative: Integer; colRelative: Integer): PWideChar cdecl;
external 'libxl' name 'xlSheetRowColToAddrW';

function xlSheetTabColor(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetTabColorW';

procedure xlSheetSetTabColor(handle: SheetHandle; color: Integer) cdecl;
external 'libxl' name 'xlSheetSetTabColorW';

function xlSheetGetTabRgbColor(handle: SheetHandle; red, green, blue: PInteger): Integer cdecl;
external 'libxl' name 'xlSheetGetTabRgbColorW';

procedure xlSheetSetTabRgbColor(handle: SheetHandle; red: Integer; green: Integer; blue: Integer) cdecl;
external 'libxl' name 'xlSheetSetTabRgbColorW';

function xlSheetAddIgnoredError(handle: SheetHandle; rowFirst: Integer; colFirst: Integer; rowLast: Integer; colLast: Integer; iError: Integer): Integer cdecl;
external 'libxl' name 'xlSheetAddIgnoredErrorW';

procedure xlSheetAddDataValidation(handle: SheetHandle; vtype: Integer; op: Integer; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; value1: PWideChar; value2: PWideChar) cdecl;
external 'libxl' name 'xlSheetAddDataValidationW';

procedure xlSheetAddDataValidationEx(handle: SheetHandle; vtype: Integer; op: Integer; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; value1: PWideChar; value2: PWideChar;
                                     allowBlank: Integer; hideDropDown: Integer; showInputMessage: Integer; showErrorMessage: Integer; promptTitle: PWideChar; prompt: PWideChar;
                                     errorTitle: PWideChar; error: PWideChar; errorStyle: Integer) cdecl;
external 'libxl' name 'xlSheetAddDataValidationExW';

procedure xlSheetAddDataValidationDouble(handle: SheetHandle; vtype: Integer; op: Integer; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; value1: double; value2: double) cdecl;
external 'libxl' name 'xlSheetAddDataValidationDoubleW';

procedure xlSheetAddDataValidationDoubleEx(handle: SheetHandle; vtype: Integer; op: Integer; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; value1: double; value2: double;
                                     allowBlank: Integer; hideDropDown: Integer; showInputMessage: Integer; showErrorMessage: Integer; promptTitle: PWideChar; prompt: PWideChar;
                                     errorTitle: PWideChar; error: PWideChar; errorStyle: Integer) cdecl;
external 'libxl' name 'xlSheetAddDataValidationDoubleExW';

procedure xlSheetRemoveDataValidations(handle: SheetHandle) cdecl;
external 'libxl' name 'xlSheetRemoveDataValidationsW';

function xlSheetFormControlSize(handle: SheetHandle): Integer cdecl;
external 'libxl' name 'xlSheetFormControlSizeW';

function xlSheetFormControl(handle: SheetHandle; index: Integer): FormControlHandle cdecl;
external 'libxl' name 'xlSheetFormControlW';

function xlSheetAddConditionalFormatting(handle: SheetHandle): ConditionalFormattingHandle cdecl;
external 'libxl' name 'xlSheetAddConditionalFormattingW';

function xlSheetGetActiveCell(handle: SheetHandle; row, col: PInteger): Integer cdecl;
external 'libxl' name 'xlSheetGetActiveCellW';

procedure xlSheetSetActiveCell(handle: SheetHandle; row, col: Integer) cdecl;
external 'libxl' name 'xlSheetSetActiveCellW';

function xlSheetSelectionRange(handle: SheetHandle): PWideChar cdecl;
external 'libxl' name 'xlSheetSelectionRangeW';

procedure xlSheetAddSelectionRange(handle: SheetHandle; sqref: PWideChar) cdecl;
external 'libxl' name 'xlSheetAddSelectionRangeW';

procedure xlSheetRemoveSelection(handle: SheetHandle) cdecl;
external 'libxl' name 'xlSheetRemoveSelectionW';

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                              Format
//
////////////////////////////////////////////////////////////////////////////////////////////////////

function xlFormatFont(handle: FormatHandle): FontHandle cdecl;
external 'libxl' name 'xlFormatFontW';

function xlFormatSetFont(handle: FormatHandle; FontHandle: FontHandle): FontHandle cdecl;
external 'libxl' name 'xlFormatSetFontW';

function xlFormatNumFormat(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatNumFormatW';

procedure xlFormatSetNumFormat(handle: FormatHandle; NumFormat: Integer) cdecl;
external 'libxl' name 'xlFormatSetNumFormatW';

function xlFormatAlignH(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatAlignHW';

procedure xlFormatSetAlignH(handle: FormatHandle; align: Integer) cdecl;
external 'libxl' name 'xlFormatSetAlignHW';

function xlFormatAlignV(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatAlignVW';

procedure xlFormatSetAlignV(handle: FormatHandle; align: Integer) cdecl;
external 'libxl' name 'xlFormatSetAlignVW';

function xlFormatWrap(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatWrapW';

procedure xlFormatSetWrap(handle: FormatHandle; wrap: Integer) cdecl;
external 'libxl' name 'xlFormatSetWrapW';

function xlFormatRotation(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatRotationW';

function xlFormatSetRotation(handle: FormatHandle; rotation: Integer): Integer cdecl;
external 'libxl' name 'xlFormatSetRotationW';

function xlFormatIndent(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatIndentW';

procedure xlFormatSetIndent(handle: FormatHandle; indent: Integer) cdecl;
external 'libxl' name 'xlFormatSetIndentW';

function xlFormatShrinkToFit(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatShrinkToFitW';

procedure xlFormatSetShrinkToFit(handle: FormatHandle; shrinkToFit: Integer) cdecl;
external 'libxl' name 'xlFormatSetShrinkToFitW';

procedure xlFormatSetBorder(handle: FormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderW';

procedure xlFormatSetBorderColor(handle: FormatHandle; Color: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderColorW';

function xlFormatBorderLeft(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderLeftW';

procedure xlFormatSetBorderLeft(handle: FormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderLeftW';

function xlFormatBorderRight(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderRightW';

procedure xlFormatSetBorderRight(handle: FormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderRightW';

function xlFormatBorderTop(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderTopW';

procedure xlFormatSetBorderTop(handle: FormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderTopW';

function xlFormatBorderBottom(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderBottomW';

procedure xlFormatSetBorderBottom(handle: FormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderBottomW';

function xlFormatBorderLeftColor(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderLeftColorW';

procedure xlFormatSetBorderLeftColor(handle: FormatHandle; Color: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderLeftColorW';

function xlFormatBorderRightColor(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderRightColorW';

procedure xlFormatSetBorderRightColor(handle: FormatHandle; Color: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderRightColorW';

function xlFormatBorderTopColor(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderTopColorW';

procedure xlFormatSetBorderTopColor(handle: FormatHandle; Color: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderTopColorW';

function xlFormatBorderBottomColor(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderBottomColorW';

procedure xlFormatSetBorderBottomColor(handle: FormatHandle; Color: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderBottomColorW';

function xlFormatBorderDiagonal(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderDiagonalW';

procedure xlFormatSetBorderDiagonal(handle: FormatHandle; border: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderDiagonalW';

function xlFormatBorderDiagonalStyle(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderDiagonalStyleW';

procedure xlFormatSetBorderDiagonalStyle(handle: FormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderDiagonalStyleW';

function xlFormatBorderDiagonalColor(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatBorderDiagonalColorW';

procedure xlFormatSetBorderDiagonalColor(handle: FormatHandle; Color: Integer) cdecl;
external 'libxl' name 'xlFormatSetBorderDiagonalColorW';

function xlFormatFillPattern(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatFillPatternW';

procedure xlFormatSetFillPattern(handle: FormatHandle; pattern: Integer) cdecl;
external 'libxl' name 'xlFormatSetFillPatternW';

function xlFormatPatternForegroundColor(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatPatternForegroundColorW';

procedure xlFormatSetPatternForegroundColor(handle: FormatHandle; Color: Integer) cdecl;
external 'libxl' name 'xlFormatSetPatternForegroundColorW';

function xlFormatPatternBackgroundColor(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatPatternBackgroundColorW';

procedure xlFormatSetPatternBackgroundColor(handle: FormatHandle; Color: Integer) cdecl;
external 'libxl' name 'xlFormatSetPatternBackgroundColorW';

function xlFormatLocked(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatLockedW';

procedure xlFormatSetLocked(handle: FormatHandle; locked: Integer) cdecl;
external 'libxl' name 'xlFormatSetLockedW';

function xlFormatHidden(handle: FormatHandle): Integer cdecl;
external 'libxl' name 'xlFormatHiddenW';

procedure xlFormatSetHidden(handle: FormatHandle; hidden: Integer) cdecl;
external 'libxl' name 'xlFormatSetHiddenW';

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                           Font
//
////////////////////////////////////////////////////////////////////////////////////////////////////

function xlFontSize(handle: FontHandle): Integer cdecl;
external 'libxl' name 'xlFontSizeW';

procedure xlFontSetSize(handle: FontHandle; size: Integer) cdecl;
external 'libxl' name 'xlFontSetSizeW';

function xlFontItalic(handle: FontHandle): Integer cdecl;
external 'libxl' name 'xlFontItalicW';

procedure xlFontSetItalic(handle: FontHandle; italic: Integer) cdecl;
external 'libxl' name 'xlFontSetItalicW';

function xlFontStrikeOut(handle: FontHandle): Integer cdecl;
external 'libxl' name 'xlFontStrikeOutW';

procedure xlFontSetStrikeOut(handle: FontHandle; strikeOut: Integer) cdecl;
external 'libxl' name 'xlFontSetStrikeOutW';

function xlFontColor(handle: FontHandle): Integer cdecl;
external 'libxl' name 'xlFontColorW';

procedure xlFontSetColor(handle: FontHandle; Color: Integer) cdecl;
external 'libxl' name 'xlFontSetColorW';

function xlFontBold(handle: FontHandle): Integer cdecl;
external 'libxl' name 'xlFontBoldW';

procedure xlFontSetBold(handle: FontHandle; bold: Integer) cdecl;
external 'libxl' name 'xlFontSetBoldW';

function xlFontScript(handle: FontHandle): Integer cdecl;
external 'libxl' name 'xlFontScriptW';

procedure xlFontSetScript(handle: FontHandle; Script: Integer) cdecl;
external 'libxl' name 'xlFontSetScriptW';

function xlFontUnderline(handle: FontHandle): Integer cdecl;
external 'libxl' name 'xlFontUnderlineW';

procedure xlFontSetUnderline(handle: FontHandle; Underline: Integer) cdecl;
external 'libxl' name 'xlFontSetUnderlineW';

function xlFontName(handle: FontHandle): PWideChar cdecl;
external 'libxl' name 'xlFontNameW';

function xlFontSetName(handle: FontHandle; const name: PWideChar): Integer cdecl;
external 'libxl' name 'xlFontSetNameW';

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                                    AutoFilter
//
////////////////////////////////////////////////////////////////////////////////////////////////////

function xlAutoFilterGetRef(handle: AutoFilterHandle; rowFirst, rowLast, colFirst, colLast: PInteger): Integer cdecl;
external 'libxl' name 'xlAutoFilterGetRefW';

procedure xlAutoFilterSetRef(handle: AutoFilterHandle; rowFirst, rowLast, colFirst, colLast: Integer) cdecl;
external 'libxl' name 'xlAutoFilterSetRefW';

function xlAutoFilterColumn(handle: AutoFilterHandle; colId: Integer): FilterColumnHandle cdecl;
external 'libxl' name 'xlAutoFilterColumnW';

function xlAutoFilterColumnSize(handle: AutoFilterHandle): Integer cdecl;
external 'libxl' name 'xlAutoFilterColumnSizeW';

function xlAutoFilterColumnByIndex(handle: AutoFilterHandle; index: Integer): FilterColumnHandle cdecl;
external 'libxl' name 'xlAutoFilterColumnByIndexW';

function xlAutoFilterGetSortRange(handle: AutoFilterHandle; rowFirst, rowLast, colFirst, colLast: PInteger): Integer cdecl;
external 'libxl' name 'xlAutoFilterGetSortRangeW';

function xlAutoFilterGetSort(handle: AutoFilterHandle; columnIndex, descending: PInteger): Integer cdecl;
external 'libxl' name 'xlAutoFilterGetSortW';

function xlAutoFilterSetSort(handle: AutoFilterHandle; columnIndex, descending: Integer): Integer cdecl;
external 'libxl' name 'xlAutoFilterSetSortW';

function xlAutoFilterAddSort(handle: AutoFilterHandle; columnIndex, descending: Integer): Integer cdecl;
external 'libxl' name 'xlAutoFilterAddSortW';

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                               FilterColumn
//
////////////////////////////////////////////////////////////////////////////////////////////////////

function xlFilterColumnIndex(handle: FilterColumnHandle): Integer cdecl;
external 'libxl' name 'xlFilterColumnIndexW';

function xlFilterColumnFilterType(handle: FilterColumnHandle): Integer cdecl;
external 'libxl' name 'xlFilterColumnFilterTypeW';

function xlFilterColumnFilterSize(handle: FilterColumnHandle): Integer cdecl;
external 'libxl' name 'xlFilterColumnFilterSizeW';

function xlFilterColumnFilter(handle: FilterColumnHandle; index: Integer): PWideChar cdecl;
external 'libxl' name 'xlFilterColumnFilterW';

procedure xlFilterColumnAddFilter(handle: FilterColumnHandle; value: PWideChar) cdecl;
external 'libxl' name 'xlFilterColumnAddFilterW';

function xlFilterColumnGetTop10(handle: FilterColumnHandle; value: PDouble; top, percent: PInteger): Integer cdecl;
external 'libxl' name 'xlFilterColumnGetTop10W';

procedure xlFilterColumnSetTop10(handle: FilterColumnHandle; value: double; top, percent: Integer) cdecl;
external 'libxl' name 'xlFilterColumnSetTop10W';

function xlFilterColumnGetCustomFilter(handle: FilterColumnHandle; op1: PInteger; v1: PAnsiString; op2: PInteger; v2: PAnsiString; andOp: PInteger): Integer cdecl;
external 'libxl' name 'xlFilterColumnGetCustomFilterW';

procedure xlFilterColumnSetCustomFilter(handle: FilterColumnHandle; op: Integer; v: WideString) cdecl;
external 'libxl' name 'xlFilterColumnSetCustomFilterW';

procedure xlFilterColumnSetCustomFilterEx(handle: FilterColumnHandle; op1: Integer; v1: WideString; op2: Integer; v2: WideString; andOp: Integer) cdecl;
external 'libxl' name 'xlFilterColumnSetCustomFilterExW';

procedure xlFilterColumnClear(handle: FilterColumnHandle) cdecl;
external 'libxl' name 'xlFilterColumnClearW';

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                                   RichString
//
////////////////////////////////////////////////////////////////////////////////////////////////////

function xlRichStringAddFont(handle: RichStringHandle; initFont: FontHandle): FontHandle cdecl;
external 'libxl' name 'xlRichStringAddFontW';

procedure xlRichStringAddText(handle: RichStringHandle; text: PWideChar; font: FontHandle) cdecl;
external 'libxl' name 'xlRichStringAddTextW';

function xlRichStringGetText(handle: RichStringHandle; index: Integer; font: PFontHandle): PWideChar cdecl;
external 'libxl' name 'xlRichStringGetTextW';

function xlRichStringTextSize(handle: RichStringHandle): Integer cdecl;
external 'libxl' name 'xlRichStringTextSizeW';

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                                 ConditionalFormatting
//
////////////////////////////////////////////////////////////////////////////////////////////////////

procedure xlConditionalFormattingAddRange(handle: ConditionalFormattingHandle; rowFirst, rowLast, colFirst, colLast: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAddRangeW';

procedure xlConditionalFormattingAddRule(handle: ConditionalFormattingHandle; cType: Integer; cFormat: ConditionalFormatHandle; value: PWideChar; stopIfTrue: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAddRuleW';

procedure xlConditionalFormattingAddTopRule(handle: ConditionalFormattingHandle; cFormat: ConditionalFormatHandle; value, bottom, percent, stopIfTrue: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAddRuleW';

procedure xlConditionalFormattingAddOpNumRule(handle: ConditionalFormattingHandle; op: Integer; cFormat: ConditionalFormatHandle; value1, value2: double; stopIfTrue: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAddOpNumRuleW';

procedure xlConditionalFormattingAddOpStrRule(handle: ConditionalFormattingHandle; op: Integer; cFormat: ConditionalFormatHandle; value1, value2: PWideChar; stopIfTrue: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAddOpStrRuleW';

procedure xlConditionalFormattingAddAboveAverageRule(handle: ConditionalFormattingHandle; cFormat: ConditionalFormatHandle; aboveAverage, equalAverage, stdDev, stopIfTrue: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAddAboveAverageRuleW';

procedure xlConditionalFormattingAddTimePeriodRule(handle: ConditionalFormattingHandle; cFormat: ConditionalFormatHandle; timePeriod, stopIfTrue: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAddTimePeriodRuleW';

procedure xlConditionalFormattingAdd2ColorScaleRule(handle: ConditionalFormattingHandle; minColor, maxColor, minType: Integer; minValue: double; maxType: Integer; maxValue: double; stopIfTrue: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAdd2ColorScaleRuleW';

procedure xlConditionalFormattingAdd2ColorScaleFormulaRule(handle: ConditionalFormattingHandle; minColor, maxColor, minType: Integer; minValue: PWideChar; maxType: Integer; maxValue: PWideChar; stopIfTrue: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAdd2ColorScaleFormulaRuleW';

procedure xlConditionalFormattingAdd3ColorScaleRule(handle: ConditionalFormattingHandle; minColor, midColor, maxColor, minType: Integer; minValue: double; midType: Integer; midValue: double; maxType: Integer; maxValue: double; stopIfTrue: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAdd3ColorScaleRuleW';

procedure xlConditionalFormattingAdd3ColorScaleFormulaRule(handle: ConditionalFormattingHandle; minColor, midColor, maxColor, minType: Integer; minValue: PWideChar; midType: Integer; midValue: PWideChar; maxType: Integer; maxValue: PWideChar; stopIfTrue: Integer) cdecl;
external 'libxl' name 'xlConditionalFormattingAdd3ColorScaleFormulaRuleW';

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                                 ConditionalFormat
//
////////////////////////////////////////////////////////////////////////////////////////////////////

function xlConditionalFormatFont(handle: ConditionalFormatHandle): FontHandle cdecl;
external 'libxl' name 'xlConditionalFormatFontW';

function xlConditionalFormatNumFormat(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatNumFormatW';

procedure xlConditionalFormatSetNumFormat(handle: ConditionalFormatHandle; numFormat: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetNumFormatW';

function xlConditionalFormatCustomNumFormat(handle: ConditionalFormatHandle): PWideChar cdecl;
external 'libxl' name 'xlConditionalFormatCustomNumFormatW';

procedure xlConditionalFormatSetCustomNumFormat(handle: ConditionalFormatHandle; customNumFormat: PWideChar) cdecl;
external 'libxl' name 'xlConditionalFormatSetCustomNumFormatW';

procedure xlConditionalFormatSetBorder(handle: ConditionalFormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetBorderW';

procedure xlConditionalFormatSetBorderColor(handle: ConditionalFormatHandle; color: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetBorderColorW';

function xlConditionalFormatBorderLeft(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatBorderLeftW';

procedure xlConditionalFormatSetBorderLeft(handle: ConditionalFormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetBorderLeftW';

function xlConditionalFormatBorderRight(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatBorderRightW';

procedure xlConditionalFormatSetBorderRight(handle: ConditionalFormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetBorderRightW';

function xlConditionalFormatBorderTop(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatBorderTopW';

procedure xlConditionalFormatSetBorderTop(handle: ConditionalFormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetBorderTopW';

function xlConditionalFormatBorderBottom(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatBorderBottomW';

procedure xlConditionalFormatSetBorderBottom(handle: ConditionalFormatHandle; style: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetBorderBottomW';

function xlConditionalFormatBorderLeftColor(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatBorderLeftColorW';

procedure xlConditionalFormatSetBorderLeftColor(handle: ConditionalFormatHandle; color: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetBorderLeftColorW';

function xlConditionalFormatBorderRightColor(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatBorderRightColorW';

procedure xlConditionalFormatSetBorderRightColor(handle: ConditionalFormatHandle; color: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetBorderRightColorW';

function xlConditionalFormatBorderTopColor(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatBorderTopColorW';

procedure xlConditionalFormatSetBorderTopColor(handle: ConditionalFormatHandle; color: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetBorderTopColorW';

function xlConditionalFormatBorderBottomColor(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatBorderBottomColorW';

procedure xlConditionalFormatSetBorderBottomColor(handle: ConditionalFormatHandle; color: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetBorderBottomColorW';

function xlConditionalFormatFillPattern(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatFillPatternW';

procedure xlConditionalFormatSetFillPattern(handle: ConditionalFormatHandle; pattern: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetFillPatternW';

function xlConditionalFormatPatternForegroundColor(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatPatternForegroundColorW';

procedure xlConditionalFormatSetPatternForegroundColor(handle: ConditionalFormatHandle; color: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetPatternForegroundColorW';

function xlConditionalFormatPatternBackgroundColor(handle: ConditionalFormatHandle): Integer cdecl;
external 'libxl' name 'xlConditionalFormatPatternBackgroundColorW';

procedure xlConditionalFormatSetPatternBackgroundColor(handle: ConditionalFormatHandle; color: Integer) cdecl;
external 'libxl' name 'xlConditionalFormatSetPatternBackgroundColorW';

////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                                 FormControl
//
////////////////////////////////////////////////////////////////////////////////////////////////////

function xlFormControlObjectType(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlObjectTypeW';

function xlFormControlChecked(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlCheckedW';

procedure xlFormControlSetChecked(handle: FormControlHandle; checked: Integer) cdecl;
external 'libxl' name 'xlFormControlSetCheckedW';

function xlFormControlFmlaGroup(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlFmlaGroupW';

procedure xlFormControlSetFmlaGroup(handle: FormControlHandle; group: PWideChar) cdecl;
external 'libxl' name 'xlFormControlSetFmlaGroupW';

function xlFormControlFmlaLink(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlFmlaLinkW';

procedure xlFormControlSetFmlaLink(handle: FormControlHandle; group: PWideChar) cdecl;
external 'libxl' name 'xlFormControlSetFmlaLinkW';

function xlFormControlFmlaRange(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlFmlaRangeW';

procedure xlFormControlSetFmlaRange(handle: FormControlHandle; range: PWideChar) cdecl;
external 'libxl' name 'xlFormControlSetFmlaRangeW';

function xlFormControlFmlaTxbx(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlFmlaTxbxW';

procedure xlFormControlSetFmlaTxbx(handle: FormControlHandle; txbx: PWideChar) cdecl;
external 'libxl' name 'xlFormControlSetFmlaTxbxW';

function xlFormControlName(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlNameW';

function xlFormControlLinkedCell(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlLinkedCellW';

function xlFormControlListFillRange(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlListFillRangeW';

function xlFormControlMacro(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlMacroW';

function xlFormControlAltText(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlAltTextW';

function xlFormControlLocked(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlLockedW';

function xlFormControlDefaultSize(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlDefaultSizeW';

function xlFormControlPrint(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlPrintW';

function xlFormControlDisabled(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlDisabledW';

function xlFormControlItem(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlItemW';

function xlFormControlItemSize(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlItemSizeW';

procedure xlFormControlAddItem(handle: FormControlHandle; value: PWideChar) cdecl;
external 'libxl' name 'xlFormControlAddItemW';

procedure xlFormControlInsertItem(handle: FormControlHandle; index: Integer; value: PWideChar) cdecl;
external 'libxl' name 'xlFormControlInsertItemW';

procedure xlFormControlClearItems(handle: FormControlHandle) cdecl;
external 'libxl' name 'xlFormControlClearItemsW';

function xlFormControlDropLines(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlDropLinesW';

procedure xlFormControlSetDropLines(handle: FormControlHandle; lines: Integer) cdecl;
external 'libxl' name 'xlFormControlSetDropLinesW';

function xlFormControlDx(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlDxW';

procedure xlFormControlSetDx(handle: FormControlHandle; dx: Integer) cdecl;
external 'libxl' name 'xlFormControlSetDxW';

function xlFormControlFirstButton(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlFirstButtonW';

procedure xlFormControlSetFirstButton(handle: FormControlHandle; firstButton: Integer) cdecl;
external 'libxl' name 'xlFormControlSetFirstButtonW';

function xlFormControlHoriz(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlHorizW';

procedure xlFormControlSetHoriz(handle: FormControlHandle; horiz: Integer) cdecl;
external 'libxl' name 'xlFormControlSetHorizW';

function xlFormControlInc(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlIncW';

procedure xlFormControlSetInc(handle: FormControlHandle; inc: Integer) cdecl;
external 'libxl' name 'xlFormControlSetIncW';

function xlFormControlGetMax(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlGetMaxW';

procedure xlFormControlSetMax(handle: FormControlHandle; max: Integer) cdecl;
external 'libxl' name 'xlFormControlSetMaxW';

function xlFormControlGetMin(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlGetMinW';

procedure xlFormControlSetMin(handle: FormControlHandle; min: Integer) cdecl;
external 'libxl' name 'xlFormControlSetMinW';

function xlFormControlMultiSel(handle: FormControlHandle): PWideChar cdecl;
external 'libxl' name 'xlFormControlMultiSelW';

procedure xlFormControlSetMultiSel(handle: FormControlHandle; value: PWideChar) cdecl;
external 'libxl' name 'xlFormControlSetMultiSelW';

function xlFormControlSel(handle: FormControlHandle): Integer cdecl;
external 'libxl' name 'xlFormControlSelW';

procedure xlFormControlSetSel(handle: FormControlHandle; sel: Integer) cdecl;
external 'libxl' name 'xlFormControlSetSelW';

function xlFormControlFromAnchor(handle: FormControlHandle; col, colOff, row, rowOff: PInteger): Integer cdecl;
external 'libxl' name 'xlFormControlFromAnchorW';

function xlFormControlToAnchor(handle: FormControlHandle; col, colOff, row, rowOff: PInteger): Integer cdecl;
external 'libxl' name 'xlFormControlToAnchorW';

////////////////////////////////////////////////////////////////////////////////////////////////////


{$M+}

type
  TXLFormControl = class(TObject)
  private
    handle: FormControlHandle;
    book: BookHandle;

    function getObjectType(): ObjectType;

    function getChecked(): CheckedType;
    procedure setChecked(checked: CheckedType);

    function getFmlaGroup(): WideString;
    procedure setFmlaGroup(fmlaGroup: WideString);

    function getFmlaLink(): WideString;
    procedure setFmlaLink(fmlaLink: WideString);

    function getFmlaRange(): WideString;
    procedure setFmlaRange(fmlaRange: WideString);

    function getFmlaTxbx(): WideString;
    procedure setFmlaTxbx(fmlaTxbx: WideString);

    function getName(): WideString;
    function getLinkedCell(): WideString;
    function getListFillRange(): WideString;
    function getMacro(): WideString;
    function getAltText(): WideString;

    function getLocked(): boolean;
    function getDefaultSize(): boolean;
    function getPrint(): boolean;
    function getDisabled(): boolean;

    function getDropLines(): Integer;
    procedure setDropLines(dropLines: Integer);

    function getDx(): Integer;
    procedure setDx(dx: Integer);

    function getFirstButton(): boolean;
    procedure setFirstButton(firstButton: boolean);

    function getHoriz(): boolean;
    procedure setHoriz(horiz: boolean);

    function getInc(): Integer;
    procedure setInc(inc: Integer);

    function getMax(): Integer;
    procedure setMax(max: Integer);

    function getMin(): Integer;
    procedure setMin(min: Integer);

    function getMultiSel(): WideString;
    procedure setMultiSel(multiSel: WideString);

    function getSel(): Integer;
    procedure setSel(sel: Integer);

  public
     property objectType: ObjectType read getObjectType;
     property checked: CheckedType read getChecked write setChecked;
     property fmlaGroup: WideString read getFmlaGroup write setFmlaGroup;
     property fmlaLink: WideString read getFmlaLink write setFmlaLink;
     property fmlaRange: WideString read getFmlaRange write setFmlaRange;
     property fmlaTxbx: WideString read getFmlaTxbx write setFmlaTxbx;
     property name: WideString read getName;
     property linkedCell: WideString read getLinkedCell;
     property listFillRange: WideString read getListFillRange;
     property macro: WideString read getMacro;
     property altText: WideString read getAltText;
     property locked: boolean read getLocked;
     property defaultSize: boolean read getDefaultSize;
     property print: boolean read getPrint;
     property disabled: boolean read getDisabled;

     function item(index: Integer): WideString;
     function itemSize(): Integer;
     procedure addItem(value: PWideChar);
     procedure insertItem(index: Integer; value: PWideChar);
     procedure clearItems();

     property dropLines: Integer read getDropLines write setDropLines;
     property dx: Integer read getDx write setDx;
     property firstButton: boolean read getFirstButton write setFirstButton;
     property horiz: boolean read getHoriz write setHoriz;
     property inc: Integer read getInc write setInc;
     property max: Integer read getMax write setMax;
     property min: Integer read getMin write setMin;
     property multiSel: WideString read getMultiSel write setMultiSel;
     property sel: Integer read getSel write setSel;

     function fromAnchor(var col, colOff, row, rowOff: Integer): boolean;
     function toAnchor(var col, colOff, row, rowOff: Integer): boolean;

  published
    constructor Create(handle: FormControlHandle; book: BookHandle);
  end;

type
  TArrayFormControls = array of TXLFormControl;

type
  TXLFilterColumn = class(TObject)
  private
    book: BookHandle;
    handle: FilterColumnHandle;

  public
     function index(): Integer;

     function filterType(): Filter;

     function filterSize(): Integer;
     function filter(index: Integer): PWideChar;
     procedure addFilter(const value: PWideChar);

     function getTop10(var value: double; var top, percent: boolean): boolean;
     procedure setTop10(value: double); overload;
     procedure setTop10(value: double; top: boolean); overload;
     procedure setTop10(value: double; top, percent: boolean); overload;

     function getCustomFilter(var op1: Op; var v1: PWideChar; var op2: Op; var v2: PWideChar; var andOp: boolean): boolean;
     procedure setCustomFilter(op: Op; const v: PWideChar); overload;
     procedure setCustomFilter(op1: Op; const v1: PWideChar; op2: Op; const v2: PWideChar; andOp: boolean); overload;

     procedure clear();

  published
    constructor Create(handle: FilterColumnHandle; book: BookHandle);
    destructor Destroy; override;
  end;

type
  TArrayFilterColumns = array of TXLFilterColumn;

type
  TXLAutoFilter = class(TObject)
  private
    handle: AutoFilterHandle;
    book: BookHandle;
    filterColumns: TArrayFilterColumns;

  public
     function getRef(var rowFirst, rowLast, colFirst, colLast: Integer): boolean;
     procedure setRef(rowFirst, rowLast, colFirst, colLast: Integer);

     function column(colId: Integer): TXLFilterColumn;

     function columnSize(): Integer;
     function columnByIndex(index: Integer): TXLFilterColumn;

     function getSortRange(var rowFirst, rowLast, colFirst, colLast: Integer): boolean;

     function getSort(var columnIndex: Integer; var descending: boolean): boolean;
     function setSort(columnIndex: Integer; descending: boolean): boolean;
     function addSort(columnIndex: Integer; descending: boolean): boolean;

  published
    constructor Create(handle: AutoFilterHandle; book: BookHandle);
    destructor Destroy; override;
  end;

type
  TXLFont = class(TObject)
  private
    handle: FontHandle;
    book: BookHandle;

    procedure Setsize(const value: Integer);
    function Getsize: Integer;

    procedure Setbold(const value: boolean);
    function Getbold: boolean;

    procedure Setitalic(const value: boolean);
    function Getitalic: boolean;

    procedure SetUnderline(const value: Underline);
    function GetUnderline: Underline;

    procedure SetstrikeOut(const value: boolean);
    function GetstrikeOut: boolean;

    procedure Setscript(const value: Script);
    function Getscript: Script;

    procedure Setcolor(const value: Color);
    function Getcolor: Color;

    procedure SetName(const value: WideString);
    function GetName: WideString;

  public
    property size: Integer read Getsize write Setsize;
    property bold: boolean read Getbold write Setbold;
    property italic: boolean read Getitalic write Setitalic;
    property underline: Underline read GetUnderline write SetUnderline;
    property strikeOut: boolean read GetstrikeOut write SetstrikeOut;
    property script: Script read Getscript write Setscript;
    property color: Color read Getcolor write Setcolor;
    property name: WideString read GetName write SetName;

  published
    constructor Create(handle: FontHandle; book: BookHandle);
    destructor Destroy; override;
  end;

type
  TArrayFonts = array of TXLFont;

type
  TXLRichString = class(TObject)
  private
    handle: RichStringHandle;
    book: BookHandle;
    fonts: TArrayFonts;

  public
     function addFont(): TXLFont; overload;
     function addFont(initFont: TXLFont): TXLFont; overload;
     procedure addText(const text: PWideChar); overload;
     procedure addText(const text: PWideChar; font: TXLFont); overload;
     function getText(index: Integer): WideString; overload;
     function getText(index: Integer; var font: TXLFont): WideString; overload;
     function textSize(): Integer;

  published
    constructor Create(handle: RichStringHandle; book: BookHandle);
    destructor Destroy; override;
  end;

type
  TArrayRichStrings = array of TXLRichString;

type
  TXLFormat = class(TObject)
  private
    handle: FormatHandle;
    book: BookHandle;
    ffont: TXLFont;

    procedure Setfont(const value: TXLFont);
    function Getfont: TXLFont;

    procedure SetalignH(const value: AlignH);
    function GetalignH: AlignH;

    procedure SetAlignV(const value: AlignV);
    function GetAlignV: AlignV;
    procedure Setwrap(const value: boolean);
    function Getwrap: boolean;
    procedure Setrotation(const value: Integer);
    function Getrotation: Integer;
    procedure Setindent(const value: Integer);
    function Getindent: Integer;
    procedure SetshrinkToFit(const value: boolean);
    function GetshrinkToFit: boolean;

    procedure SetborderLeft(const value: BorderStyle);
    function GetborderLeft: BorderStyle;
    procedure SetborderRight(const value: BorderStyle);
    function GetborderRight: BorderStyle;
    procedure SetborderTop(const value: BorderStyle);
    function GetborderTop: BorderStyle;
    procedure SetborderBottom(const value: BorderStyle);
    function GetborderBottom: BorderStyle;

    procedure SetborderLeftColor(const value: Color);
    function GetborderLeftColor: Color;
    procedure SetborderRightColor(const value: Color);
    function GetborderRightColor: Color;
    procedure SetborderTopColor(const value: Color);
    function GetborderTopColor: Color;
    procedure SetborderBottomColor(const value: Color);
    function GetborderBottomColor: Color;

    procedure SetborderDiagonal(const value: BorderDiagonal);
    function GetborderDiagonal: BorderDiagonal;
    procedure SetBorderDiagonalStyle(const value: BorderStyle);
    function GetBorderDiagonalStyle: BorderStyle;
    procedure SetborderDiagonalColor(const value: Color);
    function GetborderDiagonalColor: Color;

    procedure SetfillPattern(const value: FillPattern);
    function GetfillPattern: FillPattern;

    procedure SetpatternForegroundColor(const value: Color);
    function GetpatternForegroundColor: Color;
    procedure SetpatternBackgroundColor(const value: Color);
    function GetpatternBackgroundColor: Color;

    procedure Setlocked(const value: boolean);
    function Getlocked: boolean;

    procedure Sethidden(const value: boolean);
    function Gethidden: boolean;

  public
    function numFormat: Integer;
    procedure setNumFormat(NumFormat: Integer); overload;
    procedure setNumFormat(value: NumFormat); overload;
    procedure setBorder(style: BorderStyle);
    procedure setBorderColor(value: Color);

    property hidden: boolean read Gethidden write Sethidden;
    property locked: boolean read Getlocked write Setlocked;
    property fillPattern: FillPattern read GetfillPattern write SetfillPattern;
    property patternForegroundColor: Color read GetpatternForegroundColor write SetpatternForegroundColor;
    property patternBackgroundColor: Color read GetpatternBackgroundColor write SetpatternBackgroundColor;
    property borderDiagonal: BorderDiagonal read GetborderDiagonal write SetborderDiagonal;
    property borderDiagonalStyle: BorderStyle read GetBorderDiagonalStyle write SetBorderDiagonalStyle;
    property borderDiagonalColor: Color read GetborderDiagonalColor write SetborderDiagonalColor;

    property font: TXLFont read Getfont write Setfont;
    property alignH: AlignH read GetalignH write SetalignH;
    property alignV: AlignV read GetAlignV write SetAlignV;
    property wrap: boolean read Getwrap write Setwrap;
    property rotation: Integer read Getrotation write Setrotation;
    property indent: Integer read Getindent write Setindent;
    property shrinkToFit: boolean read GetshrinkToFit write SetshrinkToFit;

    property borderLeft: BorderStyle read GetborderLeft write SetborderLeft;
    property borderRight: BorderStyle read GetborderRight write SetborderRight;
    property borderTop: BorderStyle read GetborderTop write SetborderTop;
    property borderBottom: BorderStyle read GetborderBottom write SetborderBottom;

    property borderLeftColor: Color read GetborderLeftColor write SetborderLeftColor;
    property borderRightColor: Color read GetborderRightColor write SetborderRightColor;
    property borderTopColor: Color read GetborderTopColor write SetborderTopColor;
    property borderBottomColor: Color read GetborderBottomColor write SetborderBottomColor;

  published
    constructor Create(handle: FormatHandle; book: BookHandle);
    destructor Destroy; override;
  end;

type
  TArrayFormats = array of TXLFormat;

type
  TXLConditionalFormat = class(TObject)
  private
    handle: ConditionalFormatHandle;
    book: BookHandle;
    ffont: TXLFont;

    function Getfont: TXLFont;

    procedure SetborderLeftCond(const value: BorderStyle);
    function GetborderLeftCond: BorderStyle;
    procedure SetborderRightCond(const value: BorderStyle);
    function GetborderRightCond: BorderStyle;
    procedure SetborderTopCond(const value: BorderStyle);
    function GetborderTopCond: BorderStyle;
    procedure SetborderBottomCond(const value: BorderStyle);
    function GetborderBottomCond: BorderStyle;

    procedure SetborderLeftColorCond(const value: Color);
    function GetborderLeftColorCond: Color;
    procedure SetborderRightColorCond(const value: Color);
    function GetborderRightColorCond: Color;
    procedure SetborderTopColorCond(const value: Color);
    function GetborderTopColorCond: Color;
    procedure SetborderBottomColorCond(const value: Color);
    function GetborderBottomColorCond: Color;

    procedure SetfillPatternCond(const value: FillPattern);
    function GetfillPatternCond: FillPattern;

    procedure SetpatternForegroundColorCond(const value: Color);
    function GetpatternForegroundColorCond: Color;
    procedure SetpatternBackgroundColorCond(const value: Color);
    function GetpatternBackgroundColorCond: Color;

  public
     property font: TXLFont read Getfont;

     function numFormat(): NumFormat;
     procedure setNumFormat(numFormat: NumFormat);

     function customNumFormat(): WideString;
     procedure setCustomNumFormat(customNumFormat: PWideChar);

     procedure setBorder(style: BorderStyle);
     procedure setBorderColor(color: Color);

     property borderLeft: BorderStyle read GetborderLeftCond write SetborderLeftCond;
     property borderRight: BorderStyle read GetborderRightCond write SetborderRightCond;
     property borderTop: BorderStyle read GetborderTopCond write SetborderTopCond;
     property borderBottom: BorderStyle read GetborderBottomCond write SetborderBottomCond;

     property borderLeftColor: Color read GetborderLeftColorCond write SetborderLeftColorCond;
     property borderRightColor: Color read GetborderRightColorCond write SetborderRightColorCond;
     property borderTopColor: Color read GetborderTopColorCond write SetborderTopColorCond;
     property borderBottomColor: Color read GetborderBottomColorCond write SetborderBottomColorCond;

     property fillPattern: FillPattern read GetfillPatternCond write SetfillPatternCond;
     property patternForegroundColor: Color read GetpatternForegroundColorCond write SetpatternForegroundColorCond;
     property patternBackgroundColor: Color read GetpatternBackgroundColorCond write SetpatternBackgroundColorCond;

  published
    constructor Create(handle: ConditionalFormatHandle; book: BookHandle);
    destructor Destroy; override;
  end;

type
  TArrayConditionalFormats = array of TXLConditionalFormat;

type
  TXLConditionalFormatting = class(TObject)
  private
    handle: ConditionalFormattingHandle;
    book: BookHandle;
  public
     procedure addRange(rowFirst, rowLast, colFirst, colLast: Integer);

     procedure addRule(cType: CFormatType; cFormat: TXLConditionalFormat); overload;
     procedure addRule(cType: CFormatType; cFormat: TXLConditionalFormat; value: PWideChar); overload;
     procedure addRule(cType: CFormatType; cFormat: TXLConditionalFormat; value: PWideChar; stopIfTrue: boolean); overload;

     procedure addTopRule(cFormat: TXLConditionalFormat; value: Integer); overload;
     procedure addTopRule(cFormat: TXLConditionalFormat; value: Integer; bottom: boolean); overload;
     procedure addTopRule(cFormat: TXLConditionalFormat; value: Integer; bottom, percent: boolean); overload;
     procedure addTopRule(cFormat: TXLConditionalFormat; value: Integer; bottom, percent, stopIfTrue: boolean); overload;

     procedure addOpNumRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1: double); overload;
     procedure addOpNumRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1, value2: double); overload;
     procedure addOpNumRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1, value2: double; stopIfTrue: boolean); overload;

     procedure addOpStrRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1: PWideChar); overload;
     procedure addOpStrRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1, value2: PWideChar); overload;
     procedure addOpStrRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1, value2: PWideChar; stopIfTrue: boolean); overload;

     procedure addAboveAverageRule(cFormat: TXLConditionalFormat); overload;
     procedure addAboveAverageRule(cFormat: TXLConditionalFormat; aboveAverage: boolean); overload;
     procedure addAboveAverageRule(cFormat: TXLConditionalFormat; aboveAverage, equalAverage: boolean); overload;
     procedure addAboveAverageRule(cFormat: TXLConditionalFormat; aboveAverage, equalAverage: boolean; stdDev: Integer); overload;
     procedure addAboveAverageRule(cFormat: TXLConditionalFormat; aboveAverage, equalAverage: boolean; stdDev: Integer; stopIfTrue: boolean); overload;

     procedure addTimePeriodRule(cFormat: TXLConditionalFormat; timePeriod: CFormatTimePeriod); overload;
     procedure addTimePeriodRule(cFormat: TXLConditionalFormat; timePeriod: CFormatTimePeriod; stopIfTrue: boolean); overload;

     procedure add2ColorScaleRule(minColor, maxColor: Color); overload;
     procedure add2ColorScaleRule(minColor, maxColor: Color; minType: CFVOType; minValue: double; maxType: CFVOType; maxValue: double); overload;
     procedure add2ColorScaleRule(minColor, maxColor: Color; minType: CFVOType; minValue: double; maxType: CFVOType; maxValue: double; stopIfTrue: boolean); overload;

     procedure add2ColorScaleFormulaRule(minColor, maxColor: Color; minType: CFVOType; minValue: PWideChar; maxType: CFVOType; maxValue: PWideChar); overload;
     procedure add2ColorScaleFormulaRule(minColor, maxColor: Color; minType: CFVOType; minValue: PWideChar; maxType: CFVOType; maxValue: PWideChar; stopIfTrue: boolean); overload;

     procedure add3ColorScaleRule(minColor, midColor, maxColor: Color); overload;
     procedure add3ColorScaleRule(minColor, midColor, maxColor: Color; minType: CFVOType; minValue: double; midType: CFVOType; midValue: double; maxType: CFVOType; maxValue: double); overload;
     procedure add3ColorScaleRule(minColor, midColor, maxColor: Color; minType: CFVOType; minValue: double; midType: CFVOType; midValue: double; maxType: CFVOType; maxValue: double; stopIfTrue: boolean); overload;

     procedure add3ColorScaleFormulaRule(minColor, midColor, maxColor: Color; minType: CFVOType; minValue: PWideChar; midType: CFVOType; midValue: PWideChar; maxType: CFVOType; maxValue: PWideChar); overload;
     procedure add3ColorScaleFormulaRule(minColor, midColor, maxColor: Color; minType: CFVOType; minValue: PWideChar; midType: CFVOType; midValue: PWideChar; maxType: CFVOType; maxValue: PWideChar; stopIfTrue: boolean); overload;

  published
    constructor Create(handle: ConditionalFormattingHandle; book: BookHandle);
  end;

type
  TArrayConditionalFormattings = array of TXLConditionalFormatting;

type
  TXLSheet = class(TObject)
  private
    handle: SheetHandle;
    book: BookHandle;
    richStrings: TArrayRichStrings;
    formats: TArrayFormats;
    formControls: TArrayFormControls;
    cFormattings: TArrayConditionalFormattings;
    xlAutoFilter: TXLAutoFilter;

    procedure SetDisplayGridlines(const value: boolean);
    function GetDisplayGridlines: boolean;

    procedure SetprintGridlines(const value: boolean);
    function GetprintGridlines: boolean;

    procedure SetZoom(const value: Integer);
    function GetZoom: Integer;

    procedure SetprintZoom(const value: Integer);
    function GetprintZoom: Integer;

    procedure Setlandscape(const value: boolean);
    function Getlandscape: boolean;

    procedure SetPaper(const value: Paper);
    function GetPaper: Paper;

    procedure Setheader(const value: WideString);
    function Getheader: WideString;

    procedure SetheaderMargin(const value: double);
    function GetheaderMargin: double;

    function Getfooter: WideString;
    procedure Setfooter(const value: WideString);
    function GetfooterMargin: double;
    procedure SetfooterMargin(const value: double);

    function GethCenter: boolean;
    procedure SethCenter(const value: boolean);

    function GetvCenter: boolean;
    procedure SetvCenter(const value: boolean);

    function GetmarginLeft: double;
    procedure SetmarginLeft(const value: double);
    function GetmarginRight: double;
    procedure SetmarginRight(const value: double);
    function GetmarginBottom: double;
    function GetmarginTop: double;
    procedure SetmarginBottom(const value: double);
    procedure SetmarginTop(const value: double);

    function GetprintRowCol: boolean;
    procedure SetprintRowCol(const value: boolean);

    function GetprotectImpl: boolean;
    procedure SetprotectImpl(const value: boolean);

    function Getrighttoleft: boolean;
    procedure Setrighttoleft(const value: boolean);

    function GetHidden: SheetState;
    procedure SetHidden(const value: SheetState);

    function GetName: WideString;
    procedure SetName(const value: WideString);

    function GetGroupSummaryBelow: boolean;
    procedure SetGroupSummaryBelow(const value: boolean);

    function GetGroupSummaryRight: boolean;
    procedure SetGroupSummaryRight(const value: boolean);

  public
    property displayGridlines: boolean read GetDisplayGridlines write SetDisplayGridlines;
    property printGridlines: boolean read GetprintGridlines write SetprintGridlines;
    property zoom: Integer read GetZoom write SetZoom;
    property printZoom: Integer read GetprintZoom write SetprintZoom;
    property landscape: boolean read Getlandscape write Setlandscape;
    property paper: Paper read GetPaper write SetPaper;
    property header: WideString read Getheader write Setheader;
    property headerMargin: double read GetheaderMargin write SetheaderMargin;
    property footer: WideString read Getfooter write Setfooter;
    property footerMargin: double read GetfooterMargin write SetfooterMargin;
    property hCenter: boolean read GethCenter write SethCenter;
    property vCenter: boolean read GetvCenter write SetvCenter;

    property marginLeft: double read GetmarginLeft write SetmarginLeft;
    property marginRight: double read GetmarginRight write SetmarginRight;
    property marginTop: double read GetmarginTop write SetmarginTop;
    property marginBottom: double read GetmarginBottom write SetmarginBottom;

    property printRowCol: boolean read GetprintRowCol write SetprintRowCol;
    property name: WideString read GetName write SetName;
    property groupSummaryBelow: boolean read GetGroupSummaryBelow write SetGroupSummaryBelow;
    property groupSummaryRight: boolean read GetGroupSummaryRight write SetGroupSummaryRight;

    property protect: boolean read GetprotectImpl write SetprotectImpl;
    property hidden: SheetState read GetHidden write SetHidden;
    property rightToLeft: boolean read Getrighttoleft write Setrighttoleft;

    function errorMessage(): WideString;

    function getCellType(row: Integer; col: Integer): CellType;
    function isFormula(row: Integer; col: Integer): boolean;

    function cellFormat(row: Integer; col: Integer): TXLFormat;
    procedure setCellFormat(row: Integer; col: Integer; format: TXLFormat);
    
    function readStr(row: Integer; col: Integer): WideString; overload;
    function readStr(row: Integer; col: Integer; var format: TXLFormat): WideString; overload;
    function writeStr(row: Integer; col: Integer; value: PWideChar): boolean; overload;
    function writeStr(row: Integer; col: Integer; value: PWideChar; format: TXLFormat): boolean; overload;

    function readRichStr(row: Integer; col: Integer): TXLRichString; overload;
    function readRichStr(row: Integer; col: Integer; var format: TXLFormat): TXLRichString; overload;
    function writeRichStr(row: Integer; col: Integer; value: TXLRichString): boolean; overload;
    function writeRichStr(row: Integer; col: Integer; value: TXLRichString; format: TXLFormat): boolean; overload;

    function readNum(row: Integer; col: Integer): double; overload;
    function readNum(row: Integer; col: Integer; var format: TXLFormat): double; overload;
    function writeNum(row: Integer; col: Integer; value: double): boolean; overload;
    function writeNum(row: Integer; col: Integer; value: double; format: TXLFormat): boolean; overload;

    function readBool(row: Integer; col: Integer): boolean; overload;
    function readBool(row: Integer; col: Integer; var format: TXLFormat): boolean; overload;
    function writeBool(row: Integer; col: Integer; value: boolean): boolean; overload;
    function writeBool(row: Integer; col: Integer; value: boolean; format: TXLFormat): boolean; overload;

    function readBlank(row: Integer; col: Integer; var format: TXLFormat): boolean;
    function writeBlank(row: Integer; col: Integer; format: TXLFormat): boolean;

    function readFormula(row: Integer; col: Integer): WideString; overload;
    function readFormula(row: Integer; col: Integer; var format: TXLFormat): WideString; overload;
    function writeFormula(row: Integer; col: Integer; value: PWideChar): boolean; overload;
    function writeFormula(row: Integer; col: Integer; value: PWideChar; format: TXLFormat): boolean; overload;

    function writeFormulaNum(row: Integer; col: Integer; expr: PWideChar; value: double): boolean; overload;
    function writeFormulaNum(row: Integer; col: Integer; expr: PWideChar; value: double; format: TXLFormat): boolean; overload;

    function writeFormulaStr(row: Integer; col: Integer; expr: PWideChar; value: PWideChar): boolean; overload;
    function writeFormulaStr(row: Integer; col: Integer; expr: PWideChar; value: PWideChar; format: TXLFormat): boolean; overload;

    function writeFormulaBool(row: Integer; col: Integer; expr: PWideChar; value: Integer): boolean; overload;
    function writeFormulaBool(row: Integer; col: Integer; expr: PWideChar; value: Integer; format: TXLFormat): boolean; overload;

    function readComment(row: Integer; col: Integer): WideString;
    procedure writeComment(row: Integer; col: Integer; value: PWideChar; author: PWideChar; width, height: Integer);
    procedure removeComment(row: Integer; col: Integer);

    function isDate(row, col: Integer): boolean;
    function isRichStr(row, col: Integer): boolean;

    function readError(row, col: Integer): ErrorType;
    procedure writeError(row, col: Integer; error: ErrorType); overload;
    procedure writeError(row, col: Integer; error: ErrorType; format: TXLFormat); overload;

    function colWidth(col: Integer): double;
    function rowHeight(col: Integer): double;

    function colWidthPx(col: Integer): Integer;
    function rowHeightPx(col: Integer): Integer;

    function setCol(col: Integer; width: double): boolean; overload;
    function setCol(colFirst, colLast: Integer; width: double): boolean; overload;
    function setCol(col: Integer; width: double; format: TXLFormat): boolean; overload;
    function setCol(colFirst, colLast: Integer; width: double; format: TXLFormat): boolean; overload;
    function setCol(col: Integer; width: double; format: TXLFormat; hidden: boolean): boolean; overload;
    function setCol(colFirst, colLast: Integer; width: double; format: TXLFormat; hidden: boolean): boolean; overload;

    function setRow(row: Integer; height: double): boolean; overload;
    function setRow(row: Integer; height: double; format: TXLFormat): boolean; overload;
    function setRow(row: Integer; height: double; format: TXLFormat; hidden: boolean): boolean; overload;

    function rowHidden(row: Integer): boolean;
    function setRowHidden(row: Integer; hidden: boolean): boolean;

    function colHidden(col: Integer): boolean;
    function setColHidden(col: Integer; hidden: boolean): boolean;

    function defaultRowHeight(): double;
    procedure setDefaultRowHeight(height: double);

    function getMerge(row, col: Integer; var rowFirst, rowLast, colFirst, colLast: Integer): boolean;
    function setMerge(rowFirst, rowLast, colFirst, colLast: Integer): boolean;
    function delMerge(row, col: Integer): boolean;

    function mergeSize(): Integer;
    function merge(index: Integer; var rowFirst, rowLast, colFirst, colLast: Integer): boolean;
    function delMergeByIndex(index: Integer): boolean;

    function pictureSize: Integer;
    function getPicture(index: Integer): Integer; overload;
    function getPicture(index: Integer; var rowTop, colLeft, rowBottom, colRight: Integer): Integer; overload;
    function getPicture(index: Integer; var rowTop, colLeft, rowBottom, colRight, width, height: Integer): Integer; overload;
    function getPicture(index: Integer; var rowTop, colLeft, rowBottom, colRight, width, height, offset_x, offset_y: Integer): Integer; overload;
    function removePictureByIndex(index: Integer): boolean;

    procedure setPicture(row, col, pictureId: Integer); overload;
    procedure setPicture(row, col, pictureId: Integer; scale: double); overload;
    procedure setPicture(row, col, pictureId, width, height: Integer); overload;
    function removePicture(row, col: Integer): boolean;

    function getHorPageBreak(index: Integer): Integer;
    function getHorPageBreakSize: Integer;

    function getVerPageBreak(index: Integer): Integer;
    function getVerPageBreakSize: Integer;

    function setHorPageBreak(row: Integer): boolean;
    function delHorPageBreak(row: Integer): boolean;
    function setVerPageBreak(col: Integer): boolean;
    function delVerPageBreak(col: Integer): boolean;

    procedure split(row, col: Integer);
    function splitInfo(var row, col: Integer): boolean;

    function groupRows(rowFirst, rowLast: Integer; collapsed: boolean): boolean;
    function groupCols(colFirst, colLast: Integer; collapsed: boolean): boolean;

    function clear(rowFirst, rowLast: Integer; colFirst, colLast: Integer): boolean;

    function insertCol(colFirst, colLast: Integer): boolean;
    function insertRow(rowFirst, rowLast: Integer): boolean;
    function removeCol(colFirst, colLast: Integer): boolean;
    function removeRow(rowFirst, rowLast: Integer): boolean;

    function copyCell(rowSrc, colSrc, rowDst, colDst: Integer): boolean;

    function firstRow: Integer;
    function lastRow: Integer;
    function firstCol: Integer;
    function lastCol: Integer;

    function firstFilledRow: Integer;
    function lastFilledRow: Integer;
    function firstFilledCol: Integer;
    function lastFilledCol: Integer;

    function getPrintFit(var wPages, hPages: Integer): boolean;
    procedure setPrintFit(wPages, hPages: Integer);

    function printRepeatRows(var rowFirst, rowLast: Integer): boolean;
    procedure setPrintRepeatRows(rowFirst, rowLast: Integer);

    function printRepeatCols(var colFirst, colLast: Integer): boolean;
    procedure setPrintRepeatCols(colFirst, colLast: Integer);

    function printArea(var rowFirst, rowLast, colFirst, colLast: Integer): boolean;
    procedure setPrintArea(rowFirst, rowLast, colFirst, colLast: Integer);
    
    procedure clearPrintRepeats();
    procedure clearPrintArea();

    function getNamedRange(const name: PWideChar; var rowFirst, rowLast, colFirst, colLast: Integer): boolean; overload;
    function getNamedRange(const name: PWideChar; var rowFirst, rowLast, colFirst, colLast: Integer; scopeId: Integer): boolean; overload;
    function getNamedRange(const name: PWideChar; var rowFirst, rowLast, colFirst, colLast: Integer; scopeId: Integer; var hidden: boolean): boolean; overload;
    function setNamedRange(const name: PWideChar; rowFirst, rowLast, colFirst, colLast: Integer): boolean; overload;
    function setNamedRange(const name: PWideChar; rowFirst, rowLast, colFirst, colLast, scopeId: Integer): boolean; overload;
    function delNamedRange(const name: PWideChar): boolean; overload;
    function delNamedRange(const name: PWideChar; scopeId: Integer): boolean; overload;

    function namedRangeSize(): Integer;
    function namedRange(index: Integer; var rowFirst, rowLast, colFirst, colLast: Integer): WideString; overload;
    function namedRange(index: Integer; var rowFirst, rowLast, colFirst, colLast, scopeId: Integer): WideString; overload;
    function namedRange(index: Integer; var rowFirst, rowLast, colFirst, colLast, scopeId: Integer; var hidden: boolean): WideString; overload;

    function tableSize(): Integer;
    function table(index: Integer; var rowFirst, rowLast, colFirst, colLast, headerRowCount, totalsRowCount: Integer): WideString;

    function hyperlinkSize(): Integer;
    function hyperlink(index: Integer; var rowFirst, rowLast, colFirst, colLast: Integer): WideString;
    function delHyperlink(index: Integer): boolean;
    procedure addHyperlink(const hyperlink: PWideChar; rowFirst, rowLast, colFirst, colLast: Integer);
    function hyperlinkIndex(row, col: Integer): Integer;

    function isAutoFilter(): boolean;
    function autoFilter(): TXLAutoFilter;
    procedure applyFilter();
    procedure removeFilter();

    procedure setProtect(protect: boolean; const password: PWideChar); overload;
    procedure setProtect(protect: boolean; const password: PWideChar; const prot: EnhancedProtection); overload;

    procedure getTopLeftView(var row, col: Integer);
    procedure setTopLeftView(row, col: Integer);
    procedure setAutoFitArea(rowFirst: Integer; colFirst: Integer; rowLast: Integer; colLast: Integer);

    procedure addrToRowCol(const addr: PWideChar; var row, col: Integer); overload;
    procedure addrToRowCol(const addr: PWideChar; var row, col: Integer; var rowRelative, colRelative: boolean); overload;
    function rowColToAddr(row, col: Integer): WideString; overload;
    function rowColToAddr(row, col: Integer; rowRelative, colRelative: boolean): WideString; overload;

    function tabColor(): Color;
    procedure setTabColor(color: Color); overload;

    function getTabColor(var red, green, blue: Integer): boolean;
    procedure setTabColor(red: Integer; green: Integer; blue: Integer); overload;

    function addIgnoredError(rowFirst: Integer; colFirst: Integer; rowLast: Integer; colLast: Integer; iError: IgnoredError): boolean;

    procedure addDataValidation(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; const value: PWideChar); overload;
    procedure addDataValidation(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; const value1: PWideChar; const value2: PWideChar); overload;
    procedure addDataValidation(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; const value1: PWideChar; const value2: PWideChar;
                                allowBlank: boolean; hideDropDown: boolean; showInputMessage: boolean; showErrorMessage: boolean; const promptTitle: PWideChar; const prompt: PWideChar;
                                const errorTitle: PWideChar; const error: PWideChar; errorStyle: DataValidationErrorStyle); overload;

    procedure addDataValidationDouble(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; value: double); overload;
    procedure addDataValidationDouble(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; value1: double; value2: double); overload;
    procedure addDataValidationDouble(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; value1: double; value2: double;
                                allowBlank: boolean; hideDropDown: boolean; showInputMessage: boolean; showErrorMessage: boolean; const promptTitle: PWideChar; const prompt: PWideChar;
                                const errorTitle: PWideChar; const error: PWideChar; errorStyle: DataValidationErrorStyle); overload;

    procedure removeDataValidations();

    function formControlSize(): Integer;
    function formControl(index: Integer): TXLFormControl;

    function addConditionalFormatting(): TXLConditionalFormatting;

    function getActiveCell(var row, col: Integer): boolean;
    procedure setActiveCell(row, col: Integer);

    function selectionRange(): WideString;
    procedure addSelectionRange(sqref: PWideChar);
    procedure removeSelection();

  published
    constructor Create(handle: SheetHandle; book: BookHandle);
    destructor Destroy; override;
  end;

type
  TArraySheets = array of TXLSheet;

type
  TXLBook = class(TObject)
  private
    handle: BookHandle;

    fonts : TArrayFonts;
    formats: TArrayFormats;
    richStrings: TArrayRichStrings;
    sheets: TArraySheets;
    conditionalFormats: TArrayConditionalFormats;

    procedure Release;

    function GetRefR1C1: boolean;
    procedure SetRefR1C1(const value: boolean);

    function GetDate1904: boolean;
    procedure SetDate1904(const value: boolean);

    function GetTemplate: boolean;
    procedure SetTemplate(const value: boolean);

  public
    function load(filename: PWideChar): boolean; overload;
    function load(filename: PWideChar; tempFile: PWideChar): boolean; overload;
    function loadSheet(filename: PWideChar; sheetIndex: Integer): boolean; overload;
    function loadSheet(filename: PWideChar; sheetIndex: Integer; tempFile: PWideChar): boolean; overload;
    function loadPartially(filename: PWideChar; sheetIndex, firstRow, lastRow: Integer): boolean; overload;
    function loadPartially(filename: PWideChar; sheetIndex, firstRow, lastRow: Integer; tempFile: PWideChar): boolean; overload;
    function loadWithoutEmptyCells(filename: PWideChar): boolean;
    function loadInfo(filename: PWideChar): boolean;

    function save(filename: PWideChar): boolean; overload;
    function save(filename: PWideChar; useTempFile: boolean): boolean; overload;

    function loadRaw(data: PByteArray; size: Cardinal): boolean; overload;
    function loadRaw(data: PByteArray; size: Cardinal; sheetIndex, firstRow, lastRow: Integer): boolean; overload;
    function saveRaw(var Buffer: ByteArray; var size: Cardinal): boolean;

    function addSheet(name: PWideChar): TXLSheet; overload;
    function addSheet(name: PWideChar; initSheet: TXLSheet): TXLSheet; overload;
    function insertSheet(index: Integer; name: PWideChar): TXLSheet; overload;
    function insertSheet(index: Integer; name: PWideChar; initSheet: TXLSheet): TXLSheet; overload;
    function getSheet(index: Integer): TXLSheet;
    function getSheetName(index: Integer): WideString;
    function sheetType(index: Integer): SheetType;
    function moveSheet(srcIndex: Integer; dstIndex: Integer): boolean;
    function delSheet(index: Integer): boolean;
    function sheetCount(): Integer;

    function addFormat(): TXLFormat; overload;
    function addFormat(initFormat: TXLFormat): TXLFormat; overload;
    function addFont(): TXLFont; overload;
    function addFont(initFont: TXLFont): TXLFont; overload;
    function addRichString(): TXLRichString;
    function addCustomNumFormat(customNumFormat: PWideChar): Integer;
    function customNumFormat(fmt: Integer): WideString;

    function format(index: Integer): TXLFormat;
    function formatSize(): Integer;

    function font(index: Integer): TXLFont;
    function fontSize(): Integer;

    function addConditionalFormat(): TXLConditionalFormat;

    function datePack(year: Integer; month: Integer; day: Integer): double; overload;
    function datePack(year: Integer; month: Integer; day: Integer; hour: Integer; min: Integer; sec: Integer): double; overload;
    function datePack(year: Integer; month: Integer; day: Integer; hour: Integer; min: Integer; sec: Integer; msec: Integer): double; overload;

    function dateUnpack(value: double; var year: Integer; var month: Integer; var day: Integer): boolean; overload;
    function dateUnpack(value: double; var year: Integer; var month: Integer; var day: Integer; var hour: Integer; var min: Integer; var sec: Integer): boolean; overload;
    function dateUnpack(value: double; var year: Integer; var month: Integer; var day: Integer; var hour: Integer; var min: Integer; var sec: Integer; var msec: Integer): boolean; overload;

    function colorPack(red: Integer; green: Integer; blue: Integer): Color;
    procedure colorUnpack(color: Color; var red: Integer; var green: Integer; var blue: Integer);

    function activeSheet(): Integer;
    procedure setActiveSheet(index: Integer);

    function pictureSize(): Integer;
    function getPicture(index: Integer; var Buffer: ByteArray; var size: Cardinal): PictureType;

    function addPicture(filename: PWideChar): Integer;
    function addPicture2(data: PByteArray; size: Cardinal): Integer;
    function addPictureAsLink(filename: PWideChar; insert: boolean): Integer;

    function defaultFont(var fontSize: Integer): WideString;
    procedure setDefaultFont(fontName: PWideChar; fontSize: Integer);

    property refR1C1: boolean read GetRefR1C1 write SetRefR1C1;

    procedure setKey(name: PWideChar; key: PWideChar);

    function rgbMode(): boolean;
    procedure setRgbMode(rgbMode: boolean);

    function calcMode(): CalcModeType;
    procedure setCalcMode(calcMode: CalcModeType);

    function version(): Integer;
    function biffVersion(): Integer;

    property date1904: boolean read GetDate1904 write SetDate1904;
    property template: boolean read GetTemplate write SetTemplate;

    function isWriteProtected(): boolean;

    function setLocale(locale: PAnsiChar): boolean;

    function errorMessage(): WideString;

  published
    destructor Destroy; override;
  end;

  TBinBook = class(TXLBook)
  published
    constructor Create;    
  end;

  TXmlBook = class(TXLBook)
  published
    constructor Create;
  end;



implementation

procedure xlAddFont(var fonts: TArrayFonts; font: TXLFont);
begin
  SetLength(fonts, Length(fonts) + 1);
  fonts[High(fonts)] := font;
end;

procedure xlAddFilterColumn(var filterColumns: TArrayFilterColumns; filterColumn: TXLFilterColumn);
begin
  SetLength(filterColumns, Length(filterColumns) + 1);
  filterColumns[High(filterColumns)] := filterColumn;
end;

procedure xlAddFormat(var formats: TArrayFormats; format: TXLFormat);
begin
  SetLength(formats, Length(formats) + 1);
  formats[High(formats)] := format;
end;

procedure xlAddRichString(var richStrings: TArrayRichStrings; richString: TXLRichString);
begin
  SetLength(richStrings, Length(richStrings) + 1);
  richStrings[High(richStrings)] := richString;
end;

procedure xlAddFormControl(var formControls: TArrayFormControls; formControl: TXLFormControl);
begin
  SetLength(formControls, Length(formControls) + 1);
  formControls[High(formControls)] := formControl;
end;

procedure xlAddConditionalFormatting(var conditionalFormattings: TArrayConditionalFormattings; conditionalFormatting: TXLConditionalFormatting);
begin
  SetLength(conditionalFormattings, Length(conditionalFormattings) + 1);
  conditionalFormattings[High(conditionalFormattings)] := conditionalFormatting;
end;

procedure xlAddSheet(var sheets: TArraySheets; sheet: TXLSheet);
begin
  SetLength(sheets, Length(sheets) + 1);
  sheets[High(sheets)] := sheet;
end;

procedure xlAddConditionalFormat(var conditionalFormats: TArrayConditionalFormats; conditionalFormat: TXLConditionalFormat);
begin
  SetLength(conditionalFormats, Length(conditionalFormats) + 1);
  conditionalFormats[High(conditionalFormats)] := conditionalFormat;
end;

////////////////////////////////////////////////////////////////////

procedure TXLConditionalFormatting.addRange(rowFirst, rowLast, colFirst, colLast: Integer);
begin
  xlConditionalFormattingAddRange(handle, rowFirst, rowLast, colFirst, colLast);
end;

procedure TXLConditionalFormatting.addRule(cType: CFormatType; cFormat: TXLConditionalFormat);
begin
  xlConditionalFormattingAddRule(handle, Integer(cType), cFormat.handle, nil, 0);
end;

procedure TXLConditionalFormatting.addRule(cType: CFormatType; cFormat: TXLConditionalFormat; value: PWideChar);
begin
  xlConditionalFormattingAddRule(handle, Integer(cType), cFormat.handle, value, 0);
end;

procedure TXLConditionalFormatting.addRule(cType: CFormatType; cFormat: TXLConditionalFormat; value: PWideChar; stopIfTrue: boolean);
begin
  xlConditionalFormattingAddRule(handle, Integer(cType), cFormat.handle, value, Integer(stopIfTrue));
end;

procedure TXLConditionalFormatting.addTopRule(cFormat: TXLConditionalFormat; value: Integer);
begin
  xlConditionalFormattingAddTopRule(handle, cFormat.handle, value, 0, 0, 0);
end;

procedure TXLConditionalFormatting.addTopRule(cFormat: TXLConditionalFormat; value: Integer; bottom: boolean);
begin
  xlConditionalFormattingAddTopRule(handle, cFormat.handle, value, Integer(bottom), 0, 0);
end;

procedure TXLConditionalFormatting.addTopRule(cFormat: TXLConditionalFormat; value: Integer; bottom, percent: boolean);
begin
  xlConditionalFormattingAddTopRule(handle, cFormat.handle, value, Integer(bottom), Integer(percent), 0);
end;

procedure TXLConditionalFormatting.addTopRule(cFormat: TXLConditionalFormat; value: Integer; bottom, percent, stopIfTrue: boolean);
begin
  xlConditionalFormattingAddTopRule(handle, cFormat.handle, value, Integer(bottom), Integer(percent), Integer(stopIfTrue));
end;

procedure TXLConditionalFormatting.addOpNumRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1: double);
begin
  xlConditionalFormattingAddOpNumRule(handle, Integer(op), cFormat.handle, value1, 0, 0);
end;

procedure TXLConditionalFormatting.addOpNumRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1, value2: double);
begin
  xlConditionalFormattingAddOpNumRule(handle, Integer(op), cFormat.handle, value1, value2, 0);
end;

procedure TXLConditionalFormatting.addOpNumRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1, value2: double; stopIfTrue: boolean);
begin
  xlConditionalFormattingAddOpNumRule(handle, Integer(op), cFormat.handle, value1, value2, Integer(stopIfTrue));
end;

procedure TXLConditionalFormatting.addOpStrRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1: PWideChar);
begin
  xlConditionalFormattingAddOpStrRule(handle, Integer(op), cFormat.handle, value1, nil, 0);
end;

procedure TXLConditionalFormatting.addOpStrRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1, value2: PWideChar);
begin
  xlConditionalFormattingAddOpStrRule(handle, Integer(op), cFormat.handle, value1, value2, 0);
end;

procedure TXLConditionalFormatting.addOpStrRule(op: CFormatOperator; cFormat: TXLConditionalFormat; value1, value2: PWideChar; stopIfTrue: boolean);
begin
  xlConditionalFormattingAddOpStrRule(handle, Integer(op), cFormat.handle, value1, value2, Integer(stopIfTrue));
end;

procedure TXLConditionalFormatting.addAboveAverageRule(cFormat: TXLConditionalFormat);
begin
  xlConditionalFormattingAddAboveAverageRule(handle, cFormat.handle, 1, 0, 0, 0);
end;

procedure TXLConditionalFormatting.addAboveAverageRule(cFormat: TXLConditionalFormat; aboveAverage: boolean);
begin
  xlConditionalFormattingAddAboveAverageRule(handle, cFormat.handle, Integer(aboveAverage), 0, 0, 0);
end;

procedure TXLConditionalFormatting.addAboveAverageRule(cFormat: TXLConditionalFormat; aboveAverage, equalAverage: boolean);
begin
  xlConditionalFormattingAddAboveAverageRule(handle, cFormat.handle, Integer(aboveAverage), Integer(equalAverage), 0, 0);
end;

procedure TXLConditionalFormatting.addAboveAverageRule(cFormat: TXLConditionalFormat; aboveAverage, equalAverage: boolean; stdDev: Integer);
begin
  xlConditionalFormattingAddAboveAverageRule(handle, cFormat.handle, Integer(aboveAverage), Integer(equalAverage), stdDev, 0);
end;

procedure TXLConditionalFormatting.addAboveAverageRule(cFormat: TXLConditionalFormat; aboveAverage, equalAverage: boolean; stdDev: Integer; stopIfTrue: boolean);
begin
  xlConditionalFormattingAddAboveAverageRule(handle, cFormat.handle, Integer(aboveAverage), Integer(equalAverage), stdDev, Integer(stopIfTrue));
end;

procedure TXLConditionalFormatting.addTimePeriodRule(cFormat: TXLConditionalFormat; timePeriod: CFormatTimePeriod);
begin
  xlConditionalFormattingAddTimePeriodRule(handle, cFormat.handle, Integer(timePeriod), 0);
end;

procedure TXLConditionalFormatting.addTimePeriodRule(cFormat: TXLConditionalFormat; timePeriod: CFormatTimePeriod; stopIfTrue: boolean);
begin
  xlConditionalFormattingAddTimePeriodRule(handle, cFormat.handle, Integer(timePeriod), Integer(stopIfTrue));
end;

procedure TXLConditionalFormatting.add2ColorScaleRule(minColor, maxColor: Color);
begin
  xlConditionalFormattingAdd2ColorScaleRule(handle, Integer(minColor), Integer(maxColor), Integer(CFVO_MIN), 0, Integer(CFVO_MAX), 0, 0);
end;

procedure TXLConditionalFormatting.add2ColorScaleRule(minColor, maxColor: Color; minType: CFVOType; minValue: double; maxType: CFVOType; maxValue: double);
begin
  xlConditionalFormattingAdd2ColorScaleRule(handle, Integer(minColor), Integer(maxColor), Integer(minType), minValue, Integer(maxType), maxValue, 0);
end;

procedure TXLConditionalFormatting.add2ColorScaleRule(minColor, maxColor: Color; minType: CFVOType; minValue: double; maxType: CFVOType; maxValue: double; stopIfTrue: boolean);
begin
  xlConditionalFormattingAdd2ColorScaleRule(handle, Integer(minColor), Integer(maxColor), Integer(minType), minValue, Integer(maxType), maxValue, Integer(stopIfTrue));
end;

procedure TXLConditionalFormatting.add2ColorScaleFormulaRule(minColor, maxColor: Color; minType: CFVOType; minValue: PWideChar; maxType: CFVOType; maxValue: PWideChar);
begin
  xlConditionalFormattingAdd2ColorScaleFormulaRule(handle, Integer(minColor), Integer(maxColor), Integer(minType), minValue, Integer(maxType), maxValue, 0);
end;

procedure TXLConditionalFormatting.add2ColorScaleFormulaRule(minColor, maxColor: Color; minType: CFVOType; minValue: PWideChar; maxType: CFVOType; maxValue: PWideChar; stopIfTrue: boolean);
begin
  xlConditionalFormattingAdd2ColorScaleFormulaRule(handle, Integer(minColor), Integer(maxColor), Integer(minType), minValue, Integer(maxType), maxValue, Integer(stopIfTrue));
end;

procedure TXLConditionalFormatting.add3ColorScaleRule(minColor, midColor, maxColor: Color);
begin
  xlConditionalFormattingAdd3ColorScaleRule(handle, Integer(minColor), Integer(midColor), Integer(maxColor), Integer(CFVO_MIN), 0, Integer(CFVO_PERCENTILE), 50, Integer(CFVO_MAX), 0, 0);
end;

procedure TXLConditionalFormatting.add3ColorScaleRule(minColor, midColor, maxColor: Color; minType: CFVOType; minValue: double; midType: CFVOType; midValue: double; maxType: CFVOType; maxValue: double);
begin
  xlConditionalFormattingAdd3ColorScaleRule(handle, Integer(minColor), Integer(midColor), Integer(maxColor), Integer(minType), minValue, Integer(midType), midValue, Integer(maxType), maxValue, 0);
end;

procedure TXLConditionalFormatting.add3ColorScaleRule(minColor, midColor, maxColor: Color; minType: CFVOType; minValue: double; midType: CFVOType; midValue: double; maxType: CFVOType; maxValue: double; stopIfTrue: boolean);
begin
  xlConditionalFormattingAdd3ColorScaleRule(handle, Integer(minColor), Integer(midColor), Integer(maxColor), Integer(minType), minValue, Integer(midType), midValue, Integer(maxType), maxValue, Integer(stopIfTrue));
end;

procedure TXLConditionalFormatting.add3ColorScaleFormulaRule(minColor, midColor, maxColor: Color; minType: CFVOType; minValue: PWideChar; midType: CFVOType; midValue: PWideChar; maxType: CFVOType; maxValue: PWideChar);
begin
  xlConditionalFormattingAdd3ColorScaleFormulaRule(handle, Integer(minColor), Integer(midColor), Integer(maxColor), Integer(minType), minValue, Integer(midType), midValue, Integer(maxType), maxValue, 0);
end;

procedure TXLConditionalFormatting.add3ColorScaleFormulaRule(minColor, midColor, maxColor: Color; minType: CFVOType; minValue: PWideChar; midType: CFVOType; midValue: PWideChar; maxType: CFVOType; maxValue: PWideChar; stopIfTrue: boolean);
begin
  xlConditionalFormattingAdd3ColorScaleFormulaRule(handle, Integer(minColor), Integer(midColor), Integer(maxColor), Integer(minType), minValue, Integer(midType), midValue, Integer(maxType), maxValue, Integer(stopIfTrue));
end;

constructor TXLConditionalFormatting.Create(handle: ConditionalFormattingHandle; book: BookHandle);
begin
  inherited Create;
  self.book := book;
  self.handle := handle;
end;

//////////////////////////////////////////////////

constructor TXLFormControl.Create(handle: FormControlHandle; book: BookHandle);
begin
  inherited Create;
  self.book := book;
  self.handle := handle;
end;

function TXLFormControl.getObjectType(): ObjectType;
begin
  result := LibXL.ObjectType(xlFormControlObjectType(handle));
end;

function TXLFormControl.getChecked(): CheckedType;
begin
  result := LibXL.CheckedType(xlFormControlChecked(handle));
end;

procedure TXLFormControl.setChecked(checked: CheckedType);
begin
  xlFormControlSetChecked(handle, Integer(checked));
end;

function TXLFormControl.getFmlaGroup(): WideString;
begin
  result := WideString(xlFormControlFmlaGroup(handle));
end;

procedure TXLFormControl.setFmlaGroup(fmlaGroup: WideString);
begin
  xlFormControlSetFmlaGroup(handle, PWideChar(fmlaGroup));
end;

function TXLFormControl.getFmlaLink(): WideString;
begin
  result := WideString(xlFormControlFmlaLink(handle));
end;

procedure TXLFormControl.setFmlaLink(fmlaLink: WideString);
begin
  xlFormControlSetFmlaLink(handle, PWideChar(fmlaLink));
end;

function TXLFormControl.getFmlaRange(): WideString;
begin
  result := WideString(xlFormControlFmlaRange(handle));
end;

procedure TXLFormControl.setFmlaRange(fmlaRange: WideString);
begin
  xlFormControlSetFmlaRange(handle, PWideChar(fmlaRange));
end;

function TXLFormControl.getFmlaTxbx(): WideString;
begin
  result := WideString(xlFormControlFmlaTxbx(handle));
end;

procedure TXLFormControl.setFmlaTxbx(fmlaTxbx: WideString);
begin
  xlFormControlSetFmlaTxbx(handle, PWideChar(fmlaTxbx));
end;

function TXLFormControl.getName(): WideString;
begin
  result := WideString(xlFormControlName(handle));
end;

function TXLFormControl.getLinkedCell(): WideString;
begin
  result := WideString(xlFormControlLinkedCell(handle));
end;

function TXLFormControl.getListFillRange(): WideString;
begin
  result := WideString(xlFormControlListFillRange(handle));
end;

function TXLFormControl.getMacro(): WideString;
begin
  result := WideString(xlFormControlMacro(handle));
end;

function TXLFormControl.getAltText(): WideString;
begin
  result := WideString(xlFormControlAltText(handle));
end;

function TXLFormControl.getLocked(): boolean;
begin
  result := xlFormControlLocked(handle) > 0;
end;

function TXLFormControl.getDefaultSize(): boolean;
begin
  result := xlFormControlDefaultSize(handle) > 0;
end;

function TXLFormControl.getPrint(): boolean;
begin
  result := xlFormControlPrint(handle) > 0;
end;

function TXLFormControl.getDisabled(): boolean;
begin
  result := xlFormControlDisabled(handle) > 0;
end;

function TXLFormControl.item(index: Integer): WideString;
begin
  result := WideString(xlFormControlItem(handle));
end;

function TXLFormControl.itemSize(): Integer;
begin
  result := xlFormControlItemSize(handle);
end;

procedure TXLFormControl.addItem(value: PWideChar);
begin
  xlFormControlAddItem(handle, value);
end;

procedure TXLFormControl.insertItem(index: Integer; value: PWideChar);
begin
  xlFormControlInsertItem(handle, index, value);
end;

procedure TXLFormControl.clearItems();
begin
  xlFormControlClearItems(handle);
end;

function TXLFormControl.getDropLines(): Integer;
begin
  result := xlFormControlDropLines(handle);
end;

procedure TXLFormControl.setDropLines(dropLines: Integer);
begin
  xlFormControlSetDropLines(handle, dropLines);
end;

function TXLFormControl.getDx(): Integer;
begin
  result := xlFormControlDx(handle);
end;

procedure TXLFormControl.setDx(dx: Integer);
begin
  xlFormControlSetDx(handle, dx);
end;

function TXLFormControl.getFirstButton(): boolean;
begin
  result := xlFormControlFirstButton(handle) > 0;
end;

procedure TXLFormControl.setFirstButton(firstButton: boolean);
begin
  xlFormControlSetFirstButton(handle, Integer(firstButton));
end;

function TXLFormControl.getHoriz(): boolean;
begin
  result := xlFormControlHoriz(handle) > 0;
end;

procedure TXLFormControl.setHoriz(horiz: boolean);
begin
  xlFormControlSetHoriz(handle, Integer(horiz));
end;

function TXLFormControl.getInc(): Integer;
begin
  result := xlFormControlInc(handle);
end;

procedure TXLFormControl.setInc(inc: Integer);
begin
  xlFormControlSetInc(handle, inc);
end;

function TXLFormControl.getMax(): Integer;
begin
  result := xlFormControlGetMax(handle);
end;

procedure TXLFormControl.setMax(max: Integer);
begin
  xlFormControlSetMax(handle, max);
end;

function TXLFormControl.getMin(): Integer;
begin
  result := xlFormControlGetMin(handle);
end;

procedure TXLFormControl.setMin(min: Integer);
begin
  xlFormControlSetMin(handle, min);
end;

function TXLFormControl.getMultiSel(): WideString;
begin
  result := WideString(xlFormControlMultiSel(handle));
end;

procedure TXLFormControl.setMultiSel(multiSel: WideString);
begin
  xlFormControlSetMultiSel(handle, PWideChar(multiSel));
end;

function TXLFormControl.getSel(): Integer;
begin
  result := xlFormControlSel(handle);
end;

procedure TXLFormControl.setSel(sel: Integer);
begin
  xlFormControlSetSel(handle, sel);
end;

function TXLFormControl.fromAnchor(var col, colOff, row, rowOff: Integer): boolean;
begin
  result := xlFormControlFromAnchor(handle, @col, @colOff, @row, @rowOff) > 0;
end;

function TXLFormControl.toAnchor(var col, colOff, row, rowOff: Integer): boolean;
begin
  result := xlFormControlToAnchor(handle, @col, @colOff, @row, @rowOff) > 0;
end;

/////////////////////////////////////////////////////////////////////

constructor TXLRichString.Create(handle: RichStringHandle; book: BookHandle);
begin
  inherited Create;
  self.book := book;
  self.handle := handle;
end;

destructor TXLRichString.Destroy;
var
  i : Integer;
begin
  for i := 0 to High(fonts) do fonts[i].Destroy;
  inherited Destroy;
end;

function TXLRichString.addFont(): TXLFont;
var
  fntHandle: FontHandle;
begin
  fntHandle := xlRichStringAddFont(handle, nil);
  if fntHandle <> nil then
  begin
    result := TXLFont.Create(fntHandle, handle);
    xlAddFont(fonts, result);
  end
  else
    result := nil;
end;

function TXLRichString.addFont(initFont: TXLFont): TXLFont;
var
  fntHandle: FontHandle;
begin
  fntHandle := xlRichStringAddFont(handle, initFont.handle);
  if fntHandle <> nil then
  begin
    result := TXLFont.Create(fntHandle, handle);
    xlAddFont(fonts, result);
  end
  else
    result := nil;
end;

procedure TXLRichString.addText(const text: PWideChar);
begin
   xlRichStringAddText(handle, text, nil);
end;

procedure TXLRichString.addText(const text: PWideChar; font: TXLFont);
begin
   xlRichStringAddText(handle, text, font.handle);
end;

function TXLRichString.getText(index: Integer): WideString;
var
   fntHandle: FontHandle;
begin
   result := WideString(xlRichStringGetText(handle, index, @fntHandle));
end;

function TXLRichString.getText(index: Integer; var font: TXLFont): WideString;
var
   fntHandle: FontHandle;
   ret: WideString;
begin
   ret := WideString(xlRichStringGetText(handle, index, @fntHandle));
   if fntHandle <> nil then
   begin
       font := TXLFont.Create(fntHandle, book);
       xlAddFont(fonts, font);
   end;
   result := ret;
end;

function TXLRichString.textSize(): Integer;
begin
  result := xlRichStringTextSize(handle);
end;

////////////////////////////////////////////////////////////////////////////////

constructor TXLFilterColumn.Create(handle: FilterColumnHandle; book: BookHandle);
begin
  inherited Create;
  self.book := book;
  self.handle := handle;
end;

destructor TXLFilterColumn.Destroy;
begin
  inherited Destroy;
end;

function TXLFilterColumn.index(): Integer;
begin
  result := xlFilterColumnIndex(handle);
end;

function TXLFilterColumn.filterType(): Filter;
begin
  result := LibXL.Filter(xlFilterColumnFilterType(handle));
end;

function TXLFilterColumn.filterSize(): Integer;
begin
  result := xlFilterColumnFilterSize(handle);
end;

function TXLFilterColumn.filter(index: Integer): PWideChar;
begin
  result := xlFilterColumnFilter(handle, index);
end;

procedure TXLFilterColumn.addFilter(const value: PWideChar);
begin
  xlFilterColumnAddFilter(handle, value);
end;

function TXLFilterColumn.getTop10(var value: double; var top, percent: boolean): boolean;
var
  iTop, iPercent: Integer;
begin
  result := xlFilterColumnGetTop10(handle, @value, @iTop, @iPercent) > 0;
  top := iTop > 0;
  percent := iPercent > 0;
end;

procedure TXLFilterColumn.setTop10(value: double);
begin
  xlFilterColumnSetTop10(handle, value, 1, 0);
end;

procedure TXLFilterColumn.setTop10(value: double; top: boolean);
begin
  xlFilterColumnSetTop10(handle, value, Integer(top), 0);
end;

procedure TXLFilterColumn.setTop10(value: double; top, percent: boolean);
begin
  xlFilterColumnSetTop10(handle, value, Integer(top), Integer(percent));
end;

function TXLFilterColumn.getCustomFilter(var op1: Op; var v1: PWideChar; var op2: Op; var v2: PWideChar; var andOp: boolean): boolean;
var
  iOp1, iOp2, iAndOp: Integer;
begin
  result := xlFilterColumnGetCustomFilter(handle, @iOp1, @v1, @iOp2, @v2, @iAndOp) > 0;
  op1 := Op(iOp1);
  op2 := Op(iOp2);
  andOp := iAndOp > 0;
end;

procedure TXLFilterColumn.setCustomFilter(op: Op; const v: PWideChar);
begin
  xlFilterColumnSetCustomFilter(handle, Integer(op), v);
end;

procedure TXLFilterColumn.setCustomFilter(op1: Op; const v1: PWideChar; op2: Op; const v2: PWideChar; andOp: boolean);
begin
  xlFilterColumnSetCustomFilterEx(handle, Integer(op1), v1, Integer(op2), v2, Integer(andOp));
end;

procedure TXLFilterColumn.clear();
begin
  xlFilterColumnClear(handle);
end;

constructor TXLAutoFilter.Create(handle: AutoFilterHandle; book: BookHandle);
begin
  inherited Create;
  self.book := book;
  self.handle := handle;
end;

destructor TXLAutoFilter.Destroy;
var
  i : Integer;
begin
  for i := 0 to High(filterColumns) do filterColumns[i].Destroy;
  inherited Destroy;
end;

function TXLAutoFilter.getRef(var rowFirst, rowLast, colFirst, colLast: Integer): boolean;
begin
  result := xlAutoFilterGetRef(handle, @rowFirst, @rowLast, @colFirst, @colLast) > 0;
end;

procedure TXLAutoFilter.setRef(rowFirst, rowLast, colFirst, colLast: Integer);
begin
  xlAutoFilterSetRef(handle, rowFirst, rowLast, colFirst, colLast);
end;

function TXLAutoFilter.column(colId: Integer): TXLFilterColumn;
var
  fcHandle: FilterColumnHandle;
begin
  fcHandle := xlAutoFilterColumn(handle, colId);
  result := TXLFilterColumn.Create(fcHandle, book);
 // filterColumns := filterColumns + [result];
  xlAddFilterColumn(filterColumns, result);
end;

function TXLAutoFilter.columnSize(): Integer;
begin
  result := xlAutoFilterColumnSize(handle);
end;

function TXLAutoFilter.columnByIndex(index: Integer): TXLFilterColumn;
var
  fcHandle:  FilterColumnHandle;
begin
  fcHandle := xlAutoFilterColumnByIndex(handle, index);
  result := TXLFilterColumn.Create(fcHandle, book);
//  filterColumns := filterColumns + [result];
  xlAddFilterColumn(filterColumns, result);
end;

function TXLAutoFilter.getSortRange(var rowFirst, rowLast, colFirst, colLast: Integer): boolean;
begin
  result := xlAutoFilterGetSortRange(handle, @rowFirst, @rowLast, @colFirst, @colLast) > 0;
end;

function TXLAutoFilter.getSort(var columnIndex: Integer; var descending: boolean): boolean;
var
  iDescending: Integer;
begin
  result := xlAutoFilterGetSort(handle, @columnIndex, @iDescending) > 0;
  descending := iDescending > 0;
end;

function TXLAutoFilter.setSort(columnIndex: Integer; descending: boolean): boolean;
begin
  result := xlAutoFilterSetSort(handle, columnIndex, Integer(descending)) > 0;
end;

function TXLAutoFilter.addSort(columnIndex: Integer; descending: boolean): boolean;
begin
  result := xlAutoFilterAddSort(handle, columnIndex, Integer(descending)) > 0;
end;

constructor TXLFont.Create(handle: FontHandle; book: BookHandle);
begin
  inherited Create;
  self.book := book;
  self.handle := handle;
end;

destructor TXLFont.Destroy;
begin
  inherited Destroy;
end;

function TXLFont.Getbold: boolean;
begin
  result := (xlFontBold(handle) > 0);
end;

procedure TXLFont.Setbold(const value: boolean);
begin
  xlFontSetBold(handle, Integer(value));
end;

function TXLFont.GetName: WideString;
begin
  result := WideString(xlFontName(handle));
end;

procedure TXLFont.SetName(const value: WideString);
begin
  xlFontSetName(handle, @(value[1]));  
end;

function TXLFont.Getsize: Integer;
begin
  result := xlFontSize(handle);
end;

procedure TXLFont.Setsize(const value: Integer);
begin
  xlFontSetSize(handle, value);
end;

function TXLFont.GetUnderline: Underline;
begin
  result := LibXL.Underline(xlFontUnderline(handle));
end;

procedure TXLFont.SetUnderline(const value: LibXL.Underline);
begin
  xlFontSetUnderline(handle, Integer(value));
end;

function TXLFont.Getcolor: Color;
begin
  result := LibXL.Color(xlFontColor(handle));
end;

procedure TXLFont.Setcolor(const value: Color);
begin
  xlFontSetColor(handle, Integer(value));
end;

procedure TXLFont.Setitalic(const value: boolean);
begin
  xlFontSetItalic(handle, Integer(value));
end;

function TXLFont.Getitalic: boolean;
begin
  result := (xlFontItalic(handle) > 0);
end;

procedure TXLFont.Setscript(const value: Script);
begin
  xlFontSetScript(handle, Integer(value));
end;

function TXLFont.Getscript: Script;
begin
  result := LibXL.Script(xlFontScript(handle));
end;

procedure TXLFont.SetstrikeOut(const value: boolean);
begin
  xlFontSetStrikeOut(handle, Integer(value));
end;

function TXLFont.GetstrikeOut: boolean;
begin
  result := (xlFontStrikeOut(handle) > 0);
end;

constructor TXLFormat.Create(handle: FormatHandle; book: BookHandle);
begin
  inherited Create;
  self.book := book;
  self.handle := handle;
end;

destructor TXLFormat.Destroy;
begin
  if ffont <> nil then ffont.Destroy;
  inherited Destroy;
end;

procedure TXLFormat.SetborderDiagonal(const value: BorderDiagonal);
begin
  xlFormatSetBorderDiagonal(handle, Integer(value));
end;

procedure TXLFormat.SetBorderDiagonalStyle(const value: BorderStyle);
begin
  xlFormatSetBorderDiagonalStyle(handle, Integer(value));
end;

procedure TXLFormat.SetborderDiagonalColor(const value: Color);
begin
  xlFormatSetBorderDiagonalColor(handle, Integer(value));
end;

procedure TXLFormat.SetborderLeft(const value: BorderStyle);
begin
  xlFormatSetBorderLeft(handle, Integer(value));
end;

procedure TXLFormat.SetborderLeftColor(const value: Color);
begin
  xlFormatSetBorderLeftColor(handle, Integer(value));
end;

procedure TXLFormat.SetborderRight(const value: BorderStyle);
begin
  xlFormatSetBorderRight(handle, Integer(value));
end;

procedure TXLFormat.SetborderRightColor(const value: Color);
begin
  xlFormatSetBorderRightColor(handle, Integer(value));
end;

procedure TXLFormat.SetborderTop(const value: BorderStyle);
begin
  xlFormatSetBorderTop(handle, Integer(value));
end;

procedure TXLFormat.SetborderTopColor(const value: Color);
begin
  xlFormatSetBorderTopColor(handle, Integer(value));
end;

procedure TXLFormat.SetfillPattern(const value: FillPattern);
begin
  xlFormatSetFillPattern(handle, Integer(value));
end;

procedure TXLFormat.Setfont(const value: TXLFont);
begin
  xlFormatSetFont(handle, value.handle);
end;

function TXLFormat.GetalignH: AlignH;
begin
  result := LibXL.AlignH(xlFormatAlignH(handle));
end;

function TXLFormat.GetAlignV: AlignV;
begin
  result := LibXL.AlignV(xlFormatAlignV(handle));
end;

function TXLFormat.GetborderBottom: BorderStyle;
begin
  result := BorderStyle(xlFormatBorderBottom(handle));
end;

function TXLFormat.GetborderBottomColor: Color;
begin
  result := Color(xlFormatBorderBottomColor(handle));
end;

function TXLFormat.GetborderDiagonal: BorderDiagonal;
begin
  result := LibXL.BorderDiagonal(xlFormatBorderDiagonal(handle));
end;

function TXLFormat.GetBorderDiagonalStyle: BorderStyle;
begin
  result := LibXL.BorderStyle(xlFormatBorderDiagonalStyle(handle));
end;

function TXLFormat.GetborderDiagonalColor: Color;
begin
  result := Color(xlFormatBorderDiagonalColor(handle));
end;

function TXLFormat.GetborderLeft: BorderStyle;
begin
  result := BorderStyle(xlFormatBorderLeft(handle));
end;

function TXLFormat.GetborderLeftColor: Color;
begin
  result := Color(xlFormatBorderLeftColor(handle));
end;

function TXLFormat.GetborderRight: BorderStyle;
begin
  result := BorderStyle(xlFormatBorderRight(handle));
end;

function TXLFormat.GetborderRightColor: Color;
begin
  result := Color(xlFormatBorderRightColor(handle));
end;

function TXLFormat.GetborderTop: BorderStyle;
begin
  result := BorderStyle(xlFormatBorderTop(handle));
end;

function TXLFormat.GetborderTopColor: Color;
begin
  result := Color(xlFormatBorderTopColor(handle));
end;

function TXLFormat.GetfillPattern: FillPattern;
begin
  result := LibXL.FillPattern(xlFormatFillPattern(handle));
end;

procedure TXLFormat.Sethidden(const value: boolean);
begin
  xlFormatSetHidden(handle, Integer(value));
end;

procedure TXLFormat.Setindent(const value: Integer);
begin
  xlFormatSetIndent(handle, Integer(value));
end;

procedure TXLFormat.Setlocked(const value: boolean);
begin
  xlFormatSetLocked(handle, Integer(value));
end;

function TXLFormat.Getfont: TXLFont;
var
  f: FontHandle;
begin
  f := xlFormatFont(handle);
  if f <> nil then
  begin
    result := TXLFont.Create(f, book);
    ffont := result;
  end
  else
    result := nil;
end;

function TXLFormat.Gethidden: boolean;
begin
  result := (xlFormatHidden(handle) > 0);
end;

function TXLFormat.Getindent: Integer;
begin
  result := (xlFormatIndent(handle));
end;

function TXLFormat.Getlocked: boolean;
begin
  result := (xlFormatLocked(handle) > 0);
end;

function TXLFormat.GetpatternBackgroundColor: Color;
begin
  result := Color(xlFormatPatternBackgroundColor(handle));
end;

function TXLFormat.GetpatternForegroundColor: Color;
begin
  result := Color(xlFormatPatternForegroundColor(handle));
end;

function TXLFormat.Getrotation: Integer;
begin
  result := xlFormatRotation(handle);
end;

function TXLFormat.GetshrinkToFit: boolean;
begin
  result := (xlFormatShrinkToFit(handle) > 0);
end;

function TXLFormat.Getwrap: boolean;
begin
  result := (xlFormatWrap(handle) > 0);
end;

function TXLFormat.NumFormat: Integer;
begin
  result := xlFormatNumFormat(handle);
end;

procedure TXLFormat.SetalignH(const value: AlignH);
begin
  xlFormatSetAlignH(handle, Integer(value));
end;

procedure TXLFormat.SetAlignV(const value: AlignV);
begin
  xlFormatSetAlignV(handle, Integer(value));
end;

procedure TXLFormat.setNumFormat(NumFormat: Integer);
begin
  xlFormatSetNumFormat(handle, NumFormat);
end;

procedure TXLFormat.setNumFormat(value: NumFormat);
begin
  xlFormatSetNumFormat(handle, Integer(value));
end;

procedure TXLFormat.SetpatternBackgroundColor(const value: Color);
begin
  xlFormatSetPatternBackgroundColor(handle, Integer(value));
end;

procedure TXLFormat.SetpatternForegroundColor(const value: Color);
begin
  xlFormatSetPatternForegroundColor(handle, Integer(value));
end;

procedure TXLFormat.Setrotation(const value: Integer);
begin
  xlFormatSetRotation(handle, value);
end;

procedure TXLFormat.SetshrinkToFit(const value: boolean);
begin
  xlFormatSetShrinkToFit(handle, Integer(value));
end;

procedure TXLFormat.Setwrap(const value: boolean);
begin
  xlFormatSetWrap(handle, Integer(value));
end;

procedure TXLFormat.setBorder(style: BorderStyle);
begin
  xlFormatSetBorder(handle, Integer(style));
end;

procedure TXLFormat.SetborderBottom(const value: BorderStyle);
begin
  xlFormatSetBorderBottom(handle, Integer(value));
end;

procedure TXLFormat.SetborderBottomColor(const value: Color);
begin
  xlFormatSetBorderBottomColor(handle, Integer(value));
end;

procedure TXLFormat.setBorderColor(value: Color);
begin
  xlFormatSetBorderColor(handle, Integer(value));
end;


//////////////////////

constructor TXLConditionalFormat.Create(handle: ConditionalFormatHandle; book: BookHandle);
begin
  inherited Create;
  self.book := book;
  self.handle := handle;
end;

destructor TXLConditionalFormat.Destroy;
begin
  if ffont <> nil then ffont.Destroy;
  inherited Destroy;
end;

function TXLConditionalFormat.Getfont: TXLFont;
var
  f: FontHandle;
begin
  f := xlConditionalFormatFont(handle);
  if f <> nil then
  begin
    result := TXLFont.Create(f, book);
    ffont := result;
  end
  else
    result := nil;
end;

function TXLConditionalFormat.numFormat(): NumFormat;
begin
  result := LibXL.NumFormat(xlConditionalFormatNumFormat(handle));
end;

procedure TXLConditionalFormat.setNumFormat(numFormat: NumFormat);
begin
  xlConditionalFormatSetNumFormat(handle, Integer(numFormat));
end;

function TXLConditionalFormat.customNumFormat(): WideString;
begin
  result := WideString(xlConditionalFormatCustomNumFormat(handle));
end;

procedure TXLConditionalFormat.setCustomNumFormat(customNumFormat: PWideChar);
begin
  xlConditionalFormatSetCustomNumFormat(handle, customNumFormat);
end;

procedure TXLConditionalFormat.setBorder(style: BorderStyle);
begin
  xlConditionalFormatSetBorder(handle, Integer(style));
end;

procedure TXLConditionalFormat.setBorderColor(color: Color);
begin
  xlConditionalFormatSetBorderColor(handle, Integer(color));
end;

procedure TXLConditionalFormat.SetborderLeftCond(const value: BorderStyle);
begin
  xlConditionalFormatSetBorderLeft(handle, Integer(value));
end;

function TXLConditionalFormat.GetborderLeftCond: BorderStyle;
begin
  result := LibXL.BorderStyle(xlConditionalFormatBorderLeft(handle));
end;

procedure TXLConditionalFormat.SetborderRightCond(const value: BorderStyle);
begin
  xlConditionalFormatSetBorderRight(handle, Integer(value));
end;

function TXLConditionalFormat.GetborderRightCond: BorderStyle;
begin
  result := LibXL.BorderStyle(xlConditionalFormatBorderRight(handle));
end;

procedure TXLConditionalFormat.SetborderTopCond(const value: BorderStyle);
begin
  xlConditionalFormatSetBorderTop(handle, Integer(value));
end;

function TXLConditionalFormat.GetborderTopCond: BorderStyle;
begin
  result := LibXL.BorderStyle(xlConditionalFormatBorderTop(handle));
end;

procedure TXLConditionalFormat.SetborderBottomCond(const value: BorderStyle);
begin
  xlConditionalFormatSetBorderBottom(handle, Integer(value));
end;

function TXLConditionalFormat.GetborderBottomCond: BorderStyle;
begin
  result := LibXL.BorderStyle(xlConditionalFormatBorderBottom(handle));
end;

procedure TXLConditionalFormat.SetborderLeftColorCond(const value: Color);
begin
  xlConditionalFormatSetBorderLeftColor(handle, Integer(value));
end;

function TXLConditionalFormat.GetborderLeftColorCond: Color;
begin
  result := LibXL.Color(xlConditionalFormatBorderLeftColor(handle));
end;

procedure TXLConditionalFormat.SetborderRightColorCond(const value: Color);
begin
  xlConditionalFormatSetBorderRightColor(handle, Integer(value));
end;

function TXLConditionalFormat.GetborderRightColorCond: Color;
begin
  result := LibXL.Color(xlConditionalFormatBorderRightColor(handle));
end;

procedure TXLConditionalFormat.SetborderTopColorCond(const value: Color);
begin
  xlConditionalFormatSetBorderTopColor(handle, Integer(value));
end;

function TXLConditionalFormat.GetborderTopColorCond: Color;
begin
  result := LibXL.Color(xlConditionalFormatBorderTopColor(handle));
end;

procedure TXLConditionalFormat.SetborderBottomColorCond(const value: Color);
begin
  xlConditionalFormatSetBorderBottomColor(handle, Integer(value));
end;

function TXLConditionalFormat.GetborderBottomColorCond: Color;
begin
  result := LibXL.Color(xlConditionalFormatBorderBottomColor(handle));
end;

procedure TXLConditionalFormat.SetfillPatternCond(const value: FillPattern);
begin
  xlConditionalFormatSetFillPattern(handle, Integer(value));
end;

function TXLConditionalFormat.GetfillPatternCond: FillPattern;
begin
  result := LibXL.FillPattern(xlConditionalFormatFillPattern(handle));
end;

procedure TXLConditionalFormat.SetpatternForegroundColorCond(const value: Color);
begin
  xlConditionalFormatSetPatternForegroundColor(handle, Integer(value));
end;

function TXLConditionalFormat.GetpatternForegroundColorCond: Color;
begin
  result := LibXL.Color(xlConditionalFormatPatternForegroundColor(handle));
end;

procedure TXLConditionalFormat.SetpatternBackgroundColorCond(const value: Color);
begin
  xlConditionalFormatSetPatternBackgroundColor(handle, Integer(value));
end;

function TXLConditionalFormat.GetpatternBackgroundColorCond: Color;
begin
  result := LibXL.Color(xlConditionalFormatPatternBackgroundColor(handle));
end;

//////////////////////////////////////////////////////////

constructor TXLSheet.Create(handle: SheetHandle; book: BookHandle);
begin
  inherited Create;
  self.book := book;
  self.handle := handle;
end;

destructor TXLSheet.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(richStrings) do richStrings[i].Destroy;
  for i := 0 to High(formats) do formats[i].Destroy;
  for i := 0 to High(formControls) do formControls[i].Destroy;
  if xlAutoFilter <> nil then xlAutoFilter.Destroy;
  inherited Destroy;
end;

function TXLSheet.ErrorMessage: WideString;
begin
  result := WideString(xlBookErrorMessage(book));
end;

function TXLSheet.getCellType(row, col: Integer): CellType;
begin
  result := CellType(xlSheetCellType(handle, row, col));
end;

function TXLSheet.cellFormat(row, col: Integer): TXLFormat;
begin
  result := TXLFormat.Create(xlSheetCellFormat(handle, row, col), book);
  xlAddFormat(formats, result);
end;

procedure TXLSheet.setCellFormat(row: Integer; col: Integer; format: TXLFormat);
begin
  xlSheetSetCellFormat(handle, row, col, format.handle);
end;

function TXLSheet.isFormula(row, col: Integer): boolean;
var
  res: Integer;
begin
  res := xlSheetIsFormula(handle, row, col);
  if res > 0 then
    result := true
  else
    result := false;
end;

function TXLSheet.readStr(row, col: Integer): WideString;
var
  format: FormatHandle;
  s: PWideChar;
begin
  s := xlSheetReadStr(handle, row, col, @format);
  if s <> nil then
    result := WideString(s)
  else
    result := '';
end;

function TXLSheet.readStr(row, col: Integer; var format: TXLFormat): WideString;
var
  fmtHandle: FormatHandle;
  s: PWideChar;
begin
  s := xlSheetReadStr(handle, row, col, @fmtHandle);
  if s <> nil then
  begin
    if fmtHandle <> nil then
    begin
      format := TXLFormat.Create(fmtHandle, book);
      xlAddFormat(formats, format);
    end
    else
      format := nil;
    result := WideString(s)
  end
  else
    result := '';
end;

function TXLSheet.writeStr(row, col: Integer; value: PWideChar): boolean;
begin
  result := xlSheetWriteStr(handle, row, col, value, nil) > 0;
end;

function TXLSheet.writeStr(row, col: Integer; value: PWideChar; format: TXLFormat): boolean;
begin
  result := xlSheetWriteStr(handle, row, col, value, format.handle) > 0;
end;

function TXLSheet.readRichStr(row: Integer; col: Integer): TXLRichString;
var
  richString: RichStringHandle;
  format: FormatHandle;
begin
  richString := xlSheetReadRichStr(handle, row, col, @format);
  if richString <> nil then
  begin
    result := TXLRichString.Create(richString, handle);
    xlAddRichString(richStrings, result);
  end
  else
    result := nil;
end;

function TXLSheet.readRichStr(row: Integer; col: Integer; var format: TXLFormat): TXLRichString;
var
  richString: RichStringHandle;
begin
  richString := xlSheetReadRichStr(handle, row, col, @format.handle);
  if richString <> nil then
  begin
    result := TXLRichString.Create(richString, handle);
    xlAddRichString(richStrings, result);
  end
  else
    result := nil;
end;

function TXLSheet.writeRichStr(row: Integer; col: Integer; value: TXLRichString): boolean;
begin
  result := xlSheetWriteRichStr(handle, row, col, value.handle, nil) > 0;
end;

function TXLSheet.writeRichStr(row: Integer; col: Integer; value: TXLRichString; format: TXLFormat): boolean;
begin
  result := xlSheetWriteRichStr(handle, row, col, value.handle, format.handle) > 0;
end;

function TXLSheet.readNum(row, col: Integer): double;
var
  format: FormatHandle;
begin
  result := xlSheetReadNum(handle, row, col, @format);
end;

function TXLSheet.readNum(row, col: Integer; var format: TXLFormat): double;
var
  fmtHandle: FormatHandle;
begin
  result := xlSheetReadNum(handle, row, col, @fmtHandle);
  if fmtHandle <> nil then
  begin
    format := TXLFormat.Create(fmtHandle, book);
    xlAddFormat(formats, format);
  end
  else
    format := nil;
end;

function TXLSheet.writeNum(row, col: Integer; value: double): boolean;
begin
  result := xlSheetWriteNum(handle, row, col, value, nil) > 0;
end;

function TXLSheet.writeNum(row, col: Integer; value: double; format: TXLFormat): boolean;
begin
  result := xlSheetWriteNum(handle, row, col, value, format.handle) > 0;
end;

function TXLSheet.readBool(row, col: Integer): boolean;
var
  format: FormatHandle;
  res: Integer;
begin
  res := xlSheetReadBool(handle, row, col, @format);
  if res > 0 then
    result := true
  else
    result := false;
end;

function TXLSheet.readBool(row, col: Integer; var format: TXLFormat): boolean;
var
  fmtHandle: FormatHandle;
  res: Integer;
begin
  res := xlSheetReadBool(handle, row, col, @fmtHandle);
  if fmtHandle <> nil then
  begin
    format := TXLFormat.Create(fmtHandle, book);
    xlAddFormat(formats, format);
  end
  else
    format := nil;
  if res > 0 then
    result := true
  else
    result := false;
end;

function TXLSheet.writeBool(row, col: Integer; value: boolean): boolean;
begin
  result := xlSheetWriteBool(handle, row, col, Integer(value), nil) > 0;
end;

function TXLSheet.writeBool(row, col: Integer; value: boolean; format: TXLFormat): boolean;
begin
  result := xlSheetWriteBool(handle, row, col, Integer(value), format.handle) > 0;
end;

function TXLSheet.readBlank(row, col: Integer; var format: TXLFormat): boolean;
var
  fmtHandle: FormatHandle;
begin
  result := xlSheetReadBlank(handle, row, col, @fmtHandle) > 0;
  if fmtHandle <> nil then
  begin
    format := TXLFormat.Create(fmtHandle, book);
    xlAddFormat(formats, format);
  end
  else
    format := nil;  
end;

function TXLSheet.writeBlank(row, col: Integer; format: TXLFormat): boolean;
begin
  result := xlSheetWriteBlank(handle, row, col, format.handle) > 0;
end;

function TXLSheet.readFormula(row, col: Integer): WideString;
var
  format: FormatHandle;
  s: PWideChar;
begin
  s := xlSheetReadFormula(handle, row, col, @format);
  if s <> nil then
    result := WideString(s)
  else
    result := '';
end;

function TXLSheet.readFormula(row, col: Integer; var format: TXLFormat): WideString;
var
  fmtHandle: FormatHandle;
  s: PWideChar;
begin
  s := xlSheetReadFormula(handle, row, col, @fmtHandle);
  if s <> nil then
  begin
    if fmtHandle <> nil then
    begin
      format := TXLFormat.Create(fmtHandle, book);
      xlAddFormat(formats, format);
    end
    else
      format := nil;
    result := WideString(s);
  end
  else
    result := '';
end;

function TXLSheet.writeFormula(row, col: Integer; value: PWideChar): boolean;
begin
  result := xlSheetWriteFormula(handle, row, col, value, nil) > 0;
end;

function TXLSheet.writeFormula(row, col: Integer; value: PWideChar; format: TXLFormat): boolean;
begin
  result := xlSheetWriteFormula(handle, row, col, value, format.handle) > 0;
end;

function TXLSheet.writeFormulaNum(row, col: Integer; expr: PWideChar; value: double): boolean;
begin
  result := xlSheetWriteFormulaNum(handle, row, col, expr, value, nil) > 0;
end;

function TXLSheet.writeFormulaNum(row, col: Integer; expr: PWideChar; value: double; format: TXLFormat): boolean;
begin
  result := xlSheetWriteFormulaNum(handle, row, col, expr, value, format.handle) > 0;
end;

function TXLSheet.writeFormulaStr(row, col: Integer; expr: PWideChar; value: PWideChar): boolean;
begin
  result := xlSheetWriteFormulaStr(handle, row, col, expr, value, nil) > 0;
end;

function TXLSheet.writeFormulaStr(row, col: Integer; expr: PWideChar; value: PWideChar; format: TXLFormat): boolean;
begin
  result := xlSheetWriteFormulaStr(handle, row, col, expr, value, format.handle) > 0;
end;

function TXLSheet.writeFormulaBool(row, col: Integer; expr: PWideChar; value: Integer): boolean;
begin
  result := xlSheetWriteFormulaBool(handle, row, col, expr, value, nil) > 0;
end;

function TXLSheet.writeFormulaBool(row, col: Integer; expr: PWideChar; value: Integer; format: TXLFormat): boolean;
begin
  result := xlSheetWriteFormulaBool(handle, row, col, expr, value, format.handle) > 0;
end;

function TXLSheet.readComment(row, col: Integer): WideString;
var
  s: PWideChar;
begin
  s := xlSheetReadComment(handle, row, col);
  if s <> nil then
    result := WideString(s)
  else
    result := '';
end;

procedure TXLSheet.writeComment(row, col: Integer; value, author: PWideChar; width, height: Integer);
begin
  xlSheetWriteComment(handle, row, col, value, author, width, height);
end;

procedure TXLSheet.removeComment(row, col: Integer);
begin
  xlSheetRemoveComment(handle, row, col);
end;

function TXLSheet.isDate(row, col: Integer): boolean;
begin
  if xlSheetIsDate(handle, row, col) > 0 then
    result := true
  else
    result := false;
end;

function TXLSheet.isRichStr(row, col: Integer): boolean;
begin
  if xlSheetIsRichStr(handle, row, col) > 0 then
    result := true
  else
    result := false;
end;


function TXLSheet.readError(row, col: Integer): ErrorType;
begin
  result := ErrorType(xlSheetReadError(handle, row, col));
end;

procedure TXLSheet.writeError(row, col: Integer; error: ErrorType);
begin
  xlSheetWriteError(handle, row, col, Integer(error), nil);
end;

procedure TXLSheet.writeError(row, col: Integer; error: ErrorType; format: TXLFormat);
begin
  xlSheetWriteError(handle, row, col, Integer(error), format.handle);
end;

function TXLSheet.colWidth(col: Integer): double;
begin
  result := xlSheetColWidth(handle, col);
end;

function TXLSheet.rowHeight(col: Integer): double;
begin
  result := xlSheetRowHeight(handle, col);
end;

function TXLSheet.colWidthPx(col: Integer): Integer;
begin
  result := xlSheetColWidthPx(handle, col);
end;

function TXLSheet.rowHeightPx(col: Integer): Integer;
begin
  result := xlSheetRowHeightPx(handle, col);
end;

function TXLSheet.setCol(col: Integer; width: double; format: TXLFormat): boolean;
begin
  result := setCol(col, col, width, format);
end;

function TXLSheet.setCol(colFirst, colLast: Integer; width: double): boolean;
begin
  result := xlSheetSetCol(handle, colFirst, colLast, width, nil, 0) > 0;
end;

function TXLSheet.setCol(col: Integer; width: double): boolean;
begin
  result := setCol(col, col, width);
end;

function TXLSheet.setCol(colFirst, colLast: Integer; width: double; format: TXLFormat; hidden: boolean): boolean;
var
  fmtHandle: FormatHandle;
begin
  if format <> nil then
    fmtHandle := format.handle
  else
    fmtHandle := nil;
  result := xlSheetSetCol(handle, colFirst, colLast, width, fmtHandle, Integer(hidden)) > 0;
end;

function TXLSheet.setCol(col: Integer; width: double; format: TXLFormat; hidden: boolean): boolean;
begin
  result := setCol(col, col, width, format, hidden);
end;

function TXLSheet.setCol(colFirst, colLast: Integer; width: double; format: TXLFormat): boolean;
var
  fmtHandle: FormatHandle;
begin
  if format <> nil then
    fmtHandle := format.handle
  else
    fmtHandle := nil;
  result := xlSheetSetCol(handle, colFirst, colLast, width, fmtHandle, 0) > 0;
end;

function TXLSheet.setRow(row: Integer; height: double): boolean;
begin
  result := xlSheetSetRow(handle, row, height, nil, 0) > 0;
end;

function TXLSheet.setRow(row: Integer; height: double; format: TXLFormat): boolean;
begin
  result := xlSheetSetRow(handle, row, height, format.handle, 0) > 0;
end;

function TXLSheet.setRow(row: Integer; height: double; format: TXLFormat; hidden: boolean): boolean;
var
  fmtHandle: FormatHandle;
begin
  if format <> nil then
    fmtHandle := format.handle
  else
    fmtHandle := nil;
  result := xlSheetSetRow(handle, row, height, fmtHandle, Integer(hidden)) > 0;
end;

function TXLSheet.rowHidden(row: Integer): boolean;
begin
  result := xlSheetRowHidden(handle, row) > 0;
end;

function TXLSheet.setRowHidden(row: Integer; hidden: boolean): boolean;
begin
  result := xlSheetSetRowHidden(handle, row, Integer(hidden)) > 0;
end;

function TXLSheet.colHidden(col: Integer): boolean;
begin
  result := xlSheetColHidden(handle, col) > 0;
end;

function TXLSheet.setColHidden(col: Integer; hidden: boolean): boolean;
begin
  result := xlSheetSetColHidden(handle, col, Integer(hidden)) > 0;
end;

function TXLSheet.defaultRowHeight(): double;
begin
  result := xlSheetDefaultRowHeight(handle);
end;

procedure TXLSheet.setDefaultRowHeight(height: double);
begin
  xlSheetSetDefaultRowHeight(handle, height);
end;

function TXLSheet.delMerge(row, col: Integer): boolean;
var
  res: Integer;
begin
  res := xlSheetDelMerge(handle, row, col);
  if res > 0 then
    result := true
  else
    result := false;
end;

function TXLSheet.getMerge(row, col: Integer; var rowFirst, rowLast, colFirst, colLast: Integer): boolean;
var
  res: Integer;
begin
  res := xlSheetGetMerge(handle, row, col, @rowFirst, @rowLast, @colFirst, @colLast);
  if res > 0 then
    result := true
  else
    result := false;
end;

function TXLSheet.setMerge(rowFirst, rowLast, colFirst, colLast: Integer): boolean;
var
  res: Integer;
begin
  res := xlSheetSetMerge(handle, rowFirst, rowLast, colFirst, colLast);
  if res > 0 then
    result := true
  else
    result := false;
end;

function TXLSheet.mergeSize(): Integer;
begin
  result := xlSheetMergeSize(handle);
end;

function TXLSheet.merge(index: Integer; var rowFirst, rowLast, colFirst, colLast: Integer): boolean;
begin
  result := xlSheetMerge(handle, index, @rowFirst, @rowLast, @colFirst, @colLast) > 0;
end;

function TXLSheet.delMergeByIndex(index: Integer): boolean;
begin
  result := xlSheetDelMergeByIndex(handle, index) > 0;
end;

function TXLSheet.pictureSize: Integer;
begin
  result := xlSheetPictureSize(handle);
end;

function TXLSheet.getPicture(index: Integer): Integer;
var
  rowTop, colLeft, rowBottom, colRight, width, height, offset_x, offset_y: Integer;
begin
  result := xlSheetGetPicture(handle, index, @rowTop, @colLeft, @rowBottom, @colRight, @width, @height, @offset_x, @offset_y);
end;

function TXLSheet.getPicture(index: Integer; var rowTop, colLeft, rowBottom, colRight: Integer): Integer;
var
  width, height, offset_x, offset_y: Integer;
begin
  result := xlSheetGetPicture(handle, index, @rowTop, @colLeft, @rowBottom, @colRight, @width, @height, @offset_x, @offset_y);
end;

function TXLSheet.getPicture(index: Integer; var rowTop, colLeft, rowBottom, colRight, width, height: Integer): Integer;
var
  offset_x, offset_y: Integer;
begin
  result := xlSheetGetPicture(handle, index, @rowTop, @colLeft, @rowBottom, @colRight, @width, @height, @offset_x, @offset_y);
end;

function TXLSheet.getPicture(index: Integer; var rowTop, colLeft, rowBottom, colRight, width, height, offset_x, offset_y: Integer): Integer;
begin
  result := xlSheetGetPicture(handle, index, @rowTop, @colLeft, @rowBottom, @colRight, @width, @height, @offset_x, @offset_y);
end;

function TXLSheet.delHorPageBreak(row: Integer): boolean;
begin
  result := xlSheetSetHorPageBreak(handle, row, 0) > 0;
end;

function TXLSheet.delVerPageBreak(col: Integer): boolean;
begin
  result := xlSheetSetVerPageBreak(handle, col, 0) > 0;
end;

function TXLSheet.setHorPageBreak(row: Integer): boolean;
begin
  result := xlSheetSetHorPageBreak(handle, row, 1) > 0;
end;

function TXLSheet.setVerPageBreak(col: Integer): boolean;
begin
  result := xlSheetSetVerPageBreak(handle, col, 1) > 0;
end;

procedure TXLSheet.setPicture(row, col, pictureId, width, height: Integer);
begin
  xlSheetSetPicture2(handle, row, col, pictureId, width, height, 0, 0, 0);
end;

procedure TXLSheet.setPicture(row, col, pictureId: Integer; scale: double);
begin
  xlSheetSetPicture(handle, row, col, pictureId, scale, 0, 0, 0);
end;

procedure TXLSheet.setPicture(row, col, pictureId: Integer);
begin
  setPicture(row, col, pictureId, 1);
end;

function TXLSheet.removePictureByIndex(index: Integer): boolean;
begin
  result := xlSheetRemovePictureByIndex(handle, index) > 0;
end;

function TXLSheet.removePicture(row, col: Integer): boolean;
begin
  result := xlSheetRemovePicture(handle, row, col) > 0;
end;

function TXLSheet.getHorPageBreak(index: Integer): Integer;
begin
  result := xlSheetGetHorPageBreak(handle, index);
end;

function TXLSheet.getHorPageBreakSize: Integer;
begin
  result := xlSheetGetHorPageBreakSize(handle);
end;

function TXLSheet.getVerPageBreak(index: Integer): Integer;
begin
  result := xlSheetGetVerPageBreak(handle, index);
end;

function TXLSheet.getVerPageBreakSize: Integer;
begin
  result := xlSheetGetVerPageBreakSize(handle);
end;

procedure TXLSheet.split(row, col: Integer);
begin
  xlSheetSplit(handle, row, col);
end;

function TXLSheet.splitInfo(var row, col: Integer): boolean;
begin
  result := xlSheetSplitInfo(handle, @row, @col) > 0;
end;

function TXLSheet.groupCols(colFirst, colLast: Integer; collapsed: boolean): boolean;
begin
  result := xlSheetGroupCols(handle, colFirst, colLast, Integer(collapsed)) > 0;
end;

function TXLSheet.groupRows(rowFirst, rowLast: Integer; collapsed: boolean): boolean;
begin
  result := xlSheetGroupRows(handle, rowFirst, rowLast, Integer(collapsed)) > 0;
end;

function TXLSheet.clear(rowFirst, rowLast, colFirst, colLast: Integer): boolean;
begin
  result := xlSheetClear(handle, rowFirst, rowLast, colFirst, colLast) > 0;
end;

function TXLSheet.insertCol(colFirst, colLast: Integer): boolean;
begin
  result := xlSheetInsertCol(handle, colFirst, colLast) > 0;
end;

function TXLSheet.insertRow(rowFirst, rowLast: Integer): boolean;
begin
  result := xlSheetInsertRow(handle, rowFirst, rowLast) > 0;
end;

function TXLSheet.removeCol(colFirst, colLast: Integer): boolean;
begin
  result := xlSheetRemoveCol(handle, colFirst, colLast) > 0;
end;

function TXLSheet.removeRow(rowFirst, rowLast: Integer): boolean;
begin
  result := xlSheetRemoveRow(handle, rowFirst, rowLast) > 0;
end;

function TXLSheet.copyCell(rowSrc, colSrc, rowDst, colDst: Integer): boolean;
begin
  result := xlSheetCopyCell(handle, rowSrc, colSrc, rowDst, colDst) > 0;
end;

function TXLSheet.printRepeatRows(var rowFirst, rowLast: Integer): boolean;
begin
  result := xlSheetPrintRepeatRows(handle, @rowFirst, @rowLast) > 0;
end;

procedure TXLSheet.setPrintRepeatRows(rowFirst, rowLast: Integer);
begin
  xlSheetSetPrintRepeatRows(handle, rowFirst, rowLast);
end;

function TXLSheet.printRepeatCols(var colFirst, colLast: Integer): boolean;
begin
  result := xlSheetPrintRepeatCols(handle, @colFirst, @colLast) > 0;
end;

procedure TXLSheet.setPrintRepeatCols(colFirst, colLast: Integer);
begin
  xlSheetSetPrintRepeatCols(handle, colFirst, colLast);
end;

function TXLSheet.printArea(var rowFirst, rowLast, colFirst, colLast: Integer): boolean;
begin
  result := xlSheetPrintArea(handle, @rowFirst, @rowLast, @colFirst, @colLast) > 0;
end;

procedure TXLSheet.setPrintArea(rowFirst, rowLast, colFirst, colLast: Integer);
begin
  xlSheetSetPrintArea(handle, rowFirst, rowLast, colFirst, colLast);
end;
    
procedure TXLSheet.clearPrintRepeats();
begin
  xlSheetClearPrintRepeats(handle);
end;

procedure TXLSheet.clearPrintArea();
begin
  xlSheetClearPrintArea(handle);
end;

function TXLSheet.getNamedRange(const name: PWideChar; var rowFirst, rowLast, colFirst, colLast: Integer): boolean;
var
  hidden: boolean;
begin
  result := xlSheetGetNamedRange(handle, name, @rowFirst, @rowLast, @colFirst, @colLast, -2, @hidden) > 0;
end;

function TXLSheet.getNamedRange(const name: PWideChar; var rowFirst, rowLast, colFirst, colLast: Integer; scopeId: Integer): boolean;
var
  hidden: boolean;
begin
  result := xlSheetGetNamedRange(handle, name, @rowFirst, @rowLast, @colFirst, @colLast, scopeId, @hidden) > 0;
end;

function TXLSheet.getNamedRange(const name: PWideChar; var rowFirst, rowLast, colFirst, colLast: Integer; scopeId: Integer; var hidden: boolean): boolean;
begin
  result := xlSheetGetNamedRange(handle, name, @rowFirst, @rowLast, @colFirst, @colLast, scopeId, @hidden) > 0;
end;

function TXLSheet.setNamedRange(const name: PWideChar; rowFirst, rowLast, colFirst, colLast: Integer): boolean;
begin
  result := xlSheetSetNamedRange(handle, name, rowFirst, rowLast, colFirst, colLast, -2) > 0;
end;

function TXLSheet.setNamedRange(const name: PWideChar; rowFirst, rowLast, colFirst, colLast, scopeId: Integer): boolean;
begin
  result := xlSheetSetNamedRange(handle, name, rowFirst, rowLast, colFirst, colLast, scopeId) > 0;
end;

function TXLSheet.delNamedRange(const name: PWideChar): boolean;
begin
  result := xlSheetDelNamedRange(handle, name, -2) > 0;
end;

function TXLSheet.delNamedRange(const name: PWideChar; scopeId: Integer): boolean;
begin
  result := xlSheetDelNamedRange(handle, name, scopeId) > 0;
end;

function TXLSheet.namedRangeSize(): Integer;
begin
  result := xlSheetNamedRangeSize(handle);
end;

function TXLSheet.namedRange(index: Integer; var rowFirst, rowLast, colFirst, colLast: Integer): WideString;
var
  scopeId: Integer;
  hidden: boolean;
begin
  result := xlSheetNamedRange(handle, index, @rowFirst, @rowLast, @colFirst, @colLast, @scopeId, @hidden);
end;

function TXLSheet.namedRange(index: Integer; var rowFirst, rowLast, colFirst, colLast, scopeId: Integer): WideString;
var
  hidden: boolean;
begin
  result := xlSheetNamedRange(handle, index, @rowFirst, @rowLast, @colFirst, @colLast, @scopeId, @hidden);
end;

function TXLSheet.namedRange(index: Integer; var rowFirst, rowLast, colFirst, colLast, scopeId: Integer; var hidden: boolean): WideString;
begin
  result := xlSheetNamedRange(handle, index, @rowFirst, @rowLast, @colFirst, @colLast, @scopeId, @hidden);
end;

function TXLSheet.tableSize(): Integer;
begin
  result := xlSheetTableSize(handle);
end;

function TXLSheet.table(index: Integer; var rowFirst, rowLast, colFirst, colLast, headerRowCount, totalsRowCount: Integer): WideString;
begin
  result := xlSheetTable(handle, index, @rowFirst, @rowLast, @colFirst, @colLast, @headerRowCount, @totalsRowCount);
end;

function TXLSheet.hyperlinkSize(): Integer;
begin
  result := xlSheetHyperlinkSize(handle);
end;

function TXLSheet.hyperlink(index: Integer; var rowFirst, rowLast, colFirst, colLast: Integer): WideString;
begin
  result := xlSheetHyperlink(handle, index, @rowFirst, @rowLast, @colFirst, @colLast);
end;

function TXLSheet.delHyperlink(index: Integer): boolean;
begin
  result := xlSheetDelHyperlink(handle, index) > 0;
end;

procedure TXLSheet.addHyperlink(const hyperlink: PWideChar; rowFirst, rowLast, colFirst, colLast: Integer);
begin
  xlSheetAddHyperlink(handle, hyperlink, rowFirst, rowLast, colFirst, colLast);
end;

function TXLSheet.hyperlinkIndex(row, col: Integer): Integer;
begin
  result := xlSheetHyperlinkIndex(handle, row, col);
end;

function TXLSheet.isAutoFilter(): boolean;
begin
  result := xlSheetIsAutoFilter(handle) > 0;
end;

function TXLSheet.autoFilter(): TXLAutoFilter;
var
  autoFilter: AutoFilterHandle;
begin
  autoFilter := xlSheetAutoFilter(handle);
  if autoFilter <> nil then
  begin
    result := TXLAutoFilter.Create(xlSheetAutoFilter(handle), book);
    xlAutoFilter := result
  end
  else
    result := nil;
end;

procedure TXLSheet.applyFilter();
begin
  xlSheetApplyFilter(handle);
end;

procedure TXLSheet.removeFilter();
begin
  xlSheetRemoveFilter(handle);
end;

procedure TXLSheet.setProtect(protect: boolean; const password: PWideChar);
begin
  xlSheetSetProtectEx(handle, Integer(protect), password, -1);
end;

procedure TXLSheet.setProtect(protect: boolean; const password: PWideChar; const prot: EnhancedProtection);
begin
  xlSheetSetProtectEx(handle, Integer(protect), password, Integer(prot));
end;

function TXLSheet.firstRow: Integer;
begin
  result := xlSheetFirstRow(handle);
end;

function TXLSheet.lastRow: Integer;
begin
  result := xlSheetLastRow(handle);
end;

function TXLSheet.firstCol: Integer;
begin
  result := xlSheetFirstCol(handle);
end;

function TXLSheet.lastCol: Integer;
begin
  result := xlSheetLastCol(handle);
end;

function TXLSheet.firstFilledRow: Integer;
begin
  result := xlSheetFirstFilledRow(handle);
end;

function TXLSheet.lastFilledRow: Integer;
begin
  result := xlSheetLastFilledRow(handle);
end;

function TXLSheet.firstFilledCol: Integer;
begin
  result := xlSheetFirstFilledCol(handle);
end;

function TXLSheet.lastFilledCol: Integer;
begin
  result := xlSheetLastFilledCol(handle);
end;

function TXLSheet.getPrintFit(var wPages, hPages: Integer): boolean;
begin
  result := xlSheetGetPrintFit(handle, @wPages, @hPages) > 0;
end;

procedure TXLSheet.setPrintFit(wPages, hPages: Integer);
begin
  xlSheetSetPrintFit(handle, wPages, hPages);
end;

function TXLSheet.GetDisplayGridlines: boolean;
begin
  result := (xlSheetDisplayGridlines(handle) > 0);
end;

procedure TXLSheet.SetDisplayGridlines(const value: boolean);
begin
  xlSheetSetDisplayGridlines(handle, Integer(value));
end;

function TXLSheet.GetprintGridlines: boolean;
begin
  result := (xlSheetPrintGridlines(handle) > 0);
end;

procedure TXLSheet.SetprintGridlines(const value: boolean);
begin
  xlSheetSetPrintGridlines(handle, Integer(value));
end;

procedure TXLSheet.SetZoom(const value: Integer);
begin
  xlSheetSetZoom(handle, value);
end;

function TXLSheet.GetZoom: Integer;
begin
  result := xlSheetZoom(handle);
end;

function TXLSheet.GetprintZoom: Integer;
begin
  result := xlSheetPrintZoom(handle);
end;

procedure TXLSheet.SetprintZoom(const value: Integer);
begin
  xlSheetSetPrintZoom(handle, value);
end;

procedure TXLSheet.Setlandscape(const value: boolean);
begin
  xlSheetSetLandscape(handle, Integer(value));
end;

function TXLSheet.Getlandscape: boolean;
begin
  result := (xlSheetLandscape(handle) > 0);
end;

function TXLSheet.GetPaper: Paper;
begin
  result := LibXL.Paper(xlSheetPaper(handle));
end;

procedure TXLSheet.SetPaper(const value: Paper);
begin
  xlSheetSetPaper(handle, Integer(value));
end;

function TXLSheet.Getheader: WideString;
var
  s: PWideChar;
begin
  s := xlSheetHeader(handle);
  if s <> nil then
    result := WideString(s)
  else
    result := '';
end;

procedure TXLSheet.Setheader(const value: WideString);
var
  PValue: PWideChar;
begin
  PValue := @(value[1]);
  xlSheetSetHeader(handle, PValue, 0.5);
end;

function TXLSheet.GetheaderMargin: double;
begin
  result := xlSheetHeaderMargin(handle);
end;

procedure TXLSheet.SetheaderMargin(const value: double);
begin
  xlSheetSetHeader(handle, @(self.header[1]), value);
end;

function TXLSheet.Getfooter: WideString;
var
  s: PWideChar;
begin
  s := xlSheetFooter(handle);
  if s <> nil then
    result := WideString(s)
  else
    result := '';
end;

procedure TXLSheet.Setfooter(const value: WideString);
var
  PValue: PWideChar;
begin
  PValue := @(value[1]);
  xlSheetSetFooter(handle, PValue, 0.5);
end;

function TXLSheet.GetfooterMargin: double;
begin
  result := xlSheetHeaderMargin(handle);
end;

procedure TXLSheet.SetfooterMargin(const value: double);
begin
  xlSheetSetHeader(handle, @(self.footer[1]), value);
end;

procedure TXLSheet.SethCenter(const value: boolean);
begin
  xlSheetSetHCenter(handle, Integer(value));
end;

function TXLSheet.GethCenter: boolean;
begin
  result := (xlSheetHCenter(handle) > 0);
end;

procedure TXLSheet.SetvCenter(const value: boolean);
begin
  xlSheetSetVCenter(handle, Integer(value));
end;

function TXLSheet.GetvCenter: boolean;
begin
  result := (xlSheetVCenter(handle) > 0);
end;

procedure TXLSheet.SetmarginLeft(const value: double);
begin
  xlSheetSetMarginLeft(handle, value);
end;

function TXLSheet.GetmarginLeft: double;
begin
  result := xlSheetMarginLeft(handle);
end;

procedure TXLSheet.SetmarginRight(const value: double);
begin
  xlSheetSetMarginRight(handle, value);
end;

function TXLSheet.GetmarginRight: double;
begin
  result := xlSheetMarginRight(handle);
end;

procedure TXLSheet.SetmarginTop(const value: double);
begin
  xlSheetSetMarginTop(handle, value);
end;

function TXLSheet.GetmarginTop: double;
begin
  result := xlSheetMarginTop(handle);
end;

procedure TXLSheet.SetmarginBottom(const value: double);
begin
  xlSheetSetMarginBottom(handle, value);
end;

function TXLSheet.GetmarginBottom: double;
begin
  result := xlSheetMarginBottom(handle);
end;

function TXLSheet.Getname: WideString;
var
  s: PWideChar;
begin
  s := xlSheetName(handle);
  if s <> nil then
    result := WideString(s)
  else
    result := '';
end;

procedure TXLSheet.Setname(const value: WideString);
begin
  xlSheetSetName(handle, @(value[1]));
end;

function TXLSheet.GetprintRowCol: boolean;
begin
  result := (xlSheetPrintRowCol(handle) > 0);
end;

procedure TXLSheet.SetprintRowCol(const value: boolean);
begin
  xlSheetSetPrintRowCol(handle, Integer(value));
end;

function TXLSheet.GetprotectImpl: boolean;
begin
  result := (xlSheetProtect(handle) > 0);
end;

procedure TXLSheet.SetprotectImpl(const value: boolean);
begin
  xlSheetSetProtect(handle, Integer(value));
end;

function TXLSheet.Getrighttoleft: boolean;
begin
  result := (xlSheetRightToLeft(handle) > 0);
end;

procedure TXLSheet.Setrighttoleft(const value: boolean);
begin
  xlSheetSetRightToLeft(handle, Integer(value));
end;

function TXLSheet.GetHidden: SheetState;
begin
  result := SheetState(xlSheetHidden(handle));
end;

procedure TXLSheet.SetHidden(const value: SheetState);
begin
  xlSheetSetHidden(handle, Integer(value));
end;

procedure TXLSheet.getTopLeftView(var row, col: Integer);
begin
  xlSheetGetTopLeftView(handle, @row, @col);  
end;

procedure TXLSheet.setTopLeftView(row, col: Integer);
begin
  xlSheetSetTopLeftView(handle, row, col);  
end;

procedure TXLSheet.setAutoFitArea(rowFirst: Integer; colFirst: Integer; rowLast: Integer; colLast: Integer);
begin
  xlSheetSetAutoFitArea(handle, rowFirst, colFirst, rowLast, colLast);
end;

function TXLSheet.GetGroupSummaryBelow: boolean;
begin
  result := (xlSheetGroupSummaryBelow(handle) > 0);
end;

procedure TXLSheet.SetGroupSummaryBelow(const value: boolean);
begin
  xlSheetSetGroupSummaryBelow(handle, Integer(value));
end;

function TXLSheet.GetGroupSummaryRight: boolean;
begin
  result := (xlSheetGroupSummaryRight(handle) > 0);
end;

procedure TXLSheet.SetGroupSummaryRight(const value: boolean);
begin
  xlSheetSetGroupSummaryRight(handle, Integer(value));
end;

procedure TXLSheet.addrToRowCol(const addr: PWideChar; var row, col: Integer);
begin
  xlSheetAddrToRowCol(handle, addr, @row, @col, nil, nil);
end;

procedure TXLSheet.addrToRowCol(const addr: PWideChar; var row, col: Integer; var rowRelative, colRelative: boolean);
var
  localRowRelative, localColRelative: Integer;
begin
  xlSheetAddrToRowCol(handle, addr, @row, @col, @localRowRelative, @localColRelative);
  rowRelative := localRowRelative > 0;
  colRelative := localColRelative > 0;
end;

function TXLSheet.rowColToAddr(row, col: Integer): WideString;
var
  s: PWideChar;
begin
  s := xlSheetRowColToAddr(handle, row, col, 0, 0);
  if s <> nil then
    result := WideString(s)
  else
    result := '';
end;

function TXLSheet.rowColToAddr(row, col: Integer; rowRelative, colRelative: boolean): WideString;
var
  s: PWideChar;
begin
  s := xlSheetRowColToAddr(handle, row, col, Integer(rowRelative), Integer(colRelative));
  if s <> nil then
    result := WideString(s)
  else
    result := '';
end;

function TXLSheet.tabColor(): Color;
begin
  result := LibXL.Color(xlSheetTabColor(handle));
end;

procedure TXLSheet.setTabColor(color: Color);
begin
  xlSheetSetTabColor(handle, Integer(color));
end;

function TXLSheet.getTabColor(var red, green, blue: Integer): boolean;
begin
  result := xlSheetGetTabRgbColor(handle, @red, @green, @blue) > 0;
end;

procedure TXLSheet.setTabColor(red: Integer; green: Integer; blue: Integer);
begin
  xlSheetSetTabRgbColor(handle, red, green, blue);
end;

function TXLSheet.addIgnoredError(rowFirst: Integer; colFirst: Integer; rowLast: Integer; colLast: Integer; iError: IgnoredError): boolean;
begin
  result := xlSheetAddIgnoredError(handle,  rowFirst,  colFirst, rowLast, colLast, Integer(iError)) > 0;
end;

procedure TXLSheet.addDataValidation(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; const value: PWideChar);
begin
  xlSheetAddDataValidation(handle, Integer(vtype), Integer(op), rowFirst, rowLast, colFirst, colLast, value, nil);
end;

procedure TXLSheet.addDataValidation(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; const value1: PWideChar; const value2: PWideChar);
begin
  xlSheetAddDataValidation(handle, Integer(vtype), Integer(op), rowFirst, rowLast, colFirst, colLast, value1, value2);
end;

procedure TXLSheet.addDataValidation(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; const value1: PWideChar; const value2: PWideChar;
                                allowBlank: boolean; hideDropDown: boolean; showInputMessage: boolean; showErrorMessage: boolean; const promptTitle: PWideChar; const prompt: PWideChar;
                                const errorTitle: PWideChar; const error: PWideChar; errorStyle: DataValidationErrorStyle);
begin
  xlSheetAddDataValidationEx(handle, Integer(vtype), Integer(op), rowFirst, rowLast, colFirst, colLast, value1, value2, Integer(allowBlank), Integer(hideDropDown), Integer(showInputMessage), Integer(showErrorMessage), promptTitle, prompt, errorTitle, error, Integer(errorStyle));
end;

procedure TXLSheet.addDataValidationDouble(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; value: double);
begin
  xlSheetAddDataValidationDouble(handle, Integer(vtype), Integer(op), rowFirst, rowLast, colFirst, colLast, value, 0);
end;

procedure TXLSheet.addDataValidationDouble(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; value1: double; value2: double);
begin
  xlSheetAddDataValidationDouble(handle, Integer(vtype), Integer(op), rowFirst, rowLast, colFirst, colLast, value1, value2);
end;

procedure TXLSheet.addDataValidationDouble(vtype: DataValidationType; op: DataValidationOperator; rowFirst: Integer; rowLast: Integer; colFirst: Integer; colLast: Integer; value1: double; value2: double;
                                allowBlank: boolean; hideDropDown: boolean; showInputMessage: boolean; showErrorMessage: boolean; const promptTitle: PWideChar; const prompt: PWideChar;
                                const errorTitle: PWideChar; const error: PWideChar; errorStyle: DataValidationErrorStyle);
begin
  xlSheetAddDataValidationDoubleEx(handle, Integer(vtype), Integer(op), rowFirst, rowLast, colFirst, colLast, value1, value2, Integer(allowBlank), Integer(hideDropDown), Integer(showInputMessage), Integer(showErrorMessage), promptTitle, prompt, errorTitle, error, Integer(errorStyle));
end;

procedure TXLSheet.removeDataValidations();
begin
  xlSheetRemoveDataValidations(handle);
end;

function TXLSheet.formControlSize(): Integer;
begin
  result := xlSheetFormControlSize(handle);
end;

function TXLSheet.formControl(index: Integer): TXLFormControl;
var
  frmControlHandle: FormControlHandle;
begin
  frmControlHandle := xlSheetFormControl(handle, index);
  if frmControlHandle <> nil then
  begin
    result := TXLFormControl.Create(frmControlHandle, book);
    xlAddFormControl(formControls, result);
  end
  else
   result := nil;
end;

function TXLSheet.addConditionalFormatting(): TXLConditionalFormatting;
var
  cFormattingHandle: ConditionalFormattingHandle;
begin
  cFormattingHandle := xlSheetAddConditionalFormatting(handle);
  if cFormattingHandle <> nil then
  begin
    result := TXLConditionalFormatting.Create(cFormattingHandle, book);
    xlAddConditionalFormatting(cFormattings, result);
  end
  else
   result := nil;
end;

function TXLSheet.getActiveCell(var row, col: Integer): boolean;
begin
  result := xlSheetGetActiveCell(handle, @row, @col) > 0;
end;

procedure TXLSheet.setActiveCell(row, col: Integer);
begin
  xlSheetSetActiveCell(handle, row, col);
end;

function TXLSheet.selectionRange(): WideString;
begin
  result := WideString(xlSheetSelectionRange(handle));
end;

procedure TXLSheet.addSelectionRange(sqref: PWideChar);
begin
  xlSheetAddSelectionRange(handle, sqref);
end;

procedure TXLSheet.removeSelection();
begin
  xlSheetRemoveSelection(handle);
end;

//////////////////////////////////////////////////////////////////////////////////////////////

function TXLBook.load(filename: PWideChar): boolean;
begin
  result := xlBookLoad(handle, filename) > 0;
end;

function TXLBook.load(filename: PWideChar; tempFile: PWideChar): boolean;
begin
  result := xlBookLoadUsingTempFile(handle, filename, tempFile) > 0;
end;

function TXLBook.loadSheet(filename: PWideChar; sheetIndex: Integer): boolean;
begin
  result := xlBookLoadPartially(handle, filename, sheetIndex, -1, -1) > 0;
end;

function TXLBook.loadSheet(filename: PWideChar; sheetIndex: Integer; tempFile: PWideChar): boolean;
begin
  result := xlBookLoadPartiallyUsingTempFile(handle, filename, sheetIndex, -1, -1, tempFile) > 0;
end;

function TXLBook.loadPartially(filename: PWideChar; sheetIndex, firstRow, lastRow: Integer): boolean;
begin
  result := xlBookLoadPartially(handle, filename, sheetIndex, firstRow, lastRow) > 0;
end;

function TXLBook.loadPartially(filename: PWideChar; sheetIndex, firstRow, lastRow: Integer; tempFile: PWideChar): boolean;
begin
  result := xlBookLoadPartiallyUsingTempFile(handle, filename, sheetIndex, firstRow, lastRow, tempFile) > 0;
end;

function TXLBook.loadWithoutEmptyCells(filename: PWideChar): boolean;
begin
  result := xlBookLoadWithoutEmptyCells(handle, filename) > 0;
end;

function TXLBook.loadInfo(filename: PWideChar): boolean;
begin
  result := xlBookLoadInfo(handle, filename) > 0;
end;

function TXLBook.save(filename: PWideChar): boolean;
begin
  result := xlBookSave(handle, filename) > 0;
end;

function TXLBook.save(filename: PWideChar; useTempFile: boolean): boolean;
begin
  result := xlBookSaveUsingTempFile(handle, filename, Integer(useTempFile)) > 0;
end;

function TXLBook.loadRaw(data: PByteArray; size: Cardinal): boolean;
begin
  result := xlBookLoadRaw(handle, addr(data^[0]), size) > 0;
end;

function TXLBook.loadRaw(data: PByteArray; size: Cardinal; sheetIndex, firstRow, lastRow: Integer): boolean;
begin
  result := xlBookLoadRawPartially(handle, addr(data^[0]), size, sheetIndex, firstRow, lastRow) > 0;
end;

function TXLBook.saveRaw(var Buffer: ByteArray; var size: Cardinal): boolean;
var
  ptr: PByteArray;
  i: Integer;
  p: PByte;
begin
  if xlBookSaveRaw(handle, @ptr, @size) <> 0 then
  begin
    SetLength(Buffer, size);
    p := @(ptr^);
    for i := 0 to size - 1 do
    begin
      Buffer[i] := Byte(p^);
      Inc(p);
    end;
    result := true;
  end
  else
    result := false;
end;

function TXLBook.addSheet(name: PWideChar): TXLSheet;
var
  new_sheetHandle: SheetHandle;
begin
  new_sheetHandle := xlBookAddSheet(handle, name, nil);
  if new_sheetHandle <> nil then
  begin
    result := TXLSheet.Create(new_sheetHandle, self.handle);
    xlAddSheet(sheets, result);
  end
  else
    result := nil;
end;

function TXLBook.addSheet(name: PWideChar; initSheet: TXLSheet): TXLSheet;
var
  new_sheetHandle: SheetHandle;
begin
  new_sheetHandle := xlBookAddSheet(handle, name, initSheet.handle);
  if new_sheetHandle <> nil then
  begin
    result := TXLSheet.Create(new_sheetHandle, self.handle);
    xlAddSheet(sheets, result);
  end
  else
    result := nil;
end;

function TXLBook.insertSheet(index: Integer; name: PWideChar): TXLSheet;
var
  new_sheetHandle: SheetHandle;
begin
  new_sheetHandle := xlBookInsertSheet(handle, index, name, nil);
  if new_sheetHandle <> nil then
  begin
    result := TXLSheet.Create(new_sheetHandle, self.handle);
    xlAddSheet(sheets, result);
  end
  else
    result := nil;
end;

function TXLBook.insertSheet(index: Integer; name: PWideChar; initSheet: TXLSheet): TXLSheet;
var
  new_sheetHandle: SheetHandle;
begin
  new_sheetHandle := xlBookInsertSheet(handle, index, name, initSheet);
  if new_sheetHandle <> nil then
  begin
    result := TXLSheet.Create(new_sheetHandle, self.handle);
    xlAddSheet(sheets, result);
  end
  else 
    result := nil;
end;

function TXLBook.getSheet(index: Integer): TXLSheet;
var
  new_sheetHandle: SheetHandle;
begin
  new_sheetHandle := xlBookGetSheet(handle, index);
  if new_sheetHandle <> nil then
  begin
    result := TXLSheet.Create(new_sheetHandle, self.handle);
    xlAddSheet(sheets, result);
  end
  else
    result := nil;
end;

function TXLBook.getSheetName(index: Integer): WideString;
begin
  result := WideString(xlBookGetSheetName(handle, index));
end;

function TXLBook.sheetType(index: Integer): SheetType;
var
  retval: Integer;
begin
  retval := xlBookSheetType(handle, index);
  result := SheetType(retval);
end;

function TXLBook.moveSheet(srcIndex: Integer; dstIndex: Integer): boolean;
begin
  result := xlBookMoveSheet(handle, srcIndex, dstIndex) > 0;
end;

function TXLBook.delSheet(index: Integer): boolean;
begin
  result := xlBookDelSheet(handle, index) > 0;
end;

function TXLBook.sheetCount: Integer;
begin
  result := xlBookSheetCount(handle);
end;

function TXLBook.addFormat: TXLFormat;
var
  fmtHandle: FormatHandle;
begin
  fmtHandle := xlBookAddFormat(handle, nil);
  if fmtHandle <> nil then
  begin
    result := TXLFormat.Create(fmtHandle, handle);
    xlAddFormat(formats, result);
  end
  else
    result := nil;
end;

function TXLBook.addFormat(initFormat: TXLFormat): TXLFormat;
var
  fmtHandle: FormatHandle;
begin
  fmtHandle := xlBookAddFormat(handle, initFormat.handle);
  if fmtHandle <> nil then
  begin
    result := TXLFormat.Create(fmtHandle, handle);
    xlAddFormat(formats, result);
  end
  else
    result := nil;
end;

function TXLBook.addFont: TXLFont;
var
  font: FontHandle;
begin
  font := xlBookAddFont(handle, nil);
  if font <> nil then
  begin
    result := TXLFont.Create(font, handle);
    xlAddFont(fonts, result);
  end
  else
    result := nil;
end;

function TXLBook.addFont(initFont: TXLFont): TXLFont;
var
  font: FontHandle;
begin
  font := xlBookAddFont(handle, initFont.handle);
  if font <> nil then
  begin
    result := TXLFont.Create(font, handle);
    xlAddFont(fonts, result);
  end
  else
    result := nil;
end;

function TXLBook.addRichString(): TXLRichString;
var
  richString: RichStringHandle;
begin
  richString := xlBookAddRichString(handle);
  if richString <> nil then
  begin
    result := TXLRichString.Create(richString, handle);
    xlAddRichString(richStrings, result);
  end
  else
    result := nil;
end;

function TXLBook.addCustomNumFormat(customNumFormat: PWideChar): Integer;
begin
  result := xlBookAddCustomNumFormat(handle, customNumFormat);
end;

function TXLBook.customNumFormat(fmt: Integer): WideString;
var  
  s: PWideChar;
begin
  s := xlBookCustomNumFormat(handle, fmt);
  if s <> nil then
    result := WideString(s)
  else
    result := '';
end;

function TXLBook.format(index: Integer): TXLFormat;
var
  fmtHandle : FormatHandle;
begin
  fmtHandle := xlBookFormat(handle, index);
  if fmtHandle <> nil then
  begin
    result := TXLFormat.Create(fmtHandle, handle);
    xlAddFormat(formats, result);
  end
  else
    result := nil;
end;

function TXLBook.formatSize(): Integer;
begin
  result := xlBookFormatSize(handle);
end;

function TXLBook.font(index: Integer): TXLFont;
var
  fntHandle : FontHandle;
begin
  fntHandle := xlBookFont(handle, index);
  if fntHandle <> nil then
  begin
    result := TXLFont.Create(fntHandle, handle);
    xlAddFont(fonts, result);
  end
  else
   result := nil;
end;

function TXLBook.fontSize(): Integer;
begin
  result := xlBookFontSize(handle);
end;

function TXLBook.addConditionalFormat(): TXLConditionalFormat;
var
  fmtHandle: ConditionalFormatHandle;
begin
  fmtHandle := xlBookAddConditionalFormat(handle);
  if fmtHandle <> nil then
  begin
    result := TXLConditionalFormat.Create(fmtHandle, handle);
    xlAddConditionalFormat(conditionalFormats, result);
  end
  else
    result := nil;
end;

function TXLBook.datePack(year, month, day: Integer): double;
begin
  result := xlBookDatePack(handle, year, month, day, 0, 0, 0, 0);
end;

function TXLBook.datePack(year, month, day, hour, min, sec: Integer): double;
begin
  result := xlBookDatePack(handle, year, month, day, hour, min, sec, 0);
end;

function TXLBook.datePack(year, month, day, hour, min, sec, msec: Integer): double;
begin
  result := xlBookDatePack(handle, year, month, day, hour, min, sec, msec);
end;

function TXLBook.dateUnpack(value: double; var year: Integer; var month: Integer; var day: Integer): boolean;
begin
  result := xlBookDateUnpack(handle, value, addr(year), addr(month), addr(day), nil, nil, nil, nil) > 0;
end;

function TXLBook.dateUnpack(value: double; var year: Integer; var month: Integer; var day: Integer; var hour: Integer; var min: Integer; var sec: Integer): boolean;
begin
  result := xlBookDateUnpack(handle, value, addr(year), addr(month), addr(day), addr(hour), addr(min), addr(sec), nil) > 0;
end;

function TXLBook.dateUnpack(value: double; var year: Integer; var month: Integer; var day: Integer; var hour: Integer; var min: Integer; var sec: Integer; var msec: Integer): boolean;
begin
  result := xlBookDateUnpack(handle, value, addr(year), addr(month), addr(day), addr(hour), addr(min), addr(sec), addr(msec)) > 0;
end;

function TXLBook.colorPack(red: Integer; green: Integer; blue: Integer): Color;
begin
  result := Color(xlBookColorPack(handle, red, green, blue));
end;

procedure TXLBook.colorUnpack(color: Color; var red: Integer; var green: Integer; var blue: Integer);
begin
  xlBookColorUnpack(handle, Integer(color), addr(red), addr(green), addr(blue));
end;

function TXLBook.activeSheet: Integer;
begin
  result := xlBookActiveSheet(handle);
end;

procedure TXLBook.setActiveSheet(index: Integer);
begin
  xlBookSetActiveSheet(handle, index);
end;

function TXLBook.pictureSize(): Integer;
begin
  result := xlBookPictureSize(handle);
end;

function TXLBook.getPicture(index: Integer; var Buffer: ByteArray; var size: Cardinal): PictureType;
var
  ptr: PByteArray;
  i: Integer;
  p: PByte;
  retval: Integer;
begin
  retval := xlBookGetPicture(handle, index, @ptr, @size);
  if retval <> $FF then
  begin
    SetLength(Buffer, size);
    p := @(ptr^);
    for i := 0 to size - 1 do
    begin
      Buffer[i] := Byte(p^);
      Inc(p);
    end;
  end;
  result := PictureType(retval);
end;

function TXLBook.addPicture(filename: PWideChar): Integer;
begin
  result := xlBookAddPicture(handle, filename);
end;

function TXLBook.addPicture2(data: PByteArray; size: Cardinal): Integer;
begin
  result := xlBookAddPicture2(handle, data, size);
end;

function TXLBook.addPictureAsLink(filename: PWideChar; insert: boolean): Integer;
begin
  result := xlBookAddPictureAsLink(handle, filename, Integer(insert));
end;

function TXLBook.defaultFont(var fontSize: Integer): WideString;
var
  s: PWideChar;
begin
  s := xlBookDefaultFont(handle, addr(fontSize));
  if s <> nil then
    result := WideString(s)
  else
    result := '';
end;

procedure TXLBook.setDefaultFont(fontName: PWideChar; fontSize: Integer);
begin
  xlBookSetDefaultFont(handle, fontName, fontSize);
end;

function TXLBook.GetRefR1C1: boolean;
begin
  result := (xlBookRefR1C1(handle) > 0);
end;

procedure TXLBook.SetRefR1C1(const value: boolean);
begin
  xlBookSetRefR1C1(handle, Integer(value));
end;

function TXLBook.GetDate1904: boolean;
begin
  result := (xlBookIsDate1904(handle) > 0);
end;

procedure TXLBook.SetDate1904(const value: boolean);
begin
  xlBookSetDate1904(handle, Integer(value));
end;

function TXLBook.GetTemplate: boolean;
begin
  result := (xlBookIsTemplate(handle) > 0);
end;

procedure TXLBook.SetTemplate(const value: boolean);
begin
  xlBookSetTemplate(handle, Integer(value));
end;

procedure TXLBook.setKey(name, key: PWideChar);
begin
  xlBookSetKey(handle, name, key);
end;

function TXLBook.rgbMode(): boolean;
begin
  result := boolean(xlBookRgbMode(handle));
end;

procedure TXLBook.setRgbMode(rgbMode: boolean);
begin
  xlBookSetRgbMode(handle, Integer(rgbMode));
end;

function TXLBook.calcMode(): CalcModeType;
begin
  result := CalcModeType(xlBookCalcMode(handle));
end;

procedure TXLBook.setCalcMode(calcMode: CalcModeType);
begin
  xlBookSetCalcMode(handle, Integer(calcMode));
end;

function TXLBook.version(): Integer;
begin
  result := xlBookVersion(handle);
end;

function TXLBook.biffVersion(): Integer;
begin
  result := xlBookBiffVersion(handle);
end;

function TXLBook.isWriteProtected(): boolean;
begin
  result := xlBookIsWriteProtected(handle) > 0;
end;

function TXLBook.setLocale(locale: PAnsiChar): boolean;
begin
  result := xlBookSetLocale(handle, locale) > 0;
end;

function TXLBook.errorMessage: WideString;
begin
  result := WideString(xlBookErrorMessage(handle));
end;


procedure TXLBook.Release;
var
  i : Integer;
begin
  try
    for i:= 0 to High(fonts) do fonts[i].Destroy;
    for i:= 0 to High(formats) do formats[i].Destroy;
    for i:= 0 to High(richStrings) do richStrings[i].Destroy;
    for i:= 0 to High(sheets) do sheets[i].Destroy;
    for i:= 0 to High(conditionalFormats) do conditionalFormats[i].Destroy;
    xlBookRelease(handle);
  finally
  end;
end;

destructor TXLBook.Destroy;
begin
  Release;
  inherited Destroy;
end;

constructor TBinBook.Create();
begin
  inherited Create;
  handle := xlCreateBookC;
end;

constructor TXmlBook.Create();
begin
  inherited Create;
  handle := xlCreateXMLBookC;
end;


end.
