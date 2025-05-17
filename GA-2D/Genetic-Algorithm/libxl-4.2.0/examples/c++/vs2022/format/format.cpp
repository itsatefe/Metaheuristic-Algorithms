#include <iostream>
#include <windows.h>
#include "libxl.h"

using namespace libxl;

const wchar_t* filename = L"format.xlsx";

int main() 
{
    Book* book = xlCreateXMLBook();
    if(book) 
    {         
        Font* font = book->addFont();
        font->setName(L"Impact");
        font->setSize(36);        

        Format* format = book->addFormat();
        format->setAlignH(ALIGNH_CENTER);
        format->setBorder(BORDERSTYLE_MEDIUMDASHDOTDOT);
        format->setBorderColor(COLOR_RED);
        format->setFont(font);
	               
        Sheet* sheet = book->addSheet(L"Custom");
        if(sheet)
        {
            sheet->writeStr(2, 1, L"Format", format);
            sheet->setCol(1, 1, 25);
        }

        if(book->save(filename))
        {
            ::ShellExecute(NULL, L"open", filename, NULL, NULL, SW_SHOW);
        }
    }
    
    return 0;
}
