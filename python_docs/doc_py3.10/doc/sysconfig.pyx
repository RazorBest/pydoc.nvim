Python 3.10.14
*sysconfig.pyx*                               Last change: 2024 May 24

"sysconfig" — Provide access to Python’s configuration information
******************************************************************

New in version 3.2.

**Source code:** Lib/sysconfig.py

======================================================================

The "sysconfig" module provides access to Python’s configuration
information like the list of installation paths and the configuration
variables relevant for the current platform.


Configuration variables
=======================

A Python distribution contains a "Makefile" and a "pyconfig.h" header
file that are necessary to build both the Python binary itself and
third-party C extensions compiled using "distutils".

"sysconfig" puts all variables found in these files in a dictionary
that can be accessed using "get_config_vars()" or "get_config_var()".

Notice that on Windows, it’s a much smaller set.

sysconfig.get_config_vars(*args)

   With no arguments, return a dictionary of all configuration
   variables relevant for the current platform.

   With arguments, return a list of values that result from looking up
   each argument in the configuration variable dictionary.

   For each argument, if the value is not found, return "None".

sysconfig.get_config_var(name)

   Return the value of a single variable _name_. Equivalent to
   "get_config_vars().get(name)".

   If _name_ is not found, return "None".

Example of usage:
>
   >>> import sysconfig
   >>> sysconfig.get_config_var('Py_ENABLE_SHARED')
   0
   >>> sysconfig.get_config_var('LIBDIR')
   '/usr/local/lib'
   >>> sysconfig.get_config_vars('AR', 'CXX')
   ['ar', 'g++']
<

Installation paths
==================

Python uses an installation scheme that differs depending on the
platform and on the installation options.  These schemes are stored in
"sysconfig" under unique identifiers based on the value returned by
"os.name".

Every new component that is installed using "distutils" or a
Distutils-based system will follow the same scheme to copy its file in
the right places.

Python currently supports six schemes:

* _posix_prefix_: scheme for POSIX platforms like Linux or macOS.
  This is the default scheme used when Python or a component is
  installed.

* _posix_home_: scheme for POSIX platforms used when a _home_ option
  is used upon installation.  This scheme is used when a component is
  installed through Distutils with a specific home prefix.

* _posix_user_: scheme for POSIX platforms used when a component is
  installed through Distutils and the _user_ option is used.  This
  scheme defines paths located under the user home directory.

* _nt_: scheme for NT platforms like Windows.

* _nt_user_: scheme for NT platforms, when the _user_ option is used.

* _osx_framework_user_: scheme for macOS, when the _user_ option is
  used.

Each scheme is itself composed of a series of paths and each path has
a unique identifier.  Python currently uses eight paths:

* _stdlib_: directory containing the standard Python library files
  that are not platform-specific.

* _platstdlib_: directory containing the standard Python library files
  that are platform-specific.

* _platlib_: directory for site-specific, platform-specific files.

* _purelib_: directory for site-specific, non-platform-specific files.

* _include_: directory for non-platform-specific header files.

* _platinclude_: directory for platform-specific header files.

* _scripts_: directory for script files.

* _data_: directory for data files.

"sysconfig" provides some functions to determine these paths.

sysconfig.get_scheme_names()

   Return a tuple containing all schemes currently supported in
   "sysconfig".

sysconfig.get_default_scheme()

   Return the default scheme name for the current platform.

   New in version 3.10: This function was previously named
   "_get_default_scheme()" and considered an implementation detail.

sysconfig.get_preferred_scheme(key)

   Return a preferred scheme name for an installation layout specified
   by _key_.

   _key_ must be either ""prefix"", ""home"", or ""user"".

   The return value is a scheme name listed in "get_scheme_names()".
   It can be passed to "sysconfig" functions that take a _scheme_
   argument, such as "get_paths()".

   New in version 3.10.

sysconfig._get_preferred_schemes()

   Return a dict containing preferred scheme names on the current
   platform. Python implementers and redistributors may add their
   preferred schemes to the "_INSTALL_SCHEMES" module-level global
   value, and modify this function to return those scheme names, to
   e.g. provide different schemes for system and language package
   managers to use, so packages installed by either do not mix with
   those by the other.

   End users should not use this function, but "get_default_scheme()"
   and "get_preferred_scheme()" instead.

   New in version 3.10.

sysconfig.get_path_names()

   Return a tuple containing all path names currently supported in
   "sysconfig".

sysconfig.get_path(name[, scheme[, vars[, expand]]])

   Return an installation path corresponding to the path _name_, from
   the install scheme named _scheme_.

   _name_ has to be a value from the list returned by
   "get_path_names()".

   "sysconfig" stores installation paths corresponding to each path
   name, for each platform, with variables to be expanded.  For
   instance the _stdlib_ path for the _nt_ scheme is: "{base}/Lib".

   "get_path()" will use the variables returned by "get_config_vars()"
   to expand the path.  All variables have default values for each
   platform so one may call this function and get the default value.

   If _scheme_ is provided, it must be a value from the list returned
   by "get_scheme_names()".  Otherwise, the default scheme for the
   current platform is used.

   If _vars_ is provided, it must be a dictionary of variables that
   will update the dictionary return by "get_config_vars()".

   If _expand_ is set to "False", the path will not be expanded using
   the variables.

   If _name_ is not found, raise a "KeyError".

sysconfig.get_paths([scheme[, vars[, expand]]])

   Return a dictionary containing all installation paths corresponding
   to an installation scheme. See "get_path()" for more information.

   If _scheme_ is not provided, will use the default scheme for the
   current platform.

   If _vars_ is provided, it must be a dictionary of variables that
   will update the dictionary used to expand the paths.

   If _expand_ is set to false, the paths will not be expanded.

   If _scheme_ is not an existing scheme, "get_paths()" will raise a
   "KeyError".


Other functions
===============

sysconfig.get_python_version()

   Return the "MAJOR.MINOR" Python version number as a string.
   Similar to "'%d.%d' % sys.version_info[:2]".

sysconfig.get_platform()

   Return a string that identifies the current platform.

   This is used mainly to distinguish platform-specific build
   directories and platform-specific built distributions.  Typically
   includes the OS name and version and the architecture (as supplied
   by ‘os.uname()’), although the exact information included depends
   on the OS; e.g., on Linux, the kernel version isn’t particularly
   important.

   Examples of returned values:

   * linux-i586

   * linux-alpha (?)

   * solaris-2.6-sun4u

   Windows will return one of:

   * win-amd64 (64bit Windows on AMD64, aka x86_64, Intel64, and
     EM64T)

   * win32 (all others - specifically, sys.platform is returned)

   macOS can return:

   * macosx-10.6-ppc

   * macosx-10.4-ppc64

   * macosx-10.3-i386

   * macosx-10.4-fat

   For other non-POSIX platforms, currently just returns
   "sys.platform".

sysconfig.is_python_build()

   Return "True" if the running Python interpreter was built from
   source and is being run from its built location, and not from a
   location resulting from e.g. running "make install" or installing
   via a binary installer.

sysconfig.parse_config_h(fp[, vars])

   Parse a "config.h"-style file.

   _fp_ is a file-like object pointing to the "config.h"-like file.

   A dictionary containing name/value pairs is returned.  If an
   optional dictionary is passed in as the second argument, it is used
   instead of a new dictionary, and updated with the values read in
   the file.

sysconfig.get_config_h_filename()

   Return the path of "pyconfig.h".

sysconfig.get_makefile_filename()

   Return the path of "Makefile".


Using "sysconfig" as a script
=============================

You can use "sysconfig" as a script with Python’s _-m_ option:
>
   $ python -m sysconfig
   Platform: "macosx-10.4-i386"
   Python version: "3.2"
   Current installation scheme: "posix_prefix"

   Paths:
           data = "/usr/local"
           include = "/Users/tarek/Dev/svn.python.org/py3k/Include"
           platinclude = "."
           platlib = "/usr/local/lib/python3.2/site-packages"
           platstdlib = "/usr/local/lib/python3.2"
           purelib = "/usr/local/lib/python3.2/site-packages"
           scripts = "/usr/local/bin"
           stdlib = "/usr/local/lib/python3.2"

   Variables:
           AC_APPLE_UNIVERSAL_BUILD = "0"
           AIX_GENUINE_CPLUSPLUS = "0"
           AR = "ar"
           ARFLAGS = "rc"
           ...
<
This call will print in the standard output the information returned
by "get_platform()", "get_python_version()", "get_path()" and
"get_config_vars()".

vim:tw=78:ts=8:ft=help:norl: