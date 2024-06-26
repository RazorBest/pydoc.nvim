Python 3.10.14
*platform.pyx*                                Last change: 2024 May 24

"platform" —  Access to underlying platform’s identifying data
**************************************************************

**Source code:** Lib/platform.py

======================================================================

Note:

  Specific platforms listed alphabetically, with Linux included in the
  Unix section.


Cross Platform
==============

platform.architecture(executable=sys.executable, bits='', linkage='')

   Queries the given executable (defaults to the Python interpreter
   binary) for various architecture information.

   Returns a tuple "(bits, linkage)" which contain information about
   the bit architecture and the linkage format used for the
   executable. Both values are returned as strings.

   Values that cannot be determined are returned as given by the
   parameter presets. If bits is given as "''", the "sizeof(pointer)"
   (or "sizeof(long)" on Python version < 1.5.2) is used as indicator
   for the supported pointer size.

   The function relies on the system’s "file" command to do the actual
   work. This is available on most if not all Unix  platforms and some
   non-Unix platforms and then only if the executable points to the
   Python interpreter.  Reasonable defaults are used when the above
   needs are not met.

   Note:

     On macOS (and perhaps other platforms), executable files may be
     universal files containing multiple architectures.To get at the
     “64-bitness” of the current interpreter, it is more reliable to
     query the "sys.maxsize" attribute:

>
        is_64bits = sys.maxsize > 2**32
<
platform.machine()

   Returns the machine type, e.g. "'AMD64'". An empty string is
   returned if the value cannot be determined.

platform.node()

   Returns the computer’s network name (may not be fully qualified!).
   An empty string is returned if the value cannot be determined.

platform.platform(aliased=0, terse=0)

   Returns a single string identifying the underlying platform with as
   much useful information as possible.

   The output is intended to be _human readable_ rather than machine
   parseable. It may look different on different platforms and this is
   intended.

   If _aliased_ is true, the function will use aliases for various
   platforms that report system names which differ from their common
   names, for example SunOS will be reported as Solaris.  The
   "system_alias()" function is used to implement this.

   Setting _terse_ to true causes the function to return only the
   absolute minimum information needed to identify the platform.

   Changed in version 3.8: On macOS, the function now uses
   "mac_ver()", if it returns a non-empty release string, to get the
   macOS version rather than the darwin version.

platform.processor()

   Returns the (real) processor name, e.g. "'amdk6'".

   An empty string is returned if the value cannot be determined. Note
   that many platforms do not provide this information or simply
   return the same value as for "machine()".  NetBSD does this.

platform.python_build()

   Returns a tuple "(buildno, builddate)" stating the Python build
   number and date as strings.

platform.python_compiler()

   Returns a string identifying the compiler used for compiling
   Python.

platform.python_branch()

   Returns a string identifying the Python implementation SCM branch.

platform.python_implementation()

   Returns a string identifying the Python implementation. Possible
   return values are: ‘CPython’, ‘IronPython’, ‘Jython’, ‘PyPy’.

platform.python_revision()

   Returns a string identifying the Python implementation SCM
   revision.

platform.python_version()

   Returns the Python version as string "'major.minor.patchlevel'".

   Note that unlike the Python "sys.version", the returned value will
   always include the patchlevel (it defaults to 0).

platform.python_version_tuple()

   Returns the Python version as tuple "(major, minor, patchlevel)" of
   strings.

   Note that unlike the Python "sys.version", the returned value will
   always include the patchlevel (it defaults to "'0'").

platform.release()

   Returns the system’s release, e.g. "'2.2.0'" or "'NT'". An empty
   string is returned if the value cannot be determined.

platform.system()

   Returns the system/OS name, such as "'Linux'", "'Darwin'",
   "'Java'", "'Windows'". An empty string is returned if the value
   cannot be determined.

platform.system_alias(system, release, version)

   Returns "(system, release, version)" aliased to common marketing
   names used for some systems.  It also does some reordering of the
   information in some cases where it would otherwise cause confusion.

platform.version()

   Returns the system’s release version, e.g. "'#3 on degas'". An
   empty string is returned if the value cannot be determined.

platform.uname()

   Fairly portable uname interface. Returns a "namedtuple()"
   containing six attributes: "system", "node", "release", "version",
   "machine", and "processor".

   Note that this adds a sixth attribute ("processor") not present in
   the "os.uname()" result.  Also, the attribute names are different
   for the first two attributes; "os.uname()" names them "sysname" and
   "nodename".

   Entries which cannot be determined are set to "''".

   Changed in version 3.3: Result changed from a tuple to a
   "namedtuple()".


Java Platform
=============

platform.java_ver(release='', vendor='', vminfo=('', '', ''), osinfo=('', '', ''))

   Version interface for Jython.

   Returns a tuple "(release, vendor, vminfo, osinfo)" with _vminfo_
   being a tuple "(vm_name, vm_release, vm_vendor)" and _osinfo_ being
   a tuple "(os_name, os_version, os_arch)". Values which cannot be
   determined are set to the defaults given as parameters (which all
   default to "''").


Windows Platform
================

platform.win32_ver(release='', version='', csd='', ptype='')

   Get additional version information from the Windows Registry and
   return a tuple "(release, version, csd, ptype)" referring to OS
   release, version number, CSD level (service pack) and OS type
   (multi/single processor). Values which cannot be determined are set
   to the defaults given as parameters (which all default to an empty
   string).

   As a hint: _ptype_ is "'Uniprocessor Free'" on single processor NT
   machines and "'Multiprocessor Free'" on multi processor machines.
   The _‘Free’_ refers to the OS version being free of debugging code.
   It could also state _‘Checked’_ which means the OS version uses
   debugging code, i.e. code that checks arguments, ranges, etc.

platform.win32_edition()

   Returns a string representing the current Windows edition, or
   "None" if the value cannot be determined.  Possible values include
   but are not limited to "'Enterprise'", "'IoTUAP'",
   "'ServerStandard'", and "'nanoserver'".

   New in version 3.8.

platform.win32_is_iot()

   Return "True" if the Windows edition returned by "win32_edition()"
   is recognized as an IoT edition.

   New in version 3.8.


macOS Platform
==============

platform.mac_ver(release='', versioninfo=('', '', ''), machine='')

   Get macOS version information and return it as tuple "(release,
   versioninfo, machine)" with _versioninfo_ being a tuple "(version,
   dev_stage, non_release_version)".

   Entries which cannot be determined are set to "''".  All tuple
   entries are strings.


Unix Platforms
==============

platform.libc_ver(executable=sys.executable, lib='', version='', chunksize=16384)

   Tries to determine the libc version against which the file
   executable (defaults to the Python interpreter) is linked.  Returns
   a tuple of strings "(lib, version)" which default to the given
   parameters in case the lookup fails.

   Note that this function has intimate knowledge of how different
   libc versions add symbols to the executable is probably only usable
   for executables compiled using **gcc**.

   The file is read and scanned in chunks of _chunksize_ bytes.


Linux Platforms
===============

platform.freedesktop_os_release()

   Get operating system identification from "os-release" file and
   return it as a dict. The "os-release" file is a freedesktop.org
   standard and is available in most Linux distributions. A noticeable
   exception is Android and Android-based distributions.

   Raises "OSError" or subclass when neither "/etc/os-release" nor
   "/usr/lib/os-release" can be read.

   On success, the function returns a dictionary where keys and values
   are strings. Values have their special characters like """ and "$"
   unquoted. The fields "NAME", "ID", and "PRETTY_NAME" are always
   defined according to the standard. All other fields are optional.
   Vendors may include additional fields.

   Note that fields like "NAME", "VERSION", and "VARIANT" are strings
   suitable for presentation to users. Programs should use fields like
   "ID", "ID_LIKE", "VERSION_ID", or "VARIANT_ID" to identify Linux
   distributions.

   Example:
>
      def get_like_distro():
          info = platform.freedesktop_os_release()
          ids = [info["ID"]]
          if "ID_LIKE" in info:
              # ids are space separated and ordered by precedence
              ids.extend(info["ID_LIKE"].split())
          return ids
<
   New in version 3.10.

vim:tw=78:ts=8:ft=help:norl: