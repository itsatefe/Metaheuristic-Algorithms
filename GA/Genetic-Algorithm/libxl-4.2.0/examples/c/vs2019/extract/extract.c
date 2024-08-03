#include <stdio.h>
#include "libxl.h"

int main()
{
    BookHandle book = xlCreateXMLBook();
    if(book) 
    {
        if(xlBookLoad(book, L"example.xlsx")) 
        {
            SheetHandle sheet = xlBookGetSheet(book, 0);
            if(sheet)
            {
                double d;
                const wchar_t* s = xlSheetReadStr(sheet, 2, 1, 0);

                if(s) wprintf(L"%s\n", s);

                d = xlSheetReadNum(sheet, 3, 1, 0);
                printf("%g\n", d);
            }
        }     
       
        xlBookRelease(book);
    }

    return 0;
}
