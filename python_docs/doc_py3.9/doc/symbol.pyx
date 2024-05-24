Python 3.9.19
*symbol.pyx*                                  Last change: 2024 May 24

"symbol" — Constants used with Python parse trees
*************************************************

**Source code:** Lib/symbol.py

======================================================================

This module provides constants which represent the numeric values of
internal nodes of the parse tree.  Unlike most Python constants, these
use lower-case names.  Refer to the file "Grammar/Grammar" in the
Python distribution for the definitions of the names in the context of
the language grammar.  The specific numeric values which the names map
to may change between Python versions.

Warning:

  The symbol module is deprecated and will be removed in future
  versions of Python.

This module also provides one additional data object:

symbol.sym_name

   Dictionary mapping the numeric values of the constants defined in
   this module back to name strings, allowing more human-readable
   representation of parse trees to be generated.

vim:tw=78:ts=8:ft=help:norl: