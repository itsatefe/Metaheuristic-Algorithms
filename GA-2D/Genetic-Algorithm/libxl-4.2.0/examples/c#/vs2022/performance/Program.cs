using System;
using libxl;

const int maxRow = 20000;
const int maxCol = 256;

Random rand = new Random();
               
string makeString()
{            
    string s = "";
    for (int i = 0; i < 8; ++i) s += (char)(0x61 + rand.Next(26));
    return s;
}
                     
void test(int number)
{                
    Console.WriteLine("---------------------------------");
    if (number == 1)
    {
        Console.WriteLine("           strings               ");
    }
    else
    {
        Console.WriteLine("           numbers               ");
    }
    Console.WriteLine("---------------------------------\n");
            
    Book book = new XmlBook();                
    Sheet sheet = book.addSheet("Sheet1");

    Console.Write("writing {0:#,###} cells... ", (maxRow - 1) * maxCol);
    DateTime t1 = DateTime.Now;
            
    if (number == 1)
    {
        for (int row = 1; row < maxRow; ++row)
        {
            for (int col = 0; col < maxCol; ++col)
            {
                sheet.writeStr(row, col, makeString());
            }                        
        }                    
    }
    else
    {                    
        for (int row = 1; row < maxRow; ++row)
        {
            for (int col = 0; col < maxCol; ++col)
            {
                sheet.writeNum(row, col, 1234);
            }
        }                   
    }
            
    Console.WriteLine("ok");

    DateTime t2 = DateTime.Now;
    TimeSpan d = t2 - t1;
    Console.WriteLine("time: {0} sec", d.TotalSeconds);

    double n = (maxRow - 1) * maxCol / d.TotalSeconds;
    Console.WriteLine("speed: {0:#,###} cells/sec", n);
    Console.WriteLine();

    Console.Write("saving to xlsx... ");
            
    if (number == 1) {
        book.save("perfstr.xlsx");
    } else {
        book.save("perfnum.xlsx");
    }
                                           
    Console.WriteLine("ok");

    DateTime t3 = DateTime.Now;
    Console.WriteLine("time: {0} sec", (t3 - t2).TotalSeconds);
    Console.WriteLine();

    Console.WriteLine("total time: {0} sec", (t3 - t1).TotalSeconds);

    d = t3 - t1;
    n = (maxRow - 1) * maxCol / d.TotalSeconds;
    Console.WriteLine("speed with saving on disk: {0:#,###} cells/sec\n", n);
         
    GC.Collect();
    GC.WaitForPendingFinalizers();
    GC.Collect();        
}

try
{
    test(0);
    test(1);
}
catch (System.Exception e)
{
    Console.WriteLine(e.Message);
}
