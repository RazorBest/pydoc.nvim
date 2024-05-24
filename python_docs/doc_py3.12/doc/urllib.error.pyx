Python 3.12.3
*urllib.error.pyx*                            Last change: 2024 May 24

"urllib.error" — Exception classes raised by urllib.request
***********************************************************

**Source code:** Lib/urllib/error.py

======================================================================

The "urllib.error" module defines the exception classes for exceptions
raised by "urllib.request".  The base exception class is "URLError".

The following exceptions are raised by "urllib.error" as appropriate:

exception urllib.error.URLError

   The handlers raise this exception (or derived exceptions) when they
   run into a problem.  It is a subclass of "OSError".

   reason

      The reason for this error.  It can be a message string or
      another exception instance.

   Changed in version 3.3: "URLError" used to be a subtype of
   "IOError", which is now an alias of "OSError".

exception urllib.error.HTTPError(url, code, msg, hdrs, fp)

   Though being an exception (a subclass of "URLError"), an
   "HTTPError" can also function as a non-exceptional file-like return
   value (the same thing that "urlopen()" returns).  This is useful
   when handling exotic HTTP errors, such as requests for
   authentication.

   url

      Contains the request URL. An alias for _filename_ attribute.

   code

      An HTTP status code as defined in **RFC 2616**.  This numeric
      value corresponds to a value found in the dictionary of codes as
      found in "http.server.BaseHTTPRequestHandler.responses".

   reason

      This is usually a string explaining the reason for this error.
      An alias for _msg_ attribute.

   headers

      The HTTP response headers for the HTTP request that caused the
      "HTTPError". An alias for _hdrs_ attribute.

      New in version 3.4.

   fp

      A file-like object where the HTTP error body can be read from.

exception urllib.error.ContentTooShortError(msg, content)

   This exception is raised when the "urlretrieve()" function detects
   that the amount of the downloaded data is less than the expected
   amount (given by the _Content-Length_ header).

   content

      The downloaded (and supposedly truncated) data.

vim:tw=78:ts=8:ft=help:norl: