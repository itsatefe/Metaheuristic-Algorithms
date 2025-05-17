///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                    LibXL C++ headers version 4.2.0                        //
//                                                                           //
//                 Copyright (c) 2008 - 2023 XLware s.r.o.                   //
//                                                                           //
//   THIS FILE AND THE SOFTWARE CONTAINED HEREIN IS PROVIDED 'AS IS' AND     //
//                COMES WITH NO WARRANTIES OF ANY KIND.                      //
//                                                                           //
//          Please define LIBXL_STATIC variable for static linking.          //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

#ifndef LIBXL_ICONDFORMATT_H
#define LIBXL_ICONDFORMATT_H

#include "setup.h"
#include "enum.h"

namespace libxl
{
    template<class TCHAR> struct IConditionalFormatT;

    template<class TCHAR>
    struct IConditionalFormattingT
    {
        virtual void XLAPIENTRY addRange(int rowFirst, int rowLast, int colFirst, int colLast) = 0;

        virtual void XLAPIENTRY addRule(CFormatType type, IConditionalFormatT<TCHAR>* cFormat, const TCHAR* value = 0, bool stopIfTrue = 0) = 0;

        virtual void XLAPIENTRY addTopRule(IConditionalFormatT<TCHAR>* cFormat, int value, bool bottom = false, bool percent = false, bool stopIfTrue = 0) = 0;

        virtual void XLAPIENTRY addOpNumRule(CFormatOperator op, IConditionalFormatT<TCHAR>* cFormat, double value1, double value2 = 0, bool stopIfTrue = 0) = 0;
        virtual void XLAPIENTRY addOpStrRule(CFormatOperator op, IConditionalFormatT<TCHAR>* cFormat, const TCHAR* value1, const TCHAR* value2 = 0, bool stopIfTrue = 0) = 0;

        virtual void XLAPIENTRY addAboveAverageRule(IConditionalFormatT<TCHAR>* cFormat, bool aboveAverage = true, bool equalAverage = false, int stdDev = 0, bool stopIfTrue = 0) = 0;

        virtual void XLAPIENTRY addTimePeriodRule(IConditionalFormatT<TCHAR>* cFormat, CFormatTimePeriod timePeriod, bool stopIfTrue = 0) = 0;

        virtual void XLAPIENTRY add2ColorScaleRule(Color minColor, Color maxColor, CFVOType minType = CFVO_MIN, double minValue = 0, CFVOType maxType = CFVO_MAX, double maxValue = 0, bool stopIfTrue = 0) = 0;
        virtual void XLAPIENTRY add2ColorScaleFormulaRule(Color minColor, Color maxColor, CFVOType minType = CFVO_FORMULA, const TCHAR* minValue = 0, CFVOType maxType = CFVO_FORMULA, const TCHAR* maxValue = 0, bool stopIfTrue = 0) = 0;

        virtual void XLAPIENTRY add3ColorScaleRule(Color minColor, Color midColor, Color maxColor, CFVOType minType = CFVO_MIN, double minValue = 0, CFVOType midType = CFVO_PERCENTILE, double midValue = 50, CFVOType maxType = CFVO_MAX, double maxValue = 0, bool stopIfTrue = 0) = 0;
        virtual void XLAPIENTRY add3ColorScaleFormulaRule(Color minColor, Color midColor, Color maxColor, CFVOType minType = CFVO_FORMULA, const TCHAR* minValue = 0, CFVOType midType = CFVO_FORMULA, const TCHAR* midValue = 0, CFVOType maxType = CFVO_FORMULA, const TCHAR* maxValue = 0, bool stopIfTrue = 0) = 0;

        virtual                 ~IConditionalFormattingT() {}
    };
}

#endif


