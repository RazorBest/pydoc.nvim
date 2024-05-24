Python 3.8.19
*signal.pyx*                                  Last change: 2024 May 24

"signal" — Set handlers for asynchronous events
***********************************************

======================================================================

This module provides mechanisms to use signal handlers in Python.


General rules
=============

The "signal.signal()" function allows defining custom handlers to be
executed when a signal is received.  A small number of default
handlers are installed: "SIGPIPE" is ignored (so write errors on pipes
and sockets can be reported as ordinary Python exceptions) and
"SIGINT" is translated into a "KeyboardInterrupt" exception if the
parent process has not changed it.

A handler for a particular signal, once set, remains installed until
it is explicitly reset (Python emulates the BSD style interface
regardless of the underlying implementation), with the exception of
the handler for "SIGCHLD", which follows the underlying
implementation.


Execution of Python signal handlers
-----------------------------------

A Python signal handler does not get executed inside the low-level (C)
signal handler.  Instead, the low-level signal handler sets a flag
which tells the _virtual machine_ to execute the corresponding Python
signal handler at a later point(for example at the next _bytecode_
instruction). This has consequences:

* It makes little sense to catch synchronous errors like "SIGFPE" or
  "SIGSEGV" that are caused by an invalid operation in C code.  Python
  will return from the signal handler to the C code, which is likely
  to raise the same signal again, causing Python to apparently hang.
  From Python 3.3 onwards, you can use the "faulthandler" module to
  report on synchronous errors.

* A long-running calculation implemented purely in C (such as regular
  expression matching on a large body of text) may run uninterrupted
  for an arbitrary amount of time, regardless of any signals received.
  The Python signal handlers will be called when the calculation
  finishes.


Signals and threads
-------------------

Python signal handlers are always executed in the main Python thread,
even if the signal was received in another thread.  This means that
signals can’t be used as a means of inter-thread communication.  You
can use the synchronization primitives from the "threading" module
instead.

Besides, only the main thread is allowed to set a new signal handler.


Module contents
===============

Changed in version 3.5: signal (SIG*), handler ("SIG_DFL", "SIG_IGN")
and sigmask ("SIG_BLOCK", "SIG_UNBLOCK", "SIG_SETMASK") related
constants listed below were turned into "enums". "getsignal()",
"pthread_sigmask()", "sigpending()" and "sigwait()" functions return
human-readable "enums".

The variables defined in the "signal" module are:

signal.SIG_DFL

   This is one of two standard signal handling options; it will simply
   perform the default function for the signal.  For example, on most
   systems the default action for "SIGQUIT" is to dump core and exit,
   while the default action for "SIGCHLD" is to simply ignore it.

signal.SIG_IGN

   This is another standard signal handler, which will simply ignore
   the given signal.

signal.SIGABRT

   Abort signal from _abort(3)_.

signal.SIGALRM

   Timer signal from _alarm(2)_.

   Availability: Unix.

signal.SIGBREAK

   Interrupt from keyboard (CTRL + BREAK).

   Availability: Windows.

signal.SIGBUS

   Bus error (bad memory access).

   Availability: Unix.

signal.SIGCHLD

   Child process stopped or terminated.

   Availability: Unix.

signal.SIGCLD

   Alias to "SIGCHLD".

signal.SIGCONT

   Continue the process if it is currently stopped

   Availability: Unix.

signal.SIGFPE

   Floating-point exception. For example, division by zero.

   See also:

     "ZeroDivisionError" is raised when the second argument of a
     division or modulo operation is zero.

signal.SIGHUP

   Hangup detected on controlling terminal or death of controlling
   process.

   Availability: Unix.

signal.SIGILL

   Illegal instruction.

signal.SIGINT

   Interrupt from keyboard (CTRL + C).

   Default action is to raise "KeyboardInterrupt".

signal.SIGKILL

   Kill signal.

   It cannot be caught, blocked, or ignored.

   Availability: Unix.

signal.SIGPIPE

   Broken pipe: write to pipe with no readers.

   Default action is to ignore the signal.

   Availability: Unix.

signal.SIGSEGV

   Segmentation fault: invalid memory reference.

signal.SIGTERM

   Termination signal.

signal.SIGUSR1

   User-defined signal 1.

   Availability: Unix.

signal.SIGUSR2

   User-defined signal 2.

   Availability: Unix.

signal.SIGWINCH

   Window resize signal.

   Availability: Unix.

SIG*

   All the signal numbers are defined symbolically.  For example, the
   hangup signal is defined as "signal.SIGHUP"; the variable names are
   identical to the names used in C programs, as found in
   "<signal.h>".  The Unix man page for ‘"signal()"’ lists the
   existing signals (on some systems this is _signal(2)_, on others
   the list is in _signal(7)_). Note that not all systems define the
   same set of signal names; only those names defined by the system
   are defined by this module.

signal.CTRL_C_EVENT

   The signal corresponding to the "Ctrl+C" keystroke event. This
   signal can only be used with "os.kill()".

   Availability: Windows.

   New in version 3.2.

signal.CTRL_BREAK_EVENT

   The signal corresponding to the "Ctrl+Break" keystroke event. This
   signal can only be used with "os.kill()".

   Availability: Windows.

   New in version 3.2.

signal.NSIG

   One more than the number of the highest signal number.

signal.ITIMER_REAL

   Decrements interval timer in real time, and delivers "SIGALRM" upon
   expiration.

signal.ITIMER_VIRTUAL

   Decrements interval timer only when the process is executing, and
   delivers SIGVTALRM upon expiration.

signal.ITIMER_PROF

   Decrements interval timer both when the process executes and when
   the system is executing on behalf of the process. Coupled with
   ITIMER_VIRTUAL, this timer is usually used to profile the time
   spent by the application in user and kernel space. SIGPROF is
   delivered upon expiration.

signal.SIG_BLOCK

   A possible value for the _how_ parameter to "pthread_sigmask()"
   indicating that signals are to be blocked.

   New in version 3.3.

signal.SIG_UNBLOCK

   A possible value for the _how_ parameter to "pthread_sigmask()"
   indicating that signals are to be unblocked.

   New in version 3.3.

signal.SIG_SETMASK

   A possible value for the _how_ parameter to "pthread_sigmask()"
   indicating that the signal mask is to be replaced.

   New in version 3.3.

The "signal" module defines one exception:

exception signal.ItimerError

   Raised to signal an error from the underlying "setitimer()" or
   "getitimer()" implementation. Expect this error if an invalid
   interval timer or a negative time is passed to "setitimer()". This
   error is a subtype of "OSError".

   New in version 3.3: This error used to be a subtype of "IOError",
   which is now an alias of "OSError".

The "signal" module defines the following functions:

signal.alarm(time)

   If _time_ is non-zero, this function requests that a "SIGALRM"
   signal be sent to the process in _time_ seconds. Any previously
   scheduled alarm is canceled (only one alarm can be scheduled at any
   time).  The returned value is then the number of seconds before any
   previously set alarm was to have been delivered. If _time_ is zero,
   no alarm is scheduled, and any scheduled alarm is canceled.  If the
   return value is zero, no alarm is currently scheduled.

   Availability: Unix.  See the man page _alarm(2)_ for further
   information.

signal.getsignal(signalnum)

   Return the current signal handler for the signal _signalnum_. The
   returned value may be a callable Python object, or one of the
   special values "signal.SIG_IGN", "signal.SIG_DFL" or "None".  Here,
   "signal.SIG_IGN" means that the signal was previously ignored,
   "signal.SIG_DFL" means that the default way of handling the signal
   was previously in use, and "None" means that the previous signal
   handler was not installed from Python.

signal.strsignal(signalnum)

   Return the system description of the signal _signalnum_, such as
   “Interrupt”, “Segmentation fault”, etc. Returns "None" if the
   signal is not recognized.

   New in version 3.8.

signal.valid_signals()

   Return the set of valid signal numbers on this platform.  This can
   be less than "range(1, NSIG)" if some signals are reserved by the
   system for internal use.

   New in version 3.8.

signal.pause()

   Cause the process to sleep until a signal is received; the
   appropriate handler will then be called.  Returns nothing.

   Availability: Unix.  See the man page _signal(2)_ for further
   information.

   See also "sigwait()", "sigwaitinfo()", "sigtimedwait()" and
   "sigpending()".

signal.raise_signal(signum)

   Sends a signal to the calling process. Returns nothing.

   New in version 3.8.

signal.pthread_kill(thread_id, signalnum)

   Send the signal _signalnum_ to the thread _thread_id_, another
   thread in the same process as the caller.  The target thread can be
   executing any code (Python or not).  However, if the target thread
   is executing the Python interpreter, the Python signal handlers
   will be executed by the main thread.  Therefore, the only point of
   sending a signal to a particular Python thread would be to force a
   running system call to fail with "InterruptedError".

   Use "threading.get_ident()" or the "ident" attribute of
   "threading.Thread" objects to get a suitable value for _thread_id_.

   If _signalnum_ is 0, then no signal is sent, but error checking is
   still performed; this can be used to check if the target thread is
   still running.

   Raises an auditing event "signal.pthread_kill" with arguments
   "thread_id", "signalnum".

   Availability: Unix.  See the man page _pthread_kill(3)_ for further
   information.

   See also "os.kill()".

   New in version 3.3.

signal.pthread_sigmask(how, mask)

   Fetch and/or change the signal mask of the calling thread.  The
   signal mask is the set of signals whose delivery is currently
   blocked for the caller. Return the old signal mask as a set of
   signals.

   The behavior of the call is dependent on the value of _how_, as
   follows.

   * "SIG_BLOCK": The set of blocked signals is the union of the
     current set and the _mask_ argument.

   * "SIG_UNBLOCK": The signals in _mask_ are removed from the current
     set of blocked signals.  It is permissible to attempt to unblock
     a signal which is not blocked.

   * "SIG_SETMASK": The set of blocked signals is set to the _mask_
     argument.

   _mask_ is a set of signal numbers (e.g. {"signal.SIGINT",
   "signal.SIGTERM"}). Use "valid_signals()" for a full mask including
   all signals.

   For example, "signal.pthread_sigmask(signal.SIG_BLOCK, [])" reads
   the signal mask of the calling thread.

   "SIGKILL" and "SIGSTOP" cannot be blocked.

   Availability: Unix.  See the man page _sigprocmask(3)_ and
   _pthread_sigmask(3)_ for further information.

   See also "pause()", "sigpending()" and "sigwait()".

   New in version 3.3.

signal.setitimer(which, seconds, interval=0.0)

   Sets given interval timer (one of "signal.ITIMER_REAL",
   "signal.ITIMER_VIRTUAL" or "signal.ITIMER_PROF") specified by
   _which_ to fire after _seconds_ (float is accepted, different from
   "alarm()") and after that every _interval_ seconds (if _interval_
   is non-zero). The interval timer specified by _which_ can be
   cleared by setting _seconds_ to zero.

   When an interval timer fires, a signal is sent to the process. The
   signal sent is dependent on the timer being used;
   "signal.ITIMER_REAL" will deliver "SIGALRM",
   "signal.ITIMER_VIRTUAL" sends "SIGVTALRM", and "signal.ITIMER_PROF"
   will deliver "SIGPROF".

   The old values are returned as a tuple: (delay, interval).

   Attempting to pass an invalid interval timer will cause an
   "ItimerError".

   Availability: Unix.

signal.getitimer(which)

   Returns current value of a given interval timer specified by
   _which_.

   Availability: Unix.

signal.set_wakeup_fd(fd, *, warn_on_full_buffer=True)

   Set the wakeup file descriptor to _fd_.  When a signal is received,
   the signal number is written as a single byte into the fd.  This
   can be used by a library to wakeup a poll or select call, allowing
   the signal to be fully processed.

   The old wakeup fd is returned (or -1 if file descriptor wakeup was
   not enabled).  If _fd_ is -1, file descriptor wakeup is disabled.
   If not -1, _fd_ must be non-blocking.  It is up to the library to
   remove any bytes from _fd_ before calling poll or select again.

   When threads are enabled, this function can only be called from the
   main thread; attempting to call it from other threads will cause a
   "ValueError" exception to be raised.

   There are two common ways to use this function. In both approaches,
   you use the fd to wake up when a signal arrives, but then they
   differ in how they determine _which_ signal or signals have
   arrived.

   In the first approach, we read the data out of the fd’s buffer, and
   the byte values give you the signal numbers. This is simple, but in
   rare cases it can run into a problem: generally the fd will have a
   limited amount of buffer space, and if too many signals arrive too
   quickly, then the buffer may become full, and some signals may be
   lost. If you use this approach, then you should set
   "warn_on_full_buffer=True", which will at least cause a warning to
   be printed to stderr when signals are lost.

   In the second approach, we use the wakeup fd _only_ for wakeups,
   and ignore the actual byte values. In this case, all we care about
   is whether the fd’s buffer is empty or non-empty; a full buffer
   doesn’t indicate a problem at all. If you use this approach, then
   you should set "warn_on_full_buffer=False", so that your users are
   not confused by spurious warning messages.

   Changed in version 3.5: On Windows, the function now also supports
   socket handles.

   Changed in version 3.7: Added "warn_on_full_buffer" parameter.

signal.siginterrupt(signalnum, flag)

   Change system call restart behaviour: if _flag_ is "False", system
   calls will be restarted when interrupted by signal _signalnum_,
   otherwise system calls will be interrupted.  Returns nothing.

   Availability: Unix.  See the man page _siginterrupt(3)_ for further
   information.

   Note that installing a signal handler with "signal()" will reset
   the restart behaviour to interruptible by implicitly calling
   "siginterrupt()" with a true _flag_ value for the given signal.

signal.signal(signalnum, handler)

   Set the handler for signal _signalnum_ to the function _handler_.
   _handler_ can be a callable Python object taking two arguments (see
   below), or one of the special values "signal.SIG_IGN" or
   "signal.SIG_DFL".  The previous signal handler will be returned
   (see the description of "getsignal()" above).  (See the Unix man
   page _signal(2)_ for further information.)

   When threads are enabled, this function can only be called from the
   main thread; attempting to call it from other threads will cause a
   "ValueError" exception to be raised.

   The _handler_ is called with two arguments: the signal number and
   the current stack frame ("None" or a frame object; for a
   description of frame objects, see the description in the type
   hierarchy or see the attribute descriptions in the "inspect"
   module).

   On Windows, "signal()" can only be called with "SIGABRT", "SIGFPE",
   "SIGILL", "SIGINT", "SIGSEGV", "SIGTERM", or "SIGBREAK". A
   "ValueError" will be raised in any other case. Note that not all
   systems define the same set of signal names; an "AttributeError"
   will be raised if a signal name is not defined as "SIG*" module
   level constant.

signal.sigpending()

   Examine the set of signals that are pending for delivery to the
   calling thread (i.e., the signals which have been raised while
   blocked).  Return the set of the pending signals.

   Availability: Unix.  See the man page _sigpending(2)_ for further
   information.

   See also "pause()", "pthread_sigmask()" and "sigwait()".

   New in version 3.3.

signal.sigwait(sigset)

   Suspend execution of the calling thread until the delivery of one
   of the signals specified in the signal set _sigset_.  The function
   accepts the signal (removes it from the pending list of signals),
   and returns the signal number.

   Availability: Unix.  See the man page _sigwait(3)_ for further
   information.

   See also "pause()", "pthread_sigmask()", "sigpending()",
   "sigwaitinfo()" and "sigtimedwait()".

   New in version 3.3.

signal.sigwaitinfo(sigset)

   Suspend execution of the calling thread until the delivery of one
   of the signals specified in the signal set _sigset_.  The function
   accepts the signal and removes it from the pending list of signals.
   If one of the signals in _sigset_ is already pending for the
   calling thread, the function will return immediately with
   information about that signal. The signal handler is not called for
   the delivered signal. The function raises an "InterruptedError" if
   it is interrupted by a signal that is not in _sigset_.

   The return value is an object representing the data contained in
   the "siginfo_t" structure, namely: "si_signo", "si_code",
   "si_errno", "si_pid", "si_uid", "si_status", "si_band".

   Availability: Unix.  See the man page _sigwaitinfo(2)_ for further
   information.

   See also "pause()", "sigwait()" and "sigtimedwait()".

   New in version 3.3.

   Changed in version 3.5: The function is now retried if interrupted
   by a signal not in _sigset_ and the signal handler does not raise
   an exception (see **PEP 475** for the rationale).

signal.sigtimedwait(sigset, timeout)

   Like "sigwaitinfo()", but takes an additional _timeout_ argument
   specifying a timeout. If _timeout_ is specified as "0", a poll is
   performed. Returns "None" if a timeout occurs.

   Availability: Unix.  See the man page _sigtimedwait(2)_ for further
   information.

   See also "pause()", "sigwait()" and "sigwaitinfo()".

   New in version 3.3.

   Changed in version 3.5: The function is now retried with the
   recomputed _timeout_ if interrupted by a signal not in _sigset_ and
   the signal handler does not raise an exception (see **PEP 475** for
   the rationale).


Example
=======

Here is a minimal example program. It uses the "alarm()" function to
limit the time spent waiting to open a file; this is useful if the
file is for a serial device that may not be turned on, which would
normally cause the "os.open()" to hang indefinitely.  The solution is
to set a 5-second alarm before opening the file; if the operation
takes too long, the alarm signal will be sent, and the handler raises
an exception.
>
   import signal, os

   def handler(signum, frame):
       print('Signal handler called with signal', signum)
       raise OSError("Couldn't open device!")

   # Set the signal handler and a 5-second alarm
   signal.signal(signal.SIGALRM, handler)
   signal.alarm(5)

   # This open() may hang indefinitely
   fd = os.open('/dev/ttyS0', os.O_RDWR)

   signal.alarm(0)          # Disable the alarm
<

Note on SIGPIPE
===============

Piping output of your program to tools like _head(1)_ will cause a
"SIGPIPE" signal to be sent to your process when the receiver of its
standard output closes early.  This results in an exception like
"BrokenPipeError: [Errno 32] Broken pipe".  To handle this case, wrap
your entry point to catch this exception as follows:
>
   import os
   import sys

   def main():
       try:
           # simulate large output (your code replaces this loop)
           for x in range(10000):
               print("y")
           # flush output here to force SIGPIPE to be triggered
           # while inside this try block.
           sys.stdout.flush()
       except BrokenPipeError:
           # Python flushes standard streams on exit; redirect remaining output
           # to devnull to avoid another BrokenPipeError at shutdown
           devnull = os.open(os.devnull, os.O_WRONLY)
           os.dup2(devnull, sys.stdout.fileno())
           sys.exit(1)  # Python exits with error code 1 on EPIPE

   if __name__ == '__main__':
       main()
<
Do not set "SIGPIPE"’s disposition to "SIG_DFL" in order to avoid
"BrokenPipeError".  Doing that would cause your program to exit
unexpectedly also whenever any socket connection is interrupted while
your program is still writing to it.

vim:tw=78:ts=8:ft=help:norl: