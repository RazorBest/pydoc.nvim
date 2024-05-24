Python 3.8.19
*_dummy_thread.pyx*                           Last change: 2024 May 24

"_dummy_thread" — Drop-in replacement for the "_thread" module
**************************************************************

**Source code:** Lib/_dummy_thread.py

Deprecated since version 3.7: Python now always has threading enabled.
Please use "_thread" (or, better, "threading") instead.

======================================================================

This module provides a duplicate interface to the "_thread" module. It
was meant to be imported when the "_thread" module was not provided on
a platform.

Be careful to not use this module where deadlock might occur from a
thread being created that blocks waiting for another thread to be
created.  This often occurs with blocking I/O.

vim:tw=78:ts=8:ft=help:norl: