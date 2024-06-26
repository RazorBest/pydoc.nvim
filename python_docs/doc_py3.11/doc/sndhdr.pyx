Python 3.11.9
*sndhdr.pyx*                                  Last change: 2024 May 24

"sndhdr" — Determine type of sound file
***************************************

**Source code:** Lib/sndhdr.py

Deprecated since version 3.11, will be removed in version 3.13: The
"sndhdr" module is deprecated (see **PEP 594** for details and
alternatives).

======================================================================

The "sndhdr" provides utility functions which attempt to determine the
type of sound data which is in a file.  When these functions are able
to determine what type of sound data is stored in a file, they return
a "namedtuple()", containing five attributes: ("filetype",
"framerate", "nchannels", "nframes", "sampwidth"). The value for
_type_ indicates the data type and will be one of the strings
"'aifc'", "'aiff'", "'au'", "'hcom'", "'sndr'", "'sndt'", "'voc'",
"'wav'", "'8svx'", "'sb'", "'ub'", or "'ul'".  The _sampling_rate_
will be either the actual value or "0" if unknown or difficult to
decode.  Similarly, _channels_ will be either the number of channels
or "0" if it cannot be determined or if the value is difficult to
decode.  The value for _frames_ will be either the number of frames or
"-1".  The last item in the tuple, _bits_per_sample_, will either be
the sample size in bits or "'A'" for A-LAW or "'U'" for u-LAW.

sndhdr.what(filename)

   Determines the type of sound data stored in the file _filename_
   using "whathdr()".  If it succeeds, returns a namedtuple as
   described above, otherwise "None" is returned.

   Changed in version 3.5: Result changed from a tuple to a
   namedtuple.

sndhdr.whathdr(filename)

   Determines the type of sound data stored in a file based on the
   file  header. The name of the file is given by _filename_.  This
   function returns a namedtuple as described above on success, or
   "None".

   Changed in version 3.5: Result changed from a tuple to a
   namedtuple.

The following sound header types are recognized, as listed below with
the return value from "whathdr()": and "what()":

+--------------+--------------------------------------+
| Value        | Sound header format                  |
|==============|======================================|
| "'aifc'"     | Compressed Audio Interchange Files   |
+--------------+--------------------------------------+
| "'aiff'"     | Audio Interchange Files              |
+--------------+--------------------------------------+
| "'au'"       | Au Files                             |
+--------------+--------------------------------------+
| "'hcom'"     | HCOM Files                           |
+--------------+--------------------------------------+
| "'sndt'"     | Sndtool Sound Files                  |
+--------------+--------------------------------------+
| "'voc'"      | Creative Labs Audio Files            |
+--------------+--------------------------------------+
| "'wav'"      | Waveform Audio File Format Files     |
+--------------+--------------------------------------+
| "'8svx'"     | 8-Bit Sampled Voice Files            |
+--------------+--------------------------------------+
| "'sb'"       | Signed Byte Audio Data Files         |
+--------------+--------------------------------------+
| "'ub'"       | UB Files                             |
+--------------+--------------------------------------+
| "'ul'"       | uLAW Audio Files                     |
+--------------+--------------------------------------+

sndhdr.tests

   A list of functions performing the individual tests.  Each function
   takes two arguments: the byte-stream and an open file-like object.
   When "what()" is called with a byte-stream, the file-like object
   will be "None".

   The test function should return a string describing the image type
   if the test succeeded, or "None" if it failed.

Example:
>
   >>> import sndhdr
   >>> imghdr.what('bass.wav')
   'wav'
   >>> imghdr.whathdr('bass.wav')
   'wav'
<
vim:tw=78:ts=8:ft=help:norl: