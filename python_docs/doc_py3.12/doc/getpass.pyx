Python 3.12.3
*getpass.pyx*                                 Last change: 2024 May 24

"getpass" — Portable password input
***********************************

**Source code:** Lib/getpass.py

======================================================================

Availability: not Emscripten, not WASI.

This module does not work or is not available on WebAssembly platforms
"wasm32-emscripten" and "wasm32-wasi". See WebAssembly platforms for
more information.

The "getpass" module provides two functions:

getpass.getpass(prompt='Password: ', stream=None)

   Prompt the user for a password without echoing.  The user is
   prompted using the string _prompt_, which defaults to "'Password:
   '".  On Unix, the prompt is written to the file-like object
   _stream_ using the replace error handler if needed.  _stream_
   defaults to the controlling terminal ("/dev/tty") or if that is
   unavailable to "sys.stderr" (this argument is ignored on Windows).

   If echo free input is unavailable getpass() falls back to printing
   a warning message to _stream_ and reading from "sys.stdin" and
   issuing a "GetPassWarning".

   Note:

     If you call getpass from within IDLE, the input may be done in
     the terminal you launched IDLE from rather than the idle window
     itself.

exception getpass.GetPassWarning

   A "UserWarning" subclass issued when password input may be echoed.

getpass.getuser()

   Return the “login name” of the user.

   This function checks the environment variables "LOGNAME", "USER",
   "LNAME" and "USERNAME", in order, and returns the value of the
   first one which is set to a non-empty string.  If none are set, the
   login name from the password database is returned on systems which
   support the "pwd" module, otherwise, an exception is raised.

   In general, this function should be preferred over "os.getlogin()".

vim:tw=78:ts=8:ft=help:norl: