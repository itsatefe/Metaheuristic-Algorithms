using System;
using System.Diagnostics;
using libxl;

const string filename = "..\\..\\..\\example.xlsx";

try
{
    Book book = new XmlBook();

    if (book.load(filename))
    {
        Sheet sheet = book.getSheet(0);
        double d = sheet.readNum(3, 1);
        sheet.writeNum(3, 1, d * 2);
        sheet.writeStr(4, 1, "new string");
        book.save(filename);

        System.Diagnostics.ProcessStartInfo startInfo = new ProcessStartInfo();
        startInfo.FileName = filename;
        startInfo.UseShellExecute = true;
        System.Diagnostics.Process.Start(startInfo);
    }
}
catch (System.Exception e)
{
    Console.WriteLine(e.Message);
}
