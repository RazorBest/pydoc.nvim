Python 3.11.9
*asyncio-task.pyx*                            Last change: 2024 May 24

Coroutines and Tasks
********************

This section outlines high-level asyncio APIs to work with coroutines
and Tasks.

* Coroutines

* Awaitables

* Creating Tasks

* Task Cancellation

* Task Groups

* Sleeping

* Running Tasks Concurrently

* Shielding From Cancellation

* Timeouts

* Waiting Primitives

* Running in Threads

* Scheduling From Other Threads

* Introspection

* Task Object


Coroutines
==========

**Source code:** Lib/asyncio/coroutines.py

======================================================================

_Coroutines_ declared with the async/await syntax is the preferred way
of writing asyncio applications.  For example, the following snippet
of code prints “hello”, waits 1 second, and then prints “world”:
>
   >>> import asyncio

   >>> async def main():
   ...     print('hello')
   ...     await asyncio.sleep(1)
   ...     print('world')

   >>> asyncio.run(main())
   hello
   world
<
Note that simply calling a coroutine will not schedule it to be
executed:
>
   >>> main()
   <coroutine object main at 0x1053bb7c8>
<
To actually run a coroutine, asyncio provides the following
mechanisms:

* The "asyncio.run()" function to run the top-level entry point
  “main()” function (see the above example.)

* Awaiting on a coroutine.  The following snippet of code will print
  “hello” after waiting for 1 second, and then print “world” after
  waiting for _another_ 2 seconds:
>
     import asyncio
     import time

     async def say_after(delay, what):
         await asyncio.sleep(delay)
         print(what)

     async def main():
         print(f"started at {time.strftime('%X')}")

         await say_after(1, 'hello')
         await say_after(2, 'world')

         print(f"finished at {time.strftime('%X')}")

     asyncio.run(main())
<
  Expected output:
>
     started at 17:13:52
     hello
     world
     finished at 17:13:55
<
* The "asyncio.create_task()" function to run coroutines concurrently
  as asyncio "Tasks".

  Let’s modify the above example and run two "say_after" coroutines
  _concurrently_:
>
     async def main():
         task1 = asyncio.create_task(
             say_after(1, 'hello'))

         task2 = asyncio.create_task(
             say_after(2, 'world'))

         print(f"started at {time.strftime('%X')}")

         # Wait until both tasks are completed (should take
         # around 2 seconds.)
         await task1
         await task2

         print(f"finished at {time.strftime('%X')}")
<
  Note that expected output now shows that the snippet runs 1 second
  faster than before:
>
     started at 17:14:32
     hello
     world
     finished at 17:14:34
<
* The "asyncio.TaskGroup" class provides a more modern alternative to
  "create_task()". Using this API, the last example becomes:
>
     async def main():
         async with asyncio.TaskGroup() as tg:
             task1 = tg.create_task(
                 say_after(1, 'hello'))

             task2 = tg.create_task(
                 say_after(2, 'world'))

             print(f"started at {time.strftime('%X')}")

         # The await is implicit when the context manager exits.

         print(f"finished at {time.strftime('%X')}")
<
  The timing and output should be the same as for the previous
  version.

  New in version 3.11: "asyncio.TaskGroup".


Awaitables
==========

We say that an object is an **awaitable** object if it can be used in
an "await" expression.  Many asyncio APIs are designed to accept
awaitables.

There are three main types of _awaitable_ objects: **coroutines**,
**Tasks**, and **Futures**.

-[ Coroutines ]-

Python coroutines are _awaitables_ and therefore can be awaited from
other coroutines:
>
   import asyncio

   async def nested():
       return 42

   async def main():
       # Nothing happens if we just call "nested()".
       # A coroutine object is created but not awaited,
       # so it *won't run at all*.
       nested()

       # Let's do it differently now and await it:
       print(await nested())  # will print "42".

   asyncio.run(main())
<
Important:

  In this documentation the term “coroutine” can be used for two
  closely related concepts:

  * a _coroutine function_: an "async def" function;

  * a _coroutine object_: an object returned by calling a _coroutine
    function_.

-[ Tasks ]-

_Tasks_ are used to schedule coroutines _concurrently_.

When a coroutine is wrapped into a _Task_ with functions like
"asyncio.create_task()" the coroutine is automatically scheduled to
run soon:
>
   import asyncio

   async def nested():
       return 42

   async def main():
       # Schedule nested() to run soon concurrently
       # with "main()".
       task = asyncio.create_task(nested())

       # "task" can now be used to cancel "nested()", or
       # can simply be awaited to wait until it is complete:
       await task

   asyncio.run(main())
<
-[ Futures ]-

A "Future" is a special **low-level** awaitable object that represents
an **eventual result** of an asynchronous operation.

When a Future object is _awaited_ it means that the coroutine will
wait until the Future is resolved in some other place.

Future objects in asyncio are needed to allow callback-based code to
be used with async/await.

Normally **there is no need** to create Future objects at the
application level code.

Future objects, sometimes exposed by libraries and some asyncio APIs,
can be awaited:
>
   async def main():
       await function_that_returns_a_future_object()

       # this is also valid:
       await asyncio.gather(
           function_that_returns_a_future_object(),
           some_python_coroutine()
       )
<
A good example of a low-level function that returns a Future object is
"loop.run_in_executor()".


Creating Tasks
==============

**Source code:** Lib/asyncio/tasks.py

======================================================================

asyncio.create_task(coro, *, name=None, context=None)

   Wrap the _coro_ coroutine into a "Task" and schedule its execution.
   Return the Task object.

   If _name_ is not "None", it is set as the name of the task using
   "Task.set_name()".

   An optional keyword-only _context_ argument allows specifying a
   custom "contextvars.Context" for the _coro_ to run in. The current
   context copy is created when no _context_ is provided.

   The task is executed in the loop returned by "get_running_loop()",
   "RuntimeError" is raised if there is no running loop in current
   thread.

   Note:

     "asyncio.TaskGroup.create_task()" is a newer alternative that
     allows for convenient waiting for a group of related tasks.

   Important:

     Save a reference to the result of this function, to avoid a task
     disappearing mid-execution. The event loop only keeps weak
     references to tasks. A task that isn’t referenced elsewhere may
     get garbage collected at any time, even before it’s done. For
     reliable “fire-and-forget” background tasks, gather them in a
     collection:

>
        background_tasks = set()

        for i in range(10):
            task = asyncio.create_task(some_coro(param=i))

            # Add task to the set. This creates a strong reference.
            background_tasks.add(task)

            # To prevent keeping references to finished tasks forever,
            # make each task remove its own reference from the set after
            # completion:
            task.add_done_callback(background_tasks.discard)
<
   New in version 3.7.

   Changed in version 3.8: Added the _name_ parameter.

   Changed in version 3.11: Added the _context_ parameter.


Task Cancellation
=================

Tasks can easily and safely be cancelled. When a task is cancelled,
"asyncio.CancelledError" will be raised in the task at the next
opportunity.

It is recommended that coroutines use "try/finally" blocks to robustly
perform clean-up logic. In case "asyncio.CancelledError" is explicitly
caught, it should generally be propagated when clean-up is complete.
"asyncio.CancelledError" directly subclasses "BaseException" so most
code will not need to be aware of it.

The asyncio components that enable structured concurrency, like
"asyncio.TaskGroup" and "asyncio.timeout()", are implemented using
cancellation internally and might misbehave if a coroutine swallows
"asyncio.CancelledError". Similarly, user code should not generally
call "uncancel". However, in cases when suppressing
"asyncio.CancelledError" is truly desired, it is necessary to also
call "uncancel()" to completely remove the cancellation state.


Task Groups
===========

Task groups combine a task creation API with a convenient and reliable
way to wait for all tasks in the group to finish.

class asyncio.TaskGroup

   An asynchronous context manager holding a group of tasks. Tasks can
   be added to the group using "create_task()". All tasks are awaited
   when the context manager exits.

   New in version 3.11.

   create_task(coro, *, name=None, context=None)

      Create a task in this task group. The signature matches that of
      "asyncio.create_task()".

Example:
>
   async def main():
       async with asyncio.TaskGroup() as tg:
           task1 = tg.create_task(some_coro(...))
           task2 = tg.create_task(another_coro(...))
       print("Both tasks have completed now.")
<
The "async with" statement will wait for all tasks in the group to
finish. While waiting, new tasks may still be added to the group (for
example, by passing "tg" into one of the coroutines and calling
"tg.create_task()" in that coroutine). Once the last task has finished
and the "async with" block is exited, no new tasks may be added to the
group.

The first time any of the tasks belonging to the group fails with an
exception other than "asyncio.CancelledError", the remaining tasks in
the group are cancelled. No further tasks can then be added to the
group. At this point, if the body of the "async with" statement is
still active (i.e., "__aexit__()" hasn’t been called yet), the task
directly containing the "async with" statement is also cancelled. The
resulting "asyncio.CancelledError" will interrupt an "await", but it
will not bubble out of the containing "async with" statement.

Once all tasks have finished, if any tasks have failed with an
exception other than "asyncio.CancelledError", those exceptions are
combined in an "ExceptionGroup" or "BaseExceptionGroup" (as
appropriate; see their documentation) which is then raised.

Two base exceptions are treated specially: If any task fails with
"KeyboardInterrupt" or "SystemExit", the task group still cancels the
remaining tasks and waits for them, but then the initial
"KeyboardInterrupt" or "SystemExit" is re-raised instead of
"ExceptionGroup" or "BaseExceptionGroup".

If the body of the "async with" statement exits with an exception (so
"__aexit__()" is called with an exception set), this is treated the
same as if one of the tasks failed: the remaining tasks are cancelled
and then waited for, and non-cancellation exceptions are grouped into
an exception group and raised. The exception passed into
"__aexit__()", unless it is "asyncio.CancelledError", is also included
in the exception group. The same special case is made for
"KeyboardInterrupt" and "SystemExit" as in the previous paragraph.


Sleeping
========

coroutine asyncio.sleep(delay, result=None)

   Block for _delay_ seconds.

   If _result_ is provided, it is returned to the caller when the
   coroutine completes.

   "sleep()" always suspends the current task, allowing other tasks to
   run.

   Setting the delay to 0 provides an optimized path to allow other
   tasks to run. This can be used by long-running functions to avoid
   blocking the event loop for the full duration of the function call.

   Example of coroutine displaying the current date every second for 5
   seconds:
>
      import asyncio
      import datetime

      async def display_date():
          loop = asyncio.get_running_loop()
          end_time = loop.time() + 5.0
          while True:
              print(datetime.datetime.now())
              if (loop.time() + 1.0) >= end_time:
                  break
              await asyncio.sleep(1)

      asyncio.run(display_date())
<
   Changed in version 3.10: Removed the _loop_ parameter.


Running Tasks Concurrently
==========================

awaitable asyncio.gather(*aws, return_exceptions=False)

   Run awaitable objects in the _aws_ sequence _concurrently_.

   If any awaitable in _aws_ is a coroutine, it is automatically
   scheduled as a Task.

   If all awaitables are completed successfully, the result is an
   aggregate list of returned values.  The order of result values
   corresponds to the order of awaitables in _aws_.

   If _return_exceptions_ is "False" (default), the first raised
   exception is immediately propagated to the task that awaits on
   "gather()".  Other awaitables in the _aws_ sequence **won’t be
   cancelled** and will continue to run.

   If _return_exceptions_ is "True", exceptions are treated the same
   as successful results, and aggregated in the result list.

   If "gather()" is _cancelled_, all submitted awaitables (that have
   not completed yet) are also _cancelled_.

   If any Task or Future from the _aws_ sequence is _cancelled_, it is
   treated as if it raised "CancelledError" – the "gather()" call is
   **not** cancelled in this case.  This is to prevent the
   cancellation of one submitted Task/Future to cause other
   Tasks/Futures to be cancelled.

   Note:

     A more modern way to create and run tasks concurrently and wait
     for their completion is "asyncio.TaskGroup".

   Example:
>
      import asyncio

      async def factorial(name, number):
          f = 1
          for i in range(2, number + 1):
              print(f"Task {name}: Compute factorial({number}), currently i={i}...")
              await asyncio.sleep(1)
              f *= i
          print(f"Task {name}: factorial({number}) = {f}")
          return f

      async def main():
          # Schedule three calls *concurrently*:
          L = await asyncio.gather(
              factorial("A", 2),
              factorial("B", 3),
              factorial("C", 4),
          )
          print(L)

      asyncio.run(main())

      # Expected output:
      #
      #     Task A: Compute factorial(2), currently i=2...
      #     Task B: Compute factorial(3), currently i=2...
      #     Task C: Compute factorial(4), currently i=2...
      #     Task A: factorial(2) = 2
      #     Task B: Compute factorial(3), currently i=3...
      #     Task C: Compute factorial(4), currently i=3...
      #     Task B: factorial(3) = 6
      #     Task C: Compute factorial(4), currently i=4...
      #     Task C: factorial(4) = 24
      #     [2, 6, 24]
<
   Note:

     If _return_exceptions_ is False, cancelling gather() after it has
     been marked done won’t cancel any submitted awaitables. For
     instance, gather can be marked done after propagating an
     exception to the caller, therefore, calling "gather.cancel()"
     after catching an exception (raised by one of the awaitables)
     from gather won’t cancel any other awaitables.

   Changed in version 3.7: If the _gather_ itself is cancelled, the
   cancellation is propagated regardless of _return_exceptions_.

   Changed in version 3.10: Removed the _loop_ parameter.

   Deprecated since version 3.10: Deprecation warning is emitted if no
   positional arguments are provided or not all positional arguments
   are Future-like objects and there is no running event loop.


Shielding From Cancellation
===========================

awaitable asyncio.shield(aw)

   Protect an awaitable object from being "cancelled".

   If _aw_ is a coroutine it is automatically scheduled as a Task.

   The statement:
>
      task = asyncio.create_task(something())
      res = await shield(task)
<
   is equivalent to:
>
      res = await something()
<
   _except_ that if the coroutine containing it is cancelled, the Task
   running in "something()" is not cancelled.  From the point of view
   of "something()", the cancellation did not happen. Although its
   caller is still cancelled, so the “await” expression still raises a
   "CancelledError".

   If "something()" is cancelled by other means (i.e. from within
   itself) that would also cancel "shield()".

   If it is desired to completely ignore cancellation (not
   recommended) the "shield()" function should be combined with a
   try/except clause, as follows:
>
      task = asyncio.create_task(something())
      try:
          res = await shield(task)
      except CancelledError:
          res = None
<
   Important:

     Save a reference to tasks passed to this function, to avoid a
     task disappearing mid-execution. The event loop only keeps weak
     references to tasks. A task that isn’t referenced elsewhere may
     get garbage collected at any time, even before it’s done.

   Changed in version 3.10: Removed the _loop_ parameter.

   Deprecated since version 3.10: Deprecation warning is emitted if
   _aw_ is not Future-like object and there is no running event loop.


Timeouts
========

asyncio.timeout(delay)

   Return an asynchronous context manager that can be used to limit
   the amount of time spent waiting on something.

   _delay_ can either be "None", or a float/int number of seconds to
   wait. If _delay_ is "None", no time limit will be applied; this can
   be useful if the delay is unknown when the context manager is
   created.

   In either case, the context manager can be rescheduled after
   creation using "Timeout.reschedule()".

   Example:
>
      async def main():
          async with asyncio.timeout(10):
              await long_running_task()
<
   If "long_running_task" takes more than 10 seconds to complete, the
   context manager will cancel the current task and handle the
   resulting "asyncio.CancelledError" internally, transforming it into
   a "TimeoutError" which can be caught and handled.

   Note:

     The "asyncio.timeout()" context manager is what transforms the
     "asyncio.CancelledError" into a "TimeoutError", which means the
     "TimeoutError" can only be caught _outside_ of the context
     manager.

   Example of catching "TimeoutError":
>
      async def main():
          try:
              async with asyncio.timeout(10):
                  await long_running_task()
          except TimeoutError:
              print("The long operation timed out, but we've handled it.")

          print("This statement will run regardless.")
<
   The context manager produced by "asyncio.timeout()" can be
   rescheduled to a different deadline and inspected.

   class asyncio.Timeout(when)

      An asynchronous context manager for cancelling overdue
      coroutines.

      "when" should be an absolute time at which the context should
      time out, as measured by the event loop’s clock:

      * If "when" is "None", the timeout will never trigger.

      * If "when < loop.time()", the timeout will trigger on the next
        iteration of the event loop.

         when() -> float | None

            Return the current deadline, or "None" if the current
            deadline is not set.

         reschedule(when: float | None)

            Reschedule the timeout.

         expired() -> bool

            Return whether the context manager has exceeded its
            deadline (expired).

   Example:
>
      async def main():
          try:
              # We do not know the timeout when starting, so we pass ``None``.
              async with asyncio.timeout(None) as cm:
                  # We know the timeout now, so we reschedule it.
                  new_deadline = get_running_loop().time() + 10
                  cm.reschedule(new_deadline)

                  await long_running_task()
          except TimeoutError:
              pass

          if cm.expired():
              print("Looks like we haven't finished on time.")
<
   Timeout context managers can be safely nested.

   New in version 3.11.

asyncio.timeout_at(when)

   Similar to "asyncio.timeout()", except _when_ is the absolute time
   to stop waiting, or "None".

   Example:
>
      async def main():
          loop = get_running_loop()
          deadline = loop.time() + 20
          try:
              async with asyncio.timeout_at(deadline):
                  await long_running_task()
          except TimeoutError:
              print("The long operation timed out, but we've handled it.")

          print("This statement will run regardless.")
<
   New in version 3.11.

coroutine asyncio.wait_for(aw, timeout)

   Wait for the _aw_ awaitable to complete with a timeout.

   If _aw_ is a coroutine it is automatically scheduled as a Task.

   _timeout_ can either be "None" or a float or int number of seconds
   to wait for.  If _timeout_ is "None", block until the future
   completes.

   If a timeout occurs, it cancels the task and raises "TimeoutError".

   To avoid the task "cancellation", wrap it in "shield()".

   The function will wait until the future is actually cancelled, so
   the total wait time may exceed the _timeout_. If an exception
   happens during cancellation, it is propagated.

   If the wait is cancelled, the future _aw_ is also cancelled.

   Example:
>
      async def eternity():
          # Sleep for one hour
          await asyncio.sleep(3600)
          print('yay!')

      async def main():
          # Wait for at most 1 second
          try:
              await asyncio.wait_for(eternity(), timeout=1.0)
          except TimeoutError:
              print('timeout!')

      asyncio.run(main())

      # Expected output:
      #
      #     timeout!
<
   Changed in version 3.7: When _aw_ is cancelled due to a timeout,
   "wait_for" waits for _aw_ to be cancelled.  Previously, it raised
   "TimeoutError" immediately.

   Changed in version 3.10: Removed the _loop_ parameter.

   Changed in version 3.11: Raises "TimeoutError" instead of
   "asyncio.TimeoutError".


Waiting Primitives
==================

coroutine asyncio.wait(aws, *, timeout=None, return_when=ALL_COMPLETED)

   Run "Future" and "Task" instances in the _aws_ iterable
   concurrently and block until the condition specified by
   _return_when_.

   The _aws_ iterable must not be empty and generators yielding tasks
   are not accepted.

   Returns two sets of Tasks/Futures: "(done, pending)".

   Usage:
>
      done, pending = await asyncio.wait(aws)
<
   _timeout_ (a float or int), if specified, can be used to control
   the maximum number of seconds to wait before returning.

   Note that this function does not raise "TimeoutError". Futures or
   Tasks that aren’t done when the timeout occurs are simply returned
   in the second set.

   _return_when_ indicates when this function should return.  It must
   be one of the following constants:

   +----------------------------------------------------+----------------------------------------------------+
   | Constant                                           | Description                                        |
   |====================================================|====================================================|
   | asyncio.FIRST_COMPLETED                            | The function will return when any future finishes  |
   |                                                    | or is cancelled.                                   |
   +----------------------------------------------------+----------------------------------------------------+
   | asyncio.FIRST_EXCEPTION                            | The function will return when any future finishes  |
   |                                                    | by raising an exception. If no future raises an    |
   |                                                    | exception then it is equivalent to                 |
   |                                                    | "ALL_COMPLETED".                                   |
   +----------------------------------------------------+----------------------------------------------------+
   | asyncio.ALL_COMPLETED                              | The function will return when all futures finish   |
   |                                                    | or are cancelled.                                  |
   +----------------------------------------------------+----------------------------------------------------+

   Unlike "wait_for()", "wait()" does not cancel the futures when a
   timeout occurs.

   Changed in version 3.10: Removed the _loop_ parameter.

   Changed in version 3.11: Passing coroutine objects to "wait()"
   directly is forbidden.

asyncio.as_completed(aws, *, timeout=None)

   Run awaitable objects in the _aws_ iterable concurrently.
   Generators yielding tasks are not accepted as _aws_ iterable.
   Return an iterator of coroutines. Each coroutine returned can be
   awaited to get the earliest next result from the iterable of the
   remaining awaitables.

   Raises "TimeoutError" if the timeout occurs before all Futures are
   done.

   Example:
>
      for coro in as_completed(aws):
          earliest_result = await coro
          # ...
<
   Changed in version 3.10: Removed the _loop_ parameter.

   Deprecated since version 3.10: Deprecation warning is emitted if
   not all awaitable objects in the _aws_ iterable are Future-like
   objects and there is no running event loop.


Running in Threads
==================

coroutine asyncio.to_thread(func, /, *args, **kwargs)

   Asynchronously run function _func_ in a separate thread.

   Any *args and **kwargs supplied for this function are directly
   passed to _func_. Also, the current "contextvars.Context" is
   propagated, allowing context variables from the event loop thread
   to be accessed in the separate thread.

   Return a coroutine that can be awaited to get the eventual result
   of _func_.

   This coroutine function is primarily intended to be used for
   executing IO-bound functions/methods that would otherwise block the
   event loop if they were run in the main thread. For example:
>
      def blocking_io():
          print(f"start blocking_io at {time.strftime('%X')}")
          # Note that time.sleep() can be replaced with any blocking
          # IO-bound operation, such as file operations.
          time.sleep(1)
          print(f"blocking_io complete at {time.strftime('%X')}")

      async def main():
          print(f"started main at {time.strftime('%X')}")

          await asyncio.gather(
              asyncio.to_thread(blocking_io),
              asyncio.sleep(1))

          print(f"finished main at {time.strftime('%X')}")


      asyncio.run(main())

      # Expected output:
      #
      # started main at 19:50:53
      # start blocking_io at 19:50:53
      # blocking_io complete at 19:50:54
      # finished main at 19:50:54
<
   Directly calling "blocking_io()" in any coroutine would block the
   event loop for its duration, resulting in an additional 1 second of
   run time. Instead, by using "asyncio.to_thread()", we can run it in
   a separate thread without blocking the event loop.

   Note:

     Due to the _GIL_, "asyncio.to_thread()" can typically only be
     used to make IO-bound functions non-blocking. However, for
     extension modules that release the GIL or alternative Python
     implementations that don’t have one, "asyncio.to_thread()" can
     also be used for CPU-bound functions.

   New in version 3.9.


Scheduling From Other Threads
=============================

asyncio.run_coroutine_threadsafe(coro, loop)

   Submit a coroutine to the given event loop.  Thread-safe.

   Return a "concurrent.futures.Future" to wait for the result from
   another OS thread.

   This function is meant to be called from a different OS thread than
   the one where the event loop is running.  Example:
>
      # Create a coroutine
      coro = asyncio.sleep(1, result=3)

      # Submit the coroutine to a given loop
      future = asyncio.run_coroutine_threadsafe(coro, loop)

      # Wait for the result with an optional timeout argument
      assert future.result(timeout) == 3
<
   If an exception is raised in the coroutine, the returned Future
   will be notified.  It can also be used to cancel the task in the
   event loop:
>
      try:
          result = future.result(timeout)
      except TimeoutError:
          print('The coroutine took too long, cancelling the task...')
          future.cancel()
      except Exception as exc:
          print(f'The coroutine raised an exception: {exc!r}')
      else:
          print(f'The coroutine returned: {result!r}')
<
   See the concurrency and multithreading section of the
   documentation.

   Unlike other asyncio functions this function requires the _loop_
   argument to be passed explicitly.

   New in version 3.5.1.


Introspection
=============

asyncio.current_task(loop=None)

   Return the currently running "Task" instance, or "None" if no task
   is running.

   If _loop_ is "None" "get_running_loop()" is used to get the current
   loop.

   New in version 3.7.

asyncio.all_tasks(loop=None)

   Return a set of not yet finished "Task" objects run by the loop.

   If _loop_ is "None", "get_running_loop()" is used for getting
   current loop.

   New in version 3.7.

asyncio.iscoroutine(obj)

   Return "True" if _obj_ is a coroutine object.

   New in version 3.4.


Task Object
===========

class asyncio.Task(coro, *, loop=None, name=None, context=None)

   A "Future-like" object that runs a Python coroutine.  Not thread-
   safe.

   Tasks are used to run coroutines in event loops. If a coroutine
   awaits on a Future, the Task suspends the execution of the
   coroutine and waits for the completion of the Future.  When the
   Future is _done_, the execution of the wrapped coroutine resumes.

   Event loops use cooperative scheduling: an event loop runs one Task
   at a time.  While a Task awaits for the completion of a Future, the
   event loop runs other Tasks, callbacks, or performs IO operations.

   Use the high-level "asyncio.create_task()" function to create
   Tasks, or the low-level "loop.create_task()" or "ensure_future()"
   functions.  Manual instantiation of Tasks is discouraged.

   To cancel a running Task use the "cancel()" method.  Calling it
   will cause the Task to throw a "CancelledError" exception into the
   wrapped coroutine.  If a coroutine is awaiting on a Future object
   during cancellation, the Future object will be cancelled.

   "cancelled()" can be used to check if the Task was cancelled. The
   method returns "True" if the wrapped coroutine did not suppress the
   "CancelledError" exception and was actually cancelled.

   "asyncio.Task" inherits from "Future" all of its APIs except
   "Future.set_result()" and "Future.set_exception()".

   An optional keyword-only _context_ argument allows specifying a
   custom "contextvars.Context" for the _coro_ to run in. If no
   _context_ is provided, the Task copies the current context and
   later runs its coroutine in the copied context.

   Changed in version 3.7: Added support for the "contextvars" module.

   Changed in version 3.8: Added the _name_ parameter.

   Deprecated since version 3.10: Deprecation warning is emitted if
   _loop_ is not specified and there is no running event loop.

   Changed in version 3.11: Added the _context_ parameter.

   done()

      Return "True" if the Task is _done_.

      A Task is _done_ when the wrapped coroutine either returned a
      value, raised an exception, or the Task was cancelled.

   result()

      Return the result of the Task.

      If the Task is _done_, the result of the wrapped coroutine is
      returned (or if the coroutine raised an exception, that
      exception is re-raised.)

      If the Task has been _cancelled_, this method raises a
      "CancelledError" exception.

      If the Task’s result isn’t yet available, this method raises a
      "InvalidStateError" exception.

   exception()

      Return the exception of the Task.

      If the wrapped coroutine raised an exception that exception is
      returned.  If the wrapped coroutine returned normally this
      method returns "None".

      If the Task has been _cancelled_, this method raises a
      "CancelledError" exception.

      If the Task isn’t _done_ yet, this method raises an
      "InvalidStateError" exception.

   add_done_callback(callback, *, context=None)

      Add a callback to be run when the Task is _done_.

      This method should only be used in low-level callback-based
      code.

      See the documentation of "Future.add_done_callback()" for more
      details.

   remove_done_callback(callback)

      Remove _callback_ from the callbacks list.

      This method should only be used in low-level callback-based
      code.

      See the documentation of "Future.remove_done_callback()" for
      more details.

   get_stack(*, limit=None)

      Return the list of stack frames for this Task.

      If the wrapped coroutine is not done, this returns the stack
      where it is suspended.  If the coroutine has completed
      successfully or was cancelled, this returns an empty list. If
      the coroutine was terminated by an exception, this returns the
      list of traceback frames.

      The frames are always ordered from oldest to newest.

      Only one stack frame is returned for a suspended coroutine.

      The optional _limit_ argument sets the maximum number of frames
      to return; by default all available frames are returned. The
      ordering of the returned list differs depending on whether a
      stack or a traceback is returned: the newest frames of a stack
      are returned, but the oldest frames of a traceback are returned.
      (This matches the behavior of the traceback module.)

   print_stack(*, limit=None, file=None)

      Print the stack or traceback for this Task.

      This produces output similar to that of the traceback module for
      the frames retrieved by "get_stack()".

      The _limit_ argument is passed to "get_stack()" directly.

      The _file_ argument is an I/O stream to which the output is
      written; by default output is written to "sys.stdout".

   get_coro()

      Return the coroutine object wrapped by the "Task".

      New in version 3.8.

   get_name()

      Return the name of the Task.

      If no name has been explicitly assigned to the Task, the default
      asyncio Task implementation generates a default name during
      instantiation.

      New in version 3.8.

   set_name(value)

      Set the name of the Task.

      The _value_ argument can be any object, which is then converted
      to a string.

      In the default Task implementation, the name will be visible in
      the "repr()" output of a task object.

      New in version 3.8.

   cancel(msg=None)

      Request the Task to be cancelled.

      This arranges for a "CancelledError" exception to be thrown into
      the wrapped coroutine on the next cycle of the event loop.

      The coroutine then has a chance to clean up or even deny the
      request by suppressing the exception with a "try" … … "except
      CancelledError" … "finally" block. Therefore, unlike
      "Future.cancel()", "Task.cancel()" does not guarantee that the
      Task will be cancelled, although suppressing cancellation
      completely is not common and is actively discouraged.  Should
      the coroutine nevertheless decide to suppress the cancellation,
      it needs to call "Task.uncancel()" in addition to catching the
      exception.

      Changed in version 3.9: Added the _msg_ parameter.

      Changed in version 3.11: The "msg" parameter is propagated from
      cancelled task to its awaiter.

      The following example illustrates how coroutines can intercept
      the cancellation request:
>
         async def cancel_me():
             print('cancel_me(): before sleep')

             try:
                 # Wait for 1 hour
                 await asyncio.sleep(3600)
             except asyncio.CancelledError:
                 print('cancel_me(): cancel sleep')
                 raise
             finally:
                 print('cancel_me(): after sleep')

         async def main():
             # Create a "cancel_me" Task
             task = asyncio.create_task(cancel_me())

             # Wait for 1 second
             await asyncio.sleep(1)

             task.cancel()
             try:
                 await task
             except asyncio.CancelledError:
                 print("main(): cancel_me is cancelled now")

         asyncio.run(main())

         # Expected output:
         #
         #     cancel_me(): before sleep
         #     cancel_me(): cancel sleep
         #     cancel_me(): after sleep
         #     main(): cancel_me is cancelled now
<
   cancelled()

      Return "True" if the Task is _cancelled_.

      The Task is _cancelled_ when the cancellation was requested with
      "cancel()" and the wrapped coroutine propagated the
      "CancelledError" exception thrown into it.

   uncancel()

      Decrement the count of cancellation requests to this Task.

      Returns the remaining number of cancellation requests.

      Note that once execution of a cancelled task completed, further
      calls to "uncancel()" are ineffective.

      New in version 3.11.

      This method is used by asyncio’s internals and isn’t expected to
      be used by end-user code.  In particular, if a Task gets
      successfully uncancelled, this allows for elements of structured
      concurrency like Task Groups and "asyncio.timeout()" to continue
      running, isolating cancellation to the respective structured
      block. For example:
>
         async def make_request_with_timeout():
             try:
                 async with asyncio.timeout(1):
                     # Structured block affected by the timeout:
                     await make_request()
                     await make_another_request()
             except TimeoutError:
                 log("There was a timeout")
             # Outer code not affected by the timeout:
             await unrelated_code()
<
      While the block with "make_request()" and
      "make_another_request()" might get cancelled due to the timeout,
      "unrelated_code()" should continue running even in case of the
      timeout.  This is implemented with "uncancel()".  "TaskGroup"
      context managers use "uncancel()" in a similar fashion.

      If end-user code is, for some reason, suppresing cancellation by
      catching "CancelledError", it needs to call this method to
      remove the cancellation state.

   cancelling()

      Return the number of pending cancellation requests to this Task,
      i.e., the number of calls to "cancel()" less the number of
      "uncancel()" calls.

      Note that if this number is greater than zero but the Task is
      still executing, "cancelled()" will still return "False". This
      is because this number can be lowered by calling "uncancel()",
      which can lead to the task not being cancelled after all if the
      cancellation requests go down to zero.

      This method is used by asyncio’s internals and isn’t expected to
      be used by end-user code.  See "uncancel()" for more details.

      New in version 3.11.

vim:tw=78:ts=8:ft=help:norl: