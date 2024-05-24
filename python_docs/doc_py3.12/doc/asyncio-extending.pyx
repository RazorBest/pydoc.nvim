Python 3.12.3
*asyncio-extending.pyx*                       Last change: 2024 May 24

Extending
*********

The main direction for "asyncio" extending is writing custom _event
loop_ classes. Asyncio has helpers that could be used to simplify this
task.

Note:

  Third-parties should reuse existing asyncio code with caution, a new
  Python version is free to break backward compatibility in _internal_
  part of API.


Writing a Custom Event Loop
===========================

"asyncio.AbstractEventLoop" declares very many methods.  Implementing
all them from scratch is a tedious job.

A loop can get many common methods implementation for free by
inheriting from "asyncio.BaseEventLoop".

In turn, the successor should implement a bunch of _private_ methods
declared but not implemented in "asyncio.BaseEventLoop".

For example, "loop.create_connection()" checks arguments, resolves DNS
addresses, and calls "loop._make_socket_transport()" that should be
implemented by inherited class. The "_make_socket_transport()" method
is not documented and is considered as an _internal_ API.


Future and Task private constructors
====================================

"asyncio.Future" and "asyncio.Task" should be never created directly,
please use corresponding "loop.create_future()" and
"loop.create_task()", or "asyncio.create_task()" factories instead.

However, third-party _event loops_ may _reuse_ built-in future and
task implementations for the sake of getting a complex and highly
optimized code for free.

For this purpose the following, _private_ constructors are listed:

Future.__init__(*, loop=None)

   Create a built-in future instance.

   _loop_ is an optional event loop instance.

Task.__init__(coro, *, loop=None, name=None, context=None)

   Create a built-in task instance.

   _loop_ is an optional event loop instance. The rest of arguments
   are described in "loop.create_task()" description.

   Changed in version 3.11: _context_ argument is added.


Task lifetime support
=====================

A third party task implementation should call the following functions
to keep a task visible by "asyncio.all_tasks()" and
"asyncio.current_task()":

asyncio._register_task(task)

   Register a new _task_ as managed by _asyncio_.

   Call the function from a task constructor.

asyncio._unregister_task(task)

   Unregister a _task_ from _asyncio_ internal structures.

   The function should be called when a task is about to finish.

asyncio._enter_task(loop, task)

   Switch the current task to the _task_ argument.

   Call the function just before executing a portion of embedded
   _coroutine_ ("coroutine.send()" or "coroutine.throw()").

asyncio._leave_task(loop, task)

   Switch the current task back from _task_ to "None".

   Call the function just after "coroutine.send()" or
   "coroutine.throw()" execution.

vim:tw=78:ts=8:ft=help:norl: