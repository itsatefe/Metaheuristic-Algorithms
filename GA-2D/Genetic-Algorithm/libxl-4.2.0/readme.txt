LibXL is a library for direct reading and writing Excel files.


Package contents:

  bin              32-bit dynamic library (libxl.dll) 
  bin64            64-bit dynamic library (libxl.dll)
  bin64_32         the same libraries with different names for 32-bit and 64-bit (can be used in the same folder)
  binarm64         ARM64 dynamic library (libxl.dll)
  doc              C++ documentation
  examples         C, C++, C#, Delphi and Fortran examples (MinGW, Visual Studio, Qt, Code::Blocks)
  include_c        headers for C
  include_cpp      headers for C++
  lib              Microsoft Visual C++ 32-bit import library for libxl.dll in the bin folder
  lib64            Microsoft Visual C++ 64-bit import library for libxl.dll in the bin64 folder
  lib64_32         the import libraries for dynamic libraries libxl32.dll and libxl64.dll from the bin64_32 folder
  libarm64         Microsoft Visual C++ ARM64 import library for libxl.dll in the binarm64 folder
  net              .NET wrapper (assembly)
  php              compiled plug-in for PHP 
  stdcall          32-bit dynamic library with the stdcall calling convention
  changelog.txt    version history
  libxl.url        link to home page
  license.txt      end-user license agreement
  readme.txt       this file


Using library:


1. Microsoft Visual C++

   - add include directory in your project, for example: c:\libxl\include_cpp

     Project -> Properties -> C/C++ -> General -> Additional Include Directories

   - add library directory in your project, for example: c:\libxl\lib
    
     Project -> Properties -> Linker -> General -> Additional Library Directories

   - add libxl.lib in project dependencies:
    
     Project -> Properties -> Linker -> Input -> Additional Dependencies

   - copy bin\libxl.dll to directory of your project
     

2. MinGW

   Type in examples/c++/mingw directory:

     g++ generate.cpp -o generate -I../../../include_cpp -L../../../bin -lxl
   
   Use mingw32-make for building examples.


3. C# and other .NET languages

   Use assembly libxl.net.dll in net directory: Project -> Add reference... -> Browse

   Also copy bin\libxl.dll to Debug or Release directory of your project.


4. Qt

   - add the following lines to a configuration file (.pro):

     INCLUDEPATH = c:/libxl-3.6.4.0/include_cpp
     LIBS += c:/libxl-3.6.4.0/lib/libxl.lib

   - copy bin\libxl.dll to the build directory of your project   
   

5. Borland C++ and Embarcadero C++ Builder

   - create an import library for your compiler:

       implib -a libxl.lib libxl.dll
     
   - add the include directory to your project, for example: c:\libxl-3.9.1.0\include_cpp
  
     Project -> Options -> Building -> C++ Compiler -> Directories and Conditionals -> Include file search path

     or 

     Project -> Options -> Directories/Conditionals -> Include path (for old C++ Bulder versions)

   - add library directory to your project (only for old C++ Builder versions)

     Project -> Options -> Directories/Conditionals -> Library path

   - add libxl.lib to your project

     Project -> Add to Project...

   - copy libxl.dll from the bin folder to <your_project_directory>/Win32/Debug or <your_project_directory>/Win32/Release folder

     If your target is "Windows 64-bit" copy libxl.dll from the bin64 folder.

6. Delphi

   - add the directory with the LibXL.pas unit, for example: c:\libxl-3.9.1.0\examples\delphi12

     Project -> Options -> Building -> Delphi Compiler -> Search path

   - copy libxl.dll from the bin folder to <your_project_directory>\Win32\Debug or <your_project_directory>\Win32\Release folder

Documentation:

  http://www.libxl.com/doc

Contact:

  support@libxl.com

