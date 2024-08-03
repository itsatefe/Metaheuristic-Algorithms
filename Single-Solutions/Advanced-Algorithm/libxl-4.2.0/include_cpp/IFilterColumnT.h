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

#ifndef LIBXL_IFILTERCOLUMN_H
#define LIBXL_IFILTERCOLUMN_H

#include "setup.h"
#include "enum.h"

namespace libxl
{
    template<class TCHAR>
    struct IFilterColumnT
    {
        virtual int XLAPIENTRY index() const = 0;

        virtual Filter XLAPIENTRY filterType() const = 0;

        virtual int XLAPIENTRY filterSize() const = 0;
        virtual const TCHAR* XLAPIENTRY filter(int index) const = 0;
        virtual void XLAPIENTRY addFilter(const TCHAR* value) = 0;

        virtual bool XLAPIENTRY getTop10(double* value, bool* top, bool* percent) = 0;
        virtual void XLAPIENTRY setTop10(double value, bool top = true, bool percent = false) = 0;

        virtual bool XLAPIENTRY getCustomFilter(Operator* op1, const TCHAR** v1, Operator* op2, const TCHAR** v2, bool* andOp) const = 0;
        virtual void XLAPIENTRY setCustomFilter(Operator op1, const TCHAR* v1, Operator op2 = OPERATOR_EQUAL, const TCHAR* v2 = 0, bool andOp = false) = 0;

        virtual void XLAPIENTRY clear() = 0;
    };
}

#endif


