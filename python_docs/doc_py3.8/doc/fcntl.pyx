Python 3.8.19
*fcntl.pyx*                                   Last change: 2024 May 24

"fcntl" — The "fcntl" and "ioctl" system calls
**********************************************

======================================================================

This module performs file control and I/O control on file descriptors.
It is an interface to the "fcntl()" and "ioctl()" Unix routines.  For
a complete description of these calls, see _fcntl(2)_ and _ioctl(2)_
Unix manual pages.

All functions in this module take a file descriptor _fd_ as their
first argument.  This can be an integer file descriptor, such as
returned by "sys.stdin.fileno()", or an "io.IOBase" object, such as
"sys.stdin" itself, which provides a "fileno()" that returns a genuine
file descriptor.

Changed in version 3.3: Operations in this module used to raise an
"IOError" where they now raise an "OSError".

Changed in version 3.8: The fcntl module now contains "F_ADD_SEALS",
"F_GET_SEALS", and "F_SEAL_*" constants for sealing of
"os.memfd_create()" file descriptors.

The module defines the following functions:

fcntl.fcntl(fd, cmd, arg=0)

   Perform the operation _cmd_ on file descriptor _fd_ (file objects
   providing a "fileno()" method are accepted as well).  The values
   used for _cmd_ are operating system dependent, and are available as
   constants in the "fcntl" module, using the same names as used in
   the relevant C header files. The argument _arg_ can either be an
   integer value, or a "bytes" object. With an integer value, the
   return value of this function is the integer return value of the C
   "fcntl()" call.  When the argument is bytes it represents a binary
   structure, e.g. created by "struct.pack()". The binary data is
   copied to a buffer whose address is passed to the C "fcntl()" call.
   The return value after a successful call is the contents of the
   buffer, converted to a "bytes" object. The length of the returned
   object will be the same as the length of the _arg_ argument. This
   is limited to 1024 bytes. If the information returned in the buffer
   by the operating system is larger than 1024 bytes, this is most
   likely to result in a segmentation violation or a more subtle data
   corruption.

   If the "fcntl()" fails, an "OSError" is raised.

   Raises an auditing event "fcntl.fcntl" with arguments "fd", "cmd",
   "arg".

fcntl.ioctl(fd, request, arg=0, mutate_flag=True)

   This function is identical to the "fcntl()" function, except that
   the argument handling is even more complicated.

   The _request_ parameter is limited to values that can fit in
   32-bits. Additional constants of interest for use as the _request_
   argument can be found in the "termios" module, under the same names
   as used in the relevant C header files.

   The parameter _arg_ can be one of an integer, an object supporting
   the read-only buffer interface (like "bytes") or an object
   supporting the read-write buffer interface (like "bytearray").

   In all but the last case, behaviour is as for the "fcntl()"
   function.

   If a mutable buffer is passed, then the behaviour is determined by
   the value of the _mutate_flag_ parameter.

   If it is false, the buffer’s mutability is ignored and behaviour is
   as for a read-only buffer, except that the 1024 byte limit
   mentioned above is avoided – so long as the buffer you pass is at
   least as long as what the operating system wants to put there,
   things should work.

   If _mutate_flag_ is true (the default), then the buffer is (in
   effect) passed to the underlying "ioctl()" system call, the
   latter’s return code is passed back to the calling Python, and the
   buffer’s new contents reflect the action of the "ioctl()".  This is
   a slight simplification, because if the supplied buffer is less
   than 1024 bytes long it is first copied into a static buffer 1024
   bytes long which is then passed to "ioctl()" and copied back into
   the supplied buffer.

   If the "ioctl()" fails, an "OSError" exception is raised.

   An example:
>
      >>> import array, fcntl, struct, termios, os
      >>> os.getpgrp()
      13341
      >>> struct.unpack('h', fcntl.ioctl(0, termios.TIOCGPGRP, "  "))[0]
      13341
      >>> buf = array.array('h', [0])
      >>> fcntl.ioctl(0, termios.TIOCGPGRP, buf, 1)
      0
      >>> buf
      array('h', [13341])
<
   Raises an auditing event "fcntl.ioctl" with arguments "fd",
   "request", "arg".

fcntl.flock(fd, operation)

   Perform the lock operation _operation_ on file descriptor _fd_
   (file objects providing a "fileno()" method are accepted as well).
   See the Unix manual _flock(2)_ for details.  (On some systems, this
   function is emulated using "fcntl()".)

   If the "flock()" fails, an "OSError" exception is raised.

   Raises an auditing event "fcntl.flock" with arguments "fd",
   "operation".

fcntl.lockf(fd, cmd, len=0, start=0, whence=0)

   This is essentially a wrapper around the "fcntl()" locking calls.
   _fd_ is the file descriptor (file objects providing a "fileno()"
   method are accepted as well) of the file to lock or unlock, and
   _cmd_ is one of the following values:

   * "LOCK_UN" – unlock

   * "LOCK_SH" – acquire a shared lock

   * "LOCK_EX" – acquire an exclusive lock

   When _cmd_ is "LOCK_SH" or "LOCK_EX", it can also be bitwise ORed
   with "LOCK_NB" to avoid blocking on lock acquisition. If "LOCK_NB"
   is used and the lock cannot be acquired, an "OSError" will be
   raised and the exception will have an _errno_ attribute set to
   "EACCES" or "EAGAIN" (depending on the operating system; for
   portability, check for both values).  On at least some systems,
   "LOCK_EX" can only be used if the file descriptor refers to a file
   opened for writing.

   _len_ is the number of bytes to lock, _start_ is the byte offset at
   which the lock starts, relative to _whence_, and _whence_ is as
   with "io.IOBase.seek()", specifically:

   * "0" – relative to the start of the file ("os.SEEK_SET")

   * "1" – relative to the current buffer position ("os.SEEK_CUR")

   * "2" – relative to the end of the file ("os.SEEK_END")

   The default for _start_ is 0, which means to start at the beginning
   of the file. The default for _len_ is 0 which means to lock to the
   end of the file.  The default for _whence_ is also 0.

   Raises an auditing event "fcntl.lockf" with arguments "fd", "cmd",
   "len", "start", "whence".

Examples (all on a SVR4 compliant system):
>
   import struct, fcntl, os

   f = open(...)
   rv = fcntl.fcntl(f, fcntl.F_SETFL, os.O_NDELAY)

   lockdata = struct.pack('hhllhh', fcntl.F_WRLCK, 0, 0, 0, 0, 0)
   rv = fcntl.fcntl(f, fcntl.F_SETLKW, lockdata)
<
Note that in the first example the return value variable _rv_ will
hold an integer value; in the second example it will hold a "bytes"
object.  The structure lay-out for the _lockdata_ variable is system
dependent — therefore using the "flock()" call may be better.

See also:

  Module "os"
     If the locking flags "O_SHLOCK" and "O_EXLOCK" are present in the
     "os" module (on BSD only), the "os.open()" function provides an
     alternative to the "lockf()" and "flock()" functions.

vim:tw=78:ts=8:ft=help:norl: