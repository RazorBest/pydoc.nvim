Python 3.11.9
*copyreg.pyx*                                 Last change: 2024 May 24

"copyreg" — Register "pickle" support functions
***********************************************

**Source code:** Lib/copyreg.py

======================================================================

The "copyreg" module offers a way to define functions used while
pickling specific objects.  The "pickle" and "copy" modules use those
functions when pickling/copying those objects.  The module provides
configuration information about object constructors which are not
classes. Such constructors may be factory functions or class
instances.

copyreg.constructor(object)

   Declares _object_ to be a valid constructor.  If _object_ is not
   callable (and hence not valid as a constructor), raises
   "TypeError".

copyreg.pickle(type, function, constructor_ob=None)

   Declares that _function_ should be used as a “reduction” function
   for objects of type _type_.  _function_ must return either a string
   or a tuple containing between two and six elements. See the
   "dispatch_table" for more details on the interface of _function_.

   The _constructor_ob_ parameter is a legacy feature and is now
   ignored, but if passed it must be a callable.

   Note that the "dispatch_table" attribute of a pickler object or
   subclass of "pickle.Pickler" can also be used for declaring
   reduction functions.


Example
=======

The example below would like to show how to register a pickle function
and how it will be used:

>>> import copyreg, copy, pickle
>>> class C:
...     def __init__(self, a):
...         self.a = a
...
>>> def pickle_c(c):
...     print("pickling a C instance...")
...     return C, (c.a,)
...
>>> copyreg.pickle(C, pickle_c)
>>> c = C(1)
>>> d = copy.copy(c)  
pickling a C instance...
>>> p = pickle.dumps(c)  
pickling a C instance...

vim:tw=78:ts=8:ft=help:norl: