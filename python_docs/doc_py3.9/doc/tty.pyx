Python 3.9.19
*tty.pyx*                                     Last change: 2024 May 24

"tty" — Terminal control functions
**********************************

**Source code:** Lib/tty.py

======================================================================

The "tty" module defines functions for putting the tty into cbreak and
raw modes.

Because it requires the "termios" module, it will work only on Unix.

The "tty" module defines the following functions:

tty.setraw(fd, when=termios.TCSAFLUSH)

   Change the mode of the file descriptor _fd_ to raw. If _when_ is
   omitted, it defaults to "termios.TCSAFLUSH", and is passed to
   "termios.tcsetattr()".

tty.setcbreak(fd, when=termios.TCSAFLUSH)

   Change the mode of file descriptor _fd_ to cbreak. If _when_ is
   omitted, it defaults to "termios.TCSAFLUSH", and is passed to
   "termios.tcsetattr()".

See also:

  Module "termios"
     Low-level terminal control interface.

vim:tw=78:ts=8:ft=help:norl: