using System;
using libxl;

const string filename = "..\\..\\..\\example.xlsx";

try
{
    Book book = new XmlBook();

    if (book.load(filename))
    {
        Sheet sheet = book.getSheet(0);

        string s = sheet.readStr(2, 1);
        Console.WriteLine(s);

        double d = sheet.readNum(3, 1);
        Console.WriteLine(d);
    }
}
catch (System.Exception e)
{
    Console.WriteLine(e.Message);
}
