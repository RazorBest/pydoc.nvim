Python 3.9.19
*random.pyx*                                  Last change: 2024 May 24

"random" — Generate pseudo-random numbers
*****************************************

**Source code:** Lib/random.py

======================================================================

This module implements pseudo-random number generators for various
distributions.

For integers, there is uniform selection from a range. For sequences,
there is uniform selection of a random element, a function to generate
a random permutation of a list in-place, and a function for random
sampling without replacement.

On the real line, there are functions to compute uniform, normal
(Gaussian), lognormal, negative exponential, gamma, and beta
distributions. For generating distributions of angles, the von Mises
distribution is available.

Almost all module functions depend on the basic function "random()",
which generates a random float uniformly in the semi-open range [0.0,
1.0).  Python uses the Mersenne Twister as the core generator.  It
produces 53-bit precision floats and has a period of 2**19937-1.  The
underlying implementation in C is both fast and threadsafe.  The
Mersenne Twister is one of the most extensively tested random number
generators in existence.  However, being completely deterministic, it
is not suitable for all purposes, and is completely unsuitable for
cryptographic purposes.

The functions supplied by this module are actually bound methods of a
hidden instance of the "random.Random" class.  You can instantiate
your own instances of "Random" to get generators that don’t share
state.

Class "Random" can also be subclassed if you want to use a different
basic generator of your own devising: in that case, override the
"random()", "seed()", "getstate()", and "setstate()" methods.
Optionally, a new generator can supply a "getrandbits()" method — this
allows "randrange()" to produce selections over an arbitrarily large
range.

The "random" module also provides the "SystemRandom" class which uses
the system function "os.urandom()" to generate random numbers from
sources provided by the operating system.

Warning:

  The pseudo-random generators of this module should not be used for
  security purposes.  For security or cryptographic uses, see the
  "secrets" module.

See also:

  M. Matsumoto and T. Nishimura, “Mersenne Twister: A
  623-dimensionally equidistributed uniform pseudorandom number
  generator”, ACM Transactions on Modeling and Computer Simulation
  Vol. 8, No. 1, January pp.3–30 1998.

  Complementary-Multiply-with-Carry recipe for a compatible
  alternative random number generator with a long period and
  comparatively simple update operations.


Bookkeeping functions
=====================

random.seed(a=None, version=2)

   Initialize the random number generator.

   If _a_ is omitted or "None", the current system time is used.  If
   randomness sources are provided by the operating system, they are
   used instead of the system time (see the "os.urandom()" function
   for details on availability).

   If _a_ is an int, it is used directly.

   With version 2 (the default), a "str", "bytes", or "bytearray"
   object gets converted to an "int" and all of its bits are used.

   With version 1 (provided for reproducing random sequences from
   older versions of Python), the algorithm for "str" and "bytes"
   generates a narrower range of seeds.

   Changed in version 3.2: Moved to the version 2 scheme which uses
   all of the bits in a string seed.

   Deprecated since version 3.9: In the future, the _seed_ must be one
   of the following types: _NoneType_, "int", "float", "str", "bytes",
   or "bytearray".

random.getstate()

   Return an object capturing the current internal state of the
   generator.  This object can be passed to "setstate()" to restore
   the state.

random.setstate(state)

   _state_ should have been obtained from a previous call to
   "getstate()", and "setstate()" restores the internal state of the
   generator to what it was at the time "getstate()" was called.


Functions for bytes
===================

random.randbytes(n)

   Generate _n_ random bytes.

   This method should not be used for generating security tokens. Use
   "secrets.token_bytes()" instead.

   New in version 3.9.


Functions for integers
======================

random.randrange(stop)
random.randrange(start, stop[, step])

   Return a randomly selected element from "range(start, stop, step)".
   This is equivalent to "choice(range(start, stop, step))", but
   doesn’t actually build a range object.

   The positional argument pattern matches that of "range()".  Keyword
   arguments should not be used because the function may use them in
   unexpected ways.

   Changed in version 3.2: "randrange()" is more sophisticated about
   producing equally distributed values.  Formerly it used a style
   like "int(random()*n)" which could produce slightly uneven
   distributions.

random.randint(a, b)

   Return a random integer _N_ such that "a <= N <= b".  Alias for
   "randrange(a, b+1)".

random.getrandbits(k)

   Returns a non-negative Python integer with _k_ random bits. This
   method is supplied with the MersenneTwister generator and some
   other generators may also provide it as an optional part of the
   API. When available, "getrandbits()" enables "randrange()" to
   handle arbitrarily large ranges.

   Changed in version 3.9: This method now accepts zero for _k_.


Functions for sequences
=======================

random.choice(seq)

   Return a random element from the non-empty sequence _seq_. If _seq_
   is empty, raises "IndexError".

random.choices(population, weights=None, *, cum_weights=None, k=1)

   Return a _k_ sized list of elements chosen from the _population_
   with replacement. If the _population_ is empty, raises
   "IndexError".

   If a _weights_ sequence is specified, selections are made according
   to the relative weights.  Alternatively, if a _cum_weights_
   sequence is given, the selections are made according to the
   cumulative weights (perhaps computed using
   "itertools.accumulate()").  For example, the relative weights "[10,
   5, 30, 5]" are equivalent to the cumulative weights "[10, 15, 45,
   50]".  Internally, the relative weights are converted to cumulative
   weights before making selections, so supplying the cumulative
   weights saves work.

   If neither _weights_ nor _cum_weights_ are specified, selections
   are made with equal probability.  If a weights sequence is
   supplied, it must be the same length as the _population_ sequence.
   It is a "TypeError" to specify both _weights_ and _cum_weights_.

   The _weights_ or _cum_weights_ can use any numeric type that
   interoperates with the "float" values returned by "random()" (that
   includes integers, floats, and fractions but excludes decimals).
   Behavior is undefined if any weight is negative.  A "ValueError" is
   raised if all weights are zero.

   For a given seed, the "choices()" function with equal weighting
   typically produces a different sequence than repeated calls to
   "choice()".  The algorithm used by "choices()" uses floating point
   arithmetic for internal consistency and speed.  The algorithm used
   by "choice()" defaults to integer arithmetic with repeated
   selections to avoid small biases from round-off error.

   New in version 3.6.

   Changed in version 3.9: Raises a "ValueError" if all weights are
   zero.

random.shuffle(x[, random])

   Shuffle the sequence _x_ in place.

   The optional argument _random_ is a 0-argument function returning a
   random float in [0.0, 1.0); by default, this is the function
   "random()".

   To shuffle an immutable sequence and return a new shuffled list,
   use "sample(x, k=len(x))" instead.

   Note that even for small "len(x)", the total number of permutations
   of _x_ can quickly grow larger than the period of most random
   number generators. This implies that most permutations of a long
   sequence can never be generated.  For example, a sequence of length
   2080 is the largest that can fit within the period of the Mersenne
   Twister random number generator.

   Deprecated since version 3.9, will be removed in version 3.11: The
   optional parameter _random_.

random.sample(population, k, *, counts=None)

   Return a _k_ length list of unique elements chosen from the
   population sequence or set. Used for random sampling without
   replacement.

   Returns a new list containing elements from the population while
   leaving the original population unchanged.  The resulting list is
   in selection order so that all sub-slices will also be valid random
   samples.  This allows raffle winners (the sample) to be partitioned
   into grand prize and second place winners (the subslices).

   Members of the population need not be _hashable_ or unique.  If the
   population contains repeats, then each occurrence is a possible
   selection in the sample.

   Repeated elements can be specified one at a time or with the
   optional keyword-only _counts_ parameter.  For example,
   "sample(['red', 'blue'], counts=[4, 2], k=5)" is equivalent to
   "sample(['red', 'red', 'red', 'red', 'blue', 'blue'], k=5)".

   To choose a sample from a range of integers, use a "range()" object
   as an argument.  This is especially fast and space efficient for
   sampling from a large population:  "sample(range(10000000), k=60)".

   If the sample size is larger than the population size, a
   "ValueError" is raised.

   Changed in version 3.9: Added the _counts_ parameter.

   Deprecated since version 3.9: In the future, the _population_ must
   be a sequence.  Instances of "set" are no longer supported.  The
   set must first be converted to a "list" or "tuple", preferably in a
   deterministic order so that the sample is reproducible.


Real-valued distributions
=========================

The following functions generate specific real-valued distributions.
Function parameters are named after the corresponding variables in the
distribution’s equation, as used in common mathematical practice; most
of these equations can be found in any statistics text.

random.random()

   Return the next random floating point number in the range [0.0,
   1.0).

random.uniform(a, b)

   Return a random floating point number _N_ such that "a <= N <= b"
   for "a <= b" and "b <= N <= a" for "b < a".

   The end-point value "b" may or may not be included in the range
   depending on floating-point rounding in the equation "a + (b-a) *
   random()".

random.triangular(low, high, mode)

   Return a random floating point number _N_ such that "low <= N <=
   high" and with the specified _mode_ between those bounds.  The
   _low_ and _high_ bounds default to zero and one.  The _mode_
   argument defaults to the midpoint between the bounds, giving a
   symmetric distribution.

random.betavariate(alpha, beta)

   Beta distribution.  Conditions on the parameters are "alpha > 0"
   and "beta > 0". Returned values range between 0 and 1.

random.expovariate(lambd)

   Exponential distribution.  _lambd_ is 1.0 divided by the desired
   mean.  It should be nonzero.  (The parameter would be called
   “lambda”, but that is a reserved word in Python.)  Returned values
   range from 0 to positive infinity if _lambd_ is positive, and from
   negative infinity to 0 if _lambd_ is negative.

random.gammavariate(alpha, beta)

   Gamma distribution.  (_Not_ the gamma function!)  Conditions on the
   parameters are "alpha > 0" and "beta > 0".

   The probability distribution function is:
>
                x ** (alpha - 1) * math.exp(-x / beta)
      pdf(x) =  --------------------------------------
                  math.gamma(alpha) * beta ** alpha
<
random.gauss(mu, sigma)

   Gaussian distribution.  _mu_ is the mean, and _sigma_ is the
   standard deviation.  This is slightly faster than the
   "normalvariate()" function defined below.

   Multithreading note:  When two threads call this function
   simultaneously, it is possible that they will receive the same
   return value.  This can be avoided in three ways. 1) Have each
   thread use a different instance of the random number generator. 2)
   Put locks around all calls. 3) Use the slower, but thread-safe
   "normalvariate()" function instead.

random.lognormvariate(mu, sigma)

   Log normal distribution.  If you take the natural logarithm of this
   distribution, you’ll get a normal distribution with mean _mu_ and
   standard deviation _sigma_.  _mu_ can have any value, and _sigma_
   must be greater than zero.

random.normalvariate(mu, sigma)

   Normal distribution.  _mu_ is the mean, and _sigma_ is the standard
   deviation.

random.vonmisesvariate(mu, kappa)

   _mu_ is the mean angle, expressed in radians between 0 and 2*_pi_,
   and _kappa_ is the concentration parameter, which must be greater
   than or equal to zero.  If _kappa_ is equal to zero, this
   distribution reduces to a uniform random angle over the range 0 to
   2*_pi_.

random.paretovariate(alpha)

   Pareto distribution.  _alpha_ is the shape parameter.

random.weibullvariate(alpha, beta)

   Weibull distribution.  _alpha_ is the scale parameter and _beta_ is
   the shape parameter.


Alternative Generator
=====================

class random.Random([seed])

   Class that implements the default pseudo-random number generator
   used by the "random" module.

   Deprecated since version 3.9: In the future, the _seed_ must be one
   of the following types: "NoneType", "int", "float", "str", "bytes",
   or "bytearray".

class random.SystemRandom([seed])

   Class that uses the "os.urandom()" function for generating random
   numbers from sources provided by the operating system. Not
   available on all systems. Does not rely on software state, and
   sequences are not reproducible. Accordingly, the "seed()" method
   has no effect and is ignored. The "getstate()" and "setstate()"
   methods raise "NotImplementedError" if called.


Notes on Reproducibility
========================

Sometimes it is useful to be able to reproduce the sequences given by
a pseudo-random number generator.  By re-using a seed value, the same
sequence should be reproducible from run to run as long as multiple
threads are not running.

Most of the random module’s algorithms and seeding functions are
subject to change across Python versions, but two aspects are
guaranteed not to change:

* If a new seeding method is added, then a backward compatible seeder
  will be offered.

* The generator’s "random()" method will continue to produce the same
  sequence when the compatible seeder is given the same seed.


Examples
========

Basic examples:
>
   >>> random()                             # Random float:  0.0 <= x < 1.0
   0.37444887175646646

   >>> uniform(2.5, 10.0)                   # Random float:  2.5 <= x <= 10.0
   3.1800146073117523

   >>> expovariate(1 / 5)                   # Interval between arrivals averaging 5 seconds
   5.148957571865031

   >>> randrange(10)                        # Integer from 0 to 9 inclusive
   7

   >>> randrange(0, 101, 2)                 # Even integer from 0 to 100 inclusive
   26

   >>> choice(['win', 'lose', 'draw'])      # Single random element from a sequence
   'draw'

   >>> deck = 'ace two three four'.split()
   >>> shuffle(deck)                        # Shuffle a list
   >>> deck
   ['four', 'two', 'ace', 'three']

   >>> sample([10, 20, 30, 40, 50], k=4)    # Four samples without replacement
   [40, 10, 50, 30]
<
Simulations:
>
   >>> # Six roulette wheel spins (weighted sampling with replacement)
   >>> choices(['red', 'black', 'green'], [18, 18, 2], k=6)
   ['red', 'green', 'black', 'black', 'red', 'black']

   >>> # Deal 20 cards without replacement from a deck
   >>> # of 52 playing cards, and determine the proportion of cards
   >>> # with a ten-value:  ten, jack, queen, or king.
   >>> dealt = sample(['tens', 'low cards'], counts=[16, 36], k=20)
   >>> dealt.count('tens') / 20
   0.15

   >>> # Estimate the probability of getting 5 or more heads from 7 spins
   >>> # of a biased coin that settles on heads 60% of the time.
   >>> def trial():
   ...     return choices('HT', cum_weights=(0.60, 1.00), k=7).count('H') >= 5
   ...
   >>> sum(trial() for i in range(10_000)) / 10_000
   0.4169

   >>> # Probability of the median of 5 samples being in middle two quartiles
   >>> def trial():
   ...     return 2_500 <= sorted(choices(range(10_000), k=5))[2] < 7_500
   ...
   >>> sum(trial() for i in range(10_000)) / 10_000
   0.7958
<
Example of statistical bootstrapping using resampling with replacement
to estimate a confidence interval for the mean of a sample:
>
   # http://statistics.about.com/od/Applications/a/Example-Of-Bootstrapping.htm
   from statistics import fmean as mean
   from random import choices

   data = [41, 50, 29, 37, 81, 30, 73, 63, 20, 35, 68, 22, 60, 31, 95]
   means = sorted(mean(choices(data, k=len(data))) for i in range(100))
   print(f'The sample mean of {mean(data):.1f} has a 90% confidence '
         f'interval from {means[5]:.1f} to {means[94]:.1f}')
<
Example of a resampling permutation test to determine the statistical
significance or p-value of an observed difference between the effects
of a drug versus a placebo:
>
   # Example from "Statistics is Easy" by Dennis Shasha and Manda Wilson
   from statistics import fmean as mean
   from random import shuffle

   drug = [54, 73, 53, 70, 73, 68, 52, 65, 65]
   placebo = [54, 51, 58, 44, 55, 52, 42, 47, 58, 46]
   observed_diff = mean(drug) - mean(placebo)

   n = 10_000
   count = 0
   combined = drug + placebo
   for i in range(n):
       shuffle(combined)
       new_diff = mean(combined[:len(drug)]) - mean(combined[len(drug):])
       count += (new_diff >= observed_diff)

   print(f'{n} label reshufflings produced only {count} instances with a difference')
   print(f'at least as extreme as the observed difference of {observed_diff:.1f}.')
   print(f'The one-sided p-value of {count / n:.4f} leads us to reject the null')
   print(f'hypothesis that there is no difference between the drug and the placebo.')
<
Simulation of arrival times and service deliveries for a multiserver
queue:
>
   from heapq import heapify, heapreplace
   from random import expovariate, gauss
   from statistics import mean, median, stdev

   average_arrival_interval = 5.6
   average_service_time = 15.0
   stdev_service_time = 3.5
   num_servers = 3

   waits = []
   arrival_time = 0.0
   servers = [0.0] * num_servers  # time when each server becomes available
   heapify(servers)
   for i in range(1_000_000):
       arrival_time += expovariate(1.0 / average_arrival_interval)
       next_server_available = servers[0]
       wait = max(0.0, next_server_available - arrival_time)
       waits.append(wait)
       service_duration = max(0.0, gauss(average_service_time, stdev_service_time))
       service_completed = arrival_time + wait + service_duration
       heapreplace(servers, service_completed)

   print(f'Mean wait: {mean(waits):.1f}.  Stdev wait: {stdev(waits):.1f}.')
   print(f'Median wait: {median(waits):.1f}.  Max wait: {max(waits):.1f}.')
<
See also:

  Statistics for Hackers a video tutorial by Jake Vanderplas on
  statistical analysis using just a few fundamental concepts including
  simulation, sampling, shuffling, and cross-validation.

  Economics Simulation a simulation of a marketplace by Peter Norvig
  that shows effective use of many of the tools and distributions
  provided by this module (gauss, uniform, sample, betavariate,
  choice, triangular, and randrange).

  A Concrete Introduction to Probability (using Python) a tutorial by
  Peter Norvig covering the basics of probability theory, how to write
  simulations, and how to perform data analysis using Python.


Recipes
=======

The default "random()" returns multiples of 2⁻⁵³ in the range _0.0 ≤ x
< 1.0_.  All such numbers are evenly spaced and are exactly
representable as Python floats.  However, many other representable
floats in that interval are not possible selections.  For example,
"0.05954861408025609" isn’t an integer multiple of 2⁻⁵³.

The following recipe takes a different approach.  All floats in the
interval are possible selections.  The mantissa comes from a uniform
distribution of integers in the range _2⁵² ≤ mantissa < 2⁵³_.  The
exponent comes from a geometric distribution where exponents smaller
than _-53_ occur half as often as the next larger exponent.
>
   from random import Random
   from math import ldexp

   class FullRandom(Random):

       def random(self):
           mantissa = 0x10_0000_0000_0000 | self.getrandbits(52)
           exponent = -53
           x = 0
           while not x:
               x = self.getrandbits(32)
               exponent += x.bit_length() - 32
           return ldexp(mantissa, exponent)
<
All real valued distributions in the class will use the new method:
>
   >>> fr = FullRandom()
   >>> fr.random()
   0.05954861408025609
   >>> fr.expovariate(0.25)
   8.87925541791544
<
The recipe is conceptually equivalent to an algorithm that chooses
from all the multiples of 2⁻¹⁰⁷⁴ in the range _0.0 ≤ x < 1.0_.  All
such numbers are evenly spaced, but most have to be rounded down to
the nearest representable Python float.  (The value 2⁻¹⁰⁷⁴ is the
smallest positive unnormalized float and is equal to "math.ulp(0.0)".)

See also:

  Generating Pseudo-random Floating-Point Values a paper by Allen B.
  Downey describing ways to generate more fine-grained floats than
  normally generated by "random()".

vim:tw=78:ts=8:ft=help:norl: