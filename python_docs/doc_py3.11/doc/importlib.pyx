Python 3.11.9
*importlib.pyx*                               Last change: 2024 May 24

"importlib" — The implementation of "import"
********************************************

New in version 3.1.

**Source code:** Lib/importlib/__init__.py

======================================================================


Introduction
============

The purpose of the "importlib" package is three-fold.

One is to provide the implementation of the "import" statement (and
thus, by extension, the "__import__()" function) in Python source
code. This provides an implementation of "import" which is portable to
any Python interpreter. This also provides an implementation which is
easier to comprehend than one implemented in a programming language
other than Python.

Two, the components to implement "import" are exposed in this package,
making it easier for users to create their own custom objects (known
generically as an _importer_) to participate in the import process.

Three, the package contains modules exposing additional functionality
for managing aspects of Python packages:

* "importlib.metadata" presents access to metadata from third-party
  distributions.

* "importlib.resources" provides routines for accessing non-code
  “resources” from Python packages.

See also:

  The import statement
     The language reference for the "import" statement.

  Packages specification
     Original specification of packages. Some semantics have changed
     since the writing of this document (e.g. redirecting based on
     "None" in "sys.modules").

  The "__import__()" function
     The "import" statement is syntactic sugar for this function.

  The initialization of the sys.path module search path
     The initialization of "sys.path".

  **PEP 235**
     Import on Case-Insensitive Platforms

  **PEP 263**
     Defining Python Source Code Encodings

  **PEP 302**
     New Import Hooks

  **PEP 328**
     Imports: Multi-Line and Absolute/Relative

  **PEP 366**
     Main module explicit relative imports

  **PEP 420**
     Implicit namespace packages

  **PEP 451**
     A ModuleSpec Type for the Import System

  **PEP 488**
     Elimination of PYO files

  **PEP 489**
     Multi-phase extension module initialization

  **PEP 552**
     Deterministic pycs

  **PEP 3120**
     Using UTF-8 as the Default Source Encoding

  **PEP 3147**
     PYC Repository Directories


Functions
=========

importlib.__import__(name, globals=None, locals=None, fromlist=(), level=0)

   An implementation of the built-in "__import__()" function.

   Note:

     Programmatic importing of modules should use "import_module()"
     instead of this function.

importlib.import_module(name, package=None)

   Import a module. The _name_ argument specifies what module to
   import in absolute or relative terms (e.g. either "pkg.mod" or
   "..mod"). If the name is specified in relative terms, then the
   _package_ argument must be set to the name of the package which is
   to act as the anchor for resolving the package name (e.g.
   "import_module('..mod', 'pkg.subpkg')" will import "pkg.mod").

   The "import_module()" function acts as a simplifying wrapper around
   "importlib.__import__()". This means all semantics of the function
   are derived from "importlib.__import__()". The most important
   difference between these two functions is that "import_module()"
   returns the specified package or module (e.g. "pkg.mod"), while
   "__import__()" returns the top-level package or module (e.g.
   "pkg").

   If you are dynamically importing a module that was created since
   the interpreter began execution (e.g., created a Python source
   file), you may need to call "invalidate_caches()" in order for the
   new module to be noticed by the import system.

   Changed in version 3.3: Parent packages are automatically imported.

importlib.find_loader(name, path=None)

   Find the loader for a module, optionally within the specified
   _path_. If the module is in "sys.modules", then
   "sys.modules[name].__loader__" is returned (unless the loader would
   be "None" or is not set, in which case "ValueError" is raised).
   Otherwise a search using "sys.meta_path" is done. "None" is
   returned if no loader is found.

   A dotted name does not have its parents implicitly imported as that
   requires loading them and that may not be desired. To properly
   import a submodule you will need to import all parent packages of
   the submodule and use the correct argument to _path_.

   New in version 3.3.

   Changed in version 3.4: If "__loader__" is not set, raise
   "ValueError", just like when the attribute is set to "None".

   Deprecated since version 3.4: Use "importlib.util.find_spec()"
   instead.

importlib.invalidate_caches()

   Invalidate the internal caches of finders stored at
   "sys.meta_path". If a finder implements "invalidate_caches()" then
   it will be called to perform the invalidation.  This function
   should be called if any modules are created/installed while your
   program is running to guarantee all finders will notice the new
   module’s existence.

   New in version 3.3.

   Changed in version 3.10: Namespace packages created/installed in a
   different "sys.path" location after the same namespace was already
   imported are noticed.

importlib.reload(module)

   Reload a previously imported _module_.  The argument must be a
   module object, so it must have been successfully imported before.
   This is useful if you have edited the module source file using an
   external editor and want to try out the new version without leaving
   the Python interpreter.  The return value is the module object
   (which can be different if re-importing causes a different object
   to be placed in "sys.modules").

   When "reload()" is executed:

   * Python module’s code is recompiled and the module-level code re-
     executed, defining a new set of objects which are bound to names
     in the module’s dictionary by reusing the _loader_ which
     originally loaded the module.  The "init" function of extension
     modules is not called a second time.

   * As with all other objects in Python the old objects are only
     reclaimed after their reference counts drop to zero.

   * The names in the module namespace are updated to point to any new
     or changed objects.

   * Other references to the old objects (such as names external to
     the module) are not rebound to refer to the new objects and must
     be updated in each namespace where they occur if that is desired.

   There are a number of other caveats:

   When a module is reloaded, its dictionary (containing the module’s
   global variables) is retained.  Redefinitions of names will
   override the old definitions, so this is generally not a problem.
   If the new version of a module does not define a name that was
   defined by the old version, the old definition remains.  This
   feature can be used to the module’s advantage if it maintains a
   global table or cache of objects — with a "try" statement it can
   test for the table’s presence and skip its initialization if
   desired:
>
      try:
          cache
      except NameError:
          cache = {}
<
   It is generally not very useful to reload built-in or dynamically
   loaded modules.  Reloading "sys", "__main__", "builtins" and other
   key modules is not recommended.  In many cases extension modules
   are not designed to be initialized more than once, and may fail in
   arbitrary ways when reloaded.

   If a module imports objects from another module using "from" …
   "import" …, calling "reload()" for the other module does not
   redefine the objects imported from it — one way around this is to
   re-execute the "from" statement, another is to use "import" and
   qualified names (_module.name_) instead.

   If a module instantiates instances of a class, reloading the module
   that defines the class does not affect the method definitions of
   the instances — they continue to use the old class definition.  The
   same is true for derived classes.

   New in version 3.4.

   Changed in version 3.7: "ModuleNotFoundError" is raised when the
   module being reloaded lacks a "ModuleSpec".


"importlib.abc" – Abstract base classes related to import
=========================================================

**Source code:** Lib/importlib/abc.py

======================================================================

The "importlib.abc" module contains all of the core abstract base
classes used by "import". Some subclasses of the core abstract base
classes are also provided to help in implementing the core ABCs.

ABC hierarchy:
>
   object
    +-- Finder (deprecated)
    +-- MetaPathFinder
    +-- PathEntryFinder
    +-- Loader
         +-- ResourceLoader --------+
         +-- InspectLoader          |
              +-- ExecutionLoader --+
                                    +-- FileLoader
                                    +-- SourceLoader
<
class importlib.abc.Finder

   An abstract base class representing a _finder_.

   Deprecated since version 3.3: Use "MetaPathFinder" or
   "PathEntryFinder" instead.

   abstractmethod find_module(fullname, path=None)

      An abstract method for finding a _loader_ for the specified
      module.  Originally specified in **PEP 302**, this method was
      meant for use in "sys.meta_path" and in the path-based import
      subsystem.

      Changed in version 3.4: Returns "None" when called instead of
      raising "NotImplementedError".

      Deprecated since version 3.10: Implement
      "MetaPathFinder.find_spec()" or "PathEntryFinder.find_spec()"
      instead.

class importlib.abc.MetaPathFinder

   An abstract base class representing a _meta path finder_.

   New in version 3.3.

   Changed in version 3.10: No longer a subclass of "Finder".

   find_spec(fullname, path, target=None)

      An abstract method for finding a _spec_ for the specified
      module.  If this is a top-level import, _path_ will be "None".
      Otherwise, this is a search for a subpackage or module and
      _path_ will be the value of "__path__" from the parent package.
      If a spec cannot be found, "None" is returned. When passed in,
      "target" is a module object that the finder may use to make a
      more educated guess about what spec to return.
      "importlib.util.spec_from_loader()" may be useful for
      implementing concrete "MetaPathFinders".

      New in version 3.4.

   find_module(fullname, path)

      A legacy method for finding a _loader_ for the specified module.
      If this is a top-level import, _path_ will be "None". Otherwise,
      this is a search for a subpackage or module and _path_ will be
      the value of "__path__" from the parent package. If a loader
      cannot be found, "None" is returned.

      If "find_spec()" is defined, backwards-compatible functionality
      is provided.

      Changed in version 3.4: Returns "None" when called instead of
      raising "NotImplementedError". Can use "find_spec()" to provide
      functionality.

      Deprecated since version 3.4: Use "find_spec()" instead.

   invalidate_caches()

      An optional method which, when called, should invalidate any
      internal cache used by the finder. Used by
      "importlib.invalidate_caches()" when invalidating the caches of
      all finders on "sys.meta_path".

      Changed in version 3.4: Returns "None" when called instead of
      "NotImplemented".

class importlib.abc.PathEntryFinder

   An abstract base class representing a _path entry finder_.  Though
   it bears some similarities to "MetaPathFinder", "PathEntryFinder"
   is meant for use only within the path-based import subsystem
   provided by "importlib.machinery.PathFinder".

   New in version 3.3.

   Changed in version 3.10: No longer a subclass of "Finder".

   find_spec(fullname, target=None)

      An abstract method for finding a _spec_ for the specified
      module.  The finder will search for the module only within the
      _path entry_ to which it is assigned.  If a spec cannot be
      found, "None" is returned.  When passed in, "target" is a module
      object that the finder may use to make a more educated guess
      about what spec to return. "importlib.util.spec_from_loader()"
      may be useful for implementing concrete "PathEntryFinders".

      New in version 3.4.

   find_loader(fullname)

      A legacy method for finding a _loader_ for the specified module.
      Returns a 2-tuple of "(loader, portion)" where "portion" is a
      sequence of file system locations contributing to part of a
      namespace package. The loader may be "None" while specifying
      "portion" to signify the contribution of the file system
      locations to a namespace package. An empty list can be used for
      "portion" to signify the loader is not part of a namespace
      package. If "loader" is "None" and "portion" is the empty list
      then no loader or location for a namespace package were found
      (i.e. failure to find anything for the module).

      If "find_spec()" is defined then backwards-compatible
      functionality is provided.

      Changed in version 3.4: Returns "(None, [])" instead of raising
      "NotImplementedError". Uses "find_spec()" when available to
      provide functionality.

      Deprecated since version 3.4: Use "find_spec()" instead.

   find_module(fullname)

      A concrete implementation of "Finder.find_module()" which is
      equivalent to "self.find_loader(fullname)[0]".

      Deprecated since version 3.4: Use "find_spec()" instead.

   invalidate_caches()

      An optional method which, when called, should invalidate any
      internal cache used by the finder. Used by
      "importlib.machinery.PathFinder.invalidate_caches()" when
      invalidating the caches of all cached finders.

class importlib.abc.Loader

   An abstract base class for a _loader_. See **PEP 302** for the
   exact definition for a loader.

   Loaders that wish to support resource reading should implement a
   "get_resource_reader()" method as specified by
   "importlib.resources.abc.ResourceReader".

   Changed in version 3.7: Introduced the optional
   "get_resource_reader()" method.

   create_module(spec)

      A method that returns the module object to use when importing a
      module.  This method may return "None", indicating that default
      module creation semantics should take place.

      New in version 3.4.

      Changed in version 3.6: This method is no longer optional when
      "exec_module()" is defined.

   exec_module(module)

      An abstract method that executes the module in its own namespace
      when a module is imported or reloaded.  The module should
      already be initialized when "exec_module()" is called.  When
      this method exists, "create_module()" must be defined.

      New in version 3.4.

      Changed in version 3.6: "create_module()" must also be defined.

   load_module(fullname)

      A legacy method for loading a module.  If the module cannot be
      loaded, "ImportError" is raised, otherwise the loaded module is
      returned.

      If the requested module already exists in "sys.modules", that
      module should be used and reloaded. Otherwise the loader should
      create a new module and insert it into "sys.modules" before any
      loading begins, to prevent recursion from the import.  If the
      loader inserted a module and the load fails, it must be removed
      by the loader from "sys.modules"; modules already in
      "sys.modules" before the loader began execution should be left
      alone (see "importlib.util.module_for_loader()").

      The loader should set several attributes on the module (note
      that some of these attributes can change when a module is
      reloaded):

      * "__name__"
           The module’s fully qualified name. It is "'__main__'" for
           an executed module.

      * "__file__"
           The location the _loader_ used to load the module. For
           example, for modules loaded from a .py file this is the
           filename. It is not set on all modules (e.g. built-in
           modules).

      * "__cached__"
           The filename of a compiled version of the module’s code. It
           is not set on all modules (e.g. built-in modules).

      * "__path__"
           The list of locations where the package’s submodules will
           be found. Most of the time this is a single directory. The
           import system passes this attribute to "__import__()" and
           to finders in the same way as "sys.path" but just for the
           package. It is not set on non-package modules so it can be
           used as an indicator that the module is a package.

      * "__package__"
           The fully qualified name of the package the module is in
           (or the empty string for a top-level module). If the module
           is a package then this is the same as "__name__".

      * "__loader__"
           The _loader_ used to load the module.

      When "exec_module()" is available then backwards-compatible
      functionality is provided.

      Changed in version 3.4: Raise "ImportError" when called instead
      of "NotImplementedError".  Functionality provided when
      "exec_module()" is available.

      Deprecated since version 3.4: The recommended API for loading a
      module is "exec_module()" (and "create_module()").  Loaders
      should implement it instead of "load_module()".  The import
      machinery takes care of all the other responsibilities of
      "load_module()" when "exec_module()" is implemented.

   module_repr(module)

      A legacy method which when implemented calculates and returns
      the given module’s representation, as a string.  The module
      type’s default "__repr__()" will use the result of this method
      as appropriate.

      New in version 3.3.

      Changed in version 3.4: Made optional instead of an
      abstractmethod.

      Deprecated since version 3.4: The import machinery now takes
      care of this automatically.

class importlib.abc.ResourceLoader

   An abstract base class for a _loader_ which implements the optional
   **PEP 302** protocol for loading arbitrary resources from the
   storage back-end.

   Deprecated since version 3.7: This ABC is deprecated in favour of
   supporting resource loading through
   "importlib.resources.abc.ResourceReader".

   abstractmethod get_data(path)

      An abstract method to return the bytes for the data located at
      _path_. Loaders that have a file-like storage back-end that
      allows storing arbitrary data can implement this abstract method
      to give direct access to the data stored. "OSError" is to be
      raised if the _path_ cannot be found. The _path_ is expected to
      be constructed using a module’s "__file__" attribute or an item
      from a package’s "__path__".

      Changed in version 3.4: Raises "OSError" instead of
      "NotImplementedError".

class importlib.abc.InspectLoader

   An abstract base class for a _loader_ which implements the optional
   **PEP 302** protocol for loaders that inspect modules.

   get_code(fullname)

      Return the code object for a module, or "None" if the module
      does not have a code object (as would be the case, for example,
      for a built-in module).  Raise an "ImportError" if loader cannot
      find the requested module.

      Note:

        While the method has a default implementation, it is suggested
        that it be overridden if possible for performance.

      Changed in version 3.4: No longer abstract and a concrete
      implementation is provided.

   abstractmethod get_source(fullname)

      An abstract method to return the source of a module. It is
      returned as a text string using _universal newlines_,
      translating all recognized line separators into "'\n'"
      characters.  Returns "None" if no source is available (e.g. a
      built-in module). Raises "ImportError" if the loader cannot find
      the module specified.

      Changed in version 3.4: Raises "ImportError" instead of
      "NotImplementedError".

   is_package(fullname)

      An optional method to return a true value if the module is a
      package, a false value otherwise. "ImportError" is raised if the
      _loader_ cannot find the module.

      Changed in version 3.4: Raises "ImportError" instead of
      "NotImplementedError".

   static source_to_code(data, path='<string>')

      Create a code object from Python source.

      The _data_ argument can be whatever the "compile()" function
      supports (i.e. string or bytes). The _path_ argument should be
      the “path” to where the source code originated from, which can
      be an abstract concept (e.g. location in a zip file).

      With the subsequent code object one can execute it in a module
      by running "exec(code, module.__dict__)".

      New in version 3.4.

      Changed in version 3.5: Made the method static.

   exec_module(module)

      Implementation of "Loader.exec_module()".

      New in version 3.4.

   load_module(fullname)

      Implementation of "Loader.load_module()".

      Deprecated since version 3.4: use "exec_module()" instead.

class importlib.abc.ExecutionLoader

   An abstract base class which inherits from "InspectLoader" that,
   when implemented, helps a module to be executed as a script. The
   ABC represents an optional **PEP 302** protocol.

   abstractmethod get_filename(fullname)

      An abstract method that is to return the value of "__file__" for
      the specified module. If no path is available, "ImportError" is
      raised.

      If source code is available, then the method should return the
      path to the source file, regardless of whether a bytecode was
      used to load the module.

      Changed in version 3.4: Raises "ImportError" instead of
      "NotImplementedError".

class importlib.abc.FileLoader(fullname, path)

   An abstract base class which inherits from "ResourceLoader" and
   "ExecutionLoader", providing concrete implementations of
   "ResourceLoader.get_data()" and "ExecutionLoader.get_filename()".

   The _fullname_ argument is a fully resolved name of the module the
   loader is to handle. The _path_ argument is the path to the file
   for the module.

   New in version 3.3.

   name

      The name of the module the loader can handle.

   path

      Path to the file of the module.

   load_module(fullname)

      Calls super’s "load_module()".

      Deprecated since version 3.4: Use "Loader.exec_module()"
      instead.

   abstractmethod get_filename(fullname)

      Returns "path".

   abstractmethod get_data(path)

      Reads _path_ as a binary file and returns the bytes from it.

class importlib.abc.SourceLoader

   An abstract base class for implementing source (and optionally
   bytecode) file loading. The class inherits from both
   "ResourceLoader" and "ExecutionLoader", requiring the
   implementation of:

   * "ResourceLoader.get_data()"

   * "ExecutionLoader.get_filename()"
        Should only return the path to the source file; sourceless
        loading is not supported.

   The abstract methods defined by this class are to add optional
   bytecode file support. Not implementing these optional methods (or
   causing them to raise "NotImplementedError") causes the loader to
   only work with source code. Implementing the methods allows the
   loader to work with source _and_ bytecode files; it does not allow
   for _sourceless_ loading where only bytecode is provided.  Bytecode
   files are an optimization to speed up loading by removing the
   parsing step of Python’s compiler, and so no bytecode-specific API
   is exposed.

   path_stats(path)

      Optional abstract method which returns a "dict" containing
      metadata about the specified path.  Supported dictionary keys
      are:

      * "'mtime'" (mandatory): an integer or floating-point number
        representing the modification time of the source code;

      * "'size'" (optional): the size in bytes of the source code.

      Any other keys in the dictionary are ignored, to allow for
      future extensions. If the path cannot be handled, "OSError" is
      raised.

      New in version 3.3.

      Changed in version 3.4: Raise "OSError" instead of
      "NotImplementedError".

   path_mtime(path)

      Optional abstract method which returns the modification time for
      the specified path.

      Deprecated since version 3.3: This method is deprecated in
      favour of "path_stats()".  You don’t have to implement it, but
      it is still available for compatibility purposes. Raise
      "OSError" if the path cannot be handled.

      Changed in version 3.4: Raise "OSError" instead of
      "NotImplementedError".

   set_data(path, data)

      Optional abstract method which writes the specified bytes to a
      file path. Any intermediate directories which do not exist are
      to be created automatically.

      When writing to the path fails because the path is read-only
      ("errno.EACCES"/"PermissionError"), do not propagate the
      exception.

      Changed in version 3.4: No longer raises "NotImplementedError"
      when called.

   get_code(fullname)

      Concrete implementation of "InspectLoader.get_code()".

   exec_module(module)

      Concrete implementation of "Loader.exec_module()".

      New in version 3.4.

   load_module(fullname)

      Concrete implementation of "Loader.load_module()".

      Deprecated since version 3.4: Use "exec_module()" instead.

   get_source(fullname)

      Concrete implementation of "InspectLoader.get_source()".

   is_package(fullname)

      Concrete implementation of "InspectLoader.is_package()". A
      module is determined to be a package if its file path (as
      provided by "ExecutionLoader.get_filename()") is a file named
      "__init__" when the file extension is removed **and** the module
      name itself does not end in "__init__".


"importlib.machinery" – Importers and path hooks
================================================

**Source code:** Lib/importlib/machinery.py

======================================================================

This module contains the various objects that help "import" find and
load modules.

importlib.machinery.SOURCE_SUFFIXES

   A list of strings representing the recognized file suffixes for
   source modules.

   New in version 3.3.

importlib.machinery.DEBUG_BYTECODE_SUFFIXES

   A list of strings representing the file suffixes for non-optimized
   bytecode modules.

   New in version 3.3.

   Deprecated since version 3.5: Use "BYTECODE_SUFFIXES" instead.

importlib.machinery.OPTIMIZED_BYTECODE_SUFFIXES

   A list of strings representing the file suffixes for optimized
   bytecode modules.

   New in version 3.3.

   Deprecated since version 3.5: Use "BYTECODE_SUFFIXES" instead.

importlib.machinery.BYTECODE_SUFFIXES

   A list of strings representing the recognized file suffixes for
   bytecode modules (including the leading dot).

   New in version 3.3.

   Changed in version 3.5: The value is no longer dependent on
   "__debug__".

importlib.machinery.EXTENSION_SUFFIXES

   A list of strings representing the recognized file suffixes for
   extension modules.

   New in version 3.3.

importlib.machinery.all_suffixes()

   Returns a combined list of strings representing all file suffixes
   for modules recognized by the standard import machinery. This is a
   helper for code which simply needs to know if a filesystem path
   potentially refers to a module without needing any details on the
   kind of module (for example, "inspect.getmodulename()").

   New in version 3.3.

class importlib.machinery.BuiltinImporter

   An _importer_ for built-in modules. All known built-in modules are
   listed in "sys.builtin_module_names". This class implements the
   "importlib.abc.MetaPathFinder" and "importlib.abc.InspectLoader"
   ABCs.

   Only class methods are defined by this class to alleviate the need
   for instantiation.

   Changed in version 3.5: As part of **PEP 489**, the builtin
   importer now implements "Loader.create_module()" and
   "Loader.exec_module()"

class importlib.machinery.FrozenImporter

   An _importer_ for frozen modules. This class implements the
   "importlib.abc.MetaPathFinder" and "importlib.abc.InspectLoader"
   ABCs.

   Only class methods are defined by this class to alleviate the need
   for instantiation.

   Changed in version 3.4: Gained "create_module()" and
   "exec_module()" methods.

class importlib.machinery.WindowsRegistryFinder

   _Finder_ for modules declared in the Windows registry.  This class
   implements the "importlib.abc.MetaPathFinder" ABC.

   Only class methods are defined by this class to alleviate the need
   for instantiation.

   New in version 3.3.

   Deprecated since version 3.6: Use "site" configuration instead.
   Future versions of Python may not enable this finder by default.

class importlib.machinery.PathFinder

   A _Finder_ for "sys.path" and package "__path__" attributes. This
   class implements the "importlib.abc.MetaPathFinder" ABC.

   Only class methods are defined by this class to alleviate the need
   for instantiation.

   classmethod find_spec(fullname, path=None, target=None)

      Class method that attempts to find a _spec_ for the module
      specified by _fullname_ on "sys.path" or, if defined, on _path_.
      For each path entry that is searched, "sys.path_importer_cache"
      is checked. If a non-false object is found then it is used as
      the _path entry finder_ to look for the module being searched
      for. If no entry is found in "sys.path_importer_cache", then
      "sys.path_hooks" is searched for a finder for the path entry
      and, if found, is stored in "sys.path_importer_cache" along with
      being queried about the module. If no finder is ever found then
      "None" is both stored in the cache and returned.

      New in version 3.4.

      Changed in version 3.5: If the current working directory –
      represented by an empty string – is no longer valid then "None"
      is returned but no value is cached in "sys.path_importer_cache".

   classmethod find_module(fullname, path=None)

      A legacy wrapper around "find_spec()".

      Deprecated since version 3.4: Use "find_spec()" instead.

   classmethod invalidate_caches()

      Calls "importlib.abc.PathEntryFinder.invalidate_caches()" on all
      finders stored in "sys.path_importer_cache" that define the
      method. Otherwise entries in "sys.path_importer_cache" set to
      "None" are deleted.

      Changed in version 3.7: Entries of "None" in
      "sys.path_importer_cache" are deleted.

   Changed in version 3.4: Calls objects in "sys.path_hooks" with the
   current working directory for "''" (i.e. the empty string).

class importlib.machinery.FileFinder(path, *loader_details)

   A concrete implementation of "importlib.abc.PathEntryFinder" which
   caches results from the file system.

   The _path_ argument is the directory for which the finder is in
   charge of searching.

   The _loader_details_ argument is a variable number of 2-item tuples
   each containing a loader and a sequence of file suffixes the loader
   recognizes. The loaders are expected to be callables which accept
   two arguments of the module’s name and the path to the file found.

   The finder will cache the directory contents as necessary, making
   stat calls for each module search to verify the cache is not
   outdated. Because cache staleness relies upon the granularity of
   the operating system’s state information of the file system, there
   is a potential race condition of searching for a module, creating a
   new file, and then searching for the module the new file
   represents. If the operations happen fast enough to fit within the
   granularity of stat calls, then the module search will fail. To
   prevent this from happening, when you create a module dynamically,
   make sure to call "importlib.invalidate_caches()".

   New in version 3.3.

   path

      The path the finder will search in.

   find_spec(fullname, target=None)

      Attempt to find the spec to handle _fullname_ within "path".

      New in version 3.4.

   find_loader(fullname)

      Attempt to find the loader to handle _fullname_ within "path".

      Deprecated since version 3.10: Use "find_spec()" instead.

   invalidate_caches()

      Clear out the internal cache.

   classmethod path_hook(*loader_details)

      A class method which returns a closure for use on
      "sys.path_hooks". An instance of "FileFinder" is returned by the
      closure using the path argument given to the closure directly
      and _loader_details_ indirectly.

      If the argument to the closure is not an existing directory,
      "ImportError" is raised.

class importlib.machinery.SourceFileLoader(fullname, path)

   A concrete implementation of "importlib.abc.SourceLoader" by
   subclassing "importlib.abc.FileLoader" and providing some concrete
   implementations of other methods.

   New in version 3.3.

   name

      The name of the module that this loader will handle.

   path

      The path to the source file.

   is_package(fullname)

      Return "True" if "path" appears to be for a package.

   path_stats(path)

      Concrete implementation of
      "importlib.abc.SourceLoader.path_stats()".

   set_data(path, data)

      Concrete implementation of
      "importlib.abc.SourceLoader.set_data()".

   load_module(name=None)

      Concrete implementation of "importlib.abc.Loader.load_module()"
      where specifying the name of the module to load is optional.

      Deprecated since version 3.6: Use
      "importlib.abc.Loader.exec_module()" instead.

class importlib.machinery.SourcelessFileLoader(fullname, path)

   A concrete implementation of "importlib.abc.FileLoader" which can
   import bytecode files (i.e. no source code files exist).

   Please note that direct use of bytecode files (and thus not source
   code files) inhibits your modules from being usable by all Python
   implementations or new versions of Python which change the bytecode
   format.

   New in version 3.3.

   name

      The name of the module the loader will handle.

   path

      The path to the bytecode file.

   is_package(fullname)

      Determines if the module is a package based on "path".

   get_code(fullname)

      Returns the code object for "name" created from "path".

   get_source(fullname)

      Returns "None" as bytecode files have no source when this loader
      is used.

   load_module(name=None)

   Concrete implementation of "importlib.abc.Loader.load_module()"
   where specifying the name of the module to load is optional.

   Deprecated since version 3.6: Use
   "importlib.abc.Loader.exec_module()" instead.

class importlib.machinery.ExtensionFileLoader(fullname, path)

   A concrete implementation of "importlib.abc.ExecutionLoader" for
   extension modules.

   The _fullname_ argument specifies the name of the module the loader
   is to support. The _path_ argument is the path to the extension
   module’s file.

   New in version 3.3.

   name

      Name of the module the loader supports.

   path

      Path to the extension module.

   create_module(spec)

      Creates the module object from the given specification in
      accordance with **PEP 489**.

      New in version 3.5.

   exec_module(module)

      Initializes the given module object in accordance with **PEP
      489**.

      New in version 3.5.

   is_package(fullname)

      Returns "True" if the file path points to a package’s "__init__"
      module based on "EXTENSION_SUFFIXES".

   get_code(fullname)

      Returns "None" as extension modules lack a code object.

   get_source(fullname)

      Returns "None" as extension modules do not have source code.

   get_filename(fullname)

      Returns "path".

      New in version 3.4.

class importlib.machinery.NamespaceLoader(name, path, path_finder)

   A concrete implementation of "importlib.abc.InspectLoader" for
   namespace packages.  This is an alias for a private class and is
   only made public for introspecting the "__loader__" attribute on
   namespace packages:
>
      >>> from importlib.machinery import NamespaceLoader
      >>> import my_namespace
      >>> isinstance(my_namespace.__loader__, NamespaceLoader)
      True
      >>> import importlib.abc
      >>> isinstance(my_namespace.__loader__, importlib.abc.Loader)
      True
<
   New in version 3.11.

class importlib.machinery.ModuleSpec(name, loader, *, origin=None, loader_state=None, is_package=None)

   A specification for a module’s import-system-related state.  This
   is typically exposed as the module’s "__spec__" attribute.  In the
   descriptions below, the names in parentheses give the corresponding
   attribute available directly on the module object, e.g.
   "module.__spec__.origin == module.__file__".  Note, however, that
   while the _values_ are usually equivalent, they can differ since
   there is no synchronization between the two objects.  For example,
   it is possible to update the module’s "__file__" at runtime and
   this will not be automatically reflected in the module’s
   "__spec__.origin", and vice versa.

   New in version 3.4.

   name

   ("__name__")

   The module’s fully qualified name. The _finder_ should always set
   this attribute to a non-empty string.

   loader

   ("__loader__")

   The _loader_ used to load the module. The _finder_ should always
   set this attribute.

   origin

   ("__file__")

   The location the _loader_ should use to load the module. For
   example, for modules loaded from a .py file this is the filename.
   The _finder_ should always set this attribute to a meaningful value
   for the _loader_ to use.  In the uncommon case that there is not
   one (like for namespace packages), it should be set to "None".

   submodule_search_locations

   ("__path__")

   The list of locations where the package’s submodules will be found.
   Most of the time this is a single directory. The _finder_ should
   set this attribute to a list, even an empty one, to indicate to the
   import system that the module is a package.  It should be set to
   "None" for non-package modules.  It is set automatically later to a
   special object for namespace packages.

   loader_state

   The _finder_ may set this attribute to an object containing
   additional, module-specific data to use when loading the module.
   Otherwise it should be set to "None".

   cached

   ("__cached__")

   The filename of a compiled version of the module’s code. The
   _finder_ should always set this attribute but it may be "None" for
   modules that do not need compiled code stored.

   parent

   ("__package__")

   (Read-only) The fully qualified name of the package the module is
   in (or the empty string for a top-level module). If the module is a
   package then this is the same as "name".

   has_location

   "True" if the spec’s "origin" refers to a loadable location,
      "False" otherwise.  This value impacts how "origin" is
      interpreted and how the module’s "__file__" is populated.


"importlib.util" – Utility code for importers
=============================================

**Source code:** Lib/importlib/util.py

======================================================================

This module contains the various objects that help in the construction
of an _importer_.

importlib.util.MAGIC_NUMBER

   The bytes which represent the bytecode version number. If you need
   help with loading/writing bytecode then consider
   "importlib.abc.SourceLoader".

   New in version 3.4.

importlib.util.cache_from_source(path, debug_override=None, *, optimization=None)

   Return the **PEP 3147**/**PEP 488** path to the byte-compiled file
   associated with the source _path_.  For example, if _path_ is
   "/foo/bar/baz.py" the return value would be
   "/foo/bar/__pycache__/baz.cpython-32.pyc" for Python 3.2. The
   "cpython-32" string comes from the current magic tag (see
   "get_tag()"; if "sys.implementation.cache_tag" is not defined then
   "NotImplementedError" will be raised).

   The _optimization_ parameter is used to specify the optimization
   level of the bytecode file. An empty string represents no
   optimization, so "/foo/bar/baz.py" with an _optimization_ of "''"
   will result in a bytecode path of
   "/foo/bar/__pycache__/baz.cpython-32.pyc". "None" causes the
   interpreter’s optimization level to be used. Any other value’s
   string representation is used, so "/foo/bar/baz.py" with an
   _optimization_ of "2" will lead to the bytecode path of
   "/foo/bar/__pycache__/baz.cpython-32.opt-2.pyc". The string
   representation of _optimization_ can only be alphanumeric, else
   "ValueError" is raised.

   The _debug_override_ parameter is deprecated and can be used to
   override the system’s value for "__debug__". A "True" value is the
   equivalent of setting _optimization_ to the empty string. A "False"
   value is the same as setting _optimization_ to "1". If both
   _debug_override_ an _optimization_ are not "None" then "TypeError"
   is raised.

   New in version 3.4.

   Changed in version 3.5: The _optimization_ parameter was added and
   the _debug_override_ parameter was deprecated.

   Changed in version 3.6: Accepts a _path-like object_.

importlib.util.source_from_cache(path)

   Given the _path_ to a **PEP 3147** file name, return the associated
   source code file path.  For example, if _path_ is
   "/foo/bar/__pycache__/baz.cpython-32.pyc" the returned path would
   be "/foo/bar/baz.py".  _path_ need not exist, however if it does
   not conform to **PEP 3147** or **PEP 488** format, a "ValueError"
   is raised. If "sys.implementation.cache_tag" is not defined,
   "NotImplementedError" is raised.

   New in version 3.4.

   Changed in version 3.6: Accepts a _path-like object_.

importlib.util.decode_source(source_bytes)

   Decode the given bytes representing source code and return it as a
   string with universal newlines (as required by
   "importlib.abc.InspectLoader.get_source()").

   New in version 3.4.

importlib.util.resolve_name(name, package)

   Resolve a relative module name to an absolute one.

   If  **name** has no leading dots, then **name** is simply returned.
   This allows for usage such as "importlib.util.resolve_name('sys',
   __spec__.parent)" without doing a check to see if the **package**
   argument is needed.

   "ImportError" is raised if **name** is a relative module name but
   **package** is a false value (e.g. "None" or the empty string).
   "ImportError" is also raised if a relative name would escape its
   containing package (e.g. requesting "..bacon" from within the
   "spam" package).

   New in version 3.3.

   Changed in version 3.9: To improve consistency with import
   statements, raise "ImportError" instead of "ValueError" for invalid
   relative import attempts.

importlib.util.find_spec(name, package=None)

   Find the _spec_ for a module, optionally relative to the specified
   **package** name. If the module is in "sys.modules", then
   "sys.modules[name].__spec__" is returned (unless the spec would be
   "None" or is not set, in which case "ValueError" is raised).
   Otherwise a search using "sys.meta_path" is done. "None" is
   returned if no spec is found.

   If **name** is for a submodule (contains a dot), the parent module
   is automatically imported.

   **name** and **package** work the same as for "import_module()".

   New in version 3.4.

   Changed in version 3.7: Raises "ModuleNotFoundError" instead of
   "AttributeError" if **package** is in fact not a package (i.e.
   lacks a "__path__" attribute).

importlib.util.module_from_spec(spec)

   Create a new module based on **spec** and
   "spec.loader.create_module".

   If "spec.loader.create_module" does not return "None", then any
   pre-existing attributes will not be reset. Also, no
   "AttributeError" will be raised if triggered while accessing
   **spec** or setting an attribute on the module.

   This function is preferred over using "types.ModuleType" to create
   a new module as **spec** is used to set as many import-controlled
   attributes on the module as possible.

   New in version 3.5.

@importlib.util.module_for_loader

   A _decorator_ for "importlib.abc.Loader.load_module()" to handle
   selecting the proper module object to load with. The decorated
   method is expected to have a call signature taking two positional
   arguments (e.g. "load_module(self, module)") for which the second
   argument will be the module **object** to be used by the loader.
   Note that the decorator will not work on static methods because of
   the assumption of two arguments.

   The decorated method will take in the **name** of the module to be
   loaded as expected for a _loader_. If the module is not found in
   "sys.modules" then a new one is constructed. Regardless of where
   the module came from, "__loader__" set to **self** and
   "__package__" is set based on what
   "importlib.abc.InspectLoader.is_package()" returns (if available).
   These attributes are set unconditionally to support reloading.

   If an exception is raised by the decorated method and a module was
   added to "sys.modules", then the module will be removed to prevent
   a partially initialized module from being in left in "sys.modules".
   If the module was already in "sys.modules" then it is left alone.

   Changed in version 3.3: "__loader__" and "__package__" are
   automatically set (when possible).

   Changed in version 3.4: Set "__name__", "__loader__" "__package__"
   unconditionally to support reloading.

   Deprecated since version 3.4: The import machinery now directly
   performs all the functionality provided by this function.

@importlib.util.set_loader

   A _decorator_ for "importlib.abc.Loader.load_module()" to set the
   "__loader__" attribute on the returned module. If the attribute is
   already set the decorator does nothing. It is assumed that the
   first positional argument to the wrapped method (i.e. "self") is
   what "__loader__" should be set to.

   Changed in version 3.4: Set "__loader__" if set to "None", as if
   the attribute does not exist.

   Deprecated since version 3.4: The import machinery takes care of
   this automatically.

@importlib.util.set_package

   A _decorator_ for "importlib.abc.Loader.load_module()" to set the
   "__package__" attribute on the returned module. If "__package__" is
   set and has a value other than "None" it will not be changed.

   Deprecated since version 3.4: The import machinery takes care of
   this automatically.

importlib.util.spec_from_loader(name, loader, *, origin=None, is_package=None)

   A factory function for creating a "ModuleSpec" instance based on a
   loader.  The parameters have the same meaning as they do for
   ModuleSpec.  The function uses available _loader_ APIs, such as
   "InspectLoader.is_package()", to fill in any missing information on
   the spec.

   New in version 3.4.

importlib.util.spec_from_file_location(name, location, *, loader=None, submodule_search_locations=None)

   A factory function for creating a "ModuleSpec" instance based on
   the path to a file.  Missing information will be filled in on the
   spec by making use of loader APIs and by the implication that the
   module will be file-based.

   New in version 3.4.

   Changed in version 3.6: Accepts a _path-like object_.

importlib.util.source_hash(source_bytes)

   Return the hash of _source_bytes_ as bytes. A hash-based ".pyc"
   file embeds the "source_hash()" of the corresponding source file’s
   contents in its header.

   New in version 3.7.

class importlib.util.LazyLoader(loader)

   A class which postpones the execution of the loader of a module
   until the module has an attribute accessed.

   This class **only** works with loaders that define "exec_module()"
   as control over what module type is used for the module is
   required. For those same reasons, the loader’s "create_module()"
   method must return "None" or a type for which its "__class__"
   attribute can be mutated along with not using _slots_. Finally,
   modules which substitute the object placed into "sys.modules" will
   not work as there is no way to properly replace the module
   references throughout the interpreter safely; "ValueError" is
   raised if such a substitution is detected.

   Note:

     For projects where startup time is critical, this class allows
     for potentially minimizing the cost of loading a module if it is
     never used. For projects where startup time is not essential then
     use of this class is **heavily** discouraged due to error
     messages created during loading being postponed and thus
     occurring out of context.

   New in version 3.5.

   Changed in version 3.6: Began calling "create_module()", removing
   the compatibility warning for "importlib.machinery.BuiltinImporter"
   and "importlib.machinery.ExtensionFileLoader".

   classmethod factory(loader)

      A class method which returns a callable that creates a lazy
      loader. This is meant to be used in situations where the loader
      is passed by class instead of by instance.
>
         suffixes = importlib.machinery.SOURCE_SUFFIXES
         loader = importlib.machinery.SourceFileLoader
         lazy_loader = importlib.util.LazyLoader.factory(loader)
         finder = importlib.machinery.FileFinder(path, (lazy_loader, suffixes))
<

Examples
========


Importing programmatically
--------------------------

To programmatically import a module, use "importlib.import_module()".
>
   import importlib

   itertools = importlib.import_module('itertools')
<

Checking if a module can be imported
------------------------------------

If you need to find out if a module can be imported without actually
doing the import, then you should use "importlib.util.find_spec()".

Note that if "name" is a submodule (contains a dot),
"importlib.util.find_spec()" will import the parent module.
>
   import importlib.util
   import sys

   # For illustrative purposes.
   name = 'itertools'

   if name in sys.modules:
       print(f"{name!r} already in sys.modules")
   elif (spec := importlib.util.find_spec(name)) is not None:
       # If you chose to perform the actual import ...
       module = importlib.util.module_from_spec(spec)
       sys.modules[name] = module
       spec.loader.exec_module(module)
       print(f"{name!r} has been imported")
   else:
       print(f"can't find the {name!r} module")
<

Importing a source file directly
--------------------------------

To import a Python source file directly, use the following recipe:
>
   import importlib.util
   import sys

   # For illustrative purposes.
   import tokenize
   file_path = tokenize.__file__
   module_name = tokenize.__name__

   spec = importlib.util.spec_from_file_location(module_name, file_path)
   module = importlib.util.module_from_spec(spec)
   sys.modules[module_name] = module
   spec.loader.exec_module(module)
<

Implementing lazy imports
-------------------------

The example below shows how to implement lazy imports:
>
   >>> import importlib.util
   >>> import sys
   >>> def lazy_import(name):
   ...     spec = importlib.util.find_spec(name)
   ...     loader = importlib.util.LazyLoader(spec.loader)
   ...     spec.loader = loader
   ...     module = importlib.util.module_from_spec(spec)
   ...     sys.modules[name] = module
   ...     loader.exec_module(module)
   ...     return module
   ...
   >>> lazy_typing = lazy_import("typing")
   >>> #lazy_typing is a real module object,
   >>> #but it is not loaded in memory yet.
   >>> lazy_typing.TYPE_CHECKING
   False
<

Setting up an importer
----------------------

For deep customizations of import, you typically want to implement an
_importer_. This means managing both the _finder_ and _loader_ side of
things. For finders there are two flavours to choose from depending on
your needs: a _meta path finder_ or a _path entry finder_. The former
is what you would put on "sys.meta_path" while the latter is what you
create using a _path entry hook_ on "sys.path_hooks" which works with
"sys.path" entries to potentially create a finder. This example will
show you how to register your own importers so that import will use
them (for creating an importer for yourself, read the documentation
for the appropriate classes defined within this package):
>
   import importlib.machinery
   import sys

   # For illustrative purposes only.
   SpamMetaPathFinder = importlib.machinery.PathFinder
   SpamPathEntryFinder = importlib.machinery.FileFinder
   loader_details = (importlib.machinery.SourceFileLoader,
                     importlib.machinery.SOURCE_SUFFIXES)

   # Setting up a meta path finder.
   # Make sure to put the finder in the proper location in the list in terms of
   # priority.
   sys.meta_path.append(SpamMetaPathFinder)

   # Setting up a path entry finder.
   # Make sure to put the path hook in the proper location in the list in terms
   # of priority.
   sys.path_hooks.append(SpamPathEntryFinder.path_hook(loader_details))
<

Approximating "importlib.import_module()"
-----------------------------------------

Import itself is implemented in Python code, making it possible to
expose most of the import machinery through importlib. The following
helps illustrate the various APIs that importlib exposes by providing
an approximate implementation of "importlib.import_module()":
>
   import importlib.util
   import sys

   def import_module(name, package=None):
       """An approximate implementation of import."""
       absolute_name = importlib.util.resolve_name(name, package)
       try:
           return sys.modules[absolute_name]
       except KeyError:
           pass

       path = None
       if '.' in absolute_name:
           parent_name, _, child_name = absolute_name.rpartition('.')
           parent_module = import_module(parent_name)
           path = parent_module.__spec__.submodule_search_locations
       for finder in sys.meta_path:
           spec = finder.find_spec(absolute_name, path)
           if spec is not None:
               break
       else:
           msg = f'No module named {absolute_name!r}'
           raise ModuleNotFoundError(msg, name=absolute_name)
       module = importlib.util.module_from_spec(spec)
       sys.modules[absolute_name] = module
       spec.loader.exec_module(module)
       if path is not None:
           setattr(parent_module, child_name, module)
       return module
<
vim:tw=78:ts=8:ft=help:norl: