Python 3.12.3
*netdata.pyx*                                 Last change: 2024 May 24

Internet Data Handling
**********************

This chapter describes modules which support handling data formats
commonly used on the internet.

* "email" — An email and MIME handling package

  * "email.message": Representing an email message

  * "email.parser": Parsing email messages

    * FeedParser API

    * Parser API

    * Additional notes

  * "email.generator": Generating MIME documents

  * "email.policy": Policy Objects

  * "email.errors": Exception and Defect classes

  * "email.headerregistry": Custom Header Objects

  * "email.contentmanager": Managing MIME Content

    * Content Manager Instances

  * "email": Examples

  * "email.message.Message": Representing an email message using the
    "compat32" API

  * "email.mime": Creating email and MIME objects from scratch

  * "email.header": Internationalized headers

  * "email.charset": Representing character sets

  * "email.encoders": Encoders

  * "email.utils": Miscellaneous utilities

  * "email.iterators": Iterators

* "json" — JSON encoder and decoder

  * Basic Usage

  * Encoders and Decoders

  * Exceptions

  * Standard Compliance and Interoperability

    * Character Encodings

    * Infinite and NaN Number Values

    * Repeated Names Within an Object

    * Top-level Non-Object, Non-Array Values

    * Implementation Limitations

  * Command Line Interface

    * Command line options

* "mailbox" — Manipulate mailboxes in various formats

  * "Mailbox" objects

    * "Maildir" objects

    * "mbox" objects

    * "MH" objects

    * "Babyl" objects

    * "MMDF" objects

  * "Message" objects

    * "MaildirMessage" objects

    * "mboxMessage" objects

    * "MHMessage" objects

    * "BabylMessage" objects

    * "MMDFMessage" objects

  * Exceptions

  * Examples

* "mimetypes" — Map filenames to MIME types

  * MimeTypes Objects

* "base64" — Base16, Base32, Base64, Base85 Data Encodings

  * Security Considerations

* "binascii" — Convert between binary and ASCII

* "quopri" — Encode and decode MIME quoted-printable data

vim:tw=78:ts=8:ft=help:norl: