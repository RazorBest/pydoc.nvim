Python 3.11.9
*email.contentmanager.pyx*                    Last change: 2024 May 24

"email.contentmanager": Managing MIME Content
*********************************************

**Source code:** Lib/email/contentmanager.py

======================================================================

New in version 3.6: [1]

class email.contentmanager.ContentManager

   Base class for content managers.  Provides the standard registry
   mechanisms to register converters between MIME content and other
   representations, as well as the "get_content" and "set_content"
   dispatch methods.

   get_content(msg, *args, **kw)

      Look up a handler function based on the "mimetype" of _msg_ (see
      next paragraph), call it, passing through all arguments, and
      return the result of the call.  The expectation is that the
      handler will extract the payload from _msg_ and return an object
      that encodes information about the extracted data.

      To find the handler, look for the following keys in the
      registry, stopping with the first one found:

      * the string representing the full MIME type
        ("maintype/subtype")

      * the string representing the "maintype"

      * the empty string

      If none of these keys produce a handler, raise a "KeyError" for
      the full MIME type.

   set_content(msg, obj, *args, **kw)

      If the "maintype" is "multipart", raise a "TypeError"; otherwise
      look up a handler function based on the type of _obj_ (see next
      paragraph), call "clear_content()" on the _msg_, and call the
      handler function, passing through all arguments.  The
      expectation is that the handler will transform and store _obj_
      into _msg_, possibly making other changes to _msg_ as well, such
      as adding various MIME headers to encode information needed to
      interpret the stored data.

      To find the handler, obtain the type of _obj_ ("typ =
      type(obj)"), and look for the following keys in the registry,
      stopping with the first one found:

      * the type itself ("typ")

      * the type’s fully qualified name ("typ.__module__ + '.' +
        typ.__qualname__").

      * the type’s qualname ("typ.__qualname__")

      * the type’s name ("typ.__name__").

      If none of the above match, repeat all of the checks above for
      each of the types in the _MRO_ ("typ.__mro__").  Finally, if no
      other key yields a handler, check for a handler for the key
      "None".  If there is no handler for "None", raise a "KeyError"
      for the fully qualified name of the type.

      Also add a _MIME-Version_ header if one is not present (see also
      "MIMEPart").

   add_get_handler(key, handler)

      Record the function _handler_ as the handler for _key_.  For the
      possible values of _key_, see "get_content()".

   add_set_handler(typekey, handler)

      Record _handler_ as the function to call when an object of a
      type matching _typekey_ is passed to "set_content()".  For the
      possible values of _typekey_, see "set_content()".


Content Manager Instances
=========================

Currently the email package provides only one concrete content
manager, "raw_data_manager", although more may be added in the future.
"raw_data_manager" is the "content_manager" provided by "EmailPolicy"
and its derivatives.

email.contentmanager.raw_data_manager

   This content manager provides only a minimum interface beyond that
   provided by "Message" itself:  it deals only with text, raw byte
   strings, and "Message" objects.  Nevertheless, it provides
   significant advantages compared to the base API: "get_content" on a
   text part will return a unicode string without the application
   needing to manually decode it, "set_content" provides a rich set of
   options for controlling the headers added to a part and controlling
   the content transfer encoding, and it enables the use of the
   various "add_" methods, thereby simplifying the creation of
   multipart messages.

   email.contentmanager.get_content(msg, errors='replace')

      Return the payload of the part as either a string (for "text"
      parts), an "EmailMessage" object (for "message/rfc822" parts),
      or a "bytes" object (for all other non-multipart types).  Raise
      a "KeyError" if called on a "multipart".  If the part is a
      "text" part and _errors_ is specified, use it as the error
      handler when decoding the payload to unicode.  The default error
      handler is "replace".

   email.contentmanager.set_content(msg, <'str'>, subtype="plain", charset='utf-8', cte=None, disposition=None, filename=None, cid=None, params=None, headers=None)
   email.contentmanager.set_content(msg, <'bytes'>, maintype, subtype, cte="base64", disposition=None, filename=None, cid=None, params=None, headers=None)
   email.contentmanager.set_content(msg, <'EmailMessage'>, cte=None, disposition=None, filename=None, cid=None, params=None, headers=None)

      Add headers and payload to _msg_:

      Add a _Content-Type_ header with a "maintype/subtype" value.

      * For "str", set the MIME "maintype" to "text", and set the
        subtype to _subtype_ if it is specified, or "plain" if it is
        not.

      * For "bytes", use the specified _maintype_ and _subtype_, or
        raise a "TypeError" if they are not specified.

      * For "EmailMessage" objects, set the maintype to "message", and
        set the subtype to _subtype_ if it is specified or "rfc822" if
        it is not.  If _subtype_ is "partial", raise an error ("bytes"
        objects must be used to construct "message/partial" parts).

      If _charset_ is provided (which is valid only for "str"), encode
      the string to bytes using the specified character set.  The
      default is "utf-8".  If the specified _charset_ is a known alias
      for a standard MIME charset name, use the standard charset
      instead.

      If _cte_ is set, encode the payload using the specified content
      transfer encoding, and set the _Content-Transfer-Encoding_
      header to that value.  Possible values for _cte_ are "quoted-
      printable", "base64", "7bit", "8bit", and "binary".  If the
      input cannot be encoded in the specified encoding (for example,
      specifying a _cte_ of "7bit" for an input that contains non-
      ASCII values), raise a "ValueError".

      * For "str" objects, if _cte_ is not set use heuristics to
        determine the most compact encoding.

      * For "EmailMessage", per **RFC 2046**, raise an error if a
        _cte_ of "quoted-printable" or "base64" is requested for
        _subtype_ "rfc822", and for any _cte_ other than "7bit" for
        _subtype_ "external-body".  For "message/rfc822", use "8bit"
        if _cte_ is not specified.  For all other values of _subtype_,
        use "7bit".

      Note:

        A _cte_ of "binary" does not actually work correctly yet. The
        "EmailMessage" object as modified by "set_content" is correct,
        but "BytesGenerator" does not serialize it correctly.

      If _disposition_ is set, use it as the value of the _Content-
      Disposition_ header.  If not specified, and _filename_ is
      specified, add the header with the value "attachment". If
      _disposition_ is not specified and _filename_ is also not
      specified, do not add the header.  The only valid values for
      _disposition_ are "attachment" and "inline".

      If _filename_ is specified, use it as the value of the
      "filename" parameter of the _Content-Disposition_ header.

      If _cid_ is specified, add a _Content-ID_ header with _cid_ as
      its value.

      If _params_ is specified, iterate its "items" method and use the
      resulting "(key, value)" pairs to set additional parameters on
      the _Content-Type_ header.

      If _headers_ is specified and is a list of strings of the form
      "headername: headervalue" or a list of "header" objects
      (distinguished from strings by having a "name" attribute), add
      the headers to _msg_.

-[ Footnotes ]-

[1] Originally added in 3.4 as a _provisional module_

vim:tw=78:ts=8:ft=help:norl: