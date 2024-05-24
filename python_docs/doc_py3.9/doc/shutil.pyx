Python 3.9.19
*shutil.pyx*                                  Last change: 2024 May 24

"shutil" — High-level file operations
*************************************

**Source code:** Lib/shutil.py

======================================================================

The "shutil" module offers a number of high-level operations on files
and collections of files.  In particular, functions are provided
which support file copying and removal. For operations on individual
files, see also the "os" module.

Warning:

  Even the higher-level file copying functions ("shutil.copy()",
  "shutil.copy2()") cannot copy all file metadata.On POSIX platforms,
  this means that file owner and group are lost as well as ACLs.  On
  Mac OS, the resource fork and other metadata are not used. This
  means that resources will be lost and file type and creator codes
  will not be correct. On Windows, file owners, ACLs and alternate
  data streams are not copied.


Directory and files operations
==============================

shutil.copyfileobj(fsrc, fdst[, length])

   Copy the contents of the file-like object _fsrc_ to the file-like
   object _fdst_. The integer _length_, if given, is the buffer size.
   In particular, a negative _length_ value means to copy the data
   without looping over the source data in chunks; by default the data
   is read in chunks to avoid uncontrolled memory consumption. Note
   that if the current file position of the _fsrc_ object is not 0,
   only the contents from the current file position to the end of the
   file will be copied.

shutil.copyfile(src, dst, *, follow_symlinks=True)

   Copy the contents (no metadata) of the file named _src_ to a file
   named _dst_ and return _dst_ in the most efficient way possible.
   _src_ and _dst_ are path-like objects or path names given as
   strings.

   _dst_ must be the complete target file name; look at "copy()" for a
   copy that accepts a target directory path.  If _src_ and _dst_
   specify the same file, "SameFileError" is raised.

   The destination location must be writable; otherwise, an "OSError"
   exception will be raised. If _dst_ already exists, it will be
   replaced. Special files such as character or block devices and
   pipes cannot be copied with this function.

   If _follow_symlinks_ is false and _src_ is a symbolic link, a new
   symbolic link will be created instead of copying the file _src_
   points to.

   Raises an auditing event "shutil.copyfile" with arguments "src",
   "dst".

   Changed in version 3.3: "IOError" used to be raised instead of
   "OSError". Added _follow_symlinks_ argument. Now returns _dst_.

   Changed in version 3.4: Raise "SameFileError" instead of "Error".
   Since the former is a subclass of the latter, this change is
   backward compatible.

   Changed in version 3.8: Platform-specific fast-copy syscalls may be
   used internally in order to copy the file more efficiently. See
   Platform-dependent efficient copy operations section.

exception shutil.SameFileError

   This exception is raised if source and destination in "copyfile()"
   are the same file.

   New in version 3.4.

shutil.copymode(src, dst, *, follow_symlinks=True)

   Copy the permission bits from _src_ to _dst_.  The file contents,
   owner, and group are unaffected.  _src_ and _dst_ are path-like
   objects or path names given as strings. If _follow_symlinks_ is
   false, and both _src_ and _dst_ are symbolic links, "copymode()"
   will attempt to modify the mode of _dst_ itself (rather than the
   file it points to).  This functionality is not available on every
   platform; please see "copystat()" for more information.  If
   "copymode()" cannot modify symbolic links on the local platform,
   and it is asked to do so, it will do nothing and return.

   Raises an auditing event "shutil.copymode" with arguments "src",
   "dst".

   Changed in version 3.3: Added _follow_symlinks_ argument.

shutil.copystat(src, dst, *, follow_symlinks=True)

   Copy the permission bits, last access time, last modification time,
   and flags from _src_ to _dst_.  On Linux, "copystat()" also copies
   the “extended attributes” where possible.  The file contents,
   owner, and group are unaffected.  _src_ and _dst_ are path-like
   objects or path names given as strings.

   If _follow_symlinks_ is false, and _src_ and _dst_ both refer to
   symbolic links, "copystat()" will operate on the symbolic links
   themselves rather than the files the symbolic links refer
   to—reading the information from the _src_ symbolic link, and
   writing the information to the _dst_ symbolic link.

   Note:

     Not all platforms provide the ability to examine and modify
     symbolic links.  Python itself can tell you what functionality is
     locally available.

     * If "os.chmod in os.supports_follow_symlinks" is "True",
       "copystat()" can modify the permission bits of a symbolic link.

     * If "os.utime in os.supports_follow_symlinks" is "True",
       "copystat()" can modify the last access and modification times
       of a symbolic link.

     * If "os.chflags in os.supports_follow_symlinks" is "True",
       "copystat()" can modify the flags of a symbolic link.
       ("os.chflags" is not available on all platforms.)

     On platforms where some or all of this functionality is
     unavailable, when asked to modify a symbolic link, "copystat()"
     will copy everything it can. "copystat()" never returns
     failure.Please see "os.supports_follow_symlinks" for more
     information.

   Raises an auditing event "shutil.copystat" with arguments "src",
   "dst".

   Changed in version 3.3: Added _follow_symlinks_ argument and
   support for Linux extended attributes.

shutil.copy(src, dst, *, follow_symlinks=True)

   Copies the file _src_ to the file or directory _dst_.  _src_ and
   _dst_ should be _path-like objects_ or strings.  If _dst_ specifies
   a directory, the file will be copied into _dst_ using the base
   filename from _src_. If _dst_ specifies a file that already exists,
   it will be replaced. Returns the path to the newly created file.

   If _follow_symlinks_ is false, and _src_ is a symbolic link, _dst_
   will be created as a symbolic link.  If _follow_symlinks_ is true
   and _src_ is a symbolic link, _dst_ will be a copy of the file
   _src_ refers to.

   "copy()" copies the file data and the file’s permission mode (see
   "os.chmod()").  Other metadata, like the file’s creation and
   modification times, is not preserved. To preserve all file metadata
   from the original, use "copy2()" instead.

   Raises an auditing event "shutil.copyfile" with arguments "src",
   "dst".

   Raises an auditing event "shutil.copymode" with arguments "src",
   "dst".

   Changed in version 3.3: Added _follow_symlinks_ argument. Now
   returns path to the newly created file.

   Changed in version 3.8: Platform-specific fast-copy syscalls may be
   used internally in order to copy the file more efficiently. See
   Platform-dependent efficient copy operations section.

shutil.copy2(src, dst, *, follow_symlinks=True)

   Identical to "copy()" except that "copy2()" also attempts to
   preserve file metadata.

   When _follow_symlinks_ is false, and _src_ is a symbolic link,
   "copy2()" attempts to copy all metadata from the _src_ symbolic
   link to the newly-created _dst_ symbolic link. However, this
   functionality is not available on all platforms. On platforms where
   some or all of this functionality is unavailable, "copy2()" will
   preserve all the metadata it can; "copy2()" never raises an
   exception because it cannot preserve file metadata.

   "copy2()" uses "copystat()" to copy the file metadata. Please see
   "copystat()" for more information about platform support for
   modifying symbolic link metadata.

   Raises an auditing event "shutil.copyfile" with arguments "src",
   "dst".

   Raises an auditing event "shutil.copystat" with arguments "src",
   "dst".

   Changed in version 3.3: Added _follow_symlinks_ argument, try to
   copy extended file system attributes too (currently Linux only).
   Now returns path to the newly created file.

   Changed in version 3.8: Platform-specific fast-copy syscalls may be
   used internally in order to copy the file more efficiently. See
   Platform-dependent efficient copy operations section.

shutil.ignore_patterns(*patterns)

   This factory function creates a function that can be used as a
   callable for "copytree()"’s _ignore_ argument, ignoring files and
   directories that match one of the glob-style _patterns_ provided.
   See the example below.

shutil.copytree(src, dst, symlinks=False, ignore=None, copy_function=copy2, ignore_dangling_symlinks=False, dirs_exist_ok=False)

   Recursively copy an entire directory tree rooted at _src_ to a
   directory named _dst_ and return the destination directory.  All
   intermediate directories needed to contain _dst_ will also be
   created by default.

   Permissions and times of directories are copied with "copystat()",
   individual files are copied using "copy2()".

   If _symlinks_ is true, symbolic links in the source tree are
   represented as symbolic links in the new tree and the metadata of
   the original links will be copied as far as the platform allows; if
   false or omitted, the contents and metadata of the linked files are
   copied to the new tree.

   When _symlinks_ is false, if the file pointed by the symlink
   doesn’t exist, an exception will be added in the list of errors
   raised in an "Error" exception at the end of the copy process. You
   can set the optional _ignore_dangling_symlinks_ flag to true if you
   want to silence this exception. Notice that this option has no
   effect on platforms that don’t support "os.symlink()".

   If _ignore_ is given, it must be a callable that will receive as
   its arguments the directory being visited by "copytree()", and a
   list of its contents, as returned by "os.listdir()".  Since
   "copytree()" is called recursively, the _ignore_ callable will be
   called once for each directory that is copied.  The callable must
   return a sequence of directory and file names relative to the
   current directory (i.e. a subset of the items in its second
   argument); these names will then be ignored in the copy process.
   "ignore_patterns()" can be used to create such a callable that
   ignores names based on glob-style patterns.

   If exception(s) occur, an "Error" is raised with a list of reasons.

   If _copy_function_ is given, it must be a callable that will be
   used to copy each file. It will be called with the source path and
   the destination path as arguments. By default, "copy2()" is used,
   but any function that supports the same signature (like "copy()")
   can be used.

   If _dirs_exist_ok_ is false (the default) and _dst_ already exists,
   a "FileExistsError" is raised. If _dirs_exist_ok_ is true, the
   copying operation will continue if it encounters existing
   directories, and files within the _dst_ tree will be overwritten by
   corresponding files from the _src_ tree.

   Raises an auditing event "shutil.copytree" with arguments "src",
   "dst".

   Changed in version 3.3: Copy metadata when _symlinks_ is false. Now
   returns _dst_.

   Changed in version 3.2: Added the _copy_function_ argument to be
   able to provide a custom copy function. Added the
   _ignore_dangling_symlinks_ argument to silence dangling symlinks
   errors when _symlinks_ is false.

   Changed in version 3.8: Platform-specific fast-copy syscalls may be
   used internally in order to copy the file more efficiently. See
   Platform-dependent efficient copy operations section.

   New in version 3.8: The _dirs_exist_ok_ parameter.

shutil.rmtree(path, ignore_errors=False, onerror=None)

   Delete an entire directory tree; _path_ must point to a directory
   (but not a symbolic link to a directory).  If _ignore_errors_ is
   true, errors resulting from failed removals will be ignored; if
   false or omitted, such errors are handled by calling a handler
   specified by _onerror_ or, if that is omitted, they raise an
   exception.

   Note:

     On platforms that support the necessary fd-based functions a
     symlink attack resistant version of "rmtree()" is used by
     default.  On other platforms, the "rmtree()" implementation is
     susceptible to a symlink attack: given proper timing and
     circumstances, attackers can manipulate symlinks on the
     filesystem to delete files they wouldn’t be able to access
     otherwise.  Applications can use the
     "rmtree.avoids_symlink_attacks" function attribute to determine
     which case applies.

   If _onerror_ is provided, it must be a callable that accepts three
   parameters: _function_, _path_, and _excinfo_.

   The first parameter, _function_, is the function which raised the
   exception; it depends on the platform and implementation.  The
   second parameter, _path_, will be the path name passed to
   _function_.  The third parameter, _excinfo_, will be the exception
   information returned by "sys.exc_info()".  Exceptions raised by
   _onerror_ will not be caught.

   Raises an auditing event "shutil.rmtree" with argument "path".

   Changed in version 3.3: Added a symlink attack resistant version
   that is used automatically if platform supports fd-based functions.

   Changed in version 3.8: On Windows, will no longer delete the
   contents of a directory junction before removing the junction.

   rmtree.avoids_symlink_attacks

      Indicates whether the current platform and implementation
      provides a symlink attack resistant version of "rmtree()".
      Currently this is only true for platforms supporting fd-based
      directory access functions.

      New in version 3.3.

shutil.move(src, dst, copy_function=copy2)

   Recursively move a file or directory (_src_) to another location
   (_dst_) and return the destination.

   If the destination is an existing directory, then _src_ is moved
   inside that directory. If the destination already exists but is not
   a directory, it may be overwritten depending on "os.rename()"
   semantics.

   If the destination is on the current filesystem, then "os.rename()"
   is used. Otherwise, _src_ is copied to _dst_ using _copy_function_
   and then removed.  In case of symlinks, a new symlink pointing to
   the target of _src_ will be created in or as _dst_ and _src_ will
   be removed.

   If _copy_function_ is given, it must be a callable that takes two
   arguments _src_ and _dst_, and will be used to copy _src_ to _dst_
   if "os.rename()" cannot be used.  If the source is a directory,
   "copytree()" is called, passing it the "copy_function()". The
   default _copy_function_ is "copy2()".  Using "copy()" as the
   _copy_function_ allows the move to succeed when it is not possible
   to also copy the metadata, at the expense of not copying any of the
   metadata.

   Raises an auditing event "shutil.move" with arguments "src", "dst".

   Changed in version 3.3: Added explicit symlink handling for foreign
   filesystems, thus adapting it to the behavior of GNU’s **mv**. Now
   returns _dst_.

   Changed in version 3.5: Added the _copy_function_ keyword argument.

   Changed in version 3.8: Platform-specific fast-copy syscalls may be
   used internally in order to copy the file more efficiently. See
   Platform-dependent efficient copy operations section.

   Changed in version 3.9: Accepts a _path-like object_ for both _src_
   and _dst_.

shutil.disk_usage(path)

   Return disk usage statistics about the given path as a _named
   tuple_ with the attributes _total_, _used_ and _free_, which are
   the amount of total, used and free space, in bytes. _path_ may be a
   file or a directory.

   New in version 3.3.

   Changed in version 3.8: On Windows, _path_ can now be a file or
   directory.

   Availability: Unix, Windows.

shutil.chown(path, user=None, group=None)

   Change owner _user_ and/or _group_ of the given _path_.

   _user_ can be a system user name or a uid; the same applies to
   _group_. At least one argument is required.

   See also "os.chown()", the underlying function.

   Raises an auditing event "shutil.chown" with arguments "path",
   "user", "group".

   Availability: Unix.

   New in version 3.3.

shutil.which(cmd, mode=os.F_OK | os.X_OK, path=None)

   Return the path to an executable which would be run if the given
   _cmd_ was called.  If no _cmd_ would be called, return "None".

   _mode_ is a permission mask passed to "os.access()", by default
   determining if the file exists and executable.

   When no _path_ is specified, the results of "os.environ()" are
   used, returning either the “PATH” value or a fallback of
   "os.defpath".

   On Windows, the current directory is always prepended to the _path_
   whether or not you use the default or provide your own, which is
   the behavior the command shell uses when finding executables.
   Additionally, when finding the _cmd_ in the _path_, the "PATHEXT"
   environment variable is checked.  For example, if you call
   "shutil.which("python")", "which()" will search "PATHEXT" to know
   that it should look for "python.exe" within the _path_ directories.
   For example, on Windows:
>
      >>> shutil.which("python")
      'C:\\Python33\\python.EXE'
<
   New in version 3.3.

   Changed in version 3.8: The "bytes" type is now accepted.  If _cmd_
   type is "bytes", the result type is also "bytes".

exception shutil.Error

   This exception collects exceptions that are raised during a multi-
   file operation. For "copytree()", the exception argument is a list
   of 3-tuples (_srcname_, _dstname_, _exception_).


Platform-dependent efficient copy operations
--------------------------------------------

Starting from Python 3.8, all functions involving a file copy
("copyfile()", "copy()", "copy2()", "copytree()", and "move()") may
use platform-specific “fast-copy” syscalls in order to copy the file
more efficiently (see bpo-33671). “fast-copy” means that the copying
operation occurs within the kernel, avoiding the use of userspace
buffers in Python as in “"outfd.write(infd.read())"”.

On macOS fcopyfile is used to copy the file content (not metadata).

On Linux "os.sendfile()" is used.

On Windows "shutil.copyfile()" uses a bigger default buffer size (1
MiB instead of 64 KiB) and a "memoryview()"-based variant of
"shutil.copyfileobj()" is used.

If the fast-copy operation fails and no data was written in the
destination file then shutil will silently fallback on using less
efficient "copyfileobj()" function internally.

Changed in version 3.8.


copytree example
----------------

An example that uses the "ignore_patterns()" helper:
>
   from shutil import copytree, ignore_patterns

   copytree(source, destination, ignore=ignore_patterns('*.pyc', 'tmp*'))
<
This will copy everything except ".pyc" files and files or directories
whose name starts with "tmp".

Another example that uses the _ignore_ argument to add a logging call:
>
   from shutil import copytree
   import logging

   def _logpath(path, names):
       logging.info('Working in %s', path)
       return []   # nothing will be ignored

   copytree(source, destination, ignore=_logpath)
<

rmtree example
--------------

This example shows how to remove a directory tree on Windows where
some of the files have their read-only bit set. It uses the onerror
callback to clear the readonly bit and reattempt the remove. Any
subsequent failure will propagate.
>
   import os, stat
   import shutil

   def remove_readonly(func, path, _):
       "Clear the readonly bit and reattempt the removal"
       os.chmod(path, stat.S_IWRITE)
       func(path)

   shutil.rmtree(directory, onerror=remove_readonly)
<

Archiving operations
====================

New in version 3.2.

Changed in version 3.5: Added support for the _xztar_ format.

High-level utilities to create and read compressed and archived files
are also provided.  They rely on the "zipfile" and "tarfile" modules.

shutil.make_archive(base_name, format[, root_dir[, base_dir[, verbose[, dry_run[, owner[, group[, logger]]]]]]])

   Create an archive file (such as zip or tar) and return its name.

   _base_name_ is the name of the file to create, including the path,
   minus any format-specific extension. _format_ is the archive
   format: one of “zip” (if the "zlib" module is available), “tar”,
   “gztar” (if the "zlib" module is available), “bztar” (if the "bz2"
   module is available), or “xztar” (if the "lzma" module is
   available).

   _root_dir_ is a directory that will be the root directory of the
   archive, all paths in the archive will be relative to it; for
   example, we typically chdir into _root_dir_ before creating the
   archive.

   _base_dir_ is the directory where we start archiving from; i.e.
   _base_dir_ will be the common prefix of all files and directories
   in the archive.  _base_dir_ must be given relative to _root_dir_.
   See Archiving example with base_dir for how to use _base_dir_ and
   _root_dir_ together.

   _root_dir_ and _base_dir_ both default to the current directory.

   If _dry_run_ is true, no archive is created, but the operations
   that would be executed are logged to _logger_.

   _owner_ and _group_ are used when creating a tar archive. By
   default, uses the current owner and group.

   _logger_ must be an object compatible with **PEP 282**, usually an
   instance of "logging.Logger".

   The _verbose_ argument is unused and deprecated.

   Raises an auditing event "shutil.make_archive" with arguments
   "base_name", "format", "root_dir", "base_dir".

   Note:

     This function is not thread-safe.

   Changed in version 3.8: The modern pax (POSIX.1-2001) format is now
   used instead of the legacy GNU format for archives created with
   "format="tar"".

shutil.get_archive_formats()

   Return a list of supported formats for archiving. Each element of
   the returned sequence is a tuple "(name, description)".

   By default "shutil" provides these formats:

   * _zip_: ZIP file (if the "zlib" module is available).

   * _tar_: Uncompressed tar file. Uses POSIX.1-2001 pax format for
     new archives.

   * _gztar_: gzip’ed tar-file (if the "zlib" module is available).

   * _bztar_: bzip2’ed tar-file (if the "bz2" module is available).

   * _xztar_: xz’ed tar-file (if the "lzma" module is available).

   You can register new formats or provide your own archiver for any
   existing formats, by using "register_archive_format()".

shutil.register_archive_format(name, function[, extra_args[, description]])

   Register an archiver for the format _name_.

   _function_ is the callable that will be used to unpack archives.
   The callable will receive the _base_name_ of the file to create,
   followed by the _base_dir_ (which defaults to "os.curdir") to start
   archiving from. Further arguments are passed as keyword arguments:
   _owner_, _group_, _dry_run_ and _logger_ (as passed in
   "make_archive()").

   If given, _extra_args_ is a sequence of "(name, value)" pairs that
   will be used as extra keywords arguments when the archiver callable
   is used.

   _description_ is used by "get_archive_formats()" which returns the
   list of archivers.  Defaults to an empty string.

shutil.unregister_archive_format(name)

   Remove the archive format _name_ from the list of supported
   formats.

shutil.unpack_archive(filename[, extract_dir[, format[, filter]]])

   Unpack an archive. _filename_ is the full path of the archive.

   _extract_dir_ is the name of the target directory where the archive
   is unpacked. If not provided, the current working directory is
   used.

   _format_ is the archive format: one of “zip”, “tar”, “gztar”,
   “bztar”, or “xztar”.  Or any other format registered with
   "register_unpack_format()".  If not provided, "unpack_archive()"
   will use the archive file name extension and see if an unpacker was
   registered for that extension.  In case none is found, a
   "ValueError" is raised.

   The keyword-only _filter_ argument, which was added in Python
   3.9.17, is passed to the underlying unpacking function. For zip
   files, _filter_ is not accepted. For tar files, it is recommended
   to set it to "'data'", unless using features specific to tar and
   UNIX-like filesystems. (See Extraction filters for details.) The
   "'data'" filter will become the default for tar files in Python
   3.14.

   Raises an auditing event "shutil.unpack_archive" with arguments
   "filename", "extract_dir", "format".

   Warning:

     Never extract archives from untrusted sources without prior
     inspection. It is possible that files are created outside of the
     path specified in the _extract_dir_ argument, e.g. members that
     have absolute filenames starting with “/” or filenames with two
     dots “..”.

   Changed in version 3.7: Accepts a _path-like object_ for _filename_
   and _extract_dir_.

   Changed in version 3.9.17: Added the _filter_ argument.

shutil.register_unpack_format(name, extensions, function[, extra_args[, description]])

   Registers an unpack format. _name_ is the name of the format and
   _extensions_ is a list of extensions corresponding to the format,
   like ".zip" for Zip files.

   _function_ is the callable that will be used to unpack archives.
   The callable will receive:

   * the path of the archive, as a positional argument;

   * the directory the archive must be extracted to, as a positional
     argument;

   * possibly a _filter_ keyword argument, if it was given to
     "unpack_archive()";

   * additional keyword arguments, specified by _extra_args_ as a
     sequence of "(name, value)" tuples.

   _description_ can be provided to describe the format, and will be
   returned by the "get_unpack_formats()" function.

shutil.unregister_unpack_format(name)

   Unregister an unpack format. _name_ is the name of the format.

shutil.get_unpack_formats()

   Return a list of all registered formats for unpacking. Each element
   of the returned sequence is a tuple "(name, extensions,
   description)".

   By default "shutil" provides these formats:

   * _zip_: ZIP file (unpacking compressed files works only if the
     corresponding module is available).

   * _tar_: uncompressed tar file.

   * _gztar_: gzip’ed tar-file (if the "zlib" module is available).

   * _bztar_: bzip2’ed tar-file (if the "bz2" module is available).

   * _xztar_: xz’ed tar-file (if the "lzma" module is available).

   You can register new formats or provide your own unpacker for any
   existing formats, by using "register_unpack_format()".


Archiving example
-----------------

In this example, we create a gzip’ed tar-file archive containing all
files found in the ".ssh" directory of the user:
>
   >>> from shutil import make_archive
   >>> import os
   >>> archive_name = os.path.expanduser(os.path.join('~', 'myarchive'))
   >>> root_dir = os.path.expanduser(os.path.join('~', '.ssh'))
   >>> make_archive(archive_name, 'gztar', root_dir)
   '/Users/tarek/myarchive.tar.gz'
<
The resulting archive contains:
>
   $ tar -tzvf /Users/tarek/myarchive.tar.gz
   drwx------ tarek/staff       0 2010-02-01 16:23:40 ./
   -rw-r--r-- tarek/staff     609 2008-06-09 13:26:54 ./authorized_keys
   -rwxr-xr-x tarek/staff      65 2008-06-09 13:26:54 ./config
   -rwx------ tarek/staff     668 2008-06-09 13:26:54 ./id_dsa
   -rwxr-xr-x tarek/staff     609 2008-06-09 13:26:54 ./id_dsa.pub
   -rw------- tarek/staff    1675 2008-06-09 13:26:54 ./id_rsa
   -rw-r--r-- tarek/staff     397 2008-06-09 13:26:54 ./id_rsa.pub
   -rw-r--r-- tarek/staff   37192 2010-02-06 18:23:10 ./known_hosts
<

Archiving example with _base_dir_
---------------------------------

In this example, similar to the one above, we show how to use
"make_archive()", but this time with the usage of _base_dir_.  We now
have the following directory structure:
>
   $ tree tmp
   tmp
   └── root
       └── structure
           ├── content
               └── please_add.txt
           └── do_not_add.txt
<
In the final archive, "please_add.txt" should be included, but
"do_not_add.txt" should not.  Therefore we use the following:
>
   >>> from shutil import make_archive
   >>> import os
   >>> archive_name = os.path.expanduser(os.path.join('~', 'myarchive'))
   >>> make_archive(
   ...     archive_name,
   ...     'tar',
   ...     root_dir='tmp/root',
   ...     base_dir='structure/content',
   ... )
   '/Users/tarek/my_archive.tar'
<
Listing the files in the resulting archive gives us:
>
   $ python -m tarfile -l /Users/tarek/myarchive.tar
   structure/content/
   structure/content/please_add.txt
<

Querying the size of the output terminal
========================================

shutil.get_terminal_size(fallback=(columns, lines))

   Get the size of the terminal window.

   For each of the two dimensions, the environment variable, "COLUMNS"
   and "LINES" respectively, is checked. If the variable is defined
   and the value is a positive integer, it is used.

   When "COLUMNS" or "LINES" is not defined, which is the common case,
   the terminal connected to "sys.__stdout__" is queried by invoking
   "os.get_terminal_size()".

   If the terminal size cannot be successfully queried, either because
   the system doesn’t support querying, or because we are not
   connected to a terminal, the value given in "fallback" parameter is
   used. "fallback" defaults to "(80, 24)" which is the default size
   used by many terminal emulators.

   The value returned is a named tuple of type "os.terminal_size".

   See also: The Single UNIX Specification, Version 2, Other
   Environment Variables.

   New in version 3.3.

vim:tw=78:ts=8:ft=help:norl: