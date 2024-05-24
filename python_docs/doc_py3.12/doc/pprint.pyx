Python 3.12.3
*pprint.pyx*                                  Last change: 2024 May 24

"pprint" — Data pretty printer
******************************

**Source code:** Lib/pprint.py

======================================================================

The "pprint" module provides a capability to “pretty-print” arbitrary
Python data structures in a form which can be used as input to the
interpreter. If the formatted structures include objects which are not
fundamental Python types, the representation may not be loadable.
This may be the case if objects such as files, sockets or classes are
included, as well as many other objects which are not representable as
Python literals.

The formatted representation keeps objects on a single line if it can,
and breaks them onto multiple lines if they don’t fit within the
allowed width. Construct "PrettyPrinter" objects explicitly if you
need to adjust the width constraint.

Dictionaries are sorted by key before the display is computed.

Changed in version 3.9: Added support for pretty-printing
"types.SimpleNamespace".

Changed in version 3.10: Added support for pretty-printing
"dataclasses.dataclass".


Functions
=========

pprint.pp(object, *args, sort_dicts=False, **kwargs)

   Prints the formatted representation of _object_ followed by a
   newline. If _sort_dicts_ is false (the default), dictionaries will
   be displayed with their keys in insertion order, otherwise the dict
   keys will be sorted. _args_ and _kwargs_ will be passed to
   "pprint()" as formatting parameters.

   >>> import pprint
   >>> stuff = ['spam', 'eggs', 'lumberjack', 'knights', 'ni']
   >>> stuff.insert(0, stuff)
   >>> pprint.pp(stuff)
   [<Recursion on list with id=...>,
    'spam',
    'eggs',
    'lumberjack',
    'knights',
    'ni']

   New in version 3.8.

pprint.pprint(object, stream=None, indent=1, width=80, depth=None, *, compact=False, sort_dicts=True, underscore_numbers=False)

   Prints the formatted representation of _object_ on _stream_,
   followed by a newline.  If _stream_ is "None", "sys.stdout" is
   used. This may be used in the interactive interpreter instead of
   the "print()" function for inspecting values (you can even reassign
   "print = pprint.pprint" for use within a scope).

   The configuration parameters _stream_, _indent_, _width_, _depth_,
   _compact_, _sort_dicts_ and _underscore_numbers_ are passed to the
   "PrettyPrinter" constructor and their meanings are as described in
   its documentation below.

   Note that _sort_dicts_ is "True" by default and you might want to
   use "pp()" instead where it is "False" by default.

pprint.pformat(object, indent=1, width=80, depth=None, *, compact=False, sort_dicts=True, underscore_numbers=False)

   Return the formatted representation of _object_ as a string.
   _indent_, _width_, _depth_, _compact_, _sort_dicts_ and
   _underscore_numbers_ are passed to the "PrettyPrinter" constructor
   as formatting parameters and their meanings are as described in its
   documentation below.

pprint.isreadable(object)

   Determine if the formatted representation of _object_ is
   “readable”, or can be used to reconstruct the value using "eval()".
   This always returns "False" for recursive objects.

   >>> pprint.isreadable(stuff)
   False

pprint.isrecursive(object)

   Determine if _object_ requires a recursive representation.  This
   function is subject to the same limitations as noted in
   "saferepr()" below and may raise an "RecursionError" if it fails to
   detect a recursive object.

pprint.saferepr(object)

   Return a string representation of _object_, protected against
   recursion in some common data structures, namely instances of
   "dict", "list" and "tuple" or subclasses whose "__repr__" has not
   been overridden.  If the representation of object exposes a
   recursive entry, the recursive reference will be represented as
   "<Recursion on typename with id=number>".  The representation is
   not otherwise formatted.

   >>> pprint.saferepr(stuff)
   "[<Recursion on list with id=...>, 'spam', 'eggs', 'lumberjack', 'knights', 'ni']"


PrettyPrinter Objects
=====================

This module defines one class:

class pprint.PrettyPrinter(indent=1, width=80, depth=None, stream=None, *, compact=False, sort_dicts=True, underscore_numbers=False)

   Construct a "PrettyPrinter" instance.  This constructor understands
   several keyword parameters.

   _stream_ (default "sys.stdout") is a _file-like object_ to which
   the output will be written by calling its "write()" method. If both
   _stream_ and "sys.stdout" are "None", then "pprint()" silently
   returns.

   Other values configure the manner in which nesting of complex data
   structures is displayed.

   _indent_ (default 1) specifies the amount of indentation added for
   each nesting level.

   _depth_ controls the number of nesting levels which may be printed;
   if the data structure being printed is too deep, the next contained
   level is replaced by "...".  By default, there is no constraint on
   the depth of the objects being formatted.

   _width_ (default 80) specifies the desired maximum number of
   characters per line in the output. If a structure cannot be
   formatted within the width constraint, a best effort will be made.

   _compact_ impacts the way that long sequences (lists, tuples, sets,
   etc) are formatted. If _compact_ is false (the default) then each
   item of a sequence will be formatted on a separate line.  If
   _compact_ is true, as many items as will fit within the _width_
   will be formatted on each output line.

   If _sort_dicts_ is true (the default), dictionaries will be
   formatted with their keys sorted, otherwise they will display in
   insertion order.

   If _underscore_numbers_ is true, integers will be formatted with
   the "_" character for a thousands separator, otherwise underscores
   are not displayed (the default).

   Changed in version 3.4: Added the _compact_ parameter.

   Changed in version 3.8: Added the _sort_dicts_ parameter.

   Changed in version 3.10: Added the _underscore_numbers_ parameter.

   Changed in version 3.11: No longer attempts to write to
   "sys.stdout" if it is "None".

   >>> import pprint
   >>> stuff = ['spam', 'eggs', 'lumberjack', 'knights', 'ni']
   >>> stuff.insert(0, stuff[:])
   >>> pp = pprint.PrettyPrinter(indent=4)
   >>> pp.pprint(stuff)
   [   ['spam', 'eggs', 'lumberjack', 'knights', 'ni'],
       'spam',
       'eggs',
       'lumberjack',
       'knights',
       'ni']
   >>> pp = pprint.PrettyPrinter(width=41, compact=True)
   >>> pp.pprint(stuff)
   [['spam', 'eggs', 'lumberjack',
     'knights', 'ni'],
    'spam', 'eggs', 'lumberjack', 'knights',
    'ni']
   >>> tup = ('spam', ('eggs', ('lumberjack', ('knights', ('ni', ('dead',
   ... ('parrot', ('fresh fruit',))))))))
   >>> pp = pprint.PrettyPrinter(depth=6)
   >>> pp.pprint(tup)
   ('spam', ('eggs', ('lumberjack', ('knights', ('ni', ('dead', (...)))))))

"PrettyPrinter" instances have the following methods:

PrettyPrinter.pformat(object)

   Return the formatted representation of _object_.  This takes into
   account the options passed to the "PrettyPrinter" constructor.

PrettyPrinter.pprint(object)

   Print the formatted representation of _object_ on the configured
   stream, followed by a newline.

The following methods provide the implementations for the
corresponding functions of the same names.  Using these methods on an
instance is slightly more efficient since new "PrettyPrinter" objects
don’t need to be created.

PrettyPrinter.isreadable(object)

   Determine if the formatted representation of the object is
   “readable,” or can be used to reconstruct the value using "eval()".
   Note that this returns "False" for recursive objects.  If the
   _depth_ parameter of the "PrettyPrinter" is set and the object is
   deeper than allowed, this returns "False".

PrettyPrinter.isrecursive(object)

   Determine if the object requires a recursive representation.

This method is provided as a hook to allow subclasses to modify the
way objects are converted to strings.  The default implementation uses
the internals of the "saferepr()" implementation.

PrettyPrinter.format(object, context, maxlevels, level)

   Returns three values: the formatted version of _object_ as a
   string, a flag indicating whether the result is readable, and a
   flag indicating whether recursion was detected.  The first argument
   is the object to be presented.  The second is a dictionary which
   contains the "id()" of objects that are part of the current
   presentation context (direct and indirect containers for _object_
   that are affecting the presentation) as the keys; if an object
   needs to be presented which is already represented in _context_,
   the third return value should be "True".  Recursive calls to the
   "format()" method should add additional entries for containers to
   this dictionary.  The third argument, _maxlevels_, gives the
   requested limit to recursion; this will be "0" if there is no
   requested limit.  This argument should be passed unmodified to
   recursive calls. The fourth argument, _level_, gives the current
   level; recursive calls should be passed a value less than that of
   the current call.


Example
=======

To demonstrate several uses of the "pp()" function and its parameters,
let’s fetch information about a project from PyPI:
>
   >>> import json
   >>> import pprint
   >>> from urllib.request import urlopen
   >>> with urlopen('https://pypi.org/pypi/sampleproject/json') as resp:
   ...     project_info = json.load(resp)['info']
<
In its basic form, "pp()" shows the whole object:
>
   >>> pprint.pp(project_info)
   {'author': 'The Python Packaging Authority',
    'author_email': 'pypa-dev@googlegroups.com',
    'bugtrack_url': None,
    'classifiers': ['Development Status :: 3 - Alpha',
                    'Intended Audience :: Developers',
                    'License :: OSI Approved :: MIT License',
                    'Programming Language :: Python :: 2',
                    'Programming Language :: Python :: 2.6',
                    'Programming Language :: Python :: 2.7',
                    'Programming Language :: Python :: 3',
                    'Programming Language :: Python :: 3.2',
                    'Programming Language :: Python :: 3.3',
                    'Programming Language :: Python :: 3.4',
                    'Topic :: Software Development :: Build Tools'],
    'description': 'A sample Python project\n'
                   '=======================\n'
                   '\n'
                   'This is the description file for the project.\n'
                   '\n'
                   'The file should use UTF-8 encoding and be written using '
                   'ReStructured Text. It\n'
                   'will be used to generate the project webpage on PyPI, and '
                   'should be written for\n'
                   'that purpose.\n'
                   '\n'
                   'Typical contents for this file would include an overview of '
                   'the project, basic\n'
                   'usage examples, etc. Generally, including the project '
                   'changelog in here is not\n'
                   'a good idea, although a simple "What\'s New" section for the '
                   'most recent version\n'
                   'may be appropriate.',
    'description_content_type': None,
    'docs_url': None,
    'download_url': 'UNKNOWN',
    'downloads': {'last_day': -1, 'last_month': -1, 'last_week': -1},
    'home_page': 'https://github.com/pypa/sampleproject',
    'keywords': 'sample setuptools development',
    'license': 'MIT',
    'maintainer': None,
    'maintainer_email': None,
    'name': 'sampleproject',
    'package_url': 'https://pypi.org/project/sampleproject/',
    'platform': 'UNKNOWN',
    'project_url': 'https://pypi.org/project/sampleproject/',
    'project_urls': {'Download': 'UNKNOWN',
                     'Homepage': 'https://github.com/pypa/sampleproject'},
    'release_url': 'https://pypi.org/project/sampleproject/1.2.0/',
    'requires_dist': None,
    'requires_python': None,
    'summary': 'A sample Python project',
    'version': '1.2.0'}
<
The result can be limited to a certain _depth_ (ellipsis is used for
deeper contents):
>
   >>> pprint.pp(project_info, depth=1)
   {'author': 'The Python Packaging Authority',
    'author_email': 'pypa-dev@googlegroups.com',
    'bugtrack_url': None,
    'classifiers': [...],
    'description': 'A sample Python project\n'
                   '=======================\n'
                   '\n'
                   'This is the description file for the project.\n'
                   '\n'
                   'The file should use UTF-8 encoding and be written using '
                   'ReStructured Text. It\n'
                   'will be used to generate the project webpage on PyPI, and '
                   'should be written for\n'
                   'that purpose.\n'
                   '\n'
                   'Typical contents for this file would include an overview of '
                   'the project, basic\n'
                   'usage examples, etc. Generally, including the project '
                   'changelog in here is not\n'
                   'a good idea, although a simple "What\'s New" section for the '
                   'most recent version\n'
                   'may be appropriate.',
    'description_content_type': None,
    'docs_url': None,
    'download_url': 'UNKNOWN',
    'downloads': {...},
    'home_page': 'https://github.com/pypa/sampleproject',
    'keywords': 'sample setuptools development',
    'license': 'MIT',
    'maintainer': None,
    'maintainer_email': None,
    'name': 'sampleproject',
    'package_url': 'https://pypi.org/project/sampleproject/',
    'platform': 'UNKNOWN',
    'project_url': 'https://pypi.org/project/sampleproject/',
    'project_urls': {...},
    'release_url': 'https://pypi.org/project/sampleproject/1.2.0/',
    'requires_dist': None,
    'requires_python': None,
    'summary': 'A sample Python project',
    'version': '1.2.0'}
<
Additionally, maximum character _width_ can be suggested. If a long
object cannot be split, the specified width will be exceeded:
>
   >>> pprint.pp(project_info, depth=1, width=60)
   {'author': 'The Python Packaging Authority',
    'author_email': 'pypa-dev@googlegroups.com',
    'bugtrack_url': None,
    'classifiers': [...],
    'description': 'A sample Python project\n'
                   '=======================\n'
                   '\n'
                   'This is the description file for the '
                   'project.\n'
                   '\n'
                   'The file should use UTF-8 encoding and be '
                   'written using ReStructured Text. It\n'
                   'will be used to generate the project '
                   'webpage on PyPI, and should be written '
                   'for\n'
                   'that purpose.\n'
                   '\n'
                   'Typical contents for this file would '
                   'include an overview of the project, '
                   'basic\n'
                   'usage examples, etc. Generally, including '
                   'the project changelog in here is not\n'
                   'a good idea, although a simple "What\'s '
                   'New" section for the most recent version\n'
                   'may be appropriate.',
    'description_content_type': None,
    'docs_url': None,
    'download_url': 'UNKNOWN',
    'downloads': {...},
    'home_page': 'https://github.com/pypa/sampleproject',
    'keywords': 'sample setuptools development',
    'license': 'MIT',
    'maintainer': None,
    'maintainer_email': None,
    'name': 'sampleproject',
    'package_url': 'https://pypi.org/project/sampleproject/',
    'platform': 'UNKNOWN',
    'project_url': 'https://pypi.org/project/sampleproject/',
    'project_urls': {...},
    'release_url': 'https://pypi.org/project/sampleproject/1.2.0/',
    'requires_dist': None,
    'requires_python': None,
    'summary': 'A sample Python project',
    'version': '1.2.0'}
<
vim:tw=78:ts=8:ft=help:norl: