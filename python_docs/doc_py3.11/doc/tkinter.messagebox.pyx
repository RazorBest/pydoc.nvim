Python 3.11.9
*tkinter.messagebox.pyx*                      Last change: 2024 May 24

"tkinter.messagebox" — Tkinter message prompts
**********************************************

**Source code:** Lib/tkinter/messagebox.py

======================================================================

The "tkinter.messagebox" module provides a template base class as well
as a variety of convenience methods for commonly used configurations.
The message boxes are modal and will return a subset of ("True",
"False", "None", "OK", "CANCEL", "YES", "NO") based on the user’s
selection. Common message box styles and layouts include but are not
limited to:

   [image]

class tkinter.messagebox.Message(master=None, **options)

   Create a message window with an application-specified message, an
   icon and a set of buttons. Each of the buttons in the message
   window is identified by a unique symbolic name (see the _type_
   options).

   The following options are supported:

      _command_
         Specifies the function to invoke when the user closes the
         dialog. The name of the button clicked by the user to close
         the dialog is passed as argument. This is only available on
         macOS.

      _default_
         Gives the symbolic name of the default button for this
         message window ("OK", "CANCEL", and so on). If this option is
         not specified, the first button in the dialog will be made
         the default.

      _detail_
         Specifies an auxiliary message to the main message given by
         the _message_ option. The message detail will be presented
         beneath the main message and, where supported by the OS, in a
         less emphasized font than the main message.

      _icon_
         Specifies an icon to display. If this option is not
         specified, then the "INFO" icon will be displayed.

      _message_
         Specifies the message to display in this message box. The
         default value is an empty string.

      _parent_
         Makes the specified window the logical parent of the message
         box. The message box is displayed on top of its parent
         window.

      _title_
         Specifies a string to display as the title of the message
         box. This option is ignored on macOS, where platform
         guidelines forbid the use of a title on this kind of dialog.

      _type_
         Arranges for a predefined set of buttons to be displayed.

   show(**options)

      Display a message window and wait for the user to select one of
      the buttons. Then return the symbolic name of the selected
      button. Keyword arguments can override options specified in the
      constructor.

**Information message box**

tkinter.messagebox.showinfo(title=None, message=None, **options)

   Creates and displays an information message box with the specified
   title and message.

**Warning message boxes**

tkinter.messagebox.showwarning(title=None, message=None, **options)

   Creates and displays a warning message box with the specified title
   and message.

tkinter.messagebox.showerror(title=None, message=None, **options)

   Creates and displays an error message box with the specified title
   and message.

**Question message boxes**

tkinter.messagebox.askquestion(title=None, message=None, *, type=YESNO, **options)

   Ask a question. By default shows buttons "YES" and "NO". Returns
   the symbolic name of the selected button.

tkinter.messagebox.askokcancel(title=None, message=None, **options)

   Ask if operation should proceed. Shows buttons "OK" and "CANCEL".
   Returns "True" if the answer is ok and "False" otherwise.

tkinter.messagebox.askretrycancel(title=None, message=None, **options)

   Ask if operation should be retried. Shows buttons "RETRY" and
   "CANCEL". Return "True" if the answer is yes and "False" otherwise.

tkinter.messagebox.askyesno(title=None, message=None, **options)

   Ask a question. Shows buttons "YES" and "NO". Returns "True" if the
   answer is yes and "False" otherwise.

tkinter.messagebox.askyesnocancel(title=None, message=None, **options)

   Ask a question. Shows buttons "YES", "NO" and "CANCEL". Return
   "True" if the answer is yes, "None" if cancelled, and "False"
   otherwise.

Symbolic names of buttons:

tkinter.messagebox.ABORT = 'abort'

tkinter.messagebox.RETRY = 'retry'

tkinter.messagebox.IGNORE = 'ignore'

tkinter.messagebox.OK = 'ok'

tkinter.messagebox.CANCEL = 'cancel'

tkinter.messagebox.YES = 'yes'

tkinter.messagebox.NO = 'no'

Predefined sets of buttons:

tkinter.messagebox.ABORTRETRYIGNORE = 'abortretryignore'

   Displays three buttons whose symbolic names are "ABORT", "RETRY"
   and "IGNORE".

tkinter.messagebox.OK = 'ok'

   Displays one button whose symbolic name is "OK".

tkinter.messagebox.OKCANCEL = 'okcancel'

   Displays two buttons whose symbolic names are "OK" and "CANCEL".

tkinter.messagebox.RETRYCANCEL = 'retrycancel'

   Displays two buttons whose symbolic names are "RETRY" and "CANCEL".

tkinter.messagebox.YESNO = 'yesno'

   Displays two buttons whose symbolic names are "YES" and "NO".

tkinter.messagebox.YESNOCANCEL = 'yesnocancel'

   Displays three buttons whose symbolic names are "YES", "NO" and
   "CANCEL".

Icon images:

tkinter.messagebox.ERROR = 'error'

tkinter.messagebox.INFO = 'info'

tkinter.messagebox.QUESTION = 'question'

tkinter.messagebox.WARNING = 'warning'

vim:tw=78:ts=8:ft=help:norl: