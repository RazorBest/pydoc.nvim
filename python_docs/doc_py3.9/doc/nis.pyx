Python 3.9.19
*nis.pyx*                                     Last change: 2024 May 24

"nis" — Interface to Sun’s NIS (Yellow Pages)
*********************************************

Deprecated since version 3.11: The "nis" module is deprecated (see
**PEP 594** for details).

======================================================================

The "nis" module gives a thin wrapper around the NIS library, useful
for central administration of several hosts.

Because NIS exists only on Unix systems, this module is only available
for Unix.

The "nis" module defines the following functions:

nis.match(key, mapname, domain=default_domain)

   Return the match for _key_ in map _mapname_, or raise an error
   ("nis.error") if there is none. Both should be strings, _key_ is
   8-bit clean. Return value is an arbitrary array of bytes (may
   contain "NULL" and other joys).

   Note that _mapname_ is first checked if it is an alias to another
   name.

   The _domain_ argument allows overriding the NIS domain used for the
   lookup. If unspecified, lookup is in the default NIS domain.

nis.cat(mapname, domain=default_domain)

   Return a dictionary mapping _key_ to _value_ such that "match(key,
   mapname)==value". Note that both keys and values of the dictionary
   are arbitrary arrays of bytes.

   Note that _mapname_ is first checked if it is an alias to another
   name.

   The _domain_ argument allows overriding the NIS domain used for the
   lookup. If unspecified, lookup is in the default NIS domain.

nis.maps(domain=default_domain)

   Return a list of all valid maps.

   The _domain_ argument allows overriding the NIS domain used for the
   lookup. If unspecified, lookup is in the default NIS domain.

nis.get_default_domain()

   Return the system default NIS domain.

The "nis" module defines the following exception:

exception nis.error

   An error raised when a NIS function returns an error code.

vim:tw=78:ts=8:ft=help:norl: