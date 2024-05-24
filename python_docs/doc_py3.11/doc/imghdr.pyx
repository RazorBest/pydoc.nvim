Python 3.11.9
*imghdr.pyx*                                  Last change: 2024 May 24

"imghdr" — Determine the type of an image
*****************************************

**Source code:** Lib/imghdr.py

Deprecated since version 3.11, will be removed in version 3.13: The
"imghdr" module is deprecated (see **PEP 594** for details and
alternatives).

======================================================================

The "imghdr" module determines the type of image contained in a file
or byte stream.

The "imghdr" module defines the following function:

imghdr.what(file, h=None)

   Tests the image data contained in the file named by _file_, and
   returns a string describing the image type.  If optional _h_ is
   provided, the _file_ argument is ignored and _h_ is assumed to
   contain the byte stream to test.

   Changed in version 3.6: Accepts a _path-like object_.

The following image types are recognized, as listed below with the
return value from "what()":

+--------------+-------------------------------------+
| Value        | Image format                        |
|==============|=====================================|
| "'rgb'"      | SGI ImgLib Files                    |
+--------------+-------------------------------------+
| "'gif'"      | GIF 87a and 89a Files               |
+--------------+-------------------------------------+
| "'pbm'"      | Portable Bitmap Files               |
+--------------+-------------------------------------+
| "'pgm'"      | Portable Graymap Files              |
+--------------+-------------------------------------+
| "'ppm'"      | Portable Pixmap Files               |
+--------------+-------------------------------------+
| "'tiff'"     | TIFF Files                          |
+--------------+-------------------------------------+
| "'rast'"     | Sun Raster Files                    |
+--------------+-------------------------------------+
| "'xbm'"      | X Bitmap Files                      |
+--------------+-------------------------------------+
| "'jpeg'"     | JPEG data in JFIF or Exif formats   |
+--------------+-------------------------------------+
| "'bmp'"      | BMP files                           |
+--------------+-------------------------------------+
| "'png'"      | Portable Network Graphics           |
+--------------+-------------------------------------+
| "'webp'"     | WebP files                          |
+--------------+-------------------------------------+
| "'exr'"      | OpenEXR Files                       |
+--------------+-------------------------------------+

New in version 3.5: The _exr_ and _webp_ formats were added.

You can extend the list of file types "imghdr" can recognize by
appending to this variable:

imghdr.tests

   A list of functions performing the individual tests.  Each function
   takes two arguments: the byte-stream and an open file-like object.
   When "what()" is called with a byte-stream, the file-like object
   will be "None".

   The test function should return a string describing the image type
   if the test succeeded, or "None" if it failed.

Example:
>
   >>> import imghdr
   >>> imghdr.what('bass.gif')
   'gif'
<
vim:tw=78:ts=8:ft=help:norl: