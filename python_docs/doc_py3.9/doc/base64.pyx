Python 3.9.19
*base64.pyx*                                  Last change: 2024 May 24

"base64" — Base16, Base32, Base64, Base85 Data Encodings
********************************************************

**Source code:** Lib/base64.py

======================================================================

This module provides functions for encoding binary data to printable
ASCII characters and decoding such encodings back to binary data. It
provides encoding and decoding functions for the encodings specified
in **RFC 3548**, which defines the Base16, Base32, and Base64
algorithms, and for the de-facto standard Ascii85 and Base85
encodings.

The **RFC 3548** encodings are suitable for encoding binary data so
that it can safely sent by email, used as parts of URLs, or included
as part of an HTTP POST request.  The encoding algorithm is not the
same as the **uuencode** program.

There are two interfaces provided by this module.  The modern
interface supports encoding _bytes-like objects_ to ASCII "bytes", and
decoding _bytes-like objects_ or strings containing ASCII to "bytes".
Both base-64 alphabets defined in **RFC 3548** (normal, and URL- and
filesystem-safe) are supported.

The legacy interface does not support decoding from strings, but it
does provide functions for encoding and decoding to and from _file
objects_.  It only supports the Base64 standard alphabet, and it adds
newlines every 76 characters as per **RFC 2045**.  Note that if you
are looking for **RFC 2045** support you probably want to be looking
at the "email" package instead.

Changed in version 3.3: ASCII-only Unicode strings are now accepted by
the decoding functions of the modern interface.

Changed in version 3.4: Any _bytes-like objects_ are now accepted by
all encoding and decoding functions in this module.  Ascii85/Base85
support added.

The modern interface provides:

base64.b64encode(s, altchars=None)

   Encode the _bytes-like object_ _s_ using Base64 and return the
   encoded "bytes".

   Optional _altchars_ must be a _bytes-like object_ of at least
   length 2 (additional characters are ignored) which specifies an
   alternative alphabet for the "+" and "/" characters.  This allows
   an application to e.g. generate URL or filesystem safe Base64
   strings.  The default is "None", for which the standard Base64
   alphabet is used.

base64.b64decode(s, altchars=None, validate=False)

   Decode the Base64 encoded _bytes-like object_ or ASCII string _s_
   and return the decoded "bytes".

   Optional _altchars_ must be a _bytes-like object_ or ASCII string
   of at least length 2 (additional characters are ignored) which
   specifies the alternative alphabet used instead of the "+" and "/"
   characters.

   A "binascii.Error" exception is raised if _s_ is incorrectly
   padded.

   If _validate_ is "False" (the default), characters that are neither
   in the normal base-64 alphabet nor the alternative alphabet are
   discarded prior to the padding check.  If _validate_ is "True",
   these non-alphabet characters in the input result in a
   "binascii.Error".

base64.standard_b64encode(s)

   Encode _bytes-like object_ _s_ using the standard Base64 alphabet
   and return the encoded "bytes".

base64.standard_b64decode(s)

   Decode _bytes-like object_ or ASCII string _s_ using the standard
   Base64 alphabet and return the decoded "bytes".

base64.urlsafe_b64encode(s)

   Encode _bytes-like object_ _s_ using the URL- and filesystem-safe
   alphabet, which substitutes "-" instead of "+" and "_" instead of
   "/" in the standard Base64 alphabet, and return the encoded
   "bytes".  The result can still contain "=".

base64.urlsafe_b64decode(s)

   Decode _bytes-like object_ or ASCII string _s_ using the URL- and
   filesystem-safe alphabet, which substitutes "-" instead of "+" and
   "_" instead of "/" in the standard Base64 alphabet, and return the
   decoded "bytes".

base64.b32encode(s)

   Encode the _bytes-like object_ _s_ using Base32 and return the
   encoded "bytes".

base64.b32decode(s, casefold=False, map01=None)

   Decode the Base32 encoded _bytes-like object_ or ASCII string _s_
   and return the decoded "bytes".

   Optional _casefold_ is a flag specifying whether a lowercase
   alphabet is acceptable as input.  For security purposes, the
   default is "False".

   **RFC 3548** allows for optional mapping of the digit 0 (zero) to
   the letter O (oh), and for optional mapping of the digit 1 (one) to
   either the letter I (eye) or letter L (el).  The optional argument
   _map01_ when not "None", specifies which letter the digit 1 should
   be mapped to (when _map01_ is not "None", the digit 0 is always
   mapped to the letter O).  For security purposes the default is
   "None", so that 0 and 1 are not allowed in the input.

   A "binascii.Error" is raised if _s_ is incorrectly padded or if
   there are non-alphabet characters present in the input.

base64.b16encode(s)

   Encode the _bytes-like object_ _s_ using Base16 and return the
   encoded "bytes".

base64.b16decode(s, casefold=False)

   Decode the Base16 encoded _bytes-like object_ or ASCII string _s_
   and return the decoded "bytes".

   Optional _casefold_ is a flag specifying whether a lowercase
   alphabet is acceptable as input.  For security purposes, the
   default is "False".

   A "binascii.Error" is raised if _s_ is incorrectly padded or if
   there are non-alphabet characters present in the input.

base64.a85encode(b, *, foldspaces=False, wrapcol=0, pad=False, adobe=False)

   Encode the _bytes-like object_ _b_ using Ascii85 and return the
   encoded "bytes".

   _foldspaces_ is an optional flag that uses the special short
   sequence ‘y’ instead of 4 consecutive spaces (ASCII 0x20) as
   supported by ‘btoa’. This feature is not supported by the
   “standard” Ascii85 encoding.

   _wrapcol_ controls whether the output should have newline ("b'\n'")
   characters added to it. If this is non-zero, each output line will
   be at most this many characters long.

   _pad_ controls whether the input is padded to a multiple of 4
   before encoding. Note that the "btoa" implementation always pads.

   _adobe_ controls whether the encoded byte sequence is framed with
   "<~" and "~>", which is used by the Adobe implementation.

   New in version 3.4.

base64.a85decode(b, *, foldspaces=False, adobe=False, ignorechars=b' \t\n\r\v')

   Decode the Ascii85 encoded _bytes-like object_ or ASCII string _b_
   and return the decoded "bytes".

   _foldspaces_ is a flag that specifies whether the ‘y’ short
   sequence should be accepted as shorthand for 4 consecutive spaces
   (ASCII 0x20). This feature is not supported by the “standard”
   Ascii85 encoding.

   _adobe_ controls whether the input sequence is in Adobe Ascii85
   format (i.e. is framed with <~ and ~>).

   _ignorechars_ should be a _bytes-like object_ or ASCII string
   containing characters to ignore from the input. This should only
   contain whitespace characters, and by default contains all
   whitespace characters in ASCII.

   New in version 3.4.

base64.b85encode(b, pad=False)

   Encode the _bytes-like object_ _b_ using base85 (as used in e.g.
   git-style binary diffs) and return the encoded "bytes".

   If _pad_ is true, the input is padded with "b'\0'" so its length is
   a multiple of 4 bytes before encoding.

   New in version 3.4.

base64.b85decode(b)

   Decode the base85-encoded _bytes-like object_ or ASCII string _b_
   and return the decoded "bytes".  Padding is implicitly removed, if
   necessary.

   New in version 3.4.

The legacy interface:

base64.decode(input, output)

   Decode the contents of the binary _input_ file and write the
   resulting binary data to the _output_ file. _input_ and _output_
   must be _file objects_. _input_ will be read until
   "input.readline()" returns an empty bytes object.

base64.decodebytes(s)

   Decode the _bytes-like object_ _s_, which must contain one or more
   lines of base64 encoded data, and return the decoded "bytes".

   New in version 3.1.

base64.encode(input, output)

   Encode the contents of the binary _input_ file and write the
   resulting base64 encoded data to the _output_ file. _input_ and
   _output_ must be _file objects_. _input_ will be read until
   "input.read()" returns an empty bytes object. "encode()" inserts a
   newline character ("b'\n'") after every 76 bytes of the output, as
   well as ensuring that the output always ends with a newline, as per
   **RFC 2045** (MIME).

base64.encodebytes(s)

   Encode the _bytes-like object_ _s_, which can contain arbitrary
   binary data, and return "bytes" containing the base64-encoded data,
   with newlines ("b'\n'") inserted after every 76 bytes of output,
   and ensuring that there is a trailing newline, as per **RFC 2045**
   (MIME).

   New in version 3.1.

An example usage of the module:

>>> import base64
>>> encoded = base64.b64encode(b'data to be encoded')
>>> encoded
b'ZGF0YSB0byBiZSBlbmNvZGVk'
>>> data = base64.b64decode(encoded)
>>> data
b'data to be encoded'

See also:

  Module "binascii"
     Support module containing ASCII-to-binary and binary-to-ASCII
     conversions.

  **RFC 1521** - MIME (Multipurpose Internet Mail Extensions) Part
  One: Mechanisms for Specifying and Describing the Format of Internet
  Message Bodies
     Section 5.2, “Base64 Content-Transfer-Encoding,” provides the
     definition of the base64 encoding.

vim:tw=78:ts=8:ft=help:norl: