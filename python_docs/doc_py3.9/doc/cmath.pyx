Python 3.9.19
*cmath.pyx*                                   Last change: 2024 May 24

"cmath" — Mathematical functions for complex numbers
****************************************************

======================================================================

This module provides access to mathematical functions for complex
numbers.  The functions in this module accept integers, floating-point
numbers or complex numbers as arguments. They will also accept any
Python object that has either a "__complex__()" or a "__float__()"
method: these methods are used to convert the object to a complex or
floating-point number, respectively, and the function is then applied
to the result of the conversion.

Note:

  On platforms with hardware and system-level support for signed
  zeros, functions involving branch cuts are continuous on _both_
  sides of the branch cut: the sign of the zero distinguishes one side
  of the branch cut from the other.  On platforms that do not support
  signed zeros the continuity is as specified below.


Conversions to and from polar coordinates
=========================================

A Python complex number "z" is stored internally using _rectangular_
or _Cartesian_ coordinates.  It is completely determined by its _real
part_ "z.real" and its _imaginary part_ "z.imag".  In other words:
>
   z == z.real + z.imag*1j
<
_Polar coordinates_ give an alternative way to represent a complex
number.  In polar coordinates, a complex number _z_ is defined by the
modulus _r_ and the phase angle _phi_. The modulus _r_ is the distance
from _z_ to the origin, while the phase _phi_ is the counterclockwise
angle, measured in radians, from the positive x-axis to the line
segment that joins the origin to _z_.

The following functions can be used to convert from the native
rectangular coordinates to polar coordinates and back.

cmath.phase(x)

   Return the phase of _x_ (also known as the _argument_ of _x_), as a
   float.  "phase(x)" is equivalent to "math.atan2(x.imag, x.real)".
   The result lies in the range [-_π_, _π_], and the branch cut for
   this operation lies along the negative real axis, continuous from
   above.  On systems with support for signed zeros (which includes
   most systems in current use), this means that the sign of the
   result is the same as the sign of "x.imag", even when "x.imag" is
   zero:
>
      >>> phase(complex(-1.0, 0.0))
      3.141592653589793
      >>> phase(complex(-1.0, -0.0))
      -3.141592653589793
<
Note:

  The modulus (absolute value) of a complex number _x_ can be computed
  using the built-in "abs()" function.  There is no separate "cmath"
  module function for this operation.

cmath.polar(x)

   Return the representation of _x_ in polar coordinates.  Returns a
   pair "(r, phi)" where _r_ is the modulus of _x_ and phi is the
   phase of _x_.  "polar(x)" is equivalent to "(abs(x), phase(x))".

cmath.rect(r, phi)

   Return the complex number _x_ with polar coordinates _r_ and _phi_.
   Equivalent to "r * (math.cos(phi) + math.sin(phi)*1j)".


Power and logarithmic functions
===============================

cmath.exp(x)

   Return _e_ raised to the power _x_, where _e_ is the base of
   natural logarithms.

cmath.log(x[, base])

   Returns the logarithm of _x_ to the given _base_. If the _base_ is
   not specified, returns the natural logarithm of _x_. There is one
   branch cut, from 0 along the negative real axis to -∞, continuous
   from above.

cmath.log10(x)

   Return the base-10 logarithm of _x_. This has the same branch cut
   as "log()".

cmath.sqrt(x)

   Return the square root of _x_. This has the same branch cut as
   "log()".


Trigonometric functions
=======================

cmath.acos(x)

   Return the arc cosine of _x_. There are two branch cuts: One
   extends right from 1 along the real axis to ∞, continuous from
   below. The other extends left from -1 along the real axis to -∞,
   continuous from above.

cmath.asin(x)

   Return the arc sine of _x_. This has the same branch cuts as
   "acos()".

cmath.atan(x)

   Return the arc tangent of _x_. There are two branch cuts: One
   extends from "1j" along the imaginary axis to "∞j", continuous from
   the right. The other extends from "-1j" along the imaginary axis to
   "-∞j", continuous from the left.

cmath.cos(x)

   Return the cosine of _x_.

cmath.sin(x)

   Return the sine of _x_.

cmath.tan(x)

   Return the tangent of _x_.


Hyperbolic functions
====================

cmath.acosh(x)

   Return the inverse hyperbolic cosine of _x_. There is one branch
   cut, extending left from 1 along the real axis to -∞, continuous
   from above.

cmath.asinh(x)

   Return the inverse hyperbolic sine of _x_. There are two branch
   cuts: One extends from "1j" along the imaginary axis to "∞j",
   continuous from the right.  The other extends from "-1j" along the
   imaginary axis to "-∞j", continuous from the left.

cmath.atanh(x)

   Return the inverse hyperbolic tangent of _x_. There are two branch
   cuts: One extends from "1" along the real axis to "∞", continuous
   from below. The other extends from "-1" along the real axis to
   "-∞", continuous from above.

cmath.cosh(x)

   Return the hyperbolic cosine of _x_.

cmath.sinh(x)

   Return the hyperbolic sine of _x_.

cmath.tanh(x)

   Return the hyperbolic tangent of _x_.


Classification functions
========================

cmath.isfinite(x)

   Return "True" if both the real and imaginary parts of _x_ are
   finite, and "False" otherwise.

   New in version 3.2.

cmath.isinf(x)

   Return "True" if either the real or the imaginary part of _x_ is an
   infinity, and "False" otherwise.

cmath.isnan(x)

   Return "True" if either the real or the imaginary part of _x_ is a
   NaN, and "False" otherwise.

cmath.isclose(a, b, *, rel_tol=1e-09, abs_tol=0.0)

   Return "True" if the values _a_ and _b_ are close to each other and
   "False" otherwise.

   Whether or not two values are considered close is determined
   according to given absolute and relative tolerances.

   _rel_tol_ is the relative tolerance – it is the maximum allowed
   difference between _a_ and _b_, relative to the larger absolute
   value of _a_ or _b_. For example, to set a tolerance of 5%, pass
   "rel_tol=0.05".  The default tolerance is "1e-09", which assures
   that the two values are the same within about 9 decimal digits.
   _rel_tol_ must be greater than zero.

   _abs_tol_ is the minimum absolute tolerance – useful for
   comparisons near zero. _abs_tol_ must be at least zero.

   If no errors occur, the result will be: "abs(a-b) <= max(rel_tol *
   max(abs(a), abs(b)), abs_tol)".

   The IEEE 754 special values of "NaN", "inf", and "-inf" will be
   handled according to IEEE rules.  Specifically, "NaN" is not
   considered close to any other value, including "NaN".  "inf" and
   "-inf" are only considered close to themselves.

   New in version 3.5.

   See also: **PEP 485** – A function for testing approximate equality


Constants
=========

cmath.pi

   The mathematical constant _π_, as a float.

cmath.e

   The mathematical constant _e_, as a float.

cmath.tau

   The mathematical constant _τ_, as a float.

   New in version 3.6.

cmath.inf

   Floating-point positive infinity. Equivalent to "float('inf')".

   New in version 3.6.

cmath.infj

   Complex number with zero real part and positive infinity imaginary
   part. Equivalent to "complex(0.0, float('inf'))".

   New in version 3.6.

cmath.nan

   A floating-point “not a number” (NaN) value.  Equivalent to
   "float('nan')".

   New in version 3.6.

cmath.nanj

   Complex number with zero real part and NaN imaginary part.
   Equivalent to "complex(0.0, float('nan'))".

   New in version 3.6.

Note that the selection of functions is similar, but not identical, to
that in module "math".  The reason for having two modules is that some
users aren’t interested in complex numbers, and perhaps don’t even
know what they are.  They would rather have "math.sqrt(-1)" raise an
exception than return a complex number. Also note that the functions
defined in "cmath" always return a complex number, even if the answer
can be expressed as a real number (in which case the complex number
has an imaginary part of zero).

A note on branch cuts: They are curves along which the given function
fails to be continuous.  They are a necessary feature of many complex
functions.  It is assumed that if you need to compute with complex
functions, you will understand about branch cuts.  Consult almost any
(not too elementary) book on complex variables for enlightenment.  For
information of the proper choice of branch cuts for numerical
purposes, a good reference should be the following:

See also:

  Kahan, W:  Branch cuts for complex elementary functions; or, Much
  ado about nothing’s sign bit.  In Iserles, A., and Powell, M.
  (eds.), The state of the art in numerical analysis. Clarendon Press
  (1987) pp165–211.

vim:tw=78:ts=8:ft=help:norl: