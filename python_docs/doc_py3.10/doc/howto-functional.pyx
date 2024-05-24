Python 3.10.14
*howto-functional.pyx*                        Last change: 2024 May 24

Functional Programming HOWTO
****************************

Author:
   A. M. Kuchling

Release:
   0.32

In this document, we’ll take a tour of Python’s features suitable for
implementing programs in a functional style.  After an introduction to
the concepts of functional programming, we’ll look at language
features such as _iterator_s and _generator_s and relevant library
modules such as "itertools" and "functools".


Introduction
============

This section explains the basic concept of functional programming; if
you’re just interested in learning about Python language features,
skip to the next section on Iterators.

Programming languages support decomposing problems in several
different ways:

* Most programming languages are **procedural**: programs are lists of
  instructions that tell the computer what to do with the program’s
  input.  C, Pascal, and even Unix shells are procedural languages.

* In **declarative** languages, you write a specification that
  describes the problem to be solved, and the language implementation
  figures out how to perform the computation efficiently.  SQL is the
  declarative language you’re most likely to be familiar with; a SQL
  query describes the data set you want to retrieve, and the SQL
  engine decides whether to scan tables or use indexes, which
  subclauses should be performed first, etc.

* **Object-oriented** programs manipulate collections of objects.
  Objects have internal state and support methods that query or modify
  this internal state in some way. Smalltalk and Java are object-
  oriented languages.  C++ and Python are languages that support
  object-oriented programming, but don’t force the use of object-
  oriented features.

* **Functional** programming decomposes a problem into a set of
  functions. Ideally, functions only take inputs and produce outputs,
  and don’t have any internal state that affects the output produced
  for a given input.  Well-known functional languages include the ML
  family (Standard ML, OCaml, and other variants) and Haskell.

The designers of some computer languages choose to emphasize one
particular approach to programming.  This often makes it difficult to
write programs that use a different approach.  Other languages are
multi-paradigm languages that support several different approaches.
Lisp, C++, and Python are multi-paradigm; you can write programs or
libraries that are largely procedural, object-oriented, or functional
in all of these languages.  In a large program, different sections
might be written using different approaches; the GUI might be object-
oriented while the processing logic is procedural or functional, for
example.

In a functional program, input flows through a set of functions. Each
function operates on its input and produces some output.  Functional
style discourages functions with side effects that modify internal
state or make other changes that aren’t visible in the function’s
return value.  Functions that have no side effects at all are called
**purely functional**.  Avoiding side effects means not using data
structures that get updated as a program runs; every function’s output
must only depend on its input.

Some languages are very strict about purity and don’t even have
assignment statements such as "a=3" or "c = a + b", but it’s difficult
to avoid all side effects, such as printing to the screen or writing
to a disk file. Another example is a call to the "print()" or
"time.sleep()" function, neither of which returns a useful value. Both
are called only for their side effects of sending some text to the
screen or pausing execution for a second.

Python programs written in functional style usually won’t go to the
extreme of avoiding all I/O or all assignments; instead, they’ll
provide a functional-appearing interface but will use non-functional
features internally. For example, the implementation of a function
will still use assignments to local variables, but won’t modify global
variables or have other side effects.

Functional programming can be considered the opposite of object-
oriented programming.  Objects are little capsules containing some
internal state along with a collection of method calls that let you
modify this state, and programs consist of making the right set of
state changes.  Functional programming wants to avoid state changes as
much as possible and works with data flowing between functions.  In
Python you might combine the two approaches by writing functions that
take and return instances representing objects in your application
(e-mail messages, transactions, etc.).

Functional design may seem like an odd constraint to work under.  Why
should you avoid objects and side effects?  There are theoretical and
practical advantages to the functional style:

* Formal provability.

* Modularity.

* Composability.

* Ease of debugging and testing.


Formal provability
------------------

A theoretical benefit is that it’s easier to construct a mathematical
proof that a functional program is correct.

For a long time researchers have been interested in finding ways to
mathematically prove programs correct.  This is different from testing
a program on numerous inputs and concluding that its output is usually
correct, or reading a program’s source code and concluding that the
code looks right; the goal is instead a rigorous proof that a program
produces the right result for all possible inputs.

The technique used to prove programs correct is to write down
**invariants**, properties of the input data and of the program’s
variables that are always true.  For each line of code, you then show
that if invariants X and Y are true **before** the line is executed,
the slightly different invariants X’ and Y’ are true **after** the
line is executed.  This continues until you reach the end of the
program, at which point the invariants should match the desired
conditions on the program’s output.

Functional programming’s avoidance of assignments arose because
assignments are difficult to handle with this technique; assignments
can break invariants that were true before the assignment without
producing any new invariants that can be propagated onward.

Unfortunately, proving programs correct is largely impractical and not
relevant to Python software. Even trivial programs require proofs that
are several pages long; the proof of correctness for a moderately
complicated program would be enormous, and few or none of the programs
you use daily (the Python interpreter, your XML parser, your web
browser) could be proven correct.  Even if you wrote down or generated
a proof, there would then be the question of verifying the proof;
maybe there’s an error in it, and you wrongly believe you’ve proved
the program correct.


Modularity
----------

A more practical benefit of functional programming is that it forces
you to break apart your problem into small pieces.  Programs are more
modular as a result.  It’s easier to specify and write a small
function that does one thing than a large function that performs a
complicated transformation.  Small functions are also easier to read
and to check for errors.


Ease of debugging and testing
-----------------------------

Testing and debugging a functional-style program is easier.

Debugging is simplified because functions are generally small and
clearly specified.  When a program doesn’t work, each function is an
interface point where you can check that the data are correct.  You
can look at the intermediate inputs and outputs to quickly isolate the
function that’s responsible for a bug.

Testing is easier because each function is a potential subject for a
unit test. Functions don’t depend on system state that needs to be
replicated before running a test; instead you only have to synthesize
the right input and then check that the output matches expectations.


Composability
-------------

As you work on a functional-style program, you’ll write a number of
functions with varying inputs and outputs.  Some of these functions
will be unavoidably specialized to a particular application, but
others will be useful in a wide variety of programs.  For example, a
function that takes a directory path and returns all the XML files in
the directory, or a function that takes a filename and returns its
contents, can be applied to many different situations.

Over time you’ll form a personal library of utilities.  Often you’ll
assemble new programs by arranging existing functions in a new
configuration and writing a few functions specialized for the current
task.


Iterators
=========

I’ll start by looking at a Python language feature that’s an important
foundation for writing functional-style programs: iterators.

An iterator is an object representing a stream of data; this object
returns the data one element at a time.  A Python iterator must
support a method called "__next__()" that takes no arguments and
always returns the next element of the stream.  If there are no more
elements in the stream, "__next__()" must raise the "StopIteration"
exception. Iterators don’t have to be finite, though; it’s perfectly
reasonable to write an iterator that produces an infinite stream of
data.

The built-in "iter()" function takes an arbitrary object and tries to
return an iterator that will return the object’s contents or elements,
raising "TypeError" if the object doesn’t support iteration.  Several
of Python’s built-in data types support iteration, the most common
being lists and dictionaries.  An object is called _iterable_ if you
can get an iterator for it.

You can experiment with the iteration interface manually:

>>> L = [1, 2, 3]
>>> it = iter(L)
>>> it  
<...iterator object at ...>
>>> it.__next__()  # same as next(it)
1
>>> next(it)
2
>>> next(it)
3
>>> next(it)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration
>>>

Python expects iterable objects in several different contexts, the
most important being the "for" statement.  In the statement "for X in
Y", Y must be an iterator or some object for which "iter()" can create
an iterator.  These two statements are equivalent:
>
   for i in iter(obj):
       print(i)

   for i in obj:
       print(i)
<
Iterators can be materialized as lists or tuples by using the "list()"
or "tuple()" constructor functions:

>>> L = [1, 2, 3]
>>> iterator = iter(L)
>>> t = tuple(iterator)
>>> t
(1, 2, 3)

Sequence unpacking also supports iterators: if you know an iterator
will return N elements, you can unpack them into an N-tuple:

>>> L = [1, 2, 3]
>>> iterator = iter(L)
>>> a, b, c = iterator
>>> a, b, c
(1, 2, 3)

Built-in functions such as "max()" and "min()" can take a single
iterator argument and will return the largest or smallest element.
The ""in"" and ""not in"" operators also support iterators: "X in
iterator" is true if X is found in the stream returned by the
iterator.  You’ll run into obvious problems if the iterator is
infinite; "max()", "min()" will never return, and if the element X
never appears in the stream, the ""in"" and ""not in"" operators won’t
return either.

Note that you can only go forward in an iterator; there’s no way to
get the previous element, reset the iterator, or make a copy of it.
Iterator objects can optionally provide these additional capabilities,
but the iterator protocol only specifies the "__next__()" method.
Functions may therefore consume all of the iterator’s output, and if
you need to do something different with the same stream, you’ll have
to create a new iterator.


Data Types That Support Iterators
---------------------------------

We’ve already seen how lists and tuples support iterators.  In fact,
any Python sequence type, such as strings, will automatically support
creation of an iterator.

Calling "iter()" on a dictionary returns an iterator that will loop
over the dictionary’s keys:
>
   >>> m = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
   ...      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12}
   >>> for key in m:
   ...     print(key, m[key])
   Jan 1
   Feb 2
   Mar 3
   Apr 4
   May 5
   Jun 6
   Jul 7
   Aug 8
   Sep 9
   Oct 10
   Nov 11
   Dec 12
<
Note that starting with Python 3.7, dictionary iteration order is
guaranteed to be the same as the insertion order. In earlier versions,
the behaviour was unspecified and could vary between implementations.

Applying "iter()" to a dictionary always loops over the keys, but
dictionaries have methods that return other iterators.  If you want to
iterate over values or key/value pairs, you can explicitly call the
"values()" or "items()" methods to get an appropriate iterator.

The "dict()" constructor can accept an iterator that returns a finite
stream of "(key, value)" tuples:

>>> L = [('Italy', 'Rome'), ('France', 'Paris'), ('US', 'Washington DC')]
>>> dict(iter(L))
{'Italy': 'Rome', 'France': 'Paris', 'US': 'Washington DC'}

Files also support iteration by calling the "readline()" method until
there are no more lines in the file.  This means you can read each
line of a file like this:
>
   for line in file:
       # do something for each line
       ...
<
Sets can take their contents from an iterable and let you iterate over
the set’s elements:
>
   >>> S = {2, 3, 5, 7, 11, 13}
   >>> for i in S:
   ...     print(i)
   2
   3
   5
   7
   11
   13
<

Generator expressions and list comprehensions
=============================================

Two common operations on an iterator’s output are 1) performing some
operation for every element, 2) selecting a subset of elements that
meet some condition. For example, given a list of strings, you might
want to strip off trailing whitespace from each line or extract all
the strings containing a given substring.

List comprehensions and generator expressions (short form: “listcomps”
and “genexps”) are a concise notation for such operations, borrowed
from the functional programming language Haskell
(https://www.haskell.org/).  You can strip all the whitespace from a
stream of strings with the following code:
>
   >>> line_list = ['  line 1\n', 'line 2  \n', ' \n', '']

   >>> # Generator expression -- returns iterator
   >>> stripped_iter = (line.strip() for line in line_list)

   >>> # List comprehension -- returns list
   >>> stripped_list = [line.strip() for line in line_list]
<
You can select only certain elements by adding an ""if"" condition:
>
   >>> stripped_list = [line.strip() for line in line_list
   ...                  if line != ""]
<
With a list comprehension, you get back a Python list; "stripped_list"
is a list containing the resulting lines, not an iterator.  Generator
expressions return an iterator that computes the values as necessary,
not needing to materialize all the values at once.  This means that
list comprehensions aren’t useful if you’re working with iterators
that return an infinite stream or a very large amount of data.
Generator expressions are preferable in these situations.

Generator expressions are surrounded by parentheses (“()”) and list
comprehensions are surrounded by square brackets (“[]”).  Generator
expressions have the form:
>
   ( expression for expr in sequence1
                if condition1
                for expr2 in sequence2
                if condition2
                for expr3 in sequence3
                ...
                if condition3
                for exprN in sequenceN
                if conditionN )
<
Again, for a list comprehension only the outside brackets are
different (square brackets instead of parentheses).

The elements of the generated output will be the successive values of
"expression".  The "if" clauses are all optional; if present,
"expression" is only evaluated and added to the result when
"condition" is true.

Generator expressions always have to be written inside parentheses,
but the parentheses signalling a function call also count.  If you
want to create an iterator that will be immediately passed to a
function you can write:
>
   obj_total = sum(obj.count for obj in list_all_objects())
<
The "for...in" clauses contain the sequences to be iterated over.  The
sequences do not have to be the same length, because they are iterated
over from left to right, **not** in parallel.  For each element in
"sequence1", "sequence2" is looped over from the beginning.
"sequence3" is then looped over for each resulting pair of elements
from "sequence1" and "sequence2".

To put it another way, a list comprehension or generator expression is
equivalent to the following Python code:
>
   for expr1 in sequence1:
       if not (condition1):
           continue   # Skip this element
       for expr2 in sequence2:
           if not (condition2):
               continue   # Skip this element
           ...
           for exprN in sequenceN:
               if not (conditionN):
                   continue   # Skip this element

               # Output the value of
               # the expression.
<
This means that when there are multiple "for...in" clauses but no "if"
clauses, the length of the resulting output will be equal to the
product of the lengths of all the sequences.  If you have two lists of
length 3, the output list is 9 elements long:

>>> seq1 = 'abc'
>>> seq2 = (1, 2, 3)
>>> [(x, y) for x in seq1 for y in seq2]  
[('a', 1), ('a', 2), ('a', 3),
 ('b', 1), ('b', 2), ('b', 3),
 ('c', 1), ('c', 2), ('c', 3)]

To avoid introducing an ambiguity into Python’s grammar, if
"expression" is creating a tuple, it must be surrounded with
parentheses.  The first list comprehension below is a syntax error,
while the second one is correct:
>
   # Syntax error
   [x, y for x in seq1 for y in seq2]
   # Correct
   [(x, y) for x in seq1 for y in seq2]
<

Generators
==========

Generators are a special class of functions that simplify the task of
writing iterators.  Regular functions compute a value and return it,
but generators return an iterator that returns a stream of values.

You’re doubtless familiar with how regular function calls work in
Python or C. When you call a function, it gets a private namespace
where its local variables are created.  When the function reaches a
"return" statement, the local variables are destroyed and the value is
returned to the caller.  A later call to the same function creates a
new private namespace and a fresh set of local variables. But, what if
the local variables weren’t thrown away on exiting a function?  What
if you could later resume the function where it left off?  This is
what generators provide; they can be thought of as resumable
functions.

Here’s the simplest example of a generator function:

>>> def generate_ints(N):
...    for i in range(N):
...        yield i

Any function containing a "yield" keyword is a generator function;
this is detected by Python’s _bytecode_ compiler which compiles the
function specially as a result.

When you call a generator function, it doesn’t return a single value;
instead it returns a generator object that supports the iterator
protocol.  On executing the "yield" expression, the generator outputs
the value of "i", similar to a "return" statement.  The big difference
between "yield" and a "return" statement is that on reaching a "yield"
the generator’s state of execution is suspended and local variables
are preserved.  On the next call to the generator’s "__next__()"
method, the function will resume executing.

Here’s a sample usage of the "generate_ints()" generator:

>>> gen = generate_ints(3)
>>> gen  
<generator object generate_ints at ...>
>>> next(gen)
0
>>> next(gen)
1
>>> next(gen)
2
>>> next(gen)
Traceback (most recent call last):
  File "stdin", line 1, in <module>
  File "stdin", line 2, in generate_ints
StopIteration

You could equally write "for i in generate_ints(5)", or "a, b, c =
generate_ints(3)".

Inside a generator function, "return value" causes
"StopIteration(value)" to be raised from the "__next__()" method.
Once this happens, or the bottom of the function is reached, the
procession of values ends and the generator cannot yield any further
values.

You could achieve the effect of generators manually by writing your
own class and storing all the local variables of the generator as
instance variables.  For example, returning a list of integers could
be done by setting "self.count" to 0, and having the "__next__()"
method increment "self.count" and return it. However, for a moderately
complicated generator, writing a corresponding class can be much
messier.

The test suite included with Python’s library,
Lib/test/test_generators.py, contains a number of more interesting
examples.  Here’s one generator that implements an in-order traversal
of a tree using generators recursively.
>
   # A recursive generator that generates Tree leaves in in-order.
   def inorder(t):
       if t:
           for x in inorder(t.left):
               yield x

           yield t.label

           for x in inorder(t.right):
               yield x
<
Two other examples in "test_generators.py" produce solutions for the
N-Queens problem (placing N queens on an NxN chess board so that no
queen threatens another) and the Knight’s Tour (finding a route that
takes a knight to every square of an NxN chessboard without visiting
any square twice).


Passing values into a generator
-------------------------------

In Python 2.4 and earlier, generators only produced output.  Once a
generator’s code was invoked to create an iterator, there was no way
to pass any new information into the function when its execution is
resumed.  You could hack together this ability by making the generator
look at a global variable or by passing in some mutable object that
callers then modify, but these approaches are messy.

In Python 2.5 there’s a simple way to pass values into a generator.
"yield" became an expression, returning a value that can be assigned
to a variable or otherwise operated on:
>
   val = (yield i)
<
I recommend that you **always** put parentheses around a "yield"
expression when you’re doing something with the returned value, as in
the above example. The parentheses aren’t always necessary, but it’s
easier to always add them instead of having to remember when they’re
needed.

(**PEP 342** explains the exact rules, which are that a
"yield"-expression must always be parenthesized except when it occurs
at the top-level expression on the right-hand side of an assignment.
This means you can write "val = yield i" but have to use parentheses
when there’s an operation, as in "val = (yield i) + 12".)

Values are sent into a generator by calling its "send(value)" method.
This method resumes the generator’s code and the "yield" expression
returns the specified value.  If the regular "__next__()" method is
called, the "yield" returns "None".

Here’s a simple counter that increments by 1 and allows changing the
value of the internal counter.
>
   def counter(maximum):
       i = 0
       while i < maximum:
           val = (yield i)
           # If value provided, change counter
           if val is not None:
               i = val
           else:
               i += 1
<
And here’s an example of changing the counter:

>>> it = counter(10)  
>>> next(it)  
0
>>> next(it)  
1
>>> it.send(8)  
8
>>> next(it)  
9
>>> next(it)  
Traceback (most recent call last):
  File "t.py", line 15, in <module>
    it.next()
StopIteration

Because "yield" will often be returning "None", you should always
check for this case.  Don’t just use its value in expressions unless
you’re sure that the "send()" method will be the only method used to
resume your generator function.

In addition to "send()", there are two other methods on generators:

* "throw(value)" is used to raise an exception inside the generator;
  the exception is raised by the "yield" expression where the
  generator’s execution is paused.

* "close()" raises a "GeneratorExit" exception inside the generator to
  terminate the iteration.  On receiving this exception, the
  generator’s code must either raise "GeneratorExit" or
  "StopIteration"; catching the exception and doing anything else is
  illegal and will trigger a "RuntimeError".  "close()" will also be
  called by Python’s garbage collector when the generator is garbage-
  collected.

  If you need to run cleanup code when a "GeneratorExit" occurs, I
  suggest using a "try: ... finally:" suite instead of catching
  "GeneratorExit".

The cumulative effect of these changes is to turn generators from one-
way producers of information into both producers and consumers.

Generators also become **coroutines**, a more generalized form of
subroutines. Subroutines are entered at one point and exited at
another point (the top of the function, and a "return" statement), but
coroutines can be entered, exited, and resumed at many different
points (the "yield" statements).


Built-in functions
==================

Let’s look in more detail at built-in functions often used with
iterators.

Two of Python’s built-in functions, "map()" and "filter()" duplicate
the features of generator expressions:

"map(f, iterA, iterB, ...)" returns an iterator over the sequence
   "f(iterA[0], iterB[0]), f(iterA[1], iterB[1]), f(iterA[2],
   iterB[2]), ...".

   >>> def upper(s):
   ...     return s.upper()

   >>> list(map(upper, ['sentence', 'fragment']))
   ['SENTENCE', 'FRAGMENT']
   >>> [upper(s) for s in ['sentence', 'fragment']]
   ['SENTENCE', 'FRAGMENT']

You can of course achieve the same effect with a list comprehension.

"filter(predicate, iter)" returns an iterator over all the sequence
elements that meet a certain condition, and is similarly duplicated by
list comprehensions.  A **predicate** is a function that returns the
truth value of some condition; for use with "filter()", the predicate
must take a single value.

>>> def is_even(x):
...     return (x % 2) == 0

>>> list(filter(is_even, range(10)))
[0, 2, 4, 6, 8]

This can also be written as a list comprehension:

>>> list(x for x in range(10) if is_even(x))
[0, 2, 4, 6, 8]

"enumerate(iter, start=0)" counts off the elements in the iterable
returning 2-tuples containing the count (from _start_) and each
element.
>
   >>> for item in enumerate(['subject', 'verb', 'object']):
   ...     print(item)
   (0, 'subject')
   (1, 'verb')
   (2, 'object')
<
"enumerate()" is often used when looping through a list and recording
the indexes at which certain conditions are met:
>
   f = open('data.txt', 'r')
   for i, line in enumerate(f):
       if line.strip() == '':
           print('Blank line at line #%i' % i)
<
"sorted(iterable, key=None, reverse=False)" collects all the elements
of the iterable into a list, sorts the list, and returns the sorted
result.  The _key_ and _reverse_ arguments are passed through to the
constructed list’s "sort()" method.
>
   >>> import random
   >>> # Generate 8 random numbers between [0, 10000)
   >>> rand_list = random.sample(range(10000), 8)
   >>> rand_list  
   [769, 7953, 9828, 6431, 8442, 9878, 6213, 2207]
   >>> sorted(rand_list)  
   [769, 2207, 6213, 6431, 7953, 8442, 9828, 9878]
   >>> sorted(rand_list, reverse=True)  
   [9878, 9828, 8442, 7953, 6431, 6213, 2207, 769]
<
(For a more detailed discussion of sorting, see the Sorting HOW TO.)

The "any(iter)" and "all(iter)" built-ins look at the truth values of
an iterable’s contents.  "any()" returns "True" if any element in the
iterable is a true value, and "all()" returns "True" if all of the
elements are true values:

>>> any([0, 1, 0])
True
>>> any([0, 0, 0])
False
>>> any([1, 1, 1])
True
>>> all([0, 1, 0])
False
>>> all([0, 0, 0])
False
>>> all([1, 1, 1])
True

"zip(iterA, iterB, ...)" takes one element from each iterable and
returns them in a tuple:
>
   zip(['a', 'b', 'c'], (1, 2, 3)) =>
     ('a', 1), ('b', 2), ('c', 3)
<
It doesn’t construct an in-memory list and exhaust all the input
iterators before returning; instead tuples are constructed and
returned only if they’re requested.  (The technical term for this
behaviour is lazy evaluation.)

This iterator is intended to be used with iterables that are all of
the same length.  If the iterables are of different lengths, the
resulting stream will be the same length as the shortest iterable.
>
   zip(['a', 'b'], (1, 2, 3)) =>
     ('a', 1), ('b', 2)
<
You should avoid doing this, though, because an element may be taken
from the longer iterators and discarded.  This means you can’t go on
to use the iterators further because you risk skipping a discarded
element.


The itertools module
====================

The "itertools" module contains a number of commonly used iterators as
well as functions for combining several iterators.  This section will
introduce the module’s contents by showing small examples.

The module’s functions fall into a few broad classes:

* Functions that create a new iterator based on an existing iterator.

* Functions for treating an iterator’s elements as function arguments.

* Functions for selecting portions of an iterator’s output.

* A function for grouping an iterator’s output.


Creating new iterators
----------------------

"itertools.count(start, step)" returns an infinite stream of evenly
spaced values.  You can optionally supply the starting number, which
defaults to 0, and the interval between numbers, which defaults to 1:
>
   itertools.count() =>
     0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ...
   itertools.count(10) =>
     10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ...
   itertools.count(10, 5) =>
     10, 15, 20, 25, 30, 35, 40, 45, 50, 55, ...
<
"itertools.cycle(iter)" saves a copy of the contents of a provided
iterable and returns a new iterator that returns its elements from
first to last.  The new iterator will repeat these elements
infinitely.
>
   itertools.cycle([1, 2, 3, 4, 5]) =>
     1, 2, 3, 4, 5, 1, 2, 3, 4, 5, ...
<
"itertools.repeat(elem, [n])" returns the provided element _n_ times,
or returns the element endlessly if _n_ is not provided.
>
   itertools.repeat('abc') =>
     abc, abc, abc, abc, abc, abc, abc, abc, abc, abc, ...
   itertools.repeat('abc', 5) =>
     abc, abc, abc, abc, abc
<
"itertools.chain(iterA, iterB, ...)" takes an arbitrary number of
iterables as input, and returns all the elements of the first
iterator, then all the elements of the second, and so on, until all of
the iterables have been exhausted.
>
   itertools.chain(['a', 'b', 'c'], (1, 2, 3)) =>
     a, b, c, 1, 2, 3
<
"itertools.islice(iter, [start], stop, [step])" returns a stream
that’s a slice of the iterator.  With a single _stop_ argument, it
will return the first _stop_ elements.  If you supply a starting
index, you’ll get _stop-start_ elements, and if you supply a value for
_step_, elements will be skipped accordingly.  Unlike Python’s string
and list slicing, you can’t use negative values for _start_, _stop_,
or _step_.
>
   itertools.islice(range(10), 8) =>
     0, 1, 2, 3, 4, 5, 6, 7
   itertools.islice(range(10), 2, 8) =>
     2, 3, 4, 5, 6, 7
   itertools.islice(range(10), 2, 8, 2) =>
     2, 4, 6
<
"itertools.tee(iter, [n])" replicates an iterator; it returns _n_
independent iterators that will all return the contents of the source
iterator. If you don’t supply a value for _n_, the default is 2.
Replicating iterators requires saving some of the contents of the
source iterator, so this can consume significant memory if the
iterator is large and one of the new iterators is consumed more than
the others.
>
   itertools.tee( itertools.count() ) =>
      iterA, iterB

   where iterA ->
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ...

   and   iterB ->
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ...
<

Calling functions on elements
-----------------------------

The "operator" module contains a set of functions corresponding to
Python’s operators.  Some examples are "operator.add(a, b)" (adds two
values), "operator.ne(a, b)" (same as "a != b"), and
"operator.attrgetter('id')" (returns a callable that fetches the ".id"
attribute).

"itertools.starmap(func, iter)" assumes that the iterable will return
a stream of tuples, and calls _func_ using these tuples as the
arguments:
>
   itertools.starmap(os.path.join,
                     [('/bin', 'python'), ('/usr', 'bin', 'java'),
                      ('/usr', 'bin', 'perl'), ('/usr', 'bin', 'ruby')])
   =>
     /bin/python, /usr/bin/java, /usr/bin/perl, /usr/bin/ruby
<

Selecting elements
------------------

Another group of functions chooses a subset of an iterator’s elements
based on a predicate.

"itertools.filterfalse(predicate, iter)" is the opposite of
"filter()", returning all elements for which the predicate returns
false:
>
   itertools.filterfalse(is_even, itertools.count()) =>
     1, 3, 5, 7, 9, 11, 13, 15, ...
<
"itertools.takewhile(predicate, iter)" returns elements for as long as
the predicate returns true.  Once the predicate returns false, the
iterator will signal the end of its results.
>
   def less_than_10(x):
       return x < 10

   itertools.takewhile(less_than_10, itertools.count()) =>
     0, 1, 2, 3, 4, 5, 6, 7, 8, 9

   itertools.takewhile(is_even, itertools.count()) =>
     0
<
"itertools.dropwhile(predicate, iter)" discards elements while the
predicate returns true, and then returns the rest of the iterable’s
results.
>
   itertools.dropwhile(less_than_10, itertools.count()) =>
     10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ...

   itertools.dropwhile(is_even, itertools.count()) =>
     1, 2, 3, 4, 5, 6, 7, 8, 9, 10, ...
<
"itertools.compress(data, selectors)" takes two iterators and returns
only those elements of _data_ for which the corresponding element of
_selectors_ is true, stopping whenever either one is exhausted:
>
   itertools.compress([1, 2, 3, 4, 5], [True, True, False, False, True]) =>
      1, 2, 5
<

Combinatoric functions
----------------------

The "itertools.combinations(iterable, r)" returns an iterator giving
all possible _r_-tuple combinations of the elements contained in
_iterable_.
>
   itertools.combinations([1, 2, 3, 4, 5], 2) =>
     (1, 2), (1, 3), (1, 4), (1, 5),
     (2, 3), (2, 4), (2, 5),
     (3, 4), (3, 5),
     (4, 5)

   itertools.combinations([1, 2, 3, 4, 5], 3) =>
     (1, 2, 3), (1, 2, 4), (1, 2, 5), (1, 3, 4), (1, 3, 5), (1, 4, 5),
     (2, 3, 4), (2, 3, 5), (2, 4, 5),
     (3, 4, 5)
<
The elements within each tuple remain in the same order as _iterable_
returned them.  For example, the number 1 is always before 2, 3, 4, or
5 in the examples above.  A similar function,
"itertools.permutations(iterable, r=None)", removes this constraint on
the order, returning all possible arrangements of length _r_:
>
   itertools.permutations([1, 2, 3, 4, 5], 2) =>
     (1, 2), (1, 3), (1, 4), (1, 5),
     (2, 1), (2, 3), (2, 4), (2, 5),
     (3, 1), (3, 2), (3, 4), (3, 5),
     (4, 1), (4, 2), (4, 3), (4, 5),
     (5, 1), (5, 2), (5, 3), (5, 4)

   itertools.permutations([1, 2, 3, 4, 5]) =>
     (1, 2, 3, 4, 5), (1, 2, 3, 5, 4), (1, 2, 4, 3, 5),
     ...
     (5, 4, 3, 2, 1)
<
If you don’t supply a value for _r_ the length of the iterable is
used, meaning that all the elements are permuted.

Note that these functions produce all of the possible combinations by
position and don’t require that the contents of _iterable_ are unique:
>
   itertools.permutations('aba', 3) =>
     ('a', 'b', 'a'), ('a', 'a', 'b'), ('b', 'a', 'a'),
     ('b', 'a', 'a'), ('a', 'a', 'b'), ('a', 'b', 'a')
<
The identical tuple "('a', 'a', 'b')" occurs twice, but the two ‘a’
strings came from different positions.

The "itertools.combinations_with_replacement(iterable, r)" function
relaxes a different constraint: elements can be repeated within a
single tuple.  Conceptually an element is selected for the first
position of each tuple and then is replaced before the second element
is selected.
>
   itertools.combinations_with_replacement([1, 2, 3, 4, 5], 2) =>
     (1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
     (2, 2), (2, 3), (2, 4), (2, 5),
     (3, 3), (3, 4), (3, 5),
     (4, 4), (4, 5),
     (5, 5)
<

Grouping elements
-----------------

The last function I’ll discuss, "itertools.groupby(iter,
key_func=None)", is the most complicated.  "key_func(elem)" is a
function that can compute a key value for each element returned by the
iterable.  If you don’t supply a key function, the key is simply each
element itself.

"groupby()" collects all the consecutive elements from the underlying
iterable that have the same key value, and returns a stream of
2-tuples containing a key value and an iterator for the elements with
that key.
>
   city_list = [('Decatur', 'AL'), ('Huntsville', 'AL'), ('Selma', 'AL'),
                ('Anchorage', 'AK'), ('Nome', 'AK'),
                ('Flagstaff', 'AZ'), ('Phoenix', 'AZ'), ('Tucson', 'AZ'),
                ...
               ]

   def get_state(city_state):
       return city_state[1]

   itertools.groupby(city_list, get_state) =>
     ('AL', iterator-1),
     ('AK', iterator-2),
     ('AZ', iterator-3), ...

   where
   iterator-1 =>
     ('Decatur', 'AL'), ('Huntsville', 'AL'), ('Selma', 'AL')
   iterator-2 =>
     ('Anchorage', 'AK'), ('Nome', 'AK')
   iterator-3 =>
     ('Flagstaff', 'AZ'), ('Phoenix', 'AZ'), ('Tucson', 'AZ')
<
"groupby()" assumes that the underlying iterable’s contents will
already be sorted based on the key.  Note that the returned iterators
also use the underlying iterable, so you have to consume the results
of iterator-1 before requesting iterator-2 and its corresponding key.


The functools module
====================

The "functools" module in Python 2.5 contains some higher-order
functions. A **higher-order function** takes one or more functions as
input and returns a new function.  The most useful tool in this module
is the "functools.partial()" function.

For programs written in a functional style, you’ll sometimes want to
construct variants of existing functions that have some of the
parameters filled in. Consider a Python function "f(a, b, c)"; you may
wish to create a new function "g(b, c)" that’s equivalent to "f(1, b,
c)"; you’re filling in a value for one of "f()"’s parameters.  This is
called “partial function application”.

The constructor for "partial()" takes the arguments "(function, arg1,
arg2, ..., kwarg1=value1, kwarg2=value2)".  The resulting object is
callable, so you can just call it to invoke "function" with the
filled-in arguments.

Here’s a small but realistic example:
>
   import functools

   def log(message, subsystem):
       """Write the contents of 'message' to the specified subsystem."""
       print('%s: %s' % (subsystem, message))
       ...

   server_log = functools.partial(log, subsystem='server')
   server_log('Unable to open socket')
<
"functools.reduce(func, iter, [initial_value])" cumulatively performs
an operation on all the iterable’s elements and, therefore, can’t be
applied to infinite iterables. _func_ must be a function that takes
two elements and returns a single value.  "functools.reduce()" takes
the first two elements A and B returned by the iterator and calculates
"func(A, B)".  It then requests the third element, C, calculates
"func(func(A, B), C)", combines this result with the fourth element
returned, and continues until the iterable is exhausted.  If the
iterable returns no values at all, a "TypeError" exception is raised.
If the initial value is supplied, it’s used as a starting point and
"func(initial_value, A)" is the first calculation.
>
   >>> import operator, functools
   >>> functools.reduce(operator.concat, ['A', 'BB', 'C'])
   'ABBC'
   >>> functools.reduce(operator.concat, [])
   Traceback (most recent call last):
     ...
   TypeError: reduce() of empty sequence with no initial value
   >>> functools.reduce(operator.mul, [1, 2, 3], 1)
   6
   >>> functools.reduce(operator.mul, [], 1)
   1
<
If you use "operator.add()" with "functools.reduce()", you’ll add up
all the elements of the iterable.  This case is so common that there’s
a special built-in called "sum()" to compute it:

>>> import functools, operator
>>> functools.reduce(operator.add, [1, 2, 3, 4], 0)
10
>>> sum([1, 2, 3, 4])
10
>>> sum([])
0

For many uses of "functools.reduce()", though, it can be clearer to
just write the obvious "for" loop:
>
   import functools
   # Instead of:
   product = functools.reduce(operator.mul, [1, 2, 3], 1)

   # You can write:
   product = 1
   for i in [1, 2, 3]:
       product *= i
<
A related function is "itertools.accumulate(iterable,
func=operator.add)".  It performs the same calculation, but instead of
returning only the final result, "accumulate()" returns an iterator
that also yields each partial result:
>
   itertools.accumulate([1, 2, 3, 4, 5]) =>
     1, 3, 6, 10, 15

   itertools.accumulate([1, 2, 3, 4, 5], operator.mul) =>
     1, 2, 6, 24, 120
<

The operator module
-------------------

The "operator" module was mentioned earlier.  It contains a set of
functions corresponding to Python’s operators.  These functions are
often useful in functional-style code because they save you from
writing trivial functions that perform a single operation.

Some of the functions in this module are:

* Math operations: "add()", "sub()", "mul()", "floordiv()", "abs()", …

* Logical operations: "not_()", "truth()".

* Bitwise operations: "and_()", "or_()", "invert()".

* Comparisons: "eq()", "ne()", "lt()", "le()", "gt()", and "ge()".

* Object identity: "is_()", "is_not()".

Consult the operator module’s documentation for a complete list.


Small functions and the lambda expression
=========================================

When writing functional-style programs, you’ll often need little
functions that act as predicates or that combine elements in some way.

If there’s a Python built-in or a module function that’s suitable, you
don’t need to define a new function at all:
>
   stripped_lines = [line.strip() for line in lines]
   existing_files = filter(os.path.exists, file_list)
<
If the function you need doesn’t exist, you need to write it.  One way
to write small functions is to use the "lambda" expression.  "lambda"
takes a number of parameters and an expression combining these
parameters, and creates an anonymous function that returns the value
of the expression:
>
   adder = lambda x, y: x+y

   print_assign = lambda name, value: name + '=' + str(value)
<
An alternative is to just use the "def" statement and define a
function in the usual way:
>
   def adder(x, y):
       return x + y

   def print_assign(name, value):
       return name + '=' + str(value)
<
Which alternative is preferable?  That’s a style question; my usual
course is to avoid using "lambda".

One reason for my preference is that "lambda" is quite limited in the
functions it can define.  The result has to be computable as a single
expression, which means you can’t have multiway "if... elif... else"
comparisons or "try... except" statements.  If you try to do too much
in a "lambda" statement, you’ll end up with an overly complicated
expression that’s hard to read.  Quick, what’s the following code
doing?
>
   import functools
   total = functools.reduce(lambda a, b: (0, a[1] + b[1]), items)[1]
<
You can figure it out, but it takes time to disentangle the expression
to figure out what’s going on.  Using a short nested "def" statements
makes things a little bit better:
>
   import functools
   def combine(a, b):
       return 0, a[1] + b[1]

   total = functools.reduce(combine, items)[1]
<
But it would be best of all if I had simply used a "for" loop:
>
   total = 0
   for a, b in items:
       total += b
<
Or the "sum()" built-in and a generator expression:
>
   total = sum(b for a, b in items)
<
Many uses of "functools.reduce()" are clearer when written as "for"
loops.

Fredrik Lundh once suggested the following set of rules for
refactoring uses of "lambda":

1. Write a lambda function.

2. Write a comment explaining what the heck that lambda does.

3. Study the comment for a while, and think of a name that captures
   the essence of the comment.

4. Convert the lambda to a def statement, using that name.

5. Remove the comment.

I really like these rules, but you’re free to disagree about whether
this lambda-free style is better.


Revision History and Acknowledgements
=====================================

The author would like to thank the following people for offering
suggestions, corrections and assistance with various drafts of this
article: Ian Bicking, Nick Coghlan, Nick Efford, Raymond Hettinger,
Jim Jewett, Mike Krell, Leandro Lameiro, Jussi Salmela, Collin Winter,
Blake Winton.

Version 0.1: posted June 30 2006.

Version 0.11: posted July 1 2006.  Typo fixes.

Version 0.2: posted July 10 2006.  Merged genexp and listcomp sections
into one. Typo fixes.

Version 0.21: Added more references suggested on the tutor mailing
list.

Version 0.30: Adds a section on the "functional" module written by
Collin Winter; adds short section on the operator module; a few other
edits.


References
==========


General
-------

**Structure and Interpretation of Computer Programs**, by Harold
Abelson and Gerald Jay Sussman with Julie Sussman.  Full text at
https://mitpress.mit.edu/sicp/.  In this classic textbook of computer
science, chapters 2 and 3 discuss the use of sequences and streams to
organize the data flow inside a program.  The book uses Scheme for its
examples, but many of the design approaches described in these
chapters are applicable to functional-style Python code.

https://www.defmacro.org/ramblings/fp.html: A general introduction to
functional programming that uses Java examples and has a lengthy
historical introduction.

https://en.wikipedia.org/wiki/Functional_programming: General
Wikipedia entry describing functional programming.

https://en.wikipedia.org/wiki/Coroutine: Entry for coroutines.

https://en.wikipedia.org/wiki/Currying: Entry for the concept of
currying.


Python-specific
---------------

https://gnosis.cx/TPiP/: The first chapter of David Mertz’s book _Text
Processing in Python_ discusses functional programming for text
processing, in the section titled “Utilizing Higher-Order Functions in
Text Processing”.

Mertz also wrote a 3-part series of articles on functional programming
for IBM’s DeveloperWorks site; see part 1, part 2, and part 3,


Python documentation
--------------------

Documentation for the "itertools" module.

Documentation for the "functools" module.

Documentation for the "operator" module.

**PEP 289**: “Generator Expressions”

**PEP 342**: “Coroutines via Enhanced Generators” describes the new
generator features in Python 2.5.

vim:tw=78:ts=8:ft=help:norl: