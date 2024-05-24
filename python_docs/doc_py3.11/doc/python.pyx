Python 3.11.9
*python.pyx*                                  Last change: 2024 May 24

Python Runtime Services
***********************

The modules described in this chapter provide a wide range of services
related to the Python interpreter and its interaction with its
environment.  Here’s an overview:

* "sys" — System-specific parameters and functions

* "sysconfig" — Provide access to Python’s configuration information

  * Configuration variables

  * Installation paths

  * User scheme

    * "posix_user"

    * "nt_user"

    * "osx_framework_user"

  * Home scheme

    * "posix_home"

  * Prefix scheme

    * "posix_prefix"

    * "nt"

  * Installation path functions

  * Other functions

  * Using "sysconfig" as a script

* "builtins" — Built-in objects

* "__main__" — Top-level code environment

  * "__name__ == '__main__'"

    * What is the “top-level code environment”?

    * Idiomatic Usage

    * Packaging Considerations

  * "__main__.py" in Python Packages

    * Idiomatic Usage

  * "import __main__"

* "warnings" — Warning control

  * Warning Categories

  * The Warnings Filter

    * Describing Warning Filters

    * Default Warning Filter

    * Overriding the default filter

  * Temporarily Suppressing Warnings

  * Testing Warnings

  * Updating Code For New Versions of Dependencies

  * Available Functions

  * Available Context Managers

* "dataclasses" — Data Classes

  * Module contents

  * Post-init processing

  * Class variables

  * Init-only variables

  * Frozen instances

  * Inheritance

  * Re-ordering of keyword-only parameters in "__init__()"

  * Default factory functions

  * Mutable default values

  * Descriptor-typed fields

* "contextlib" — Utilities for "with"-statement contexts

  * Utilities

  * Examples and Recipes

    * Supporting a variable number of context managers

    * Catching exceptions from "__enter__" methods

    * Cleaning up in an "__enter__" implementation

    * Replacing any use of "try-finally" and flag variables

    * Using a context manager as a function decorator

  * Single use, reusable and reentrant context managers

    * Reentrant context managers

    * Reusable context managers

* "abc" — Abstract Base Classes

* "atexit" — Exit handlers

  * "atexit" Example

* "traceback" — Print or retrieve a stack traceback

  * "TracebackException" Objects

  * "StackSummary" Objects

  * "FrameSummary" Objects

  * Traceback Examples

* "__future__" — Future statement definitions

  * Module Contents

* "gc" — Garbage Collector interface

* "inspect" — Inspect live objects

  * Types and members

  * Retrieving source code

  * Introspecting callables with the Signature object

  * Classes and functions

  * The interpreter stack

  * Fetching attributes statically

  * Current State of Generators and Coroutines

  * Code Objects Bit Flags

  * Command Line Interface

* "site" — Site-specific configuration hook

  * "sitecustomize"

  * "usercustomize"

  * Readline configuration

  * Module contents

  * Command Line Interface

vim:tw=78:ts=8:ft=help:norl: