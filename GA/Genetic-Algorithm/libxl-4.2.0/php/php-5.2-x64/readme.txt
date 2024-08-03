VC9 x64 Thread Safe compiled LibXL plug-in for PHP 5.2 
(Ilia Alshanetsky https://github.com/iliaal/php_excel)

How to use:

1. Copy the php_excel.dll file to the "ext" folder inside your PHP folder. It should be the same folder as specified in the "extension_dir" parameter 
   inside your php.ini file.
2. Copy the libxl.dll from the "bin64" folder to your Apache "bin" folder or add the "<LIBXL_PATH>\bin64" folder to your PATH environment variable.
3. Go to your php.ini file and add the following line there:

   extension=php_excel.dll

4. Restart your webserver. The LibXL plug-in is ready for using.
