Python 3.11.9
*tomllib.pyx*                                 Last change: 2024 May 24

"tomllib" — Parse TOML files
****************************

New in version 3.11.

**Source code:** Lib/tomllib

======================================================================

This module provides an interface for parsing TOML (Tom’s Obvious
Minimal Language, https://toml.io). This module does not support
writing TOML.

See also:

  The Tomli-W package is a TOML writer that can be used in conjunction
  with this module, providing a write API familiar to users of the
  standard library "marshal" and "pickle" modules.

See also:

  The TOML Kit package is a style-preserving TOML library with both
  read and write capability. It is a recommended replacement for this
  module for editing already existing TOML files.

This module defines the following functions:

tomllib.load(fp, /, *, parse_float=float)

   Read a TOML file. The first argument should be a readable and
   binary file object. Return a "dict". Convert TOML types to Python
   using this conversion table.

   _parse_float_ will be called with the string of every TOML float to
   be decoded.  By default, this is equivalent to "float(num_str)".
   This can be used to use another datatype or parser for TOML floats
   (e.g. "decimal.Decimal"). The callable must not return a "dict" or
   a "list", else a "ValueError" is raised.

   A "TOMLDecodeError" will be raised on an invalid TOML document.

tomllib.loads(s, /, *, parse_float=float)

   Load TOML from a "str" object. Return a "dict". Convert TOML types
   to Python using this conversion table. The _parse_float_ argument
   has the same meaning as in "load()".

   A "TOMLDecodeError" will be raised on an invalid TOML document.

The following exceptions are available:

exception tomllib.TOMLDecodeError

   Subclass of "ValueError".


Examples
========

Parsing a TOML file:
>
   import tomllib

   with open("pyproject.toml", "rb") as f:
       data = tomllib.load(f)
<
Parsing a TOML string:
>
   import tomllib

   toml_str = """
   python-version = "3.11.0"
   python-implementation = "CPython"
   """

   data = tomllib.loads(toml_str)
<

Conversion Table
================

+--------------------+----------------------------------------------------------------------------------------+
| TOML               | Python                                                                                 |
|====================|========================================================================================|
| TOML document      | dict                                                                                   |
+--------------------+----------------------------------------------------------------------------------------+
| string             | str                                                                                    |
+--------------------+----------------------------------------------------------------------------------------+
| integer            | int                                                                                    |
+--------------------+----------------------------------------------------------------------------------------+
| float              | float (configurable with _parse_float_)                                                |
+--------------------+----------------------------------------------------------------------------------------+
| boolean            | bool                                                                                   |
+--------------------+----------------------------------------------------------------------------------------+
| offset date-time   | datetime.datetime ("tzinfo" attribute set to an instance of "datetime.timezone")       |
+--------------------+----------------------------------------------------------------------------------------+
| local date-time    | datetime.datetime ("tzinfo" attribute set to "None")                                   |
+--------------------+----------------------------------------------------------------------------------------+
| local date         | datetime.date                                                                          |
+--------------------+----------------------------------------------------------------------------------------+
| local time         | datetime.time                                                                          |
+--------------------+----------------------------------------------------------------------------------------+
| array              | list                                                                                   |
+--------------------+----------------------------------------------------------------------------------------+
| table              | dict                                                                                   |
+--------------------+----------------------------------------------------------------------------------------+
| inline table       | dict                                                                                   |
+--------------------+----------------------------------------------------------------------------------------+
| array of tables    | list of dicts                                                                          |
+--------------------+----------------------------------------------------------------------------------------+

vim:tw=78:ts=8:ft=help:norl: