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

#ifndef LIBXL_IRICHSTRINGT_H
#define LIBXL_IRICHSTRINGT_H

#include "setup.h"

namespace libxl
{
    template<class TCHAR> struct IFontT;

    template<class TCHAR>
    struct IRichStringT
    {
        virtual IFontT<TCHAR>* XLAPIENTRY addFont(IFontT<TCHAR>* initFont = 0) = 0;
        virtual           void XLAPIENTRY addText(const TCHAR* text, IFontT<TCHAR>* font = 0) = 0;
        virtual   const TCHAR* XLAPIENTRY getText(int index, IFontT<TCHAR>** font = 0) = 0;
        virtual            int XLAPIENTRY textSize() const = 0;
        virtual                ~IRichStringT() {}
    };

}

#endif
