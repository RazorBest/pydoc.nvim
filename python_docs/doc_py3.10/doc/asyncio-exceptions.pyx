Python 3.10.14
*asyncio-exceptions.pyx*                      Last change: 2024 May 24

Exceptions
**********

**Source code:** Lib/asyncio/exceptions.py

======================================================================

exception asyncio.TimeoutError

   The operation has exceeded the given deadline.

   Important:

     This exception is different from the builtin "TimeoutError"
     exception.

exception asyncio.CancelledError

   The operation has been cancelled.

   This exception can be caught to perform custom operations when
   asyncio Tasks are cancelled.  In almost all situations the
   exception must be re-raised.

   Changed in version 3.8: "CancelledError" is now a subclass of
   "BaseException".

exception asyncio.InvalidStateError

   Invalid internal state of "Task" or "Future".

   Can be raised in situations like setting a result value for a
   _Future_ object that already has a result value set.

exception asyncio.SendfileNotAvailableError

   The “sendfile” syscall is not available for the given socket or
   file type.

   A subclass of "RuntimeError".

exception asyncio.IncompleteReadError

   The requested read operation did not complete fully.

   Raised by the asyncio stream APIs.

   This exception is a subclass of "EOFError".

   expected

      The total number ("int") of expected bytes.

   partial

      A string of "bytes" read before the end of stream was reached.

exception asyncio.LimitOverrunError

   Reached the buffer size limit while looking for a separator.

   Raised by the asyncio stream APIs.

   consumed

      The total number of to be consumed bytes.

vim:tw=78:ts=8:ft=help:norl: