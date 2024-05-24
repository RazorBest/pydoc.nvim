Python 3.10.14
*pipes.pyx*                                   Last change: 2024 May 24

"pipes" — Interface to shell pipelines
**************************************

**Source code:** Lib/pipes.py

Deprecated since version 3.11: The "pipes" module is deprecated (see
**PEP 594** for details). Please use the "subprocess" module instead.

======================================================================

The "pipes" module defines a class to abstract the concept of a
_pipeline_ — a sequence of converters from one file to  another.

Because the module uses **/bin/sh** command lines, a POSIX or
compatible shell for "os.system()" and "os.popen()" is required.

Availability: Unix. Not available on VxWorks.

The "pipes" module defines the following class:

class pipes.Template

   An abstraction of a pipeline.

Example:
>
   >>> import pipes
   >>> t = pipes.Template()
   >>> t.append('tr a-z A-Z', '--')
   >>> f = t.open('pipefile', 'w')
   >>> f.write('hello world')
   >>> f.close()
   >>> open('pipefile').read()
   'HELLO WORLD'
<

Template Objects
================

Template objects following methods:

Template.reset()

   Restore a pipeline template to its initial state.

Template.clone()

   Return a new, equivalent, pipeline template.

Template.debug(flag)

   If _flag_ is true, turn debugging on. Otherwise, turn debugging
   off. When debugging is on, commands to be executed are printed, and
   the shell is given "set -x" command to be more verbose.

Template.append(cmd, kind)

   Append a new action at the end. The _cmd_ variable must be a valid
   bourne shell command. The _kind_ variable consists of two letters.

   The first letter can be either of "'-'" (which means the command
   reads its standard input), "'f'" (which means the commands reads a
   given file on the command line) or "'.'" (which means the commands
   reads no input, and hence must be first.)

   Similarly, the second letter can be either of "'-'" (which means
   the command writes to standard output), "'f'" (which means the
   command writes a file on the command line) or "'.'" (which means
   the command does not write anything, and hence must be last.)

Template.prepend(cmd, kind)

   Add a new action at the beginning. See "append()" for explanations
   of the arguments.

Template.open(file, mode)

   Return a file-like object, open to _file_, but read from or written
   to by the pipeline.  Note that only one of "'r'", "'w'" may be
   given.

Template.copy(infile, outfile)

   Copy _infile_ to _outfile_ through the pipe.

vim:tw=78:ts=8:ft=help:norl: