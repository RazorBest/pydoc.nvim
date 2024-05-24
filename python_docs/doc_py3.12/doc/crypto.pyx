Python 3.12.3
*crypto.pyx*                                  Last change: 2024 May 24

Cryptographic Services
**********************

The modules described in this chapter implement various algorithms of
a cryptographic nature.  They are available at the discretion of the
installation. On Unix systems, the "crypt" module may also be
available. Here’s an overview:

* "hashlib" — Secure hashes and message digests

  * Hash algorithms

  * Usage

  * Constructors

  * Attributes

  * Hash Objects

  * SHAKE variable length digests

  * File hashing

  * Key derivation

  * BLAKE2

    * Creating hash objects

    * Constants

    * Examples

      * Simple hashing

      * Using different digest sizes

      * Keyed hashing

      * Randomized hashing

      * Personalization

      * Tree mode

    * Credits

* "hmac" — Keyed-Hashing for Message Authentication

* "secrets" — Generate secure random numbers for managing secrets

  * Random numbers

  * Generating tokens

    * How many bytes should tokens use?

  * Other functions

  * Recipes and best practices

vim:tw=78:ts=8:ft=help:norl: