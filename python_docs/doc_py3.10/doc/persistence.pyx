Python 3.10.14
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

  * Tutorial

  * Reference

    * Module functions

    * Module constants

    * Connection objects

    * Cursor objects

    * Row objects

    * PrepareProtocol objects

    * Exceptions

    * SQLite and Python types

    * Default adapters and converters

  * How-to guides

    * How to use placeholders to bind values in SQL queries

    * How to adapt custom Python types to SQLite values

      * How to write adaptable objects

      * How to register adapter callables

    * How to convert SQLite values to custom Python types

    * Adapter and converter recipes

    * How to use connection shortcut methods

    * How to use the connection context manager

    * How to work with SQLite URIs

    * How to create and use row factories

  * Explanation

    * Transaction control

vim:tw=78:ts=8:ft=help:norl: