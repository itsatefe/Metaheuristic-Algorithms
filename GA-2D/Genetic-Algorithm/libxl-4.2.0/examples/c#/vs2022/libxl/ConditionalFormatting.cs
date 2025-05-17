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
    public class ConditionalFormatting
    {
        public IntPtr handle;
        public ConditionalFormatting(IntPtr handle)
        {
            this.handle = handle;
        }

        public void addRange(int rowFirst, int rowLast, int colFirst, int colLast)
        {
            xlConditionalFormattingAddRange(handle, rowFirst, rowLast, colFirst, colLast);
        }

        public void addRule(CFormatType type, ConditionalFormat cFormat)
        {
            xlConditionalFormattingAddRule(handle, (int)type, cFormat.handle, "", 0);
        }

        public void addRule(CFormatType type, ConditionalFormat cFormat, string value)
        {
            xlConditionalFormattingAddRule(handle, (int)type, cFormat.handle, value, 0);
        }

        public void addRule(CFormatType type, ConditionalFormat cFormat, string value, bool stopIfTrue)
        {
            xlConditionalFormattingAddRule(handle, (int)type, cFormat.handle, value, stopIfTrue ? 1 : 0);
        }

        public void addTopRule(ConditionalFormat cFormat, int value)
        {
            xlConditionalFormattingAddTopRule(handle, cFormat.handle, value, 0, 0, 0);
        }

        public void addTopRule(ConditionalFormat cFormat, int value, bool bottom)
        {
            xlConditionalFormattingAddTopRule(handle, cFormat.handle, value, bottom ? 1 : 0, 0, 0);
        }

        public void addTopRule(ConditionalFormat cFormat, int value, bool bottom, bool percent)
        {
            xlConditionalFormattingAddTopRule(handle, cFormat.handle, value, bottom ? 1 : 0, percent ? 1 : 0, 0);
        }

        public void addTopRule(ConditionalFormat cFormat, int value, bool bottom, bool percent, bool stopIfTrue)
        {
            xlConditionalFormattingAddTopRule(handle, cFormat.handle, value, bottom ? 1 : 0, percent ? 1 : 0, stopIfTrue ? 1 : 0);
        }

        public void addOpNumRule(CFormatOperator op, ConditionalFormat cFormat, double value1)
        {
            xlConditionalFormattingAddOpNumRule(handle, (int)op, cFormat.handle, value1, 0, 0);
        }

        public void addOpNumRule(CFormatOperator op, ConditionalFormat cFormat, double value1, double value2)
        {
            xlConditionalFormattingAddOpNumRule(handle, (int)op, cFormat.handle, value1, value2, 0);
        }

        public void addOpNumRule(CFormatOperator op, ConditionalFormat cFormat, double value1, double value2, bool stopIfTrue)
        {
            xlConditionalFormattingAddOpNumRule(handle, (int)op, cFormat.handle, value1, value2, stopIfTrue ? 1 : 0);
        }

        public void addOpStrRule(CFormatOperator op, ConditionalFormat cFormat, string value1)
        {
            xlConditionalFormattingAddOpStrRule(handle, (int)op, cFormat.handle, value1, "", 0);
        }

        public void addOpStrRule(CFormatOperator op, ConditionalFormat cFormat, string value1, string value2)
        {
            xlConditionalFormattingAddOpStrRule(handle, (int)op, cFormat.handle, value1, value2, 0);
        }

        public void addOpStrRule(CFormatOperator op, ConditionalFormat cFormat, string value1, string value2, bool stopIfTrue)
        {
            xlConditionalFormattingAddOpStrRule(handle, (int)op, cFormat.handle, value1, value2, stopIfTrue ? 1 : 0);
        }

        public void addAboveAverageRule(ConditionalFormat cFormat)
        {
            xlConditionalFormattingAddAboveAverageRule(handle, cFormat.handle, 1, 0, 0, 0);
        }

        public void addAboveAverageRule(ConditionalFormat cFormat, bool aboveAverage)
        {
            xlConditionalFormattingAddAboveAverageRule(handle, cFormat.handle, aboveAverage ? 1 : 0, 0, 0, 0);
        }

        public void addAboveAverageRule(ConditionalFormat cFormat, bool aboveAverage, bool equalAverage)
        {
            xlConditionalFormattingAddAboveAverageRule(handle, cFormat.handle, aboveAverage ? 1 : 0, equalAverage ? 1 : 0, 0, 0);
        }

        public void addAboveAverageRule(ConditionalFormat cFormat, bool aboveAverage, bool equalAverage, int stdDev)
        {
            xlConditionalFormattingAddAboveAverageRule(handle, cFormat.handle, aboveAverage ? 1 : 0, equalAverage ? 1 : 0, stdDev, 0);
        }

        public void addAboveAverageRule(ConditionalFormat cFormat, bool aboveAverage, bool equalAverage, int stdDev, bool stopIfTrue)
        {
            xlConditionalFormattingAddAboveAverageRule(handle, cFormat.handle, aboveAverage ? 1 : 0, equalAverage ? 1 : 0, stdDev, stopIfTrue ? 1 : 0);
        }

        public void addTimePeriodRule(ConditionalFormat cFormat, CFormatTimePeriod timePeriod)
        {
            xlConditionalFormattingAddTimePeriodRule(handle, cFormat.handle, (int)timePeriod, 0);
        }
        public void addTimePeriodRule(ConditionalFormat cFormat, CFormatTimePeriod timePeriod, bool stopIfTrue)
        {
            xlConditionalFormattingAddTimePeriodRule(handle, cFormat.handle, (int)timePeriod, stopIfTrue ? 1 : 0);
        }

        public void add2ColorScaleRule(Color minColor, Color maxColor)
        {
            xlConditionalFormattingAdd2ColorScaleRule(handle, (int)minColor, (int)maxColor, 0, 0, 1, 0, 0);
        }

        public void add2ColorScaleRule(Color minColor, Color maxColor, CFVOType minType, double minValue, CFVOType maxType, double maxValue)
        {
            xlConditionalFormattingAdd2ColorScaleRule(handle, (int)minColor, (int)maxColor, (int)minType, minValue, (int)maxType, maxValue, 0);
        }

        public void add2ColorScaleRule(Color minColor, Color maxColor, CFVOType minType, double minValue, CFVOType maxType, double maxValue, bool stopIfTrue)
        {
            xlConditionalFormattingAdd2ColorScaleRule(handle, (int)minColor, (int)maxColor, (int)minType, minValue, (int)maxType, maxValue, stopIfTrue ? 1 : 0);
        }

        public void add2ColorScaleFormulaRule(Color minColor, Color maxColor, CFVOType minType, string minValue, CFVOType maxType, string maxValue)
        {
            xlConditionalFormattingAdd2ColorScaleFormulaRule(handle, (int)minColor, (int)maxColor, (int)minType, minValue, (int)maxType, maxValue, 0);
        }

        public void add2ColorScaleFormulaRule(Color minColor, Color maxColor, CFVOType minType, string minValue, CFVOType maxType, string maxValue, bool stopIfTrue)
        {
            xlConditionalFormattingAdd2ColorScaleFormulaRule(handle, (int)minColor, (int)maxColor, (int)minType, minValue, (int)maxType, maxValue, stopIfTrue ? 1 : 0);
        }

        public void add3ColorScaleRule(Color minColor, Color midColor, Color maxColor)
        {
            xlConditionalFormattingAdd3ColorScaleRule(handle, (int)minColor, (int)midColor, (int)maxColor, 0, 0, 5, 50, 1, 0, 0);
        }

        public void add3ColorScaleRule(Color minColor, Color midColor, Color maxColor, CFVOType minType, double minValue, CFVOType midType, double midValue, CFVOType maxType, double maxValue)
        {
            xlConditionalFormattingAdd3ColorScaleRule(handle, (int)minColor, (int)midColor, (int)maxColor, (int)minType, minValue, (int)midType, midValue, (int)maxType, maxValue, 0);
        }

        public void add3ColorScaleRule(Color minColor, Color midColor, Color maxColor, CFVOType minType, double minValue, CFVOType midType, double midValue, CFVOType maxType, double maxValue, bool stopIfTrue)
        {
            xlConditionalFormattingAdd3ColorScaleRule(handle, (int)minColor, (int)midColor, (int)maxColor, (int)minType, minValue, (int)midType, midValue, (int)maxType, maxValue, stopIfTrue ? 1 : 0);
        }

        public void add3ColorScaleFormulaRule(Color minColor, Color midColor, Color maxColor, CFVOType minType, string minValue, CFVOType midType, string midValue, CFVOType maxType, string maxValue)
        {
            xlConditionalFormattingAdd3ColorScaleFormulaRule(handle, (int)minColor, (int)midColor, (int)maxColor, (int)minType, minValue, (int)midType, midValue, (int)maxType, maxValue, 0);
        }

        public void add3ColorScaleFormulaRule(Color minColor, Color midColor, Color maxColor, CFVOType minType, string minValue, CFVOType midType, string midValue, CFVOType maxType, string maxValue, bool stopIfTrue)
        {
            xlConditionalFormattingAdd3ColorScaleFormulaRule(handle, (int)minColor, (int)midColor, (int)maxColor, (int)minType, minValue, (int)midType, midValue, (int)maxType, maxValue, stopIfTrue ? 1 : 0);
        }

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAddRange(IntPtr handle, int rowFirst, int rowLast, int colFirst, int colLast);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAddRule(IntPtr handle, int type, IntPtr cFormat, string value, int stopIfTrue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAddTopRule(IntPtr handle, IntPtr cFormat, int value, int bottom, int percent, int stopIfTrue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAddOpNumRule(IntPtr handle, int op, IntPtr cFormat, double value1, double value2, int stopIfTrue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAddOpStrRule(IntPtr handle, int op, IntPtr cFormat, string value1, string value2, int stopIfTrue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAddAboveAverageRule(IntPtr handle, IntPtr cFormat, int aboveAverage, int equalAverage, int stdDev, int stopIfTrue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAddTimePeriodRule(IntPtr handle, IntPtr cFormat, int timePeriod, int stopIfTrue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAdd2ColorScaleRule(IntPtr handle, int minColor, int maxColor, int minType, double minValue, int maxType, double maxValue, int stopIfTrue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAdd2ColorScaleFormulaRule(IntPtr handle, int minColor, int maxColor, int minType, string minValue, int maxType, string maxValue, int stopIfTrue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAdd3ColorScaleRule(IntPtr handle, int minColor, int midColor, int maxColor, int minType, double minValue, int midType, double midValue, int maxType, double maxValue, int stopIfTrue);

        [DllImport("libxl.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]
        private static extern void xlConditionalFormattingAdd3ColorScaleFormulaRule(IntPtr handle, int minColor, int midColor, int maxColor, int minType, string minValue, int midType, string midValue, int maxType, string maxValue, int stopIfTrue);
    }
}

