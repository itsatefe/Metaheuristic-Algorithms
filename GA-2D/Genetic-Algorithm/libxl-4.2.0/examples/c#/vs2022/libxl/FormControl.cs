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
    public class FormControl
    {
        public IntPtr handle;        

        public FormControl(IntPtr handle)
        {
            this.handle = handle;     
        }

        public ObjectType objectType
        {
            get { return (ObjectType)xlFormControlObjectType(handle); }
        }

        public CheckedType isChecked
        {
            get { return (CheckedType)xlFormControlChecked(handle); }
            set { xlFormControlSetChecked(handle, (int)value); }
        }

        public string fmlaGroup
        {
            get { return xlFormControlFmlaGroup(handle); }
            set { xlFormControlSetFmlaGroup(handle, value); }
        }

        public string fmlaLink
        {
            get { return xlFormControlFmlaLink(handle); }
            set { xlFormControlSetFmlaLink(handle, value); }
        }

        public string fmlaRange
        {
            get { return xlFormControlFmlaRange(handle); }
            set { xlFormControlSetFmlaRange(handle, value); }
        }

        public string fmlaTxbx
        {
            get { return xlFormControlFmlaTxbx(handle); }
            set { xlFormControlSetFmlaTxbx(handle, value); }
        }

        public string name
        {
            get { return xlFormControlName(handle); }
        }
        public string linkedCell
        {
            get { return xlFormControlLinkedCell(handle); }
        }
        public string listFillRange
        {
            get { return xlFormControlListFillRange(handle); }
        }
        public string macro
        {
            get { return xlFormControlMacro(handle); }
        }
        public string altText
        {
            get { return xlFormControlAltText(handle); }
        }
        public bool locked
        {
            get { return xlFormControlLocked(handle) > 0; }
        }
        public bool defaultSize
        {
            get { return xlFormControlDefaultSize(handle) > 0; }
        }
        public bool print
        {
            get { return xlFormControlPrint(handle) > 0; }
        }
        public bool disabled
        {
            get { return xlFormControlDisabled(handle) > 0; }
        }

        public string item(int index)
        {
            return xlFormControlItem(handle, index);
        }

        public int itemSize()
        {
            return xlFormControlItemSize(handle);
        }

        public void addItem(string value)
        {
            xlFormControlAddItem(handle, value);
        }
        public void insertItem(int index, string value)
        {
            xlFormControlInsertItem(handle, index, value);
        }
        public void clearItems()
        {
            xlFormControlClearItems(handle);
        }

        public int dropLines
        {
            get { return xlFormControlDropLines(handle); }
            set { xlFormControlSetDropLines(handle, value); }
        }
        public int dx
        {
            get { return xlFormControlDx(handle); }
            set { xlFormControlSetDx(handle, value); }
        }

        public bool firstButton
        {
            get { return xlFormControlFirstButton(handle) > 0; }
            set { xlFormControlSetFirstButton(handle, value ? 1 : 0); }
        }
        public bool horiz
        {
            get { return xlFormControlHoriz(handle) > 0; }
            set { xlFormControlSetHoriz(handle, value ? 1 : 0); }
        }
        public int inc
        {
            get { return xlFormControlInc(handle); }
            set { xlFormControlSetInc(handle, value); }
        }
        public int max
        {
            get { return xlFormControlGetMax(handle); }
            set { xlFormControlSetMax(handle, value); }
        }
        public int min
        {
            get { return xlFormControlGetMin(handle); }
            set { xlFormControlSetMin(handle, value); }
        }

        public string multiSel
        {
            get { return xlFormControlMultiSel(handle); }
            set { xlFormControlSetMultiSel(handle, value); }
        }
        public int sel
        {
            get { return xlFormControlSel(handle); }
            set { xlFormControlSetSel(handle, value); }
        }

        public bool fromAnchor(ref int col, ref int colOff, ref int row, ref int rowOff)
        {
            return xlFormControlFromAnchor(handle, ref col, ref colOff, ref row, ref rowOff) > 0;
        }
        public bool toAnchor(ref int col, ref int colOff, ref int row, ref int rowOff)
        {
            return xlFormControlToAnchor(handle, ref col, ref colOff, ref row, ref rowOff) > 0;
        }

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlObjectType(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlChecked(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetChecked(IntPtr handle, int index);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlFmlaGroup(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetFmlaGroup(IntPtr handle, string group);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlFmlaLink(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetFmlaLink(IntPtr handle, string link);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlFmlaRange(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetFmlaRange(IntPtr handle, string range);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlFmlaTxbx(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetFmlaTxbx(IntPtr handle, string txbx);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlName(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlLinkedCell(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlListFillRange(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlMacro(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlAltText(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlLocked(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlDefaultSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlPrint(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlDisabled(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlItem(IntPtr handle, int index);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlItemSize(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlAddItem(IntPtr handle, string value);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlInsertItem(IntPtr handle, int index, string value);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlClearItems(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlDropLines(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetDropLines(IntPtr handle, int index);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlDx(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetDx(IntPtr handle, int dx);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlFirstButton(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetFirstButton(IntPtr handle, int firstButton);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlHoriz(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetHoriz(IntPtr handle, int horiz);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlInc(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetInc(IntPtr handle, int inc);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlGetMax(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetMax(IntPtr handle, int max);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlGetMin(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetMin(IntPtr handle, int min);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern string xlFormControlMultiSel(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetMultiSel(IntPtr handle, string value);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlSel(IntPtr handle);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlFormControlSetSel(IntPtr handle, int sel);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlFromAnchor(IntPtr handle, ref int col, ref int colOff, ref int row, ref int rowOff);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern int xlFormControlToAnchor(IntPtr handle, ref int col, ref int colOff, ref int row, ref int rowOff);
    }
}

