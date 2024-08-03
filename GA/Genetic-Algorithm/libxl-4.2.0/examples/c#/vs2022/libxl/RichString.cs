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

namespace libxl
{
    public class RichString
    {
        public IntPtr handle;
        Book book;

        public RichString(IntPtr handle, Book book)
        {
            this.handle = handle;
            this.book = book;
        }

        public Font addFont()
        {
            IntPtr fontHandle = xlRichStringAddFont(handle, IntPtr.Zero);

            if (fontHandle == IntPtr.Zero)
                throw new XLError(book.errorMessage());

            return new Font(fontHandle, book);
        }

        public Font addFont(Font initFont)
        {
            IntPtr fontHandle = xlRichStringAddFont(handle, initFont.handle);

            if (fontHandle == IntPtr.Zero)
                throw new XLError(book.errorMessage());
                                       
            return new Font(fontHandle, book);            
        }

        public void addText(string text)
        {
            xlRichStringAddText(handle, text, IntPtr.Zero);
        }

        public void addText(string text, Font font)
        {
            xlRichStringAddText(handle, text, font.handle);
        }

        public string getText(int index)
        {
            IntPtr fontHandle = IntPtr.Zero;
            return Book.ptrToString(xlRichStringGetText(handle, index, ref fontHandle));            
        }

        public string getText(int index, ref Font font)
        {
            IntPtr fontHandle = IntPtr.Zero;
            IntPtr pStr = xlRichStringGetText(handle, index, ref fontHandle);
            if (fontHandle != IntPtr.Zero)
            {
                font = new Font(fontHandle, book);
            }
            return Book.ptrToString(pStr);
        }

        public int textSize()
        {
            return xlRichStringTextSize(handle);
        }

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlRichStringAddFont(IntPtr handle, IntPtr fontHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlRichStringAddText(IntPtr handle, string text, IntPtr fontHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlRichStringGetText(IntPtr handle, int index, ref IntPtr fontHandle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlRichStringTextSize(IntPtr handle);
    }
}

