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

#ifndef LIBXL_ICFORMATT_H
#define LIBXL_ICFORMATT_H

#include "setup.h"
#include "enum.h"

namespace libxl
{
    template<class TCHAR> struct IFontT;

    template<class TCHAR>
    struct IConditionalFormatT
    {

        virtual IFontT<TCHAR>* XLAPIENTRY font() = 0;

        virtual      NumFormat XLAPIENTRY numFormat() const = 0;
        virtual           void XLAPIENTRY setNumFormat(NumFormat numFormat) = 0;

        virtual   const TCHAR* XLAPIENTRY customNumFormat() const = 0;
        virtual           void XLAPIENTRY setCustomNumFormat(const TCHAR* customNumFormat) = 0;

        virtual           void XLAPIENTRY setBorder(BorderStyle style = BORDERSTYLE_THIN) = 0;
        virtual           void XLAPIENTRY setBorderColor(Color color) = 0;

        virtual    BorderStyle XLAPIENTRY borderLeft() const = 0;
        virtual           void XLAPIENTRY setBorderLeft(BorderStyle style = BORDERSTYLE_THIN) = 0;

        virtual    BorderStyle XLAPIENTRY borderRight() const = 0;
        virtual           void XLAPIENTRY setBorderRight(BorderStyle style = BORDERSTYLE_THIN) = 0;

        virtual    BorderStyle XLAPIENTRY borderTop() const = 0;
        virtual           void XLAPIENTRY setBorderTop(BorderStyle style = BORDERSTYLE_THIN) = 0;

        virtual    BorderStyle XLAPIENTRY borderBottom() const = 0;
        virtual           void XLAPIENTRY setBorderBottom(BorderStyle style = BORDERSTYLE_THIN) = 0;

        virtual          Color XLAPIENTRY borderLeftColor() const = 0;
        virtual           void XLAPIENTRY setBorderLeftColor(Color color) = 0;

        virtual          Color XLAPIENTRY borderRightColor() const = 0;
        virtual           void XLAPIENTRY setBorderRightColor(Color color) = 0;

        virtual          Color XLAPIENTRY borderTopColor() const = 0;
        virtual           void XLAPIENTRY setBorderTopColor(Color color) = 0;

        virtual          Color XLAPIENTRY borderBottomColor() const = 0;
        virtual           void XLAPIENTRY setBorderBottomColor(Color color) = 0;

        virtual    FillPattern XLAPIENTRY fillPattern() const = 0;
        virtual           void XLAPIENTRY setFillPattern(FillPattern pattern) = 0;

        virtual          Color XLAPIENTRY patternForegroundColor() const = 0;
        virtual           void XLAPIENTRY setPatternForegroundColor(Color color) = 0;

        virtual          Color XLAPIENTRY patternBackgroundColor() const = 0;
        virtual           void XLAPIENTRY setPatternBackgroundColor(Color color) = 0;

        virtual                           ~IConditionalFormatT() {}
    };

}

#endif

