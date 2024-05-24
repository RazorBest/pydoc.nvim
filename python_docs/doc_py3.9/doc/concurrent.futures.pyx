Python 3.9.19
*concurrent.futures.pyx*                      Last change: 2024 May 24

"concurrent.futures" — Launching parallel tasks
***********************************************

New in version 3.2.

**Source code:** Lib/concurrent/futures/thread.py and
Lib/concurrent/futures/process.py

======================================================================

The "concurrent.futures" module provides a high-level interface for
asynchronously executing callables.

The asynchronous execution can be performed with threads, using
"ThreadPoolExecutor", or separate processes, using
"ProcessPoolExecutor".  Both implement the same interface, which is
defined by the abstract "Executor" class.


Executor Objects
================

class concurrent.futures.Executor

   An abstract class that provides methods to execute calls
   asynchronously.  It should not be used directly, but through its
   concrete subclasses.

      submit(fn, /, *args, **kwargs)

         Schedules the callable, _fn_, to be executed as "fn(*args,
         **kwargs)" and returns a "Future" object representing the
         execution of the callable.
>
            with ThreadPoolExecutor(max_workers=1) as executor:
                future = executor.submit(pow, 323, 1235)
                print(future.result())
<
      map(func, *iterables, timeout=None, chunksize=1)

         Similar to "map(func, *iterables)" except:

         * the _iterables_ are collected immediately rather than
           lazily;

         * _func_ is executed asynchronously and several calls to
           _func_ may be made concurrently.

         The returned iterator raises a
         "concurrent.futures.TimeoutError" if "__next__()" is called
         and the result isn’t available after _timeout_ seconds from
         the original call to "Executor.map()". _timeout_ can be an
         int or a float.  If _timeout_ is not specified or "None",
         there is no limit to the wait time.

         If a _func_ call raises an exception, then that exception
         will be raised when its value is retrieved from the iterator.

         When using "ProcessPoolExecutor", this method chops
         _iterables_ into a number of chunks which it submits to the
         pool as separate tasks.  The (approximate) size of these
         chunks can be specified by setting _chunksize_ to a positive
         integer.  For very long iterables, using a large value for
         _chunksize_ can significantly improve performance compared to
         the default size of 1.  With "ThreadPoolExecutor",
         _chunksize_ has no effect.

         Changed in version 3.5: Added the _chunksize_ argument.

      shutdown(wait=True, *, cancel_futures=False)

         Signal the executor that it should free any resources that it
         is using when the currently pending futures are done
         executing.  Calls to "Executor.submit()" and "Executor.map()"
         made after shutdown will raise "RuntimeError".

         If _wait_ is "True" then this method will not return until
         all the pending futures are done executing and the resources
         associated with the executor have been freed.  If _wait_ is
         "False" then this method will return immediately and the
         resources associated with the executor will be freed when all
         pending futures are done executing.  Regardless of the value
         of _wait_, the entire Python program will not exit until all
         pending futures are done executing.

         If _cancel_futures_ is "True", this method will cancel all
         pending futures that the executor has not started running.
         Any futures that are completed or running won’t be cancelled,
         regardless of the value of _cancel_futures_.

         If both _cancel_futures_ and _wait_ are "True", all futures
         that the executor has started running will be completed prior
         to this method returning. The remaining futures are
         cancelled.

         You can avoid having to call this method explicitly if you
         use the "with" statement, which will shutdown the "Executor"
         (waiting as if "Executor.shutdown()" were called with _wait_
         set to "True"):
>
            import shutil
            with ThreadPoolExecutor(max_workers=4) as e:
                e.submit(shutil.copy, 'src1.txt', 'dest1.txt')
                e.submit(shutil.copy, 'src2.txt', 'dest2.txt')
                e.submit(shutil.copy, 'src3.txt', 'dest3.txt')
                e.submit(shutil.copy, 'src4.txt', 'dest4.txt')
<
         Changed in version 3.9: Added _cancel_futures_.


ThreadPoolExecutor
==================

"ThreadPoolExecutor" is an "Executor" subclass that uses a pool of
threads to execute calls asynchronously.

Deadlocks can occur when the callable associated with a "Future" waits
on the results of another "Future".  For example:
>
   import time
   def wait_on_b():
       time.sleep(5)
       print(b.result())  # b will never complete because it is waiting on a.
       return 5

   def wait_on_a():
       time.sleep(5)
       print(a.result())  # a will never complete because it is waiting on b.
       return 6


   executor = ThreadPoolExecutor(max_workers=2)
   a = executor.submit(wait_on_b)
   b = executor.submit(wait_on_a)
<
And:
>
   def wait_on_future():
       f = executor.submit(pow, 5, 2)
       # This will never complete because there is only one worker thread and
       # it is executing this function.
       print(f.result())

   executor = ThreadPoolExecutor(max_workers=1)
   executor.submit(wait_on_future)
<
class concurrent.futures.ThreadPoolExecutor(max_workers=None, thread_name_prefix='', initializer=None, initargs=())

   An "Executor" subclass that uses a pool of at most _max_workers_
   threads to execute calls asynchronously.

   _initializer_ is an optional callable that is called at the start
   of each worker thread; _initargs_ is a tuple of arguments passed to
   the initializer.  Should _initializer_ raise an exception, all
   currently pending jobs will raise a "BrokenThreadPool", as well as
   any attempt to submit more jobs to the pool.

   Changed in version 3.5: If _max_workers_ is "None" or not given, it
   will default to the number of processors on the machine, multiplied
   by "5", assuming that "ThreadPoolExecutor" is often used to overlap
   I/O instead of CPU work and the number of workers should be higher
   than the number of workers for "ProcessPoolExecutor".

   New in version 3.6: The _thread_name_prefix_ argument was added to
   allow users to control the "threading.Thread" names for worker
   threads created by the pool for easier debugging.

   Changed in version 3.7: Added the _initializer_ and _initargs_
   arguments.

   Changed in version 3.8: Default value of _max_workers_ is changed
   to "min(32, os.cpu_count() + 4)". This default value preserves at
   least 5 workers for I/O bound tasks. It utilizes at most 32 CPU
   cores for CPU bound tasks which release the GIL. And it avoids
   using very large resources implicitly on many-core
   machines.ThreadPoolExecutor now reuses idle worker threads before
   starting _max_workers_ worker threads too.


ThreadPoolExecutor Example
--------------------------
>
   import concurrent.futures
   import urllib.request

   URLS = ['http://www.foxnews.com/',
           'http://www.cnn.com/',
           'http://europe.wsj.com/',
           'http://www.bbc.co.uk/',
           'http://nonexistant-subdomain.python.org/']

   # Retrieve a single page and report the URL and contents
   def load_url(url, timeout):
       with urllib.request.urlopen(url, timeout=timeout) as conn:
           return conn.read()

   # We can use a with statement to ensure threads are cleaned up promptly
   with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
       # Start the load operations and mark each future with its URL
       future_to_url = {executor.submit(load_url, url, 60): url for url in URLS}
       for future in concurrent.futures.as_completed(future_to_url):
           url = future_to_url[future]
           try:
               data = future.result()
           except Exception as exc:
               print('%r generated an exception: %s' % (url, exc))
           else:
               print('%r page is %d bytes' % (url, len(data)))
<

ProcessPoolExecutor
===================

The "ProcessPoolExecutor" class is an "Executor" subclass that uses a
pool of processes to execute calls asynchronously.
"ProcessPoolExecutor" uses the "multiprocessing" module, which allows
it to side-step the _Global Interpreter Lock_ but also means that only
picklable objects can be executed and returned.

The "__main__" module must be importable by worker subprocesses. This
means that "ProcessPoolExecutor" will not work in the interactive
interpreter.

Calling "Executor" or "Future" methods from a callable submitted to a
"ProcessPoolExecutor" will result in deadlock.

class concurrent.futures.ProcessPoolExecutor(max_workers=None, mp_context=None, initializer=None, initargs=())

   An "Executor" subclass that executes calls asynchronously using a
   pool of at most _max_workers_ processes.  If _max_workers_ is
   "None" or not given, it will default to the number of processors on
   the machine. If _max_workers_ is less than or equal to "0", then a
   "ValueError" will be raised. On Windows, _max_workers_ must be less
   than or equal to "61". If it is not then "ValueError" will be
   raised. If _max_workers_ is "None", then the default chosen will be
   at most "61", even if more processors are available. _mp_context_
   can be a multiprocessing context or None. It will be used to launch
   the workers. If _mp_context_ is "None" or not given, the default
   multiprocessing context is used.

   _initializer_ is an optional callable that is called at the start
   of each worker process; _initargs_ is a tuple of arguments passed
   to the initializer.  Should _initializer_ raise an exception, all
   currently pending jobs will raise a "BrokenProcessPool", as well as
   any attempt to submit more jobs to the pool.

   Changed in version 3.3: When one of the worker processes terminates
   abruptly, a "BrokenProcessPool" error is now raised.  Previously,
   behaviour was undefined but operations on the executor or its
   futures would often freeze or deadlock.

   Changed in version 3.7: The _mp_context_ argument was added to
   allow users to control the start_method for worker processes
   created by the pool.Added the _initializer_ and _initargs_
   arguments.


ProcessPoolExecutor Example
---------------------------
>
   import concurrent.futures
   import math

   PRIMES = [
       112272535095293,
       112582705942171,
       112272535095293,
       115280095190773,
       115797848077099,
       1099726899285419]

   def is_prime(n):
       if n < 2:
           return False
       if n == 2:
           return True
       if n % 2 == 0:
           return False

       sqrt_n = int(math.floor(math.sqrt(n)))
       for i in range(3, sqrt_n + 1, 2):
           if n % i == 0:
               return False
       return True

   def main():
       with concurrent.futures.ProcessPoolExecutor() as executor:
           for number, prime in zip(PRIMES, executor.map(is_prime, PRIMES)):
               print('%d is prime: %s' % (number, prime))

   if __name__ == '__main__':
       main()
<

Future Objects
==============

The "Future" class encapsulates the asynchronous execution of a
callable. "Future" instances are created by "Executor.submit()".

class concurrent.futures.Future

   Encapsulates the asynchronous execution of a callable.  "Future"
   instances are created by "Executor.submit()" and should not be
   created directly except for testing.

      cancel()

         Attempt to cancel the call.  If the call is currently being
         executed or finished running and cannot be cancelled then the
         method will return "False", otherwise the call will be
         cancelled and the method will return "True".

      cancelled()

         Return "True" if the call was successfully cancelled.

      running()

         Return "True" if the call is currently being executed and
         cannot be cancelled.

      done()

         Return "True" if the call was successfully cancelled or
         finished running.

      result(timeout=None)

         Return the value returned by the call. If the call hasn’t yet
         completed then this method will wait up to _timeout_ seconds.
         If the call hasn’t completed in _timeout_ seconds, then a
         "concurrent.futures.TimeoutError" will be raised. _timeout_
         can be an int or float.  If _timeout_ is not specified or
         "None", there is no limit to the wait time.

         If the future is cancelled before completing then
         "CancelledError" will be raised.

         If the call raised an exception, this method will raise the
         same exception.

      exception(timeout=None)

         Return the exception raised by the call.  If the call hasn’t
         yet completed then this method will wait up to _timeout_
         seconds.  If the call hasn’t completed in _timeout_ seconds,
         then a "concurrent.futures.TimeoutError" will be raised.
         _timeout_ can be an int or float.  If _timeout_ is not
         specified or "None", there is no limit to the wait time.

         If the future is cancelled before completing then
         "CancelledError" will be raised.

         If the call completed without raising, "None" is returned.

      add_done_callback(fn)

         Attaches the callable _fn_ to the future.  _fn_ will be
         called, with the future as its only argument, when the future
         is cancelled or finishes running.

         Added callables are called in the order that they were added
         and are always called in a thread belonging to the process
         that added them.  If the callable raises an "Exception"
         subclass, it will be logged and ignored.  If the callable
         raises a "BaseException" subclass, the behavior is undefined.

         If the future has already completed or been cancelled, _fn_
         will be called immediately.

   The following "Future" methods are meant for use in unit tests and
   "Executor" implementations.

      set_running_or_notify_cancel()

         This method should only be called by "Executor"
         implementations before executing the work associated with the
         "Future" and by unit tests.

         If the method returns "False" then the "Future" was
         cancelled, i.e. "Future.cancel()" was called and returned
         _True_.  Any threads waiting on the "Future" completing (i.e.
         through "as_completed()" or "wait()") will be woken up.

         If the method returns "True" then the "Future" was not
         cancelled and has been put in the running state, i.e. calls
         to "Future.running()" will return _True_.

         This method can only be called once and cannot be called
         after "Future.set_result()" or "Future.set_exception()" have
         been called.

      set_result(result)

         Sets the result of the work associated with the "Future" to
         _result_.

         This method should only be used by "Executor" implementations
         and unit tests.

         Changed in version 3.8: This method raises
         "concurrent.futures.InvalidStateError" if the "Future" is
         already done.

      set_exception(exception)

         Sets the result of the work associated with the "Future" to
         the "Exception" _exception_.

         This method should only be used by "Executor" implementations
         and unit tests.

         Changed in version 3.8: This method raises
         "concurrent.futures.InvalidStateError" if the "Future" is
         already done.


Module Functions
================

concurrent.futures.wait(fs, timeout=None, return_when=ALL_COMPLETED)

   Wait for the "Future" instances (possibly created by different
   "Executor" instances) given by _fs_ to complete. Duplicate futures
   given to _fs_ are removed and will be returned only once. Returns a
   named 2-tuple of sets.  The first set, named "done", contains the
   futures that completed (finished or cancelled futures) before the
   wait completed.  The second set, named "not_done", contains the
   futures that did not complete (pending or running futures).

   _timeout_ can be used to control the maximum number of seconds to
   wait before returning.  _timeout_ can be an int or float.  If
   _timeout_ is not specified or "None", there is no limit to the wait
   time.

   _return_when_ indicates when this function should return.  It must
   be one of the following constants:

   +-------------------------------+------------------------------------------+
   | Constant                      | Description                              |
   |===============================|==========================================|
   | "FIRST_COMPLETED"             | The function will return when any future |
   |                               | finishes or is cancelled.                |
   +-------------------------------+------------------------------------------+
   | "FIRST_EXCEPTION"             | The function will return when any future |
   |                               | finishes by raising an exception.  If no |
   |                               | future raises an exception then it is    |
   |                               | equivalent to "ALL_COMPLETED".           |
   +-------------------------------+------------------------------------------+
   | "ALL_COMPLETED"               | The function will return when all        |
   |                               | futures finish or are cancelled.         |
   +-------------------------------+------------------------------------------+

concurrent.futures.as_completed(fs, timeout=None)

   Returns an iterator over the "Future" instances (possibly created
   by different "Executor" instances) given by _fs_ that yields
   futures as they complete (finished or cancelled futures). Any
   futures given by _fs_ that are duplicated will be returned once.
   Any futures that completed before "as_completed()" is called will
   be yielded first.  The returned iterator raises a
   "concurrent.futures.TimeoutError" if "__next__()" is called and the
   result isn’t available after _timeout_ seconds from the original
   call to "as_completed()".  _timeout_ can be an int or float. If
   _timeout_ is not specified or "None", there is no limit to the wait
   time.

See also:

  **PEP 3148** – futures - execute computations asynchronously
     The proposal which described this feature for inclusion in the
     Python standard library.


Exception classes
=================

exception concurrent.futures.CancelledError

   Raised when a future is cancelled.

exception concurrent.futures.TimeoutError

   Raised when a future operation exceeds the given timeout.

exception concurrent.futures.BrokenExecutor

   Derived from "RuntimeError", this exception class is raised when an
   executor is broken for some reason, and cannot be used to submit or
   execute new tasks.

   New in version 3.7.

exception concurrent.futures.InvalidStateError

   Raised when an operation is performed on a future that is not
   allowed in the current state.

   New in version 3.8.

exception concurrent.futures.thread.BrokenThreadPool

   Derived from "BrokenExecutor", this exception class is raised when
   one of the workers of a "ThreadPoolExecutor" has failed
   initializing.

   New in version 3.7.

exception concurrent.futures.process.BrokenProcessPool

   Derived from "BrokenExecutor" (formerly "RuntimeError"), this
   exception class is raised when one of the workers of a
   "ProcessPoolExecutor" has terminated in a non-clean fashion (for
   example, if it was killed from the outside).

   New in version 3.3.

vim:tw=78:ts=8:ft=help:norl: