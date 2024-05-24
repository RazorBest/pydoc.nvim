Python 3.9.19
*tkinter.scrolledtext.pyx*                    Last change: 2024 May 24

"tkinter.scrolledtext" — Scrolled Text Widget
*********************************************

**Source code:** Lib/tkinter/scrolledtext.py

======================================================================

The "tkinter.scrolledtext" module provides a class of the same name
which implements a basic text widget which has a vertical scroll bar
configured to do the “right thing.”  Using the "ScrolledText" class is
a lot easier than setting up a text widget and scroll bar directly.

The text widget and scrollbar are packed together in a "Frame", and
the methods of the "Grid" and "Pack" geometry managers are acquired
from the "Frame" object.  This allows the "ScrolledText" widget to be
used directly to achieve most normal geometry management behavior.

Should more specific control be necessary, the following attributes
are available:

class tkinter.scrolledtext.ScrolledText(master=None, **kw)

   frame

      The frame which surrounds the text and scroll bar widgets.

   vbar

      The scroll bar widget.

vim:tw=78:ts=8:ft=help:norl: