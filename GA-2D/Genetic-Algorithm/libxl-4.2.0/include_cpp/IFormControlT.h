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

#ifndef LIBXL_IFORMCONTROLT_H
#define LIBXL_IFORMCONTROLT_H

#include "setup.h"
#include "enum.h"

namespace libxl
{
    template<class TCHAR>
    struct IFormControlT
    {
        virtual     ObjectType XLAPIENTRY objectType() const = 0;

        virtual    CheckedType XLAPIENTRY checked() const = 0;
        virtual           void XLAPIENTRY setChecked(CheckedType checked) = 0;

        virtual   const TCHAR* XLAPIENTRY fmlaGroup() = 0;
        virtual           void XLAPIENTRY setFmlaGroup(const TCHAR* group) = 0;

        virtual   const TCHAR* XLAPIENTRY fmlaLink() = 0;
        virtual           void XLAPIENTRY setFmlaLink(const TCHAR* link) = 0;

        virtual   const TCHAR* XLAPIENTRY fmlaRange() = 0;
        virtual           void XLAPIENTRY setFmlaRange(const TCHAR* range) = 0;

        virtual   const TCHAR* XLAPIENTRY fmlaTxbx() = 0;
        virtual           void XLAPIENTRY setFmlaTxbx(const TCHAR* txbx) = 0;

        virtual   const TCHAR* XLAPIENTRY name() = 0;
        virtual   const TCHAR* XLAPIENTRY linkedCell() = 0;
        virtual   const TCHAR* XLAPIENTRY listFillRange() = 0;
        virtual   const TCHAR* XLAPIENTRY macro() = 0;
        virtual   const TCHAR* XLAPIENTRY altText() = 0;

        virtual           bool XLAPIENTRY locked() const = 0;
        virtual           bool XLAPIENTRY defaultSize() const = 0;
        virtual           bool XLAPIENTRY print() const = 0;
        virtual           bool XLAPIENTRY disabled() const = 0;

        virtual   const TCHAR* XLAPIENTRY item(int index) = 0;
        virtual            int XLAPIENTRY itemSize() const = 0;
        virtual           void XLAPIENTRY addItem(const TCHAR* value) = 0;
        virtual           void XLAPIENTRY insertItem(int index, const TCHAR* value) = 0;
        virtual           void XLAPIENTRY clearItems() = 0;

        virtual           int XLAPIENTRY dropLines() const = 0;
        virtual          void XLAPIENTRY setDropLines(int lines) = 0;

        virtual           int XLAPIENTRY dx() const = 0;
        virtual          void XLAPIENTRY setDx(int dx) = 0;

        virtual          bool XLAPIENTRY firstButton() const = 0;
        virtual          void XLAPIENTRY setFirstButton(bool firstButton) = 0;

        virtual          bool XLAPIENTRY horiz() const = 0;
        virtual          void XLAPIENTRY setHoriz(bool horiz) = 0;

        virtual           int XLAPIENTRY inc() const = 0;
        virtual          void XLAPIENTRY setInc(int inc) = 0;

        virtual           int XLAPIENTRY getMax() const = 0;
        virtual          void XLAPIENTRY setMax(int max) = 0;

        virtual           int XLAPIENTRY getMin() const = 0;
        virtual          void XLAPIENTRY setMin(int min) = 0;

        virtual  const TCHAR* XLAPIENTRY multiSel() const = 0;
        virtual          void XLAPIENTRY setMultiSel(const TCHAR* value) = 0;

        virtual           int XLAPIENTRY sel() const = 0;
        virtual          void XLAPIENTRY setSel(int sel) = 0;

        virtual           bool XLAPIENTRY fromAnchor(int* col, int* colOff, int* row, int* rowOff) = 0;
        virtual           bool XLAPIENTRY toAnchor(int* col, int* colOff, int* row, int* rowOff) = 0;

        virtual                ~IFormControlT() {}
    };

}

#endif

