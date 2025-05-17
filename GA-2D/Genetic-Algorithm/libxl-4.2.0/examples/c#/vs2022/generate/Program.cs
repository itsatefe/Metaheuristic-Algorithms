using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using libxl;

const string filename = "example.xlsx";

try
{
    Book book = new XmlBook();    
    Sheet sheet = book.addSheet("Sheet1");
    
    sheet.writeStr(2, 1, "Hello, World !");
    sheet.writeNum(3, 1, 1000);

    Format dateFormat = book.addFormat();    
    dateFormat.setNumFormat(NumFormat.NUMFORMAT_DATE);        
    sheet.writeNum(4, 1, book.datePack(2008, 4, 29), dateFormat);                
    sheet.setCol(1, 1, 12);
    book.save(filename);

    System.Diagnostics.ProcessStartInfo startInfo = new ProcessStartInfo();
    startInfo.FileName = filename;
    startInfo.UseShellExecute = true;
    System.Diagnostics.Process.Start(startInfo);    
}
catch (System.Exception e)
{
    Console.WriteLine(e.Message);
}


