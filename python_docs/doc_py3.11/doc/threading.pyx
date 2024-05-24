Python 3.11.9
*threading.pyx*                               Last change: 2024 May 24

"threading" — Thread-based parallelism
**************************************

**Source code:** Lib/threading.py

======================================================================

This module constructs higher-level threading interfaces on top of the
lower level "_thread" module.

Changed in version 3.7: This module used to be optional, it is now
always available.

See also:

  "concurrent.futures.ThreadPoolExecutor" offers a higher level
  interface to push tasks to a background thread without blocking
  execution of the calling thread, while still being able to retrieve
  their results when needed.

  "queue" provides a thread-safe interface for exchanging data between
  running threads.

  "asyncio" offers an alternative approach to achieving task level
  concurrency without requiring the use of multiple operating system
  threads.

Note:

  In the Python 2.x series, this module contained "camelCase" names
  for some methods and functions. These are deprecated as of Python
  3.10, but they are still supported for compatibility with Python 2.5
  and lower.

**CPython implementation detail:** In CPython, due to the _Global
Interpreter Lock_, only one thread can execute Python code at once
(even though certain performance-oriented libraries might overcome
this limitation). If you want your application to make better use of
the computational resources of multi-core machines, you are advised to
use "multiprocessing" or "concurrent.futures.ProcessPoolExecutor".
However, threading is still an appropriate model if you want to run
multiple I/O-bound tasks simultaneously.

Availability: not Emscripten, not WASI.

This module does not work or is not available on WebAssembly platforms
"wasm32-emscripten" and "wasm32-wasi". See WebAssembly platforms for
more information.

This module defines the following functions:

threading.active_count()

   Return the number of "Thread" objects currently alive.  The
   returned count is equal to the length of the list returned by
   "enumerate()".

   The function "activeCount" is a deprecated alias for this function.

threading.current_thread()

   Return the current "Thread" object, corresponding to the caller’s
   thread of control.  If the caller’s thread of control was not
   created through the "threading" module, a dummy thread object with
   limited functionality is returned.

   The function "currentThread" is a deprecated alias for this
   function.

threading.excepthook(args, /)

   Handle uncaught exception raised by "Thread.run()".

   The _args_ argument has the following attributes:

   * _exc_type_: Exception type.

   * _exc_value_: Exception value, can be "None".

   * _exc_traceback_: Exception traceback, can be "None".

   * _thread_: Thread which raised the exception, can be "None".

   If _exc_type_ is "SystemExit", the exception is silently ignored.
   Otherwise, the exception is printed out on "sys.stderr".

   If  this function raises an exception, "sys.excepthook()" is called
   to handle it.

   "threading.excepthook()" can be overridden to control how uncaught
   exceptions raised by "Thread.run()" are handled.

   Storing _exc_value_ using a custom hook can create a reference
   cycle. It should be cleared explicitly to break the reference cycle
   when the exception is no longer needed.

   Storing _thread_ using a custom hook can resurrect it if it is set
   to an object which is being finalized. Avoid storing _thread_ after
   the custom hook completes to avoid resurrecting objects.

   See also: "sys.excepthook()" handles uncaught exceptions.

   New in version 3.8.

threading.__excepthook__

   Holds the original value of "threading.excepthook()". It is saved
   so that the original value can be restored in case they happen to
   get replaced with broken or alternative objects.

   New in version 3.10.

threading.get_ident()

   Return the ‘thread identifier’ of the current thread.  This is a
   nonzero integer.  Its value has no direct meaning; it is intended
   as a magic cookie to be used e.g. to index a dictionary of thread-
   specific data.  Thread identifiers may be recycled when a thread
   exits and another thread is created.

   New in version 3.3.

threading.get_native_id()

   Return the native integral Thread ID of the current thread assigned
   by the kernel. This is a non-negative integer. Its value may be
   used to uniquely identify this particular thread system-wide (until
   the thread terminates, after which the value may be recycled by the
   OS).

   Availability: Windows, FreeBSD, Linux, macOS, OpenBSD, NetBSD, AIX.

   New in version 3.8.

threading.enumerate()

   Return a list of all "Thread" objects currently active.  The list
   includes daemonic threads and dummy thread objects created by
   "current_thread()".  It excludes terminated threads and threads
   that have not yet been started.  However, the main thread is always
   part of the result, even when terminated.

threading.main_thread()

   Return the main "Thread" object.  In normal conditions, the main
   thread is the thread from which the Python interpreter was started.

   New in version 3.4.

threading.settrace(func)

   Set a trace function for all threads started from the "threading"
   module. The _func_ will be passed to  "sys.settrace()" for each
   thread, before its "run()" method is called.

threading.gettrace()

   Get the trace function as set by "settrace()".

   New in version 3.10.

threading.setprofile(func)

   Set a profile function for all threads started from the "threading"
   module. The _func_ will be passed to  "sys.setprofile()" for each
   thread, before its "run()" method is called.

threading.getprofile()

   Get the profiler function as set by "setprofile()".

   New in version 3.10.

threading.stack_size([size])

   Return the thread stack size used when creating new threads.  The
   optional _size_ argument specifies the stack size to be used for
   subsequently created threads, and must be 0 (use platform or
   configured default) or a positive integer value of at least 32,768
   (32 KiB). If _size_ is not specified, 0 is used.  If changing the
   thread stack size is unsupported, a "RuntimeError" is raised.  If
   the specified stack size is invalid, a "ValueError" is raised and
   the stack size is unmodified.  32 KiB is currently the minimum
   supported stack size value to guarantee sufficient stack space for
   the interpreter itself.  Note that some platforms may have
   particular restrictions on values for the stack size, such as
   requiring a minimum stack size > 32 KiB or requiring allocation in
   multiples of the system memory page size - platform documentation
   should be referred to for more information (4 KiB pages are common;
   using multiples of 4096 for the stack size is the suggested
   approach in the absence of more specific information).

   Availability: Windows, pthreads.

   Unix platforms with POSIX threads support.

This module also defines the following constant:

threading.TIMEOUT_MAX

   The maximum value allowed for the _timeout_ parameter of blocking
   functions ("Lock.acquire()", "RLock.acquire()", "Condition.wait()",
   etc.). Specifying a timeout greater than this value will raise an
   "OverflowError".

   New in version 3.2.

This module defines a number of classes, which are detailed in the
sections below.

The design of this module is loosely based on Java’s threading model.
However, where Java makes locks and condition variables basic behavior
of every object, they are separate objects in Python.  Python’s
"Thread" class supports a subset of the behavior of Java’s Thread
class; currently, there are no priorities, no thread groups, and
threads cannot be destroyed, stopped, suspended, resumed, or
interrupted.  The static methods of Java’s Thread class, when
implemented, are mapped to module-level functions.

All of the methods described below are executed atomically.


Thread-Local Data
=================

Thread-local data is data whose values are thread specific.  To manage
thread-local data, just create an instance of "local" (or a subclass)
and store attributes on it:
>
   mydata = threading.local()
   mydata.x = 1
<
The instance’s values will be different for separate threads.

class threading.local

   A class that represents thread-local data.

   For more details and extensive examples, see the documentation
   string of the "_threading_local" module: Lib/_threading_local.py.


Thread Objects
==============

The "Thread" class represents an activity that is run in a separate
thread of control.  There are two ways to specify the activity: by
passing a callable object to the constructor, or by overriding the
"run()" method in a subclass.  No other methods (except for the
constructor) should be overridden in a subclass.  In other words,
_only_  override the "__init__()" and "run()" methods of this class.

Once a thread object is created, its activity must be started by
calling the thread’s "start()" method.  This invokes the "run()"
method in a separate thread of control.

Once the thread’s activity is started, the thread is considered
‘alive’. It stops being alive when its "run()" method terminates –
either normally, or by raising an unhandled exception.  The
"is_alive()" method tests whether the thread is alive.

Other threads can call a thread’s "join()" method.  This blocks the
calling thread until the thread whose "join()" method is called is
terminated.

A thread has a name.  The name can be passed to the constructor, and
read or changed through the "name" attribute.

If the "run()" method raises an exception, "threading.excepthook()" is
called to handle it. By default, "threading.excepthook()" ignores
silently "SystemExit".

A thread can be flagged as a “daemon thread”.  The significance of
this flag is that the entire Python program exits when only daemon
threads are left.  The initial value is inherited from the creating
thread.  The flag can be set through the "daemon" property or the
_daemon_ constructor argument.

Note:

  Daemon threads are abruptly stopped at shutdown.  Their resources
  (such as open files, database transactions, etc.) may not be
  released properly. If you want your threads to stop gracefully, make
  them non-daemonic and use a suitable signalling mechanism such as an
  "Event".

There is a “main thread” object; this corresponds to the initial
thread of control in the Python program.  It is not a daemon thread.

There is the possibility that “dummy thread objects” are created.
These are thread objects corresponding to “alien threads”, which are
threads of control started outside the threading module, such as
directly from C code.  Dummy thread objects have limited
functionality; they are always considered alive and daemonic, and
cannot be joined.  They are never deleted, since it is impossible to
detect the termination of alien threads.

class threading.Thread(group=None, target=None, name=None, args=(), kwargs={}, *, daemon=None)

   This constructor should always be called with keyword arguments.
   Arguments are:

   _group_ should be "None"; reserved for future extension when a
   "ThreadGroup" class is implemented.

   _target_ is the callable object to be invoked by the "run()"
   method. Defaults to "None", meaning nothing is called.

   _name_ is the thread name. By default, a unique name is constructed
   of the form “Thread-_N_” where _N_ is a small decimal number, or
   “Thread-_N_ (target)” where “target” is "target.__name__" if the
   _target_ argument is specified.

   _args_ is a list or tuple of arguments for the target invocation.
   Defaults to "()".

   _kwargs_ is a dictionary of keyword arguments for the target
   invocation. Defaults to "{}".

   If not "None", _daemon_ explicitly sets whether the thread is
   daemonic. If "None" (the default), the daemonic property is
   inherited from the current thread.

   If the subclass overrides the constructor, it must make sure to
   invoke the base class constructor ("Thread.__init__()") before
   doing anything else to the thread.

   Changed in version 3.3: Added the _daemon_ parameter.

   Changed in version 3.10: Use the _target_ name if _name_ argument
   is omitted.

   start()

      Start the thread’s activity.

      It must be called at most once per thread object.  It arranges
      for the object’s "run()" method to be invoked in a separate
      thread of control.

      This method will raise a "RuntimeError" if called more than once
      on the same thread object.

   run()

      Method representing the thread’s activity.

      You may override this method in a subclass.  The standard
      "run()" method invokes the callable object passed to the
      object’s constructor as the _target_ argument, if any, with
      positional and keyword arguments taken from the _args_ and
      _kwargs_ arguments, respectively.

      Using list or tuple as the _args_ argument which passed to the
      "Thread" could achieve the same effect.

      Example:
>
         >>> from threading import Thread
         >>> t = Thread(target=print, args=[1])
         >>> t.run()
         1
         >>> t = Thread(target=print, args=(1,))
         >>> t.run()
         1
<
   join(timeout=None)

      Wait until the thread terminates. This blocks the calling thread
      until the thread whose "join()" method is called terminates –
      either normally or through an unhandled exception – or until the
      optional timeout occurs.

      When the _timeout_ argument is present and not "None", it should
      be a floating point number specifying a timeout for the
      operation in seconds (or fractions thereof). As "join()" always
      returns "None", you must call "is_alive()" after "join()" to
      decide whether a timeout happened – if the thread is still
      alive, the "join()" call timed out.

      When the _timeout_ argument is not present or "None", the
      operation will block until the thread terminates.

      A thread can be joined many times.

      "join()" raises a "RuntimeError" if an attempt is made to join
      the current thread as that would cause a deadlock. It is also an
      error to "join()" a thread before it has been started and
      attempts to do so raise the same exception.

   name

      A string used for identification purposes only. It has no
      semantics. Multiple threads may be given the same name.  The
      initial name is set by the constructor.

   getName()
   setName()

      Deprecated getter/setter API for "name"; use it directly as a
      property instead.

      Deprecated since version 3.10.

   ident

      The ‘thread identifier’ of this thread or "None" if the thread
      has not been started.  This is a nonzero integer.  See the
      "get_ident()" function.  Thread identifiers may be recycled when
      a thread exits and another thread is created.  The identifier is
      available even after the thread has exited.

   native_id

      The Thread ID ("TID") of this thread, as assigned by the OS
      (kernel). This is a non-negative integer, or "None" if the
      thread has not been started. See the "get_native_id()" function.
      This value may be used to uniquely identify this particular
      thread system-wide (until the thread terminates, after which the
      value may be recycled by the OS).

      Note:

        Similar to Process IDs, Thread IDs are only valid (guaranteed
        unique system-wide) from the time the thread is created until
        the thread has been terminated.

      Availability: Windows, FreeBSD, Linux, macOS, OpenBSD, NetBSD,
      AIX, DragonFlyBSD.

      New in version 3.8.

   is_alive()

      Return whether the thread is alive.

      This method returns "True" just before the "run()" method starts
      until just after the "run()" method terminates.  The module
      function "enumerate()" returns a list of all alive threads.

   daemon

      A boolean value indicating whether this thread is a daemon
      thread ("True") or not ("False").  This must be set before
      "start()" is called, otherwise "RuntimeError" is raised.  Its
      initial value is inherited from the creating thread; the main
      thread is not a daemon thread and therefore all threads created
      in the main thread default to "daemon" = "False".

      The entire Python program exits when no alive non-daemon threads
      are left.

   isDaemon()
   setDaemon()

      Deprecated getter/setter API for "daemon"; use it directly as a
      property instead.

      Deprecated since version 3.10.


Lock Objects
============

A primitive lock is a synchronization primitive that is not owned by a
particular thread when locked.  In Python, it is currently the lowest
level synchronization primitive available, implemented directly by the
"_thread" extension module.

A primitive lock is in one of two states, “locked” or “unlocked”. It
is created in the unlocked state.  It has two basic methods,
"acquire()" and "release()".  When the state is unlocked, "acquire()"
changes the state to locked and returns immediately.  When the state
is locked, "acquire()" blocks until a call to "release()" in another
thread changes it to unlocked, then the "acquire()" call resets it to
locked and returns.  The "release()" method should only be called in
the locked state; it changes the state to unlocked and returns
immediately. If an attempt is made to release an unlocked lock, a
"RuntimeError" will be raised.

Locks also support the context management protocol.

When more than one thread is blocked in "acquire()" waiting for the
state to turn to unlocked, only one thread proceeds when a "release()"
call resets the state to unlocked; which one of the waiting threads
proceeds is not defined, and may vary across implementations.

All methods are executed atomically.

class threading.Lock

   The class implementing primitive lock objects.  Once a thread has
   acquired a lock, subsequent attempts to acquire it block, until it
   is released; any thread may release it.

   Note that "Lock" is actually a factory function which returns an
   instance of the most efficient version of the concrete Lock class
   that is supported by the platform.

   acquire(blocking=True, timeout=-1)

      Acquire a lock, blocking or non-blocking.

      When invoked with the _blocking_ argument set to "True" (the
      default), block until the lock is unlocked, then set it to
      locked and return "True".

      When invoked with the _blocking_ argument set to "False", do not
      block. If a call with _blocking_ set to "True" would block,
      return "False" immediately; otherwise, set the lock to locked
      and return "True".

      When invoked with the floating-point _timeout_ argument set to a
      positive value, block for at most the number of seconds
      specified by _timeout_ and as long as the lock cannot be
      acquired.  A _timeout_ argument of "-1" specifies an unbounded
      wait.  It is forbidden to specify a _timeout_ when _blocking_ is
      "False".

      The return value is "True" if the lock is acquired successfully,
      "False" if not (for example if the _timeout_ expired).

      Changed in version 3.2: The _timeout_ parameter is new.

      Changed in version 3.2: Lock acquisition can now be interrupted
      by signals on POSIX if the underlying threading implementation
      supports it.

   release()

      Release a lock.  This can be called from any thread, not only
      the thread which has acquired the lock.

      When the lock is locked, reset it to unlocked, and return.  If
      any other threads are blocked waiting for the lock to become
      unlocked, allow exactly one of them to proceed.

      When invoked on an unlocked lock, a "RuntimeError" is raised.

      There is no return value.

   locked()

      Return "True" if the lock is acquired.


RLock Objects
=============

A reentrant lock is a synchronization primitive that may be acquired
multiple times by the same thread.  Internally, it uses the concepts
of “owning thread” and “recursion level” in addition to the
locked/unlocked state used by primitive locks.  In the locked state,
some thread owns the lock; in the unlocked state, no thread owns it.

To lock the lock, a thread calls its "acquire()" method; this returns
once the thread owns the lock.  To unlock the lock, a thread calls its
"release()" method. "acquire()"/"release()" call pairs may be nested;
only the final "release()" (the "release()" of the outermost pair)
resets the lock to unlocked and allows another thread blocked in
"acquire()" to proceed.

Reentrant locks also support the context management protocol.

class threading.RLock

   This class implements reentrant lock objects.  A reentrant lock
   must be released by the thread that acquired it.  Once a thread has
   acquired a reentrant lock, the same thread may acquire it again
   without blocking; the thread must release it once for each time it
   has acquired it.

   Note that "RLock" is actually a factory function which returns an
   instance of the most efficient version of the concrete RLock class
   that is supported by the platform.

   acquire(blocking=True, timeout=-1)

      Acquire a lock, blocking or non-blocking.

      When invoked without arguments: if this thread already owns the
      lock, increment the recursion level by one, and return
      immediately.  Otherwise, if another thread owns the lock, block
      until the lock is unlocked.  Once the lock is unlocked (not
      owned by any thread), then grab ownership, set the recursion
      level to one, and return.  If more than one thread is blocked
      waiting until the lock is unlocked, only one at a time will be
      able to grab ownership of the lock. There is no return value in
      this case.

      When invoked with the _blocking_ argument set to "True", do the
      same thing as when called without arguments, and return "True".

      When invoked with the _blocking_ argument set to "False", do not
      block.  If a call without an argument would block, return
      "False" immediately; otherwise, do the same thing as when called
      without arguments, and return "True".

      When invoked with the floating-point _timeout_ argument set to a
      positive value, block for at most the number of seconds
      specified by _timeout_ and as long as the lock cannot be
      acquired.  Return "True" if the lock has been acquired, "False"
      if the timeout has elapsed.

      Changed in version 3.2: The _timeout_ parameter is new.

   release()

      Release a lock, decrementing the recursion level.  If after the
      decrement it is zero, reset the lock to unlocked (not owned by
      any thread), and if any other threads are blocked waiting for
      the lock to become unlocked, allow exactly one of them to
      proceed.  If after the decrement the recursion level is still
      nonzero, the lock remains locked and owned by the calling
      thread.

      Only call this method when the calling thread owns the lock. A
      "RuntimeError" is raised if this method is called when the lock
      is unlocked.

      There is no return value.


Condition Objects
=================

A condition variable is always associated with some kind of lock; this
can be passed in or one will be created by default.  Passing one in is
useful when several condition variables must share the same lock.  The
lock is part of the condition object: you don’t have to track it
separately.

A condition variable obeys the context management protocol: using the
"with" statement acquires the associated lock for the duration of the
enclosed block.  The "acquire()" and "release()" methods also call the
corresponding methods of the associated lock.

Other methods must be called with the associated lock held.  The
"wait()" method releases the lock, and then blocks until another
thread awakens it by calling "notify()" or "notify_all()".  Once
awakened, "wait()" re-acquires the lock and returns.  It is also
possible to specify a timeout.

The "notify()" method wakes up one of the threads waiting for the
condition variable, if any are waiting.  The "notify_all()" method
wakes up all threads waiting for the condition variable.

Note: the "notify()" and "notify_all()" methods don’t release the
lock; this means that the thread or threads awakened will not return
from their "wait()" call immediately, but only when the thread that
called "notify()" or "notify_all()" finally relinquishes ownership of
the lock.

The typical programming style using condition variables uses the lock
to synchronize access to some shared state; threads that are
interested in a particular change of state call "wait()" repeatedly
until they see the desired state, while threads that modify the state
call "notify()" or "notify_all()" when they change the state in such a
way that it could possibly be a desired state for one of the waiters.
For example, the following code is a generic producer-consumer
situation with unlimited buffer capacity:
>
   # Consume one item
   with cv:
       while not an_item_is_available():
           cv.wait()
       get_an_available_item()

   # Produce one item
   with cv:
       make_an_item_available()
       cv.notify()
<
The "while" loop checking for the application’s condition is necessary
because "wait()" can return after an arbitrary long time, and the
condition which prompted the "notify()" call may no longer hold true.
This is inherent to multi-threaded programming.  The "wait_for()"
method can be used to automate the condition checking, and eases the
computation of timeouts:
>
   # Consume an item
   with cv:
       cv.wait_for(an_item_is_available)
       get_an_available_item()
<
To choose between "notify()" and "notify_all()", consider whether one
state change can be interesting for only one or several waiting
threads.  E.g. in a typical producer-consumer situation, adding one
item to the buffer only needs to wake up one consumer thread.

class threading.Condition(lock=None)

   This class implements condition variable objects.  A condition
   variable allows one or more threads to wait until they are notified
   by another thread.

   If the _lock_ argument is given and not "None", it must be a "Lock"
   or "RLock" object, and it is used as the underlying lock.
   Otherwise, a new "RLock" object is created and used as the
   underlying lock.

   Changed in version 3.3: changed from a factory function to a class.

   acquire(*args)

      Acquire the underlying lock. This method calls the corresponding
      method on the underlying lock; the return value is whatever that
      method returns.

   release()

      Release the underlying lock. This method calls the corresponding
      method on the underlying lock; there is no return value.

   wait(timeout=None)

      Wait until notified or until a timeout occurs. If the calling
      thread has not acquired the lock when this method is called, a
      "RuntimeError" is raised.

      This method releases the underlying lock, and then blocks until
      it is awakened by a "notify()" or "notify_all()" call for the
      same condition variable in another thread, or until the optional
      timeout occurs.  Once awakened or timed out, it re-acquires the
      lock and returns.

      When the _timeout_ argument is present and not "None", it should
      be a floating point number specifying a timeout for the
      operation in seconds (or fractions thereof).

      When the underlying lock is an "RLock", it is not released using
      its "release()" method, since this may not actually unlock the
      lock when it was acquired multiple times recursively.  Instead,
      an internal interface of the "RLock" class is used, which really
      unlocks it even when it has been recursively acquired several
      times. Another internal interface is then used to restore the
      recursion level when the lock is reacquired.

      The return value is "True" unless a given _timeout_ expired, in
      which case it is "False".

      Changed in version 3.2: Previously, the method always returned
      "None".

   wait_for(predicate, timeout=None)

      Wait until a condition evaluates to true.  _predicate_ should be
      a callable which result will be interpreted as a boolean value.
      A _timeout_ may be provided giving the maximum time to wait.

      This utility method may call "wait()" repeatedly until the
      predicate is satisfied, or until a timeout occurs. The return
      value is the last return value of the predicate and will
      evaluate to "False" if the method timed out.

      Ignoring the timeout feature, calling this method is roughly
      equivalent to writing:
>
         while not predicate():
             cv.wait()
<
      Therefore, the same rules apply as with "wait()": The lock must
      be held when called and is re-acquired on return.  The predicate
      is evaluated with the lock held.

      New in version 3.2.

   notify(n=1)

      By default, wake up one thread waiting on this condition, if
      any.  If the calling thread has not acquired the lock when this
      method is called, a "RuntimeError" is raised.

      This method wakes up at most _n_ of the threads waiting for the
      condition variable; it is a no-op if no threads are waiting.

      The current implementation wakes up exactly _n_ threads, if at
      least _n_ threads are waiting.  However, it’s not safe to rely
      on this behavior. A future, optimized implementation may
      occasionally wake up more than _n_ threads.

      Note: an awakened thread does not actually return from its
      "wait()" call until it can reacquire the lock.  Since "notify()"
      does not release the lock, its caller should.

   notify_all()

      Wake up all threads waiting on this condition.  This method acts
      like "notify()", but wakes up all waiting threads instead of
      one. If the calling thread has not acquired the lock when this
      method is called, a "RuntimeError" is raised.

      The method "notifyAll" is a deprecated alias for this method.


Semaphore Objects
=================

This is one of the oldest synchronization primitives in the history of
computer science, invented by the early Dutch computer scientist
Edsger W. Dijkstra (he used the names "P()" and "V()" instead of
"acquire()" and "release()").

A semaphore manages an internal counter which is decremented by each
"acquire()" call and incremented by each "release()" call.  The
counter can never go below zero; when "acquire()" finds that it is
zero, it blocks, waiting until some other thread calls "release()".

Semaphores also support the context management protocol.

class threading.Semaphore(value=1)

   This class implements semaphore objects.  A semaphore manages an
   atomic counter representing the number of "release()" calls minus
   the number of "acquire()" calls, plus an initial value.  The
   "acquire()" method blocks if necessary until it can return without
   making the counter negative. If not given, _value_ defaults to 1.

   The optional argument gives the initial _value_ for the internal
   counter; it defaults to "1". If the _value_ given is less than 0,
   "ValueError" is raised.

   Changed in version 3.3: changed from a factory function to a class.

   acquire(blocking=True, timeout=None)

      Acquire a semaphore.

      When invoked without arguments:

      * If the internal counter is larger than zero on entry,
        decrement it by one and return "True" immediately.

      * If the internal counter is zero on entry, block until awoken
        by a call to "release()".  Once awoken (and the counter is
        greater than 0), decrement the counter by 1 and return "True".
        Exactly one thread will be awoken by each call to "release()".
        The order in which threads are awoken should not be relied on.

      When invoked with _blocking_ set to "False", do not block.  If a
      call without an argument would block, return "False"
      immediately; otherwise, do the same thing as when called without
      arguments, and return "True".

      When invoked with a _timeout_ other than "None", it will block
      for at most _timeout_ seconds.  If acquire does not complete
      successfully in that interval, return "False".  Return "True"
      otherwise.

      Changed in version 3.2: The _timeout_ parameter is new.

   release(n=1)

      Release a semaphore, incrementing the internal counter by _n_.
      When it was zero on entry and other threads are waiting for it
      to become larger than zero again, wake up _n_ of those threads.

      Changed in version 3.9: Added the _n_ parameter to release
      multiple waiting threads at once.

class threading.BoundedSemaphore(value=1)

   Class implementing bounded semaphore objects.  A bounded semaphore
   checks to make sure its current value doesn’t exceed its initial
   value.  If it does, "ValueError" is raised. In most situations
   semaphores are used to guard resources with limited capacity.  If
   the semaphore is released too many times it’s a sign of a bug.  If
   not given, _value_ defaults to 1.

   Changed in version 3.3: changed from a factory function to a class.


"Semaphore" Example
-------------------

Semaphores are often used to guard resources with limited capacity,
for example, a database server.  In any situation where the size of
the resource is fixed, you should use a bounded semaphore.  Before
spawning any worker threads, your main thread would initialize the
semaphore:
>
   maxconnections = 5
   # ...
   pool_sema = BoundedSemaphore(value=maxconnections)
<
Once spawned, worker threads call the semaphore’s acquire and release
methods when they need to connect to the server:
>
   with pool_sema:
       conn = connectdb()
       try:
           # ... use connection ...
       finally:
           conn.close()
<
The use of a bounded semaphore reduces the chance that a programming
error which causes the semaphore to be released more than it’s
acquired will go undetected.


Event Objects
=============

This is one of the simplest mechanisms for communication between
threads: one thread signals an event and other threads wait for it.

An event object manages an internal flag that can be set to true with
the "set()" method and reset to false with the "clear()" method.  The
"wait()" method blocks until the flag is true.

class threading.Event

   Class implementing event objects.  An event manages a flag that can
   be set to true with the "set()" method and reset to false with the
   "clear()" method.  The "wait()" method blocks until the flag is
   true. The flag is initially false.

   Changed in version 3.3: changed from a factory function to a class.

   is_set()

      Return "True" if and only if the internal flag is true.

      The method "isSet" is a deprecated alias for this method.

   set()

      Set the internal flag to true. All threads waiting for it to
      become true are awakened. Threads that call "wait()" once the
      flag is true will not block at all.

   clear()

      Reset the internal flag to false. Subsequently, threads calling
      "wait()" will block until "set()" is called to set the internal
      flag to true again.

   wait(timeout=None)

      Block as long as the internal flag is false and the timeout, if
      given, has not expired. The return value represents the reason
      that this blocking method returned; "True" if returning because
      the internal flag is set to true, or "False" if a timeout is
      given and the the internal flag did not become true within the
      given wait time.

      When the timeout argument is present and not "None", it should
      be a floating point number specifying a timeout for the
      operation in seconds, or fractions thereof.

      Changed in version 3.1: Previously, the method always returned
      "None".


Timer Objects
=============

This class represents an action that should be run only after a
certain amount of time has passed — a timer.  "Timer" is a subclass of
"Thread" and as such also functions as an example of creating custom
threads.

Timers are started, as with threads, by calling their "Timer.start"
method.  The timer can be stopped (before its action has begun) by
calling the "cancel()" method.  The interval the timer will wait
before executing its action may not be exactly the same as the
interval specified by the user.

For example:
>
   def hello():
       print("hello, world")

   t = Timer(30.0, hello)
   t.start()  # after 30 seconds, "hello, world" will be printed
<
class threading.Timer(interval, function, args=None, kwargs=None)

   Create a timer that will run _function_ with arguments _args_ and
   keyword arguments _kwargs_, after _interval_ seconds have passed.
   If _args_ is "None" (the default) then an empty list will be used.
   If _kwargs_ is "None" (the default) then an empty dict will be
   used.

   Changed in version 3.3: changed from a factory function to a class.

   cancel()

      Stop the timer, and cancel the execution of the timer’s action.
      This will only work if the timer is still in its waiting stage.


Barrier Objects
===============

New in version 3.2.

This class provides a simple synchronization primitive for use by a
fixed number of threads that need to wait for each other.  Each of the
threads tries to pass the barrier by calling the "wait()" method and
will block until all of the threads have made their "wait()" calls. At
this point, the threads are released simultaneously.

The barrier can be reused any number of times for the same number of
threads.

As an example, here is a simple way to synchronize a client and server
thread:
>
   b = Barrier(2, timeout=5)

   def server():
       start_server()
       b.wait()
       while True:
           connection = accept_connection()
           process_server_connection(connection)

   def client():
       b.wait()
       while True:
           connection = make_connection()
           process_client_connection(connection)
<
class threading.Barrier(parties, action=None, timeout=None)

   Create a barrier object for _parties_ number of threads.  An
   _action_, when provided, is a callable to be called by one of the
   threads when they are released.  _timeout_ is the default timeout
   value if none is specified for the "wait()" method.

   wait(timeout=None)

      Pass the barrier.  When all the threads party to the barrier
      have called this function, they are all released simultaneously.
      If a _timeout_ is provided, it is used in preference to any that
      was supplied to the class constructor.

      The return value is an integer in the range 0 to _parties_ – 1,
      different for each thread.  This can be used to select a thread
      to do some special housekeeping, e.g.:
>
         i = barrier.wait()
         if i == 0:
             # Only one thread needs to print this
             print("passed the barrier")
<
      If an _action_ was provided to the constructor, one of the
      threads will have called it prior to being released.  Should
      this call raise an error, the barrier is put into the broken
      state.

      If the call times out, the barrier is put into the broken state.

      This method may raise a "BrokenBarrierError" exception if the
      barrier is broken or reset while a thread is waiting.

   reset()

      Return the barrier to the default, empty state.  Any threads
      waiting on it will receive the "BrokenBarrierError" exception.

      Note that using this function may require some external
      synchronization if there are other threads whose state is
      unknown.  If a barrier is broken it may be better to just leave
      it and create a new one.

   abort()

      Put the barrier into a broken state.  This causes any active or
      future calls to "wait()" to fail with the "BrokenBarrierError".
      Use this for example if one of the threads needs to abort, to
      avoid deadlocking the application.

      It may be preferable to simply create the barrier with a
      sensible _timeout_ value to automatically guard against one of
      the threads going awry.

   parties

      The number of threads required to pass the barrier.

   n_waiting

      The number of threads currently waiting in the barrier.

   broken

      A boolean that is "True" if the barrier is in the broken state.

exception threading.BrokenBarrierError

   This exception, a subclass of "RuntimeError", is raised when the
   "Barrier" object is reset or broken.


Using locks, conditions, and semaphores in the "with" statement
===============================================================

All of the objects provided by this module that have "acquire" and
"release" methods can be used as context managers for a "with"
statement.  The "acquire" method will be called when the block is
entered, and "release" will be called when the block is exited.
Hence, the following snippet:
>
   with some_lock:
       # do something...
<
is equivalent to:
>
   some_lock.acquire()
   try:
       # do something...
   finally:
       some_lock.release()
<
Currently, "Lock", "RLock", "Condition", "Semaphore", and
"BoundedSemaphore" objects may be used as "with" statement context
managers.

vim:tw=78:ts=8:ft=help:norl: