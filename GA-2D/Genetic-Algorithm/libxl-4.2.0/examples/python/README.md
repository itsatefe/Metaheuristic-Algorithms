# LibXLPy:
A libxl python wrapper, support both python2 and python3.

# Installation:

python setup.py install

# Issues

If you see the following error:

libxlpy.c:1:20: fatal error: Python.h: No such file or directory
 #include <Python.h>

Please install header files and a static library for Python:

apt-get install python-dev

# Dependencies:
* libxl

# Usage:
See tests under `./tests` folder.
