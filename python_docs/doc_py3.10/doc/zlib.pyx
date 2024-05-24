Python 3.10.14
*zlib.pyx*                                    Last change: 2024 May 24

"zlib" — Compression compatible with **gzip**
*********************************************

======================================================================

For applications that require data compression, the functions in this
module allow compression and decompression, using the zlib library.
The zlib library has its own home page at https://www.zlib.net.
There are known incompatibilities between the Python module and
versions of the zlib library earlier than 1.1.3; 1.1.3 has a security
vulnerability, so we recommend using 1.1.4 or later.

zlib’s functions have many options and often need to be used in a
particular order.  This documentation doesn’t attempt to cover all of
the permutations; consult the zlib manual at
http://www.zlib.net/manual.html for authoritative information.

For reading and writing ".gz" files see the "gzip" module.

The available exception and functions in this module are:

exception zlib.error

   Exception raised on compression and decompression errors.

zlib.adler32(data[, value])

   Computes an Adler-32 checksum of _data_.  (An Adler-32 checksum is
   almost as reliable as a CRC32 but can be computed much more
   quickly.)  The result is an unsigned 32-bit integer.  If _value_ is
   present, it is used as the starting value of the checksum;
   otherwise, a default value of 1 is used.  Passing in _value_ allows
   computing a running checksum over the concatenation of several
   inputs.  The algorithm is not cryptographically strong, and should
   not be used for authentication or digital signatures.  Since the
   algorithm is designed for use as a checksum algorithm, it is not
   suitable for use as a general hash algorithm.

   Changed in version 3.0: The result is always unsigned. To generate
   the same numeric value when using Python 2 or earlier, use
   "adler32(data) & 0xffffffff".

zlib.compress(data, /, level=- 1)

   Compresses the bytes in _data_, returning a bytes object containing
   compressed data. _level_ is an integer from "0" to "9" or "-1"
   controlling the level of compression; "1" (Z_BEST_SPEED) is fastest
   and produces the least compression, "9" (Z_BEST_COMPRESSION) is
   slowest and produces the most.  "0" (Z_NO_COMPRESSION) is no
   compression. The default value is "-1" (Z_DEFAULT_COMPRESSION).
   Z_DEFAULT_COMPRESSION represents a default compromise between speed
   and compression (currently equivalent to level 6). Raises the
   "error" exception if any error occurs.

   Changed in version 3.6: _level_ can now be used as a keyword
   parameter.

zlib.compressobj(level=-1, method=DEFLATED, wbits=MAX_WBITS, memLevel=DEF_MEM_LEVEL, strategy=Z_DEFAULT_STRATEGY[, zdict])

   Returns a compression object, to be used for compressing data
   streams that won’t fit into memory at once.

   _level_ is the compression level – an integer from "0" to "9" or
   "-1". A value of "1" (Z_BEST_SPEED) is fastest and produces the
   least compression, while a value of "9" (Z_BEST_COMPRESSION) is
   slowest and produces the most. "0" (Z_NO_COMPRESSION) is no
   compression.  The default value is "-1" (Z_DEFAULT_COMPRESSION).
   Z_DEFAULT_COMPRESSION represents a default compromise between speed
   and compression (currently equivalent to level 6).

   _method_ is the compression algorithm. Currently, the only
   supported value is "DEFLATED".

   The _wbits_ argument controls the size of the history buffer (or
   the “window size”) used when compressing data, and whether a header
   and trailer is included in the output.  It can take several ranges
   of values, defaulting to "15" (MAX_WBITS):

   * +9 to +15: The base-two logarithm of the window size, which
     therefore ranges between 512 and 32768.  Larger values produce
     better compression at the expense of greater memory usage.  The
     resulting output will include a zlib-specific header and trailer.

   * −9 to −15: Uses the absolute value of _wbits_ as the window size
     logarithm, while producing a raw output stream with no header or
     trailing checksum.

   * +25 to +31 = 16 + (9 to 15): Uses the low 4 bits of the value as
     the window size logarithm, while including a basic **gzip**
     header and trailing checksum in the output.

   The _memLevel_ argument controls the amount of memory used for the
   internal compression state. Valid values range from "1" to "9".
   Higher values use more memory, but are faster and produce smaller
   output.

   _strategy_ is used to tune the compression algorithm. Possible
   values are "Z_DEFAULT_STRATEGY", "Z_FILTERED", "Z_HUFFMAN_ONLY",
   "Z_RLE" (zlib 1.2.0.1) and "Z_FIXED" (zlib 1.2.2.2).

   _zdict_ is a predefined compression dictionary. This is a sequence
   of bytes (such as a "bytes" object) containing subsequences that
   are expected to occur frequently in the data that is to be
   compressed. Those subsequences that are expected to be most common
   should come at the end of the dictionary.

   Changed in version 3.3: Added the _zdict_ parameter and keyword
   argument support.

zlib.crc32(data[, value])

   Computes a CRC (Cyclic Redundancy Check) checksum of _data_. The
   result is an unsigned 32-bit integer. If _value_ is present, it is
   used as the starting value of the checksum; otherwise, a default
   value of 0 is used.  Passing in _value_ allows computing a running
   checksum over the concatenation of several inputs.  The algorithm
   is not cryptographically strong, and should not be used for
   authentication or digital signatures.  Since the algorithm is
   designed for use as a checksum algorithm, it is not suitable for
   use as a general hash algorithm.

   Changed in version 3.0: The result is always unsigned. To generate
   the same numeric value when using Python 2 or earlier, use
   "crc32(data) & 0xffffffff".

zlib.decompress(data, /, wbits=MAX_WBITS, bufsize=DEF_BUF_SIZE)

   Decompresses the bytes in _data_, returning a bytes object
   containing the uncompressed data.  The _wbits_ parameter depends on
   the format of _data_, and is discussed further below. If _bufsize_
   is given, it is used as the initial size of the output buffer.
   Raises the "error" exception if any error occurs.

   The _wbits_ parameter controls the size of the history buffer (or
   “window size”), and what header and trailer format is expected. It
   is similar to the parameter for "compressobj()", but accepts more
   ranges of values:

   * +8 to +15: The base-two logarithm of the window size.  The input
     must include a zlib header and trailer.

   * 0: Automatically determine the window size from the zlib header.
     Only supported since zlib 1.2.3.5.

   * −8 to −15: Uses the absolute value of _wbits_ as the window size
     logarithm.  The input must be a raw stream with no header or
     trailer.

   * +24 to +31 = 16 + (8 to 15): Uses the low 4 bits of the value as
     the window size logarithm.  The input must include a gzip header
     and trailer.

   * +40 to +47 = 32 + (8 to 15): Uses the low 4 bits of the value as
     the window size logarithm, and automatically accepts either the
     zlib or gzip format.

   When decompressing a stream, the window size must not be smaller
   than the size originally used to compress the stream; using a too-
   small value may result in an "error" exception. The default _wbits_
   value corresponds to the largest window size and requires a zlib
   header and trailer to be included.

   _bufsize_ is the initial size of the buffer used to hold
   decompressed data.  If more space is required, the buffer size will
   be increased as needed, so you don’t have to get this value exactly
   right; tuning it will only save a few calls to "malloc()".

   Changed in version 3.6: _wbits_ and _bufsize_ can be used as
   keyword arguments.

zlib.decompressobj(wbits=MAX_WBITS[, zdict])

   Returns a decompression object, to be used for decompressing data
   streams that won’t fit into memory at once.

   The _wbits_ parameter controls the size of the history buffer (or
   the “window size”), and what header and trailer format is expected.
   It has the same meaning as described for decompress().

   The _zdict_ parameter specifies a predefined compression
   dictionary. If provided, this must be the same dictionary as was
   used by the compressor that produced the data that is to be
   decompressed.

   Note:

     If _zdict_ is a mutable object (such as a "bytearray"), you must
     not modify its contents between the call to "decompressobj()" and
     the first call to the decompressor’s "decompress()" method.

   Changed in version 3.3: Added the _zdict_ parameter.

Compression objects support the following methods:

Compress.compress(data)

   Compress _data_, returning a bytes object containing compressed
   data for at least part of the data in _data_.  This data should be
   concatenated to the output produced by any preceding calls to the
   "compress()" method.  Some input may be kept in internal buffers
   for later processing.

Compress.flush([mode])

   All pending input is processed, and a bytes object containing the
   remaining compressed output is returned.  _mode_ can be selected
   from the constants "Z_NO_FLUSH", "Z_PARTIAL_FLUSH", "Z_SYNC_FLUSH",
   "Z_FULL_FLUSH", "Z_BLOCK" (zlib 1.2.3.4), or "Z_FINISH", defaulting
   to "Z_FINISH".  Except "Z_FINISH", all constants allow compressing
   further bytestrings of data, while "Z_FINISH" finishes the
   compressed stream and prevents compressing any more data.  After
   calling "flush()" with _mode_ set to "Z_FINISH", the "compress()"
   method cannot be called again; the only realistic action is to
   delete the object.

Compress.copy()

   Returns a copy of the compression object.  This can be used to
   efficiently compress a set of data that share a common initial
   prefix.

Changed in version 3.8: Added "copy.copy()" and "copy.deepcopy()"
support to compression objects.

Decompression objects support the following methods and attributes:

Decompress.unused_data

   A bytes object which contains any bytes past the end of the
   compressed data. That is, this remains "b""" until the last byte
   that contains compression data is available.  If the whole
   bytestring turned out to contain compressed data, this is "b""", an
   empty bytes object.

Decompress.unconsumed_tail

   A bytes object that contains any data that was not consumed by the
   last "decompress()" call because it exceeded the limit for the
   uncompressed data buffer.  This data has not yet been seen by the
   zlib machinery, so you must feed it (possibly with further data
   concatenated to it) back to a subsequent "decompress()" method call
   in order to get correct output.

Decompress.eof

   A boolean indicating whether the end of the compressed data stream
   has been reached.

   This makes it possible to distinguish between a properly formed
   compressed stream, and an incomplete or truncated one.

   New in version 3.3.

Decompress.decompress(data, max_length=0)

   Decompress _data_, returning a bytes object containing the
   uncompressed data corresponding to at least part of the data in
   _string_.  This data should be concatenated to the output produced
   by any preceding calls to the "decompress()" method.  Some of the
   input data may be preserved in internal buffers for later
   processing.

   If the optional parameter _max_length_ is non-zero then the return
   value will be no longer than _max_length_. This may mean that not
   all of the compressed input can be processed; and unconsumed data
   will be stored in the attribute "unconsumed_tail". This bytestring
   must be passed to a subsequent call to "decompress()" if
   decompression is to continue.  If _max_length_ is zero then the
   whole input is decompressed, and "unconsumed_tail" is empty.

   Changed in version 3.6: _max_length_ can be used as a keyword
   argument.

Decompress.flush([length])

   All pending input is processed, and a bytes object containing the
   remaining uncompressed output is returned.  After calling
   "flush()", the "decompress()" method cannot be called again; the
   only realistic action is to delete the object.

   The optional parameter _length_ sets the initial size of the output
   buffer.

Decompress.copy()

   Returns a copy of the decompression object.  This can be used to
   save the state of the decompressor midway through the data stream
   in order to speed up random seeks into the stream at a future
   point.

Changed in version 3.8: Added "copy.copy()" and "copy.deepcopy()"
support to decompression objects.

Information about the version of the zlib library in use is available
through the following constants:

zlib.ZLIB_VERSION

   The version string of the zlib library that was used for building
   the module. This may be different from the zlib library actually
   used at runtime, which is available as "ZLIB_RUNTIME_VERSION".

zlib.ZLIB_RUNTIME_VERSION

   The version string of the zlib library actually loaded by the
   interpreter.

   New in version 3.3.

See also:

  Module "gzip"
     Reading and writing **gzip**-format files.

  http://www.zlib.net
     The zlib library home page.

  http://www.zlib.net/manual.html
     The zlib manual explains  the semantics and usage of the
     library’s many functions.

vim:tw=78:ts=8:ft=help:norl: