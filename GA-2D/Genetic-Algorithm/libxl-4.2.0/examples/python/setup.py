
from distutils.core import setup, Extension
import platform
import os.path
import re

def get_version():
    filename = os.path.join(os.path.dirname(__file__), './version.h')
    file = None
    try:
        file = open(filename)
        header = file.read()
    finally:
        if file:
            file.close()
    m = re.search(r'#define\s+LIBXLPY_VERSION\s+"(\d+\.\d+(?:\.\d+)?)"', header)
    return m.group(1)

if platform.architecture()[0] == '32bit':
    extra_link_args = ['-L../../lib', '-lxl', '-Wl,-rpath,../../lib']
else:
    extra_link_args = ['-L../../lib64', '-lxl', '-Wl,-rpath,../../lib64']

module = Extension('libxlpy'
        , sources = [
            'libxlpy.c',
            'book.c',
            'sheet.c',
            'format.c',
            'font.c'
            ]
        , extra_compile_args = ['-I../../include_c']
        , extra_link_args = extra_link_args
        )
 
setup (name = 'libxlpy'
        , version = get_version()
        , description = 'libxl python wrapper'
        , ext_modules = [module]
        )
