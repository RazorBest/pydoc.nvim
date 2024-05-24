Python 3.9.19
*modulefinder.pyx*                            Last change: 2024 May 24

"modulefinder" — Find modules used by a script
**********************************************

**Source code:** Lib/modulefinder.py

======================================================================

This module provides a "ModuleFinder" class that can be used to
determine the set of modules imported by a script. "modulefinder.py"
can also be run as a script, giving the filename of a Python script as
its argument, after which a report of the imported modules will be
printed.

modulefinder.AddPackagePath(pkg_name, path)

   Record that the package named _pkg_name_ can be found in the
   specified _path_.

modulefinder.ReplacePackage(oldname, newname)

   Allows specifying that the module named _oldname_ is in fact the
   package named _newname_.

class modulefinder.ModuleFinder(path=None, debug=0, excludes=[], replace_paths=[])

   This class provides "run_script()" and "report()" methods to
   determine the set of modules imported by a script. _path_ can be a
   list of directories to search for modules; if not specified,
   "sys.path" is used.  _debug_ sets the debugging level; higher
   values make the class print debugging messages about what it’s
   doing. _excludes_ is a list of module names to exclude from the
   analysis. _replace_paths_ is a list of "(oldpath, newpath)" tuples
   that will be replaced in module paths.

   report()

      Print a report to standard output that lists the modules
      imported by the script and their paths, as well as modules that
      are missing or seem to be missing.

   run_script(pathname)

      Analyze the contents of the _pathname_ file, which must contain
      Python code.

   modules

      A dictionary mapping module names to modules. See Example usage
      of ModuleFinder.


Example usage of "ModuleFinder"
===============================

The script that is going to get analyzed later on (bacon.py):
>
   import re, itertools

   try:
       import baconhameggs
   except ImportError:
       pass

   try:
       import guido.python.ham
   except ImportError:
       pass
<
The script that will output the report of bacon.py:
>
   from modulefinder import ModuleFinder

   finder = ModuleFinder()
   finder.run_script('bacon.py')

   print('Loaded modules:')
   for name, mod in finder.modules.items():
       print('%s: ' % name, end='')
       print(','.join(list(mod.globalnames.keys())[:3]))

   print('-'*50)
   print('Modules not imported:')
   print('\n'.join(finder.badmodules.keys()))
<
Sample output (may vary depending on the architecture):
>
   Loaded modules:
   _types:
   copyreg:  _inverted_registry,_slotnames,__all__
   sre_compile:  isstring,_sre,_optimize_unicode
   _sre:
   sre_constants:  REPEAT_ONE,makedict,AT_END_LINE
   sys:
   re:  __module__,finditer,_expand
   itertools:
   __main__:  re,itertools,baconhameggs
   sre_parse:  _PATTERNENDERS,SRE_FLAG_UNICODE
   array:
   types:  __module__,IntType,TypeType
   ---------------------------------------------------
   Modules not imported:
   guido.python.ham
   baconhameggs
<
vim:tw=78:ts=8:ft=help:norl: