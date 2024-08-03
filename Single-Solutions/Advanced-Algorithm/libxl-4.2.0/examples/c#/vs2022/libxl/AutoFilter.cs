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
    public class AutoFilter
    {
        public IntPtr handle;
        Book book;

        public AutoFilter(IntPtr handle, Book book)
        {
            this.handle = handle;
            this.book = book;
        }

        public bool getRef(ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast)
        {
            return xlAutoFilterGetRef(handle, ref rowFirst, ref rowLast, ref colFirst, ref colLast) > 0;
        }

        public void setRef(int rowFirst, int rowLast, int colFirst, int colLast)
        {
            xlAutoFilterSetRef(handle, rowFirst, rowLast, colFirst, colLast);
        }

        public FilterColumn column(int colId)
        {
            IntPtr filterColumnHandle = xlAutoFilterColumn(handle, colId);

            if(filterColumnHandle == IntPtr.Zero)            
                throw new XLError(book.errorMessage());
            
            return new FilterColumn(filterColumnHandle, book);
        }

        public int columnSize()
        {
            return xlAutoFilterColumnSize(handle);
        }

        public FilterColumn columnByIndex(int index)
        {
            IntPtr filterColumnHandle = xlAutoFilterColumnByIndex(handle, index);

            if(filterColumnHandle == IntPtr.Zero)
                throw new XLError(book.errorMessage());

            return new FilterColumn(filterColumnHandle, book);
        }

        public bool getSortRange(ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast)
        {
            return xlAutoFilterGetSortRange(handle, ref rowFirst, ref rowLast, ref colFirst, ref colLast) > 0;
        }

        public bool getSort(ref int columnIndex, ref bool descending)
        {
            int iDescending = 0;
            bool status = xlAutoFilterGetSort(handle, ref columnIndex, ref iDescending) > 0;
            descending = iDescending > 0;
            return status;
        }

        public bool setSort(int columnIndex)
        {            
            return xlAutoFilterSetSort(handle, columnIndex, 0) > 0;            
        }

        public bool setSort(int columnIndex, bool descending)
        {
            return xlAutoFilterSetSort(handle, columnIndex, descending ? 1 : 0) > 0;
        }

        public bool addSort(int columnIndex, bool descending)
        {
            return xlAutoFilterAddSort(handle, columnIndex, descending ? 1 : 0) > 0;
        }
        
        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlAutoFilterGetRef(IntPtr handle, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlAutoFilterSetRef(IntPtr handle, int rowFirst, int rowLast, int colFirst, int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlAutoFilterColumn(IntPtr handle, int col);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlAutoFilterColumnSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr xlAutoFilterColumnByIndex(IntPtr handle, int index);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlAutoFilterGetSortRange(IntPtr handle, ref int rowFirst, ref int rowLast, ref int colFirst, ref int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlAutoFilterGetSort(IntPtr handle, ref int columnIndex, ref int descending);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlAutoFilterSetSort(IntPtr handle, int columnIndex, int descending);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlAutoFilterAddSort(IntPtr handle, int columnIndex, int descending);
    }
}

