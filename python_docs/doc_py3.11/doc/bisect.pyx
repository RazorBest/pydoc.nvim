Python 3.11.9
*bisect.pyx*                                  Last change: 2024 May 24

"bisect" — Array bisection algorithm
************************************

**Source code:** Lib/bisect.py

======================================================================

This module provides support for maintaining a list in sorted order
without having to sort the list after each insertion.  For long lists
of items with expensive comparison operations, this can be an
improvement over the more common approach.  The module is called
"bisect" because it uses a basic bisection algorithm to do its work.
The source code may be most useful as a working example of the
algorithm (the boundary conditions are already right!).

The following functions are provided:

bisect.bisect_left(a, x, lo=0, hi=len(a), *, key=None)

   Locate the insertion point for _x_ in _a_ to maintain sorted order.
   The parameters _lo_ and _hi_ may be used to specify a subset of the
   list which should be considered; by default the entire list is
   used.  If _x_ is already present in _a_, the insertion point will
   be before (to the left of) any existing entries.  The return value
   is suitable for use as the first parameter to "list.insert()"
   assuming that _a_ is already sorted.

   The returned insertion point _i_ partitions the array _a_ into two
   halves so that "all(val < x for val in a[lo : i])" for the left
   side and "all(val >= x for val in a[i : hi])" for the right side.

   _key_ specifies a _key function_ of one argument that is used to
   extract a comparison key from each element in the array.  To
   support searching complex records, the key function is not applied
   to the _x_ value.

   If _key_ is "None", the elements are compared directly with no
   intervening function call.

   Changed in version 3.10: Added the _key_ parameter.

bisect.bisect_right(a, x, lo=0, hi=len(a), *, key=None)
bisect.bisect(a, x, lo=0, hi=len(a), *, key=None)

   Similar to "bisect_left()", but returns an insertion point which
   comes after (to the right of) any existing entries of _x_ in _a_.

   The returned insertion point _i_ partitions the array _a_ into two
   halves so that "all(val <= x for val in a[lo : i])" for the left
   side and "all(val > x for val in a[i : hi])" for the right side.

   _key_ specifies a _key function_ of one argument that is used to
   extract a comparison key from each element in the array.  To
   support searching complex records, the key function is not applied
   to the _x_ value.

   If _key_ is "None", the elements are compared directly with no
   intervening function call.

   Changed in version 3.10: Added the _key_ parameter.

bisect.insort_left(a, x, lo=0, hi=len(a), *, key=None)

   Insert _x_ in _a_ in sorted order.

   This function first runs "bisect_left()" to locate an insertion
   point. Next, it runs the "insert()" method on _a_ to insert _x_ at
   the appropriate position to maintain sort order.

   To support inserting records in a table, the _key_ function (if
   any) is applied to _x_ for the search step but not for the
   insertion step.

   Keep in mind that the _O_(log _n_) search is dominated by the slow
   _O_(_n_) insertion step.

   Changed in version 3.10: Added the _key_ parameter.

bisect.insort_right(a, x, lo=0, hi=len(a), *, key=None)
bisect.insort(a, x, lo=0, hi=len(a), *, key=None)

   Similar to "insort_left()", but inserting _x_ in _a_ after any
   existing entries of _x_.

   This function first runs "bisect_right()" to locate an insertion
   point. Next, it runs the "insert()" method on _a_ to insert _x_ at
   the appropriate position to maintain sort order.

   To support inserting records in a table, the _key_ function (if
   any) is applied to _x_ for the search step but not for the
   insertion step.

   Keep in mind that the _O_(log _n_) search is dominated by the slow
   _O_(_n_) insertion step.

   Changed in version 3.10: Added the _key_ parameter.


Performance Notes
=================

When writing time sensitive code using _bisect()_ and _insort()_, keep
these thoughts in mind:

* Bisection is effective for searching ranges of values. For locating
  specific values, dictionaries are more performant.

* The _insort()_ functions are _O_(_n_) because the logarithmic search
  step is dominated by the linear time insertion step.

* The search functions are stateless and discard key function results
  after they are used.  Consequently, if the search functions are used
  in a loop, the key function may be called again and again on the
  same array elements. If the key function isn’t fast, consider
  wrapping it with "functools.cache()" to avoid duplicate
  computations.  Alternatively, consider searching an array of
  precomputed keys to locate the insertion point (as shown in the
  examples section below).

See also:

  * Sorted Collections is a high performance module that uses _bisect_
    to managed sorted collections of data.

  * The SortedCollection recipe uses bisect to build a full-featured
    collection class with straight-forward search methods and support
    for a key-function.  The keys are precomputed to save unnecessary
    calls to the key function during searches.


Searching Sorted Lists
======================

The above bisect functions are useful for finding insertion points but
can be tricky or awkward to use for common searching tasks. The
following five functions show how to transform them into the standard
lookups for sorted lists:
>
   def index(a, x):
       'Locate the leftmost value exactly equal to x'
       i = bisect_left(a, x)
       if i != len(a) and a[i] == x:
           return i
       raise ValueError

   def find_lt(a, x):
       'Find rightmost value less than x'
       i = bisect_left(a, x)
       if i:
           return a[i-1]
       raise ValueError

   def find_le(a, x):
       'Find rightmost value less than or equal to x'
       i = bisect_right(a, x)
       if i:
           return a[i-1]
       raise ValueError

   def find_gt(a, x):
       'Find leftmost value greater than x'
       i = bisect_right(a, x)
       if i != len(a):
           return a[i]
       raise ValueError

   def find_ge(a, x):
       'Find leftmost item greater than or equal to x'
       i = bisect_left(a, x)
       if i != len(a):
           return a[i]
       raise ValueError
<

Examples
========

The "bisect()" function can be useful for numeric table lookups. This
example uses "bisect()" to look up a letter grade for an exam score
(say) based on a set of ordered numeric breakpoints: 90 and up is an
‘A’, 80 to 89 is a ‘B’, and so on:
>
   >>> def grade(score, breakpoints=[60, 70, 80, 90], grades='FDCBA'):
   ...     i = bisect(breakpoints, score)
   ...     return grades[i]
   ...
   >>> [grade(score) for score in [33, 99, 77, 70, 89, 90, 100]]
   ['F', 'A', 'C', 'C', 'B', 'A', 'A']
<
The "bisect()" and "insort()" functions also work with lists of
tuples.  The _key_ argument can serve to extract the field used for
ordering records in a table:
>
   >>> from collections import namedtuple
   >>> from operator import attrgetter
   >>> from bisect import bisect, insort
   >>> from pprint import pprint

   >>> Movie = namedtuple('Movie', ('name', 'released', 'director'))

   >>> movies = [
   ...     Movie('Jaws', 1975, 'Spielberg'),
   ...     Movie('Titanic', 1997, 'Cameron'),
   ...     Movie('The Birds', 1963, 'Hitchcock'),
   ...     Movie('Aliens', 1986, 'Cameron')
   ... ]

   >>> # Find the first movie released after 1960
   >>> by_year = attrgetter('released')
   >>> movies.sort(key=by_year)
   >>> movies[bisect(movies, 1960, key=by_year)]
   Movie(name='The Birds', released=1963, director='Hitchcock')

   >>> # Insert a movie while maintaining sort order
   >>> romance = Movie('Love Story', 1970, 'Hiller')
   >>> insort(movies, romance, key=by_year)
   >>> pprint(movies)
   [Movie(name='The Birds', released=1963, director='Hitchcock'),
    Movie(name='Love Story', released=1970, director='Hiller'),
    Movie(name='Jaws', released=1975, director='Spielberg'),
    Movie(name='Aliens', released=1986, director='Cameron'),
    Movie(name='Titanic', released=1997, director='Cameron')]
<
If the key function is expensive, it is possible to avoid repeated
function calls by searching a list of precomputed keys to find the
index of a record:
>
   >>> data = [('red', 5), ('blue', 1), ('yellow', 8), ('black', 0)]
   >>> data.sort(key=lambda r: r[1])       # Or use operator.itemgetter(1).
   >>> keys = [r[1] for r in data]         # Precompute a list of keys.
   >>> data[bisect_left(keys, 0)]
   ('black', 0)
   >>> data[bisect_left(keys, 1)]
   ('blue', 1)
   >>> data[bisect_left(keys, 5)]
   ('red', 5)
   >>> data[bisect_left(keys, 8)]
   ('yellow', 8)
<
vim:tw=78:ts=8:ft=help:norl: