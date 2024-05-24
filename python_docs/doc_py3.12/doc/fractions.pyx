Python 3.12.3
*fractions.pyx*                               Last change: 2024 May 24

"fractions" — Rational numbers
******************************

**Source code:** Lib/fractions.py

======================================================================

The "fractions" module provides support for rational number
arithmetic.

A Fraction instance can be constructed from a pair of integers, from
another rational number, or from a string.

class fractions.Fraction(numerator=0, denominator=1)
class fractions.Fraction(other_fraction)
class fractions.Fraction(float)
class fractions.Fraction(decimal)
class fractions.Fraction(string)

   The first version requires that _numerator_ and _denominator_ are
   instances of "numbers.Rational" and returns a new "Fraction"
   instance with value "numerator/denominator". If _denominator_ is
   "0", it raises a "ZeroDivisionError". The second version requires
   that _other_fraction_ is an instance of "numbers.Rational" and
   returns a "Fraction" instance with the same value.  The next two
   versions accept either a "float" or a "decimal.Decimal" instance,
   and return a "Fraction" instance with exactly the same value.  Note
   that due to the usual issues with binary floating-point (see
   Floating Point Arithmetic:  Issues and Limitations), the argument
   to "Fraction(1.1)" is not exactly equal to 11/10, and so
   "Fraction(1.1)" does _not_ return "Fraction(11, 10)" as one might
   expect. (But see the documentation for the "limit_denominator()"
   method below.) The last version of the constructor expects a string
   or unicode instance. The usual form for this instance is:
>
      [sign] numerator ['/' denominator]
<
   where the optional "sign" may be either ‘+’ or ‘-’ and "numerator"
   and "denominator" (if present) are strings of decimal digits
   (underscores may be used to delimit digits as with integral
   literals in code).  In addition, any string that represents a
   finite value and is accepted by the "float" constructor is also
   accepted by the "Fraction" constructor.  In either form the input
   string may also have leading and/or trailing whitespace. Here are
   some examples:
>
      >>> from fractions import Fraction
      >>> Fraction(16, -10)
      Fraction(-8, 5)
      >>> Fraction(123)
      Fraction(123, 1)
      >>> Fraction()
      Fraction(0, 1)
      >>> Fraction('3/7')
      Fraction(3, 7)
      >>> Fraction(' -3/7 ')
      Fraction(-3, 7)
      >>> Fraction('1.414213 \t\n')
      Fraction(1414213, 1000000)
      >>> Fraction('-.125')
      Fraction(-1, 8)
      >>> Fraction('7e-6')
      Fraction(7, 1000000)
      >>> Fraction(2.25)
      Fraction(9, 4)
      >>> Fraction(1.1)
      Fraction(2476979795053773, 2251799813685248)
      >>> from decimal import Decimal
      >>> Fraction(Decimal('1.1'))
      Fraction(11, 10)
<
   The "Fraction" class inherits from the abstract base class
   "numbers.Rational", and implements all of the methods and
   operations from that class.  "Fraction" instances are _hashable_,
   and should be treated as immutable.  In addition, "Fraction" has
   the following properties and methods:

   Changed in version 3.2: The "Fraction" constructor now accepts
   "float" and "decimal.Decimal" instances.

   Changed in version 3.9: The "math.gcd()" function is now used to
   normalize the _numerator_ and _denominator_. "math.gcd()" always
   return a "int" type. Previously, the GCD type depended on
   _numerator_ and _denominator_.

   Changed in version 3.11: Underscores are now permitted when
   creating a "Fraction" instance from a string, following **PEP 515**
   rules.

   Changed in version 3.11: "Fraction" implements "__int__" now to
   satisfy "typing.SupportsInt" instance checks.

   Changed in version 3.12: Space is allowed around the slash for
   string inputs: "Fraction('2 / 3')".

   Changed in version 3.12: "Fraction" instances now support float-
   style formatting, with presentation types ""e"", ""E"", ""f"",
   ""F"", ""g"", ""G"" and ""%""".

   numerator

      Numerator of the Fraction in lowest term.

   denominator

      Denominator of the Fraction in lowest term.

   as_integer_ratio()

      Return a tuple of two integers, whose ratio is equal to the
      original Fraction.  The ratio is in lowest terms and has a
      positive denominator.

      New in version 3.8.

   is_integer()

      Return "True" if the Fraction is an integer.

      New in version 3.12.

   classmethod from_float(flt)

      Alternative constructor which only accepts instances of "float"
      or "numbers.Integral". Beware that "Fraction.from_float(0.3)" is
      not the same value as "Fraction(3, 10)".

      Note:

        From Python 3.2 onwards, you can also construct a "Fraction"
        instance directly from a "float".

   classmethod from_decimal(dec)

      Alternative constructor which only accepts instances of
      "decimal.Decimal" or "numbers.Integral".

      Note:

        From Python 3.2 onwards, you can also construct a "Fraction"
        instance directly from a "decimal.Decimal" instance.

   limit_denominator(max_denominator=1000000)

      Finds and returns the closest "Fraction" to "self" that has
      denominator at most max_denominator.  This method is useful for
      finding rational approximations to a given floating-point
      number:

      >>> from fractions import Fraction
      >>> Fraction('3.1415926535897932').limit_denominator(1000)
      Fraction(355, 113)

      or for recovering a rational number that’s represented as a
      float:

      >>> from math import pi, cos
      >>> Fraction(cos(pi/3))
      Fraction(4503599627370497, 9007199254740992)
      >>> Fraction(cos(pi/3)).limit_denominator()
      Fraction(1, 2)
      >>> Fraction(1.1).limit_denominator()
      Fraction(11, 10)

   __floor__()

      Returns the greatest "int" "<= self".  This method can also be
      accessed through the "math.floor()" function:

      >>> from math import floor
      >>> floor(Fraction(355, 113))
      3

   __ceil__()

      Returns the least "int" ">= self".  This method can also be
      accessed through the "math.ceil()" function.

   __round__()
   __round__(ndigits)

      The first version returns the nearest "int" to "self", rounding
      half to even. The second version rounds "self" to the nearest
      multiple of "Fraction(1, 10**ndigits)" (logically, if "ndigits"
      is negative), again rounding half toward even.  This method can
      also be accessed through the "round()" function.

   __format__(format_spec, /)

      Provides support for float-style formatting of "Fraction"
      instances via the "str.format()" method, the "format()" built-in
      function, or Formatted string literals. The presentation types
      ""e"", ""E"", ""f"", ""F"", ""g"", ""G"" and ""%"" are
      supported. For these presentation types, formatting for a
      "Fraction" object "x" follows the rules outlined for the "float"
      type in the Format Specification Mini-Language section.

      Here are some examples:
>
         >>> from fractions import Fraction
         >>> format(Fraction(1, 7), '.40g')
         '0.1428571428571428571428571428571428571429'
         >>> format(Fraction('1234567.855'), '_.2f')
         '1_234_567.86'
         >>> f"{Fraction(355, 113):*>20.6e}"
         '********3.141593e+00'
         >>> old_price, new_price = 499, 672
         >>> "{:.2%} price increase".format(Fraction(new_price, old_price) - 1)
         '34.67% price increase'
<
See also:

  Module "numbers"
     The abstract base classes making up the numeric tower.

vim:tw=78:ts=8:ft=help:norl: