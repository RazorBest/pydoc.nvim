Python 3.11.9
*webbrowser.pyx*                              Last change: 2024 May 24

"webbrowser" — Convenient web-browser controller
************************************************

**Source code:** Lib/webbrowser.py

======================================================================

The "webbrowser" module provides a high-level interface to allow
displaying web-based documents to users. Under most circumstances,
simply calling the "open()" function from this module will do the
right thing.

Under Unix, graphical browsers are preferred under X11, but text-mode
browsers will be used if graphical browsers are not available or an
X11 display isn’t available.  If text-mode browsers are used, the
calling process will block until the user exits the browser.

If the environment variable "BROWSER" exists, it is interpreted as the
"os.pathsep"-separated list of browsers to try ahead of the platform
defaults.  When the value of a list part contains the string "%s",
then it is interpreted as a literal browser command line to be used
with the argument URL substituted for "%s"; if the part does not
contain "%s", it is simply interpreted as the name of the browser to
launch. [1]

For non-Unix platforms, or when a remote browser is available on Unix,
the controlling process will not wait for the user to finish with the
browser, but allow the remote browser to maintain its own windows on
the display.  If remote browsers are not available on Unix, the
controlling process will launch a new browser and wait.

The script **webbrowser** can be used as a command-line interface for
the module. It accepts a URL as the argument. It accepts the following
optional parameters: "-n" opens the URL in a new browser window, if
possible; "-t" opens the URL in a new browser page (“tab”). The
options are, naturally, mutually exclusive.  Usage example:
>
   python -m webbrowser -t "https://www.python.org"
<
Availability: not Emscripten, not WASI.

This module does not work or is not available on WebAssembly platforms
"wasm32-emscripten" and "wasm32-wasi". See WebAssembly platforms for
more information.

The following exception is defined:

exception webbrowser.Error

   Exception raised when a browser control error occurs.

The following functions are defined:

webbrowser.open(url, new=0, autoraise=True)

   Display _url_ using the default browser. If _new_ is 0, the _url_
   is opened in the same browser window if possible.  If _new_ is 1, a
   new browser window is opened if possible.  If _new_ is 2, a new
   browser page (“tab”) is opened if possible.  If _autoraise_ is
   "True", the window is raised if possible (note that under many
   window managers this will occur regardless of the setting of this
   variable).

   Note that on some platforms, trying to open a filename using this
   function, may work and start the operating system’s associated
   program.  However, this is neither supported nor portable.

   Raises an auditing event "webbrowser.open" with argument "url".

webbrowser.open_new(url)

   Open _url_ in a new window of the default browser, if possible,
   otherwise, open _url_ in the only browser window.

webbrowser.open_new_tab(url)

   Open _url_ in a new page (“tab”) of the default browser, if
   possible, otherwise equivalent to "open_new()".

webbrowser.get(using=None)

   Return a controller object for the browser type _using_.  If
   _using_ is "None", return a controller for a default browser
   appropriate to the caller’s environment.

webbrowser.register(name, constructor, instance=None, *, preferred=False)

   Register the browser type _name_.  Once a browser type is
   registered, the "get()" function can return a controller for that
   browser type.  If _instance_ is not provided, or is "None",
   _constructor_ will be called without parameters to create an
   instance when needed.  If _instance_ is provided, _constructor_
   will never be called, and may be "None".

   Setting _preferred_ to "True" makes this browser a preferred result
   for a "get()" call with no argument.  Otherwise, this entry point
   is only useful if you plan to either set the "BROWSER" variable or
   call "get()" with a nonempty argument matching the name of a
   handler you declare.

   Changed in version 3.7: _preferred_ keyword-only parameter was
   added.

A number of browser types are predefined.  This table gives the type
names that may be passed to the "get()" function and the corresponding
instantiations for the controller classes, all defined in this module.

+--------------------------+-------------------------------------------+---------+
| Type Name                | Class Name                                | Notes   |
|==========================|===========================================|=========|
| "'mozilla'"              | "Mozilla('mozilla')"                      |         |
+--------------------------+-------------------------------------------+---------+
| "'firefox'"              | "Mozilla('mozilla')"                      |         |
+--------------------------+-------------------------------------------+---------+
| "'netscape'"             | "Mozilla('netscape')"                     |         |
+--------------------------+-------------------------------------------+---------+
| "'galeon'"               | "Galeon('galeon')"                        |         |
+--------------------------+-------------------------------------------+---------+
| "'epiphany'"             | "Galeon('epiphany')"                      |         |
+--------------------------+-------------------------------------------+---------+
| "'skipstone'"            | "BackgroundBrowser('skipstone')"          |         |
+--------------------------+-------------------------------------------+---------+
| "'kfmclient'"            | "Konqueror()"                             | (1)     |
+--------------------------+-------------------------------------------+---------+
| "'konqueror'"            | "Konqueror()"                             | (1)     |
+--------------------------+-------------------------------------------+---------+
| "'kfm'"                  | "Konqueror()"                             | (1)     |
+--------------------------+-------------------------------------------+---------+
| "'mosaic'"               | "BackgroundBrowser('mosaic')"             |         |
+--------------------------+-------------------------------------------+---------+
| "'opera'"                | "Opera()"                                 |         |
+--------------------------+-------------------------------------------+---------+
| "'grail'"                | "Grail()"                                 |         |
+--------------------------+-------------------------------------------+---------+
| "'links'"                | "GenericBrowser('links')"                 |         |
+--------------------------+-------------------------------------------+---------+
| "'elinks'"               | "Elinks('elinks')"                        |         |
+--------------------------+-------------------------------------------+---------+
| "'lynx'"                 | "GenericBrowser('lynx')"                  |         |
+--------------------------+-------------------------------------------+---------+
| "'w3m'"                  | "GenericBrowser('w3m')"                   |         |
+--------------------------+-------------------------------------------+---------+
| "'windows-default'"      | "WindowsDefault"                          | (2)     |
+--------------------------+-------------------------------------------+---------+
| "'macosx'"               | "MacOSXOSAScript('default')"              | (3)     |
+--------------------------+-------------------------------------------+---------+
| "'safari'"               | "MacOSXOSAScript('safari')"               | (3)     |
+--------------------------+-------------------------------------------+---------+
| "'google-chrome'"        | "Chrome('google-chrome')"                 |         |
+--------------------------+-------------------------------------------+---------+
| "'chrome'"               | "Chrome('chrome')"                        |         |
+--------------------------+-------------------------------------------+---------+
| "'chromium'"             | "Chromium('chromium')"                    |         |
+--------------------------+-------------------------------------------+---------+
| "'chromium-browser'"     | "Chromium('chromium-browser')"            |         |
+--------------------------+-------------------------------------------+---------+

Notes:

1. “Konqueror” is the file manager for the KDE desktop environment for
   Unix, and only makes sense to use if KDE is running.  Some way of
   reliably detecting KDE would be nice; the "KDEDIR" variable is not
   sufficient.  Note also that the name “kfm” is used even when using
   the **konqueror** command with KDE 2 — the implementation selects
   the best strategy for running Konqueror.

2. Only on Windows platforms.

3. Only on macOS platform.

New in version 3.3: Support for Chrome/Chromium has been added.

Deprecated since version 3.11, will be removed in version 3.13:
"MacOSX" is deprecated, use "MacOSXOSAScript" instead.

Here are some simple examples:
>
   url = 'https://docs.python.org/'

   # Open URL in a new tab, if a browser window is already open.
   webbrowser.open_new_tab(url)

   # Open URL in new window, raising the window if possible.
   webbrowser.open_new(url)
<

Browser Controller Objects
==========================

Browser controllers provide these methods which parallel three of the
module-level convenience functions:

webbrowser.name

   System-dependent name for the browser.

controller.open(url, new=0, autoraise=True)

   Display _url_ using the browser handled by this controller. If
   _new_ is 1, a new browser window is opened if possible. If _new_ is
   2, a new browser page (“tab”) is opened if possible.

controller.open_new(url)

   Open _url_ in a new window of the browser handled by this
   controller, if possible, otherwise, open _url_ in the only browser
   window.  Alias "open_new()".

controller.open_new_tab(url)

   Open _url_ in a new page (“tab”) of the browser handled by this
   controller, if possible, otherwise equivalent to "open_new()".

-[ Footnotes ]-

[1] Executables named here without a full path will be searched in the
    directories given in the "PATH" environment variable.

vim:tw=78:ts=8:ft=help:norl: