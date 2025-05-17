#include <iostream>
#include <windows.h>
#include "libxl.h"

using namespace libxl;

const wchar_t* filename = L"..\\generate\\example.xlsx";

int main() 
{
    Book* book = xlCreateXMLBook();
    if(book) 
    {                
        if(book->load(filename))
        {
            Sheet* sheet = book->getSheet(0);
            if(sheet) 
            {   
                double d = sheet->readNum(4, 1);
                sheet->writeNum(4, 1, d * 2);
                sheet->writeStr(10, 1, L"new string !");
            }

            if(book->save(filename))
            {
                std::wcout << "\nFile " << filename << " has been modified." << std::endl;
                ::ShellExecute(NULL, L"open", filename, NULL, NULL, SW_SHOW);
            }
            else
            {
                std::cout << book->errorMessage() << std::endl;
            }
        }
        else
        {
            std::cout << "At first run generate !" << std::endl;
        }

        book->release();   
    }
   
    return 0;
}
