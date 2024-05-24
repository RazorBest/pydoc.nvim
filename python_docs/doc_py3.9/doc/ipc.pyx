Python 3.9.19
*ipc.pyx*                                     Last change: 2024 May 24

Networking and Interprocess Communication
*****************************************

The modules described in this chapter provide mechanisms for
networking and inter-processes communication.

Some modules only work for two processes that are on the same machine,
e.g. "signal" and "mmap".  Other modules support networking protocols
that two or more processes can use to communicate across machines.

The list of modules described in this chapter is:

* "asyncio" — Asynchronous I/O

* "socket" — Low-level networking interface

* "ssl" — TLS/SSL wrapper for socket objects

* "select" — Waiting for I/O completion

* "selectors" — High-level I/O multiplexing

* "signal" — Set handlers for asynchronous events

* "mmap" — Memory-mapped file support

vim:tw=78:ts=8:ft=help:norl: