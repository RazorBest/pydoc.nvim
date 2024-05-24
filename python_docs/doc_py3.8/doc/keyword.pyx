Python 3.8.19
*keyword.pyx*                                 Last change: 2024 May 24

"keyword" — Testing for Python keywords
***************************************

**Source code:** Lib/keyword.py

======================================================================

This module allows a Python program to determine if a string is a
keyword.

keyword.iskeyword(s)

   Return "True" if _s_ is a Python keyword.

keyword.kwlist

   Sequence containing all the keywords defined for the interpreter.
   If any keywords are defined to only be active when particular
   "__future__" statements are in effect, these will be included as
   well.

vim:tw=78:ts=8:ft=help:norl: