Python 3.12.3
*archiving.pyx*                               Last change: 2024 May 24

Data Compression and Archiving
******************************

The modules described in this chapter support data compression with
the zlib, gzip, bzip2 and lzma algorithms, and the creation of ZIP-
and tar-format archives.  See also Archiving operations provided by
the "shutil" module.

* "zlib" — Compression compatible with **gzip**

* "gzip" — Support for **gzip** files

  * Examples of usage

  * Command Line Interface

    * Command line options

* "bz2" — Support for **bzip2** compression

  * (De)compression of files

  * Incremental (de)compression

  * One-shot (de)compression

  * Examples of usage

* "lzma" — Compression using the LZMA algorithm

  * Reading and writing compressed files

  * Compressing and decompressing data in memory

  * Miscellaneous

  * Specifying custom filter chains

  * Examples

* "zipfile" — Work with ZIP archives

  * ZipFile Objects

  * Path Objects

  * PyZipFile Objects

  * ZipInfo Objects

  * Command-Line Interface

    * Command-line options

  * Decompression pitfalls

    * From file itself

    * File System limitations

    * Resources limitations

    * Interruption

    * Default behaviors of extraction

* "tarfile" — Read and write tar archive files

  * TarFile Objects

  * TarInfo Objects

  * Extraction filters

    * Default named filters

    * Filter errors

    * Hints for further verification

    * Supporting older Python versions

    * Stateful extraction filter example

  * Command-Line Interface

    * Command-line options

  * Examples

  * Supported tar formats

  * Unicode issues

vim:tw=78:ts=8:ft=help:norl: