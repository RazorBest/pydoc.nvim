Python 3.8.19
*tarfile.pyx*                                 Last change: 2024 May 24

"tarfile" — Read and write tar archive files
********************************************

**Source code:** Lib/tarfile.py

======================================================================

The "tarfile" module makes it possible to read and write tar archives,
including those using gzip, bz2 and lzma compression. Use the
"zipfile" module to read or write ".zip" files, or the higher-level
functions in shutil.

Some facts and figures:

* reads and writes "gzip", "bz2" and "lzma" compressed archives if the
  respective modules are available.

* read/write support for the POSIX.1-1988 (ustar) format.

* read/write support for the GNU tar format including _longname_ and
  _longlink_ extensions, read-only support for all variants of the
  _sparse_ extension including restoration of sparse files.

* read/write support for the POSIX.1-2001 (pax) format.

* handles directories, regular files, hardlinks, symbolic links,
  fifos, character devices and block devices and is able to acquire
  and restore file information like timestamp, access permissions and
  owner.

Changed in version 3.3: Added support for "lzma" compression.

tarfile.open(name=None, mode='r', fileobj=None, bufsize=10240, **kwargs)

   Return a "TarFile" object for the pathname _name_. For detailed
   information on "TarFile" objects and the keyword arguments that are
   allowed, see TarFile Objects.

   _mode_ has to be a string of the form "'filemode[:compression]'",
   it defaults to "'r'". Here is a full list of mode combinations:

   +--------------------+-----------------------------------------------+
   | mode               | action                                        |
   |====================|===============================================|
   | "'r' or 'r:*'"     | Open for reading with transparent compression |
   |                    | (recommended).                                |
   +--------------------+-----------------------------------------------+
   | "'r:'"             | Open for reading exclusively without          |
   |                    | compression.                                  |
   +--------------------+-----------------------------------------------+
   | "'r:gz'"           | Open for reading with gzip compression.       |
   +--------------------+-----------------------------------------------+
   | "'r:bz2'"          | Open for reading with bzip2 compression.      |
   +--------------------+-----------------------------------------------+
   | "'r:xz'"           | Open for reading with lzma compression.       |
   +--------------------+-----------------------------------------------+
   | "'x'" or "'x:'"    | Create a tarfile exclusively without          |
   |                    | compression. Raise an "FileExistsError"       |
   |                    | exception if it already exists.               |
   +--------------------+-----------------------------------------------+
   | "'x:gz'"           | Create a tarfile with gzip compression. Raise |
   |                    | an "FileExistsError" exception if it already  |
   |                    | exists.                                       |
   +--------------------+-----------------------------------------------+
   | "'x:bz2'"          | Create a tarfile with bzip2 compression.      |
   |                    | Raise an "FileExistsError" exception if it    |
   |                    | already exists.                               |
   +--------------------+-----------------------------------------------+
   | "'x:xz'"           | Create a tarfile with lzma compression. Raise |
   |                    | an "FileExistsError" exception if it already  |
   |                    | exists.                                       |
   +--------------------+-----------------------------------------------+
   | "'a' or 'a:'"      | Open for appending with no compression. The   |
   |                    | file is created if it does not exist.         |
   +--------------------+-----------------------------------------------+
   | "'w' or 'w:'"      | Open for uncompressed writing.                |
   +--------------------+-----------------------------------------------+
   | "'w:gz'"           | Open for gzip compressed writing.             |
   +--------------------+-----------------------------------------------+
   | "'w:bz2'"          | Open for bzip2 compressed writing.            |
   +--------------------+-----------------------------------------------+
   | "'w:xz'"           | Open for lzma compressed writing.             |
   +--------------------+-----------------------------------------------+

   Note that "'a:gz'", "'a:bz2'" or "'a:xz'" is not possible. If
   _mode_ is not suitable to open a certain (compressed) file for
   reading, "ReadError" is raised. Use _mode_ "'r'" to avoid this.  If
   a compression method is not supported, "CompressionError" is
   raised.

   If _fileobj_ is specified, it is used as an alternative to a _file
   object_ opened in binary mode for _name_. It is supposed to be at
   position 0.

   For modes "'w:gz'", "'r:gz'", "'w:bz2'", "'r:bz2'", "'x:gz'",
   "'x:bz2'", "tarfile.open()" accepts the keyword argument
   _compresslevel_ (default "9") to specify the compression level of
   the file.

   For special purposes, there is a second format for _mode_:
   "'filemode|[compression]'".  "tarfile.open()" will return a
   "TarFile" object that processes its data as a stream of blocks.  No
   random seeking will be done on the file. If given, _fileobj_ may be
   any object that has a "read()" or "write()" method (depending on
   the _mode_). _bufsize_ specifies the blocksize and defaults to "20
   * 512" bytes. Use this variant in combination with e.g.
   "sys.stdin", a socket _file object_ or a tape device. However, such
   a "TarFile" object is limited in that it does not allow random
   access, see Examples.  The currently possible modes:

   +---------------+----------------------------------------------+
   | Mode          | Action                                       |
   |===============|==============================================|
   | "'r|*'"       | Open a _stream_ of tar blocks for reading    |
   |               | with transparent compression.                |
   +---------------+----------------------------------------------+
   | "'r|'"        | Open a _stream_ of uncompressed tar blocks   |
   |               | for reading.                                 |
   +---------------+----------------------------------------------+
   | "'r|gz'"      | Open a gzip compressed _stream_ for reading. |
   +---------------+----------------------------------------------+
   | "'r|bz2'"     | Open a bzip2 compressed _stream_ for         |
   |               | reading.                                     |
   +---------------+----------------------------------------------+
   | "'r|xz'"      | Open an lzma compressed _stream_ for         |
   |               | reading.                                     |
   +---------------+----------------------------------------------+
   | "'w|'"        | Open an uncompressed _stream_ for writing.   |
   +---------------+----------------------------------------------+
   | "'w|gz'"      | Open a gzip compressed _stream_ for writing. |
   +---------------+----------------------------------------------+
   | "'w|bz2'"     | Open a bzip2 compressed _stream_ for         |
   |               | writing.                                     |
   +---------------+----------------------------------------------+
   | "'w|xz'"      | Open an lzma compressed _stream_ for         |
   |               | writing.                                     |
   +---------------+----------------------------------------------+

   Changed in version 3.5: The "'x'" (exclusive creation) mode was
   added.

   Changed in version 3.6: The _name_ parameter accepts a _path-like
   object_.

class tarfile.TarFile

   Class for reading and writing tar archives. Do not use this class
   directly: use "tarfile.open()" instead. See TarFile Objects.

tarfile.is_tarfile(name)

   Return "True" if _name_ is a tar archive file, that the "tarfile"
   module can read.

The "tarfile" module defines the following exceptions:

exception tarfile.TarError

   Base class for all "tarfile" exceptions.

exception tarfile.ReadError

   Is raised when a tar archive is opened, that either cannot be
   handled by the "tarfile" module or is somehow invalid.

exception tarfile.CompressionError

   Is raised when a compression method is not supported or when the
   data cannot be decoded properly.

exception tarfile.StreamError

   Is raised for the limitations that are typical for stream-like
   "TarFile" objects.

exception tarfile.ExtractError

   Is raised for _non-fatal_ errors when using "TarFile.extract()",
   but only if "TarFile.errorlevel""== 2".

exception tarfile.HeaderError

   Is raised by "TarInfo.frombuf()" if the buffer it gets is invalid.

exception tarfile.FilterError

   Base class for members refused by filters.

   tarinfo

      Information about the member that the filter refused to extract,
      as TarInfo.

exception tarfile.AbsolutePathError

   Raised to refuse extracting a member with an absolute path.

exception tarfile.OutsideDestinationError

   Raised to refuse extracting a member outside the destination
   directory.

exception tarfile.SpecialFileError

   Raised to refuse extracting a special file (e.g. a device or pipe).

exception tarfile.AbsoluteLinkError

   Raised to refuse extracting a symbolic link with an absolute path.

exception tarfile.LinkOutsideDestinationError

   Raised to refuse extracting a symbolic link pointing outside the
   destination directory.

The following constants are available at the module level:

tarfile.ENCODING

   The default character encoding: "'utf-8'" on Windows, the value
   returned by "sys.getfilesystemencoding()" otherwise.

Each of the following constants defines a tar archive format that the
"tarfile" module is able to create. See section Supported tar formats
for details.

tarfile.USTAR_FORMAT

   POSIX.1-1988 (ustar) format.

tarfile.GNU_FORMAT

   GNU tar format.

tarfile.PAX_FORMAT

   POSIX.1-2001 (pax) format.

tarfile.DEFAULT_FORMAT

   The default format for creating archives. This is currently
   "PAX_FORMAT".

   Changed in version 3.8: The default format for new archives was
   changed to "PAX_FORMAT" from "GNU_FORMAT".

See also:

  Module "zipfile"
     Documentation of the "zipfile" standard module.

  Archiving operations
     Documentation of the higher-level archiving facilities provided
     by the standard "shutil" module.

  GNU tar manual, Basic Tar Format
     Documentation for tar archive files, including GNU tar
     extensions.


TarFile Objects
===============

The "TarFile" object provides an interface to a tar archive. A tar
archive is a sequence of blocks. An archive member (a stored file) is
made up of a header block followed by data blocks. It is possible to
store a file in a tar archive several times. Each archive member is
represented by a "TarInfo" object, see TarInfo Objects for details.

A "TarFile" object can be used as a context manager in a "with"
statement. It will automatically be closed when the block is
completed. Please note that in the event of an exception an archive
opened for writing will not be finalized; only the internally used
file object will be closed. See the Examples section for a use case.

New in version 3.2: Added support for the context management protocol.

class tarfile.TarFile(name=None, mode='r', fileobj=None, format=DEFAULT_FORMAT, tarinfo=TarInfo, dereference=False, ignore_zeros=False, encoding=ENCODING, errors='surrogateescape', pax_headers=None, debug=0, errorlevel=1)

   All following arguments are optional and can be accessed as
   instance attributes as well.

   _name_ is the pathname of the archive. _name_ may be a _path-like
   object_. It can be omitted if _fileobj_ is given. In this case, the
   file object’s "name" attribute is used if it exists.

   _mode_ is either "'r'" to read from an existing archive, "'a'" to
   append data to an existing file, "'w'" to create a new file
   overwriting an existing one, or "'x'" to create a new file only if
   it does not already exist.

   If _fileobj_ is given, it is used for reading or writing data. If
   it can be determined, _mode_ is overridden by _fileobj_’s mode.
   _fileobj_ will be used from position 0.

   Note:

     _fileobj_ is not closed, when "TarFile" is closed.

   _format_ controls the archive format for writing. It must be one of
   the constants "USTAR_FORMAT", "GNU_FORMAT" or "PAX_FORMAT" that are
   defined at module level. When reading, format will be automatically
   detected, even if different formats are present in a single
   archive.

   The _tarinfo_ argument can be used to replace the default "TarInfo"
   class with a different one.

   If _dereference_ is "False", add symbolic and hard links to the
   archive. If it is "True", add the content of the target files to
   the archive. This has no effect on systems that do not support
   symbolic links.

   If _ignore_zeros_ is "False", treat an empty block as the end of
   the archive. If it is "True", skip empty (and invalid) blocks and
   try to get as many members as possible. This is only useful for
   reading concatenated or damaged archives.

   _debug_ can be set from "0" (no debug messages) up to "3" (all
   debug messages). The messages are written to "sys.stderr".

   _errorlevel_ controls how extraction errors are handled, see "the
   corresponding attribute".

   The _encoding_ and _errors_ arguments define the character encoding
   to be used for reading or writing the archive and how conversion
   errors are going to be handled. The default settings will work for
   most users. See section Unicode issues for in-depth information.

   The _pax_headers_ argument is an optional dictionary of strings
   which will be added as a pax global header if _format_ is
   "PAX_FORMAT".

   Changed in version 3.2: Use "'surrogateescape'" as the default for
   the _errors_ argument.

   Changed in version 3.5: The "'x'" (exclusive creation) mode was
   added.

   Changed in version 3.6: The _name_ parameter accepts a _path-like
   object_.

classmethod TarFile.open(...)

   Alternative constructor. The "tarfile.open()" function is actually
   a shortcut to this classmethod.

TarFile.getmember(name)

   Return a "TarInfo" object for member _name_. If _name_ can not be
   found in the archive, "KeyError" is raised.

   Note:

     If a member occurs more than once in the archive, its last
     occurrence is assumed to be the most up-to-date version.

TarFile.getmembers()

   Return the members of the archive as a list of "TarInfo" objects.
   The list has the same order as the members in the archive.

TarFile.getnames()

   Return the members as a list of their names. It has the same order
   as the list returned by "getmembers()".

TarFile.list(verbose=True, *, members=None)

   Print a table of contents to "sys.stdout". If _verbose_ is "False",
   only the names of the members are printed. If it is "True", output
   similar to that of **ls -l** is produced. If optional _members_ is
   given, it must be a subset of the list returned by "getmembers()".

   Changed in version 3.5: Added the _members_ parameter.

TarFile.next()

   Return the next member of the archive as a "TarInfo" object, when
   "TarFile" is opened for reading. Return "None" if there is no more
   available.

TarFile.extractall(path=".", members=None, *, numeric_owner=False, filter=None)

   Extract all members from the archive to the current working
   directory or directory _path_. If optional _members_ is given, it
   must be a subset of the list returned by "getmembers()". Directory
   information like owner, modification time and permissions are set
   after all members have been extracted. This is done to work around
   two problems: A directory’s modification time is reset each time a
   file is created in it. And, if a directory’s permissions do not
   allow writing, extracting files to it will fail.

   If _numeric_owner_ is "True", the uid and gid numbers from the
   tarfile are used to set the owner/group for the extracted files.
   Otherwise, the named values from the tarfile are used.

   The _filter_ argument, which was added in Python 3.8.17, specifies
   how "members" are modified or rejected before extraction. See
   Extraction filters for details. It is recommended to set this
   explicitly depending on which _tar_ features you need to support.

   Warning:

     Never extract archives from untrusted sources without prior
     inspection. It is possible that files are created outside of
     _path_, e.g. members that have absolute filenames starting with
     ""/"" or filenames with two dots "".."".Set "filter='data'" to
     prevent the most dangerous security issues, and read the
     Extraction filters section for details.

   Changed in version 3.5: Added the _numeric_owner_ parameter.

   Changed in version 3.6: The _path_ parameter accepts a _path-like
   object_.

   Changed in version 3.8.17: Added the _filter_ parameter.

TarFile.extract(member, path="", set_attrs=True, *, numeric_owner=False, filter=None)

   Extract a member from the archive to the current working directory,
   using its full name. Its file information is extracted as
   accurately as possible. _member_ may be a filename or a "TarInfo"
   object. You can specify a different directory using _path_. _path_
   may be a _path-like object_. File attributes (owner, mtime, mode)
   are set unless _set_attrs_ is false.

   The _numeric_owner_ and _filter_ arguments are the same as for
   "extractall()".

   Note:

     The "extract()" method does not take care of several extraction
     issues. In most cases you should consider using the
     "extractall()" method.

   Warning:

     See the warning for "extractall()".Set "filter='data'" to prevent
     the most dangerous security issues, and read the Extraction
     filters section for details.

   Changed in version 3.2: Added the _set_attrs_ parameter.

   Changed in version 3.5: Added the _numeric_owner_ parameter.

   Changed in version 3.6: The _path_ parameter accepts a _path-like
   object_.

   Changed in version 3.8.17: Added the _filter_ parameter.

TarFile.extractfile(member)

   Extract a member from the archive as a file object. _member_ may be
   a filename or a "TarInfo" object. If _member_ is a regular file or
   a link, an "io.BufferedReader" object is returned. Otherwise,
   "None" is returned.

   Changed in version 3.3: Return an "io.BufferedReader" object.

TarFile.errorlevel: int

   If _errorlevel_ is "0", errors are ignored when using
   "TarFile.extract()" and "TarFile.extractall()". Nevertheless, they
   appear as error messages in the debug output when _debug_ is
   greater than 0. If "1" (the default), all _fatal_ errors are raised
   as "OSError" or "FilterError" exceptions. If "2", all _non-fatal_
   errors are raised as "TarError" exceptions as well.

   Some exceptions, e.g. ones caused by wrong argument types or data
   corruption, are always raised.

   Custom extraction filters should raise "FilterError" for _fatal_
   errors and "ExtractError" for _non-fatal_ ones.

   Note that when an exception is raised, the archive may be partially
   extracted. It is the user’s responsibility to clean up.

TarFile.extraction_filter

   New in version 3.8.17.

   The extraction filter used as a default for the _filter_ argument
   of "extract()" and "extractall()".

   The attribute may be "None" or a callable. String names are not
   allowed for this attribute, unlike the _filter_ argument to
   "extract()".

   If "extraction_filter" is "None" (the default), calling an
   extraction method without a _filter_ argument will use the
   "fully_trusted" filter for compatibility with previous Python
   versions.

   In Python 3.12+, leaving "extraction_filter=None" will emit a
   "DeprecationWarning".

   In Python 3.14+, leaving "extraction_filter=None" will cause
   extraction methods to use the "data" filter by default.

   The attribute may be set on instances or overridden in subclasses.
   It also is possible to set it on the "TarFile" class itself to set
   a global default, although, since it affects all uses of _tarfile_,
   it is best practice to only do so in top-level applications or
   "site configuration". To set a global default this way, a filter
   function needs to be wrapped in "staticmethod()" to prevent
   injection of a "self" argument.

TarFile.add(name, arcname=None, recursive=True, *, filter=None)

   Add the file _name_ to the archive. _name_ may be any type of file
   (directory, fifo, symbolic link, etc.). If given, _arcname_
   specifies an alternative name for the file in the archive.
   Directories are added recursively by default. This can be avoided
   by setting _recursive_ to "False". Recursion adds entries in sorted
   order. If _filter_ is given, it should be a function that takes a
   "TarInfo" object argument and returns the changed "TarInfo" object.
   If it instead returns "None" the "TarInfo" object will be excluded
   from the archive. See Examples for an example.

   Changed in version 3.2: Added the _filter_ parameter.

   Changed in version 3.7: Recursion adds entries in sorted order.

TarFile.addfile(tarinfo, fileobj=None)

   Add the "TarInfo" object _tarinfo_ to the archive. If _fileobj_ is
   given, it should be a _binary file_, and "tarinfo.size" bytes are
   read from it and added to the archive.  You can create "TarInfo"
   objects directly, or by using "gettarinfo()".

TarFile.gettarinfo(name=None, arcname=None, fileobj=None)

   Create a "TarInfo" object from the result of "os.stat()" or
   equivalent on an existing file.  The file is either named by
   _name_, or specified as a _file object_ _fileobj_ with a file
   descriptor. _name_ may be a _path-like object_.  If given,
   _arcname_ specifies an alternative name for the file in the
   archive, otherwise, the name is taken from _fileobj_’s "name"
   attribute, or the _name_ argument.  The name should be a text
   string.

   You can modify some of the "TarInfo"’s attributes before you add it
   using "addfile()". If the file object is not an ordinary file
   object positioned at the beginning of the file, attributes such as
   "size" may need modifying.  This is the case for objects such as
   "GzipFile". The "name" may also be modified, in which case
   _arcname_ could be a dummy string.

   Changed in version 3.6: The _name_ parameter accepts a _path-like
   object_.

TarFile.close()

   Close the "TarFile". In write mode, two finishing zero blocks are
   appended to the archive.

TarFile.pax_headers

   A dictionary containing key-value pairs of pax global headers.


TarInfo Objects
===============

A "TarInfo" object represents one member in a "TarFile". Aside from
storing all required attributes of a file (like file type, size, time,
permissions, owner etc.), it provides some useful methods to determine
its type. It does _not_ contain the file’s data itself.

"TarInfo" objects are returned by "TarFile"’s methods "getmember()",
"getmembers()" and "gettarinfo()".

Modifying the objects returned by "getmember()" or "getmembers()" will
affect all subsequent operations on the archive. For cases where this
is unwanted, you can use "copy.copy()" or call the "replace()" method
to create a modified copy in one step.

Several attributes can be set to "None" to indicate that a piece of
metadata is unused or unknown. Different "TarInfo" methods handle
"None" differently:

* The "extract()" or "extractall()" methods will ignore the
  corresponding metadata, leaving it set to a default.

* "addfile()" will fail.

* "list()" will print a placeholder string.

Changed in version 3.8.17: Added "replace()" and handling of "None".

class tarfile.TarInfo(name="")

   Create a "TarInfo" object.

classmethod TarInfo.frombuf(buf, encoding, errors)

   Create and return a "TarInfo" object from string buffer _buf_.

   Raises "HeaderError" if the buffer is invalid.

classmethod TarInfo.fromtarfile(tarfile)

   Read the next member from the "TarFile" object _tarfile_ and return
   it as a "TarInfo" object.

TarInfo.tobuf(format=DEFAULT_FORMAT, encoding=ENCODING, errors='surrogateescape')

   Create a string buffer from a "TarInfo" object. For information on
   the arguments see the constructor of the "TarFile" class.

   Changed in version 3.2: Use "'surrogateescape'" as the default for
   the _errors_ argument.

A "TarInfo" object has the following public data attributes:

TarInfo.name: str

   Name of the archive member.

TarInfo.size: int

   Size in bytes.

TarInfo.mtime: int | float

   Time of last modification in seconds since the epoch, as in
   "os.stat_result.st_mtime".

   Changed in version 3.8.17: Can be set to "None" for "extract()" and
   "extractall()", causing extraction to skip applying this attribute.

TarInfo.mode: int

   Permission bits, as for "os.chmod()".

   Changed in version 3.8.17: Can be set to "None" for "extract()" and
   "extractall()", causing extraction to skip applying this attribute.

TarInfo.type

   File type.  _type_ is usually one of these constants: "REGTYPE",
   "AREGTYPE", "LNKTYPE", "SYMTYPE", "DIRTYPE", "FIFOTYPE",
   "CONTTYPE", "CHRTYPE", "BLKTYPE", "GNUTYPE_SPARSE".  To determine
   the type of a "TarInfo" object more conveniently, use the "is*()"
   methods below.

TarInfo.linkname: str

   Name of the target file name, which is only present in "TarInfo"
   objects of type "LNKTYPE" and "SYMTYPE".

   For symbolic links ("SYMTYPE"), the _linkname_ is relative to the
   directory that contains the link. For hard links ("LNKTYPE"), the
   _linkname_ is relative to the root of the archive.

TarInfo.uid: int

   User ID of the user who originally stored this member.

   Changed in version 3.8.17: Can be set to "None" for "extract()" and
   "extractall()", causing extraction to skip applying this attribute.

TarInfo.gid: int

   Group ID of the user who originally stored this member.

   Changed in version 3.8.17: Can be set to "None" for "extract()" and
   "extractall()", causing extraction to skip applying this attribute.

TarInfo.uname: str

   User name.

   Changed in version 3.8.17: Can be set to "None" for "extract()" and
   "extractall()", causing extraction to skip applying this attribute.

TarInfo.gname: str

   Group name.

   Changed in version 3.8.17: Can be set to "None" for "extract()" and
   "extractall()", causing extraction to skip applying this attribute.

TarInfo.pax_headers: dict

   A dictionary containing key-value pairs of an associated pax
   extended header.

TarInfo.replace(name=..., mtime=..., mode=..., linkname=...,
uid=..., gid=..., uname=..., gname=...,
deep=True)

   New in version 3.8.17.

   Return a _new_ copy of the "TarInfo" object with the given
   attributes changed. For example, to return a "TarInfo" with the
   group name set to "'staff'", use:
>
      new_tarinfo = old_tarinfo.replace(gname='staff')
<
   By default, a deep copy is made. If _deep_ is false, the copy is
   shallow, i.e. "pax_headers" and any custom attributes are shared
   with the original "TarInfo" object.

A "TarInfo" object also provides some convenient query methods:

TarInfo.isfile()

   Return "True" if the "Tarinfo" object is a regular file.

TarInfo.isreg()

   Same as "isfile()".

TarInfo.isdir()

   Return "True" if it is a directory.

TarInfo.issym()

   Return "True" if it is a symbolic link.

TarInfo.islnk()

   Return "True" if it is a hard link.

TarInfo.ischr()

   Return "True" if it is a character device.

TarInfo.isblk()

   Return "True" if it is a block device.

TarInfo.isfifo()

   Return "True" if it is a FIFO.

TarInfo.isdev()

   Return "True" if it is one of character device, block device or
   FIFO.


Extraction filters
==================

New in version 3.8.17.

The _tar_ format is designed to capture all details of a UNIX-like
filesystem, which makes it very powerful. Unfortunately, the features
make it easy to create tar files that have unintended – and possibly
malicious – effects when extracted. For example, extracting a tar file
can overwrite arbitrary files in various ways (e.g.  by using absolute
paths, ".." path components, or symlinks that affect later members).

In most cases, the full functionality is not needed. Therefore,
_tarfile_ supports extraction filters: a mechanism to limit
functionality, and thus mitigate some of the security issues.

See also:

  **PEP 706**
     Contains further motivation and rationale behind the design.

The _filter_ argument to "TarFile.extract()" or "extractall()" can be:

* the string "'fully_trusted'": Honor all metadata as specified in the
  archive. Should be used if the user trusts the archive completely,
  or implements their own complex verification.

* the string "'tar'": Honor most _tar_-specific features (i.e.
  features of UNIX-like filesystems), but block features that are very
  likely to be surprising or malicious. See "tar_filter()" for
  details.

* the string "'data'": Ignore or block most features specific to UNIX-
  like filesystems. Intended for extracting cross-platform data
  archives. See "data_filter()" for details.

* "None" (default): Use "TarFile.extraction_filter".

  If that is also "None" (the default), the "'fully_trusted'" filter
  will be used (for compatibility with earlier versions of Python).

  In Python 3.12, the default will emit a "DeprecationWarning".

  In Python 3.14, the "'data'" filter will become the default instead.
  It’s possible to switch earlier; see "TarFile.extraction_filter".

* A callable which will be called for each extracted member with a
  TarInfo describing the member and the destination path to where the
  archive is extracted (i.e. the same path is used for all members):
>
     filter(/, member: TarInfo, path: str) -> TarInfo | None
<
  The callable is called just before each member is extracted, so it
  can take the current state of the disk into account. It can:

  * return a "TarInfo" object which will be used instead of the
    metadata in the archive, or

  * return "None", in which case the member will be skipped, or

  * raise an exception to abort the operation or skip the member,
    depending on "errorlevel". Note that when extraction is aborted,
    "extractall()" may leave the archive partially extracted. It does
    not attempt to clean up.


Default named filters
---------------------

The pre-defined, named filters are available as functions, so they can
be reused in custom filters:

tarfile.fully_trusted_filter(/, member, path)

   Return _member_ unchanged.

   This implements the "'fully_trusted'" filter.

tarfile.tar_filter(/, member, path)

   Implements the "'tar'" filter.

   * Strip leading slashes ("/" and "os.sep") from filenames.

   * Refuse to extract files with absolute paths (in case the name is
     absolute even after stripping slashes, e.g. "C:/foo" on Windows).
     This raises "AbsolutePathError".

   * Refuse to extract files whose absolute path (after following
     symlinks) would end up outside the destination. This raises
     "OutsideDestinationError".

   * Clear high mode bits (setuid, setgid, sticky) and group/other
     write bits ("S_IWOTH").

   Return the modified "TarInfo" member.

tarfile.data_filter(/, member, path)

   Implements the "'data'" filter. In addition to what "tar_filter"
   does:

   * Refuse to extract links (hard or soft) that link to absolute
     paths, or ones that link outside the destination.

     This raises "AbsoluteLinkError" or "LinkOutsideDestinationError".

     Note that such files are refused even on platforms that do not
     support symbolic links.

   * Refuse to extract device files (including pipes). This raises
     "SpecialFileError".

   * For regular files, including hard links:

     * Set the owner read and write permissions ("S_IWUSR").

     * Remove the group & other executable permission ("S_IXOTH") if
       the owner doesn’t have it ("S_IXUSR").

   * For other files (directories), set "mode" to "None", so that
     extraction methods skip applying permission bits.

   * Set user and group info ("uid", "gid", "uname", "gname") to
     "None", so that extraction methods skip setting it.

   Return the modified "TarInfo" member.


Filter errors
-------------

When a filter refuses to extract a file, it will raise an appropriate
exception, a subclass of "FilterError". This will abort the extraction
if "TarFile.errorlevel" is 1 or more. With "errorlevel=0" the error
will be logged and the member will be skipped, but extraction will
continue.


Hints for further verification
------------------------------

Even with "filter='data'", _tarfile_ is not suited for extracting
untrusted files without prior inspection. Among other issues, the pre-
defined filters do not prevent denial-of-service attacks. Users should
do additional checks.

Here is an incomplete list of things to consider:

* Extract to a "new temporary directory" to prevent e.g. exploiting
  pre-existing links, and to make it easier to clean up after a failed
  extraction.

* When working with untrusted data, use external (e.g. OS-level)
  limits on disk, memory and CPU usage.

* Check filenames against an allow-list of characters (to filter out
  control characters, confusables, foreign path separators, etc.).

* Check that filenames have expected extensions (discouraging files
  that execute when you “click on them”, or extension-less files like
  Windows special device names).

* Limit the number of extracted files, total size of extracted data,
  filename length (including symlink length), and size of individual
  files.

* Check for files that would be shadowed on case-insensitive
  filesystems.

Also note that:

* Tar files may contain multiple versions of the same file. Later ones
  are expected to overwrite any earlier ones. This feature is crucial
  to allow updating tape archives, but can be abused maliciously.

* _tarfile_ does not protect against issues with “live” data, e.g. an
  attacker tinkering with the destination (or source) directory while
  extraction (or archiving) is in progress.


Supporting older Python versions
--------------------------------

Extraction filters were added to Python 3.12, and are backported to
older versions as security updates. To check whether the feature is
available, use e.g. "hasattr(tarfile, 'data_filter')" rather than
checking the Python version.

The following examples show how to support Python versions with and
without the feature. Note that setting "extraction_filter" will affect
any subsequent operations.

* Fully trusted archive:
>
     my_tarfile.extraction_filter = (lambda member, path: member)
     my_tarfile.extractall()
<
* Use the "'data'" filter if available, but revert to Python 3.11
  behavior ("'fully_trusted'") if this feature is not available:
>
     my_tarfile.extraction_filter = getattr(tarfile, 'data_filter',
                                            (lambda member, path: member))
     my_tarfile.extractall()
<
* Use the "'data'" filter; _fail_ if it is not available:
>
     my_tarfile.extractall(filter=tarfile.data_filter)
<
  or:
>
     my_tarfile.extraction_filter = tarfile.data_filter
     my_tarfile.extractall()
<
* Use the "'data'" filter; _warn_ if it is not available:
>
     if hasattr(tarfile, 'data_filter'):
         my_tarfile.extractall(filter='data')
     else:
         # remove this when no longer needed
         warn_the_user('Extracting may be unsafe; consider updating Python')
         my_tarfile.extractall()
<

Stateful extraction filter example
----------------------------------

While _tarfile_’s extraction methods take a simple _filter_ callable,
custom filters may be more complex objects with an internal state. It
may be useful to write these as context managers, to be used like
this:
>
   with StatefulFilter() as filter_func:
       tar.extractall(path, filter=filter_func)
<
Such a filter can be written as, for example:
>
   class StatefulFilter:
       def __init__(self):
           self.file_count = 0

       def __enter__(self):
           return self

       def __call__(self, member, path):
           self.file_count += 1
           return member

       def __exit__(self, *exc_info):
           print(f'{self.file_count} files extracted')
<

Command-Line Interface
======================

New in version 3.4.

The "tarfile" module provides a simple command-line interface to
interact with tar archives.

If you want to create a new tar archive, specify its name after the
"-c" option and then list the filename(s) that should be included:
>
   $ python -m tarfile -c monty.tar  spam.txt eggs.txt
<
Passing a directory is also acceptable:
>
   $ python -m tarfile -c monty.tar life-of-brian_1979/
<
If you want to extract a tar archive into the current directory, use
the "-e" option:
>
   $ python -m tarfile -e monty.tar
<
You can also extract a tar archive into a different directory by
passing the directory’s name:
>
   $ python -m tarfile -e monty.tar  other-dir/
<
For a list of the files in a tar archive, use the "-l" option:
>
   $ python -m tarfile -l monty.tar
<

Command-line options
--------------------

-l <tarfile>
--list <tarfile>

   List files in a tarfile.

-c <tarfile> <source1> ... <sourceN>
--create <tarfile> <source1> ... <sourceN>

   Create tarfile from source files.

-e <tarfile> [<output_dir>]
--extract <tarfile> [<output_dir>]

   Extract tarfile into the current directory if _output_dir_ is not
   specified.

-t <tarfile>
--test <tarfile>

   Test whether the tarfile is valid or not.

-v, --verbose

   Verbose output.

--filter <filtername>

   Specifies the _filter_ for "--extract". See Extraction filters for
   details. Only string names are accepted (that is, "fully_trusted",
   "tar", and "data").

   New in version 3.8.17.


Examples
========

How to extract an entire tar archive to the current working directory:
>
   import tarfile
   tar = tarfile.open("sample.tar.gz")
   tar.extractall()
   tar.close()
<
How to extract a subset of a tar archive with "TarFile.extractall()"
using a generator function instead of a list:
>
   import os
   import tarfile

   def py_files(members):
       for tarinfo in members:
           if os.path.splitext(tarinfo.name)[1] == ".py":
               yield tarinfo

   tar = tarfile.open("sample.tar.gz")
   tar.extractall(members=py_files(tar))
   tar.close()
<
How to create an uncompressed tar archive from a list of filenames:
>
   import tarfile
   tar = tarfile.open("sample.tar", "w")
   for name in ["foo", "bar", "quux"]:
       tar.add(name)
   tar.close()
<
The same example using the "with" statement:
>
   import tarfile
   with tarfile.open("sample.tar", "w") as tar:
       for name in ["foo", "bar", "quux"]:
           tar.add(name)
<
How to read a gzip compressed tar archive and display some member
information:
>
   import tarfile
   tar = tarfile.open("sample.tar.gz", "r:gz")
   for tarinfo in tar:
       print(tarinfo.name, "is", tarinfo.size, "bytes in size and is ", end="")
       if tarinfo.isreg():
           print("a regular file.")
       elif tarinfo.isdir():
           print("a directory.")
       else:
           print("something else.")
   tar.close()
<
How to create an archive and reset the user information using the
_filter_ parameter in "TarFile.add()":
>
   import tarfile
   def reset(tarinfo):
       tarinfo.uid = tarinfo.gid = 0
       tarinfo.uname = tarinfo.gname = "root"
       return tarinfo
   tar = tarfile.open("sample.tar.gz", "w:gz")
   tar.add("foo", filter=reset)
   tar.close()
<

Supported tar formats
=====================

There are three tar formats that can be created with the "tarfile"
module:

* The POSIX.1-1988 ustar format ("USTAR_FORMAT"). It supports
  filenames up to a length of at best 256 characters and linknames up
  to 100 characters. The maximum file size is 8 GiB. This is an old
  and limited but widely supported format.

* The GNU tar format ("GNU_FORMAT"). It supports long filenames and
  linknames, files bigger than 8 GiB and sparse files. It is the de
  facto standard on GNU/Linux systems. "tarfile" fully supports the
  GNU tar extensions for long names, sparse file support is read-only.

* The POSIX.1-2001 pax format ("PAX_FORMAT"). It is the most flexible
  format with virtually no limits. It supports long filenames and
  linknames, large files and stores pathnames in a portable way.
  Modern tar implementations, including GNU tar, bsdtar/libarchive and
  star, fully support extended _pax_ features; some old or
  unmaintained libraries may not, but should treat _pax_ archives as
  if they were in the universally-supported _ustar_ format. It is the
  current default format for new archives.

  It extends the existing _ustar_ format with extra headers for
  information that cannot be stored otherwise. There are two flavours
  of pax headers: Extended headers only affect the subsequent file
  header, global headers are valid for the complete archive and affect
  all following files. All the data in a pax header is encoded in
  _UTF-8_ for portability reasons.

There are some more variants of the tar format which can be read, but
not created:

* The ancient V7 format. This is the first tar format from Unix
  Seventh Edition, storing only regular files and directories. Names
  must not be longer than 100 characters, there is no user/group name
  information. Some archives have miscalculated header checksums in
  case of fields with non-ASCII characters.

* The SunOS tar extended format. This format is a variant of the
  POSIX.1-2001 pax format, but is not compatible.


Unicode issues
==============

The tar format was originally conceived to make backups on tape drives
with the main focus on preserving file system information. Nowadays
tar archives are commonly used for file distribution and exchanging
archives over networks. One problem of the original format (which is
the basis of all other formats) is that there is no concept of
supporting different character encodings. For example, an ordinary tar
archive created on a _UTF-8_ system cannot be read correctly on a
_Latin-1_ system if it contains non-_ASCII_ characters. Textual
metadata (like filenames, linknames, user/group names) will appear
damaged. Unfortunately, there is no way to autodetect the encoding of
an archive. The pax format was designed to solve this problem. It
stores non-ASCII metadata using the universal character encoding
_UTF-8_.

The details of character conversion in "tarfile" are controlled by the
_encoding_ and _errors_ keyword arguments of the "TarFile" class.

_encoding_ defines the character encoding to use for the metadata in
the archive. The default value is "sys.getfilesystemencoding()" or
"'ascii'" as a fallback. Depending on whether the archive is read or
written, the metadata must be either decoded or encoded. If _encoding_
is not set appropriately, this conversion may fail.

The _errors_ argument defines how characters are treated that cannot
be converted. Possible values are listed in section Error Handlers.
The default scheme is "'surrogateescape'" which Python also uses for
its file system calls, see File Names, Command Line Arguments, and
Environment Variables.

For "PAX_FORMAT" archives (the default), _encoding_ is generally not
needed because all the metadata is stored using _UTF-8_. _encoding_ is
only used in the rare cases when binary pax headers are decoded or
when strings with surrogate characters are stored.

vim:tw=78:ts=8:ft=help:norl: