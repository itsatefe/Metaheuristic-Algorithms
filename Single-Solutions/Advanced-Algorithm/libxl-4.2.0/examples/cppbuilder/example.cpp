#pragma hdrstop
#pragma argsused

#ifdef _WIN32
  #include <tchar.h>
  #include <windows.h>
#else
  typedef char _TCHAR;
  #define _tmain main
#endif
#include "libxl.h"

int _tmain(int argc, _TCHAR* argv[])
{
	libxl::Book* book = xlCreateXMLBook();

	libxl::Sheet* sheet = book->addSheet("Sheet1");

	sheet->writeStr(2, 1, "Hello, World !");
	sheet->writeNum(4, 1, 1000);
	sheet->writeNum(5, 1, 2000);

	libxl::Font* font = book->addFont();
	font->setColor(libxl::COLOR_RED);
	font->setBold(true);
	libxl::Format* boldFormat = book->addFormat();
	boldFormat->setFont(font);
	sheet->writeFormula(6, 1, "SUM(B5:B6)", boldFormat);

	libxl::Format* dateFormat = book->addFormat();
	dateFormat->setNumFormat(libxl::NUMFORMAT_DATE);
	sheet->writeNum(8, 1, book->datePack(2008, 4, 29), dateFormat);

	sheet->setCol(1, 1, 12);

	book->save("out.xlsx");

	::ShellExecute(NULL, "open", "out.xlsx", NULL, NULL, SW_SHOW);

	book->release();

	return 0;
}
