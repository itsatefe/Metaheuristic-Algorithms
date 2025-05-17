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

#ifndef LIBXL_IAUTOFILTER_H
#define LIBXL_IAUTOFILTER_H

#include "setup.h"

namespace libxl
{
    template<class TCHAR> struct IFilterColumnT;

    template<class TCHAR>
    struct IAutoFilterT
    {
        virtual bool XLAPIENTRY getRef(int* rowFirst, int* rowLast, int* colFirst, int* colLast) = 0;
        virtual void XLAPIENTRY setRef(int rowFirst, int rowLast, int colFirst, int colLast) = 0;

        virtual IFilterColumnT<TCHAR>* XLAPIENTRY column(int colId) = 0;

        virtual int XLAPIENTRY columnSize() const = 0;
        virtual IFilterColumnT<TCHAR>* XLAPIENTRY columnByIndex(int index) = 0;

        virtual bool XLAPIENTRY getSortRange(int* rowFirst, int* rowLast, int* colFirst, int* colLast) = 0;

        virtual bool XLAPIENTRY getSort(int* columnIndex, bool* descending) = 0;
        virtual bool XLAPIENTRY setSort(int columnIndex, bool descending = false) = 0;
        virtual bool XLAPIENTRY addSort(int columnIndex, bool descending = false) = 0;

        virtual                 ~IAutoFilterT() {}
    };
}

#endif


