Python 3.11.9
*quopri.pyx*                                  Last change: 2024 May 24

"quopri" — Encode and decode MIME quoted-printable data
*******************************************************

**Source code:** Lib/quopri.py

======================================================================

This module performs quoted-printable transport encoding and decoding,
as defined in **RFC 1521**: “MIME (Multipurpose Internet Mail
Extensions) Part One: Mechanisms for Specifying and Describing the
Format of Internet Message Bodies”. The quoted-printable encoding is
designed for data where there are relatively few nonprintable
characters; the base64 encoding scheme available via the "base64"
module is more compact if there are many such characters, as when
sending a graphics file.

quopri.decode(input, output, header=False)

   Decode the contents of the _input_ file and write the resulting
   decoded binary data to the _output_ file. _input_ and _output_ must
   be _binary file objects_.  If the optional argument _header_ is
   present and true, underscore will be decoded as space. This is used
   to decode “Q”-encoded headers as described in **RFC 1522**: “MIME
   (Multipurpose Internet Mail Extensions) Part Two: Message Header
   Extensions for Non-ASCII Text”.

quopri.encode(input, output, quotetabs, header=False)

   Encode the contents of the _input_ file and write the resulting
   quoted-printable data to the _output_ file. _input_ and _output_
   must be _binary file objects_. _quotetabs_, a non-optional flag
   which controls whether to encode embedded spaces and tabs; when
   true it encodes such embedded whitespace, and when false it leaves
   them unencoded. Note that spaces and tabs appearing at the end of
   lines are always encoded, as per **RFC 1521**.  _header_ is a flag
   which controls if spaces are encoded as underscores as per **RFC
   1522**.

quopri.decodestring(s, header=False)

   Like "decode()", except that it accepts a source "bytes" and
   returns the corresponding decoded "bytes".

quopri.encodestring(s, quotetabs=False, header=False)

   Like "encode()", except that it accepts a source "bytes" and
   returns the corresponding encoded "bytes". By default, it sends a
   "False" value to _quotetabs_ parameter of the "encode()" function.

See also:

  Module "base64"
     Encode and decode MIME base64 data

vim:tw=78:ts=8:ft=help:norl: