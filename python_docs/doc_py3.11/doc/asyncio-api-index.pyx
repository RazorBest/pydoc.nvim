Python 3.11.9
*asyncio-api-index.pyx*                       Last change: 2024 May 24

High-level API Index
********************

This page lists all high-level async/await enabled asyncio APIs.


Tasks
=====

Utilities to run asyncio programs, create Tasks, and await on multiple
things with timeouts.

+----------------------------------------------------+----------------------------------------------------+
| "run()"                                            | Create event loop, run a coroutine, close the      |
|                                                    | loop.                                              |
+----------------------------------------------------+----------------------------------------------------+
| "Runner"                                           | A context manager that simplifies multiple async   |
|                                                    | function calls.                                    |
+----------------------------------------------------+----------------------------------------------------+
| "Task"                                             | Task object.                                       |
+----------------------------------------------------+----------------------------------------------------+
| "TaskGroup"                                        | A context manager that holds a group of tasks.     |
|                                                    | Provides a convenient and reliable way to wait for |
|                                                    | all tasks in the group to finish.                  |
+----------------------------------------------------+----------------------------------------------------+
| "create_task()"                                    | Start an asyncio Task, then returns it.            |
+----------------------------------------------------+----------------------------------------------------+
| "current_task()"                                   | Return the current Task.                           |
+----------------------------------------------------+----------------------------------------------------+
| "all_tasks()"                                      | Return all tasks that are not yet finished for an  |
|                                                    | event loop.                                        |
+----------------------------------------------------+----------------------------------------------------+
| "await" "sleep()"                                  | Sleep for a number of seconds.                     |
+----------------------------------------------------+----------------------------------------------------+
| "await" "gather()"                                 | Schedule and wait for things concurrently.         |
+----------------------------------------------------+----------------------------------------------------+
| "await" "wait_for()"                               | Run with a timeout.                                |
+----------------------------------------------------+----------------------------------------------------+
| "await" "shield()"                                 | Shield from cancellation.                          |
+----------------------------------------------------+----------------------------------------------------+
| "await" "wait()"                                   | Monitor for completion.                            |
+----------------------------------------------------+----------------------------------------------------+
| "timeout()"                                        | Run with a timeout. Useful in cases when           |
|                                                    | "wait_for" is not suitable.                        |
+----------------------------------------------------+----------------------------------------------------+
| "to_thread()"                                      | Asynchronously run a function in a separate OS     |
|                                                    | thread.                                            |
+----------------------------------------------------+----------------------------------------------------+
| "run_coroutine_threadsafe()"                       | Schedule a coroutine from another OS thread.       |
+----------------------------------------------------+----------------------------------------------------+
| "for in" "as_completed()"                          | Monitor for completion with a "for" loop.          |
+----------------------------------------------------+----------------------------------------------------+

-[ Examples ]-

* Using asyncio.gather() to run things in parallel.

* Using asyncio.wait_for() to enforce a timeout.

* Cancellation.

* Using asyncio.sleep().

* See also the main Tasks documentation page.


Queues
======

Queues should be used to distribute work amongst multiple asyncio
Tasks, implement connection pools, and pub/sub patterns.

+----------------------------------------------------+----------------------------------------------------+
| "Queue"                                            | A FIFO queue.                                      |
+----------------------------------------------------+----------------------------------------------------+
| "PriorityQueue"                                    | A priority queue.                                  |
+----------------------------------------------------+----------------------------------------------------+
| "LifoQueue"                                        | A LIFO queue.                                      |
+----------------------------------------------------+----------------------------------------------------+

-[ Examples ]-

* Using asyncio.Queue to distribute workload between several Tasks.

* See also the Queues documentation page.


Subprocesses
============

Utilities to spawn subprocesses and run shell commands.

+----------------------------------------------------+----------------------------------------------------+
| "await" "create_subprocess_exec()"                 | Create a subprocess.                               |
+----------------------------------------------------+----------------------------------------------------+
| "await" "create_subprocess_shell()"                | Run a shell command.                               |
+----------------------------------------------------+----------------------------------------------------+

-[ Examples ]-

* Executing a shell command.

* See also the subprocess APIs documentation.


Streams
=======

High-level APIs to work with network IO.

+----------------------------------------------------+----------------------------------------------------+
| "await" "open_connection()"                        | Establish a TCP connection.                        |
+----------------------------------------------------+----------------------------------------------------+
| "await" "open_unix_connection()"                   | Establish a Unix socket connection.                |
+----------------------------------------------------+----------------------------------------------------+
| "await" "start_server()"                           | Start a TCP server.                                |
+----------------------------------------------------+----------------------------------------------------+
| "await" "start_unix_server()"                      | Start a Unix socket server.                        |
+----------------------------------------------------+----------------------------------------------------+
| "StreamReader"                                     | High-level async/await object to receive network   |
|                                                    | data.                                              |
+----------------------------------------------------+----------------------------------------------------+
| "StreamWriter"                                     | High-level async/await object to send network      |
|                                                    | data.                                              |
+----------------------------------------------------+----------------------------------------------------+

-[ Examples ]-

* Example TCP client.

* See also the streams APIs documentation.


Synchronization
===============

Threading-like synchronization primitives that can be used in Tasks.

+----------------------------------------------------+----------------------------------------------------+
| "Lock"                                             | A mutex lock.                                      |
+----------------------------------------------------+----------------------------------------------------+
| "Event"                                            | An event object.                                   |
+----------------------------------------------------+----------------------------------------------------+
| "Condition"                                        | A condition object.                                |
+----------------------------------------------------+----------------------------------------------------+
| "Semaphore"                                        | A semaphore.                                       |
+----------------------------------------------------+----------------------------------------------------+
| "BoundedSemaphore"                                 | A bounded semaphore.                               |
+----------------------------------------------------+----------------------------------------------------+
| "Barrier"                                          | A barrier object.                                  |
+----------------------------------------------------+----------------------------------------------------+

-[ Examples ]-

* Using asyncio.Event.

* Using asyncio.Barrier.

* See also the documentation of asyncio synchronization primitives.


Exceptions
==========

+----------------------------------------------------+----------------------------------------------------+
| "asyncio.CancelledError"                           | Raised when a Task is cancelled. See also          |
|                                                    | "Task.cancel()".                                   |
+----------------------------------------------------+----------------------------------------------------+
| "asyncio.BrokenBarrierError"                       | Raised when a Barrier is broken. See also          |
|                                                    | "Barrier.wait()".                                  |
+----------------------------------------------------+----------------------------------------------------+

-[ Examples ]-

* Handling CancelledError to run code on cancellation request.

* See also the full list of asyncio-specific exceptions.

vim:tw=78:ts=8:ft=help:norl: