///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                   LibXL .NET wrapper version 4.2.0                        //
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

using System;
using System.Runtime.InteropServices;
using System.Text;

namespace libxl
{
    public class Sheet
    {
        public IntPtr handle;
        Book book;

        public Sheet(IntPtr handle, Book book)
        {
            this.handle = handle;
            this.book = book;
        }

        public CellType cellType(int row, int col)
        {
            return (CellType)xlSheetCellType(handle, row, col);
        }

        public Format cellFormat(int row, int col)
        {
            IntPtr formatHandle = xlSheetCellFormat(handle, row, col);
            return new Format(formatHandle, book);
        }

        public void setCellFormat(int row, int col, Format format)
        {
            xlSheetSetCellFormat(handle, row, col, format.handle);
        }

        public bool isFormula(int row, int col)
        {
            return xlSheetIsFormula(handle, row, col) > 0 ? true : false;
        }

        public string readStr(int row, int col)
        {
            IntPtr formatHandle = (IntPtr)0;
            IntPtr pStr = xlSheetReadStr(handle, row, col, ref formatHandle);
            if (pStr == (IntPtr)0)
            {
                return "";
            }
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public string readStr(int row, int col, ref Format format)
        {
            IntPtr formatHandle = (IntPtr)0;
            IntPtr pStr = xlSheetReadStr(handle, row, col, ref formatHandle);
            if (pStr == (IntPtr)0)
            {
                return "";
            }
            format = new Format(formatHandle, book);
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public bool writeStr(int row, int col, string value)
        {
            int result = xlSheetWriteStr(handle, row, col, value, (IntPtr)0);
            return result > 0;
        }

        public bool writeStr(int row, int col, string value, Format format)
        {
            int result = xlSheetWriteStr(handle, row, col, value, format.handle);
            return result > 0;
        }

        public RichString readRichStr(int row, int col)
        {
            IntPtr formatHandle = (IntPtr)0;
            IntPtr pStr = xlSheetReadRichStr(handle, row, col, ref formatHandle);
            if (pStr != (IntPtr)0)
            {
                return new RichString(pStr, book);
            }
            return null;
        }

        public RichString readRichStr(int row, int col, ref Format format)
        {
            IntPtr formatHandle = (IntPtr)0;
            IntPtr pStr = xlSheetReadRichStr(handle, row, col, ref formatHandle);
            if (pStr != (IntPtr)0)
            {
                if (formatHandle != (IntPtr)0)
                {
                    format = new Format(formatHandle, book);
                }
                return new RichString(pStr, book);
            }
            return null;
        }

        public bool writeRichStr(int row, int col, RichString value)
        {
            int result = xlSheetWriteRichStr(handle, row, col, value.handle, (IntPtr)0);
            return result > 0;
        }

        public bool writeRichStr(int row, int col, RichString value, Format format)
        {
            int result = xlSheetWriteRichStr(handle, row, col, value.handle, format.handle);
            return result > 0;
        }

        public double readNum(int row, int col)
        {
            IntPtr formatHandle = (IntPtr)0;
            double result = xlSheetReadNum(handle, row, col, ref formatHandle);
            return result;
        }

        public double readNum(int row, int col, ref Format format)
        {
            double result = xlSheetReadNum(handle, row, col, ref format.handle);
            return result;
        }

        public bool writeNum(int row, int col, double value)
        {
            int result = xlSheetWriteNum(handle, row, col, value, (IntPtr)0);
            return result > 0;
        }

        public bool writeNum(int row, int col, double value, Format format)
        {
            int result = xlSheetWriteNum(handle, row, col, value, format.handle);
            return result > 0;
        }

        public bool readBool(int row, int col)
        {
            IntPtr formatHandle = (IntPtr)0;
            int result = xlSheetReadBool(handle, row, col, ref formatHandle);
            return result > 0;
        }

        public bool readBool(int row, int col, ref Format format)
        {
            int result = xlSheetReadBool(handle, row, col, ref format.handle);
            return result > 0;
        }

        public bool writeBool(int row, int col, bool value)
        {
            int result = xlSheetWriteBool(handle, row, col, value ? 1 : 0, (IntPtr)0);
            return result > 0;
        }

        public bool writeBool(int row, int col, bool value, Format format)
        {
            int result = xlSheetWriteBool(handle, row, col, value ? 1 : 0, format.handle);
            return result > 0;
        }

        public bool readBlank(int row, int col, ref Format format)
        {
            int result = xlSheetReadBlank(handle, row, col, ref format.handle);
            return result > 0;
        }

        public bool writeBlank(int row, int col, Format format)
        {
            int result = xlSheetWriteBlank(handle, row, col, format.handle);
            return result > 0;
        }

        public string readFormula(int row, int col)
        {
            IntPtr formatHandle = (IntPtr)0;
            IntPtr pStr = xlSheetReadFormula(handle, row, col, ref formatHandle);
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public string readFormula(int row, int col, ref Format format)
        {
            IntPtr formatHandle = (IntPtr)0;
            IntPtr pStr = xlSheetReadFormula(handle, row, col, ref formatHandle);
            if (formatHandle != (IntPtr)0)
            {
                format = new Format(formatHandle, book);
            }
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public bool writeFormula(int row, int col, string value)
        {
            int result = xlSheetWriteFormula(handle, row, col, value, (IntPtr)0);
            return result > 0;
        }

        public bool writeFormula(int row, int col, string value, Format format)
        {
            int result = xlSheetWriteFormula(handle, row, col, value, format.handle);
            return result > 0;
        }

        public bool writeFormulaNum(int row, int col, string expr, double value)
        {
            return xlSheetWriteFormulaNum(handle, row, col, expr, value, (IntPtr)0) > 0;
        }

        public bool writeFormulaNum(int row, int col, string expr, double value, Format format)
        {
            return xlSheetWriteFormulaNum(handle, row, col, expr, value, format.handle) > 0;
        }

        public bool writeFormulaStr(int row, int col, string expr, string value)
        {
            return xlSheetWriteFormulaStr(handle, row, col, expr, value, (IntPtr)0) > 0;
        }

        public bool writeFormulaStr(int row, int col, string expr, string value, Format format)
        {
            return xlSheetWriteFormulaStr(handle, row, col, expr, value, format.handle) > 0;
        }

        public bool writeFormulaBool(int row, int col, string expr, bool value)
        {
            return xlSheetWriteFormulaBool(handle, row, col, expr, value ? 1 : 0, (IntPtr)0) > 0;
        }

        public bool writeFormulaBool(int row, int col, string expr, bool value, Format format)
        {
            return xlSheetWriteFormulaBool(handle, row, col, expr, value ? 1 : 0, format.handle) > 0;
        }

        public string readComment(int row, int col)
        {
            IntPtr pStr = xlSheetReadComment(handle, row, col);
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public void writeComment(int row, int col, string value, string author, int width, int height)
        {
            xlSheetWriteComment(handle, row, col, value, author, width, height);
        }

        public void removeComment(int row, int col)
        {
            xlSheetRemoveComment(handle, row, col);
        }

        public bool isDate(int row, int col)
        {
            return xlSheetIsDate(handle, row, col) > 0 ? true : false;
        }

        public bool isRichStr(int row, int col)
        {
            return xlSheetIsRichStr(handle, row, col) > 0 ? true : false;
        }

        public ErrorType readError(int row, int col)
        {
            return (ErrorType)xlSheetReadError(handle, row, col);
        }

        public void writeError(int row, int col, ErrorType error)
        {
            xlSheetWriteError(handle, row, col, (int)error, (IntPtr)0);
        }

        public void writeError(int row, int col, ErrorType error, Format format)
        {
            xlSheetWriteError(handle, row, col, (int)error, format.handle);
        }

        public double colWidth(int col)
        {
            return xlSheetColWidth(handle, col);
        }

        public double rowHeight(int row)
        {
            return xlSheetRowHeight(handle, row);
        }

        public int colWidthPx(int col)
        {
            return xlSheetColWidthPx(handle, col);
        }

        public int rowHeightPx(int row)
        {
            return xlSheetRowHeightPx(handle, row);
        }

        public bool setCol(int col, double width)
        {
            return setCol(col, col, width);
        }

        public bool setCol(int colFirst, int colLast, double width)
        {
            int result = xlSheetSetCol(handle, colFirst, colLast, width, (IntPtr)0, 0);
            return result > 0;
        }

        public bool setCol(int col, double width, Format format)
        {
            return setCol(col, col, width, format);
        }

        public bool setCol(int colFirst, int colLast, double width, Format format)
        {
            int result = xlSheetSetCol(handle, colFirst, colLast, width, format.handle, 0);
            return result > 0;
        }

        public bool setCol(int col, double width, Format format, bool hidden)
        {
            return setCol(col, col, width, format, hidden);
        }

        public bool setCol(int colFirst, int colLast, double width, Format format, bool hidden)
        {
            int result = xlSheetSetCol(handle, colFirst, colLast, width, (format == null) ? (IntPtr)0 : format.handle, hidden ? 1 : 0);
            return result > 0;
        }

        public bool setColPx(int col, int widthPx)
        {
            return setColPx(col, col, widthPx);
        }

        public bool setColPx(int colFirst, int colLast, int widthPx)
        {
            return xlSheetSetColPx(handle, colFirst, colLast, widthPx, IntPtr.Zero, 0) > 0;            
        }

        public bool setColPx(int col, int widthPx, Format format)
        {
            return setColPx(col, col, widthPx, format);
        }

        public bool setColPx(int colFirst, int colLast, int widthPx, Format format)
        {
            return xlSheetSetColPx(handle, colFirst, colLast, widthPx, format.handle, 0) > 0;            
        }

        public bool setColPx(int col, int widthPx, Format format, bool hidden)
        {
            return setColPx(col, col, widthPx, format, hidden);
        }

        public bool setColPx(int colFirst, int colLast, int widthPx, Format format, bool hidden)
        {
            return xlSheetSetColPx(handle, colFirst, colLast, widthPx, (format == null) ? IntPtr.Zero : format.handle, hidden ? 1 : 0) > 0;            
        }

        public bool setRow(int row, double height)
        {
            int result = xlSheetSetRow(handle, row, height, (IntPtr)0, 0);
            return result > 0;
        }

        public bool setRow(int row, double height, Format format)
        {
            int result = xlSheetSetRow(handle, row, height, format.handle, 0);
            return result > 0;
        }

        public bool setRow(int row, double height, Format format, bool hidden)
        {
            int result = xlSheetSetRow(handle, row, height, (format == null) ? (IntPtr)0 : format.handle, hidden ? 1 : 0);
            return result > 0;
        }

        public bool setRowPx(int row, int heightPx)
        {
            return xlSheetSetRowPx(handle, row, heightPx, IntPtr.Zero, 0) > 0;            
        }

        public bool setRowPx(int row, int heightPx, Format format)
        {
            return xlSheetSetRowPx(handle, row, heightPx, format.handle, 0) > 0;            
        }

        public bool setRowPx(int row, int heightPx, Format format, bool hidden)
        {
            return xlSheetSetRowPx(handle, row, heightPx, (format == null) ? (IntPtr)0 : format.handle, hidden ? 1 : 0) > 0;            
        }

        public bool rowHidden(int row)
        {
            return xlSheetRowHidden(handle, row) > 0 ? true : false;
        }

        public bool setRowHidden(int row, bool hidden)
        {
            int result = xlSheetSetRowHidden(handle, row, hidden ? 1 : 0);
            return result > 0;
        }

        public bool colHidden(int col)
        {
            return xlSheetColHidden(handle, col) > 0 ? true : false;
        }

        public bool setColHidden(int col, bool hidden)
        {
            int result = xlSheetSetColHidden(handle, col, hidden ? 1 : 0);
            return result > 0;
        }

        public double defaultRowHeight
        {
            get { return xlSheetDefaultRowHeight(handle); }
            set { xlSheetSetDefaultRowHeight(handle, value); }
        }

        public bool getMerge(int row, int col, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast)
        {
            return xlSheetGetMerge(handle, row, col, ref rowFirst, ref rowLast, ref colFirst, ref colLast) > 0 ? true : false;
        }

        public bool setMerge(int rowFirst, int rowLast, int colFirst, int colLast)
        {
            int result = xlSheetSetMerge(handle, rowFirst, rowLast, colFirst, colLast);
            return result > 0;
        }

        public bool delMerge(int row, int col)
        {
            int result = xlSheetDelMerge(handle, row, col);
            return result > 0;
        }

        public int mergeSize()
        {
            return xlSheetMergeSize(handle);
        }

        public bool merge(int index, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast)
        {
            int result = xlSheetMerge(handle, index, ref rowFirst, ref rowLast, ref colFirst, ref colLast);
            return result > 0;
        }

        public bool delMergeByIndex(int index)
        {
            int result = xlSheetDelMergeByIndex(handle, index);
            return result > 0;
        }

        public int pictureSize()
        {
            int result = xlSheetPictureSize(handle);
            return result;
        }

        public int getPicture(int index)
        {
            int rowTop = 0, colLeft = 0, rowBottom = 0, colRight = 0, width = 0, height = 0, offset_x = 0, offset_y = 0;

            int result = xlSheetGetPicture(handle, index, ref rowTop, ref colLeft, ref rowBottom, ref colRight,
                                                          ref width, ref height, ref offset_x, ref offset_y);
            return result;
        }

        public int getPicture(int index, ref int rowTop, ref int colLeft, ref int rowBottom, ref int colRight)
        {
            int width = 0, height = 0, offset_x = 0, offset_y = 0;

            int result = xlSheetGetPicture(handle, index, ref rowTop, ref colLeft, ref rowBottom, ref colRight,
                                                          ref width, ref height, ref offset_x, ref offset_y);
            return result;
        }

        public int getPicture(int index, ref int rowTop, ref int colLeft, ref int rowBottom, ref int colRight,
                                         ref int width, ref int height)
        {
            int offset_x = 0, offset_y = 0;

            int result = xlSheetGetPicture(handle, index, ref rowTop, ref colLeft, ref rowBottom, ref colRight,
                                                          ref width, ref height, ref offset_x, ref offset_y);
            return result;
        }

        public int getPicture(int index, ref int rowTop, ref int colLeft, ref int rowBottom, ref int colRight,
                                         ref int width, ref int height, ref int offset_x, ref int offset_y)
        {
            int result = xlSheetGetPicture(handle, index, ref rowTop, ref colLeft, ref rowBottom, ref colRight,
                                                          ref width, ref height, ref offset_x, ref offset_y);
            return result;
        }

        public bool removePictureByIndex(int index)
        {
            int result = xlSheetRemovePictureByIndex(handle, index);
            return result > 0;
        }

        public void setPicture(int row, int col, int pictureId)
        {
            setPicture(row, col, pictureId, 1);
        }

        public void setPicture(int row, int col, int pictureId, double scale)
        {
            xlSheetSetPicture(handle, row, col, pictureId, scale, 0, 0, (int)Position.POSITION_MOVE_AND_SIZE);
        }

        public void setPicture(int row, int col, int pictureId, double scale, int offset_x, int offset_y)
        {
            xlSheetSetPicture(handle, row, col, pictureId, scale, offset_x, offset_y, (int)Position.POSITION_MOVE_AND_SIZE);
        }

        public void setPicture(int row, int col, int pictureId, double scale, int offset_x, int offset_y, Position pos)
        {
            xlSheetSetPicture(handle, row, col, pictureId, scale, offset_x, offset_y, (int)pos);
        }

        public void setPicture(int row, int col, int pictureId, int width, int height)
        {
            xlSheetSetPicture2(handle, row, col, pictureId, width, height, 0, 0, (int)Position.POSITION_MOVE_AND_SIZE);
        }

        public void setPicture(int row, int col, int pictureId, int width, int height, int offset_x, int offset_y)
        {
            xlSheetSetPicture2(handle, row, col, pictureId, width, height, offset_x, offset_y, (int)Position.POSITION_MOVE_AND_SIZE);
        }

        public void setPicture(int row, int col, int pictureId, int width, int height, int offset_x, int offset_y, Position pos)
        {
            xlSheetSetPicture2(handle, row, col, pictureId, width, height, offset_x, offset_y, (int)pos);
        }

        public bool removePicture(int row, int col)
        {
            int result = xlSheetRemovePicture(handle, row, col);
            return result > 0;
        }

        public int getHorPageBreak(int index)
        {
            int result = xlSheetGetHorPageBreak(handle, index);
            return result;
        }

        public int getHorPageBreakSize()
        {
            int result = xlSheetGetHorPageBreakSize(handle);
            return result;
        }

        public int getVerPageBreak(int index)
        {
            int result = xlSheetGetVerPageBreak(handle, index);
            return result;
        }

        public int getVerPageBreakSize()
        {
            int result = xlSheetGetVerPageBreakSize(handle);
            return result;
        }

        public bool setHorPageBreak(int row)
        {
            int result = xlSheetSetHorPageBreak(handle, row, 1);
            return result > 0;
        }

        public bool delHorPageBreak(int row)
        {
            int result = xlSheetSetHorPageBreak(handle, row, 0);
            return result > 0;
        }

        public bool setVerPageBreak(int col)
        {
            int result = xlSheetSetVerPageBreak(handle, col, 1);
            return result > 0;
        }

        public bool delVerPageBreak(int col)
        {
            int result = xlSheetSetVerPageBreak(handle, col, 0);
            return result > 0;
        }

        public void split(int row, int col)
        {
            xlSheetSplit(handle, row, col);
        }

        public bool splitInfo(ref int row, ref int col)
        {
            return xlSheetSplitInfo(handle, ref row, ref col) > 0;
        }

        public bool groupRows(int rowFirst, int rowLast, bool collapsed)
        {
            int result = xlSheetGroupRows(handle, rowFirst, rowLast, collapsed ? 1 : 0);
            return result > 0;
        }

        public bool groupCols(int colFirst, int colLast, bool collapsed)
        {
            int result = xlSheetGroupCols(handle, colFirst, colLast, collapsed ? 1 : 0);
            return result > 0;
        }

        public bool groupSummaryBelow
        {
            get { return xlSheetGroupSummaryBelow(handle) > 0; }
            set { xlSheetSetGroupSummaryBelow(handle, value ? 1 : 0); }
        }

        public bool groupSummaryRight
        {
            get { return xlSheetGroupSummaryRight(handle) > 0; }
            set { xlSheetSetGroupSummaryRight(handle, value ? 1 : 0); }
        }

        public bool clear(int rowFirst, int rowLast, int colFirst, int colLast)
        {
            return xlSheetClear(handle, rowFirst, rowLast, colFirst, colLast) > 0;
        }

        public bool insertCol(int colFirst, int colLast)
        {
            int result = xlSheetInsertCol(handle, colFirst, colLast);
            return result > 0;
        }

        public bool insertRow(int rowFirst, int rowLast)
        {
            int result = xlSheetInsertRow(handle, rowFirst, rowLast);
            return result > 0;
        }

        public bool removeCol(int colFirst, int colLast)
        {
            int result = xlSheetRemoveCol(handle, colFirst, colLast);
            return result > 0;
        }

        public bool removeRow(int rowFirst, int rowLast)
        {
            int result = xlSheetRemoveRow(handle, rowFirst, rowLast);
            return result > 0;
        }

        public bool copyCell(int rowSrc, int colSrc, int rowDst, int colDst)
        {
            int result = xlSheetCopyCell(handle, rowSrc, colSrc, rowDst, colDst);
            return result > 0;
        }

        public int firstRow()
        {
            return xlSheetFirstRow(handle);
        }

        public int lastRow()
        {
            return xlSheetLastRow(handle);
        }

        public int firstCol()
        {
            return xlSheetFirstCol(handle);
        }

        public int lastCol()
        {
            return xlSheetLastCol(handle);
        }

        public int firstFilledRow()
        {
            return xlSheetFirstFilledRow(handle);
        }

        public int lastFilledRow()
        {
            return xlSheetLastFilledRow(handle);
        }

        public int firstFilledCol()
        {
            return xlSheetFirstFilledCol(handle);
        }

        public int lastFilledCol()
        {
            return xlSheetLastFilledCol(handle);
        }

        public bool displayGridlines
        {
            get { return xlSheetDisplayGridlines(handle) > 0; }
            set { xlSheetSetDisplayGridlines(handle, value ? 1 : 0); }
        }

        public bool printGridlines
        {
            get { return xlSheetPrintGridlines(handle) > 0; }
            set { xlSheetSetPrintGridlines(handle, value ? 1 : 0); }
        }

        public int zoom
        {
            get { return xlSheetZoom(handle); }
            set { xlSheetSetZoom(handle, value); }
        }

        public int printZoom
        {
            get { return xlSheetPrintZoom(handle); }
            set { xlSheetSetPrintZoom(handle, value); }
        }

        public bool getPrintFit(ref int wPages, ref int hPages)
        {
            return xlSheetGetPrintFit(handle, ref wPages, ref hPages) > 0;
        }

        public void setPrintFit(int wPages, int hPages)
        {
            xlSheetSetPrintFit(handle, wPages, hPages);
        }

        public bool landscape
        {
            get { return xlSheetLandscape(handle) > 0; }
            set { xlSheetSetLandscape(handle, value ? 1 : 0); }
        }

        public Paper paper
        {
            get { return (Paper)xlSheetPaper(handle); }
            set { xlSheetSetPaper(handle, (int)value); }
        }

        public string header
        {
            get
            {
                IntPtr pStr = xlSheetHeader(handle);
                String s = Marshal.PtrToStringAuto(pStr);
                return s;
            }

            set
            {
                xlSheetSetHeader(handle, value, 0.5);
            }
        }

        public double headerMargin
        {
            get
            {
                return xlSheetHeaderMargin(handle);
            }

            set
            {
                xlSheetSetHeader(handle, header, value);
            }
        }

        public string footer
        {
            get
            {
                IntPtr pStr = xlSheetFooter(handle);
                String s = Marshal.PtrToStringAuto(pStr);
                return s;
            }

            set
            {
                xlSheetSetFooter(handle, value, 0.5);
            }
        }

        public double footerMargin
        {
            get
            {
                return xlSheetFooterMargin(handle);
            }

            set
            {
                xlSheetSetFooter(handle, footer, value);
            }
        }

        public bool hCenter
        {
            get { return xlSheetHCenter(handle) > 0; }
            set { xlSheetSetHCenter(handle, value ? 1 : 0); }
        }

        public bool vCenter
        {
            get { return xlSheetVCenter(handle) > 0; }
            set { xlSheetSetVCenter(handle, value ? 1 : 0); }
        }

        public double marginLeft
        {
            get { return xlSheetMarginLeft(handle); }
            set { xlSheetSetMarginLeft(handle, value); }
        }

        public double marginRight
        {
            get { return xlSheetMarginRight(handle); }
            set { xlSheetSetMarginRight(handle, value); }
        }

        public double marginTop
        {
            get { return xlSheetMarginTop(handle); }
            set { xlSheetSetMarginTop(handle, value); }
        }

        public double marginBottom
        {
            get { return xlSheetMarginBottom(handle); }
            set { xlSheetSetMarginBottom(handle, value); }
        }

        public bool printRowCol
        {
            get { return xlSheetPrintRowCol(handle) > 0; }
            set { xlSheetSetPrintRowCol(handle, value ? 1 : 0); }
        }

        public bool printRepeatRows(ref int rowFirst, ref int rowLast)
        {
            return xlSheetPrintRepeatRows(handle, ref rowFirst, ref rowLast) > 0;
        }

        public void setPrintRepeatRows(int rowFirst, int rowLast)
        {
            xlSheetSetPrintRepeatRows(handle, rowFirst, rowLast);
        }

        public bool printRepeatCols(ref int colFirst, ref int colLast)
        {
            return xlSheetPrintRepeatCols(handle, ref colFirst, ref colLast) > 0;
        }

        public void setPrintRepeatCols(int colFirst, int colLast)
        {
            xlSheetSetPrintRepeatCols(handle, colFirst, colLast);
        }

        public bool printArea(ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast)
        {
            return xlSheetPrintArea(handle, ref rowFirst, ref rowLast, ref colFirst, ref colLast) > 0;
        }

        public void setPrintArea(int rowFirst, int rowLast, int colFirst, int colLast)
        {
            xlSheetSetPrintArea(handle, rowFirst, rowLast, colFirst, colLast);
        }

        public void clearPrintRepeats()
        {
            xlSheetClearPrintRepeats(handle);
        }

        public void clearPrintArea()
        {
            xlSheetClearPrintArea(handle);
        }

        public bool getNamedRange(string name, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast)
        {
            int hidden = 0;
            return xlSheetGetNamedRange(handle, name, ref rowFirst, ref rowLast, ref colFirst, ref colLast, (int)Scope.SCOPE_UNDEFINED, ref hidden) > 0 ? true : false;
        }

        public bool getNamedRange(string name, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast, int scopeId)
        {
            int hidden = 0;
            return xlSheetGetNamedRange(handle, name, ref rowFirst, ref rowLast, ref colFirst, ref colLast, scopeId, ref hidden) > 0 ? true : false;
        }

        public bool getNamedRange(string name, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast, int scopeId, ref bool hidden)
        {
            int iHidden = 0;
            int retValue = xlSheetGetNamedRange(handle, name, ref rowFirst, ref rowLast, ref colFirst, ref colLast, scopeId, ref iHidden);
            if (iHidden > 0)
            {
                hidden = true;
            }
            else
            {
                hidden = false;
            }
            return retValue > 0;
        }

        public bool setNamedRange(string name, int rowFirst, int rowLast, int colFirst, int colLast)
        {
            int result = xlSheetSetNamedRange(handle, name, rowFirst, rowLast, colFirst, colLast, (int)Scope.SCOPE_UNDEFINED);
            return result > 0;
        }

        public bool setNamedRange(string name, int rowFirst, int rowLast, int colFirst, int colLast, int scopeId)
        {
            int result = xlSheetSetNamedRange(handle, name, rowFirst, rowLast, colFirst, colLast, scopeId);
            return result > 0;
        }

        public bool delNamedRange(string name)
        {
            int result = xlSheetDelNamedRange(handle, name, (int)Scope.SCOPE_UNDEFINED);
            return result > 0;
        }

        public bool delNamedRange(string name, int scopeId)
        {
            int result = xlSheetDelNamedRange(handle, name, scopeId);
            return result > 0;
        }

        public int namedRangeSize()
        {
            int result = xlSheetNamedRangeSize(handle);
            return result;
        }

        public string namedRange(int index, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast)
        {
            int scopeId = 0;
            int hidden = 0;
            IntPtr pStr = xlSheetNamedRange(handle, index, ref rowFirst, ref rowLast, ref colFirst, ref colLast, ref scopeId, ref hidden);
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public string namedRange(int index, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast, ref int scopeId)
        {
            int hidden = 0;
            IntPtr pStr = xlSheetNamedRange(handle, index, ref rowFirst, ref rowLast, ref colFirst, ref colLast, ref scopeId, ref hidden);
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public string namedRange(int index, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast, ref int scopeId, ref bool hidden)
        {
            int iHidden = 0;
            IntPtr pStr = xlSheetNamedRange(handle, index, ref rowFirst, ref rowLast, ref colFirst, ref colLast, ref scopeId, ref iHidden);

            if (iHidden > 0)
            {
                hidden = true;
            }
            else
            {
                hidden = false;
            }

            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public bool getTable(string name, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast, ref int headerRowCount, ref int totalsRowCount)
        {
            return xlSheetGetTable(handle, name, ref rowFirst, ref rowLast, ref colFirst, ref colLast, ref headerRowCount, ref totalsRowCount) > 0;            
        }

        public int tableSize()
        {
            return xlSheetTableSize(handle);
        }

        public string table(int index, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast, ref int headerRowCount, ref int totalsRowCount)
        {
            IntPtr pStr = xlSheetTable(handle, index, ref rowFirst, ref rowLast, ref colFirst, ref colLast, ref headerRowCount, ref totalsRowCount);
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public int hyperlinkSize()
        {
            return xlSheetHyperlinkSize(handle);
        }

        public string hyperlink(int index, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast)
        {
            IntPtr pStr = xlSheetHyperlink(handle, index, ref rowFirst, ref rowLast, ref colFirst, ref colLast);
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public bool delHyperlink(int index)
        {
            int result = xlSheetDelHyperlink(handle, index);
            return result > 0;
        }

        public void addHyperlink(string name, int rowFirst, int rowLast, int colFirst, int colLast)
        {
            xlSheetAddHyperlink(handle, name, rowFirst, rowLast, colFirst, colLast);
        }

        public int hyperlinkIndex(int row, int col)
        {
            return xlSheetHyperlinkIndex(handle, row, col);
        }

        public bool isAutoFilter()
        {
            return xlSheetIsAutoFilter(handle) > 0;
        }

        public AutoFilter autoFilter()
        {
            IntPtr autoFilterHandle = xlSheetAutoFilter(handle);
            return new AutoFilter(autoFilterHandle, book);
        }

        public void applyFilter()
        {
            xlSheetApplyFilter(handle);
        }

        public void removeFilter()
        {
            xlSheetRemoveFilter(handle);
        }

        public string name
        {
            get
            {
                IntPtr pStr = xlSheetName(handle);
                String s = Marshal.PtrToStringAuto(pStr);
                return s;
            }
            set { xlSheetSetName(handle, value); }
        }

        public bool protect
        {
            get { return xlSheetProtect(handle) > 0; }
            set { xlSheetSetProtect(handle, value ? 1 : 0); }
        }

        public void setProtect(bool protect, string password)
        {
            xlSheetSetProtectEx(handle, protect ? 1 : 0, password, (int)EnhancedProtection.PROT_DEFAULT);
        }

        public void setProtect(bool protect, string password, EnhancedProtection prot)
        {
            xlSheetSetProtectEx(handle, protect ? 1 : 0, password, (int)prot);
        }

        public SheetState hidden
        {
            get { return (SheetState)xlSheetHidden(handle); }
            set { xlSheetSetHidden(handle, (int)value); }
        }

        public void getTopLeftView(ref int row, ref int col)
        {
            xlSheetGetTopLeftView(handle, ref row, ref col);
        }

        public void setTopLeftView(int row, int col)
        {
            xlSheetSetTopLeftView(handle, row, col);
        }

        public bool rightToLeft
        {
            get { return xlSheetRightToLeft(handle) > 0; }
            set { xlSheetSetRightToLeft(handle, value ? 1 : 0); }
        }

        public void setAutoFitArea(int rowFirst, int colFirst, int rowLast, int colLast)
        {
            xlSheetSetAutoFitArea(handle, rowFirst, colFirst, rowLast, colLast);
        }

        public void addrToRowCol(string addr, ref int row, ref int col)
        {
            int iRowRelative = 0;
            int iColRelative = 0;
            xlSheetAddrToRowCol(handle, addr, ref row, ref col, ref iRowRelative, ref iColRelative);
        }

        public void addrToRowCol(string addr, ref int row, ref int col, ref bool rowRelative, ref bool colRelative)
        {
            int iRowRelative = 0;
            int iColRelative = 0;
            xlSheetAddrToRowCol(handle, addr, ref row, ref col, ref iRowRelative, ref iColRelative);
            rowRelative = iRowRelative > 0;
            colRelative = iColRelative > 0;
        }

        public string rowColToAddr(int row, int col)
        {
            IntPtr pStr = xlSheetRowColToAddr(handle, row, col, 1, 1);
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public string rowColToAddr(int row, int col, bool rowRelative, bool colRelative)
        {
            IntPtr pStr = xlSheetRowColToAddr(handle, row, col, rowRelative ? 1 : 0, colRelative ? 1 : 0);
            String s = Marshal.PtrToStringAuto(pStr);
            return s;
        }

        public Color tabColor()
        {
            return (Color)xlSheetTabColor(handle);
        }

        public void setTabColor(Color color)
        {
            xlSheetSetTabColor(handle, (int)color);
        }

        public bool getTabColor(ref int red, ref int green, ref int blue)
        {
            return xlSheetGetTabRgbColor(handle, ref red, ref green, ref blue) > 0;
        }

        public void setTabColor(int red, int green, int blue)
        {
            xlSheetSetTabRgbColor(handle, red, green, blue);
        }

        public bool addIgnoredError(int rowFirst, int colFirst, int rowLast, int colLast, IgnoredError iError)
        {
            return xlSheetAddIgnoredError(handle, rowFirst, colFirst, rowLast, colLast, (int)iError) > 0;
        }

        public void addDataValidation(DataValidationType type, DataValidationOperator op, int rowFirst, int rowLast, int colFirst, int colLast, string value)
        {
            xlSheetAddDataValidation(handle, (int)type, (int)op, rowFirst, rowLast, colFirst, colLast, value, "");
        }

        public void addDataValidation(DataValidationType type, DataValidationOperator op, int rowFirst, int rowLast, int colFirst, int colLast, string value1, string value2)
        {
            xlSheetAddDataValidation(handle, (int)type, (int)op, rowFirst, rowLast, colFirst, colLast, value1, value2);
        }

        public void addDataValidation(DataValidationType type, DataValidationOperator op, int rowFirst, int rowLast, int colFirst, int colLast, string value1, string value2, bool allowBlank, bool hideDropDown, bool showInputMessage, bool showErrorMessage, string promptTitle, string prompt, string errorTitle, string error, DataValidationErrorStyle errorStyle)
        {
            xlSheetAddDataValidationEx(handle, (int)type, (int)op, rowFirst, rowLast, colFirst, colLast, value1, value2, allowBlank ? 1 : 0, hideDropDown ? 1 : 0, showInputMessage ? 1 : 0, showErrorMessage ? 1 : 0, promptTitle, prompt, errorTitle, error, (int)errorStyle);
        }

        public void addDataValidationDouble(DataValidationType type, DataValidationOperator op, int rowFirst, int rowLast, int colFirst, int colLast, double value)
        {
            xlSheetAddDataValidationDouble(handle, (int)type, (int)op, rowFirst, rowLast, colFirst, colLast, value, 0);
        }

        public void addDataValidationDouble(DataValidationType type, DataValidationOperator op, int rowFirst, int rowLast, int colFirst, int colLast, double value1, double value2)
        {
            xlSheetAddDataValidationDouble(handle, (int)type, (int)op, rowFirst, rowLast, colFirst, colLast, value1, value2);
        }

        public void addDataValidationDouble(DataValidationType type, DataValidationOperator op, int rowFirst, int rowLast, int colFirst, int colLast, double value1, double value2, bool allowBlank, bool hideDropDown, bool showInputMessage, bool showErrorMessage, string promptTitle, string prompt, string errorTitle, string error, DataValidationErrorStyle errorStyle)
        {
            xlSheetAddDataValidationDoubleEx(handle, (int)type, (int)op, rowFirst, rowLast, colFirst, colLast, value1, value2, allowBlank ? 1 : 0, hideDropDown ? 1 : 0, showInputMessage ? 1 : 0, showErrorMessage ? 1 : 0, promptTitle, prompt, errorTitle, error, (int)errorStyle);
        }

        public void removeDataValidations()
        {
            xlSheetRemoveDataValidations(handle);
        }

        public int formControlSize()
        {
            return xlSheetFormControlSize(handle);
        }

        public FormControl formControl(int index)
        {
            IntPtr formControlHandle = xlSheetFormControl(handle, index);
            if (formControlHandle != (IntPtr)0)
            {
                return new FormControl(formControlHandle);
            }
            return null;
        }

        public ConditionalFormatting addConditionalFormatting()
        {
            IntPtr conditionalFormattingHandle = xlSheetAddConditionalFormatting(handle);
            if (conditionalFormattingHandle != (IntPtr)0)
            {
                return new ConditionalFormatting(conditionalFormattingHandle);
            }
            return null;
        }

        public bool getActiveCell(ref int row, ref int col)
        {
            int result = xlSheetGetActiveCell(handle, ref row, ref col);
            return result > 0;
        }
        public void setActiveCell(int row, int col)
        {
            xlSheetSetActiveCell(handle, row, col);
        }
        public string selectionRange()
        {
            IntPtr pStr = xlSheetSelectionRange(handle);
            String s = Marshal.PtrToStringAuto(pStr);
            return s;            
        }
        public void addSelectionRange(string sqref)
        {
            xlSheetAddSelectionRange(handle, sqref);
        }
        public void removeSelection()
        {
            xlSheetRemoveSelection(handle);
        }

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetCellType(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetCellFormat(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetCellFormat(IntPtr handle, int row, int col, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetIsFormula(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetReadStr(IntPtr handle, int row, int col, ref IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetWriteStr(IntPtr handle, int row, int col, string value, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetReadRichStr(IntPtr handle, int row, int col, ref IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetWriteRichStr(IntPtr handle, int row, int col, IntPtr richStringHandle, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern double xlSheetReadNum(IntPtr handle, int row, int col, ref IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetWriteNum(IntPtr handle, int row, int col, double value, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetReadBool(IntPtr handle, int row, int col, ref IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetWriteBool(IntPtr handle, int row, int col, int value, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetReadBlank(IntPtr handle, int row, int col, ref IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetWriteBlank(IntPtr handle, int row, int col, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetReadFormula(IntPtr handle, int row, int col, ref IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetWriteFormula(IntPtr handle, int row, int col, string value, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetWriteFormulaNum(IntPtr handle, int row, int col, string expr, double value, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetWriteFormulaStr(IntPtr handle, int row, int col, string expr, string value, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetWriteFormulaBool(IntPtr handle, int row, int col, string expr, int value, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetReadComment(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetWriteComment(IntPtr handle, int row, int col, string value, string author, int width, int height);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetRemoveComment(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetIsDate(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetIsRichStr(IntPtr handle, int row, int col);
        
        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetReadError(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetWriteError(IntPtr handle, int row, int col, int error, IntPtr formatHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern double xlSheetColWidth(IntPtr handle, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern double xlSheetRowHeight(IntPtr handle, int row);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetColWidthPx(IntPtr handle, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetRowHeightPx(IntPtr handle, int row);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetCol(IntPtr handle, int colFirst, int colLast, double width, IntPtr formatHandle, int hidden);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetColPx(IntPtr handle, int colFirst, int colLast, int widthPx, IntPtr formatHandle, int hidden);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetRow(IntPtr handle, int row, double height, IntPtr formatHandle, int hidden);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetRowPx(IntPtr handle, int row, int heightPx, IntPtr formatHandle, int hidden);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetRowHidden(IntPtr handle, int row);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetRowHidden(IntPtr handle, int row, int hidden);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetColHidden(IntPtr handle, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetColHidden(IntPtr handle, int col, int hidden);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern double xlSheetDefaultRowHeight(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetDefaultRowHeight(IntPtr handle, double height);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetMerge(IntPtr handle, int row, int col, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetMerge(IntPtr handle, int rowFirst, int rowLast, int colFirst, int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetDelMerge(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetMergeSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetMerge(IntPtr handle, int index, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetDelMergeByIndex(IntPtr handle, int index);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetPictureSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetPicture(IntPtr handle, int index, ref int rowTop, ref int colLeft, ref int rowBottom, ref int colRight,
                                                                              ref int width, ref int height, ref int offset_x, ref int offset_y);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetRemovePictureByIndex(IntPtr handle, int index);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetPicture(IntPtr handle, int row, int col, int pictureId, double scale, int offset_x, int offset_y, int pos);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetPicture2(IntPtr handle, int row, int col, int pictureId, int width, int height, int offset_x, int offset_y, int pos);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetRemovePicture(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetHorPageBreak(IntPtr handle, int index);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetHorPageBreakSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetVerPageBreak(IntPtr handle, int index);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetVerPageBreakSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetHorPageBreak(IntPtr handle, int row, int pageBreak);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetVerPageBreak(IntPtr handle, int col, int pageBreak);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSplit(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSplitInfo(IntPtr handle, ref int row, ref int col);
      
        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGroupRows(IntPtr handle, int rowFirst, int rowLast, int collapsed);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGroupCols(IntPtr handle, int colFirst, int colLast, int collapsed);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGroupSummaryBelow(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetGroupSummaryBelow(IntPtr handle, int below);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGroupSummaryRight(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetGroupSummaryRight(IntPtr handle, int right);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetClear(IntPtr handle, int rowFirst, int rowLast, int colFirst, int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetInsertCol(IntPtr handle, int colFirst, int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetInsertRow(IntPtr handle, int rowFirst, int rowLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetRemoveCol(IntPtr handle, int colFirst, int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetRemoveRow(IntPtr handle, int rowFirst, int rowLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetCopyCell(IntPtr handle, int rowSrc, int colSrc, int rowDst, int colDst);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetFirstRow(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetLastRow(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetFirstCol(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetLastCol(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetFirstFilledRow(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetLastFilledRow(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetFirstFilledCol(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetLastFilledCol(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetDisplayGridlines(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetDisplayGridlines(IntPtr handle, int show);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetPrintGridlines(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetPrintGridlines(IntPtr handle, int print);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetZoom(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetZoom(IntPtr handle, int zoom);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetPrintZoom(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetPrintZoom(IntPtr handle, int zoom);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetPrintFit(IntPtr handle, ref int wPages, ref int hPages);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetPrintFit(IntPtr handle, int wPages, int hPages);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetLandscape(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetLandscape(IntPtr handle, int landscape);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetPaper(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetPaper(IntPtr handle, int paper);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetHeader(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetHeader(IntPtr handle, string header, double margin);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern double xlSheetHeaderMargin(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetFooter(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetFooter(IntPtr handle, string footer, double margin);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern double xlSheetFooterMargin(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetHCenter(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetHCenter(IntPtr handle, int hCenter);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetVCenter(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetVCenter(IntPtr handle, int vCenter);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern double xlSheetMarginLeft(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetMarginLeft(IntPtr handle, double margin);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern double xlSheetMarginRight(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetMarginRight(IntPtr handle, double margin);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern double xlSheetMarginTop(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetMarginTop(IntPtr handle, double margin);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern double xlSheetMarginBottom(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetMarginBottom(IntPtr handle, double margin);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetPrintRowCol(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetPrintRowCol(IntPtr handle, int print);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetPrintRepeatRows(IntPtr handle, ref int rowFirst, ref int rowLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetPrintRepeatRows(IntPtr handle, int rowFirst, int rowLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetPrintRepeatCols(IntPtr handle, ref int colFirst, ref int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetPrintRepeatCols(IntPtr handle, int colFirst, int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetPrintArea(IntPtr handle, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetPrintArea(IntPtr handle, int rowFirst, int rowLast, int colFirst, int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetClearPrintRepeats(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetClearPrintArea(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetNamedRange(IntPtr handle, string name, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast, int scopeId, ref int hidden);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetNamedRange(IntPtr handle, string name, int rowFirst, int rowLast, int colFirst, int colLast, int scopeId);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetDelNamedRange(IntPtr handle, string name, int scopeId);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetNamedRangeSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetNamedRange(IntPtr handle, int index, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast, ref int scopeId, ref int hidden);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetTable(IntPtr handle, string name, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast, ref int headerRowCount, ref int totalsRowCount);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetTableSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetTable(IntPtr handle, int index, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast, ref int headerRowCount, ref int totalsRowCount);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetHyperlinkSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetHyperlink(IntPtr handle, int index, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetDelHyperlink(IntPtr handle, int index);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetAddHyperlink(IntPtr handle, string hyperlink, int rowFirst, int rowLast, int colFirst, int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetHyperlinkIndex(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetIsAutoFilter(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetAutoFilter(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetApplyFilter(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetRemoveFilter(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetName(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetName(IntPtr handle, string name);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetProtect(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetProtect(IntPtr handle, int protect);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetProtectEx(IntPtr handle, int protect, string password, int enhancedProtection);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetHidden(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetSetHidden(IntPtr handle, int hidden);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetGetTopLeftView(IntPtr handle, ref int row, ref int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetTopLeftView(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetRightToLeft(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetRightToLeft(IntPtr handle, int rightToLeft);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetAutoFitArea(IntPtr handle, int rowFirst, int colFirst, int rowLast, int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetAddrToRowCol(IntPtr handle, string addr, ref int row, ref int col, ref int rowRelative, ref int colRelative);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetRowColToAddr(IntPtr handle, int row, int col, int rowRelative, int colRelative);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetTabColor(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetTabColor(IntPtr handle, int color);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetTabRgbColor(IntPtr handle, ref int red, ref int green, ref int blue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetTabRgbColor(IntPtr handle, int red, int green, int blue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetAddIgnoredError(IntPtr handle, int rowFirst, int colFirst, int rowLast, int colLast, int iError);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetAddDataValidation(IntPtr handle, int type, int op, int rowFirst, int rowLast, int colFirst, int colLast, string value1, string value2);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetAddDataValidationEx(IntPtr handle, int type, int op, int rowFirst, int rowLast, int colFirst, int colLast, string value1, string value2,
                                                              int allowBlank, int hideDropDown, int showInputMessage, int showErrorMessage, string promptTitle, string prompt, 
                                                              string errorTitle, string error, int errorStyle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetAddDataValidationDouble(IntPtr handle, int type, int op, int rowFirst, int rowLast, int colFirst, int colLast, double value1, double value2);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetAddDataValidationDoubleEx(IntPtr handle, int type, int op, int rowFirst, int rowLast, int colFirst, int colLast, double value1, double value2,
                                                              int allowBlank, int hideDropDown, int showInputMessage, int showErrorMessage, string promptTitle, string prompt, 
                                                              string errorTitle, string error, int errorStyle);
        
        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetRemoveDataValidations(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetFormControlSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetFormControl(IntPtr handle, int index);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetAddConditionalFormatting(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlSheetGetActiveCell(IntPtr handle, ref int row, ref int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetSetActiveCell(IntPtr handle, int row, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlSheetSelectionRange(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetAddSelectionRange(IntPtr handle, string sqref);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlSheetRemoveSelection(IntPtr handle);
    }
}
