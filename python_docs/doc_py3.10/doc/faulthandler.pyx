Python 3.10.14
*faulthandler.pyx*                            Last change: 2024 May 24

"faulthandler" — Dump the Python traceback
******************************************

New in version 3.3.

======================================================================

This module contains functions to dump Python tracebacks explicitly,
on a fault, after a timeout, or on a user signal. Call
"faulthandler.enable()" to install fault handlers for the "SIGSEGV",
"SIGFPE", "SIGABRT", "SIGBUS", and "SIGILL" signals. You can also
enable them at startup by setting the "PYTHONFAULTHANDLER" environment
variable or by using the "-X" "faulthandler" command line option.

The fault handler is compatible with system fault handlers like Apport
or the Windows fault handler. The module uses an alternative stack for
signal handlers if the "sigaltstack()" function is available. This
allows it to dump the traceback even on a stack overflow.

The fault handler is called on catastrophic cases and therefore can
only use signal-safe functions (e.g. it cannot allocate memory on the
heap). Because of this limitation traceback dumping is minimal
compared to normal Python tracebacks:

* Only ASCII is supported. The "backslashreplace" error handler is
  used on encoding.

* Each string is limited to 500 characters.

* Only the filename, the function name and the line number are
  displayed. (no source code)

* It is limited to 100 frames and 100 threads.

* The order is reversed: the most recent call is shown first.

By default, the Python traceback is written to "sys.stderr". To see
tracebacks, applications must be run in the terminal. A log file can
alternatively be passed to "faulthandler.enable()".

The module is implemented in C, so tracebacks can be dumped on a crash
or when Python is deadlocked.

The Python Development Mode calls "faulthandler.enable()" at Python
startup.

See also:

  Module "pdb"
     Interactive source code debugger for Python programs.

  Module "traceback"
     Standard interface to extract, format and print stack traces of
     Python programs.


Dumping the traceback
=====================

faulthandler.dump_traceback(file=sys.stderr, all_threads=True)

   Dump the tracebacks of all threads into _file_. If _all_threads_ is
   "False", dump only the current thread.

   See also:

     "traceback.print_tb()", which can be used to print a traceback
     object.

   Changed in version 3.5: Added support for passing file descriptor
   to this function.


Fault handler state
===================

faulthandler.enable(file=sys.stderr, all_threads=True)

   Enable the fault handler: install handlers for the "SIGSEGV",
   "SIGFPE", "SIGABRT", "SIGBUS" and "SIGILL" signals to dump the
   Python traceback. If _all_threads_ is "True", produce tracebacks
   for every running thread. Otherwise, dump only the current thread.

   The _file_ must be kept open until the fault handler is disabled:
   see issue with file descriptors.

   Changed in version 3.5: Added support for passing file descriptor
   to this function.

   Changed in version 3.6: On Windows, a handler for Windows exception
   is also installed.

   Changed in version 3.10: The dump now mentions if a garbage
   collector collection is running if _all_threads_ is true.

faulthandler.disable()

   Disable the fault handler: uninstall the signal handlers installed
   by "enable()".

faulthandler.is_enabled()

   Check if the fault handler is enabled.


Dumping the tracebacks after a timeout
======================================

faulthandler.dump_traceback_later(timeout, repeat=False, file=sys.stderr, exit=False)

   Dump the tracebacks of all threads, after a timeout of _timeout_
   seconds, or every _timeout_ seconds if _repeat_ is "True".  If
   _exit_ is "True", call "_exit()" with status=1 after dumping the
   tracebacks.  (Note "_exit()" exits the process immediately, which
   means it doesn’t do any cleanup like flushing file buffers.) If the
   function is called twice, the new call replaces previous parameters
   and resets the timeout. The timer has a sub-second resolution.

   The _file_ must be kept open until the traceback is dumped or
   "cancel_dump_traceback_later()" is called: see issue with file
   descriptors.

   This function is implemented using a watchdog thread.

   Changed in version 3.7: This function is now always available.

   Changed in version 3.5: Added support for passing file descriptor
   to this function.

faulthandler.cancel_dump_traceback_later()

   Cancel the last call to "dump_traceback_later()".


Dumping the traceback on a user signal
======================================

faulthandler.register(signum, file=sys.stderr, all_threads=True, chain=False)

   Register a user signal: install a handler for the _signum_ signal
   to dump the traceback of all threads, or of the current thread if
   _all_threads_ is "False", into _file_. Call the previous handler if
   chain is "True".

   The _file_ must be kept open until the signal is unregistered by
   "unregister()": see issue with file descriptors.

   Not available on Windows.

   Changed in version 3.5: Added support for passing file descriptor
   to this function.

faulthandler.unregister(signum)

   Unregister a user signal: uninstall the handler of the _signum_
   signal installed by "register()". Return "True" if the signal was
   registered, "False" otherwise.

   Not available on Windows.


Issue with file descriptors
===========================

"enable()", "dump_traceback_later()" and "register()" keep the file
descriptor of their _file_ argument. If the file is closed and its
file descriptor is reused by a new file, or if "os.dup2()" is used to
replace the file descriptor, the traceback will be written into a
different file. Call these functions again each time that the file is
replaced.


Example
=======

Example of a segmentation fault on Linux with and without enabling the
fault handler:
>
   $ python3 -c "import ctypes; ctypes.string_at(0)"
   Segmentation fault

   $ python3 -q -X faulthandler
   >>> import ctypes
   >>> ctypes.string_at(0)
   Fatal Python error: Segmentation fault

   Current thread 0x00007fb899f39700 (most recent call first):
     File "/home/python/cpython/Lib/ctypes/__init__.py", line 486 in string_at
     File "<stdin>", line 1 in <module>
   Segmentation fault
<
vim:tw=78:ts=8:ft=help:norl: