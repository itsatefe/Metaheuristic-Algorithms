---------------------
  LibXL Delphi unit
---------------------

1. Add the LibXL.pas file to your Delphi project. 

2. Add LibXL to your "uses" clause:

uses LibXL;

3. Copy the libxl.dll file from the bin folder to your project folder

4. LibXL functions are ready in your code:

var
  Book: TXLBook;
  Sheet: TXLSheet;
begin
  Book := TXmlBook.Create;
  Sheet := Book.addSheet('Sheet1');

  Sheet.writeStr(2, 1, 'Hello, World !');
  Sheet.writeNum(3, 1, 1000);

  Book.save('out.xlsx');
  Book.Free;
end;




