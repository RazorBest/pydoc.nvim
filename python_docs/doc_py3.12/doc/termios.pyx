Python 3.12.3
*termios.pyx*                                 Last change: 2024 May 24

"termios" — POSIX style tty control
***********************************

======================================================================

This module provides an interface to the POSIX calls for tty I/O
control. For a complete description of these calls, see _termios(3)_
Unix manual page.  It is only available for those Unix versions that
support POSIX _termios_ style tty I/O control configured during
installation.

Availability: Unix.

All functions in this module take a file descriptor _fd_ as their
first argument.  This can be an integer file descriptor, such as
returned by "sys.stdin.fileno()", or a _file object_, such as
"sys.stdin" itself.

This module also defines all the constants needed to work with the
functions provided here; these have the same name as their
counterparts in C.  Please refer to your system documentation for more
information on using these terminal control interfaces.

The module defines the following functions:

termios.tcgetattr(fd)

   Return a list containing the tty attributes for file descriptor
   _fd_, as follows: "[iflag, oflag, cflag, lflag, ispeed, ospeed,
   cc]" where _cc_ is a list of the tty special characters (each a
   string of length 1, except the items with indices "VMIN" and
   "VTIME", which are integers when these fields are defined).  The
   interpretation of the flags and the speeds as well as the indexing
   in the _cc_ array must be done using the symbolic constants defined
   in the "termios" module.

termios.tcsetattr(fd, when, attributes)

   Set the tty attributes for file descriptor _fd_ from the
   _attributes_, which is a list like the one returned by
   "tcgetattr()".  The _when_ argument determines when the attributes
   are changed:

   termios.TCSANOW

      Change attributes immediately.

   termios.TCSADRAIN

      Change attributes after transmitting all queued output.

   termios.TCSAFLUSH

      Change attributes after transmitting all queued output and
      discarding all queued input.

termios.tcsendbreak(fd, duration)

   Send a break on file descriptor _fd_.  A zero _duration_ sends a
   break for 0.25–0.5 seconds; a nonzero _duration_ has a system
   dependent meaning.

termios.tcdrain(fd)

   Wait until all output written to file descriptor _fd_ has been
   transmitted.

termios.tcflush(fd, queue)

   Discard queued data on file descriptor _fd_.  The _queue_ selector
   specifies which queue: "TCIFLUSH" for the input queue, "TCOFLUSH"
   for the output queue, or "TCIOFLUSH" for both queues.

termios.tcflow(fd, action)

   Suspend or resume input or output on file descriptor _fd_.  The
   _action_ argument can be "TCOOFF" to suspend output, "TCOON" to
   restart output, "TCIOFF" to suspend input, or "TCION" to restart
   input.

termios.tcgetwinsize(fd)

   Return a tuple "(ws_row, ws_col)" containing the tty window size
   for file descriptor _fd_. Requires "termios.TIOCGWINSZ" or
   "termios.TIOCGSIZE".

   New in version 3.11.

termios.tcsetwinsize(fd, winsize)

   Set the tty window size for file descriptor _fd_ from _winsize_,
   which is a two-item tuple "(ws_row, ws_col)" like the one returned
   by "tcgetwinsize()". Requires at least one of the pairs
   ("termios.TIOCGWINSZ", "termios.TIOCSWINSZ"); ("termios.TIOCGSIZE",
   "termios.TIOCSSIZE") to be defined.

   New in version 3.11.

See also:

  Module "tty"
     Convenience functions for common terminal control operations.


Example
=======

Here’s a function that prompts for a password with echoing turned off.
Note the technique using a separate "tcgetattr()" call and a "try" …
"finally" statement to ensure that the old tty attributes are restored
exactly no matter what happens:
>
   def getpass(prompt="Password: "):
       import termios, sys
       fd = sys.stdin.fileno()
       old = termios.tcgetattr(fd)
       new = termios.tcgetattr(fd)
       new[3] = new[3] & ~termios.ECHO          # lflags
       try:
           termios.tcsetattr(fd, termios.TCSADRAIN, new)
           passwd = input(prompt)
       finally:
           termios.tcsetattr(fd, termios.TCSADRAIN, old)
       return passwd
<
vim:tw=78:ts=8:ft=help:norl: