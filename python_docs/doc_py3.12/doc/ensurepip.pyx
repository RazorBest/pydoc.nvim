Python 3.12.3
*ensurepip.pyx*                               Last change: 2024 May 24

"ensurepip" — Bootstrapping the "pip" installer
***********************************************

New in version 3.4.

**Source code:** Lib/ensurepip

======================================================================

The "ensurepip" package provides support for bootstrapping the "pip"
installer into an existing Python installation or virtual environment.
This bootstrapping approach reflects the fact that "pip" is an
independent project with its own release cycle, and the latest
available stable version is bundled with maintenance and feature
releases of the CPython reference interpreter.

In most cases, end users of Python shouldn’t need to invoke this
module directly (as "pip" should be bootstrapped by default), but it
may be needed if installing "pip" was skipped when installing Python
(or when creating a virtual environment) or after explicitly
uninstalling "pip".

Note:

  This module _does not_ access the internet. All of the components
  needed to bootstrap "pip" are included as internal parts of the
  package.

See also:

  Installing Python Modules
     The end user guide for installing Python packages

  **PEP 453**: Explicit bootstrapping of pip in Python installations
     The original rationale and specification for this module.

Availability: not Emscripten, not WASI.

This module does not work or is not available on WebAssembly platforms
"wasm32-emscripten" and "wasm32-wasi". See WebAssembly platforms for
more information.


Command line interface
======================

The command line interface is invoked using the interpreter’s "-m"
switch.

The simplest possible invocation is:
>
   python -m ensurepip
<
This invocation will install "pip" if it is not already installed, but
otherwise does nothing. To ensure the installed version of "pip" is at
least as recent as the one available in "ensurepip", pass the "--
upgrade" option:
>
   python -m ensurepip --upgrade
<
By default, "pip" is installed into the current virtual environment
(if one is active) or into the system site packages (if there is no
active virtual environment). The installation location can be
controlled through two additional command line options:

* "--root _dir_": Installs "pip" relative to the given root directory
  rather than the root of the currently active virtual environment (if
  any) or the default root for the current Python installation.

* "--user": Installs "pip" into the user site packages directory
  rather than globally for the current Python installation (this
  option is not permitted inside an active virtual environment).

By default, the scripts "pipX" and "pipX.Y" will be installed (where
X.Y stands for the version of Python used to invoke "ensurepip"). The
scripts installed can be controlled through two additional command
line options:

* "--altinstall": if an alternate installation is requested, the
  "pipX" script will _not_ be installed.

* "--default-pip": if a “default pip” installation is requested, the
  "pip" script will be installed in addition to the two regular
  scripts.

Providing both of the script selection options will trigger an
exception.


Module API
==========

"ensurepip" exposes two functions for programmatic use:

ensurepip.version()

   Returns a string specifying the available version of pip that will
   be installed when bootstrapping an environment.

ensurepip.bootstrap(root=None, upgrade=False, user=False, altinstall=False, default_pip=False, verbosity=0)

   Bootstraps "pip" into the current or designated environment.

   _root_ specifies an alternative root directory to install relative
   to. If _root_ is "None", then installation uses the default install
   location for the current environment.

   _upgrade_ indicates whether or not to upgrade an existing
   installation of an earlier version of "pip" to the available
   version.

   _user_ indicates whether to use the user scheme rather than
   installing globally.

   By default, the scripts "pipX" and "pipX.Y" will be installed
   (where X.Y stands for the current version of Python).

   If _altinstall_ is set, then "pipX" will _not_ be installed.

   If _default_pip_ is set, then "pip" will be installed in addition
   to the two regular scripts.

   Setting both _altinstall_ and _default_pip_ will trigger
   "ValueError".

   _verbosity_ controls the level of output to "sys.stdout" from the
   bootstrapping operation.

   Raises an auditing event "ensurepip.bootstrap" with argument
   "root".

   Note:

     The bootstrapping process has side effects on both "sys.path" and
     "os.environ". Invoking the command line interface in a subprocess
     instead allows these side effects to be avoided.

   Note:

     The bootstrapping process may install additional modules required
     by "pip", but other software should not assume those dependencies
     will always be present by default (as the dependencies may be
     removed in a future version of "pip").

vim:tw=78:ts=8:ft=help:norl: