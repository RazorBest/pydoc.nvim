Python 3.12.3
*filecmp.pyx*                                 Last change: 2024 May 24

"filecmp" — File and Directory Comparisons
******************************************

**Source code:** Lib/filecmp.py

======================================================================

The "filecmp" module defines functions to compare files and
directories, with various optional time/correctness trade-offs. For
comparing files, see also the "difflib" module.

The "filecmp" module defines the following functions:

filecmp.cmp(f1, f2, shallow=True)

   Compare the files named _f1_ and _f2_, returning "True" if they
   seem equal, "False" otherwise.

   If _shallow_ is true and the "os.stat()" signatures (file type,
   size, and modification time) of both files are identical, the files
   are taken to be equal.

   Otherwise, the files are treated as different if their sizes or
   contents differ.

   Note that no external programs are called from this function,
   giving it portability and efficiency.

   This function uses a cache for past comparisons and the results,
   with cache entries invalidated if the "os.stat()" information for
   the file changes.  The entire cache may be cleared using
   "clear_cache()".

filecmp.cmpfiles(dir1, dir2, common, shallow=True)

   Compare the files in the two directories _dir1_ and _dir2_ whose
   names are given by _common_.

   Returns three lists of file names: _match_, _mismatch_, _errors_.
   _match_ contains the list of files that match, _mismatch_ contains
   the names of those that don’t, and _errors_ lists the names of
   files which could not be compared.  Files are listed in _errors_ if
   they don’t exist in one of the directories, the user lacks
   permission to read them or if the comparison could not be done for
   some other reason.

   The _shallow_ parameter has the same meaning and default value as
   for "filecmp.cmp()".

   For example, "cmpfiles('a', 'b', ['c', 'd/e'])" will compare "a/c"
   with "b/c" and "a/d/e" with "b/d/e".  "'c'" and "'d/e'" will each
   be in one of the three returned lists.

filecmp.clear_cache()

   Clear the filecmp cache. This may be useful if a file is compared
   so quickly after it is modified that it is within the mtime
   resolution of the underlying filesystem.

   New in version 3.4.


The "dircmp" class
==================

class filecmp.dircmp(a, b, ignore=None, hide=None)

   Construct a new directory comparison object, to compare the
   directories _a_ and _b_.  _ignore_ is a list of names to ignore,
   and defaults to "filecmp.DEFAULT_IGNORES".  _hide_ is a list of
   names to hide, and defaults to "[os.curdir, os.pardir]".

   The "dircmp" class compares files by doing _shallow_ comparisons as
   described for "filecmp.cmp()".

   The "dircmp" class provides the following methods:

   report()

      Print (to "sys.stdout") a comparison between _a_ and _b_.

   report_partial_closure()

      Print a comparison between _a_ and _b_ and common immediate
      subdirectories.

   report_full_closure()

      Print a comparison between _a_ and _b_ and common subdirectories
      (recursively).

   The "dircmp" class offers a number of interesting attributes that
   may be used to get various bits of information about the directory
   trees being compared.

   Note that via "__getattr__()" hooks, all attributes are computed
   lazily, so there is no speed penalty if only those attributes which
   are lightweight to compute are used.

   left

      The directory _a_.

   right

      The directory _b_.

   left_list

      Files and subdirectories in _a_, filtered by _hide_ and
      _ignore_.

   right_list

      Files and subdirectories in _b_, filtered by _hide_ and
      _ignore_.

   common

      Files and subdirectories in both _a_ and _b_.

   left_only

      Files and subdirectories only in _a_.

   right_only

      Files and subdirectories only in _b_.

   common_dirs

      Subdirectories in both _a_ and _b_.

   common_files

      Files in both _a_ and _b_.

   common_funny

      Names in both _a_ and _b_, such that the type differs between
      the directories, or names for which "os.stat()" reports an
      error.

   same_files

      Files which are identical in both _a_ and _b_, using the class’s
      file comparison operator.

   diff_files

      Files which are in both _a_ and _b_, whose contents differ
      according to the class’s file comparison operator.

   funny_files

      Files which are in both _a_ and _b_, but could not be compared.

   subdirs

      A dictionary mapping names in "common_dirs" to "dircmp"
      instances (or MyDirCmp instances if this instance is of type
      MyDirCmp, a subclass of "dircmp").

      Changed in version 3.10: Previously entries were always "dircmp"
      instances. Now entries are the same type as _self_, if _self_ is
      a subclass of "dircmp".

filecmp.DEFAULT_IGNORES

   New in version 3.4.

   List of directories ignored by "dircmp" by default.

Here is a simplified example of using the "subdirs" attribute to
search recursively through two directories to show common different
files:
>
   >>> from filecmp import dircmp
   >>> def print_diff_files(dcmp):
   ...     for name in dcmp.diff_files:
   ...         print("diff_file %s found in %s and %s" % (name, dcmp.left,
   ...               dcmp.right))
   ...     for sub_dcmp in dcmp.subdirs.values():
   ...         print_diff_files(sub_dcmp)
   ...
   >>> dcmp = dircmp('dir1', 'dir2') 
   >>> print_diff_files(dcmp) 
<
vim:tw=78:ts=8:ft=help:norl: