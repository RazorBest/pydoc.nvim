Python 3.12.3
*tty.pyx*                                     Last change: 2024 May 24

"tty" — Terminal control functions
**********************************

**Source code:** Lib/tty.py

======================================================================

The "tty" module defines functions for putting the tty into cbreak and
raw modes.

Availability: Unix.

Because it requires the "termios" module, it will work only on Unix.

The "tty" module defines the following functions:

tty.cfmakeraw(mode)

   Convert the tty attribute list _mode_, which is a list like the one
   returned by "termios.tcgetattr()", to that of a tty in raw mode.

   New in version 3.12.

tty.cfmakecbreak(mode)

   Convert the tty attribute list _mode_, which is a list like the one
   returned by "termios.tcgetattr()", to that of a tty in cbreak mode.

   This clears the "ECHO" and "ICANON" local mode flags in _mode_ as
   well as setting the minimum input to 1 byte with no delay.

   New in version 3.12.

   Changed in version 3.12.2: The "ICRNL" flag is no longer cleared.
   This matches Linux and macOS "stty cbreak" behavior and what
   "setcbreak()" historically did.

tty.setraw(fd, when=termios.TCSAFLUSH)

   Change the mode of the file descriptor _fd_ to raw. If _when_ is
   omitted, it defaults to "termios.TCSAFLUSH", and is passed to
   "termios.tcsetattr()". The return value of "termios.tcgetattr()" is
   saved before setting _fd_ to raw mode; this value is returned.

   Changed in version 3.12: The return value is now the original tty
   attributes, instead of None.

tty.setcbreak(fd, when=termios.TCSAFLUSH)

   Change the mode of file descriptor _fd_ to cbreak. If _when_ is
   omitted, it defaults to "termios.TCSAFLUSH", and is passed to
   "termios.tcsetattr()". The return value of "termios.tcgetattr()" is
   saved before setting _fd_ to cbreak mode; this value is returned.

   This clears the "ECHO" and "ICANON" local mode flags as well as
   setting the minimum input to 1 byte with no delay.

   Changed in version 3.12: The return value is now the original tty
   attributes, instead of None.

   Changed in version 3.12.2: The "ICRNL" flag is no longer cleared.
   This restores the behavior of Python 3.11 and earlier as well as
   matching what Linux, macOS, & BSDs describe in their "stty(1)" man
   pages regarding cbreak mode.

See also:

  Module "termios"
     Low-level terminal control interface.

vim:tw=78:ts=8:ft=help:norl: