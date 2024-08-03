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
                double d = xlSheetReadNum(sheet, 3, 1, 0);
                xlSheetWriteNum(sheet, 3, 1, d * 2, 0);
                xlSheetWriteStr(sheet, 4, 1, L"new string", 0);     
            }

            if(xlBookSave(book, L"example.xlsx")) printf("\nFile example.xlsx has been modified.\n");
        } 

        xlBookRelease(book);
    }

    return 0;
}
