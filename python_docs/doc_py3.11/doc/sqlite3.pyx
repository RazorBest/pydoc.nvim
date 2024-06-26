Python 3.11.9
*sqlite3.pyx*                                 Last change: 2024 May 24

"sqlite3" — DB-API 2.0 interface for SQLite databases
*****************************************************

**Source code:** Lib/sqlite3/

SQLite is a C library that provides a lightweight disk-based database
that doesn’t require a separate server process and allows accessing
the database using a nonstandard variant of the SQL query language.
Some applications can use SQLite for internal data storage.  It’s also
possible to prototype an application using SQLite and then port the
code to a larger database such as PostgreSQL or Oracle.

The "sqlite3" module was written by Gerhard Häring.  It provides an
SQL interface compliant with the DB-API 2.0 specification described by
**PEP 249**, and requires SQLite 3.7.15 or newer.

This document includes four main sections:

* Tutorial teaches how to use the "sqlite3" module.

* Reference describes the classes and functions this module defines.

* How-to guides details how to handle specific tasks.

* Explanation provides in-depth background on transaction control.

See also:

  https://www.sqlite.org
     The SQLite web page; the documentation describes the syntax and
     the available data types for the supported SQL dialect.

  https://www.w3schools.com/sql/
     Tutorial, reference and examples for learning SQL syntax.

  **PEP 249** - Database API Specification 2.0
     PEP written by Marc-André Lemburg.


Tutorial
========

In this tutorial, you will create a database of Monty Python movies
using basic "sqlite3" functionality. It assumes a fundamental
understanding of database concepts, including cursors and
transactions.

First, we need to create a new database and open a database connection
to allow "sqlite3" to work with it. Call "sqlite3.connect()" to create
a connection to the database "tutorial.db" in the current working
directory, implicitly creating it if it does not exist:
>
   import sqlite3
   con = sqlite3.connect("tutorial.db")
<
The returned "Connection" object "con" represents the connection to
the on-disk database.

In order to execute SQL statements and fetch results from SQL queries,
we will need to use a database cursor. Call "con.cursor()" to create
the "Cursor":
>
   cur = con.cursor()
<
Now that we’ve got a database connection and a cursor, we can create a
database table "movie" with columns for title, release year, and
review score. For simplicity, we can just use column names in the
table declaration – thanks to the flexible typing feature of SQLite,
specifying the data types is optional. Execute the "CREATE TABLE"
statement by calling "cur.execute(...)":
>
   cur.execute("CREATE TABLE movie(title, year, score)")
<
We can verify that the new table has been created by querying the
"sqlite_master" table built-in to SQLite, which should now contain an
entry for the "movie" table definition (see The Schema Table for
details). Execute that query by calling "cur.execute(...)", assign the
result to "res", and call "res.fetchone()" to fetch the resulting row:
>
   >>> res = cur.execute("SELECT name FROM sqlite_master")
   >>> res.fetchone()
   ('movie',)
<
We can see that the table has been created, as the query returns a
"tuple" containing the table’s name. If we query "sqlite_master" for a
non-existent table "spam", "res.fetchone()" will return "None":
>
   >>> res = cur.execute("SELECT name FROM sqlite_master WHERE name='spam'")
   >>> res.fetchone() is None
   True
<
Now, add two rows of data supplied as SQL literals by executing an
"INSERT" statement, once again by calling "cur.execute(...)":
>
   cur.execute("""
       INSERT INTO movie VALUES
           ('Monty Python and the Holy Grail', 1975, 8.2),
           ('And Now for Something Completely Different', 1971, 7.5)
   """)
<
The "INSERT" statement implicitly opens a transaction, which needs to
be committed before changes are saved in the database (see Transaction
control for details). Call "con.commit()" on the connection object to
commit the transaction:
>
   con.commit()
<
We can verify that the data was inserted correctly by executing a
"SELECT" query. Use the now-familiar "cur.execute(...)" to assign the
result to "res", and call "res.fetchall()" to return all resulting
rows:
>
   >>> res = cur.execute("SELECT score FROM movie")
   >>> res.fetchall()
   [(8.2,), (7.5,)]
<
The result is a "list" of two "tuple"s, one per row, each containing
that row’s "score" value.

Now, insert three more rows by calling "cur.executemany(...)":
>
   data = [
       ("Monty Python Live at the Hollywood Bowl", 1982, 7.9),
       ("Monty Python's The Meaning of Life", 1983, 7.5),
       ("Monty Python's Life of Brian", 1979, 8.0),
   ]
   cur.executemany("INSERT INTO movie VALUES(?, ?, ?)", data)
   con.commit()  # Remember to commit the transaction after executing INSERT.
<
Notice that "?" placeholders are used to bind "data" to the query.
Always use placeholders instead of string formatting to bind Python
values to SQL statements, to avoid SQL injection attacks (see How to
use placeholders to bind values in SQL queries for more details).

We can verify that the new rows were inserted by executing a "SELECT"
query, this time iterating over the results of the query:
>
   >>> for row in cur.execute("SELECT year, title FROM movie ORDER BY year"):
   ...     print(row)
   (1971, 'And Now for Something Completely Different')
   (1975, 'Monty Python and the Holy Grail')
   (1979, "Monty Python's Life of Brian")
   (1982, 'Monty Python Live at the Hollywood Bowl')
   (1983, "Monty Python's The Meaning of Life")
<
Each row is a two-item "tuple" of "(year, title)", matching the
columns selected in the query.

Finally, verify that the database has been written to disk by calling
"con.close()" to close the existing connection, opening a new one,
creating a new cursor, then querying the database:
>
   >>> con.close()
   >>> new_con = sqlite3.connect("tutorial.db")
   >>> new_cur = new_con.cursor()
   >>> res = new_cur.execute("SELECT title, year FROM movie ORDER BY score DESC")
   >>> title, year = res.fetchone()
   >>> print(f'The highest scoring Monty Python movie is {title!r}, released in {year}')
   The highest scoring Monty Python movie is 'Monty Python and the Holy Grail', released in 1975
<
You’ve now created an SQLite database using the "sqlite3" module,
inserted data and retrieved values from it in multiple ways.

See also:

  * How-to guides for further reading:

    * How to use placeholders to bind values in SQL queries

    * How to adapt custom Python types to SQLite values

    * How to convert SQLite values to custom Python types

    * How to use the connection context manager

    * How to create and use row factories

  * Explanation for in-depth background on transaction control.


Reference
=========


Module functions
----------------

sqlite3.connect(database, timeout=5.0, detect_types=0, isolation_level='DEFERRED', check_same_thread=True, factory=sqlite3.Connection, cached_statements=128, uri=False)

   Open a connection to an SQLite database.

   Parameters:
      * **database** (_path-like object_) – The path to the database
        file to be opened. You can pass "":memory:"" to create an
        SQLite database existing only in memory, and open a connection
        to it.

      * **timeout** (_float_) – How many seconds the connection should
        wait before raising an "OperationalError" when a table is
        locked. If another connection opens a transaction to modify a
        table, that table will be locked until the transaction is
        committed. Default five seconds.

      * **detect_types** (_int_) – Control whether and how data types
        not natively supported by SQLite are looked up to be converted
        to Python types, using the converters registered with
        "register_converter()". Set it to any combination (using "|",
        bitwise or) of "PARSE_DECLTYPES" and "PARSE_COLNAMES" to
        enable this. Column names takes precedence over declared types
        if both flags are set. Types cannot be detected for generated
        fields (for example "max(data)"), even when the _detect_types_
        parameter is set; "str" will be returned instead. By default
        ("0"), type detection is disabled.

      * **isolation_level** (_str__ | __None_) – The "isolation_level"
        of the connection, controlling whether and how transactions
        are implicitly opened. Can be ""DEFERRED"" (default),
        ""EXCLUSIVE"" or ""IMMEDIATE""; or "None" to disable opening
        transactions implicitly. See Transaction control for more.

      * **check_same_thread** (_bool_) – If "True" (default),
        "ProgrammingError" will be raised if the database connection
        is used by a thread other than the one that created it. If
        "False", the connection may be accessed in multiple threads;
        write operations may need to be serialized by the user to
        avoid data corruption. See "threadsafety" for more
        information.

      * **factory** (_Connection_) – A custom subclass of "Connection"
        to create the connection with, if not the default "Connection"
        class.

      * **cached_statements** (_int_) – The number of statements that
        "sqlite3" should internally cache for this connection, to
        avoid parsing overhead. By default, 128 statements.

      * **uri** (_bool_) – If set to "True", _database_ is interpreted
        as a URI (Uniform Resource Identifier) with a file path and an
        optional query string. The scheme part _must_ be ""file:"",
        and the path can be relative or absolute. The query string
        allows passing parameters to SQLite, enabling various How to
        work with SQLite URIs.

   Return type:
      _Connection_

   Raises an auditing event "sqlite3.connect" with argument
   "database".

   Raises an auditing event "sqlite3.connect/handle" with argument
   "connection_handle".

   Changed in version 3.4: Added the _uri_ parameter.

   Changed in version 3.7: _database_ can now also be a _path-like
   object_, not only a string.

   Changed in version 3.10: Added the "sqlite3.connect/handle"
   auditing event.

sqlite3.complete_statement(statement)

   Return "True" if the string _statement_ appears to contain one or
   more complete SQL statements. No syntactic verification or parsing
   of any kind is performed, other than checking that there are no
   unclosed string literals and the statement is terminated by a
   semicolon.

   For example:
>
      >>> sqlite3.complete_statement("SELECT foo FROM bar;")
      True
      >>> sqlite3.complete_statement("SELECT foo")
      False
<
   This function may be useful during command-line input to determine
   if the entered text seems to form a complete SQL statement, or if
   additional input is needed before calling "execute()".

sqlite3.enable_callback_tracebacks(flag, /)

   Enable or disable callback tracebacks. By default you will not get
   any tracebacks in user-defined functions, aggregates, converters,
   authorizer callbacks etc. If you want to debug them, you can call
   this function with _flag_ set to "True". Afterwards, you will get
   tracebacks from callbacks on "sys.stderr". Use "False" to disable
   the feature again.

   Register an "unraisable hook handler" for an improved debug
   experience:
>
      >>> sqlite3.enable_callback_tracebacks(True)
      >>> con = sqlite3.connect(":memory:")
      >>> def evil_trace(stmt):
      ...     5/0
      >>> con.set_trace_callback(evil_trace)
      >>> def debug(unraisable):
      ...     print(f"{unraisable.exc_value!r} in callback {unraisable.object.__name__}")
      ...     print(f"Error message: {unraisable.err_msg}")
      >>> import sys
      >>> sys.unraisablehook = debug
      >>> cur = con.execute("SELECT 1")
      ZeroDivisionError('division by zero') in callback evil_trace
      Error message: None
<
sqlite3.register_adapter(type, adapter, /)

   Register an _adapter_ _callable_ to adapt the Python type _type_
   into an SQLite type. The adapter is called with a Python object of
   type _type_ as its sole argument, and must return a value of a type
   that SQLite natively understands.

sqlite3.register_converter(typename, converter, /)

   Register the _converter_ _callable_ to convert SQLite objects of
   type _typename_ into a Python object of a specific type. The
   converter is invoked for all SQLite values of type _typename_; it
   is passed a "bytes" object and should return an object of the
   desired Python type. Consult the parameter _detect_types_ of
   "connect()" for information regarding how type detection works.

   Note: _typename_ and the name of the type in your query are matched
   case-insensitively.


Module constants
----------------

sqlite3.PARSE_COLNAMES

   Pass this flag value to the _detect_types_ parameter of "connect()"
   to look up a converter function by using the type name, parsed from
   the query column name, as the converter dictionary key. The type
   name must be wrapped in square brackets ("[]").
>
      SELECT p as "p [point]" FROM test;  ! will look up converter "point"
<
   This flag may be combined with "PARSE_DECLTYPES" using the "|"
   (bitwise or) operator.

sqlite3.PARSE_DECLTYPES

   Pass this flag value to the _detect_types_ parameter of "connect()"
   to look up a converter function using the declared types for each
   column. The types are declared when the database table is created.
   "sqlite3" will look up a converter function using the first word of
   the declared type as the converter dictionary key. For example:
>
      CREATE TABLE test(
         i integer primary key,  ! will look up a converter named "integer"
         p point,                ! will look up a converter named "point"
         n number(10)            ! will look up a converter named "number"
       )
<
   This flag may be combined with "PARSE_COLNAMES" using the "|"
   (bitwise or) operator.

sqlite3.SQLITE_OK
sqlite3.SQLITE_DENY
sqlite3.SQLITE_IGNORE

   Flags that should be returned by the _authorizer_callback_
   _callable_ passed to "Connection.set_authorizer()", to indicate
   whether:

   * Access is allowed ("SQLITE_OK"),

   * The SQL statement should be aborted with an error ("SQLITE_DENY")

   * The column should be treated as a "NULL" value ("SQLITE_IGNORE")

sqlite3.apilevel

   String constant stating the supported DB-API level. Required by the
   DB-API. Hard-coded to ""2.0"".

sqlite3.paramstyle

   String constant stating the type of parameter marker formatting
   expected by the "sqlite3" module. Required by the DB-API. Hard-
   coded to ""qmark"".

   Note:

     The "named" DB-API parameter style is also supported.

sqlite3.sqlite_version

   Version number of the runtime SQLite library as a "string".

sqlite3.sqlite_version_info

   Version number of the runtime SQLite library as a "tuple" of
   "integers".

sqlite3.threadsafety

   Integer constant required by the DB-API 2.0, stating the level of
   thread safety the "sqlite3" module supports. This attribute is set
   based on the default threading mode the underlying SQLite library
   is compiled with. The SQLite threading modes are:

   1. **Single-thread**: In this mode, all mutexes are disabled and
      SQLite is unsafe to use in more than a single thread at once.

   2. **Multi-thread**: In this mode, SQLite can be safely used by
      multiple threads provided that no single database connection is
      used simultaneously in two or more threads.

   3. **Serialized**: In serialized mode, SQLite can be safely used by
      multiple threads with no restriction.

   The mappings from SQLite threading modes to DB-API 2.0 threadsafety
   levels are as follows:

   +--------------------+-------------------+------------------------+---------------------------------+
   | SQLite threading   | threadsafety      | SQLITE_THREADSAFE      | DB-API 2.0 meaning              |
   | mode               |                   |                        |                                 |
   |====================|===================|========================|=================================|
   | single-thread      | 0                 | 0                      | Threads may not share the       |
   |                    |                   |                        | module                          |
   +--------------------+-------------------+------------------------+---------------------------------+
   | multi-thread       | 1                 | 2                      | Threads may share the module,   |
   |                    |                   |                        | but not connections             |
   +--------------------+-------------------+------------------------+---------------------------------+
   | serialized         | 3                 | 1                      | Threads may share the module,   |
   |                    |                   |                        | connections and cursors         |
   +--------------------+-------------------+------------------------+---------------------------------+

   Changed in version 3.11: Set _threadsafety_ dynamically instead of
   hard-coding it to "1".

sqlite3.version

   Version number of this module as a "string". This is not the
   version of the SQLite library.

sqlite3.version_info

   Version number of this module as a "tuple" of "integers". This is
   not the version of the SQLite library.


Connection objects
------------------

class sqlite3.Connection

   Each open SQLite database is represented by a "Connection" object,
   which is created using "sqlite3.connect()". Their main purpose is
   creating "Cursor" objects, and Transaction control.

   See also:

     * How to use connection shortcut methods

     * How to use the connection context manager

   An SQLite database connection has the following attributes and
   methods:

   cursor(factory=Cursor)

      Create and return a "Cursor" object. The cursor method accepts a
      single optional parameter _factory_. If supplied, this must be a
      _callable_ returning an instance of "Cursor" or its subclasses.

   blobopen(table, column, row, /, *, readonly=False, name='main')

      Open a "Blob" handle to an existing BLOB (Binary Large OBject).

      Parameters:
         * **table** (_str_) – The name of the table where the blob is
           located.

         * **column** (_str_) – The name of the column where the blob
           is located.

         * **row** (_str_) – The name of the row where the blob is
           located.

         * **readonly** (_bool_) – Set to "True" if the blob should be
           opened without write permissions. Defaults to "False".

         * **name** (_str_) – The name of the database where the blob
           is located. Defaults to ""main"".

      Raises:
         **OperationalError** – When trying to open a blob in a
         "WITHOUT ROWID" table.

      Return type:
         Blob

      Note:

        The blob size cannot be changed using the "Blob" class. Use
        the SQL function "zeroblob" to create a blob with a fixed
        size.

      New in version 3.11.

   commit()

      Commit any pending transaction to the database. If there is no
      open transaction, this method is a no-op.

   rollback()

      Roll back to the start of any pending transaction. If there is
      no open transaction, this method is a no-op.

   close()

      Close the database connection. Any pending transaction is not
      committed implicitly; make sure to "commit()" before closing to
      avoid losing pending changes.

   execute(sql, parameters=(), /)

      Create a new "Cursor" object and call "execute()" on it with the
      given _sql_ and _parameters_. Return the new cursor object.

   executemany(sql, parameters, /)

      Create a new "Cursor" object and call "executemany()" on it with
      the given _sql_ and _parameters_. Return the new cursor object.

   executescript(sql_script, /)

      Create a new "Cursor" object and call "executescript()" on it
      with the given _sql_script_. Return the new cursor object.

   create_function(name, narg, func, *, deterministic=False)

      Create or remove a user-defined SQL function.

      Parameters:
         * **name** (_str_) – The name of the SQL function.

         * **narg** (_int_) – The number of arguments the SQL function
           can accept. If "-1", it may take any number of arguments.

         * **func** (_callback_ | None) – A _callable_ that is called
           when the SQL function is invoked. The callable must return
           a type natively supported by SQLite. Set to "None" to
           remove an existing SQL function.

         * **deterministic** (_bool_) – If "True", the created SQL
           function is marked as deterministic, which allows SQLite to
           perform additional optimizations.

      Raises:
         **NotSupportedError** – If _deterministic_ is used with
         SQLite versions older than 3.8.3.

      Changed in version 3.8: Added the _deterministic_ parameter.

      Example:
>
         >>> import hashlib
         >>> def md5sum(t):
         ...     return hashlib.md5(t).hexdigest()
         >>> con = sqlite3.connect(":memory:")
         >>> con.create_function("md5", 1, md5sum)
         >>> for row in con.execute("SELECT md5(?)", (b"foo",)):
         ...     print(row)
         ('acbd18db4cc2f85cedef654fccc4a4d8',)
<
   create_aggregate(name, n_arg, aggregate_class)

      Create or remove a user-defined SQL aggregate function.

      Parameters:
         * **name** (_str_) – The name of the SQL aggregate function.

         * **n_arg** (_int_) – The number of arguments the SQL
           aggregate function can accept. If "-1", it may take any
           number of arguments.

         * **aggregate_class** (_class_ | None) –

           A class must implement the following methods:

           * "step()": Add a row to the aggregate.

           * "finalize()": Return the final result of the aggregate as
             a type natively supported by SQLite.

           The number of arguments that the "step()" method must
           accept is controlled by _n_arg_.

           Set to "None" to remove an existing SQL aggregate function.

      Example:
>
         class MySum:
             def __init__(self):
                 self.count = 0

             def step(self, value):
                 self.count += value

             def finalize(self):
                 return self.count

         con = sqlite3.connect(":memory:")
         con.create_aggregate("mysum", 1, MySum)
         cur = con.execute("CREATE TABLE test(i)")
         cur.execute("INSERT INTO test(i) VALUES(1)")
         cur.execute("INSERT INTO test(i) VALUES(2)")
         cur.execute("SELECT mysum(i) FROM test")
         print(cur.fetchone()[0])

         con.close()
<
   create_window_function(name, num_params, aggregate_class, /)

      Create or remove a user-defined aggregate window function.

      Parameters:
         * **name** (_str_) – The name of the SQL aggregate window
           function to create or remove.

         * **num_params** (_int_) – The number of arguments the SQL
           aggregate window function can accept. If "-1", it may take
           any number of arguments.

         * **aggregate_class** (_class_ | None) –

           A class that must implement the following methods:

           * "step()": Add a row to the current window.

           * "value()": Return the current value of the aggregate.

           * "inverse()": Remove a row from the current window.

           * "finalize()": Return the final result of the aggregate as
             a type natively supported by SQLite.

           The number of arguments that the "step()" and "value()"
           methods must accept is controlled by _num_params_.

           Set to "None" to remove an existing SQL aggregate window
           function.

      Raises:
         **NotSupportedError** – If used with a version of SQLite
         older than 3.25.0, which does not support aggregate window
         functions.

      New in version 3.11.

      Example:
>
         # Example taken from https://www.sqlite.org/windowfunctions.html#udfwinfunc
         class WindowSumInt:
             def __init__(self):
                 self.count = 0

             def step(self, value):
                 """Add a row to the current window."""
                 self.count += value

             def value(self):
                 """Return the current value of the aggregate."""
                 return self.count

             def inverse(self, value):
                 """Remove a row from the current window."""
                 self.count -= value

             def finalize(self):
                 """Return the final value of the aggregate.

                 Any clean-up actions should be placed here.
                 """
                 return self.count


         con = sqlite3.connect(":memory:")
         cur = con.execute("CREATE TABLE test(x, y)")
         values = [
             ("a", 4),
             ("b", 5),
             ("c", 3),
             ("d", 8),
             ("e", 1),
         ]
         cur.executemany("INSERT INTO test VALUES(?, ?)", values)
         con.create_window_function("sumint", 1, WindowSumInt)
         cur.execute("""
             SELECT x, sumint(y) OVER (
                 ORDER BY x ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
             ) AS sum_y
             FROM test ORDER BY x
         """)
         print(cur.fetchall())
<
   create_collation(name, callable, /)

      Create a collation named _name_ using the collating function
      _callable_. _callable_ is passed two "string" arguments, and it
      should return an "integer":

      * "1" if the first is ordered higher than the second

      * "-1" if the first is ordered lower than the second

      * "0" if they are ordered equal

      The following example shows a reverse sorting collation:
>
         def collate_reverse(string1, string2):
             if string1 == string2:
                 return 0
             elif string1 < string2:
                 return 1
             else:
                 return -1

         con = sqlite3.connect(":memory:")
         con.create_collation("reverse", collate_reverse)

         cur = con.execute("CREATE TABLE test(x)")
         cur.executemany("INSERT INTO test(x) VALUES(?)", [("a",), ("b",)])
         cur.execute("SELECT x FROM test ORDER BY x COLLATE reverse")
         for row in cur:
             print(row)
         con.close()
<
      Remove a collation function by setting _callable_ to "None".

      Changed in version 3.11: The collation name can contain any
      Unicode character.  Earlier, only ASCII characters were allowed.

   interrupt()

      Call this method from a different thread to abort any queries
      that might be executing on the connection. Aborted queries will
      raise an "OperationalError".

   set_authorizer(authorizer_callback)

      Register _callable_ _authorizer_callback_ to be invoked for each
      attempt to access a column of a table in the database. The
      callback should return one of "SQLITE_OK", "SQLITE_DENY", or
      "SQLITE_IGNORE" to signal how access to the column should be
      handled by the underlying SQLite library.

      The first argument to the callback signifies what kind of
      operation is to be authorized. The second and third argument
      will be arguments or "None" depending on the first argument. The
      4th argument is the name of the database (“main”, “temp”, etc.)
      if applicable. The 5th argument is the name of the inner-most
      trigger or view that is responsible for the access attempt or
      "None" if this access attempt is directly from input SQL code.

      Please consult the SQLite documentation about the possible
      values for the first argument and the meaning of the second and
      third argument depending on the first one. All necessary
      constants are available in the "sqlite3" module.

      Passing "None" as _authorizer_callback_ will disable the
      authorizer.

      Changed in version 3.11: Added support for disabling the
      authorizer using "None".

   set_progress_handler(progress_handler, n)

      Register _callable_ _progress_handler_ to be invoked for every
      _n_ instructions of the SQLite virtual machine. This is useful
      if you want to get called from SQLite during long-running
      operations, for example to update a GUI.

      If you want to clear any previously installed progress handler,
      call the method with "None" for _progress_handler_.

      Returning a non-zero value from the handler function will
      terminate the currently executing query and cause it to raise an
      "OperationalError" exception.

   set_trace_callback(trace_callback)

      Register _callable_ _trace_callback_ to be invoked for each SQL
      statement that is actually executed by the SQLite backend.

      The only argument passed to the callback is the statement (as
      "str") that is being executed. The return value of the callback
      is ignored. Note that the backend does not only run statements
      passed to the "Cursor.execute()" methods.  Other sources include
      the transaction management of the "sqlite3" module and the
      execution of triggers defined in the current database.

      Passing "None" as _trace_callback_ will disable the trace
      callback.

      Note:

        Exceptions raised in the trace callback are not propagated. As
        a development and debugging aid, use
        "enable_callback_tracebacks()" to enable printing tracebacks
        from exceptions raised in the trace callback.

      New in version 3.3.

   enable_load_extension(enabled, /)

      Enable the SQLite engine to load SQLite extensions from shared
      libraries if _enabled_ is "True"; else, disallow loading SQLite
      extensions. SQLite extensions can define new functions,
      aggregates or whole new virtual table implementations.  One
      well-known extension is the fulltext-search extension
      distributed with SQLite.

      Note:

        The "sqlite3" module is not built with loadable extension
        support by default, because some platforms (notably macOS)
        have SQLite libraries which are compiled without this feature.
        To get loadable extension support, you must pass the "--
        enable-loadable-sqlite-extensions" option to **configure**.

      Raises an auditing event "sqlite3.enable_load_extension" with
      arguments "connection", "enabled".

      New in version 3.2.

      Changed in version 3.10: Added the
      "sqlite3.enable_load_extension" auditing event.
>
         con.enable_load_extension(True)

         # Load the fulltext search extension
         con.execute("select load_extension('./fts3.so')")

         # alternatively you can load the extension using an API call:
         # con.load_extension("./fts3.so")

         # disable extension loading again
         con.enable_load_extension(False)

         # example from SQLite wiki
         con.execute("CREATE VIRTUAL TABLE recipe USING fts3(name, ingredients)")
         con.executescript("""
             INSERT INTO recipe (name, ingredients) VALUES('broccoli stew', 'broccoli peppers cheese tomatoes');
             INSERT INTO recipe (name, ingredients) VALUES('pumpkin stew', 'pumpkin onions garlic celery');
             INSERT INTO recipe (name, ingredients) VALUES('broccoli pie', 'broccoli cheese onions flour');
             INSERT INTO recipe (name, ingredients) VALUES('pumpkin pie', 'pumpkin sugar flour butter');
             """)
         for row in con.execute("SELECT rowid, name, ingredients FROM recipe WHERE name MATCH 'pie'"):
             print(row)

         con.close()
<
   load_extension(path, /)

      Load an SQLite extension from a shared library located at
      _path_. Enable extension loading with "enable_load_extension()"
      before calling this method.

      Raises an auditing event "sqlite3.load_extension" with arguments
      "connection", "path".

      New in version 3.2.

      Changed in version 3.10: Added the "sqlite3.load_extension"
      auditing event.

   iterdump()

      Return an _iterator_ to dump the database as SQL source code.
      Useful when saving an in-memory database for later restoration.
      Similar to the ".dump" command in the **sqlite3** shell.

      Example:
>
         # Convert file example.db to SQL dump file dump.sql
         con = sqlite3.connect('example.db')
         with open('dump.sql', 'w') as f:
             for line in con.iterdump():
                 f.write('%s\n' % line)
         con.close()
<
      See also: How to handle non-UTF-8 text encodings

   backup(target, *, pages=-1, progress=None, name='main', sleep=0.250)

      Create a backup of an SQLite database.

      Works even if the database is being accessed by other clients or
      concurrently by the same connection.

      Parameters:
         * **target** (_Connection_) – The database connection to save
           the backup to.

         * **pages** (_int_) – The number of pages to copy at a time.
           If equal to or less than "0", the entire database is copied
           in a single step. Defaults to "-1".

         * **progress** (_callback_ | None) – If set to a _callable_,
           it is invoked with three integer arguments for every backup
           iteration: the _status_ of the last iteration, the
           _remaining_ number of pages still to be copied, and the
           _total_ number of pages. Defaults to "None".

         * **name** (_str_) – The name of the database to back up.
           Either ""main"" (the default) for the main database,
           ""temp"" for the temporary database, or the name of a
           custom database as attached using the "ATTACH DATABASE" SQL
           statement.

         * **sleep** (_float_) – The number of seconds to sleep
           between successive attempts to back up remaining pages.

      Example 1, copy an existing database into another:
>
         def progress(status, remaining, total):
             print(f'Copied {total-remaining} of {total} pages...')

         src = sqlite3.connect('example.db')
         dst = sqlite3.connect('backup.db')
         with dst:
             src.backup(dst, pages=1, progress=progress)
         dst.close()
         src.close()
<
      Example 2, copy an existing database into a transient copy:
>
         src = sqlite3.connect('example.db')
         dst = sqlite3.connect(':memory:')
         src.backup(dst)
<
      New in version 3.7.

      See also: How to handle non-UTF-8 text encodings

   getlimit(category, /)

      Get a connection runtime limit.

      Parameters:
         **category** (_int_) – The SQLite limit category to be
         queried.

      Return type:
         int

      Raises:
         **ProgrammingError** – If _category_ is not recognised by the
         underlying SQLite library.

      Example, query the maximum length of an SQL statement for
      "Connection" "con" (the default is 1000000000):
>
         >>> con.getlimit(sqlite3.SQLITE_LIMIT_SQL_LENGTH)
         1000000000
<
      New in version 3.11.

   setlimit(category, limit, /)

      Set a connection runtime limit. Attempts to increase a limit
      above its hard upper bound are silently truncated to the hard
      upper bound. Regardless of whether or not the limit was changed,
      the prior value of the limit is returned.

      Parameters:
         * **category** (_int_) – The SQLite limit category to be set.

         * **limit** (_int_) – The value of the new limit. If
           negative, the current limit is unchanged.

      Return type:
         int

      Raises:
         **ProgrammingError** – If _category_ is not recognised by the
         underlying SQLite library.

      Example, limit the number of attached databases to 1 for
      "Connection" "con" (the default limit is 10):
>
         >>> con.setlimit(sqlite3.SQLITE_LIMIT_ATTACHED, 1)
         10
         >>> con.getlimit(sqlite3.SQLITE_LIMIT_ATTACHED)
         1
<
      New in version 3.11.

   serialize(*, name='main')

      Serialize a database into a "bytes" object.  For an ordinary on-
      disk database file, the serialization is just a copy of the disk
      file.  For an in-memory database or a “temp” database, the
      serialization is the same sequence of bytes which would be
      written to disk if that database were backed up to disk.

      Parameters:
         **name** (_str_) – The database name to be serialized.
         Defaults to ""main"".

      Return type:
         bytes

      Note:

        This method is only available if the underlying SQLite library
        has the serialize API.

      New in version 3.11.

   deserialize(data, /, *, name='main')

      Deserialize a "serialized" database into a "Connection". This
      method causes the database connection to disconnect from
      database _name_, and reopen _name_ as an in-memory database
      based on the serialization contained in _data_.

      Parameters:
         * **data** (_bytes_) – A serialized database.

         * **name** (_str_) – The database name to deserialize into.
           Defaults to ""main"".

      Raises:
         * **OperationalError** – If the database connection is
           currently involved in a read transaction or a backup
           operation.

         * **DatabaseError** – If _data_ does not contain a valid
           SQLite database.

         * **OverflowError** – If "len(data)" is larger than "2**63 -
           1".

      Note:

        This method is only available if the underlying SQLite library
        has the deserialize API.

      New in version 3.11.

   in_transaction

      This read-only attribute corresponds to the low-level SQLite
      autocommit mode.

      "True" if a transaction is active (there are uncommitted
      changes), "False" otherwise.

      New in version 3.2.

   isolation_level

      This attribute controls the transaction handling performed by
      "sqlite3". If set to "None", transactions are never implicitly
      opened. If set to one of ""DEFERRED"", ""IMMEDIATE"", or
      ""EXCLUSIVE"", corresponding to the underlying SQLite
      transaction behaviour, implicit transaction management is
      performed.

      If not overridden by the _isolation_level_ parameter of
      "connect()", the default is """", which is an alias for
      ""DEFERRED"".

   row_factory

      The initial "row_factory" for "Cursor" objects created from this
      connection. Assigning to this attribute does not affect the
      "row_factory" of existing cursors belonging to this connection,
      only new ones. Is "None" by default, meaning each row is
      returned as a "tuple".

      See How to create and use row factories for more details.

   text_factory

      A _callable_ that accepts a "bytes" parameter and returns a text
      representation of it. The callable is invoked for SQLite values
      with the "TEXT" data type. By default, this attribute is set to
      "str".

      See How to handle non-UTF-8 text encodings for more details.

   total_changes

      Return the total number of database rows that have been
      modified, inserted, or deleted since the database connection was
      opened.


Cursor objects
--------------

   A "Cursor" object represents a database cursor which is used to
   execute SQL statements, and manage the context of a fetch
   operation. Cursors are created using "Connection.cursor()", or by
   using any of the connection shortcut methods.

   Cursor objects are _iterators_, meaning that if you "execute()" a
   "SELECT" query, you can simply iterate over the cursor to fetch the
   resulting rows:
>
      for row in cur.execute("SELECT t FROM data"):
          print(row)
<
class sqlite3.Cursor

   A "Cursor" instance has the following attributes and methods.

   execute(sql, parameters=(), /)

      Execute a single SQL statement, optionally binding Python values
      using placeholders.

      Parameters:
         * **sql** (_str_) – A single SQL statement.

         * **parameters** ("dict" | _sequence_) – Python values to
           bind to placeholders in _sql_. A "dict" if named
           placeholders are used. A _sequence_ if unnamed placeholders
           are used. See How to use placeholders to bind values in SQL
           queries.

      Raises:
         **ProgrammingError** – If _sql_ contains more than one SQL
         statement.

      If "isolation_level" is not "None", _sql_ is an "INSERT",
      "UPDATE", "DELETE", or "REPLACE" statement, and there is no open
      transaction, a transaction is implicitly opened before executing
      _sql_.

      Use "executescript()" to execute multiple SQL statements.

   executemany(sql, parameters, /)

      For every item in _parameters_, repeatedly execute the
      parameterized DML (Data Manipulation Language) SQL statement
      _sql_.

      Uses the same implicit transaction handling as "execute()".

      Parameters:
         * **sql** (_str_) – A single SQL DML statement.

         * **parameters** (_iterable_) – An _iterable_ of parameters
           to bind with the placeholders in _sql_. See How to use
           placeholders to bind values in SQL queries.

      Raises:
         **ProgrammingError** – If _sql_ contains more than one SQL
         statement, or is not a DML statement.

      Example:
>
         rows = [
             ("row1",),
             ("row2",),
         ]
         # cur is an sqlite3.Cursor object
         cur.executemany("INSERT INTO data VALUES(?)", rows)
<
      Note:

        Any resulting rows are discarded, including DML statements
        with RETURNING clauses.

   executescript(sql_script, /)

      Execute the SQL statements in _sql_script_. If there is a
      pending transaction, an implicit "COMMIT" statement is executed
      first. No other implicit transaction control is performed; any
      transaction control must be added to _sql_script_.

      _sql_script_ must be a "string".

      Example:
>
         # cur is an sqlite3.Cursor object
         cur.executescript("""
             BEGIN;
             CREATE TABLE person(firstname, lastname, age);
             CREATE TABLE book(title, author, published);
             CREATE TABLE publisher(name, address);
             COMMIT;
         """)
<
   fetchone()

      If "row_factory" is "None", return the next row query result set
      as a "tuple". Else, pass it to the row factory and return its
      result. Return "None" if no more data is available.

   fetchmany(size=cursor.arraysize)

      Return the next set of rows of a query result as a "list".
      Return an empty list if no more rows are available.

      The number of rows to fetch per call is specified by the _size_
      parameter. If _size_ is not given, "arraysize" determines the
      number of rows to be fetched. If fewer than _size_ rows are
      available, as many rows as are available are returned.

      Note there are performance considerations involved with the
      _size_ parameter. For optimal performance, it is usually best to
      use the arraysize attribute. If the _size_ parameter is used,
      then it is best for it to retain the same value from one
      "fetchmany()" call to the next.

   fetchall()

      Return all (remaining) rows of a query result as a "list".
      Return an empty list if no rows are available. Note that the
      "arraysize" attribute can affect the performance of this
      operation.

   close()

      Close the cursor now (rather than whenever "__del__" is called).

      The cursor will be unusable from this point forward; a
      "ProgrammingError" exception will be raised if any operation is
      attempted with the cursor.

   setinputsizes(sizes, /)

      Required by the DB-API. Does nothing in "sqlite3".

   setoutputsize(size, column=None, /)

      Required by the DB-API. Does nothing in "sqlite3".

   arraysize

      Read/write attribute that controls the number of rows returned
      by "fetchmany()". The default value is 1 which means a single
      row would be fetched per call.

   connection

      Read-only attribute that provides the SQLite database
      "Connection" belonging to the cursor.  A "Cursor" object created
      by calling "con.cursor()" will have a "connection" attribute
      that refers to _con_:
>
         >>> con = sqlite3.connect(":memory:")
         >>> cur = con.cursor()
         >>> cur.connection == con
         True
<
   description

      Read-only attribute that provides the column names of the last
      query. To remain compatible with the Python DB API, it returns a
      7-tuple for each column where the last six items of each tuple
      are "None".

      It is set for "SELECT" statements without any matching rows as
      well.

   lastrowid

      Read-only attribute that provides the row id of the last
      inserted row. It is only updated after successful "INSERT" or
      "REPLACE" statements using the "execute()" method.  For other
      statements, after "executemany()" or "executescript()", or if
      the insertion failed, the value of "lastrowid" is left
      unchanged.  The initial value of "lastrowid" is "None".

      Note:

        Inserts into "WITHOUT ROWID" tables are not recorded.

      Changed in version 3.6: Added support for the "REPLACE"
      statement.

   rowcount

      Read-only attribute that provides the number of modified rows
      for "INSERT", "UPDATE", "DELETE", and "REPLACE" statements; is
      "-1" for other statements, including CTE (Common Table
      Expression) queries. It is only updated by the "execute()" and
      "executemany()" methods, after the statement has run to
      completion. This means that any resulting rows must be fetched
      in order for "rowcount" to be updated.

   row_factory

      Control how a row fetched from this "Cursor" is represented. If
      "None", a row is represented as a "tuple". Can be set to the
      included "sqlite3.Row"; or a _callable_ that accepts two
      arguments, a "Cursor" object and the "tuple" of row values, and
      returns a custom object representing an SQLite row.

      Defaults to what "Connection.row_factory" was set to when the
      "Cursor" was created. Assigning to this attribute does not
      affect "Connection.row_factory" of the parent connection.

      See How to create and use row factories for more details.


Row objects
-----------

class sqlite3.Row

   A "Row" instance serves as a highly optimized "row_factory" for
   "Connection" objects. It supports iteration, equality testing,
   "len()", and _mapping_ access by column name and index.

   Two "Row" objects compare equal if they have identical column names
   and values.

   See How to create and use row factories for more details.

   keys()

      Return a "list" of column names as "strings". Immediately after
      a query, it is the first member of each tuple in
      "Cursor.description".

   Changed in version 3.5: Added support of slicing.


Blob objects
------------

class sqlite3.Blob

   New in version 3.11.

   A "Blob" instance is a _file-like object_ that can read and write
   data in an SQLite BLOB (Binary Large OBject). Call "len(blob)" to
   get the size (number of bytes) of the blob. Use indices and
   _slices_ for direct access to the blob data.

   Use the "Blob" as a _context manager_ to ensure that the blob
   handle is closed after use.
>
      con = sqlite3.connect(":memory:")
      con.execute("CREATE TABLE test(blob_col blob)")
      con.execute("INSERT INTO test(blob_col) VALUES(zeroblob(13))")

      # Write to our blob, using two write operations:
      with con.blobopen("test", "blob_col", 1) as blob:
          blob.write(b"hello, ")
          blob.write(b"world.")
          # Modify the first and last bytes of our blob
          blob[0] = ord("H")
          blob[-1] = ord("!")

      # Read the contents of our blob
      with con.blobopen("test", "blob_col", 1) as blob:
          greeting = blob.read()

      print(greeting)  # outputs "b'Hello, world!'"
<
   close()

      Close the blob.

      The blob will be unusable from this point onward.  An "Error"
      (or subclass) exception will be raised if any further operation
      is attempted with the blob.

   read(length=-1, /)

      Read _length_ bytes of data from the blob at the current offset
      position. If the end of the blob is reached, the data up to EOF
      (End of File) will be returned.  When _length_ is not specified,
      or is negative, "read()" will read until the end of the blob.

   write(data, /)

      Write _data_ to the blob at the current offset.  This function
      cannot change the blob length.  Writing beyond the end of the
      blob will raise "ValueError".

   tell()

      Return the current access position of the blob.

   seek(offset, origin=os.SEEK_SET, /)

      Set the current access position of the blob to _offset_.  The
      _origin_ argument defaults to "os.SEEK_SET" (absolute blob
      positioning). Other values for _origin_ are "os.SEEK_CUR" (seek
      relative to the current position) and "os.SEEK_END" (seek
      relative to the blob’s end).


PrepareProtocol objects
-----------------------

class sqlite3.PrepareProtocol

   The PrepareProtocol type’s single purpose is to act as a **PEP
   246** style adaption protocol for objects that can adapt themselves
   to native SQLite types.


Exceptions
----------

The exception hierarchy is defined by the DB-API 2.0 (**PEP 249**).

exception sqlite3.Warning

   This exception is not currently raised by the "sqlite3" module, but
   may be raised by applications using "sqlite3", for example if a
   user-defined function truncates data while inserting. "Warning" is
   a subclass of "Exception".

exception sqlite3.Error

   The base class of the other exceptions in this module. Use this to
   catch all errors with one single "except" statement. "Error" is a
   subclass of "Exception".

   If the exception originated from within the SQLite library, the
   following two attributes are added to the exception:

   sqlite_errorcode

      The numeric error code from the SQLite API

      New in version 3.11.

   sqlite_errorname

      The symbolic name of the numeric error code from the SQLite API

      New in version 3.11.

exception sqlite3.InterfaceError

   Exception raised for misuse of the low-level SQLite C API. In other
   words, if this exception is raised, it probably indicates a bug in
   the "sqlite3" module. "InterfaceError" is a subclass of "Error".

exception sqlite3.DatabaseError

   Exception raised for errors that are related to the database. This
   serves as the base exception for several types of database errors.
   It is only raised implicitly through the specialised subclasses.
   "DatabaseError" is a subclass of "Error".

exception sqlite3.DataError

   Exception raised for errors caused by problems with the processed
   data, like numeric values out of range, and strings which are too
   long. "DataError" is a subclass of "DatabaseError".

exception sqlite3.OperationalError

   Exception raised for errors that are related to the database’s
   operation, and not necessarily under the control of the programmer.
   For example, the database path is not found, or a transaction could
   not be processed. "OperationalError" is a subclass of
   "DatabaseError".

exception sqlite3.IntegrityError

   Exception raised when the relational integrity of the database is
   affected, e.g. a foreign key check fails.  It is a subclass of
   "DatabaseError".

exception sqlite3.InternalError

   Exception raised when SQLite encounters an internal error. If this
   is raised, it may indicate that there is a problem with the runtime
   SQLite library. "InternalError" is a subclass of "DatabaseError".

exception sqlite3.ProgrammingError

   Exception raised for "sqlite3" API programming errors, for example
   supplying the wrong number of bindings to a query, or trying to
   operate on a closed "Connection". "ProgrammingError" is a subclass
   of "DatabaseError".

exception sqlite3.NotSupportedError

   Exception raised in case a method or database API is not supported
   by the underlying SQLite library. For example, setting
   _deterministic_ to "True" in "create_function()", if the underlying
   SQLite library does not support deterministic functions.
   "NotSupportedError" is a subclass of "DatabaseError".


SQLite and Python types
-----------------------

SQLite natively supports the following types: "NULL", "INTEGER",
"REAL", "TEXT", "BLOB".

The following Python types can thus be sent to SQLite without any
problem:

+---------------------------------+---------------+
| Python type                     | SQLite type   |
|=================================|===============|
| "None"                          | "NULL"        |
+---------------------------------+---------------+
| "int"                           | "INTEGER"     |
+---------------------------------+---------------+
| "float"                         | "REAL"        |
+---------------------------------+---------------+
| "str"                           | "TEXT"        |
+---------------------------------+---------------+
| "bytes"                         | "BLOB"        |
+---------------------------------+---------------+

This is how SQLite types are converted to Python types by default:

+---------------+------------------------------------------------+
| SQLite type   | Python type                                    |
|===============|================================================|
| "NULL"        | "None"                                         |
+---------------+------------------------------------------------+
| "INTEGER"     | "int"                                          |
+---------------+------------------------------------------------+
| "REAL"        | "float"                                        |
+---------------+------------------------------------------------+
| "TEXT"        | depends on "text_factory", "str" by default    |
+---------------+------------------------------------------------+
| "BLOB"        | "bytes"                                        |
+---------------+------------------------------------------------+

The type system of the "sqlite3" module is extensible in two ways: you
can store additional Python types in an SQLite database via object
adapters, and you can let the "sqlite3" module convert SQLite types to
Python types via converters.


Default adapters and converters
-------------------------------

There are default adapters for the date and datetime types in the
datetime module. They will be sent as ISO dates/ISO timestamps to
SQLite.

The default converters are registered under the name “date” for
"datetime.date" and under the name “timestamp” for
"datetime.datetime".

This way, you can use date/timestamps from Python without any
additional fiddling in most cases. The format of the adapters is also
compatible with the experimental SQLite date/time functions.

The following example demonstrates this.
>
   import sqlite3
   import datetime

   con = sqlite3.connect(":memory:", detect_types=sqlite3.PARSE_DECLTYPES|sqlite3.PARSE_COLNAMES)
   cur = con.cursor()
   cur.execute("create table test(d date, ts timestamp)")

   today = datetime.date.today()
   now = datetime.datetime.now()

   cur.execute("insert into test(d, ts) values (?, ?)", (today, now))
   cur.execute("select d, ts from test")
   row = cur.fetchone()
   print(today, "=>", row[0], type(row[0]))
   print(now, "=>", row[1], type(row[1]))

   cur.execute('select current_date as "d [date]", current_timestamp as "ts [timestamp]"')
   row = cur.fetchone()
   print("current_date", row[0], type(row[0]))
   print("current_timestamp", row[1], type(row[1]))

   con.close()
<
If a timestamp stored in SQLite has a fractional part longer than 6
numbers, its value will be truncated to microsecond precision by the
timestamp converter.

Note:

  The default “timestamp” converter ignores UTC offsets in the
  database and always returns a naive "datetime.datetime" object. To
  preserve UTC offsets in timestamps, either leave converters
  disabled, or register an offset-aware converter with
  "register_converter()".


How-to guides
=============


How to use placeholders to bind values in SQL queries
-----------------------------------------------------

SQL operations usually need to use values from Python variables.
However, beware of using Python’s string operations to assemble
queries, as they are vulnerable to SQL injection attacks. For example,
an attacker can simply close the single quote and inject "OR TRUE" to
select all rows:
>
   >>> # Never do this -- insecure!
   >>> symbol = input()
   ' OR TRUE; --
   >>> sql = "SELECT * FROM stocks WHERE symbol = '%s'" % symbol
   >>> print(sql)
   SELECT * FROM stocks WHERE symbol = '' OR TRUE; --'
   >>> cur.execute(sql)
<
Instead, use the DB-API’s parameter substitution. To insert a variable
into a query string, use a placeholder in the string, and substitute
the actual values into the query by providing them as a "tuple" of
values to the second argument of the cursor’s "execute()" method.

An SQL statement may use one of two kinds of placeholders: question
marks (qmark style) or named placeholders (named style). For the qmark
style, _parameters_ must be a _sequence_ whose length must match the
number of placeholders, or a "ProgrammingError" is raised. For the
named style, _parameters_ should be an instance of a "dict" (or a
subclass), which must contain keys for all named parameters; any extra
items are ignored. Here’s an example of both styles:
>
   con = sqlite3.connect(":memory:")
   cur = con.execute("CREATE TABLE lang(name, first_appeared)")

   # This is the named style used with executemany():
   data = (
       {"name": "C", "year": 1972},
       {"name": "Fortran", "year": 1957},
       {"name": "Python", "year": 1991},
       {"name": "Go", "year": 2009},
   )
   cur.executemany("INSERT INTO lang VALUES(:name, :year)", data)

   # This is the qmark style used in a SELECT query:
   params = (1972,)
   cur.execute("SELECT * FROM lang WHERE first_appeared = ?", params)
   print(cur.fetchall())
<
Note:

  **PEP 249** numeric placeholders are _not_ supported. If used, they
  will be interpreted as named placeholders.


How to adapt custom Python types to SQLite values
-------------------------------------------------

SQLite supports only a limited set of data types natively. To store
custom Python types in SQLite databases, _adapt_ them to one of the
Python types SQLite natively understands.

There are two ways to adapt Python objects to SQLite types: letting
your object adapt itself, or using an _adapter callable_. The latter
will take precedence above the former. For a library that exports a
custom type, it may make sense to enable that type to adapt itself. As
an application developer, it may make more sense to take direct
control by registering custom adapter functions.


How to write adaptable objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Suppose we have a "Point" class that represents a pair of coordinates,
"x" and "y", in a Cartesian coordinate system. The coordinate pair
will be stored as a text string in the database, using a semicolon to
separate the coordinates. This can be implemented by adding a
"__conform__(self, protocol)" method which returns the adapted value.
The object passed to _protocol_ will be of type "PrepareProtocol".
>
   class Point:
       def __init__(self, x, y):
           self.x, self.y = x, y

       def __conform__(self, protocol):
           if protocol is sqlite3.PrepareProtocol:
               return f"{self.x};{self.y}"

   con = sqlite3.connect(":memory:")
   cur = con.cursor()

   cur.execute("SELECT ?", (Point(4.0, -3.2),))
   print(cur.fetchone()[0])
<

How to register adapter callables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The other possibility is to create a function that converts the Python
object to an SQLite-compatible type. This function can then be
registered using "register_adapter()".
>
   class Point:
       def __init__(self, x, y):
           self.x, self.y = x, y

   def adapt_point(point):
       return f"{point.x};{point.y}"

   sqlite3.register_adapter(Point, adapt_point)

   con = sqlite3.connect(":memory:")
   cur = con.cursor()

   cur.execute("SELECT ?", (Point(1.0, 2.5),))
   print(cur.fetchone()[0])
<

How to convert SQLite values to custom Python types
---------------------------------------------------

Writing an adapter lets you convert _from_ custom Python types _to_
SQLite values. To be able to convert _from_ SQLite values _to_ custom
Python types, we use _converters_.

Let’s go back to the "Point" class. We stored the x and y coordinates
separated via semicolons as strings in SQLite.

First, we’ll define a converter function that accepts the string as a
parameter and constructs a "Point" object from it.

Note:

  Converter functions are **always** passed a "bytes" object, no
  matter the underlying SQLite data type.
>
   def convert_point(s):
       x, y = map(float, s.split(b";"))
       return Point(x, y)
<
We now need to tell "sqlite3" when it should convert a given SQLite
value. This is done when connecting to a database, using the
_detect_types_ parameter of "connect()". There are three options:

* Implicit: set _detect_types_ to "PARSE_DECLTYPES"

* Explicit: set _detect_types_ to "PARSE_COLNAMES"

* Both: set _detect_types_ to "sqlite3.PARSE_DECLTYPES |
  sqlite3.PARSE_COLNAMES". Column names take precedence over declared
  types.

The following example illustrates the implicit and explicit
approaches:
>
   class Point:
       def __init__(self, x, y):
           self.x, self.y = x, y

       def __repr__(self):
           return f"Point({self.x}, {self.y})"

   def adapt_point(point):
       return f"{point.x};{point.y}"

   def convert_point(s):
       x, y = list(map(float, s.split(b";")))
       return Point(x, y)

   # Register the adapter and converter
   sqlite3.register_adapter(Point, adapt_point)
   sqlite3.register_converter("point", convert_point)

   # 1) Parse using declared types
   p = Point(4.0, -3.2)
   con = sqlite3.connect(":memory:", detect_types=sqlite3.PARSE_DECLTYPES)
   cur = con.execute("CREATE TABLE test(p point)")

   cur.execute("INSERT INTO test(p) VALUES(?)", (p,))
   cur.execute("SELECT p FROM test")
   print("with declared types:", cur.fetchone()[0])
   cur.close()
   con.close()

   # 2) Parse using column names
   con = sqlite3.connect(":memory:", detect_types=sqlite3.PARSE_COLNAMES)
   cur = con.execute("CREATE TABLE test(p)")

   cur.execute("INSERT INTO test(p) VALUES(?)", (p,))
   cur.execute('SELECT p AS "p [point]" FROM test')
   print("with column names:", cur.fetchone()[0])
<

Adapter and converter recipes
-----------------------------

This section shows recipes for common adapters and converters.
>
   import datetime
   import sqlite3

   def adapt_date_iso(val):
       """Adapt datetime.date to ISO 8601 date."""
       return val.isoformat()

   def adapt_datetime_iso(val):
       """Adapt datetime.datetime to timezone-naive ISO 8601 date."""
       return val.isoformat()

   def adapt_datetime_epoch(val):
       """Adapt datetime.datetime to Unix timestamp."""
       return int(val.timestamp())

   sqlite3.register_adapter(datetime.date, adapt_date_iso)
   sqlite3.register_adapter(datetime.datetime, adapt_datetime_iso)
   sqlite3.register_adapter(datetime.datetime, adapt_datetime_epoch)

   def convert_date(val):
       """Convert ISO 8601 date to datetime.date object."""
       return datetime.date.fromisoformat(val.decode())

   def convert_datetime(val):
       """Convert ISO 8601 datetime to datetime.datetime object."""
       return datetime.datetime.fromisoformat(val.decode())

   def convert_timestamp(val):
       """Convert Unix epoch timestamp to datetime.datetime object."""
       return datetime.datetime.fromtimestamp(int(val))

   sqlite3.register_converter("date", convert_date)
   sqlite3.register_converter("datetime", convert_datetime)
   sqlite3.register_converter("timestamp", convert_timestamp)
<

How to use connection shortcut methods
--------------------------------------

Using the "execute()", "executemany()", and "executescript()" methods
of the "Connection" class, your code can be written more concisely
because you don’t have to create the (often superfluous) "Cursor"
objects explicitly. Instead, the "Cursor" objects are created
implicitly and these shortcut methods return the cursor objects. This
way, you can execute a "SELECT" statement and iterate over it directly
using only a single call on the "Connection" object.
>
   # Create and fill the table.
   con = sqlite3.connect(":memory:")
   con.execute("CREATE TABLE lang(name, first_appeared)")
   data = [
       ("C++", 1985),
       ("Objective-C", 1984),
   ]
   con.executemany("INSERT INTO lang(name, first_appeared) VALUES(?, ?)", data)

   # Print the table contents
   for row in con.execute("SELECT name, first_appeared FROM lang"):
       print(row)

   print("I just deleted", con.execute("DELETE FROM lang").rowcount, "rows")

   # close() is not a shortcut method and it's not called automatically;
   # the connection object should be closed manually
   con.close()
<

How to use the connection context manager
-----------------------------------------

A "Connection" object can be used as a context manager that
automatically commits or rolls back open transactions when leaving the
body of the context manager. If the body of the "with" statement
finishes without exceptions, the transaction is committed. If this
commit fails, or if the body of the "with" statement raises an
uncaught exception, the transaction is rolled back.

If there is no open transaction upon leaving the body of the "with"
statement, the context manager is a no-op.

Note:

  The context manager neither implicitly opens a new transaction nor
  closes the connection. If you need a closing context manager,
  consider using "contextlib.closing()".
>
   con = sqlite3.connect(":memory:")
   con.execute("CREATE TABLE lang(id INTEGER PRIMARY KEY, name VARCHAR UNIQUE)")

   # Successful, con.commit() is called automatically afterwards
   with con:
       con.execute("INSERT INTO lang(name) VALUES(?)", ("Python",))

   # con.rollback() is called after the with block finishes with an exception,
   # the exception is still raised and must be caught
   try:
       with con:
           con.execute("INSERT INTO lang(name) VALUES(?)", ("Python",))
   except sqlite3.IntegrityError:
       print("couldn't add Python twice")

   # Connection object used as context manager only commits or rollbacks transactions,
   # so the connection object should be closed manually
   con.close()
<

How to work with SQLite URIs
----------------------------

Some useful URI tricks include:

* Open a database in read-only mode:
>
   >>> con = sqlite3.connect("file:tutorial.db?mode=ro", uri=True)
   >>> con.execute("CREATE TABLE readonly(data)")
   Traceback (most recent call last):
   OperationalError: attempt to write a readonly database
<
* Do not implicitly create a new database file if it does not already
  exist; will raise "OperationalError" if unable to create a new file:
>
   >>> con = sqlite3.connect("file:nosuchdb.db?mode=rw", uri=True)
   Traceback (most recent call last):
   OperationalError: unable to open database file
<
* Create a shared named in-memory database:
>
   db = "file:mem1?mode=memory&cache=shared"
   con1 = sqlite3.connect(db, uri=True)
   con2 = sqlite3.connect(db, uri=True)
   with con1:
       con1.execute("CREATE TABLE shared(data)")
       con1.execute("INSERT INTO shared VALUES(28)")
   res = con2.execute("SELECT data FROM shared")
   assert res.fetchone() == (28,)
<
More information about this feature, including a list of parameters,
can be found in the SQLite URI documentation.


How to create and use row factories
-----------------------------------

By default, "sqlite3" represents each row as a "tuple". If a "tuple"
does not suit your needs, you can use the "sqlite3.Row" class or a
custom "row_factory".

While "row_factory" exists as an attribute both on the "Cursor" and
the "Connection", it is recommended to set "Connection.row_factory",
so all cursors created from the connection will use the same row
factory.

"Row" provides indexed and case-insensitive named access to columns,
with minimal memory overhead and performance impact over a "tuple". To
use "Row" as a row factory, assign it to the "row_factory" attribute:
>
   >>> con = sqlite3.connect(":memory:")
   >>> con.row_factory = sqlite3.Row
<
Queries now return "Row" objects:
>
   >>> res = con.execute("SELECT 'Earth' AS name, 6378 AS radius")
   >>> row = res.fetchone()
   >>> row.keys()
   ['name', 'radius']
   >>> row[0]         # Access by index.
   'Earth'
   >>> row["name"]    # Access by name.
   'Earth'
   >>> row["RADIUS"]  # Column names are case-insensitive.
   6378
<
Note:

  The "FROM" clause can be omitted in the "SELECT" statement, as in
  the above example. In such cases, SQLite returns a single row with
  columns defined by expressions, e.g. literals, with the given
  aliases "expr AS alias".

You can create a custom "row_factory" that returns each row as a
"dict", with column names mapped to values:
>
   def dict_factory(cursor, row):
       fields = [column[0] for column in cursor.description]
       return {key: value for key, value in zip(fields, row)}
<
Using it, queries now return a "dict" instead of a "tuple":
>
   >>> con = sqlite3.connect(":memory:")
   >>> con.row_factory = dict_factory
   >>> for row in con.execute("SELECT 1 AS a, 2 AS b"):
   ...     print(row)
   {'a': 1, 'b': 2}
<
The following row factory returns a _named tuple_:
>
   from collections import namedtuple

   def namedtuple_factory(cursor, row):
       fields = [column[0] for column in cursor.description]
       cls = namedtuple("Row", fields)
       return cls._make(row)
<
"namedtuple_factory()" can be used as follows:
>
   >>> con = sqlite3.connect(":memory:")
   >>> con.row_factory = namedtuple_factory
   >>> cur = con.execute("SELECT 1 AS a, 2 AS b")
   >>> row = cur.fetchone()
   >>> row
   Row(a=1, b=2)
   >>> row[0]  # Indexed access.
   1
   >>> row.b   # Attribute access.
   2
<
With some adjustments, the above recipe can be adapted to use a
"dataclass", or any other custom class, instead of a "namedtuple".


How to handle non-UTF-8 text encodings
--------------------------------------

By default, "sqlite3" uses "str" to adapt SQLite values with the
"TEXT" data type. This works well for UTF-8 encoded text, but it might
fail for other encodings and invalid UTF-8. You can use a custom
"text_factory" to handle such cases.

Because of SQLite’s flexible typing, it is not uncommon to encounter
table columns with the "TEXT" data type containing non-UTF-8
encodings, or even arbitrary data. To demonstrate, let’s assume we
have a database with ISO-8859-2 (Latin-2) encoded text, for example a
table of Czech-English dictionary entries. Assuming we now have a
"Connection" instance "con" connected to this database, we can decode
the Latin-2 encoded text using this "text_factory":
>
   con.text_factory = lambda data: str(data, encoding="latin2")
<
For invalid UTF-8 or arbitrary data in stored in "TEXT" table columns,
you can use the following technique, borrowed from the Unicode HOWTO:
>
   con.text_factory = lambda data: str(data, errors="surrogateescape")
<
Note:

  The "sqlite3" module API does not support strings containing
  surrogates.

See also: Unicode HOWTO


Explanation
===========


Transaction control
-------------------

The "sqlite3" module does not adhere to the transaction handling
recommended by **PEP 249**.

If the connection attribute "isolation_level" is not "None", new
transactions are implicitly opened before "execute()" and
"executemany()" executes "INSERT", "UPDATE", "DELETE", or "REPLACE"
statements; for other statements, no implicit transaction handling is
performed. Use the "commit()" and "rollback()" methods to respectively
commit and roll back pending transactions. You can choose the
underlying SQLite transaction behaviour — that is, whether and what
type of "BEGIN" statements "sqlite3" implicitly executes – via the
"isolation_level" attribute.

If "isolation_level" is set to "None", no transactions are implicitly
opened at all. This leaves the underlying SQLite library in autocommit
mode, but also allows the user to perform their own transaction
handling using explicit SQL statements. The underlying SQLite library
autocommit mode can be queried using the "in_transaction" attribute.

The "executescript()" method implicitly commits any pending
transaction before execution of the given SQL script, regardless of
the value of "isolation_level".

Changed in version 3.6: "sqlite3" used to implicitly commit an open
transaction before DDL statements.  This is no longer the case.

vim:tw=78:ts=8:ft=help:norl: