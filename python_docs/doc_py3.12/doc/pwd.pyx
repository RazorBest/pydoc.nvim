Python 3.12.3
*pwd.pyx*                                     Last change: 2024 May 24

"pwd" — The password database
*****************************

======================================================================

This module provides access to the Unix user account and password
database.  It is available on all Unix versions.

Availability: Unix, not Emscripten, not WASI.

Password database entries are reported as a tuple-like object, whose
attributes correspond to the members of the "passwd" structure
(Attribute field below, see "<pwd.h>"):

+---------+-----------------+-------------------------------+
| Index   | Attribute       | Meaning                       |
|=========|=================|===============================|
| 0       | "pw_name"       | Login name                    |
+---------+-----------------+-------------------------------+
| 1       | "pw_passwd"     | Optional encrypted password   |
+---------+-----------------+-------------------------------+
| 2       | "pw_uid"        | Numerical user ID             |
+---------+-----------------+-------------------------------+
| 3       | "pw_gid"        | Numerical group ID            |
+---------+-----------------+-------------------------------+
| 4       | "pw_gecos"      | User name or comment field    |
+---------+-----------------+-------------------------------+
| 5       | "pw_dir"        | User home directory           |
+---------+-----------------+-------------------------------+
| 6       | "pw_shell"      | User command interpreter      |
+---------+-----------------+-------------------------------+

The uid and gid items are integers, all others are strings. "KeyError"
is raised if the entry asked for cannot be found.

Note:

  In traditional Unix the field "pw_passwd" usually contains a
  password encrypted with a DES derived algorithm (see module
  "crypt").  However most modern unices  use a so-called _shadow
  password_ system.  On those unices the _pw_passwd_ field only
  contains an asterisk ("'*'") or the  letter "'x'" where the
  encrypted password is stored in a file "/etc/shadow" which is not
  world readable.  Whether the _pw_passwd_ field contains anything
  useful is system-dependent.  If available, the "spwd" module should
  be used where access to the encrypted password is required.

It defines the following items:

pwd.getpwuid(uid)

   Return the password database entry for the given numeric user ID.

pwd.getpwnam(name)

   Return the password database entry for the given user name.

pwd.getpwall()

   Return a list of all available password database entries, in
   arbitrary order.

See also:

  Module "grp"
     An interface to the group database, similar to this.

  Module "spwd"
     An interface to the shadow password database, similar to this.

vim:tw=78:ts=8:ft=help:norl: