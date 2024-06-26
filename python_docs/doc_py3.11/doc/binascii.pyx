Python 3.11.9
*binascii.pyx*                                Last change: 2024 May 24

"binascii" — Convert between binary and ASCII
*********************************************

======================================================================

The "binascii" module contains a number of methods to convert between
binary and various ASCII-encoded binary representations. Normally, you
will not use these functions directly but use wrapper modules like
"uu" or "base64" instead. The "binascii" module contains low-level
functions written in C for greater speed that are used by the higher-
level modules.

Note:

  "a2b_*" functions accept Unicode strings containing only ASCII
  characters. Other functions only accept _bytes-like objects_ (such
  as "bytes", "bytearray" and other objects that support the buffer
  protocol).

  Changed in version 3.3: ASCII-only unicode strings are now accepted
  by the "a2b_*" functions.

The "binascii" module defines the following functions:

binascii.a2b_uu(string)

   Convert a single line of uuencoded data back to binary and return
   the binary data. Lines normally contain 45 (binary) bytes, except
   for the last line. Line data may be followed by whitespace.

binascii.b2a_uu(data, *, backtick=False)

   Convert binary data to a line of ASCII characters, the return value
   is the converted line, including a newline char. The length of
   _data_ should be at most 45. If _backtick_ is true, zeros are
   represented by "'`'" instead of spaces.

   Changed in version 3.7: Added the _backtick_ parameter.

binascii.a2b_base64(string, /, *, strict_mode=False)

   Convert a block of base64 data back to binary and return the binary
   data. More than one line may be passed at a time.

   If _strict_mode_ is true, only valid base64 data will be converted.
   Invalid base64 data will raise "binascii.Error".

   Valid base64:

   * Conforms to **RFC 3548**.

   * Contains only characters from the base64 alphabet.

   * Contains no excess data after padding (including excess padding,
     newlines, etc.).

   * Does not start with a padding.

   Changed in version 3.11: Added the _strict_mode_ parameter.

binascii.b2a_base64(data, *, newline=True)

   Convert binary data to a line of ASCII characters in base64 coding.
   The return value is the converted line, including a newline char if
   _newline_ is true.  The output of this function conforms to **RFC
   3548**.

   Changed in version 3.6: Added the _newline_ parameter.

binascii.a2b_qp(data, header=False)

   Convert a block of quoted-printable data back to binary and return
   the binary data. More than one line may be passed at a time. If the
   optional argument _header_ is present and true, underscores will be
   decoded as spaces.

binascii.b2a_qp(data, quotetabs=False, istext=True, header=False)

   Convert binary data to a line(s) of ASCII characters in quoted-
   printable encoding.  The return value is the converted line(s). If
   the optional argument _quotetabs_ is present and true, all tabs and
   spaces will be encoded.   If the optional argument _istext_ is
   present and true, newlines are not encoded but trailing whitespace
   will be encoded. If the optional argument _header_ is present and
   true, spaces will be encoded as underscores per **RFC 1522**. If
   the optional argument _header_ is present and false, newline
   characters will be encoded as well; otherwise linefeed conversion
   might corrupt the binary data stream.

binascii.crc_hqx(data, value)

   Compute a 16-bit CRC value of _data_, starting with _value_ as the
   initial CRC, and return the result.  This uses the CRC-CCITT
   polynomial _x_^16 + _x_^12 + _x_^5 + 1, often represented as
   0x1021.  This CRC is used in the binhex4 format.

binascii.crc32(data[, value])

   Compute CRC-32, the unsigned 32-bit checksum of _data_, starting
   with an initial CRC of _value_.  The default initial CRC is zero.
   The algorithm is consistent with the ZIP file checksum.  Since the
   algorithm is designed for use as a checksum algorithm, it is not
   suitable for use as a general hash algorithm.  Use as follows:
>
      print(binascii.crc32(b"hello world"))
      # Or, in two pieces:
      crc = binascii.crc32(b"hello")
      crc = binascii.crc32(b" world", crc)
      print('crc32 = {:#010x}'.format(crc))
<
   Changed in version 3.0: The result is always unsigned.

binascii.b2a_hex(data[, sep[, bytes_per_sep=1]])
binascii.hexlify(data[, sep[, bytes_per_sep=1]])

   Return the hexadecimal representation of the binary _data_.  Every
   byte of _data_ is converted into the corresponding 2-digit hex
   representation.  The returned bytes object is therefore twice as
   long as the length of _data_.

   Similar functionality (but returning a text string) is also
   conveniently accessible using the "bytes.hex()" method.

   If _sep_ is specified, it must be a single character str or bytes
   object. It will be inserted in the output after every
   _bytes_per_sep_ input bytes. Separator placement is counted from
   the right end of the output by default, if you wish to count from
   the left, supply a negative _bytes_per_sep_ value.

   >>> import binascii
   >>> binascii.b2a_hex(b'\xb9\x01\xef')
   b'b901ef'
   >>> binascii.hexlify(b'\xb9\x01\xef', '-')
   b'b9-01-ef'
   >>> binascii.b2a_hex(b'\xb9\x01\xef', b'_', 2)
   b'b9_01ef'
   >>> binascii.b2a_hex(b'\xb9\x01\xef', b' ', -2)
   b'b901 ef'

   Changed in version 3.8: The _sep_ and _bytes_per_sep_ parameters
   were added.

binascii.a2b_hex(hexstr)
binascii.unhexlify(hexstr)

   Return the binary data represented by the hexadecimal string
   _hexstr_.  This function is the inverse of "b2a_hex()". _hexstr_
   must contain an even number of hexadecimal digits (which can be
   upper or lower case), otherwise an "Error" exception is raised.

   Similar functionality (accepting only text string arguments, but
   more liberal towards whitespace) is also accessible using the
   "bytes.fromhex()" class method.

exception binascii.Error

   Exception raised on errors. These are usually programming errors.

exception binascii.Incomplete

   Exception raised on incomplete data. These are usually not
   programming errors, but may be handled by reading a little more
   data and trying again.

See also:

  Module "base64"
     Support for RFC compliant base64-style encoding in base 16, 32,
     64, and 85.

  Module "uu"
     Support for UU encoding used on Unix.

  Module "quopri"
     Support for quoted-printable encoding used in MIME email
     messages.

vim:tw=78:ts=8:ft=help:norl: