Python 3.10.14
*pty.pyx*                                     Last change: 2024 May 24

"pty" — Pseudo-terminal utilities
*********************************

**Source code:** Lib/pty.py

======================================================================

The "pty" module defines operations for handling the pseudo-terminal
concept: starting another process and being able to write to and read
from its controlling terminal programmatically.

Pseudo-terminal handling is highly platform dependent. This code is
mainly tested on Linux, FreeBSD, and macOS (it is supposed to work on
other POSIX platforms but it’s not been thoroughly tested).

The "pty" module defines the following functions:

pty.fork()

   Fork. Connect the child’s controlling terminal to a pseudo-
   terminal. Return value is "(pid, fd)". Note that the child  gets
   _pid_ 0, and the _fd_ is _invalid_. The parent’s return value is
   the _pid_ of the child, and _fd_ is a file descriptor connected to
   the child’s controlling terminal (and also to the child’s standard
   input and output).

pty.openpty()

   Open a new pseudo-terminal pair, using "os.openpty()" if possible,
   or emulation code for generic Unix systems. Return a pair of file
   descriptors "(master, slave)", for the master and the slave end,
   respectively.

pty.spawn(argv[, master_read[, stdin_read]])

   Spawn a process, and connect its controlling terminal with the
   current process’s standard io. This is often used to baffle
   programs which insist on reading from the controlling terminal. It
   is expected that the process spawned behind the pty will eventually
   terminate, and when it does _spawn_ will return.

   A loop copies STDIN of the current process to the child and data
   received from the child to STDOUT of the current process. It is not
   signaled to the child if STDIN of the current process closes down.

   The functions _master_read_ and _stdin_read_ are passed a file
   descriptor which they should read from, and they should always
   return a byte string. In order to force spawn to return before the
   child process exits an empty byte array should be returned to
   signal end of file.

   The default implementation for both functions will read and return
   up to 1024 bytes each time the function is called. The
   _master_read_ callback is passed the pseudoterminal’s master file
   descriptor to read output from the child process, and _stdin_read_
   is passed file descriptor 0, to read from the parent process’s
   standard input.

   Returning an empty byte string from either callback is interpreted
   as an end-of-file (EOF) condition, and that callback will not be
   called after that. If _stdin_read_ signals EOF the controlling
   terminal can no longer communicate with the parent process OR the
   child process. Unless the child process will quit without any
   input, _spawn_ will then loop forever. If _master_read_ signals EOF
   the same behavior results (on linux at least).

   Return the exit status value from "os.waitpid()" on the child
   process.

   "waitstatus_to_exitcode()" can be used to convert the exit status
   into an exit code.

   Raises an auditing event "pty.spawn" with argument "argv".

   Changed in version 3.4: "spawn()" now returns the status value from
   "os.waitpid()" on the child process.


Example
=======

The following program acts like the Unix command _script(1)_, using a
pseudo-terminal to record all input and output of a terminal session
in a “typescript”.
>
   import argparse
   import os
   import pty
   import sys
   import time

   parser = argparse.ArgumentParser()
   parser.add_argument('-a', dest='append', action='store_true')
   parser.add_argument('-p', dest='use_python', action='store_true')
   parser.add_argument('filename', nargs='?', default='typescript')
   options = parser.parse_args()

   shell = sys.executable if options.use_python else os.environ.get('SHELL', 'sh')
   filename = options.filename
   mode = 'ab' if options.append else 'wb'

   with open(filename, mode) as script:
       def read(fd):
           data = os.read(fd, 1024)
           script.write(data)
           return data

       print('Script started, file is', filename)
       script.write(('Script started on %s\n' % time.asctime()).encode())

       pty.spawn(shell, read)

       script.write(('Script done on %s\n' % time.asctime()).encode())
       print('Script done, file is', filename)
<
vim:tw=78:ts=8:ft=help:norl: