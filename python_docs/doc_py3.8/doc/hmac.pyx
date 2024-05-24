Python 3.8.19
*hmac.pyx*                                    Last change: 2024 May 24

"hmac" — Keyed-Hashing for Message Authentication
*************************************************

**Source code:** Lib/hmac.py

======================================================================

This module implements the HMAC algorithm as described by **RFC
2104**.

hmac.new(key, msg=None, digestmod='')

   Return a new hmac object.  _key_ is a bytes or bytearray object
   giving the secret key.  If _msg_ is present, the method call
   "update(msg)" is made. _digestmod_ is the digest name, digest
   constructor or module for the HMAC object to use.  It may be any
   name suitable to "hashlib.new()". Despite its argument position, it
   is required.

   Changed in version 3.4: Parameter _key_ can be a bytes or bytearray
   object. Parameter _msg_ can be of any type supported by "hashlib".
   Parameter _digestmod_ can be the name of a hash algorithm.

   Deprecated since version 3.4, removed in version 3.8: MD5 as
   implicit default digest for _digestmod_ is deprecated. The
   digestmod parameter is now required.  Pass it as a keyword argument
   to avoid awkwardness when you do not have an initial msg.

hmac.digest(key, msg, digest)

   Return digest of _msg_ for given secret _key_ and _digest_. The
   function is equivalent to "HMAC(key, msg, digest).digest()", but
   uses an optimized C or inline implementation, which is faster for
   messages that fit into memory. The parameters _key_, _msg_, and
   _digest_ have the same meaning as in "new()".

   CPython implementation detail, the optimized C implementation is
   only used when _digest_ is a string and name of a digest algorithm,
   which is supported by OpenSSL.

   New in version 3.7.

An HMAC object has the following methods:

HMAC.update(msg)

   Update the hmac object with _msg_.  Repeated calls are equivalent
   to a single call with the concatenation of all the arguments:
   "m.update(a); m.update(b)" is equivalent to "m.update(a + b)".

   Changed in version 3.4: Parameter _msg_ can be of any type
   supported by "hashlib".

HMAC.digest()

   Return the digest of the bytes passed to the "update()" method so
   far. This bytes object will be the same length as the _digest_size_
   of the digest given to the constructor.  It may contain non-ASCII
   bytes, including NUL bytes.

   Warning:

     When comparing the output of "digest()" to an externally-supplied
     digest during a verification routine, it is recommended to use
     the "compare_digest()" function instead of the "==" operator to
     reduce the vulnerability to timing attacks.

HMAC.hexdigest()

   Like "digest()" except the digest is returned as a string twice the
   length containing only hexadecimal digits.  This may be used to
   exchange the value safely in email or other non-binary
   environments.

   Warning:

     When comparing the output of "hexdigest()" to an externally-
     supplied digest during a verification routine, it is recommended
     to use the "compare_digest()" function instead of the "=="
     operator to reduce the vulnerability to timing attacks.

HMAC.copy()

   Return a copy (“clone”) of the hmac object.  This can be used to
   efficiently compute the digests of strings that share a common
   initial substring.

A hash object has the following attributes:

HMAC.digest_size

   The size of the resulting HMAC digest in bytes.

HMAC.block_size

   The internal block size of the hash algorithm in bytes.

   New in version 3.4.

HMAC.name

   The canonical name of this HMAC, always lowercase, e.g. "hmac-md5".

   New in version 3.4.

This module also provides the following helper function:

hmac.compare_digest(a, b)

   Return "a == b".  This function uses an approach designed to
   prevent timing analysis by avoiding content-based short circuiting
   behaviour, making it appropriate for cryptography.  _a_ and _b_
   must both be of the same type: either "str" (ASCII only, as e.g.
   returned by "HMAC.hexdigest()"), or a _bytes-like object_.

   Note:

     If _a_ and _b_ are of different lengths, or if an error occurs, a
     timing attack could theoretically reveal information about the
     types and lengths of _a_ and _b_—but not their values.

   New in version 3.3.

See also:

  Module "hashlib"
     The Python module providing secure hash functions.

vim:tw=78:ts=8:ft=help:norl: