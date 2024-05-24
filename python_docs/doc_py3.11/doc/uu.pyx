Python 3.11.9
*uu.pyx*                                      Last change: 2024 May 24

"uu" — Encode and decode uuencode files
***************************************

**Source code:** Lib/uu.py

Deprecated since version 3.11, will be removed in version 3.13: The
"uu" module is deprecated (see **PEP 594** for details). "base64" is a
modern alternative.

======================================================================

This module encodes and decodes files in uuencode format, allowing
arbitrary binary data to be transferred over ASCII-only connections.
Wherever a file argument is expected, the methods accept a file-like
object.  For backwards compatibility, a string containing a pathname
is also accepted, and the corresponding file will be opened for
reading and writing; the pathname "'-'" is understood to mean the
standard input or output.  However, this interface is deprecated; it’s
better for the caller to open the file itself, and be sure that, when
required, the mode is "'rb'" or "'wb'" on Windows.

This code was contributed by Lance Ellinghouse, and modified by Jack
Jansen.

The "uu" module defines the following functions:

uu.encode(in_file, out_file, name=None, mode=None, *, backtick=False)

   Uuencode file _in_file_ into file _out_file_.  The uuencoded file
   will have the header specifying _name_ and _mode_ as the defaults
   for the results of decoding the file. The default defaults are
   taken from _in_file_, or "'-'" and "0o666" respectively.  If
   _backtick_ is true, zeros are represented by "'`'" instead of
   spaces.

   Changed in version 3.7: Added the _backtick_ parameter.

uu.decode(in_file, out_file=None, mode=None, quiet=False)

   This call decodes uuencoded file _in_file_ placing the result on
   file _out_file_. If _out_file_ is a pathname, _mode_ is used to set
   the permission bits if the file must be created. Defaults for
   _out_file_ and _mode_ are taken from the uuencode header.  However,
   if the file specified in the header already exists, a "uu.Error" is
   raised.

   "decode()" may print a warning to standard error if the input was
   produced by an incorrect uuencoder and Python could recover from
   that error.  Setting _quiet_ to a true value silences this warning.

exception uu.Error

   Subclass of "Exception", this can be raised by "uu.decode()" under
   various situations, such as described above, but also including a
   badly formatted header, or truncated input file.

See also:

  Module "binascii"
     Support module containing ASCII-to-binary and binary-to-ASCII
     conversions.

vim:tw=78:ts=8:ft=help:norl: