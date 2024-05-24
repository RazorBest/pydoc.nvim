Python 3.8.19
*bz2.pyx*                                     Last change: 2024 May 24

"bz2" — Support for **bzip2** compression
*****************************************

**Source code:** Lib/bz2.py

======================================================================

This module provides a comprehensive interface for compressing and
decompressing data using the bzip2 compression algorithm.

The "bz2" module contains:

* The "open()" function and "BZ2File" class for reading and writing
  compressed files.

* The "BZ2Compressor" and "BZ2Decompressor" classes for incremental
  (de)compression.

* The "compress()" and "decompress()" functions for one-shot
  (de)compression.

All of the classes in this module may safely be accessed from multiple
threads.


(De)compression of files
========================

bz2.open(filename, mode='r', compresslevel=9, encoding=None, errors=None, newline=None)

   Open a bzip2-compressed file in binary or text mode, returning a
   _file object_.

   As with the constructor for "BZ2File", the _filename_ argument can
   be an actual filename (a "str" or "bytes" object), or an existing
   file object to read from or write to.

   The _mode_ argument can be any of "'r'", "'rb'", "'w'", "'wb'",
   "'x'", "'xb'", "'a'" or "'ab'" for binary mode, or "'rt'", "'wt'",
   "'xt'", or "'at'" for text mode. The default is "'rb'".

   The _compresslevel_ argument is an integer from 1 to 9, as for the
   "BZ2File" constructor.

   For binary mode, this function is equivalent to the "BZ2File"
   constructor: "BZ2File(filename, mode,
   compresslevel=compresslevel)". In this case, the _encoding_,
   _errors_ and _newline_ arguments must not be provided.

   For text mode, a "BZ2File" object is created, and wrapped in an
   "io.TextIOWrapper" instance with the specified encoding, error
   handling behavior, and line ending(s).

   New in version 3.3.

   Changed in version 3.4: The "'x'" (exclusive creation) mode was
   added.

   Changed in version 3.6: Accepts a _path-like object_.

class bz2.BZ2File(filename, mode='r', buffering=None, compresslevel=9)

   Open a bzip2-compressed file in binary mode.

   If _filename_ is a "str" or "bytes" object, open the named file
   directly. Otherwise, _filename_ should be a _file object_, which
   will be used to read or write the compressed data.

   The _mode_ argument can be either "'r'" for reading (default),
   "'w'" for overwriting, "'x'" for exclusive creation, or "'a'" for
   appending. These can equivalently be given as "'rb'", "'wb'",
   "'xb'" and "'ab'" respectively.

   If _filename_ is a file object (rather than an actual file name), a
   mode of "'w'" does not truncate the file, and is instead equivalent
   to "'a'".

   The _buffering_ argument is ignored. Its use is deprecated since
   Python 3.0.

   If _mode_ is "'w'" or "'a'", _compresslevel_ can be an integer
   between "1" and "9" specifying the level of compression: "1"
   produces the least compression, and "9" (default) produces the most
   compression.

   If _mode_ is "'r'", the input file may be the concatenation of
   multiple compressed streams.

   "BZ2File" provides all of the members specified by the
   "io.BufferedIOBase", except for "detach()" and "truncate()".
   Iteration and the "with" statement are supported.

   "BZ2File" also provides the following method:

   peek([n])

      Return buffered data without advancing the file position. At
      least one byte of data will be returned (unless at EOF). The
      exact number of bytes returned is unspecified.

      Note:

        While calling "peek()" does not change the file position of
        the "BZ2File", it may change the position of the underlying
        file object (e.g. if the "BZ2File" was constructed by passing
        a file object for _filename_).

      New in version 3.3.

   Deprecated since version 3.0: The keyword argument _buffering_ was
   deprecated and is now ignored.

   Changed in version 3.1: Support for the "with" statement was added.

   Changed in version 3.3: The "fileno()", "readable()", "seekable()",
   "writable()", "read1()" and "readinto()" methods were added.

   Changed in version 3.3: Support was added for _filename_ being a
   _file object_ instead of an actual filename.

   Changed in version 3.3: The "'a'" (append) mode was added, along
   with support for reading multi-stream files.

   Changed in version 3.4: The "'x'" (exclusive creation) mode was
   added.

   Changed in version 3.5: The "read()" method now accepts an argument
   of "None".

   Changed in version 3.6: Accepts a _path-like object_.


Incremental (de)compression
===========================

class bz2.BZ2Compressor(compresslevel=9)

   Create a new compressor object. This object may be used to compress
   data incrementally. For one-shot compression, use the "compress()"
   function instead.

   _compresslevel_, if given, must be an integer between "1" and "9".
   The default is "9".

   compress(data)

      Provide data to the compressor object. Returns a chunk of
      compressed data if possible, or an empty byte string otherwise.

      When you have finished providing data to the compressor, call
      the "flush()" method to finish the compression process.

   flush()

      Finish the compression process. Returns the compressed data left
      in internal buffers.

      The compressor object may not be used after this method has been
      called.

class bz2.BZ2Decompressor

   Create a new decompressor object. This object may be used to
   decompress data incrementally. For one-shot compression, use the
   "decompress()" function instead.

   Note:

     This class does not transparently handle inputs containing
     multiple compressed streams, unlike "decompress()" and "BZ2File".
     If you need to decompress a multi-stream input with
     "BZ2Decompressor", you must use a new decompressor for each
     stream.

   decompress(data, max_length=-1)

      Decompress _data_ (a _bytes-like object_), returning
      uncompressed data as bytes. Some of _data_ may be buffered
      internally, for use in later calls to "decompress()". The
      returned data should be concatenated with the output of any
      previous calls to "decompress()".

      If _max_length_ is nonnegative, returns at most _max_length_
      bytes of decompressed data. If this limit is reached and further
      output can be produced, the "needs_input" attribute will be set
      to "False". In this case, the next call to "decompress()" may
      provide _data_ as "b''" to obtain more of the output.

      If all of the input data was decompressed and returned (either
      because this was less than _max_length_ bytes, or because
      _max_length_ was negative), the "needs_input" attribute will be
      set to "True".

      Attempting to decompress data after the end of stream is reached
      raises an _EOFError_.  Any data found after the end of the
      stream is ignored and saved in the "unused_data" attribute.

      Changed in version 3.5: Added the _max_length_ parameter.

   eof

      "True" if the end-of-stream marker has been reached.

      New in version 3.3.

   unused_data

      Data found after the end of the compressed stream.

      If this attribute is accessed before the end of the stream has
      been reached, its value will be "b''".

   needs_input

      "False" if the "decompress()" method can provide more
      decompressed data before requiring new uncompressed input.

      New in version 3.5.


One-shot (de)compression
========================

bz2.compress(data, compresslevel=9)

   Compress _data_, a _bytes-like object_.

   _compresslevel_, if given, must be an integer between "1" and "9".
   The default is "9".

   For incremental compression, use a "BZ2Compressor" instead.

bz2.decompress(data)

   Decompress _data_, a _bytes-like object_.

   If _data_ is the concatenation of multiple compressed streams,
   decompress all of the streams.

   For incremental decompression, use a "BZ2Decompressor" instead.

   Changed in version 3.3: Support for multi-stream inputs was added.


Examples of usage
=================

Below are some examples of typical usage of the "bz2" module.

Using "compress()" and "decompress()" to demonstrate round-trip
compression:

>>> import bz2
>>> data = b"""\
... Donec rhoncus quis sapien sit amet molestie. Fusce scelerisque vel augue
... nec ullamcorper. Nam rutrum pretium placerat. Aliquam vel tristique lorem,
... sit amet cursus ante. In interdum laoreet mi, sit amet ultrices purus
... pulvinar a. Nam gravida euismod magna, non varius justo tincidunt feugiat.
... Aliquam pharetra lacus non risus vehicula rutrum. Maecenas aliquam leo
... felis. Pellentesque semper nunc sit amet nibh ullamcorper, ac elementum
... dolor luctus. Curabitur lacinia mi ornare consectetur vestibulum."""
>>> c = bz2.compress(data)
>>> len(data) / len(c)  # Data compression ratio
1.513595166163142
>>> d = bz2.decompress(c)
>>> data == d  # Check equality to original object after round-trip
True

Using "BZ2Compressor" for incremental compression:

>>> import bz2
>>> def gen_data(chunks=10, chunksize=1000):
...     """Yield incremental blocks of chunksize bytes."""
...     for _ in range(chunks):
...         yield b"z" * chunksize
...
>>> comp = bz2.BZ2Compressor()
>>> out = b""
>>> for chunk in gen_data():
...     # Provide data to the compressor object
...     out = out + comp.compress(chunk)
...
>>> # Finish the compression process.  Call this once you have
>>> # finished providing data to the compressor.
>>> out = out + comp.flush()

The example above uses a very “nonrandom” stream of data (a stream of
_b”z”_ chunks).  Random data tends to compress poorly, while ordered,
repetitive data usually yields a high compression ratio.

Writing and reading a bzip2-compressed file in binary mode:

>>> import bz2
>>> data = b"""\
... Donec rhoncus quis sapien sit amet molestie. Fusce scelerisque vel augue
... nec ullamcorper. Nam rutrum pretium placerat. Aliquam vel tristique lorem,
... sit amet cursus ante. In interdum laoreet mi, sit amet ultrices purus
... pulvinar a. Nam gravida euismod magna, non varius justo tincidunt feugiat.
... Aliquam pharetra lacus non risus vehicula rutrum. Maecenas aliquam leo
... felis. Pellentesque semper nunc sit amet nibh ullamcorper, ac elementum
... dolor luctus. Curabitur lacinia mi ornare consectetur vestibulum."""
>>> with bz2.open("myfile.bz2", "wb") as f:
...     # Write compressed data to file
...     unused = f.write(data)
>>> with bz2.open("myfile.bz2", "rb") as f:
...     # Decompress data from file
...     content = f.read()
>>> content == data  # Check equality to original object after round-trip
True

vim:tw=78:ts=8:ft=help:norl: