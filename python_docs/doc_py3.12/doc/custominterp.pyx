Python 3.12.3
*custominterp.pyx*                            Last change: 2024 May 24

Custom Python Interpreters
**************************

The modules described in this chapter allow writing interfaces similar
to Python’s interactive interpreter.  If you want a Python interpreter
that supports some special feature in addition to the Python language,
you should look at the "code" module.  (The "codeop" module is lower-
level, used to support compiling a possibly incomplete chunk of Python
code.)

The full list of modules described in this chapter is:

* "code" — Interpreter base classes

  * Interactive Interpreter Objects

  * Interactive Console Objects

* "codeop" — Compile Python code

vim:tw=78:ts=8:ft=help:norl: