Python 3.12.3
*importlib.resources.pyx*                     Last change: 2024 May 24

"importlib.resources" – Package resource reading, opening and access
********************************************************************

**Source code:** Lib/importlib/resources/__init__.py

======================================================================

New in version 3.7.

This module leverages Python’s import system to provide access to
_resources_ within _packages_.

“Resources” are file-like resources associated with a module or
package in Python. The resources may be contained directly in a
package, within a subdirectory contained in that package, or adjacent
to modules outside a package. Resources may be text or binary. As a
result, Python module sources (.py) of a package and compilation
artifacts (pycache) are technically de-facto resources of that
package. In practice, however, resources are primarily those non-
Python artifacts exposed specifically by the package author.

Resources can be opened or read in either binary or text mode.

Resources are roughly akin to files inside directories, though it’s
important to keep in mind that this is just a metaphor.  Resources and
packages **do not** have to exist as physical files and directories on
the file system: for example, a package and its resources can be
imported from a zip file using "zipimport".

Note:

  This module provides functionality similar to pkg_resources Basic
  Resource Access without the performance overhead of that package.
  This makes reading resources included in packages easier, with more
  stable and consistent semantics.The standalone backport of this
  module provides more information on using importlib.resources and
  migrating from pkg_resources to importlib.resources.

"Loaders" that wish to support resource reading should implement a
"get_resource_reader(fullname)" method as specified by
"importlib.resources.abc.ResourceReader".

class importlib.resources.Anchor

   Represents an anchor for resources, either a "module object" or a
   module name as a string. Defined as "Union[str, ModuleType]".

importlib.resources.files(anchor: Anchor | None = None)

   Returns a "Traversable" object representing the resource container
   (think directory) and its resources (think files). A Traversable
   may contain other containers (think subdirectories).

   _anchor_ is an optional "Anchor". If the anchor is a package,
   resources are resolved from that package. If a module, resources
   are resolved adjacent to that module (in the same package or the
   package root). If the anchor is omitted, the caller’s module is
   used.

   New in version 3.9.

   Changed in version 3.12: _package_ parameter was renamed to
   _anchor_. _anchor_ can now be a non-package module and if omitted
   will default to the caller’s module. _package_ is still accepted
   for compatibility but will raise a "DeprecationWarning". Consider
   passing the anchor positionally or using "importlib_resources >=
   5.10" for a compatible interface on older Pythons.

importlib.resources.as_file(traversable)

   Given a "Traversable" object representing a file or directory,
   typically from "importlib.resources.files()", return a context
   manager for use in a "with" statement. The context manager provides
   a "pathlib.Path" object.

   Exiting the context manager cleans up any temporary file or
   directory created when the resource was extracted from e.g. a zip
   file.

   Use "as_file" when the Traversable methods ("read_text", etc) are
   insufficient and an actual file or directory on the file system is
   required.

   New in version 3.9.

   Changed in version 3.12: Added support for _traversable_
   representing a directory.


Deprecated functions
====================

An older, deprecated set of functions is still available, but is
scheduled for removal in a future version of Python. The main drawback
of these functions is that they do not support directories: they
assume all resources are located directly within a _package_.

importlib.resources.Package

      Whenever a function accepts a "Package" argument, you can pass
      in either a "module object" or a module name as a string.  You
      can only pass module objects whose
      "__spec__.submodule_search_locations" is not "None".

      The "Package" type is defined as "Union[str, ModuleType]".

   Deprecated since version 3.12.

importlib.resources.Resource

   For _resource_ arguments of the functions below, you can pass in
   the name of a resource as a string or a "path-like object".

   The "Resource" type is defined as "Union[str, os.PathLike]".

importlib.resources.open_binary(package, resource)

   Open for binary reading the _resource_ within _package_.

   _package_ is either a name or a module object which conforms to the
   "Package" requirements.  _resource_ is the name of the resource to
   open within _package_; it may not contain path separators and it
   may not have sub-resources (i.e. it cannot be a directory).  This
   function returns a "typing.BinaryIO" instance, a binary I/O stream
   open for reading.

   Deprecated since version 3.11: Calls to this function can be
   replaced by:

>
      files(package).joinpath(resource).open('rb')
<
importlib.resources.open_text(package, resource, encoding='utf-8', errors='strict')

   Open for text reading the _resource_ within _package_.  By default,
   the resource is opened for reading as UTF-8.

   _package_ is either a name or a module object which conforms to the
   "Package" requirements.  _resource_ is the name of the resource to
   open within _package_; it may not contain path separators and it
   may not have sub-resources (i.e. it cannot be a directory).
   _encoding_ and _errors_ have the same meaning as with built-in
   "open()".

   This function returns a "typing.TextIO" instance, a text I/O stream
   open for reading.

   Deprecated since version 3.11: Calls to this function can be
   replaced by:

>
      files(package).joinpath(resource).open('r', encoding=encoding)
<
importlib.resources.read_binary(package, resource)

   Read and return the contents of the _resource_ within _package_ as
   "bytes".

   _package_ is either a name or a module object which conforms to the
   "Package" requirements.  _resource_ is the name of the resource to
   open within _package_; it may not contain path separators and it
   may not have sub-resources (i.e. it cannot be a directory).  This
   function returns the contents of the resource as "bytes".

   Deprecated since version 3.11: Calls to this function can be
   replaced by:

>
      files(package).joinpath(resource).read_bytes()
<
importlib.resources.read_text(package, resource, encoding='utf-8', errors='strict')

   Read and return the contents of _resource_ within _package_ as a
   "str". By default, the contents are read as strict UTF-8.

   _package_ is either a name or a module object which conforms to the
   "Package" requirements.  _resource_ is the name of the resource to
   open within _package_; it may not contain path separators and it
   may not have sub-resources (i.e. it cannot be a directory).
   _encoding_ and _errors_ have the same meaning as with built-in
   "open()".  This function returns the contents of the resource as
   "str".

   Deprecated since version 3.11: Calls to this function can be
   replaced by:

>
      files(package).joinpath(resource).read_text(encoding=encoding)
<
importlib.resources.path(package, resource)

   Return the path to the _resource_ as an actual file system path.
   This function returns a context manager for use in a "with"
   statement. The context manager provides a "pathlib.Path" object.

   Exiting the context manager cleans up any temporary file created
   when the resource needs to be extracted from e.g. a zip file.

   _package_ is either a name or a module object which conforms to the
   "Package" requirements.  _resource_ is the name of the resource to
   open within _package_; it may not contain path separators and it
   may not have sub-resources (i.e. it cannot be a directory).

   Deprecated since version 3.11: Calls to this function can be
   replaced using "as_file()":

>
      as_file(files(package).joinpath(resource))
<
importlib.resources.is_resource(package, name)

   Return "True" if there is a resource named _name_ in the package,
   otherwise "False". This function does not consider directories to
   be resources. _package_ is either a name or a module object which
   conforms to the "Package" requirements.

   Deprecated since version 3.11: Calls to this function can be
   replaced by:

>
      files(package).joinpath(resource).is_file()
<
importlib.resources.contents(package)

   Return an iterable over the named items within the package.  The
   iterable returns "str" resources (e.g. files) and non-resources
   (e.g. directories).  The iterable does not recurse into
   subdirectories.

   _package_ is either a name or a module object which conforms to the
   "Package" requirements.

   Deprecated since version 3.11: Calls to this function can be
   replaced by:

>
      (resource.name for resource in files(package).iterdir() if resource.is_file())
<
vim:tw=78:ts=8:ft=help:norl: