Python 3.9.19
*__main__.pyx*                                Last change: 2024 May 24

"__main__" — Top-level script environment
*****************************************

======================================================================

"'__main__'" is the name of the scope in which top-level code
executes. A module’s __name__ is set equal to "'__main__'" when read
from standard input, a script, or from an interactive prompt.

A module can discover whether or not it is running in the main scope
by checking its own "__name__", which allows a common idiom for
conditionally executing code in a module when it is run as a script or
with "python -m" but not when it is imported:
>
   if __name__ == "__main__":
       # execute only if run as a script
       main()
<
For a package, the same effect can be achieved by including a
"__main__.py" module, the contents of which will be executed when the
module is run with "-m".

vim:tw=78:ts=8:ft=help:norl: