Python 3.11.9
*functools.pyx*                               Last change: 2024 May 24

"functools" — Higher-order functions and operations on callable objects
***********************************************************************

**Source code:** Lib/functools.py

======================================================================

The "functools" module is for higher-order functions: functions that
act on or return other functions. In general, any callable object can
be treated as a function for the purposes of this module.

The "functools" module defines the following functions:

@functools.cache(user_function)

   Simple lightweight unbounded function cache.  Sometimes called
   “memoize”.

   Returns the same as "lru_cache(maxsize=None)", creating a thin
   wrapper around a dictionary lookup for the function arguments.
   Because it never needs to evict old values, this is smaller and
   faster than "lru_cache()" with a size limit.

   For example:
>
      @cache
      def factorial(n):
          return n * factorial(n-1) if n else 1

      >>> factorial(10)      # no previously cached result, makes 11 recursive calls
      3628800
      >>> factorial(5)       # just looks up cached value result
      120
      >>> factorial(12)      # makes two new recursive calls, the other 10 are cached
      479001600
<
   The cache is threadsafe so that the wrapped function can be used in
   multiple threads.  This means that the underlying data structure
   will remain coherent during concurrent updates.

   It is possible for the wrapped function to be called more than once
   if another thread makes an additional call before the initial call
   has been completed and cached.

   New in version 3.9.

@functools.cached_property(func)

   Transform a method of a class into a property whose value is
   computed once and then cached as a normal attribute for the life of
   the instance. Similar to "property()", with the addition of
   caching. Useful for expensive computed properties of instances that
   are otherwise effectively immutable.

   Example:
>
      class DataSet:

          def __init__(self, sequence_of_numbers):
              self._data = tuple(sequence_of_numbers)

          @cached_property
          def stdev(self):
              return statistics.stdev(self._data)
<
   The mechanics of "cached_property()" are somewhat different from
   "property()".  A regular property blocks attribute writes unless a
   setter is defined. In contrast, a _cached_property_ allows writes.

   The _cached_property_ decorator only runs on lookups and only when
   an attribute of the same name doesn’t exist.  When it does run, the
   _cached_property_ writes to the attribute with the same name.
   Subsequent attribute reads and writes take precedence over the
   _cached_property_ method and it works like a normal attribute.

   The cached value can be cleared by deleting the attribute.  This
   allows the _cached_property_ method to run again.

   Note, this decorator interferes with the operation of **PEP 412**
   key-sharing dictionaries.  This means that instance dictionaries
   can take more space than usual.

   Also, this decorator requires that the "__dict__" attribute on each
   instance be a mutable mapping. This means it will not work with
   some types, such as metaclasses (since the "__dict__" attributes on
   type instances are read-only proxies for the class namespace), and
   those that specify "__slots__" without including "__dict__" as one
   of the defined slots (as such classes don’t provide a "__dict__"
   attribute at all).

   If a mutable mapping is not available or if space-efficient key
   sharing is desired, an effect similar to "cached_property()" can
   also be achieved by stacking "property()" on top of "lru_cache()".
   See How do I cache method calls? for more details on how this
   differs from "cached_property()".

   New in version 3.8.

functools.cmp_to_key(func)

   Transform an old-style comparison function to a _key function_.
   Used with tools that accept key functions (such as "sorted()",
   "min()", "max()", "heapq.nlargest()", "heapq.nsmallest()",
   "itertools.groupby()").  This function is primarily used as a
   transition tool for programs being converted from Python 2 which
   supported the use of comparison functions.

   A comparison function is any callable that accepts two arguments,
   compares them, and returns a negative number for less-than, zero
   for equality, or a positive number for greater-than.  A key
   function is a callable that accepts one argument and returns
   another value to be used as the sort key.

   Example:
>
      sorted(iterable, key=cmp_to_key(locale.strcoll))  # locale-aware sort order
<
   For sorting examples and a brief sorting tutorial, see Sorting HOW
   TO.

   New in version 3.2.

@functools.lru_cache(user_function)
@functools.lru_cache(maxsize=128, typed=False)

   Decorator to wrap a function with a memoizing callable that saves
   up to the _maxsize_ most recent calls.  It can save time when an
   expensive or I/O bound function is periodically called with the
   same arguments.

   The cache is threadsafe so that the wrapped function can be used in
   multiple threads.  This means that the underlying data structure
   will remain coherent during concurrent updates.

   It is possible for the wrapped function to be called more than once
   if another thread makes an additional call before the initial call
   has been completed and cached.

   Since a dictionary is used to cache results, the positional and
   keyword arguments to the function must be _hashable_.

   Distinct argument patterns may be considered to be distinct calls
   with separate cache entries.  For example, "f(a=1, b=2)" and
   "f(b=2, a=1)" differ in their keyword argument order and may have
   two separate cache entries.

   If _user_function_ is specified, it must be a callable. This allows
   the _lru_cache_ decorator to be applied directly to a user
   function, leaving the _maxsize_ at its default value of 128:
>
      @lru_cache
      def count_vowels(sentence):
          return sum(sentence.count(vowel) for vowel in 'AEIOUaeiou')
<
   If _maxsize_ is set to "None", the LRU feature is disabled and the
   cache can grow without bound.

   If _typed_ is set to true, function arguments of different types
   will be cached separately.  If _typed_ is false, the implementation
   will usually regard them as equivalent calls and only cache a
   single result. (Some types such as _str_ and _int_ may be cached
   separately even when _typed_ is false.)

   Note, type specificity applies only to the function’s immediate
   arguments rather than their contents.  The scalar arguments,
   "Decimal(42)" and "Fraction(42)" are be treated as distinct calls
   with distinct results. In contrast, the tuple arguments "('answer',
   Decimal(42))" and "('answer', Fraction(42))" are treated as
   equivalent.

   The wrapped function is instrumented with a "cache_parameters()"
   function that returns a new "dict" showing the values for _maxsize_
   and _typed_.  This is for information purposes only.  Mutating the
   values has no effect.

   To help measure the effectiveness of the cache and tune the
   _maxsize_ parameter, the wrapped function is instrumented with a
   "cache_info()" function that returns a _named tuple_ showing
   _hits_, _misses_, _maxsize_ and _currsize_.

   The decorator also provides a "cache_clear()" function for clearing
   or invalidating the cache.

   The original underlying function is accessible through the
   "__wrapped__" attribute.  This is useful for introspection, for
   bypassing the cache, or for rewrapping the function with a
   different cache.

   The cache keeps references to the arguments and return values until
   they age out of the cache or until the cache is cleared.

   If a method is cached, the "self" instance argument is included in
   the cache.  See How do I cache method calls?

   An LRU (least recently used) cache works best when the most recent
   calls are the best predictors of upcoming calls (for example, the
   most popular articles on a news server tend to change each day).
   The cache’s size limit assures that the cache does not grow without
   bound on long-running processes such as web servers.

   In general, the LRU cache should only be used when you want to
   reuse previously computed values.  Accordingly, it doesn’t make
   sense to cache functions with side-effects, functions that need to
   create distinct mutable objects on each call (such as generators
   and async functions), or impure functions such as time() or
   random().

   Example of an LRU cache for static web content:
>
      @lru_cache(maxsize=32)
      def get_pep(num):
          'Retrieve text of a Python Enhancement Proposal'
          resource = 'https://peps.python.org/pep-%04d/' % num
          try:
              with urllib.request.urlopen(resource) as s:
                  return s.read()
          except urllib.error.HTTPError:
              return 'Not Found'

      >>> for n in 8, 290, 308, 320, 8, 218, 320, 279, 289, 320, 9991:
      ...     pep = get_pep(n)
      ...     print(n, len(pep))

      >>> get_pep.cache_info()
      CacheInfo(hits=3, misses=8, maxsize=32, currsize=8)
<
   Example of efficiently computing Fibonacci numbers using a cache to
   implement a dynamic programming technique:
>
      @lru_cache(maxsize=None)
      def fib(n):
          if n < 2:
              return n
          return fib(n-1) + fib(n-2)

      >>> [fib(n) for n in range(16)]
      [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610]

      >>> fib.cache_info()
      CacheInfo(hits=28, misses=16, maxsize=None, currsize=16)
<
   New in version 3.2.

   Changed in version 3.3: Added the _typed_ option.

   Changed in version 3.8: Added the _user_function_ option.

   Changed in version 3.9: Added the function "cache_parameters()"

@functools.total_ordering

   Given a class defining one or more rich comparison ordering
   methods, this class decorator supplies the rest.  This simplifies
   the effort involved in specifying all of the possible rich
   comparison operations:

   The class must define one of "__lt__()", "__le__()", "__gt__()", or
   "__ge__()". In addition, the class should supply an "__eq__()"
   method.

   For example:
>
      @total_ordering
      class Student:
          def _is_valid_operand(self, other):
              return (hasattr(other, "lastname") and
                      hasattr(other, "firstname"))
          def __eq__(self, other):
              if not self._is_valid_operand(other):
                  return NotImplemented
              return ((self.lastname.lower(), self.firstname.lower()) ==
                      (other.lastname.lower(), other.firstname.lower()))
          def __lt__(self, other):
              if not self._is_valid_operand(other):
                  return NotImplemented
              return ((self.lastname.lower(), self.firstname.lower()) <
                      (other.lastname.lower(), other.firstname.lower()))
<
   Note:

     While this decorator makes it easy to create well behaved totally
     ordered types, it _does_ come at the cost of slower execution and
     more complex stack traces for the derived comparison methods. If
     performance benchmarking indicates this is a bottleneck for a
     given application, implementing all six rich comparison methods
     instead is likely to provide an easy speed boost.

   Note:

     This decorator makes no attempt to override methods that have
     been declared in the class _or its superclasses_. Meaning that if
     a superclass defines a comparison operator, _total_ordering_ will
     not implement it again, even if the original method is abstract.

   New in version 3.2.

   Changed in version 3.4: Returning NotImplemented from the
   underlying comparison function for unrecognised types is now
   supported.

functools.partial(func, /, *args, **keywords)

   Return a new partial object which when called will behave like
   _func_ called with the positional arguments _args_ and keyword
   arguments _keywords_. If more arguments are supplied to the call,
   they are appended to _args_. If additional keyword arguments are
   supplied, they extend and override _keywords_. Roughly equivalent
   to:
>
      def partial(func, /, *args, **keywords):
          def newfunc(*fargs, **fkeywords):
              newkeywords = {**keywords, **fkeywords}
              return func(*args, *fargs, **newkeywords)
          newfunc.func = func
          newfunc.args = args
          newfunc.keywords = keywords
          return newfunc
<
   The "partial()" is used for partial function application which
   “freezes” some portion of a function’s arguments and/or keywords
   resulting in a new object with a simplified signature.  For
   example, "partial()" can be used to create a callable that behaves
   like the "int()" function where the _base_ argument defaults to
   two:

   >>> from functools import partial
   >>> basetwo = partial(int, base=2)
   >>> basetwo.__doc__ = 'Convert base 2 string to an int.'
   >>> basetwo('10010')
   18

class functools.partialmethod(func, /, *args, **keywords)

   Return a new "partialmethod" descriptor which behaves like
   "partial" except that it is designed to be used as a method
   definition rather than being directly callable.

   _func_ must be a _descriptor_ or a callable (objects which are
   both, like normal functions, are handled as descriptors).

   When _func_ is a descriptor (such as a normal Python function,
   "classmethod()", "staticmethod()", "abstractmethod()" or another
   instance of "partialmethod"), calls to "__get__" are delegated to
   the underlying descriptor, and an appropriate partial object
   returned as the result.

   When _func_ is a non-descriptor callable, an appropriate bound
   method is created dynamically. This behaves like a normal Python
   function when used as a method: the _self_ argument will be
   inserted as the first positional argument, even before the _args_
   and _keywords_ supplied to the "partialmethod" constructor.

   Example:
>
      >>> class Cell:
      ...     def __init__(self):
      ...         self._alive = False
      ...     @property
      ...     def alive(self):
      ...         return self._alive
      ...     def set_state(self, state):
      ...         self._alive = bool(state)
      ...     set_alive = partialmethod(set_state, True)
      ...     set_dead = partialmethod(set_state, False)
      ...
      >>> c = Cell()
      >>> c.alive
      False
      >>> c.set_alive()
      >>> c.alive
      True
<
   New in version 3.4.

functools.reduce(function, iterable[, initializer])

   Apply _function_ of two arguments cumulatively to the items of
   _iterable_, from left to right, so as to reduce the iterable to a
   single value.  For example, "reduce(lambda x, y: x+y, [1, 2, 3, 4,
   5])" calculates "((((1+2)+3)+4)+5)". The left argument, _x_, is the
   accumulated value and the right argument, _y_, is the update value
   from the _iterable_.  If the optional _initializer_ is present, it
   is placed before the items of the iterable in the calculation, and
   serves as a default when the iterable is empty.  If _initializer_
   is not given and _iterable_ contains only one item, the first item
   is returned.

   Roughly equivalent to:
>
      def reduce(function, iterable, initializer=None):
          it = iter(iterable)
          if initializer is None:
              value = next(it)
          else:
              value = initializer
          for element in it:
              value = function(value, element)
          return value
<
   See "itertools.accumulate()" for an iterator that yields all
   intermediate values.

@functools.singledispatch

   Transform a function into a _single-dispatch_ _generic function_.

   To define a generic function, decorate it with the
   "@singledispatch" decorator. When defining a function using
   "@singledispatch", note that the dispatch happens on the type of
   the first argument:
>
      >>> from functools import singledispatch
      >>> @singledispatch
      ... def fun(arg, verbose=False):
      ...     if verbose:
      ...         print("Let me just say,", end=" ")
      ...     print(arg)
<
   To add overloaded implementations to the function, use the
   "register()" attribute of the generic function, which can be used
   as a decorator.  For functions annotated with types, the decorator
   will infer the type of the first argument automatically:
>
      >>> @fun.register
      ... def _(arg: int, verbose=False):
      ...     if verbose:
      ...         print("Strength in numbers, eh?", end=" ")
      ...     print(arg)
      ...
      >>> @fun.register
      ... def _(arg: list, verbose=False):
      ...     if verbose:
      ...         print("Enumerate this:")
      ...     for i, elem in enumerate(arg):
      ...         print(i, elem)
<
   "types.UnionType" and "typing.Union" can also be used:
>
      >>> @fun.register
      ... def _(arg: int | float, verbose=False):
      ...     if verbose:
      ...         print("Strength in numbers, eh?", end=" ")
      ...     print(arg)
      ...
      >>> from typing import Union
      >>> @fun.register
      ... def _(arg: Union[list, set], verbose=False):
      ...     if verbose:
      ...         print("Enumerate this:")
      ...     for i, elem in enumerate(arg):
      ...         print(i, elem)
      ...
<
   For code which doesn’t use type annotations, the appropriate type
   argument can be passed explicitly to the decorator itself:
>
      >>> @fun.register(complex)
      ... def _(arg, verbose=False):
      ...     if verbose:
      ...         print("Better than complicated.", end=" ")
      ...     print(arg.real, arg.imag)
      ...
<
   To enable registering _lambdas_ and pre-existing functions, the
   "register()" attribute can also be used in a functional form:
>
      >>> def nothing(arg, verbose=False):
      ...     print("Nothing.")
      ...
      >>> fun.register(type(None), nothing)
<
   The "register()" attribute returns the undecorated function. This
   enables decorator stacking, "pickling", and the creation of unit
   tests for each variant independently:
>
      >>> @fun.register(float)
      ... @fun.register(Decimal)
      ... def fun_num(arg, verbose=False):
      ...     if verbose:
      ...         print("Half of your number:", end=" ")
      ...     print(arg / 2)
      ...
      >>> fun_num is fun
      False
<
   When called, the generic function dispatches on the type of the
   first argument:
>
      >>> fun("Hello, world.")
      Hello, world.
      >>> fun("test.", verbose=True)
      Let me just say, test.
      >>> fun(42, verbose=True)
      Strength in numbers, eh? 42
      >>> fun(['spam', 'spam', 'eggs', 'spam'], verbose=True)
      Enumerate this:
      0 spam
      1 spam
      2 eggs
      3 spam
      >>> fun(None)
      Nothing.
      >>> fun(1.23)
      0.615
<
   Where there is no registered implementation for a specific type,
   its method resolution order is used to find a more generic
   implementation. The original function decorated with
   "@singledispatch" is registered for the base "object" type, which
   means it is used if no better implementation is found.

   If an implementation is registered to an _abstract base class_,
   virtual subclasses of the base class will be dispatched to that
   implementation:
>
      >>> from collections.abc import Mapping
      >>> @fun.register
      ... def _(arg: Mapping, verbose=False):
      ...     if verbose:
      ...         print("Keys & Values")
      ...     for key, value in arg.items():
      ...         print(key, "=>", value)
      ...
      >>> fun({"a": "b"})
      a => b
<
   To check which implementation the generic function will choose for
   a given type, use the "dispatch()" attribute:
>
      >>> fun.dispatch(float)
      <function fun_num at 0x1035a2840>
      >>> fun.dispatch(dict)    # note: default implementation
      <function fun at 0x103fe0000>
<
   To access all registered implementations, use the read-only
   "registry" attribute:
>
      >>> fun.registry.keys()
      dict_keys([<class 'NoneType'>, <class 'int'>, <class 'object'>,
                <class 'decimal.Decimal'>, <class 'list'>,
                <class 'float'>])
      >>> fun.registry[float]
      <function fun_num at 0x1035a2840>
      >>> fun.registry[object]
      <function fun at 0x103fe0000>
<
   New in version 3.4.

   Changed in version 3.7: The "register()" attribute now supports
   using type annotations.

   Changed in version 3.11: The "register()" attribute now supports
   "types.UnionType" and "typing.Union" as type annotations.

class functools.singledispatchmethod(func)

   Transform a method into a _single-dispatch_ _generic function_.

   To define a generic method, decorate it with the
   "@singledispatchmethod" decorator. When defining a function using
   "@singledispatchmethod", note that the dispatch happens on the type
   of the first non-_self_ or non-_cls_ argument:
>
      class Negator:
          @singledispatchmethod
          def neg(self, arg):
              raise NotImplementedError("Cannot negate a")

          @neg.register
          def _(self, arg: int):
              return -arg

          @neg.register
          def _(self, arg: bool):
              return not arg
<
   "@singledispatchmethod" supports nesting with other decorators such
   as "@classmethod". Note that to allow for "dispatcher.register",
   "singledispatchmethod" must be the _outer most_ decorator. Here is
   the "Negator" class with the "neg" methods bound to the class,
   rather than an instance of the class:
>
      class Negator:
          @singledispatchmethod
          @classmethod
          def neg(cls, arg):
              raise NotImplementedError("Cannot negate a")

          @neg.register
          @classmethod
          def _(cls, arg: int):
              return -arg

          @neg.register
          @classmethod
          def _(cls, arg: bool):
              return not arg
<
   The same pattern can be used for other similar decorators:
   "@staticmethod", "@abstractmethod", and others.

   New in version 3.8.

functools.update_wrapper(wrapper, wrapped, assigned=WRAPPER_ASSIGNMENTS, updated=WRAPPER_UPDATES)

   Update a _wrapper_ function to look like the _wrapped_ function.
   The optional arguments are tuples to specify which attributes of
   the original function are assigned directly to the matching
   attributes on the wrapper function and which attributes of the
   wrapper function are updated with the corresponding attributes from
   the original function. The default values for these arguments are
   the module level constants "WRAPPER_ASSIGNMENTS" (which assigns to
   the wrapper function’s "__module__", "__name__", "__qualname__",
   "__annotations__" and "__doc__", the documentation string) and
   "WRAPPER_UPDATES" (which updates the wrapper function’s "__dict__",
   i.e. the instance dictionary).

   To allow access to the original function for introspection and
   other purposes (e.g. bypassing a caching decorator such as
   "lru_cache()"), this function automatically adds a "__wrapped__"
   attribute to the wrapper that refers to the function being wrapped.

   The main intended use for this function is in _decorator_ functions
   which wrap the decorated function and return the wrapper. If the
   wrapper function is not updated, the metadata of the returned
   function will reflect the wrapper definition rather than the
   original function definition, which is typically less than helpful.

   "update_wrapper()" may be used with callables other than functions.
   Any attributes named in _assigned_ or _updated_ that are missing
   from the object being wrapped are ignored (i.e. this function will
   not attempt to set them on the wrapper function). "AttributeError"
   is still raised if the wrapper function itself is missing any
   attributes named in _updated_.

   Changed in version 3.2: The "__wrapped__" attribute is now
   automatically added. The "__annotations__" attribute is now copied
   by default. Missing attributes no longer trigger an
   "AttributeError".

   Changed in version 3.4: The "__wrapped__" attribute now always
   refers to the wrapped function, even if that function defined a
   "__wrapped__" attribute. (see bpo-17482)

@functools.wraps(wrapped, assigned=WRAPPER_ASSIGNMENTS, updated=WRAPPER_UPDATES)

   This is a convenience function for invoking "update_wrapper()" as a
   function decorator when defining a wrapper function.  It is
   equivalent to "partial(update_wrapper, wrapped=wrapped,
   assigned=assigned, updated=updated)". For example:
>
      >>> from functools import wraps
      >>> def my_decorator(f):
      ...     @wraps(f)
      ...     def wrapper(*args, **kwds):
      ...         print('Calling decorated function')
      ...         return f(*args, **kwds)
      ...     return wrapper
      ...
      >>> @my_decorator
      ... def example():
      ...     """Docstring"""
      ...     print('Called example function')
      ...
      >>> example()
      Calling decorated function
      Called example function
      >>> example.__name__
      'example'
      >>> example.__doc__
      'Docstring'
<
   Without the use of this decorator factory, the name of the example
   function would have been "'wrapper'", and the docstring of the
   original "example()" would have been lost.


"partial" Objects
=================

"partial" objects are callable objects created by "partial()". They
have three read-only attributes:

partial.func

   A callable object or function.  Calls to the "partial" object will
   be forwarded to "func" with new arguments and keywords.

partial.args

   The leftmost positional arguments that will be prepended to the
   positional arguments provided to a "partial" object call.

partial.keywords

   The keyword arguments that will be supplied when the "partial"
   object is called.

"partial" objects are like "function" objects in that they are
callable, weak referenceable, and can have attributes.  There are some
important differences.  For instance, the "__name__" and "__doc__"
attributes are not created automatically.  Also, "partial" objects
defined in classes behave like static methods and do not transform
into bound methods during instance attribute look-up.

vim:tw=78:ts=8:ft=help:norl: