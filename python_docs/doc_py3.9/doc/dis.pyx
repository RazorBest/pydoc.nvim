Python 3.9.19
*dis.pyx*                                     Last change: 2024 May 24

"dis" — Disassembler for Python bytecode
****************************************

**Source code:** Lib/dis.py

======================================================================

The "dis" module supports the analysis of CPython _bytecode_ by
disassembling it. The CPython bytecode which this module takes as an
input is defined in the file "Include/opcode.h" and used by the
compiler and the interpreter.

**CPython implementation detail:** Bytecode is an implementation
detail of the CPython interpreter.  No guarantees are made that
bytecode will not be added, removed, or changed between versions of
Python.  Use of this module should not be considered to work across
Python VMs or Python releases.

Changed in version 3.6: Use 2 bytes for each instruction. Previously
the number of bytes varied by instruction.

Example: Given the function "myfunc()":
>
   def myfunc(alist):
       return len(alist)
<
the following command can be used to display the disassembly of
"myfunc()":
>
   >>> dis.dis(myfunc)
     2           0 LOAD_GLOBAL              0 (len)
                 2 LOAD_FAST                0 (alist)
                 4 CALL_FUNCTION            1
                 6 RETURN_VALUE
<
(The “2” is a line number).


Bytecode analysis
=================

New in version 3.4.

The bytecode analysis API allows pieces of Python code to be wrapped
in a "Bytecode" object that provides easy access to details of the
compiled code.

class dis.Bytecode(x, *, first_line=None, current_offset=None)

   Analyse the bytecode corresponding to a function, generator,
   asynchronous generator, coroutine, method, string of source code,
   or a code object (as returned by "compile()").

   This is a convenience wrapper around many of the functions listed
   below, most notably "get_instructions()", as iterating over a
   "Bytecode" instance yields the bytecode operations as "Instruction"
   instances.

   If _first_line_ is not "None", it indicates the line number that
   should be reported for the first source line in the disassembled
   code.  Otherwise, the source line information (if any) is taken
   directly from the disassembled code object.

   If _current_offset_ is not "None", it refers to an instruction
   offset in the disassembled code. Setting this means "dis()" will
   display a “current instruction” marker against the specified
   opcode.

   classmethod from_traceback(tb)

      Construct a "Bytecode" instance from the given traceback,
      setting _current_offset_ to the instruction responsible for the
      exception.

   codeobj

      The compiled code object.

   first_line

      The first source line of the code object (if available)

   dis()

      Return a formatted view of the bytecode operations (the same as
      printed by "dis.dis()", but returned as a multi-line string).

   info()

      Return a formatted multi-line string with detailed information
      about the code object, like "code_info()".

   Changed in version 3.7: This can now handle coroutine and
   asynchronous generator objects.

Example:
>
   >>> bytecode = dis.Bytecode(myfunc)
   >>> for instr in bytecode:
   ...     print(instr.opname)
   ...
   LOAD_GLOBAL
   LOAD_FAST
   CALL_FUNCTION
   RETURN_VALUE
<

Analysis functions
==================

The "dis" module also defines the following analysis functions that
convert the input directly to the desired output. They can be useful
if only a single operation is being performed, so the intermediate
analysis object isn’t useful:

dis.code_info(x)

   Return a formatted multi-line string with detailed code object
   information for the supplied function, generator, asynchronous
   generator, coroutine, method, source code string or code object.

   Note that the exact contents of code info strings are highly
   implementation dependent and they may change arbitrarily across
   Python VMs or Python releases.

   New in version 3.2.

   Changed in version 3.7: This can now handle coroutine and
   asynchronous generator objects.

dis.show_code(x, *, file=None)

   Print detailed code object information for the supplied function,
   method, source code string or code object to _file_ (or
   "sys.stdout" if _file_ is not specified).

   This is a convenient shorthand for "print(code_info(x),
   file=file)", intended for interactive exploration at the
   interpreter prompt.

   New in version 3.2.

   Changed in version 3.4: Added _file_ parameter.

dis.dis(x=None, *, file=None, depth=None)

   Disassemble the _x_ object.  _x_ can denote either a module, a
   class, a method, a function, a generator, an asynchronous
   generator, a coroutine, a code object, a string of source code or a
   byte sequence of raw bytecode. For a module, it disassembles all
   functions. For a class, it disassembles all methods (including
   class and static methods). For a code object or sequence of raw
   bytecode, it prints one line per bytecode instruction. It also
   recursively disassembles nested code objects (the code of
   comprehensions, generator expressions and nested functions, and the
   code used for building nested classes). Strings are first compiled
   to code objects with the "compile()" built-in function before being
   disassembled.  If no object is provided, this function disassembles
   the last traceback.

   The disassembly is written as text to the supplied _file_ argument
   if provided and to "sys.stdout" otherwise.

   The maximal depth of recursion is limited by _depth_ unless it is
   "None". "depth=0" means no recursion.

   Changed in version 3.4: Added _file_ parameter.

   Changed in version 3.7: Implemented recursive disassembling and
   added _depth_ parameter.

   Changed in version 3.7: This can now handle coroutine and
   asynchronous generator objects.

dis.distb(tb=None, *, file=None)

   Disassemble the top-of-stack function of a traceback, using the
   last traceback if none was passed.  The instruction causing the
   exception is indicated.

   The disassembly is written as text to the supplied _file_ argument
   if provided and to "sys.stdout" otherwise.

   Changed in version 3.4: Added _file_ parameter.

dis.disassemble(code, lasti=-1, *, file=None)
dis.disco(code, lasti=-1, *, file=None)

   Disassemble a code object, indicating the last instruction if
   _lasti_ was provided.  The output is divided in the following
   columns:

   1. the line number, for the first instruction of each line

   2. the current instruction, indicated as "-->",

   3. a labelled instruction, indicated with ">>",

   4. the address of the instruction,

   5. the operation code name,

   6. operation parameters, and

   7. interpretation of the parameters in parentheses.

   The parameter interpretation recognizes local and global variable
   names, constant values, branch targets, and compare operators.

   The disassembly is written as text to the supplied _file_ argument
   if provided and to "sys.stdout" otherwise.

   Changed in version 3.4: Added _file_ parameter.

dis.get_instructions(x, *, first_line=None)

   Return an iterator over the instructions in the supplied function,
   method, source code string or code object.

   The iterator generates a series of "Instruction" named tuples
   giving the details of each operation in the supplied code.

   If _first_line_ is not "None", it indicates the line number that
   should be reported for the first source line in the disassembled
   code.  Otherwise, the source line information (if any) is taken
   directly from the disassembled code object.

   New in version 3.4.

dis.findlinestarts(code)

   This generator function uses the "co_firstlineno" and "co_lnotab"
   attributes of the code object _code_ to find the offsets which are
   starts of lines in the source code.  They are generated as
   "(offset, lineno)" pairs. See Objects/lnotab_notes.txt for the
   "co_lnotab" format and how to decode it.

   Changed in version 3.6: Line numbers can be decreasing. Before,
   they were always increasing.

dis.findlabels(code)

   Detect all offsets in the raw compiled bytecode string _code_ which
   are jump targets, and return a list of these offsets.

dis.stack_effect(opcode, oparg=None, *, jump=None)

   Compute the stack effect of _opcode_ with argument _oparg_.

   If the code has a jump target and _jump_ is "True",
   "stack_effect()" will return the stack effect of jumping.  If
   _jump_ is "False", it will return the stack effect of not jumping.
   And if _jump_ is "None" (default), it will return the maximal stack
   effect of both cases.

   New in version 3.4.

   Changed in version 3.8: Added _jump_ parameter.


Python Bytecode Instructions
============================

The "get_instructions()" function and "Bytecode" class provide details
of bytecode instructions as "Instruction" instances:

class dis.Instruction

   Details for a bytecode operation

   opcode

      numeric code for operation, corresponding to the opcode values
      listed below and the bytecode values in the Opcode collections.

   opname

      human readable name for operation

   arg

      numeric argument to operation (if any), otherwise "None"

   argval

      resolved arg value (if known), otherwise same as arg

   argrepr

      human readable description of operation argument

   offset

      start index of operation within bytecode sequence

   starts_line

      line started by this opcode (if any), otherwise "None"

   is_jump_target

      "True" if other code jumps to here, otherwise "False"

   New in version 3.4.

The Python compiler currently generates the following bytecode
instructions.

**General instructions**

NOP

   Do nothing code.  Used as a placeholder by the bytecode optimizer.

POP_TOP

   Removes the top-of-stack (TOS) item.

ROT_TWO

   Swaps the two top-most stack items.

ROT_THREE

   Lifts second and third stack item one position up, moves top down
   to position three.

ROT_FOUR

   Lifts second, third and fourth stack items one position up, moves
   top down to position four.

   New in version 3.8.

DUP_TOP

   Duplicates the reference on top of the stack.

   New in version 3.2.

DUP_TOP_TWO

   Duplicates the two references on top of the stack, leaving them in
   the same order.

   New in version 3.2.

**Unary operations**

Unary operations take the top of the stack, apply the operation, and
push the result back on the stack.

UNARY_POSITIVE

   Implements "TOS = +TOS".

UNARY_NEGATIVE

   Implements "TOS = -TOS".

UNARY_NOT

   Implements "TOS = not TOS".

UNARY_INVERT

   Implements "TOS = ~TOS".

GET_ITER

   Implements "TOS = iter(TOS)".

GET_YIELD_FROM_ITER

   If "TOS" is a _generator iterator_ or _coroutine_ object it is left
   as is.  Otherwise, implements "TOS = iter(TOS)".

   New in version 3.5.

**Binary operations**

Binary operations remove the top of the stack (TOS) and the second
top-most stack item (TOS1) from the stack.  They perform the
operation, and put the result back on the stack.

BINARY_POWER

   Implements "TOS = TOS1 ** TOS".

BINARY_MULTIPLY

   Implements "TOS = TOS1 * TOS".

BINARY_MATRIX_MULTIPLY

   Implements "TOS = TOS1 @ TOS".

   New in version 3.5.

BINARY_FLOOR_DIVIDE

   Implements "TOS = TOS1 // TOS".

BINARY_TRUE_DIVIDE

   Implements "TOS = TOS1 / TOS".

BINARY_MODULO

   Implements "TOS = TOS1 % TOS".

BINARY_ADD

   Implements "TOS = TOS1 + TOS".

BINARY_SUBTRACT

   Implements "TOS = TOS1 - TOS".

BINARY_SUBSCR

   Implements "TOS = TOS1[TOS]".

BINARY_LSHIFT

   Implements "TOS = TOS1 << TOS".

BINARY_RSHIFT

   Implements "TOS = TOS1 >> TOS".

BINARY_AND

   Implements "TOS = TOS1 & TOS".

BINARY_XOR

   Implements "TOS = TOS1 ^ TOS".

BINARY_OR

   Implements "TOS = TOS1 | TOS".

**In-place operations**

In-place operations are like binary operations, in that they remove
TOS and TOS1, and push the result back on the stack, but the operation
is done in-place when TOS1 supports it, and the resulting TOS may be
(but does not have to be) the original TOS1.

INPLACE_POWER

   Implements in-place "TOS = TOS1 ** TOS".

INPLACE_MULTIPLY

   Implements in-place "TOS = TOS1 * TOS".

INPLACE_MATRIX_MULTIPLY

   Implements in-place "TOS = TOS1 @ TOS".

   New in version 3.5.

INPLACE_FLOOR_DIVIDE

   Implements in-place "TOS = TOS1 // TOS".

INPLACE_TRUE_DIVIDE

   Implements in-place "TOS = TOS1 / TOS".

INPLACE_MODULO

   Implements in-place "TOS = TOS1 % TOS".

INPLACE_ADD

   Implements in-place "TOS = TOS1 + TOS".

INPLACE_SUBTRACT

   Implements in-place "TOS = TOS1 - TOS".

INPLACE_LSHIFT

   Implements in-place "TOS = TOS1 << TOS".

INPLACE_RSHIFT

   Implements in-place "TOS = TOS1 >> TOS".

INPLACE_AND

   Implements in-place "TOS = TOS1 & TOS".

INPLACE_XOR

   Implements in-place "TOS = TOS1 ^ TOS".

INPLACE_OR

   Implements in-place "TOS = TOS1 | TOS".

STORE_SUBSCR

   Implements "TOS1[TOS] = TOS2".

DELETE_SUBSCR

   Implements "del TOS1[TOS]".

**Coroutine opcodes**

GET_AWAITABLE

   Implements "TOS = get_awaitable(TOS)", where "get_awaitable(o)"
   returns "o" if "o" is a coroutine object or a generator object with
   the CO_ITERABLE_COROUTINE flag, or resolves "o.__await__".

   New in version 3.5.

GET_AITER

   Implements "TOS = TOS.__aiter__()".

   New in version 3.5.

   Changed in version 3.7: Returning awaitable objects from
   "__aiter__" is no longer supported.

GET_ANEXT

   Implements "PUSH(get_awaitable(TOS.__anext__()))".  See
   "GET_AWAITABLE" for details about "get_awaitable"

   New in version 3.5.

END_ASYNC_FOR

   Terminates an "async for" loop.  Handles an exception raised when
   awaiting a next item.  If TOS is "StopAsyncIteration" pop 7 values
   from the stack and restore the exception state using the second
   three of them.  Otherwise re-raise the exception using the three
   values from the stack.  An exception handler block is removed from
   the block stack.

   New in version 3.8.

BEFORE_ASYNC_WITH

   Resolves "__aenter__" and "__aexit__" from the object on top of the
   stack.  Pushes "__aexit__" and result of "__aenter__()" to the
   stack.

   New in version 3.5.

SETUP_ASYNC_WITH

   Creates a new frame object.

   New in version 3.5.

**Miscellaneous opcodes**

PRINT_EXPR

   Implements the expression statement for the interactive mode.  TOS
   is removed from the stack and printed.  In non-interactive mode, an
   expression statement is terminated with "POP_TOP".

SET_ADD(i)

   Calls "set.add(TOS1[-i], TOS)".  Used to implement set
   comprehensions.

LIST_APPEND(i)

   Calls "list.append(TOS1[-i], TOS)".  Used to implement list
   comprehensions.

MAP_ADD(i)

   Calls "dict.__setitem__(TOS1[-i], TOS1, TOS)".  Used to implement
   dict comprehensions.

   New in version 3.1.

   Changed in version 3.8: Map value is TOS and map key is TOS1.
   Before, those were reversed.

For all of the "SET_ADD", "LIST_APPEND" and "MAP_ADD" instructions,
while the added value or key/value pair is popped off, the container
object remains on the stack so that it is available for further
iterations of the loop.

RETURN_VALUE

   Returns with TOS to the caller of the function.

YIELD_VALUE

   Pops TOS and yields it from a _generator_.

YIELD_FROM

   Pops TOS and delegates to it as a subiterator from a _generator_.

   New in version 3.3.

SETUP_ANNOTATIONS

   Checks whether "__annotations__" is defined in "locals()", if not
   it is set up to an empty "dict". This opcode is only emitted if a
   class or module body contains _variable annotations_ statically.

   New in version 3.6.

IMPORT_STAR

   Loads all symbols not starting with "'_'" directly from the module
   TOS to the local namespace. The module is popped after loading all
   names. This opcode implements "from module import *".

POP_BLOCK

   Removes one block from the block stack.  Per frame, there is a
   stack of blocks, denoting "try" statements, and such.

POP_EXCEPT

   Removes one block from the block stack. The popped block must be an
   exception handler block, as implicitly created when entering an
   except handler.  In addition to popping extraneous values from the
   frame stack, the last three popped values are used to restore the
   exception state.

RERAISE

   Re-raises the exception currently on top of the stack.

   New in version 3.9.

WITH_EXCEPT_START

   Calls the function in position 7 on the stack with the top three
   items on the stack as arguments. Used to implement the call
   "context_manager.__exit__(*exc_info())" when an exception has
   occurred in a "with" statement.

   New in version 3.9.

LOAD_ASSERTION_ERROR

   Pushes "AssertionError" onto the stack.  Used by the "assert"
   statement.

   New in version 3.9.

LOAD_BUILD_CLASS

   Pushes "builtins.__build_class__()" onto the stack.  It is later
   called by "CALL_FUNCTION" to construct a class.

SETUP_WITH(delta)

   This opcode performs several operations before a with block starts.
   First, it loads "__exit__()" from the context manager and pushes it
   onto the stack for later use by "WITH_EXCEPT_START".  Then,
   "__enter__()" is called, and a finally block pointing to _delta_ is
   pushed.  Finally, the result of calling the "__enter__()" method is
   pushed onto the stack.  The next opcode will either ignore it
   ("POP_TOP"), or store it in (a) variable(s) ("STORE_FAST",
   "STORE_NAME", or "UNPACK_SEQUENCE").

   New in version 3.2.

All of the following opcodes use their arguments.

STORE_NAME(namei)

   Implements "name = TOS". _namei_ is the index of _name_ in the
   attribute "co_names" of the code object. The compiler tries to use
   "STORE_FAST" or "STORE_GLOBAL" if possible.

DELETE_NAME(namei)

   Implements "del name", where _namei_ is the index into "co_names"
   attribute of the code object.

UNPACK_SEQUENCE(count)

   Unpacks TOS into _count_ individual values, which are put onto the
   stack right-to-left.

UNPACK_EX(counts)

   Implements assignment with a starred target: Unpacks an iterable in
   TOS into individual values, where the total number of values can be
   smaller than the number of items in the iterable: one of the new
   values will be a list of all leftover items.

   The low byte of _counts_ is the number of values before the list
   value, the high byte of _counts_ the number of values after it.
   The resulting values are put onto the stack right-to-left.

STORE_ATTR(namei)

   Implements "TOS.name = TOS1", where _namei_ is the index of name in
   "co_names".

DELETE_ATTR(namei)

   Implements "del TOS.name", using _namei_ as index into "co_names".

STORE_GLOBAL(namei)

   Works as "STORE_NAME", but stores the name as a global.

DELETE_GLOBAL(namei)

   Works as "DELETE_NAME", but deletes a global name.

LOAD_CONST(consti)

   Pushes "co_consts[consti]" onto the stack.

LOAD_NAME(namei)

   Pushes the value associated with "co_names[namei]" onto the stack.

BUILD_TUPLE(count)

   Creates a tuple consuming _count_ items from the stack, and pushes
   the resulting tuple onto the stack.

BUILD_LIST(count)

   Works as "BUILD_TUPLE", but creates a list.

BUILD_SET(count)

   Works as "BUILD_TUPLE", but creates a set.

BUILD_MAP(count)

   Pushes a new dictionary object onto the stack.  Pops "2 * count"
   items so that the dictionary holds _count_ entries: "{..., TOS3:
   TOS2, TOS1: TOS}".

   Changed in version 3.5: The dictionary is created from stack items
   instead of creating an empty dictionary pre-sized to hold _count_
   items.

BUILD_CONST_KEY_MAP(count)

   The version of "BUILD_MAP" specialized for constant keys. Pops the
   top element on the stack which contains a tuple of keys, then
   starting from "TOS1", pops _count_ values to form values in the
   built dictionary.

   New in version 3.6.

BUILD_STRING(count)

   Concatenates _count_ strings from the stack and pushes the
   resulting string onto the stack.

   New in version 3.6.

LIST_TO_TUPLE

   Pops a list from the stack and pushes a tuple containing the same
   values.

   New in version 3.9.

LIST_EXTEND(i)

   Calls "list.extend(TOS1[-i], TOS)".  Used to build lists.

   New in version 3.9.

SET_UPDATE(i)

   Calls "set.update(TOS1[-i], TOS)".  Used to build sets.

   New in version 3.9.

DICT_UPDATE(i)

   Calls "dict.update(TOS1[-i], TOS)".  Used to build dicts.

   New in version 3.9.

DICT_MERGE

   Like "DICT_UPDATE" but raises an exception for duplicate keys.

   New in version 3.9.

LOAD_ATTR(namei)

   Replaces TOS with "getattr(TOS, co_names[namei])".

COMPARE_OP(opname)

   Performs a Boolean operation.  The operation name can be found in
   "cmp_op[opname]".

IS_OP(invert)

   Performs "is" comparison, or "is not" if "invert" is 1.

   New in version 3.9.

CONTAINS_OP(invert)

   Performs "in" comparison, or "not in" if "invert" is 1.

   New in version 3.9.

IMPORT_NAME(namei)

   Imports the module "co_names[namei]".  TOS and TOS1 are popped and
   provide the _fromlist_ and _level_ arguments of "__import__()".
   The module object is pushed onto the stack.  The current namespace
   is not affected: for a proper import statement, a subsequent
   "STORE_FAST" instruction modifies the namespace.

IMPORT_FROM(namei)

   Loads the attribute "co_names[namei]" from the module found in TOS.
   The resulting object is pushed onto the stack, to be subsequently
   stored by a "STORE_FAST" instruction.

JUMP_FORWARD(delta)

   Increments bytecode counter by _delta_.

POP_JUMP_IF_TRUE(target)

   If TOS is true, sets the bytecode counter to _target_.  TOS is
   popped.

   New in version 3.1.

POP_JUMP_IF_FALSE(target)

   If TOS is false, sets the bytecode counter to _target_.  TOS is
   popped.

   New in version 3.1.

JUMP_IF_NOT_EXC_MATCH(target)

   Tests whether the second value on the stack is an exception
   matching TOS, and jumps if it is not. Pops two values from the
   stack.

   New in version 3.9.

JUMP_IF_TRUE_OR_POP(target)

   If TOS is true, sets the bytecode counter to _target_ and leaves
   TOS on the stack.  Otherwise (TOS is false), TOS is popped.

   New in version 3.1.

JUMP_IF_FALSE_OR_POP(target)

   If TOS is false, sets the bytecode counter to _target_ and leaves
   TOS on the stack.  Otherwise (TOS is true), TOS is popped.

   New in version 3.1.

JUMP_ABSOLUTE(target)

   Set bytecode counter to _target_.

FOR_ITER(delta)

   TOS is an _iterator_.  Call its "__next__()" method.  If this
   yields a new value, push it on the stack (leaving the iterator
   below it).  If the iterator indicates it is exhausted, TOS is
   popped, and the byte code counter is incremented by _delta_.

LOAD_GLOBAL(namei)

   Loads the global named "co_names[namei]" onto the stack.

SETUP_FINALLY(delta)

   Pushes a try block from a try-finally or try-except clause onto the
   block stack.  _delta_ points to the finally block or the first
   except block.

LOAD_FAST(var_num)

   Pushes a reference to the local "co_varnames[var_num]" onto the
   stack.

STORE_FAST(var_num)

   Stores TOS into the local "co_varnames[var_num]".

DELETE_FAST(var_num)

   Deletes local "co_varnames[var_num]".

LOAD_CLOSURE(i)

   Pushes a reference to the cell contained in slot _i_ of the cell
   and free variable storage.  The name of the variable is
   "co_cellvars[i]" if _i_ is less than the length of _co_cellvars_.
   Otherwise it is "co_freevars[i - len(co_cellvars)]".

LOAD_DEREF(i)

   Loads the cell contained in slot _i_ of the cell and free variable
   storage. Pushes a reference to the object the cell contains on the
   stack.

LOAD_CLASSDEREF(i)

   Much like "LOAD_DEREF" but first checks the locals dictionary
   before consulting the cell.  This is used for loading free
   variables in class bodies.

   New in version 3.4.

STORE_DEREF(i)

   Stores TOS into the cell contained in slot _i_ of the cell and free
   variable storage.

DELETE_DEREF(i)

   Empties the cell contained in slot _i_ of the cell and free
   variable storage. Used by the "del" statement.

   New in version 3.2.

RAISE_VARARGS(argc)

   Raises an exception using one of the 3 forms of the "raise"
   statement, depending on the value of _argc_:

   * 0: "raise" (re-raise previous exception)

   * 1: "raise TOS" (raise exception instance or type at "TOS")

   * 2: "raise TOS1 from TOS" (raise exception instance or type at
     "TOS1" with "__cause__" set to "TOS")

CALL_FUNCTION(argc)

   Calls a callable object with positional arguments. _argc_ indicates
   the number of positional arguments. The top of the stack contains
   positional arguments, with the right-most argument on top.  Below
   the arguments is a callable object to call. "CALL_FUNCTION" pops
   all arguments and the callable object off the stack, calls the
   callable object with those arguments, and pushes the return value
   returned by the callable object.

   Changed in version 3.6: This opcode is used only for calls with
   positional arguments.

CALL_FUNCTION_KW(argc)

   Calls a callable object with positional (if any) and keyword
   arguments. _argc_ indicates the total number of positional and
   keyword arguments. The top element on the stack contains a tuple
   with the names of the keyword arguments, which must be strings.
   Below that are the values for the keyword arguments, in the order
   corresponding to the tuple. Below that are positional arguments,
   with the right-most parameter on top.  Below the arguments is a
   callable object to call. "CALL_FUNCTION_KW" pops all arguments and
   the callable object off the stack, calls the callable object with
   those arguments, and pushes the return value returned by the
   callable object.

   Changed in version 3.6: Keyword arguments are packed in a tuple
   instead of a dictionary, _argc_ indicates the total number of
   arguments.

CALL_FUNCTION_EX(flags)

   Calls a callable object with variable set of positional and keyword
   arguments.  If the lowest bit of _flags_ is set, the top of the
   stack contains a mapping object containing additional keyword
   arguments. Before the callable is called, the mapping object and
   iterable object are each “unpacked” and their contents passed in as
   keyword and positional arguments respectively. "CALL_FUNCTION_EX"
   pops all arguments and the callable object off the stack, calls the
   callable object with those arguments, and pushes the return value
   returned by the callable object.

   New in version 3.6.

LOAD_METHOD(namei)

   Loads a method named "co_names[namei]" from the TOS object. TOS is
   popped. This bytecode distinguishes two cases: if TOS has a method
   with the correct name, the bytecode pushes the unbound method and
   TOS. TOS will be used as the first argument ("self") by
   "CALL_METHOD" when calling the unbound method. Otherwise, "NULL"
   and the object return by the attribute lookup are pushed.

   New in version 3.7.

CALL_METHOD(argc)

   Calls a method.  _argc_ is the number of positional arguments.
   Keyword arguments are not supported.  This opcode is designed to be
   used with "LOAD_METHOD".  Positional arguments are on top of the
   stack. Below them, the two items described in "LOAD_METHOD" are on
   the stack (either "self" and an unbound method object or "NULL" and
   an arbitrary callable). All of them are popped and the return value
   is pushed.

   New in version 3.7.

MAKE_FUNCTION(flags)

   Pushes a new function object on the stack.  From bottom to top, the
   consumed stack must consist of values if the argument carries a
   specified flag value

   * "0x01" a tuple of default values for positional-only and
     positional-or-keyword parameters in positional order

   * "0x02" a dictionary of keyword-only parameters’ default values

   * "0x04" an annotation dictionary

   * "0x08" a tuple containing cells for free variables, making a
     closure

   * the code associated with the function (at TOS1)

   * the _qualified name_ of the function (at TOS)

BUILD_SLICE(argc)

   Pushes a slice object on the stack.  _argc_ must be 2 or 3.  If it
   is 2, "slice(TOS1, TOS)" is pushed; if it is 3, "slice(TOS2, TOS1,
   TOS)" is pushed. See the "slice()" built-in function for more
   information.

EXTENDED_ARG(ext)

   Prefixes any opcode which has an argument too big to fit into the
   default one byte. _ext_ holds an additional byte which act as
   higher bits in the argument. For each opcode, at most three
   prefixal "EXTENDED_ARG" are allowed, forming an argument from two-
   byte to four-byte.

FORMAT_VALUE(flags)

   Used for implementing formatted literal strings (f-strings).  Pops
   an optional _fmt_spec_ from the stack, then a required _value_.
   _flags_ is interpreted as follows:

   * "(flags & 0x03) == 0x00": _value_ is formatted as-is.

   * "(flags & 0x03) == 0x01": call "str()" on _value_ before
     formatting it.

   * "(flags & 0x03) == 0x02": call "repr()" on _value_ before
     formatting it.

   * "(flags & 0x03) == 0x03": call "ascii()" on _value_ before
     formatting it.

   * "(flags & 0x04) == 0x04": pop _fmt_spec_ from the stack and use
     it, else use an empty _fmt_spec_.

   Formatting is performed using "PyObject_Format()".  The result is
   pushed on the stack.

   New in version 3.6.

HAVE_ARGUMENT

   This is not really an opcode.  It identifies the dividing line
   between opcodes which don’t use their argument and those that do
   ("< HAVE_ARGUMENT" and ">= HAVE_ARGUMENT", respectively).

   Changed in version 3.6: Now every instruction has an argument, but
   opcodes "< HAVE_ARGUMENT" ignore it. Before, only opcodes ">=
   HAVE_ARGUMENT" had an argument.


Opcode collections
==================

These collections are provided for automatic introspection of bytecode
instructions:

dis.opname

   Sequence of operation names, indexable using the bytecode.

dis.opmap

   Dictionary mapping operation names to bytecodes.

dis.cmp_op

   Sequence of all compare operation names.

dis.hasconst

   Sequence of bytecodes that access a constant.

dis.hasfree

   Sequence of bytecodes that access a free variable (note that ‘free’
   in this context refers to names in the current scope that are
   referenced by inner scopes or names in outer scopes that are
   referenced from this scope.  It does _not_ include references to
   global or builtin scopes).

dis.hasname

   Sequence of bytecodes that access an attribute by name.

dis.hasjrel

   Sequence of bytecodes that have a relative jump target.

dis.hasjabs

   Sequence of bytecodes that have an absolute jump target.

dis.haslocal

   Sequence of bytecodes that access a local variable.

dis.hascompare

   Sequence of bytecodes of Boolean operations.

vim:tw=78:ts=8:ft=help:norl: