Python 3.11.9
*traceback.pyx*                               Last change: 2024 May 24

"traceback" — Print or retrieve a stack traceback
*************************************************

**Source code:** Lib/traceback.py

======================================================================

This module provides a standard interface to extract, format and print
stack traces of Python programs.  It exactly mimics the behavior of
the Python interpreter when it prints a stack trace.  This is useful
when you want to print stack traces under program control, such as in
a “wrapper” around the interpreter.

The module uses traceback objects — these are objects of type
"types.TracebackType", which are assigned to the "__traceback__" field
of "BaseException" instances.

See also:

  Module "faulthandler"
     Used to dump Python tracebacks explicitly, on a fault, after a
     timeout, or on a user signal.

  Module "pdb"
     Interactive source code debugger for Python programs.

The module defines the following functions:

traceback.print_tb(tb, limit=None, file=None)

   Print up to _limit_ stack trace entries from traceback object _tb_
   (starting from the caller’s frame) if _limit_ is positive.
   Otherwise, print the last "abs(limit)" entries.  If _limit_ is
   omitted or "None", all entries are printed.  If _file_ is omitted
   or "None", the output goes to "sys.stderr"; otherwise it should be
   an open _file_ or _file-like object_ to receive the output.

   Changed in version 3.5: Added negative _limit_ support.

traceback.print_exception(exc, /, [value, tb, ]limit=None, file=None, chain=True)

   Print exception information and stack trace entries from traceback
   object _tb_ to _file_. This differs from "print_tb()" in the
   following ways:

   * if _tb_ is not "None", it prints a header "Traceback (most recent
     call last):"

   * it prints the exception type and _value_ after the stack trace

   * if _type(value)_ is "SyntaxError" and _value_ has the appropriate
     format, it prints the line where the syntax error occurred with a
     caret indicating the approximate position of the error.

   Since Python 3.10, instead of passing _value_ and _tb_, an
   exception object can be passed as the first argument. If _value_
   and _tb_ are provided, the first argument is ignored in order to
   provide backwards compatibility.

   The optional _limit_ argument has the same meaning as for
   "print_tb()". If _chain_ is true (the default), then chained
   exceptions (the "__cause__" or "__context__" attributes of the
   exception) will be printed as well, like the interpreter itself
   does when printing an unhandled exception.

   Changed in version 3.5: The _etype_ argument is ignored and
   inferred from the type of _value_.

   Changed in version 3.10: The _etype_ parameter has been renamed to
   _exc_ and is now positional-only.

traceback.print_exc(limit=None, file=None, chain=True)

   This is a shorthand for "print_exception(sys.exception(), limit,
   file, chain)".

traceback.print_last(limit=None, file=None, chain=True)

   This is a shorthand for "print_exception(sys.last_type,
   sys.last_value, sys.last_traceback, limit, file, chain)".  In
   general it will work only after an exception has reached an
   interactive prompt (see "sys.last_type").

traceback.print_stack(f=None, limit=None, file=None)

   Print up to _limit_ stack trace entries (starting from the
   invocation point) if _limit_ is positive.  Otherwise, print the
   last "abs(limit)" entries.  If _limit_ is omitted or "None", all
   entries are printed. The optional _f_ argument can be used to
   specify an alternate stack frame to start.  The optional _file_
   argument has the same meaning as for "print_tb()".

   Changed in version 3.5: Added negative _limit_ support.

traceback.extract_tb(tb, limit=None)

   Return a "StackSummary" object representing a list of “pre-
   processed” stack trace entries extracted from the traceback object
   _tb_.  It is useful for alternate formatting of stack traces.  The
   optional _limit_ argument has the same meaning as for "print_tb()".
   A “pre-processed” stack trace entry is a "FrameSummary" object
   containing attributes "filename", "lineno", "name", and "line"
   representing the information that is usually printed for a stack
   trace.

traceback.extract_stack(f=None, limit=None)

   Extract the raw traceback from the current stack frame.  The return
   value has the same format as for "extract_tb()".  The optional _f_
   and _limit_ arguments have the same meaning as for "print_stack()".

traceback.format_list(extracted_list)

   Given a list of tuples or "FrameSummary" objects as returned by
   "extract_tb()" or "extract_stack()", return a list of strings ready
   for printing.  Each string in the resulting list corresponds to the
   item with the same index in the argument list.  Each string ends in
   a newline; the strings may contain internal newlines as well, for
   those items whose source text line is not "None".

traceback.format_exception_only(exc, /[, value])

   Format the exception part of a traceback using an exception value
   such as given by "sys.last_value".  The return value is a list of
   strings, each ending in a newline.  The list contains the
   exception’s message, which is normally a single string; however,
   for "SyntaxError" exceptions, it contains several lines that (when
   printed) display detailed information about where the syntax error
   occurred. Following the message, the list contains the exception’s
   "notes".

   Since Python 3.10, instead of passing _value_, an exception object
   can be passed as the first argument.  If _value_ is provided, the
   first argument is ignored in order to provide backwards
   compatibility.

   Changed in version 3.10: The _etype_ parameter has been renamed to
   _exc_ and is now positional-only.

   Changed in version 3.11: The returned list now includes any "notes"
   attached to the exception.

traceback.format_exception(exc, /, [value, tb, ]limit=None, chain=True)

   Format a stack trace and the exception information.  The arguments
   have the same meaning as the corresponding arguments to
   "print_exception()".  The return value is a list of strings, each
   ending in a newline and some containing internal newlines.  When
   these lines are concatenated and printed, exactly the same text is
   printed as does "print_exception()".

   Changed in version 3.5: The _etype_ argument is ignored and
   inferred from the type of _value_.

   Changed in version 3.10: This function’s behavior and signature
   were modified to match "print_exception()".

traceback.format_exc(limit=None, chain=True)

   This is like "print_exc(limit)" but returns a string instead of
   printing to a file.

traceback.format_tb(tb, limit=None)

   A shorthand for "format_list(extract_tb(tb, limit))".

traceback.format_stack(f=None, limit=None)

   A shorthand for "format_list(extract_stack(f, limit))".

traceback.clear_frames(tb)

   Clears the local variables of all the stack frames in a traceback
   _tb_ by calling the "clear()" method of each frame object.

   New in version 3.4.

traceback.walk_stack(f)

   Walk a stack following "f.f_back" from the given frame, yielding
   the frame and line number for each frame. If _f_ is "None", the
   current stack is used. This helper is used with
   "StackSummary.extract()".

   New in version 3.5.

traceback.walk_tb(tb)

   Walk a traceback following "tb_next" yielding the frame and line
   number for each frame. This helper is used with
   "StackSummary.extract()".

   New in version 3.5.

The module also defines the following classes:


"TracebackException" Objects
============================

New in version 3.5.

"TracebackException" objects are created from actual exceptions to
capture data for later printing in a lightweight fashion.

class traceback.TracebackException(exc_type, exc_value, exc_traceback, *, limit=None, lookup_lines=True, capture_locals=False, compact=False, max_group_width=15, max_group_depth=10)

   Capture an exception for later rendering. _limit_, _lookup_lines_
   and _capture_locals_ are as for the "StackSummary" class.

   If _compact_ is true, only data that is required by
   "TracebackException"’s "format()" method is saved in the class
   attributes. In particular, the "__context__" field is calculated
   only if "__cause__" is "None" and "__suppress_context__" is false.

   Note that when locals are captured, they are also shown in the
   traceback.

   _max_group_width_ and _max_group_depth_ control the formatting of
   exception groups (see "BaseExceptionGroup"). The depth refers to
   the nesting level of the group, and the width refers to the size of
   a single exception group’s exceptions array. The formatted output
   is truncated when either limit is exceeded.

   Changed in version 3.10: Added the _compact_ parameter.

   Changed in version 3.11: Added the _max_group_width_ and
   _max_group_depth_ parameters.

   __cause__

      A "TracebackException" of the original "__cause__".

   __context__

      A "TracebackException" of the original "__context__".

   exceptions

      If "self" represents an "ExceptionGroup", this field holds a
      list of "TracebackException" instances representing the nested
      exceptions. Otherwise it is "None".

      New in version 3.11.

   __suppress_context__

      The "__suppress_context__" value from the original exception.

   __notes__

      The "__notes__" value from the original exception, or "None" if
      the exception does not have any notes. If it is not "None" is it
      formatted in the traceback after the exception string.

      New in version 3.11.

   stack

      A "StackSummary" representing the traceback.

   exc_type

      The class of the original traceback.

   filename

      For syntax errors - the file name where the error occurred.

   lineno

      For syntax errors - the line number where the error occurred.

   end_lineno

      For syntax errors - the end line number where the error
      occurred. Can be "None" if not present.

      New in version 3.10.

   text

      For syntax errors - the text where the error occurred.

   offset

      For syntax errors - the offset into the text where the error
      occurred.

   end_offset

      For syntax errors - the end offset into the text where the error
      occurred. Can be "None" if not present.

      New in version 3.10.

   msg

      For syntax errors - the compiler error message.

   classmethod from_exception(exc, *, limit=None, lookup_lines=True, capture_locals=False)

      Capture an exception for later rendering. _limit_,
      _lookup_lines_ and _capture_locals_ are as for the
      "StackSummary" class.

      Note that when locals are captured, they are also shown in the
      traceback.

   print(*, file=None, chain=True)

      Print to _file_ (default "sys.stderr") the exception information
      returned by "format()".

      New in version 3.11.

   format(*, chain=True)

      Format the exception.

      If _chain_ is not "True", "__cause__" and "__context__" will not
      be formatted.

      The return value is a generator of strings, each ending in a
      newline and some containing internal newlines.
      "print_exception()" is a wrapper around this method which just
      prints the lines to a file.

   format_exception_only()

      Format the exception part of the traceback.

      The return value is a generator of strings, each ending in a
      newline.

      The generator emits the exception’s message followed by its
      notes (if it has any). The exception message is normally a
      single string; however, for "SyntaxError" exceptions, it
      consists of several lines that (when printed) display detailed
      information about where the syntax error occurred.

      Changed in version 3.11: The exception’s "notes" are now
      included in the output.


"StackSummary" Objects
======================

New in version 3.5.

"StackSummary" objects represent a call stack ready for formatting.

class traceback.StackSummary

   classmethod extract(frame_gen, *, limit=None, lookup_lines=True, capture_locals=False)

      Construct a "StackSummary" object from a frame generator (such
      as is returned by "walk_stack()" or "walk_tb()").

      If _limit_ is supplied, only this many frames are taken from
      _frame_gen_. If _lookup_lines_ is "False", the returned
      "FrameSummary" objects will not have read their lines in yet,
      making the cost of creating the "StackSummary" cheaper (which
      may be valuable if it may not actually get formatted). If
      _capture_locals_ is "True" the local variables in each
      "FrameSummary" are captured as object representations.

   classmethod from_list(a_list)

      Construct a "StackSummary" object from a supplied list of
      "FrameSummary" objects or old-style list of tuples.  Each tuple
      should be a 4-tuple with _filename_, _lineno_, _name_, _line_ as
      the elements.

   format()

      Returns a list of strings ready for printing.  Each string in
      the resulting list corresponds to a single frame from the stack.
      Each string ends in a newline; the strings may contain internal
      newlines as well, for those items with source text lines.

      For long sequences of the same frame and line, the first few
      repetitions are shown, followed by a summary line stating the
      exact number of further repetitions.

      Changed in version 3.6: Long sequences of repeated frames are
      now abbreviated.

   format_frame_summary(frame_summary)

      Returns a string for printing one of the frames involved in the
      stack. This method is called for each "FrameSummary" object to
      be printed by "StackSummary.format()". If it returns "None", the
      frame is omitted from the output.

      New in version 3.11.


"FrameSummary" Objects
======================

New in version 3.5.

A "FrameSummary" object represents a single frame in a traceback.

class traceback.FrameSummary(filename, lineno, name, lookup_line=True, locals=None, line=None)

   Represents a single frame in the traceback or stack that is being
   formatted or printed. It may optionally have a stringified version
   of the frame’s locals included in it. If _lookup_line_ is "False",
   the source code is not looked up until the "FrameSummary" has the
   "line" attribute accessed (which also happens when casting it to a
   "tuple"). "line" may be directly provided, and will prevent line
   lookups happening at all. _locals_ is an optional local variable
   dictionary, and if supplied the variable representations are stored
   in the summary for later display.

   "FrameSummary" instances have the following attributes:

   filename

      The filename of the source code for this frame. Equivalent to
      accessing "f.f_code.co_filename" on a frame object _f_.

   lineno

      The line number of the source code for this frame.

   name

      Equivalent to accessing "f.f_code.co_name" on a frame object
      _f_.

   line

      A string representing the source code for this frame, with
      leading and trailing whitespace stripped. If the source is not
      available, it is "None".


Traceback Examples
==================

This simple example implements a basic read-eval-print loop, similar
to (but less useful than) the standard Python interactive interpreter
loop.  For a more complete implementation of the interpreter loop,
refer to the "code" module.
>
   import sys, traceback

   def run_user_code(envdir):
       source = input(">>> ")
       try:
           exec(source, envdir)
       except Exception:
           print("Exception in user code:")
           print("-"*60)
           traceback.print_exc(file=sys.stdout)
           print("-"*60)

   envdir = {}
   while True:
       run_user_code(envdir)
<
The following example demonstrates the different ways to print and
format the exception and traceback:
>
   import sys, traceback

   def lumberjack():
       bright_side_of_life()

   def bright_side_of_life():
       return tuple()[0]

   try:
       lumberjack()
   except IndexError:
       exc = sys.exception()
       print("*** print_tb:")
       traceback.print_tb(exc.__traceback__, limit=1, file=sys.stdout)
       print("*** print_exception:")
       traceback.print_exception(exc, limit=2, file=sys.stdout)
       print("*** print_exc:")
       traceback.print_exc(limit=2, file=sys.stdout)
       print("*** format_exc, first and last line:")
       formatted_lines = traceback.format_exc().splitlines()
       print(formatted_lines[0])
       print(formatted_lines[-1])
       print("*** format_exception:")
       print(repr(traceback.format_exception(exc)))
       print("*** extract_tb:")
       print(repr(traceback.extract_tb(exc.__traceback__)))
       print("*** format_tb:")
       print(repr(traceback.format_tb(exc.__traceback__)))
       print("*** tb_lineno:", exc.__traceback__.tb_lineno)
<
The output for the example would look similar to this:
>
   *** print_tb:
     File "<doctest...>", line 10, in <module>
       lumberjack()
   *** print_exception:
   Traceback (most recent call last):
     File "<doctest...>", line 10, in <module>
       lumberjack()
     File "<doctest...>", line 4, in lumberjack
       bright_side_of_life()
   IndexError: tuple index out of range
   *** print_exc:
   Traceback (most recent call last):
     File "<doctest...>", line 10, in <module>
       lumberjack()
     File "<doctest...>", line 4, in lumberjack
       bright_side_of_life()
   IndexError: tuple index out of range
   *** format_exc, first and last line:
   Traceback (most recent call last):
   IndexError: tuple index out of range
   *** format_exception:
   ['Traceback (most recent call last):\n',
    '  File "<doctest default[0]>", line 10, in <module>\n    lumberjack()\n',
    '  File "<doctest default[0]>", line 4, in lumberjack\n    bright_side_of_life()\n',
    '  File "<doctest default[0]>", line 7, in bright_side_of_life\n    return tuple()[0]\n           ~~~~~~~^^^\n',
    'IndexError: tuple index out of range\n']
   *** extract_tb:
   [<FrameSummary file <doctest...>, line 10 in <module>>,
    <FrameSummary file <doctest...>, line 4 in lumberjack>,
    <FrameSummary file <doctest...>, line 7 in bright_side_of_life>]
   *** format_tb:
   ['  File "<doctest default[0]>", line 10, in <module>\n    lumberjack()\n',
    '  File "<doctest default[0]>", line 4, in lumberjack\n    bright_side_of_life()\n',
    '  File "<doctest default[0]>", line 7, in bright_side_of_life\n    return tuple()[0]\n           ~~~~~~~^^^\n']
   *** tb_lineno: 10
<
The following example shows the different ways to print and format the
stack:
>
   >>> import traceback
   >>> def another_function():
   ...     lumberstack()
   ...
   >>> def lumberstack():
   ...     traceback.print_stack()
   ...     print(repr(traceback.extract_stack()))
   ...     print(repr(traceback.format_stack()))
   ...
   >>> another_function()
     File "<doctest>", line 10, in <module>
       another_function()
     File "<doctest>", line 3, in another_function
       lumberstack()
     File "<doctest>", line 6, in lumberstack
       traceback.print_stack()
   [('<doctest>', 10, '<module>', 'another_function()'),
    ('<doctest>', 3, 'another_function', 'lumberstack()'),
    ('<doctest>', 7, 'lumberstack', 'print(repr(traceback.extract_stack()))')]
   ['  File "<doctest>", line 10, in <module>\n    another_function()\n',
    '  File "<doctest>", line 3, in another_function\n    lumberstack()\n',
    '  File "<doctest>", line 8, in lumberstack\n    print(repr(traceback.format_stack()))\n']
<
This last example demonstrates the final few formatting functions:
>
   >>> import traceback
   >>> traceback.format_list([('spam.py', 3, '<module>', 'spam.eggs()'),
   ...                        ('eggs.py', 42, 'eggs', 'return "bacon"')])
   ['  File "spam.py", line 3, in <module>\n    spam.eggs()\n',
    '  File "eggs.py", line 42, in eggs\n    return "bacon"\n']
   >>> an_error = IndexError('tuple index out of range')
   >>> traceback.format_exception_only(type(an_error), an_error)
   ['IndexError: tuple index out of range\n']
<
vim:tw=78:ts=8:ft=help:norl: