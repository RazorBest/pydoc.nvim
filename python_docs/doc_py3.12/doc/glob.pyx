Python 3.12.3
*glob.pyx*                                    Last change: 2024 May 24

"glob" — Unix style pathname pattern expansion
**********************************************

**Source code:** Lib/glob.py

======================================================================

The "glob" module finds all the pathnames matching a specified pattern
according to the rules used by the Unix shell, although results are
returned in arbitrary order.  No tilde expansion is done, but "*",
"?", and character ranges expressed with "[]" will be correctly
matched.  This is done by using the "os.scandir()" and
"fnmatch.fnmatch()" functions in concert, and not by actually invoking
a subshell.

Note that files beginning with a dot (".") can only be matched by
patterns that also start with a dot, unlike "fnmatch.fnmatch()" or
"pathlib.Path.glob()". (For tilde and shell variable expansion, use
"os.path.expanduser()" and "os.path.expandvars()".)

For a literal match, wrap the meta-characters in brackets. For
example, "'[?]'" matches the character "'?'".

See also: The "pathlib" module offers high-level path objects.

glob.glob(pathname, *, root_dir=None, dir_fd=None, recursive=False, include_hidden=False)

   Return a possibly empty list of path names that match _pathname_,
   which must be a string containing a path specification. _pathname_
   can be either absolute (like "/usr/src/Python-1.5/Makefile") or
   relative (like "../../Tools/*/*.gif"), and can contain shell-style
   wildcards. Broken symlinks are included in the results (as in the
   shell). Whether or not the results are sorted depends on the file
   system.  If a file that satisfies conditions is removed or added
   during the call of this function, whether a path name for that file
   will be included is unspecified.

   If _root_dir_ is not "None", it should be a _path-like object_
   specifying the root directory for searching.  It has the same
   effect on "glob()" as changing the current directory before calling
   it.  If _pathname_ is relative, the result will contain paths
   relative to _root_dir_.

   This function can support paths relative to directory descriptors
   with the _dir_fd_ parameter.

   If _recursive_ is true, the pattern “"**"” will match any files and
   zero or more directories, subdirectories and symbolic links to
   directories. If the pattern is followed by an "os.sep" or
   "os.altsep" then files will not match.

   If _include_hidden_ is true, “"**"” pattern will match hidden
   directories.

   Raises an auditing event "glob.glob" with arguments "pathname",
   "recursive".

   Raises an auditing event "glob.glob/2" with arguments "pathname",
   "recursive", "root_dir", "dir_fd".

   Note:

     Using the “"**"” pattern in large directory trees may consume an
     inordinate amount of time.

   Changed in version 3.5: Support for recursive globs using “"**"”.

   Changed in version 3.10: Added the _root_dir_ and _dir_fd_
   parameters.

   Changed in version 3.11: Added the _include_hidden_ parameter.

glob.iglob(pathname, *, root_dir=None, dir_fd=None, recursive=False, include_hidden=False)

   Return an _iterator_ which yields the same values as "glob()"
   without actually storing them all simultaneously.

   Raises an auditing event "glob.glob" with arguments "pathname",
   "recursive".

   Raises an auditing event "glob.glob/2" with arguments "pathname",
   "recursive", "root_dir", "dir_fd".

   Changed in version 3.5: Support for recursive globs using “"**"”.

   Changed in version 3.10: Added the _root_dir_ and _dir_fd_
   parameters.

   Changed in version 3.11: Added the _include_hidden_ parameter.

glob.escape(pathname)

   Escape all special characters ("'?'", "'*'" and "'['"). This is
   useful if you want to match an arbitrary literal string that may
   have special characters in it.  Special characters in drive/UNC
   sharepoints are not escaped, e.g. on Windows "escape('//?/c:/Quo
   vadis?.txt')" returns "'//?/c:/Quo vadis[?].txt'".

   New in version 3.4.

For example, consider a directory containing the following files:
"1.gif", "2.txt", "card.gif" and a subdirectory "sub" which contains
only the file "3.txt".  "glob()" will produce the following results.
Notice how any leading components of the path are preserved.
>
   >>> import glob
   >>> glob.glob('./[0-9].*')
   ['./1.gif', './2.txt']
   >>> glob.glob('*.gif')
   ['1.gif', 'card.gif']
   >>> glob.glob('?.gif')
   ['1.gif']
   >>> glob.glob('**/*.txt', recursive=True)
   ['2.txt', 'sub/3.txt']
   >>> glob.glob('./**/', recursive=True)
   ['./', './sub/']
<
If the directory contains files starting with "." they won’t be
matched by default. For example, consider a directory containing
"card.gif" and ".card.gif":
>
   >>> import glob
   >>> glob.glob('*.gif')
   ['card.gif']
   >>> glob.glob('.c*')
   ['.card.gif']
<
See also:

  Module "fnmatch"
     Shell-style filename (not path) expansion

vim:tw=78:ts=8:ft=help:norl: