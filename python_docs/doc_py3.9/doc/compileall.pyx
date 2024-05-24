Python 3.9.19
*compileall.pyx*                              Last change: 2024 May 24

"compileall" — Byte-compile Python libraries
********************************************

**Source code:** Lib/compileall.py

======================================================================

This module provides some utility functions to support installing
Python libraries.  These functions compile Python source files in a
directory tree. This module can be used to create the cached byte-code
files at library installation time, which makes them available for use
even by users who don’t have write permission to the library
directories.


Command-line use
================

This module can work as a script (using **python -m compileall**) to
compile Python sources.

directory ...
file ...

   Positional arguments are files to compile or directories that
   contain source files, traversed recursively.  If no argument is
   given, behave as if the command line was "-l <directories from
   sys.path>".

-l

   Do not recurse into subdirectories, only compile source code files
   directly contained in the named or implied directories.

-f

   Force rebuild even if timestamps are up-to-date.

-q

   Do not print the list of files compiled. If passed once, error
   messages will still be printed. If passed twice ("-qq"), all output
   is suppressed.

-d destdir

   Directory prepended to the path to each file being compiled.  This
   will appear in compilation time tracebacks, and is also compiled in
   to the byte-code file, where it will be used in tracebacks and
   other messages in cases where the source file does not exist at the
   time the byte-code file is executed.

-s strip_prefix

-p prepend_prefix

   Remove ("-s") or append ("-p") the given prefix of paths recorded
   in the ".pyc" files. Cannot be combined with "-d".

-x regex

   regex is used to search the full path to each file considered for
   compilation, and if the regex produces a match, the file is
   skipped.

-i list

   Read the file "list" and add each line that it contains to the list
   of files and directories to compile.  If "list" is "-", read lines
   from "stdin".

-b

   Write the byte-code files to their legacy locations and names,
   which may overwrite byte-code files created by another version of
   Python.  The default is to write files to their **PEP 3147**
   locations and names, which allows byte-code files from multiple
   versions of Python to coexist.

-r

   Control the maximum recursion level for subdirectories. If this is
   given, then "-l" option will not be taken into account. **python -m
   compileall <directory> -r 0** is equivalent to **python -m
   compileall <directory> -l**.

-j N

   Use _N_ workers to compile the files within the given directory. If
   "0" is used, then the result of "os.cpu_count()" will be used.

--invalidation-mode [timestamp|checked-hash|unchecked-hash]

   Control how the generated byte-code files are invalidated at
   runtime. The "timestamp" value, means that ".pyc" files with the
   source timestamp and size embedded will be generated. The "checked-
   hash" and "unchecked-hash" values cause hash-based pycs to be
   generated. Hash-based pycs embed a hash of the source file contents
   rather than a timestamp. See Cached bytecode invalidation for more
   information on how Python validates bytecode cache files at
   runtime. The default is "timestamp" if the "SOURCE_DATE_EPOCH"
   environment variable is not set, and "checked-hash" if the
   "SOURCE_DATE_EPOCH" environment variable is set.

-o level

   Compile with the given optimization level. May be used multiple
   times to compile for multiple levels at a time (for example,
   "compileall -o 1 -o 2").

-e dir

   Ignore symlinks pointing outside the given directory.

--hardlink-dupes

   If two ".pyc" files with different optimization level have the same
   content, use hard links to consolidate duplicate files.

Changed in version 3.2: Added the "-i", "-b" and "-h" options.

Changed in version 3.5: Added the  "-j", "-r", and "-qq" options.
"-q" option was changed to a multilevel value.  "-b" will always
produce a byte-code file ending in ".pyc", never ".pyo".

Changed in version 3.7: Added the "--invalidation-mode" option.

Changed in version 3.9: Added the "-s", "-p", "-e" and "--hardlink-
dupes" options. Raised the default recursion limit from 10 to
"sys.getrecursionlimit()". Added the possibility to specify the "-o"
option multiple times.

There is no command-line option to control the optimization level used
by the "compile()" function, because the Python interpreter itself
already provides the option: **python -O -m compileall**.

Similarly, the "compile()" function respects the "sys.pycache_prefix"
setting. The generated bytecode cache will only be useful if
"compile()" is run with the same "sys.pycache_prefix" (if any) that
will be used at runtime.


Public functions
================

compileall.compile_dir(dir, maxlevels=sys.getrecursionlimit(), ddir=None, force=False, rx=None, quiet=0, legacy=False, optimize=-1, workers=1, invalidation_mode=None, *, stripdir=None, prependdir=None, limit_sl_dest=None, hardlink_dupes=False)

   Recursively descend the directory tree named by _dir_, compiling
   all ".py" files along the way. Return a true value if all the files
   compiled successfully, and a false value otherwise.

   The _maxlevels_ parameter is used to limit the depth of the
   recursion; it defaults to "sys.getrecursionlimit()".

   If _ddir_ is given, it is prepended to the path to each file being
   compiled for use in compilation time tracebacks, and is also
   compiled in to the byte-code file, where it will be used in
   tracebacks and other messages in cases where the source file does
   not exist at the time the byte-code file is executed.

   If _force_ is true, modules are re-compiled even if the timestamps
   are up to date.

   If _rx_ is given, its "search" method is called on the complete
   path to each file considered for compilation, and if it returns a
   true value, the file is skipped. This can be used to exclude files
   matching a regular expression, given as a re.Pattern object.

   If _quiet_ is "False" or "0" (the default), the filenames and other
   information are printed to standard out. Set to "1", only errors
   are printed. Set to "2", all output is suppressed.

   If _legacy_ is true, byte-code files are written to their legacy
   locations and names, which may overwrite byte-code files created by
   another version of Python.  The default is to write files to their
   **PEP 3147** locations and names, which allows byte-code files from
   multiple versions of Python to coexist.

   _optimize_ specifies the optimization level for the compiler.  It
   is passed to the built-in "compile()" function. Accepts also a
   sequence of optimization levels which lead to multiple compilations
   of one ".py" file in one call.

   The argument _workers_ specifies how many workers are used to
   compile files in parallel. The default is to not use multiple
   workers. If the platform can’t use multiple workers and _workers_
   argument is given, then sequential compilation will be used as a
   fallback.  If _workers_ is 0, the number of cores in the system is
   used.  If _workers_ is lower than "0", a "ValueError" will be
   raised.

   _invalidation_mode_ should be a member of the
   "py_compile.PycInvalidationMode" enum and controls how the
   generated pycs are invalidated at runtime.

   The _stripdir_, _prependdir_ and _limit_sl_dest_ arguments
   correspond to the "-s", "-p" and "-e" options described above. They
   may be specified as "str", "bytes" or "os.PathLike".

   If _hardlink_dupes_ is true and two ".pyc" files with different
   optimization level have the same content, use hard links to
   consolidate duplicate files.

   Changed in version 3.2: Added the _legacy_ and _optimize_
   parameter.

   Changed in version 3.5: Added the _workers_ parameter.

   Changed in version 3.5: _quiet_ parameter was changed to a
   multilevel value.

   Changed in version 3.5: The _legacy_ parameter only writes out
   ".pyc" files, not ".pyo" files no matter what the value of
   _optimize_ is.

   Changed in version 3.6: Accepts a _path-like object_.

   Changed in version 3.7: The _invalidation_mode_ parameter was
   added.

   Changed in version 3.7.2: The _invalidation_mode_ parameter’s
   default value is updated to None.

   Changed in version 3.8: Setting _workers_ to 0 now chooses the
   optimal number of cores.

   Changed in version 3.9: Added _stripdir_, _prependdir_,
   _limit_sl_dest_ and _hardlink_dupes_ arguments. Default value of
   _maxlevels_ was changed from "10" to "sys.getrecursionlimit()"

compileall.compile_file(fullname, ddir=None, force=False, rx=None, quiet=0, legacy=False, optimize=-1, invalidation_mode=None, *, stripdir=None, prependdir=None, limit_sl_dest=None, hardlink_dupes=False)

   Compile the file with path _fullname_. Return a true value if the
   file compiled successfully, and a false value otherwise.

   If _ddir_ is given, it is prepended to the path to the file being
   compiled for use in compilation time tracebacks, and is also
   compiled in to the byte-code file, where it will be used in
   tracebacks and other messages in cases where the source file does
   not exist at the time the byte-code file is executed.

   If _rx_ is given, its "search" method is passed the full path name
   to the file being compiled, and if it returns a true value, the
   file is not compiled and "True" is returned. This can be used to
   exclude files matching a regular expression, given as a re.Pattern
   object.

   If _quiet_ is "False" or "0" (the default), the filenames and other
   information are printed to standard out. Set to "1", only errors
   are printed. Set to "2", all output is suppressed.

   If _legacy_ is true, byte-code files are written to their legacy
   locations and names, which may overwrite byte-code files created by
   another version of Python.  The default is to write files to their
   **PEP 3147** locations and names, which allows byte-code files from
   multiple versions of Python to coexist.

   _optimize_ specifies the optimization level for the compiler.  It
   is passed to the built-in "compile()" function. Accepts also a
   sequence of optimization levels which lead to multiple compilations
   of one ".py" file in one call.

   _invalidation_mode_ should be a member of the
   "py_compile.PycInvalidationMode" enum and controls how the
   generated pycs are invalidated at runtime.

   The _stripdir_, _prependdir_ and _limit_sl_dest_ arguments
   correspond to the "-s", "-p" and "-e" options described above. They
   may be specified as "str", "bytes" or "os.PathLike".

   If _hardlink_dupes_ is true and two ".pyc" files with different
   optimization level have the same content, use hard links to
   consolidate duplicate files.

   New in version 3.2.

   Changed in version 3.5: _quiet_ parameter was changed to a
   multilevel value.

   Changed in version 3.5: The _legacy_ parameter only writes out
   ".pyc" files, not ".pyo" files no matter what the value of
   _optimize_ is.

   Changed in version 3.7: The _invalidation_mode_ parameter was
   added.

   Changed in version 3.7.2: The _invalidation_mode_ parameter’s
   default value is updated to None.

   Changed in version 3.9: Added _stripdir_, _prependdir_,
   _limit_sl_dest_ and _hardlink_dupes_ arguments.

compileall.compile_path(skip_curdir=True, maxlevels=0, force=False, quiet=0, legacy=False, optimize=-1, invalidation_mode=None)

   Byte-compile all the ".py" files found along "sys.path". Return a
   true value if all the files compiled successfully, and a false
   value otherwise.

   If _skip_curdir_ is true (the default), the current directory is
   not included in the search.  All other parameters are passed to the
   "compile_dir()" function.  Note that unlike the other compile
   functions, "maxlevels" defaults to "0".

   Changed in version 3.2: Added the _legacy_ and _optimize_
   parameter.

   Changed in version 3.5: _quiet_ parameter was changed to a
   multilevel value.

   Changed in version 3.5: The _legacy_ parameter only writes out
   ".pyc" files, not ".pyo" files no matter what the value of
   _optimize_ is.

   Changed in version 3.7: The _invalidation_mode_ parameter was
   added.

   Changed in version 3.7.2: The _invalidation_mode_ parameter’s
   default value is updated to None.

To force a recompile of all the ".py" files in the "Lib/" subdirectory
and all its subdirectories:
>
   import compileall

   compileall.compile_dir('Lib/', force=True)

   # Perform same compilation, excluding files in .svn directories.
   import re
   compileall.compile_dir('Lib/', rx=re.compile(r'[/\\][.]svn'), force=True)

   # pathlib.Path objects can also be used.
   import pathlib
   compileall.compile_dir(pathlib.Path('Lib/'), force=True)
<
See also:

  Module "py_compile"
     Byte-compile a single source file.

vim:tw=78:ts=8:ft=help:norl: