Python 3.11.9
*cgitb.pyx*                                   Last change: 2024 May 24

"cgitb" — Traceback manager for CGI scripts
*******************************************

**Source code:** Lib/cgitb.py

Deprecated since version 3.11, will be removed in version 3.13: The
"cgitb" module is deprecated (see **PEP 594** for details).

======================================================================

The "cgitb" module provides a special exception handler for Python
scripts. (Its name is a bit misleading.  It was originally designed to
display extensive traceback information in HTML for CGI scripts.  It
was later generalized to also display this information in plain text.)
After this module is activated, if an uncaught exception occurs, a
detailed, formatted report will be displayed.  The report includes a
traceback showing excerpts of the source code for each level, as well
as the values of the arguments and local variables to currently
running functions, to help you debug the problem.  Optionally, you can
save this information to a file instead of sending it to the browser.

To enable this feature, simply add this to the top of your CGI script:
>
   import cgitb
   cgitb.enable()
<
The options to the "enable()" function control whether the report is
displayed in the browser and whether the report is logged to a file
for later analysis.

cgitb.enable(display=1, logdir=None, context=5, format='html')

   This function causes the "cgitb" module to take over the
   interpreter’s default handling for exceptions by setting the value
   of "sys.excepthook".

   The optional argument _display_ defaults to "1" and can be set to
   "0" to suppress sending the traceback to the browser. If the
   argument _logdir_ is present, the traceback reports are written to
   files.  The value of _logdir_ should be a directory where these
   files will be placed. The optional argument _context_ is the number
   of lines of context to display around the current line of source
   code in the traceback; this defaults to "5". If the optional
   argument _format_ is ""html"", the output is formatted as HTML.
   Any other value forces plain text output.  The default value is
   ""html"".

cgitb.text(info, context=5)

   This function handles the exception described by _info_ (a 3-tuple
   containing the result of "sys.exc_info()"), formatting its
   traceback as text and returning the result as a string. The
   optional argument _context_ is the number of lines of context to
   display around the current line of source code in the traceback;
   this defaults to "5".

cgitb.html(info, context=5)

   This function handles the exception described by _info_ (a 3-tuple
   containing the result of "sys.exc_info()"), formatting its
   traceback as HTML and returning the result as a string. The
   optional argument _context_ is the number of lines of context to
   display around the current line of source code in the traceback;
   this defaults to "5".

cgitb.handler(info=None)

   This function handles an exception using the default settings (that
   is, show a report in the browser, but don’t log to a file). This
   can be used when you’ve caught an exception and want to report it
   using "cgitb".  The optional _info_ argument should be a 3-tuple
   containing an exception type, exception value, and traceback
   object, exactly like the tuple returned by "sys.exc_info()".  If
   the _info_ argument is not supplied, the current exception is
   obtained from "sys.exc_info()".

vim:tw=78:ts=8:ft=help:norl: