Python 3.10.14
*binhex.pyx*                                  Last change: 2024 May 24

"binhex" — Encode and decode binhex4 files
******************************************

**Source code:** Lib/binhex.py

Deprecated since version 3.9.

======================================================================

This module encodes and decodes files in binhex4 format, a format
allowing representation of Macintosh files in ASCII. Only the data
fork is handled.

The "binhex" module defines the following functions:

binhex.binhex(input, output)

   Convert a binary file with filename _input_ to binhex file
   _output_. The _output_ parameter can either be a filename or a
   file-like object (any object supporting a "write()" and "close()"
   method).

binhex.hexbin(input, output)

   Decode a binhex file _input_. _input_ may be a filename or a file-
   like object supporting "read()" and "close()" methods. The
   resulting file is written to a file named _output_, unless the
   argument is "None" in which case the output filename is read from
   the binhex file.

The following exception is also defined:

exception binhex.Error

   Exception raised when something can’t be encoded using the binhex
   format (for example, a filename is too long to fit in the filename
   field), or when input is not properly encoded binhex data.

See also:

  Module "binascii"
     Support module containing ASCII-to-binary and binary-to-ASCII
     conversions.


Notes
=====

There is an alternative, more powerful interface to the coder and
decoder, see the source for details.

If you code or decode textfiles on non-Macintosh platforms they will
still use the old Macintosh newline convention (carriage-return as end
of line).

vim:tw=78:ts=8:ft=help:norl: