<?php
$useXlsxFormat = true;
$xlBook = new \ExcelBook('<YOUR_LICENSE_NAME>', '<YOUR_LICENSE_KEY>', $useXlsxFormat);
$xlBook->setLocale('UTF-8');
$xlSheet = $xlBook->addSheet('Sheet1');
$xlSheet->write(3, 3, 'Hello world!');
$xlBook->save('test.xlsx');
?>

