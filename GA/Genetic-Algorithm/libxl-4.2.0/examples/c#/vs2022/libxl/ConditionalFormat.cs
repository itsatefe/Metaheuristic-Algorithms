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
using System.Diagnostics.CodeAnalysis;
using System.Runtime.InteropServices;

namespace libxl
{
    public class ConditionalFormat
    {
        public IntPtr handle;
        Book book;

        public ConditionalFormat(IntPtr handle, Book book)
        {
            this.handle = handle;
            this.book = book;
        }

        public Font font
        {            
            get
            {
                IntPtr fontHandle = xlConditionalFormatFont(handle);

                if (fontHandle == IntPtr.Zero)
                    throw new XLError(book.errorMessage());
                                                                           
                return new Font(fontHandle, book);
            }
        }

        public NumFormat numFormat()
        {
            return (NumFormat)xlConditionalFormatNumFormat(handle);
        }

        public void setNumFormat(NumFormat numFormat)
        {
            xlConditionalFormatSetNumFormat(handle, (int)numFormat);
        }        
        public string customNumFormat()
        {
            return Book.ptrToString(xlConditionalFormatCustomNumFormat(handle));                  
        }
        public void setCustomNumFormat(string customNumFormat)
        {
            xlConditionalFormatSetCustomNumFormat(handle, customNumFormat);            
        }

        public void setBorder(BorderStyle style)
        {
            xlConditionalFormatSetBorder(handle, (int)style);
        }

        public void setBorderColor(Color color)
        {
            xlConditionalFormatSetBorderColor(handle, (int)color);
        }

        public BorderStyle borderLeft
        {
            get { return (BorderStyle)xlConditionalFormatBorderLeft(handle); }
            set { xlConditionalFormatSetBorderLeft(handle, (int)value); }
        }

        public BorderStyle borderRight
        {
            get { return (BorderStyle)xlConditionalFormatBorderRight(handle); }
            set { xlConditionalFormatSetBorderRight(handle, (int)value); }
        }

        public BorderStyle borderTop
        {
            get { return (BorderStyle)xlConditionalFormatBorderTop(handle); }
            set { xlConditionalFormatSetBorderTop(handle, (int)value); }
        }

        public BorderStyle borderBottom
        {
            get { return (BorderStyle)xlConditionalFormatBorderBottom(handle); }
            set { xlConditionalFormatSetBorderBottom(handle, (int)value); }
        }

        public Color borderLeftColor
        {
            get { return (Color)xlConditionalFormatBorderLeftColor(handle); }
            set { xlConditionalFormatSetBorderLeftColor(handle, (int)value); }
        }

        public Color borderRightColor
        {
            get { return (Color)xlConditionalFormatBorderRightColor(handle); }
            set { xlConditionalFormatSetBorderRightColor(handle, (int)value); }
        }

        public Color borderTopColor
        {
            get { return (Color)xlConditionalFormatBorderTopColor(handle); }
            set { xlConditionalFormatSetBorderTopColor(handle, (int)value); }
        }

        public Color borderBottomColor
        {
            get { return (Color)xlConditionalFormatBorderBottomColor(handle); }
            set { xlConditionalFormatSetBorderBottomColor(handle, (int)value); }
        }

        public FillPattern fillPattern
        {
            get { return (FillPattern)xlConditionalFormatFillPattern(handle); }
            set { xlConditionalFormatSetFillPattern(handle, (int)value); }
        }

        public Color patternForegroundColor
        {
            get { return (Color)xlConditionalFormatPatternForegroundColor(handle); }
            set { xlConditionalFormatSetPatternForegroundColor(handle, (int)value); }
        }

        public Color patternBackgroundColor
        {
            get { return (Color)xlConditionalFormatPatternBackgroundColor(handle); }
            set { xlConditionalFormatSetPatternBackgroundColor(handle, (int)value); }
        }      

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlConditionalFormatFont(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatNumFormat(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetNumFormat(IntPtr handle, int numFormat);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlConditionalFormatCustomNumFormat(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetCustomNumFormat(IntPtr handle, string customNumFormat);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetBorder(IntPtr handle, int style);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetBorderColor(IntPtr handle, int color);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatBorderLeft(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetBorderLeft(IntPtr handle, int style);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatBorderRight(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetBorderRight(IntPtr handle, int style);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatBorderTop(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetBorderTop(IntPtr handle, int style);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatBorderBottom(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetBorderBottom(IntPtr handle, int style);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatBorderLeftColor(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetBorderLeftColor(IntPtr handle, int color);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatBorderRightColor(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetBorderRightColor(IntPtr handle, int color);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatBorderTopColor(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetBorderTopColor(IntPtr handle, int color);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatBorderBottomColor(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetBorderBottomColor(IntPtr handle, int color);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatFillPattern(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetFillPattern(IntPtr handle, int pattern);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatPatternForegroundColor(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetPatternForegroundColor(IntPtr handle, int color);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlConditionalFormatPatternBackgroundColor(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormatSetPatternBackgroundColor(IntPtr handle, int color);

    }
}
