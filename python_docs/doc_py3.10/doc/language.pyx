Python 3.10.14
*language.pyx*                                Last change: 2024 May 24

Python Language Services
************************

Python provides a number of modules to assist in working with the
Python language.  These modules support tokenizing, parsing, syntax
analysis, bytecode disassembly, and various other facilities.

These modules include:

* "ast" — Abstract Syntax Trees

  * Abstract Grammar

  * Node classes

    * Literals

    * Variables

    * Expressions

      * Subscripting

      * Comprehensions

    * Statements

      * Imports

    * Control flow

    * Pattern matching

    * Function and class definitions

    * Async and await

  * "ast" Helpers

  * Compiler Flags

  * Command-Line Usage

* "symtable" — Access to the compiler’s symbol tables

  * Generating Symbol Tables

  * Examining Symbol Tables

* "token" — Constants used with Python parse trees

* "keyword" — Testing for Python keywords

* "tokenize" — Tokenizer for Python source

  * Tokenizing Input

  * Command-Line Usage

  * Examples

* "tabnanny" — Detection of ambiguous indentation

* "pyclbr" — Python module browser support

  * Function Objects

  * Class Objects

* "py_compile" — Compile Python source files

  * Command-Line Interface

* "compileall" — Byte-compile Python libraries

  * Command-line use

  * Public functions

* "dis" — Disassembler for Python bytecode

  * Bytecode analysis

  * Analysis functions

  * Python Bytecode Instructions

  * Opcode collections

* "pickletools" — Tools for pickle developers

  * Command line usage

    * Command line options

  * Programmatic Interface

vim:tw=78:ts=8:ft=help:norl: