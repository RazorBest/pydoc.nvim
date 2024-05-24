Python 3.9.19
*asyncio-policy.pyx*                          Last change: 2024 May 24

Policies
********

An event loop policy is a global per-process object that controls the
management of the event loop. Each event loop has a default policy,
which can be changed and customized using the policy API.

A policy defines the notion of _context_ and manages a separate event
loop per context. The default policy defines _context_ to be the
current thread.

By using a custom event loop policy, the behavior of
"get_event_loop()", "set_event_loop()", and "new_event_loop()"
functions can be customized.

Policy objects should implement the APIs defined in the
"AbstractEventLoopPolicy" abstract base class.


Getting and Setting the Policy
==============================

The following functions can be used to get and set the policy for the
current process:

asyncio.get_event_loop_policy()

   Return the current process-wide policy.

asyncio.set_event_loop_policy(policy)

   Set the current process-wide policy to _policy_.

   If _policy_ is set to "None", the default policy is restored.


Policy Objects
==============

The abstract event loop policy base class is defined as follows:

class asyncio.AbstractEventLoopPolicy

   An abstract base class for asyncio policies.

   get_event_loop()

      Get the event loop for the current context.

      Return an event loop object implementing the "AbstractEventLoop"
      interface.

      This method should never return "None".

      Changed in version 3.6.

   set_event_loop(loop)

      Set the event loop for the current context to _loop_.

   new_event_loop()

      Create and return a new event loop object.

      This method should never return "None".

   get_child_watcher()

      Get a child process watcher object.

      Return a watcher object implementing the "AbstractChildWatcher"
      interface.

      This function is Unix specific.

   set_child_watcher(watcher)

      Set the current child process watcher to _watcher_.

      This function is Unix specific.

asyncio ships with the following built-in policies:

class asyncio.DefaultEventLoopPolicy

   The default asyncio policy.  Uses "SelectorEventLoop" on Unix and
   "ProactorEventLoop" on Windows.

   There is no need to install the default policy manually. asyncio is
   configured to use the default policy automatically.

   Changed in version 3.8: On Windows, "ProactorEventLoop" is now used
   by default.

class asyncio.WindowsSelectorEventLoopPolicy

   An alternative event loop policy that uses the "SelectorEventLoop"
   event loop implementation.

   Availability: Windows.

class asyncio.WindowsProactorEventLoopPolicy

   An alternative event loop policy that uses the "ProactorEventLoop"
   event loop implementation.

   Availability: Windows.


Process Watchers
================

A process watcher allows customization of how an event loop monitors
child processes on Unix. Specifically, the event loop needs to know
when a child process has exited.

In asyncio, child processes are created with
"create_subprocess_exec()" and "loop.subprocess_exec()" functions.

asyncio defines the "AbstractChildWatcher" abstract base class, which
child watchers should implement, and has four different
implementations: "ThreadedChildWatcher" (configured to be used by
default), "MultiLoopChildWatcher", "SafeChildWatcher", and
"FastChildWatcher".

See also the Subprocess and Threads section.

The following two functions can be used to customize the child process
watcher implementation used by the asyncio event loop:

asyncio.get_child_watcher()

   Return the current child watcher for the current policy.

asyncio.set_child_watcher(watcher)

   Set the current child watcher to _watcher_ for the current policy.
   _watcher_ must implement methods defined in the
   "AbstractChildWatcher" base class.

Note:

  Third-party event loops implementations might not support custom
  child watchers.  For such event loops, using "set_child_watcher()"
  might be prohibited or have no effect.

class asyncio.AbstractChildWatcher

   add_child_handler(pid, callback, *args)

      Register a new child handler.

      Arrange for "callback(pid, returncode, *args)" to be called when
      a process with PID equal to _pid_ terminates.  Specifying
      another callback for the same process replaces the previous
      handler.

      The _callback_ callable must be thread-safe.

   remove_child_handler(pid)

      Removes the handler for process with PID equal to _pid_.

      The function returns "True" if the handler was successfully
      removed, "False" if there was nothing to remove.

   attach_loop(loop)

      Attach the watcher to an event loop.

      If the watcher was previously attached to an event loop, then it
      is first detached before attaching to the new loop.

      Note: loop may be "None".

   is_active()

      Return "True" if the watcher is ready to use.

      Spawning a subprocess with _inactive_ current child watcher
      raises "RuntimeError".

      New in version 3.8.

   close()

      Close the watcher.

      This method has to be called to ensure that underlying resources
      are cleaned-up.

class asyncio.ThreadedChildWatcher

   This implementation starts a new waiting thread for every
   subprocess spawn.

   It works reliably even when the asyncio event loop is run in a non-
   main OS thread.

   There is no noticeable overhead when handling a big number of
   children (_O(1)_ each time a child terminates), but starting a
   thread per process requires extra memory.

   This watcher is used by default.

   New in version 3.8.

class asyncio.MultiLoopChildWatcher

   This implementation registers a "SIGCHLD" signal handler on
   instantiation. That can break third-party code that installs a
   custom handler for "SIGCHLD" signal.

   The watcher avoids disrupting other code spawning processes by
   polling every process explicitly on a "SIGCHLD" signal.

   There is no limitation for running subprocesses from different
   threads once the watcher is installed.

   The solution is safe but it has a significant overhead when
   handling a big number of processes (_O(n)_ each time a "SIGCHLD" is
   received).

   New in version 3.8.

class asyncio.SafeChildWatcher

   This implementation uses active event loop from the main thread to
   handle "SIGCHLD" signal. If the main thread has no running event
   loop another thread cannot spawn a subprocess ("RuntimeError" is
   raised).

   The watcher avoids disrupting other code spawning processes by
   polling every process explicitly on a "SIGCHLD" signal.

   This solution is as safe as "MultiLoopChildWatcher" and has the
   same _O(N)_ complexity but requires a running event loop in the
   main thread to work.

class asyncio.FastChildWatcher

   This implementation reaps every terminated processes by calling
   "os.waitpid(-1)" directly, possibly breaking other code spawning
   processes and waiting for their termination.

   There is no noticeable overhead when handling a big number of
   children (_O(1)_ each time a child terminates).

   This solution requires a running event loop in the main thread to
   work, as "SafeChildWatcher".

class asyncio.PidfdChildWatcher

   This implementation polls process file descriptors (pidfds) to
   await child process termination. In some respects,
   "PidfdChildWatcher" is a “Goldilocks” child watcher implementation.
   It doesn’t require signals or threads, doesn’t interfere with any
   processes launched outside the event loop, and scales linearly with
   the number of subprocesses launched by the event loop. The main
   disadvantage is that pidfds are specific to Linux, and only work on
   recent (5.3+) kernels.

   New in version 3.9.


Custom Policies
===============

To implement a new event loop policy, it is recommended to subclass
"DefaultEventLoopPolicy" and override the methods for which custom
behavior is wanted, e.g.:
>
   class MyEventLoopPolicy(asyncio.DefaultEventLoopPolicy):

       def get_event_loop(self):
           """Get the event loop.

           This may be None or an instance of EventLoop.
           """
           loop = super().get_event_loop()
           # Do something with loop ...
           return loop

   asyncio.set_event_loop_policy(MyEventLoopPolicy())
<
vim:tw=78:ts=8:ft=help:norl: