Python 3.12.3
*os.path.pyx*                                 Last change: 2024 May 24

"os.path" — Common pathname manipulations
*****************************************

**Source code:** Lib/posixpath.py (for POSIX) and Lib/ntpath.py (for
Windows).

======================================================================

This module implements some useful functions on pathnames. To read or
write files see "open()", and for accessing the filesystem see the
"os" module. The path parameters can be passed as strings, or bytes,
or any object implementing the "os.PathLike" protocol.

Unlike a Unix shell, Python does not do any _automatic_ path
expansions. Functions such as "expanduser()" and "expandvars()" can be
invoked explicitly when an application desires shell-like path
expansion.  (See also the "glob" module.)

See also: The "pathlib" module offers high-level path objects.

Note:

  All of these functions accept either only bytes or only string
  objects as their parameters.  The result is an object of the same
  type, if a path or file name is returned.

Note:

  Since different operating systems have different path name
  conventions, there are several versions of this module in the
  standard library.  The "os.path" module is always the path module
  suitable for the operating system Python is running on, and
  therefore usable for local paths.  However, you can also import and
  use the individual modules if you want to manipulate a path that is
  _always_ in one of the different formats.  They all have the same
  interface:

  * "posixpath" for UNIX-style paths

  * "ntpath" for Windows paths

Changed in version 3.8: "exists()", "lexists()", "isdir()",
"isfile()", "islink()", and "ismount()" now return "False" instead of
raising an exception for paths that contain characters or bytes
unrepresentable at the OS level.

os.path.abspath(path)

   Return a normalized absolutized version of the pathname _path_. On
   most platforms, this is equivalent to calling the function
   "normpath()" as follows: "normpath(join(os.getcwd(), path))".

   Changed in version 3.6: Accepts a _path-like object_.

os.path.basename(path)

   Return the base name of pathname _path_.  This is the second
   element of the pair returned by passing _path_ to the function
   "split()".  Note that the result of this function is different from
   the Unix **basename** program; where **basename** for "'/foo/bar/'"
   returns "'bar'", the "basename()" function returns an empty string
   ("''").

   Changed in version 3.6: Accepts a _path-like object_.

os.path.commonpath(paths)

   Return the longest common sub-path of each pathname in the sequence
   _paths_.  Raise "ValueError" if _paths_ contain both absolute and
   relative pathnames, the _paths_ are on the different drives or if
   _paths_ is empty.  Unlike "commonprefix()", this returns a valid
   path.

   Availability: Unix, Windows.

   New in version 3.5.

   Changed in version 3.6: Accepts a sequence of _path-like objects_.

os.path.commonprefix(list)

   Return the longest path prefix (taken character-by-character) that
   is a prefix of all paths in  _list_.  If _list_ is empty, return
   the empty string ("''").

   Note:

     This function may return invalid paths because it works a
     character at a time.  To obtain a valid path, see "commonpath()".

>
        >>> os.path.commonprefix(['/usr/lib', '/usr/local/lib'])
        '/usr/l'

        >>> os.path.commonpath(['/usr/lib', '/usr/local/lib'])
        '/usr'
<
   Changed in version 3.6: Accepts a _path-like object_.

os.path.dirname(path)

   Return the directory name of pathname _path_.  This is the first
   element of the pair returned by passing _path_ to the function
   "split()".

   Changed in version 3.6: Accepts a _path-like object_.

os.path.exists(path)

   Return "True" if _path_ refers to an existing path or an open file
   descriptor.  Returns "False" for broken symbolic links.  On some
   platforms, this function may return "False" if permission is not
   granted to execute "os.stat()" on the requested file, even if the
   _path_ physically exists.

   Changed in version 3.3: _path_ can now be an integer: "True" is
   returned if it is an  open file descriptor, "False" otherwise.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.lexists(path)

   Return "True" if _path_ refers to an existing path. Returns "True"
   for broken symbolic links.   Equivalent to "exists()" on platforms
   lacking "os.lstat()".

   Changed in version 3.6: Accepts a _path-like object_.

os.path.expanduser(path)

   On Unix and Windows, return the argument with an initial component
   of "~" or "~user" replaced by that _user_’s home directory.

   On Unix, an initial "~" is replaced by the environment variable
   "HOME" if it is set; otherwise the current user’s home directory is
   looked up in the password directory through the built-in module
   "pwd". An initial "~user" is looked up directly in the password
   directory.

   On Windows, "USERPROFILE" will be used if set, otherwise a
   combination of "HOMEPATH" and "HOMEDRIVE" will be used.  An initial
   "~user" is handled by checking that the last directory component of
   the current user’s home directory matches "USERNAME", and replacing
   it if so.

   If the expansion fails or if the path does not begin with a tilde,
   the path is returned unchanged.

   Changed in version 3.6: Accepts a _path-like object_.

   Changed in version 3.8: No longer uses "HOME" on Windows.

os.path.expandvars(path)

   Return the argument with environment variables expanded.
   Substrings of the form "$name" or "${name}" are replaced by the
   value of environment variable _name_.  Malformed variable names and
   references to non-existing variables are left unchanged.

   On Windows, "%name%" expansions are supported in addition to
   "$name" and "${name}".

   Changed in version 3.6: Accepts a _path-like object_.

os.path.getatime(path)

   Return the time of last access of _path_.  The return value is a
   floating point number giving the number of seconds since the epoch
   (see the  "time" module).  Raise "OSError" if the file does not
   exist or is inaccessible.

os.path.getmtime(path)

   Return the time of last modification of _path_.  The return value
   is a floating point number giving the number of seconds since the
   epoch (see the  "time" module). Raise "OSError" if the file does
   not exist or is inaccessible.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.getctime(path)

   Return the system’s ctime which, on some systems (like Unix) is the
   time of the last metadata change, and, on others (like Windows), is
   the creation time for _path_. The return value is a number giving
   the number of seconds since the epoch (see the  "time" module).
   Raise "OSError" if the file does not exist or is inaccessible.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.getsize(path)

   Return the size, in bytes, of _path_.  Raise "OSError" if the file
   does not exist or is inaccessible.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.isabs(path)

   Return "True" if _path_ is an absolute pathname.  On Unix, that
   means it begins with a slash, on Windows that it begins with a
   (back)slash after chopping off a potential drive letter.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.isfile(path)

   Return "True" if _path_ is an "existing" regular file. This follows
   symbolic links, so both "islink()" and "isfile()" can be true for
   the same path.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.isdir(path)

   Return "True" if _path_ is an "existing" directory.  This follows
   symbolic links, so both "islink()" and "isdir()" can be true for
   the same path.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.isjunction(path)

   Return "True" if _path_ refers to an "existing" directory entry
   that is a junction.  Always return "False" if junctions are not
   supported on the current platform.

   New in version 3.12.

os.path.islink(path)

   Return "True" if _path_ refers to an "existing" directory entry
   that is a symbolic link.  Always "False" if symbolic links are not
   supported by the Python runtime.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.ismount(path)

   Return "True" if pathname _path_ is a _mount point_: a point in a
   file system where a different file system has been mounted.  On
   POSIX, the function checks whether _path_’s parent, "_path_/..", is
   on a different device than _path_, or whether "_path_/.." and
   _path_ point to the same i-node on the same device — this should
   detect mount points for all Unix and POSIX variants.  It is not
   able to reliably detect bind mounts on the same filesystem.  On
   Windows, a drive letter root and a share UNC are always mount
   points, and for any other path "GetVolumePathName" is called to see
   if it is different from the input path.

   New in version 3.4: Support for detecting non-root mount points on
   Windows.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.isdevdrive(path)

   Return "True" if pathname _path_ is located on a Windows Dev Drive.
   A Dev Drive is optimized for developer scenarios, and offers faster
   performance for reading and writing files. It is recommended for
   use for source code, temporary build directories, package caches,
   and other IO-intensive operations.

   May raise an error for an invalid path, for example, one without a
   recognizable drive, but returns "False" on platforms that do not
   support Dev Drives. See the Windows documentation for information
   on enabling and creating Dev Drives.

   Availability: Windows.

   New in version 3.12.

os.path.join(path, *paths)

   Join one or more path segments intelligently.  The return value is
   the concatenation of _path_ and all members of _*paths_, with
   exactly one directory separator following each non-empty part,
   except the last. That is, the result will only end in a separator
   if the last part is either empty or ends in a separator. If a
   segment is an absolute path (which on Windows requires both a drive
   and a root), then all previous segments are ignored and joining
   continues from the absolute path segment.

   On Windows, the drive is not reset when a rooted path segment
   (e.g., "r'\foo'") is encountered. If a segment is on a different
   drive or is an absolute path, all previous segments are ignored and
   the drive is reset. Note that since there is a current directory
   for each drive, "os.path.join("c:", "foo")" represents a path
   relative to the current directory on drive "C:" ("c:foo"), not
   "c:\foo".

   Changed in version 3.6: Accepts a _path-like object_ for _path_ and
   _paths_.

os.path.normcase(path)

   Normalize the case of a pathname.  On Windows, convert all
   characters in the pathname to lowercase, and also convert forward
   slashes to backward slashes. On other operating systems, return the
   path unchanged.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.normpath(path)

      Normalize a pathname by collapsing redundant separators and up-
      level references so that "A//B", "A/B/", "A/./B" and
      "A/foo/../B" all become "A/B".  This string manipulation may
      change the meaning of a path that contains symbolic links.  On
      Windows, it converts forward slashes to backward slashes. To
      normalize case, use "normcase()".

   Note:

        On POSIX systems, in accordance with IEEE Std 1003.1 2013
        Edition; 4.13 Pathname Resolution, if a pathname begins with
        exactly two slashes, the first component following the leading
        characters may be interpreted in an implementation-defined
        manner, although more than two leading characters shall be
        treated as a single character.

     Changed in version 3.6: Accepts a _path-like object_.

os.path.realpath(path, *, strict=False)

   Return the canonical path of the specified filename, eliminating
   any symbolic links encountered in the path (if they are supported
   by the operating system).

   If a path doesn’t exist or a symlink loop is encountered, and
   _strict_ is "True", "OSError" is raised. If _strict_ is "False",
   the path is resolved as far as possible and any remainder is
   appended without checking whether it exists.

   Note:

     This function emulates the operating system’s procedure for
     making a path canonical, which differs slightly between Windows
     and UNIX with respect to how links and subsequent path components
     interact.Operating system APIs make paths canonical as needed, so
     it’s not normally necessary to call this function.

   Changed in version 3.6: Accepts a _path-like object_.

   Changed in version 3.8: Symbolic links and junctions are now
   resolved on Windows.

   Changed in version 3.10: The _strict_ parameter was added.

os.path.relpath(path, start=os.curdir)

   Return a relative filepath to _path_ either from the current
   directory or from an optional _start_ directory.  This is a path
   computation:  the filesystem is not accessed to confirm the
   existence or nature of _path_ or _start_.  On Windows, "ValueError"
   is raised when _path_ and _start_ are on different drives.

   _start_ defaults to "os.curdir".

   Availability: Unix, Windows.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.samefile(path1, path2)

   Return "True" if both pathname arguments refer to the same file or
   directory. This is determined by the device number and i-node
   number and raises an exception if an "os.stat()" call on either
   pathname fails.

   Availability: Unix, Windows.

   Changed in version 3.2: Added Windows support.

   Changed in version 3.4: Windows now uses the same implementation as
   all other platforms.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.sameopenfile(fp1, fp2)

   Return "True" if the file descriptors _fp1_ and _fp2_ refer to the
   same file.

   Availability: Unix, Windows.

   Changed in version 3.2: Added Windows support.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.samestat(stat1, stat2)

   Return "True" if the stat tuples _stat1_ and _stat2_ refer to the
   same file. These structures may have been returned by "os.fstat()",
   "os.lstat()", or "os.stat()".  This function implements the
   underlying comparison used by "samefile()" and "sameopenfile()".

   Availability: Unix, Windows.

   Changed in version 3.4: Added Windows support.

   Changed in version 3.6: Accepts a _path-like object_.

os.path.split(path)

   Split the pathname _path_ into a pair, "(head, tail)" where _tail_
   is the last pathname component and _head_ is everything leading up
   to that.  The _tail_ part will never contain a slash; if _path_
   ends in a slash, _tail_ will be empty.  If there is no slash in
   _path_, _head_ will be empty.  If _path_ is empty, both _head_ and
   _tail_ are empty.  Trailing slashes are stripped from _head_ unless
   it is the root (one or more slashes only).  In all cases,
   "join(head, tail)" returns a path to the same location as _path_
   (but the strings may differ).  Also see the functions "dirname()"
   and "basename()".

   Changed in version 3.6: Accepts a _path-like object_.

os.path.splitdrive(path)

   Split the pathname _path_ into a pair "(drive, tail)" where _drive_
   is either a mount point or the empty string.  On systems which do
   not use drive specifications, _drive_ will always be the empty
   string.  In all cases, "drive + tail" will be the same as _path_.

   On Windows, splits a pathname into drive/UNC sharepoint and
   relative path.

   If the path contains a drive letter, drive will contain everything
   up to and including the colon:
>
      >>> splitdrive("c:/dir")
      ("c:", "/dir")
<
   If the path contains a UNC path, drive will contain the host name
   and share:
>
      >>> splitdrive("//host/computer/dir")
      ("//host/computer", "/dir")
<
   Changed in version 3.6: Accepts a _path-like object_.

os.path.splitroot(path)

   Split the pathname _path_ into a 3-item tuple "(drive, root, tail)"
   where _drive_ is a device name or mount point, _root_ is a string
   of separators after the drive, and _tail_ is everything after the
   root. Any of these items may be the empty string. In all cases,
   "drive + root + tail" will be the same as _path_.

   On POSIX systems, _drive_ is always empty. The _root_ may be empty
   (if _path_ is relative), a single forward slash (if _path_ is
   absolute), or two forward slashes (implementation-defined per IEEE
   Std 1003.1-2017; 4.13 Pathname Resolution.) For example:
>
      >>> splitroot('/home/sam')
      ('', '/', 'home/sam')
      >>> splitroot('//home/sam')
      ('', '//', 'home/sam')
      >>> splitroot('///home/sam')
      ('', '/', '//home/sam')
<
   On Windows, _drive_ may be empty, a drive-letter name, a UNC share,
   or a device name. The _root_ may be empty, a forward slash, or a
   backward slash. For example:
>
      >>> splitroot('C:/Users/Sam')
      ('C:', '/', 'Users/Sam')
      >>> splitroot('//Server/Share/Users/Sam')
      ('//Server/Share', '/', 'Users/Sam')
<
   New in version 3.12.

os.path.splitext(path)

   Split the pathname _path_ into a pair "(root, ext)"  such that
   "root + ext == path", and the extension, _ext_, is empty or begins
   with a period and contains at most one period.

   If the path contains no extension, _ext_ will be "''":
>
      >>> splitext('bar')
      ('bar', '')
<
   If the path contains an extension, then _ext_ will be set to this
   extension, including the leading period. Note that previous periods
   will be ignored:
>
      >>> splitext('foo.bar.exe')
      ('foo.bar', '.exe')
      >>> splitext('/foo/bar.exe')
      ('/foo/bar', '.exe')
<
   Leading periods of the last component of the path are considered to
   be part of the root:
>
      >>> splitext('.cshrc')
      ('.cshrc', '')
      >>> splitext('/foo/....jpg')
      ('/foo/....jpg', '')
<
   Changed in version 3.6: Accepts a _path-like object_.

os.path.supports_unicode_filenames

   "True" if arbitrary Unicode strings can be used as file names
   (within limitations imposed by the file system).

vim:tw=78:ts=8:ft=help:norl: