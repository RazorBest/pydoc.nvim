Python 3.12.3
*email.utils.pyx*                             Last change: 2024 May 24

"email.utils": Miscellaneous utilities
**************************************

**Source code:** Lib/email/utils.py

======================================================================

There are a couple of useful utilities provided in the "email.utils"
module:

email.utils.localtime(dt=None)

   Return local time as an aware datetime object.  If called without
   arguments, return current time.  Otherwise _dt_ argument should be
   a "datetime" instance, and it is converted to the local time zone
   according to the system time zone database.  If _dt_ is naive (that
   is, "dt.tzinfo" is "None"), it is assumed to be in local time.  The
   _isdst_ parameter is ignored.

   New in version 3.3.

   Deprecated since version 3.12, will be removed in version 3.14: The
   _isdst_ parameter.

email.utils.make_msgid(idstring=None, domain=None)

   Returns a string suitable for an **RFC 2822**-compliant _Message-
   ID_ header.  Optional _idstring_ if given, is a string used to
   strengthen the uniqueness of the message id.  Optional _domain_ if
   given provides the portion of the msgid after the ‘@’.  The default
   is the local hostname.  It is not normally necessary to override
   this default, but may be useful certain cases, such as a
   constructing distributed system that uses a consistent domain name
   across multiple hosts.

   Changed in version 3.2: Added the _domain_ keyword.

The remaining functions are part of the legacy ("Compat32") email API.
There is no need to directly use these with the new API, since the
parsing and formatting they provide is done automatically by the
header parsing machinery of the new API.

email.utils.quote(str)

   Return a new string with backslashes in _str_ replaced by two
   backslashes, and double quotes replaced by backslash-double quote.

email.utils.unquote(str)

   Return a new string which is an _unquoted_ version of _str_. If
   _str_ ends and begins with double quotes, they are stripped off.
   Likewise if _str_ ends and begins with angle brackets, they are
   stripped off.

email.utils.parseaddr(address)

   Parse address – which should be the value of some address-
   containing field such as _To_ or _Cc_ – into its constituent
   _realname_ and _email address_ parts.  Returns a tuple of that
   information, unless the parse fails, in which case a 2-tuple of
   "('', '')" is returned.

email.utils.formataddr(pair, charset='utf-8')

   The inverse of "parseaddr()", this takes a 2-tuple of the form
   "(realname, email_address)" and returns the string value suitable
   for a _To_ or _Cc_ header.  If the first element of _pair_ is
   false, then the second element is returned unmodified.

   Optional _charset_ is the character set that will be used in the
   **RFC 2047** encoding of the "realname" if the "realname" contains
   non-ASCII characters.  Can be an instance of "str" or a "Charset".
   Defaults to "utf-8".

   Changed in version 3.3: Added the _charset_ option.

email.utils.getaddresses(fieldvalues)

   This method returns a list of 2-tuples of the form returned by
   "parseaddr()". _fieldvalues_ is a sequence of header field values
   as might be returned by "Message.get_all".  Here’s a simple example
   that gets all the recipients of a message:
>
      from email.utils import getaddresses

      tos = msg.get_all('to', [])
      ccs = msg.get_all('cc', [])
      resent_tos = msg.get_all('resent-to', [])
      resent_ccs = msg.get_all('resent-cc', [])
      all_recipients = getaddresses(tos + ccs + resent_tos + resent_ccs)
<
email.utils.parsedate(date)

   Attempts to parse a date according to the rules in **RFC 2822**.
   however, some mailers don’t follow that format as specified, so
   "parsedate()" tries to guess correctly in such cases.  _date_ is a
   string containing an **RFC 2822** date, such as  ""Mon, 20 Nov 1995
   19:12:08 -0500"".  If it succeeds in parsing the date,
   "parsedate()" returns a 9-tuple that can be passed directly to
   "time.mktime()"; otherwise "None" will be returned.  Note that
   indexes 6, 7, and 8 of the result tuple are not usable.

email.utils.parsedate_tz(date)

   Performs the same function as "parsedate()", but returns either
   "None" or a 10-tuple; the first 9 elements make up a tuple that can
   be passed directly to "time.mktime()", and the tenth is the offset
   of the date’s timezone from UTC (which is the official term for
   Greenwich Mean Time) [1].  If the input string has no timezone, the
   last element of the tuple returned is "0", which represents UTC.
   Note that indexes 6, 7, and 8 of the result tuple are not usable.

email.utils.parsedate_to_datetime(date)

   The inverse of "format_datetime()".  Performs the same function as
   "parsedate()", but on success returns a "datetime"; otherwise
   "ValueError" is raised if _date_ contains an invalid value such as
   an hour greater than 23 or a timezone offset not between -24 and 24
   hours. If the input date has a timezone of "-0000", the "datetime"
   will be a naive "datetime", and if the date is conforming to the
   RFCs it will represent a time in UTC but with no indication of the
   actual source timezone of the message the date comes from.  If the
   input date has any other valid timezone offset, the "datetime" will
   be an aware "datetime" with the corresponding a "timezone"
   "tzinfo".

   New in version 3.3.

email.utils.mktime_tz(tuple)

   Turn a 10-tuple as returned by "parsedate_tz()" into a UTC
   timestamp (seconds since the Epoch).  If the timezone item in the
   tuple is "None", assume local time.

email.utils.formatdate(timeval=None, localtime=False, usegmt=False)

   Returns a date string as per **RFC 2822**, e.g.:
>
      Fri, 09 Nov 2001 01:08:47 -0000
<
   Optional _timeval_ if given is a floating point time value as
   accepted by "time.gmtime()" and "time.localtime()", otherwise the
   current time is used.

   Optional _localtime_ is a flag that when "True", interprets
   _timeval_, and returns a date relative to the local timezone
   instead of UTC, properly taking daylight savings time into account.
   The default is "False" meaning UTC is used.

   Optional _usegmt_ is a flag that when "True", outputs a  date
   string with the timezone as an ascii string "GMT", rather than a
   numeric "-0000". This is needed for some protocols (such as HTTP).
   This only applies when _localtime_ is "False".  The default is
   "False".

email.utils.format_datetime(dt, usegmt=False)

   Like "formatdate", but the input is a "datetime" instance.  If it
   is a naive datetime, it is assumed to be “UTC with no information
   about the source timezone”, and the conventional "-0000" is used
   for the timezone. If it is an aware "datetime", then the numeric
   timezone offset is used. If it is an aware timezone with offset
   zero, then _usegmt_ may be set to "True", in which case the string
   "GMT" is used instead of the numeric timezone offset.  This
   provides a way to generate standards conformant HTTP date headers.

   New in version 3.3.

email.utils.decode_rfc2231(s)

   Decode the string _s_ according to **RFC 2231**.

email.utils.encode_rfc2231(s, charset=None, language=None)

   Encode the string _s_ according to **RFC 2231**.  Optional
   _charset_ and _language_, if given is the character set name and
   language name to use.  If neither is given, _s_ is returned as-is.
   If _charset_ is given but _language_ is not, the string is encoded
   using the empty string for _language_.

email.utils.collapse_rfc2231_value(value, errors='replace', fallback_charset='us-ascii')

   When a header parameter is encoded in **RFC 2231** format,
   "Message.get_param" may return a 3-tuple containing the character
   set, language, and value.  "collapse_rfc2231_value()" turns this
   into a unicode string.  Optional _errors_ is passed to the _errors_
   argument of "str"’s "encode()" method; it defaults to "'replace'".
   Optional _fallback_charset_ specifies the character set to use if
   the one in the **RFC 2231** header is not known by Python; it
   defaults to "'us-ascii'".

   For convenience, if the _value_ passed to
   "collapse_rfc2231_value()" is not a tuple, it should be a string
   and it is returned unquoted.

email.utils.decode_params(params)

   Decode parameters list according to **RFC 2231**.  _params_ is a
   sequence of 2-tuples containing elements of the form "(content-
   type, string-value)".

-[ Footnotes ]-

[1] Note that the sign of the timezone offset is the opposite of the
    sign of the "time.timezone" variable for the same timezone; the
    latter variable follows the POSIX standard while this module
    follows **RFC 2822**.

vim:tw=78:ts=8:ft=help:norl: