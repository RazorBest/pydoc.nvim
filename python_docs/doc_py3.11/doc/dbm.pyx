Python 3.11.9
*dbm.pyx*                                     Last change: 2024 May 24

"dbm" — Interfaces to Unix “databases”
**************************************

**Source code:** Lib/dbm/__init__.py

======================================================================

"dbm" is a generic interface to variants of the DBM database —
"dbm.gnu" or "dbm.ndbm".  If none of these modules is installed, the
slow-but-simple implementation in module "dbm.dumb" will be used.
There is a third party interface to the Oracle Berkeley DB.

exception dbm.error

   A tuple containing the exceptions that can be raised by each of the
   supported modules, with a unique exception also named "dbm.error"
   as the first item — the latter is used when "dbm.error" is raised.

dbm.whichdb(filename)

   This function attempts to guess which of the several simple
   database modules available — "dbm.gnu", "dbm.ndbm" or "dbm.dumb" —
   should be used to open a given file.

   Return one of the following values:

   * "None" if the file can’t be opened because it’s unreadable or
     doesn’t exist

   * the empty string ("''") if the file’s format can’t be guessed

   * a string containing the required module name, such as
     "'dbm.ndbm'" or "'dbm.gnu'"

   Changed in version 3.11: _filename_ accepts a _path-like object_.

dbm.open(file, flag='r', mode=0o666)

   Open a database and return the corresponding database object.

   Parameters:
      * **file** (_path-like object_) –

        The database file to open.

        If the database file already exists, the "whichdb()" function
        is used to determine its type and the appropriate module is
        used; if it does not exist, the first submodule listed above
        that can be imported is used.

      * **flag** (_str_) –

        * "'r'" (default): Open existing database for reading only.

        * "'w'": Open existing database for reading and writing.

        * "'c'": Open database for reading and writing, creating it if
          it doesn’t exist.

        * "'n'": Always create a new, empty database, open for reading
          and writing.

      * **mode** (_int_) – The Unix file access mode of the file
        (default: octal "0o666"), used only when the database has to
        be created.

   Changed in version 3.11: _file_ accepts a _path-like object_.

The object returned by "open()" supports the same basic functionality
as a "dict"; keys and their corresponding values can be stored,
retrieved, and deleted, and the "in" operator and the "keys()" method
are available, as well as "get()" and "setdefault()" methods.

Key and values are always stored as "bytes". This means that when
strings are used they are implicitly converted to the default encoding
before being stored.

These objects also support being used in a "with" statement, which
will automatically close them when done.

Changed in version 3.2: "get()" and "setdefault()" methods are now
available for all "dbm" backends.

Changed in version 3.4: Added native support for the context
management protocol to the objects returned by "open()".

Changed in version 3.8: Deleting a key from a read-only database
raises a database module specific exception instead of "KeyError".

The following example records some hostnames and a corresponding
title,  and then prints out the contents of the database:
>
   import dbm

   # Open database, creating it if necessary.
   with dbm.open('cache', 'c') as db:

       # Record some values
       db[b'hello'] = b'there'
       db['www.python.org'] = 'Python Website'
       db['www.cnn.com'] = 'Cable News Network'

       # Note that the keys are considered bytes now.
       assert db[b'www.python.org'] == b'Python Website'
       # Notice how the value is now in bytes.
       assert db['www.cnn.com'] == b'Cable News Network'

       # Often-used methods of the dict interface work too.
       print(db.get('python.org', b'not present'))

       # Storing a non-string key or value will raise an exception (most
       # likely a TypeError).
       db['www.yahoo.com'] = 4

   # db is automatically closed when leaving the with statement.
<
See also:

  Module "shelve"
     Persistence module which stores non-string data.

The individual submodules are described in the following sections.


"dbm.gnu" — GNU database manager
================================

**Source code:** Lib/dbm/gnu.py

======================================================================

The "dbm.gnu" module provides an interface to the GDBM (GNU dbm)
library, similar to the "dbm.ndbm" module, but with additional
functionality like crash tolerance.

Note:

  The file formats created by "dbm.gnu" and "dbm.ndbm" are
  incompatible and can not be used interchangeably.

exception dbm.gnu.error

   Raised on "dbm.gnu"-specific errors, such as I/O errors. "KeyError"
   is raised for general mapping errors like specifying an incorrect
   key.

dbm.gnu.open(filename, flag='r', mode=0o666, /)

   Open a GDBM database and return a "gdbm" object.

   Parameters:
      * **filename** (_path-like object_) – The database file to open.

      * **flag** (_str_) –

        * "'r'" (default): Open existing database for reading only.

        * "'w'": Open existing database for reading and writing.

        * "'c'": Open database for reading and writing, creating it if
          it doesn’t exist.

        * "'n'": Always create a new, empty database, open for reading
          and writing.

        The following additional characters may be appended to control
        how the database is opened:

        * "'f'": Open the database in fast mode. Writes to the
          database will not be synchronized.

        * "'s'": Synchronized mode. Changes to the database will be
          written immediately to the file.

        * "'u'": Do not lock database.

        Not all flags are valid for all versions of GDBM. See the
        "open_flags" member for a list of supported flag characters.

      * **mode** (_int_) – The Unix file access mode of the file
        (default: octal "0o666"), used only when the database has to
        be created.

   Raises:
      **error** – If an invalid _flag_ argument is passed.

   Changed in version 3.11: _filename_ accepts a _path-like object_.

   dbm.gnu.open_flags

      A string of characters the _flag_ parameter of "open()"
      supports.

   "gdbm" objects behave similar to _mappings_, but "items()" and
   "values()" methods are not supported. The following methods are
   also provided:

   gdbm.firstkey()

      It’s possible to loop over every key in the database using this
      method  and the "nextkey()" method.  The traversal is ordered by
      GDBM’s internal hash values, and won’t be sorted by the key
      values.  This method returns the starting key.

   gdbm.nextkey(key)

      Returns the key that follows _key_ in the traversal.  The
      following code prints every key in the database "db", without
      having to create a list in memory that contains them all:
>
         k = db.firstkey()
         while k is not None:
             print(k)
             k = db.nextkey(k)
<
   gdbm.reorganize()

      If you have carried out a lot of deletions and would like to
      shrink the space used by the GDBM file, this routine will
      reorganize the database.  "gdbm" objects will not shorten the
      length of a database file except by using this reorganization;
      otherwise, deleted file space will be kept and reused as new
      (key, value) pairs are added.

   gdbm.sync()

      When the database has been opened in fast mode, this method
      forces any unwritten data to be written to the disk.

   gdbm.close()

      Close the GDBM database.


"dbm.ndbm" — New Database Manager
=================================

**Source code:** Lib/dbm/ndbm.py

======================================================================

The "dbm.ndbm" module provides an interface to the NDBM (New Database
Manager) library. This module can be used with the “classic” NDBM
interface or the GDBM (GNU dbm) compatibility interface.

Note:

  The file formats created by "dbm.gnu" and "dbm.ndbm" are
  incompatible and can not be used interchangeably.

Warning:

  The NDBM library shipped as part of macOS has an undocumented
  limitation on the size of values, which can result in corrupted
  database files when storing values larger than this limit. Reading
  such corrupted files can result in a hard crash (segmentation
  fault).

exception dbm.ndbm.error

   Raised on "dbm.ndbm"-specific errors, such as I/O errors.
   "KeyError" is raised for general mapping errors like specifying an
   incorrect key.

dbm.ndbm.library

   Name of the NDBM implementation library used.

dbm.ndbm.open(filename, flag='r', mode=0o666, /)

   Open an NDBM database and return an "ndbm" object.

   Parameters:
      * **filename** (_path-like object_) – The basename of the
        database file (without the ".dir" or ".pag" extensions).

      * **flag** (_str_) –

        * "'r'" (default): Open existing database for reading only.

        * "'w'": Open existing database for reading and writing.

        * "'c'": Open database for reading and writing, creating it if
          it doesn’t exist.

        * "'n'": Always create a new, empty database, open for reading
          and writing.

      * **mode** (_int_) – The Unix file access mode of the file
        (default: octal "0o666"), used only when the database has to
        be created.

   "ndbm" objects behave similar to _mappings_, but "items()" and
   "values()" methods are not supported. The following methods are
   also provided:

   Changed in version 3.11: Accepts _path-like object_ for filename.

   ndbm.close()

      Close the NDBM database.


"dbm.dumb" — Portable DBM implementation
========================================

**Source code:** Lib/dbm/dumb.py

Note:

  The "dbm.dumb" module is intended as a last resort fallback for the
  "dbm" module when a more robust module is not available. The
  "dbm.dumb" module is not written for speed and is not nearly as
  heavily used as the other database modules.

======================================================================

The "dbm.dumb" module provides a persistent "dict"-like interface
which is written entirely in Python. Unlike other "dbm" backends, such
as "dbm.gnu", no external library is required.

The "dbm.dumb" module defines the following:

exception dbm.dumb.error

   Raised on "dbm.dumb"-specific errors, such as I/O errors.
   "KeyError" is raised for general mapping errors like specifying an
   incorrect key.

dbm.dumb.open(filename, flag='c', mode=0o666)

   Open a "dbm.dumb" database. The returned database object behaves
   similar to a _mapping_, in addition to providing "sync()" and
   "close()" methods.

   Parameters:
      * **filename** –

        The basename of the database file (without extensions). A new
        database creates the following files:

        * "_filename_.dat"

        * "_filename_.dir"

      * **flag** (_str_) –

        * "'r'": Open existing database for reading only.

        * "'w'": Open existing database for reading and writing.

        * "'c'" (default): Open database for reading and writing,
          creating it if it doesn’t exist.

        * "'n'": Always create a new, empty database, open for reading
          and writing.

      * **mode** (_int_) – The Unix file access mode of the file
        (default: octal "0o666"), used only when the database has to
        be created.

   Warning:

     It is possible to crash the Python interpreter when loading a
     database with a sufficiently large/complex entry due to stack
     depth limitations in Python’s AST compiler.

   Changed in version 3.5: "open()" always creates a new database when
   _flag_ is "'n'".

   Changed in version 3.8: A database opened read-only if _flag_ is
   "'r'". A database is not created if it does not exist if _flag_ is
   "'r'" or "'w'".

   Changed in version 3.11: _filename_ accepts a _path-like object_.

   In addition to the methods provided by the
   "collections.abc.MutableMapping" class, the following methods are
   provided:

   dumbdbm.sync()

      Synchronize the on-disk directory and data files.  This method
      is called by the "Shelve.sync()" method.

   dumbdbm.close()

      Close the database.

vim:tw=78:ts=8:ft=help:norl: