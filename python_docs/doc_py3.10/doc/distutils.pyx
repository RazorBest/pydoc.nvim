Python 3.10.14
*distutils.pyx*                               Last change: 2024 May 24

"distutils" — Building and installing Python modules
****************************************************

======================================================================

"distutils" is deprecated with removal planned for Python 3.12. See
the What’s New entry for more information.

======================================================================

The "distutils" package provides support for building and installing
additional modules into a Python installation.  The new modules may be
either 100%-pure Python, or may be extension modules written in C, or
may be collections of Python packages which include modules coded in
both Python and C.

Most Python users will _not_ want to use this module directly, but
instead use the cross-version tools maintained by the Python Packaging
Authority. In particular, setuptools is an enhanced alternative to
"distutils" that provides:

* support for declaring project dependencies

* additional mechanisms for configuring which files to include in
  source releases (including plugins for integration with version
  control systems)

* the ability to declare project “entry points”, which can be used as
  the basis for application plugin systems

* the ability to automatically generate Windows command line
  executables at installation time rather than needing to prebuild
  them

* consistent behaviour across all supported Python versions

The recommended pip installer runs all "setup.py" scripts with
"setuptools", even if the script itself only imports "distutils".
Refer to the Python Packaging User Guide for more information.

For the benefits of packaging tool authors and users seeking a deeper
understanding of the details of the current packaging and distribution
system, the legacy "distutils" based user documentation and API
reference remain available:

* Installing Python Modules (Legacy version)

* Distributing Python Modules (Legacy version)

vim:tw=78:ts=8:ft=help:norl: