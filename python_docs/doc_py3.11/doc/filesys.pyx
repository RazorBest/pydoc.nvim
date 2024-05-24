Python 3.11.9
*filesys.pyx*                                 Last change: 2024 May 24

File and Directory Access
*************************

The modules described in this chapter deal with disk files and
directories.  For example, there are modules for reading the
properties of files, manipulating paths in a portable way, and
creating temporary files.  The full list of modules in this chapter
is:

* "pathlib" — Object-oriented filesystem paths

  * Basic use

  * Pure paths

    * General properties

    * Operators

    * Accessing individual parts

    * Methods and properties

  * Concrete paths

    * Methods

  * Correspondence to tools in the "os" module

* "os.path" — Common pathname manipulations

* "fileinput" — Iterate over lines from multiple input streams

* "stat" — Interpreting "stat()" results

* "filecmp" — File and Directory Comparisons

  * The "dircmp" class

* "tempfile" — Generate temporary files and directories

  * Examples

  * Deprecated functions and variables

* "glob" — Unix style pathname pattern expansion

* "fnmatch" — Unix filename pattern matching

* "linecache" — Random access to text lines

* "shutil" — High-level file operations

  * Directory and files operations

    * Platform-dependent efficient copy operations

    * copytree example

    * rmtree example

  * Archiving operations

    * Archiving example

    * Archiving example with _base_dir_

  * Querying the size of the output terminal

See also:

  Module "os"
     Operating system interfaces, including functions to work with
     files at a lower level than Python _file objects_.

  Module "io"
     Python’s built-in I/O library, including both abstract classes
     and some concrete classes such as file I/O.

  Built-in function "open()"
     The standard way to open files for reading and writing with
     Python.

vim:tw=78:ts=8:ft=help:norl: