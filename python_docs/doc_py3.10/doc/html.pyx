Python 3.10.14
*html.pyx*                                    Last change: 2024 May 24

"html" — HyperText Markup Language support
******************************************

**Source code:** Lib/html/__init__.py

======================================================================

This module defines utilities to manipulate HTML.

html.escape(s, quote=True)

   Convert the characters "&", "<" and ">" in string _s_ to HTML-safe
   sequences.  Use this if you need to display text that might contain
   such characters in HTML.  If the optional flag _quote_ is true, the
   characters (""") and ("'") are also translated; this helps for
   inclusion in an HTML attribute value delimited by quotes, as in "<a
   href="...">".

   New in version 3.2.

html.unescape(s)

   Convert all named and numeric character references (e.g. "&gt;",
   "&#62;", "&#x3e;") in the string _s_ to the corresponding Unicode
   characters.  This function uses the rules defined by the HTML 5
   standard for both valid and invalid character references, and the
   "list of HTML 5 named character references".

   New in version 3.4.

======================================================================

Submodules in the "html" package are:

* "html.parser" – HTML/XHTML parser with lenient parsing mode

* "html.entities" – HTML entity definitions

vim:tw=78:ts=8:ft=help:norl: