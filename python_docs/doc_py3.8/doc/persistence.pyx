Python 3.8.19
*persistence.pyx*                             Last change: 2024 May 24

Data Persistence
****************

The modules described in this chapter support storing Python data in a
persistent form on disk.  The "pickle" and "marshal" modules can turn
many Python data types into a stream of bytes and then recreate the
objects from the bytes.  The various DBM-related modules support a
family of hash-based file formats that store a mapping of strings to
other strings.

The list of modules described in this chapter is:

* "pickle" — Python object serialization

  * Relationship to other Python modules

    * Comparison with "marshal"

    * Comparison with "json"

  * Data stream format

  * Module Interface

  * What can be pickled and unpickled?

  * Pickling Class Instances

    * Persistence of External Objects

    * Dispatch Tables

    * Handling Stateful Objects

  * Custom Reduction for Types, Functions, and Other Objects

  * Out-of-band Buffers

    * Provider API

    * Consumer API

    * Example

  * Restricting Globals

  * Performance

  * Examples

* "copyreg" — Register "pickle" support functions

  * Example

* "shelve" — Python object persistence

  * Restrictions

  * Example

* "marshal" — Internal Python object serialization

* "dbm" — Interfaces to Unix “databases”

  * "dbm.gnu" — GNU’s reinterpretation of dbm

  * "dbm.ndbm" — Interface based on ndbm

  * "dbm.dumb" — Portable DBM implementation

* "sqlite3" — DB-API 2.0 interface for SQLite databases

  * Module functions and constants

  * Connection Objects

  * Cursor Objects

  * Row Objects

  * Exceptions

  * SQLite and Python types

    * Introduction

    * Using adapters to store additional Python types in SQLite
      databases

      * Letting your object adapt itself

      * Registering an adapter callable

    * Converting SQLite values to custom Python types

    * Default adapters and converters

  * Controlling Transactions

  * Using "sqlite3" efficiently

    * Using shortcut methods

    * Accessing columns by name instead of by index

    * Using the connection as a context manager

vim:tw=78:ts=8:ft=help:norl: