Python 3.8.19
*unix.pyx*                                    Last change: 2024 May 24

Unix Specific Services
**********************

The modules described in this chapter provide interfaces to features
that are unique to the Unix operating system, or in some cases to some
or many variants of it.  Here’s an overview:

* "posix" — The most common POSIX system calls

  * Large File Support

  * Notable Module Contents

* "pwd" — The password database

* "spwd" — The shadow password database

* "grp" — The group database

* "crypt" — Function to check Unix passwords

  * Hashing Methods

  * Module Attributes

  * Module Functions

  * Examples

* "termios" — POSIX style tty control

  * Example

* "tty" — Terminal control functions

* "pty" — Pseudo-terminal utilities

  * Example

* "fcntl" — The "fcntl" and "ioctl" system calls

* "pipes" — Interface to shell pipelines

  * Template Objects

* "resource" — Resource usage information

  * Resource Limits

  * Resource Usage

* "nis" — Interface to Sun’s NIS (Yellow Pages)

* "syslog" — Unix syslog library routines

  * Examples

    * Simple example

vim:tw=78:ts=8:ft=help:norl: