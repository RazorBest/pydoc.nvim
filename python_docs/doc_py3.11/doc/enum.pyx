Python 3.11.9
*enum.pyx*                                    Last change: 2024 May 24

"enum" — Support for enumerations
*********************************

New in version 3.4.

**Source code:** Lib/enum.py


Important
^^^^^^^^^

This page contains the API reference information. For tutorial
information and discussion of more advanced topics, see

* Basic Tutorial

* Advanced Tutorial

* Enum Cookbook

======================================================================

An enumeration:

* is a set of symbolic names (members) bound to unique values

* can be iterated over to return its canonical (i.e. non-alias)
  members in definition order

* uses _call_ syntax to return members by value

* uses _index_ syntax to return members by name

Enumerations are created either by using "class" syntax, or by using
function-call syntax:
>
   >>> from enum import Enum

   >>> # class syntax
   >>> class Color(Enum):
   ...     RED = 1
   ...     GREEN = 2
   ...     BLUE = 3

   >>> # functional syntax
   >>> Color = Enum('Color', ['RED', 'GREEN', 'BLUE'])
<
Even though we can use "class" syntax to create Enums, Enums are not
normal Python classes.  See How are Enums different? for more details.

Note:

  Nomenclature

  * The class "Color" is an _enumeration_ (or _enum_)

  * The attributes "Color.RED", "Color.GREEN", etc., are _enumeration
    members_ (or _members_) and are functionally constants.

  * The enum members have _names_ and _values_ (the name of
    "Color.RED" is "RED", the value of "Color.BLUE" is "3", etc.)

======================================================================


Module Contents
===============

   "EnumType"

      The "type" for Enum and its subclasses.

   "Enum"

      Base class for creating enumerated constants.

   "IntEnum"

      Base class for creating enumerated constants that are also
      subclasses of "int". (Notes)

   "StrEnum"

      Base class for creating enumerated constants that are also
      subclasses of "str". (Notes)

   "Flag"

      Base class for creating enumerated constants that can be
      combined using the bitwise operations without losing their
      "Flag" membership.

   "IntFlag"

      Base class for creating enumerated constants that can be
      combined using the bitwise operators without losing their
      "IntFlag" membership. "IntFlag" members are also subclasses of
      "int". (Notes)

   "ReprEnum"

      Used by "IntEnum", "StrEnum", and "IntFlag" to keep the "str()"
      of the mixed-in type.

   "EnumCheck"

      An enumeration with the values "CONTINUOUS", "NAMED_FLAGS", and
      "UNIQUE", for use with "verify()" to ensure various constraints
      are met by a given enumeration.

   "FlagBoundary"

      An enumeration with the values "STRICT", "CONFORM", "EJECT", and
      "KEEP" which allows for more fine-grained control over how
      invalid values are dealt with in an enumeration.

   "auto"

      Instances are replaced with an appropriate value for Enum
      members. "StrEnum" defaults to the lower-cased version of the
      member name, while other Enums default to 1 and increase from
      there.

   "property()"

      Allows "Enum" members to have attributes without conflicting
      with member names.

   "unique()"

      Enum class decorator that ensures only one name is bound to any
      one value.

   "verify()"

      Enum class decorator that checks user-selectable constraints on
      an enumeration.

   "member()"

      Make "obj" a member.  Can be used as a decorator.

   "nonmember()"

      Do not make "obj" a member.  Can be used as a decorator.

   "global_enum()"

      Modify the "str()" and "repr()" of an enum to show its members
      as belonging to the module instead of its class, and export the
      enum members to the global namespace.

   "show_flag_values()"

      Return a list of all power-of-two integers contained in a flag.

New in version 3.6: "Flag", "IntFlag", "auto"

New in version 3.11: "StrEnum", "EnumCheck", "ReprEnum",
"FlagBoundary", "property", "member", "nonmember", "global_enum",
"show_flag_values"

======================================================================


Data Types
==========

class enum.EnumType

   _EnumType_ is the _metaclass_ for _enum_ enumerations.  It is
   possible to subclass _EnumType_ – see Subclassing EnumType for
   details.

   _EnumType_ is responsible for setting the correct "__repr__()",
   "__str__()", "__format__()", and "__reduce__()" methods on the
   final _enum_, as well as creating the enum members, properly
   handling duplicates, providing iteration over the enum class, etc.

   __call__(cls, value, names=None, *, module=None, qualname=None, type=None, start=1, boundary=None)

      This method is called in two different ways:

      * to look up an existing member:

           cls:
              The enum class being called.

           value:
              The value to lookup.

      * to use the "cls" enum to create a new enum (only if the
        existing enum does not have any members):

           cls:
              The enum class being called.

           value:
              The name of the new Enum to create.

           names:
              The names/values of the members for the new Enum.

           module:
              The name of the module the new Enum is created in.

           qualname:
              The actual location in the module where this Enum can be
              found.

           type:
              A mix-in type for the new Enum.

           start:
              The first integer value for the Enum (used by "auto").

           boundary:
              How to handle out-of-range values from bit operations
              ("Flag" only).

   __contains__(cls, member)

      Returns "True" if member belongs to the "cls":
>
         >>> some_var = Color.RED
         >>> some_var in Color
         True
<
      Note:

        In Python 3.12 it will be possible to check for member values
        and not just members; until then, a "TypeError" will be raised
        if a non-Enum-member is used in a containment check.

   __dir__(cls)

      Returns "['__class__', '__doc__', '__members__', '__module__']"
      and the names of the members in _cls_:
>
         >>> dir(Color)
         ['BLUE', 'GREEN', 'RED', '__class__', '__contains__', '__doc__', '__getitem__', '__init_subclass__', '__iter__', '__len__', '__members__', '__module__', '__name__', '__qualname__']
<
   __getattr__(cls, name)

      Returns the Enum member in _cls_ matching _name_, or raises an
      "AttributeError":
>
         >>> Color.GREEN
         <Color.GREEN: 2>
<
   __getitem__(cls, name)

      Returns the Enum member in _cls_ matching _name_, or raises a
      "KeyError":
>
         >>> Color['BLUE']
         <Color.BLUE: 3>
<
   __iter__(cls)

      Returns each member in _cls_ in definition order:
>
         >>> list(Color)
         [<Color.RED: 1>, <Color.GREEN: 2>, <Color.BLUE: 3>]
<
   __len__(cls)

      Returns the number of member in _cls_:
>
         >>> len(Color)
         3
<
   __reversed__(cls)

      Returns each member in _cls_ in reverse definition order:
>
         >>> list(reversed(Color))
         [<Color.BLUE: 3>, <Color.GREEN: 2>, <Color.RED: 1>]
<
   New in version 3.11: Before 3.11 "enum" used "EnumMeta" type, which
   is kept as an alias.

class enum.Enum

   _Enum_ is the base class for all _enum_ enumerations.

   name

      The name used to define the "Enum" member:
>
         >>> Color.BLUE.name
         'BLUE'
<
   value

      The value given to the "Enum" member:
>
         >>> Color.RED.value
         1
<
      Value of the member, can be set in "__new__()".

      Note:

        Enum member valuesMember values can be anything: "int", "str",
        etc.  If the exact value is unimportant you may use "auto"
        instances and an appropriate value will be chosen for you.
        See "auto" for the details.While mutable/unhashable values,
        such as "dict", "list" or a mutable "dataclass", can be used,
        they will have a quadratic performance impact during creation
        relative to the total number of mutable/unhashable values in
        the enum.

   _name_

      Name of the member.

   _value_

      Value of the member, can be set in "__new__()".

   _order_

      No longer used, kept for backward compatibility. (class
      attribute, removed during class creation).

   _ignore_

      "_ignore_" is only used during creation and is removed from the
      enumeration once creation is complete.

      "_ignore_" is a list of names that will not become members, and
      whose names will also be removed from the completed enumeration.
      See TimePeriod for an example.

   __dir__(self)

      Returns "['__class__', '__doc__', '__module__', 'name',
      'value']" and any public methods defined on _self.__class___:
>
         >>> from datetime import date
         >>> class Weekday(Enum):
         ...     MONDAY = 1
         ...     TUESDAY = 2
         ...     WEDNESDAY = 3
         ...     THURSDAY = 4
         ...     FRIDAY = 5
         ...     SATURDAY = 6
         ...     SUNDAY = 7
         ...     @classmethod
         ...     def today(cls):
         ...         print('today is %s' % cls(date.today().isoweekday()).name)
         >>> dir(Weekday.SATURDAY)
         ['__class__', '__doc__', '__eq__', '__hash__', '__module__', 'name', 'today', 'value']
<
   _generate_next_value_(name, start, count, last_values)

         name:
            The name of the member being defined (e.g. ‘RED’).

         start:
            The start value for the Enum; the default is 1.

         count:
            The number of members currently defined, not including
            this one.

         last_values:
            A list of the previous values.

      A _staticmethod_ that is used to determine the next value
      returned by "auto":
>
         >>> from enum import auto
         >>> class PowersOfThree(Enum):
         ...     @staticmethod
         ...     def _generate_next_value_(name, start, count, last_values):
         ...         return 3 ** (count + 1)
         ...     FIRST = auto()
         ...     SECOND = auto()
         >>> PowersOfThree.SECOND.value
         9
<
   __init_subclass__(cls, **kwds)

      A _classmethod_ that is used to further configure subsequent
      subclasses. By default, does nothing.

   _missing_(cls, value)

      A _classmethod_ for looking up values not found in _cls_.  By
      default it does nothing, but can be overridden to implement
      custom search behavior:
>
         >>> from enum import StrEnum
         >>> class Build(StrEnum):
         ...     DEBUG = auto()
         ...     OPTIMIZED = auto()
         ...     @classmethod
         ...     def _missing_(cls, value):
         ...         value = value.lower()
         ...         for member in cls:
         ...             if member.value == value:
         ...                 return member
         ...         return None
         >>> Build.DEBUG.value
         'debug'
         >>> Build('deBUG')
         <Build.DEBUG: 'debug'>
<
   __repr__(self)

      Returns the string used for _repr()_ calls.  By default, returns
      the _Enum_ name, member name, and value, but can be overridden:
>
         >>> class OtherStyle(Enum):
         ...     ALTERNATE = auto()
         ...     OTHER = auto()
         ...     SOMETHING_ELSE = auto()
         ...     def __repr__(self):
         ...         cls_name = self.__class__.__name__
         ...         return f'{cls_name}.{self.name}'
         >>> OtherStyle.ALTERNATE, str(OtherStyle.ALTERNATE), f"{OtherStyle.ALTERNATE}"
         (OtherStyle.ALTERNATE, 'OtherStyle.ALTERNATE', 'OtherStyle.ALTERNATE')
<
   __str__(self)

      Returns the string used for _str()_ calls.  By default, returns
      the _Enum_ name and member name, but can be overridden:
>
         >>> class OtherStyle(Enum):
         ...     ALTERNATE = auto()
         ...     OTHER = auto()
         ...     SOMETHING_ELSE = auto()
         ...     def __str__(self):
         ...         return f'{self.name}'
         >>> OtherStyle.ALTERNATE, str(OtherStyle.ALTERNATE), f"{OtherStyle.ALTERNATE}"
         (<OtherStyle.ALTERNATE: 1>, 'ALTERNATE', 'ALTERNATE')
<
   __format__(self)

      Returns the string used for _format()_ and _f-string_ calls.  By
      default, returns "__str__()" return value, but can be
      overridden:
>
         >>> class OtherStyle(Enum):
         ...     ALTERNATE = auto()
         ...     OTHER = auto()
         ...     SOMETHING_ELSE = auto()
         ...     def __format__(self, spec):
         ...         return f'{self.name}'
         >>> OtherStyle.ALTERNATE, str(OtherStyle.ALTERNATE), f"{OtherStyle.ALTERNATE}"
         (<OtherStyle.ALTERNATE: 1>, 'OtherStyle.ALTERNATE', 'ALTERNATE')
<
   Note:

     Using "auto" with "Enum" results in integers of increasing value,
     starting with "1".

class enum.IntEnum

   _IntEnum_ is the same as _Enum_, but its members are also integers
   and can be used anywhere that an integer can be used.  If any
   integer operation is performed with an _IntEnum_ member, the
   resulting value loses its enumeration status.

   >>> from enum import IntEnum
   >>> class Number(IntEnum):
   ...     ONE = 1
   ...     TWO = 2
   ...     THREE = 3
   ...
   >>> Number.THREE
   <Number.THREE: 3>
   >>> Number.ONE + Number.TWO
   3
   >>> Number.THREE + 5
   8
   >>> Number.THREE == 3
   True

   Note:

     Using "auto" with "IntEnum" results in integers of increasing
     value, starting with "1".

   Changed in version 3.11: "__str__()" is now "int.__str__()" to
   better support the _replacement of existing constants_ use-case.
   "__format__()" was already "int.__format__()" for that same reason.

class enum.StrEnum

   _StrEnum_ is the same as _Enum_, but its members are also strings
   and can be used in most of the same places that a string can be
   used.  The result of any string operation performed on or with a
   _StrEnum_ member is not part of the enumeration.

   Note:

     There are places in the stdlib that check for an exact "str"
     instead of a "str" subclass (i.e. "type(unknown) == str" instead
     of "isinstance(unknown, str)"), and in those locations you will
     need to use "str(StrEnum.member)".

   Note:

     Using "auto" with "StrEnum" results in the lower-cased member
     name as the value.

   Note:

     "__str__()" is "str.__str__()" to better support the _replacement
     of existing constants_ use-case.  "__format__()" is likewise
     "str.__format__()" for that same reason.

   New in version 3.11.

class enum.Flag

   _Flag_ members support the bitwise operators "&" (_AND_), "|"
   (_OR_), "^" (_XOR_), and "~" (_INVERT_); the results of those
   operators are members of the enumeration.

   __contains__(self, value)

      Returns _True_ if value is in self:
>
         >>> from enum import Flag, auto
         >>> class Color(Flag):
         ...     RED = auto()
         ...     GREEN = auto()
         ...     BLUE = auto()
         >>> purple = Color.RED | Color.BLUE
         >>> white = Color.RED | Color.GREEN | Color.BLUE
         >>> Color.GREEN in purple
         False
         >>> Color.GREEN in white
         True
         >>> purple in white
         True
         >>> white in purple
         False
<
   __iter__(self):

      Returns all contained non-alias members:
>
         >>> list(Color.RED)
         [<Color.RED: 1>]
         >>> list(purple)
         [<Color.RED: 1>, <Color.BLUE: 4>]
<
      New in version 3.11.

   __len__(self):

      Returns number of members in flag:
>
         >>> len(Color.GREEN)
         1
         >>> len(white)
         3
<
   __bool__(self):

      Returns _True_ if any members in flag, _False_ otherwise:
>
         >>> bool(Color.GREEN)
         True
         >>> bool(white)
         True
         >>> black = Color(0)
         >>> bool(black)
         False
<
   __or__(self, other)

      Returns current flag binary or’ed with other:
>
         >>> Color.RED | Color.GREEN
         <Color.RED|GREEN: 3>
<
   __and__(self, other)

      Returns current flag binary and’ed with other:
>
         >>> purple & white
         <Color.RED|BLUE: 5>
         >>> purple & Color.GREEN
         <Color: 0>
<
   __xor__(self, other)

      Returns current flag binary xor’ed with other:
>
         >>> purple ^ white
         <Color.GREEN: 2>
         >>> purple ^ Color.GREEN
         <Color.RED|GREEN|BLUE: 7>
<
   __invert__(self):

      Returns all the flags in _type(self)_ that are not in self:
>
         >>> ~white
         <Color: 0>
         >>> ~purple
         <Color.GREEN: 2>
         >>> ~Color.RED
         <Color.GREEN|BLUE: 6>
<
   _numeric_repr_()

      Function used to format any remaining unnamed numeric values.
      Default is the value’s repr; common choices are "hex()" and
      "oct()".

   Note:

     Using "auto" with "Flag" results in integers that are powers of
     two, starting with "1".

   Changed in version 3.11: The _repr()_ of zero-valued flags has
   changed.  It is now::

   >>> Color(0) 
   <Color: 0>

class enum.IntFlag

   _IntFlag_ is the same as _Flag_, but its members are also integers
   and can be used anywhere that an integer can be used.

   >>> from enum import IntFlag, auto
   >>> class Color(IntFlag):
   ...     RED = auto()
   ...     GREEN = auto()
   ...     BLUE = auto()
   >>> Color.RED & 2
   <Color: 0>
   >>> Color.RED | 2
   <Color.RED|GREEN: 3>

   If any integer operation is performed with an _IntFlag_ member, the
   result is not an _IntFlag_:
>
      >>> Color.RED + 2
      3
<
   If a _Flag_ operation is performed with an _IntFlag_ member and:

   * the result is a valid _IntFlag_: an _IntFlag_ is returned

   * the result is not a valid _IntFlag_: the result depends on the
     _FlagBoundary_ setting

   The _repr()_ of unnamed zero-valued flags has changed.  It is now:

   >>> Color(0)
   <Color: 0>

   Note:

     Using "auto" with "IntFlag" results in integers that are powers
     of two, starting with "1".

   Changed in version 3.11: "__str__()" is now "int.__str__()" to
   better support the _replacement of existing constants_ use-case.
   "__format__()" was already "int.__format__()" for that same
   reason.Inversion of an "IntFlag" now returns a positive value that
   is the union of all flags not in the given flag, rather than a
   negative value. This matches the existing "Flag" behavior.

class enum.ReprEnum

   "ReprEnum" uses the "repr()" of "Enum", but the "str()" of the
   mixed-in data type:

   * "int.__str__()" for "IntEnum" and "IntFlag"

   * "str.__str__()" for "StrEnum"

   Inherit from "ReprEnum" to keep the "str()" / "format()" of the
   mixed-in data type instead of using the "Enum"-default "str()".

   New in version 3.11.

class enum.EnumCheck

   _EnumCheck_ contains the options used by the "verify()" decorator
   to ensure various constraints; failed constraints result in a
   "ValueError".

   UNIQUE

      Ensure that each value has only one name:
>
         >>> from enum import Enum, verify, UNIQUE
         >>> @verify(UNIQUE)
         ... class Color(Enum):
         ...     RED = 1
         ...     GREEN = 2
         ...     BLUE = 3
         ...     CRIMSON = 1
         Traceback (most recent call last):
         ...
         ValueError: aliases found in <enum 'Color'>: CRIMSON -> RED
<
   CONTINUOUS

      Ensure that there are no missing values between the lowest-
      valued member and the highest-valued member:
>
         >>> from enum import Enum, verify, CONTINUOUS
         >>> @verify(CONTINUOUS)
         ... class Color(Enum):
         ...     RED = 1
         ...     GREEN = 2
         ...     BLUE = 5
         Traceback (most recent call last):
         ...
         ValueError: invalid enum 'Color': missing values 3, 4
<
   NAMED_FLAGS

      Ensure that any flag groups/masks contain only named flags –
      useful when values are specified instead of being generated by
      "auto()":
>
         >>> from enum import Flag, verify, NAMED_FLAGS
         >>> @verify(NAMED_FLAGS)
         ... class Color(Flag):
         ...     RED = 1
         ...     GREEN = 2
         ...     BLUE = 4
         ...     WHITE = 15
         ...     NEON = 31
         Traceback (most recent call last):
         ...
         ValueError: invalid Flag 'Color': aliases WHITE and NEON are missing combined values of 0x18 [use enum.show_flag_values(value) for details]
<
   Note:

     CONTINUOUS and NAMED_FLAGS are designed to work with integer-
     valued members.

   New in version 3.11.

class enum.FlagBoundary

   _FlagBoundary_ controls how out-of-range values are handled in
   _Flag_ and its subclasses.

   STRICT

      Out-of-range values cause a "ValueError" to be raised. This is
      the default for "Flag":
>
         >>> from enum import Flag, STRICT, auto
         >>> class StrictFlag(Flag, boundary=STRICT):
         ...     RED = auto()
         ...     GREEN = auto()
         ...     BLUE = auto()
         >>> StrictFlag(2**2 + 2**4)
         Traceback (most recent call last):
         ...
         ValueError: <flag 'StrictFlag'> invalid value 20
             given 0b0 10100
           allowed 0b0 00111
<
   CONFORM

      Out-of-range values have invalid values removed, leaving a valid
      _Flag_ value:
>
         >>> from enum import Flag, CONFORM, auto
         >>> class ConformFlag(Flag, boundary=CONFORM):
         ...     RED = auto()
         ...     GREEN = auto()
         ...     BLUE = auto()
         >>> ConformFlag(2**2 + 2**4)
         <ConformFlag.BLUE: 4>
<
   EJECT

      Out-of-range values lose their _Flag_ membership and revert to
      "int".

      >>> from enum import Flag, EJECT, auto
      >>> class EjectFlag(Flag, boundary=EJECT):
      ...     RED = auto()
      ...     GREEN = auto()
      ...     BLUE = auto()
      >>> EjectFlag(2**2 + 2**4)
      20

   KEEP

      Out-of-range values are kept, and the _Flag_ membership is kept.
      This is the default for "IntFlag":
>
         >>> from enum import Flag, KEEP, auto
         >>> class KeepFlag(Flag, boundary=KEEP):
         ...     RED = auto()
         ...     GREEN = auto()
         ...     BLUE = auto()
         >>> KeepFlag(2**2 + 2**4)
         <KeepFlag.BLUE|16: 20>
<
New in version 3.11.

======================================================================


Supported "__dunder__" names
----------------------------

"__members__" is a read-only ordered mapping of "member_name":"member"
items.  It is only available on the class.

"__new__()", if specified, must create and return the enum members; it
is also a very good idea to set the member’s "_value_" appropriately.
Once all the members are created it is no longer used.


Supported "_sunder_" names
--------------------------

* "_name_" – name of the member

* "_value_" – value of the member; can be set in "__new__"

* "_missing_()" – a lookup function used when a value is not found;
  may be overridden

* "_ignore_" – a list of names, either as a "list" or a "str", that
  will not be transformed into members, and will be removed from the
  final class

* "_order_" – no longer used, kept for backward compatibility (class
  attribute, removed during class creation)

* "_generate_next_value_()" – used to get an appropriate value for an
  enum member; may be overridden

  Note:

    For standard "Enum" classes the next value chosen is the last
    value seen incremented by one.For "Flag" classes the next value
    chosen will be the next highest power-of-two, regardless of the
    last value seen.

New in version 3.6: "_missing_", "_order_", "_generate_next_value_"

New in version 3.7: "_ignore_"

======================================================================


Utilities and Decorators
========================

class enum.auto

   _auto_ can be used in place of a value.  If used, the _Enum_
   machinery will call an _Enum_’s "_generate_next_value_()" to get an
   appropriate value. For _Enum_ and _IntEnum_ that appropriate value
   will be the last value plus one; for _Flag_ and _IntFlag_ it will
   be the first power-of-two greater than the highest value; for
   _StrEnum_ it will be the lower-cased version of the member’s name.
   Care must be taken if mixing _auto()_ with manually specified
   values.

   _auto_ instances are only resolved when at the top level of an
   assignment:

   * "FIRST = auto()" will work (auto() is replaced with "1");

   * "SECOND = auto(), -2" will work (auto is replaced with "2", so
     "2, -2" is used to create the "SECOND" enum member;

   * "THREE = [auto(), -3]" will _not_ work ("<auto instance>, -3" is
     used to create the "THREE" enum member)

   Changed in version 3.11.1: In prior versions, "auto()" had to be
   the only thing on the assignment line to work properly.

   "_generate_next_value_" can be overridden to customize the values
   used by _auto_.

   Note:

     in 3.13 the default "_generate_next_value_" will always return
     the highest member value incremented by 1, and will fail if any
     member is an incompatible type.

@enum.property

   A decorator similar to the built-in _property_, but specifically
   for enumerations.  It allows member attributes to have the same
   names as members themselves.

   Note:

     the _property_ and the member must be defined in separate
     classes; for example, the _value_ and _name_ attributes are
     defined in the _Enum_ class, and _Enum_ subclasses can define
     members with the names "value" and "name".

   New in version 3.11.

@enum.unique

   A "class" decorator specifically for enumerations.  It searches an
   enumeration’s "__members__", gathering any aliases it finds; if any
   are found "ValueError" is raised with the details:
>
      >>> from enum import Enum, unique
      >>> @unique
      ... class Mistake(Enum):
      ...     ONE = 1
      ...     TWO = 2
      ...     THREE = 3
      ...     FOUR = 3
      ...
      Traceback (most recent call last):
      ...
      ValueError: duplicate values found in <enum 'Mistake'>: FOUR -> THREE
<
@enum.verify

   A "class" decorator specifically for enumerations.  Members from
   "EnumCheck" are used to specify which constraints should be checked
   on the decorated enumeration.

   New in version 3.11.

@enum.member

   A decorator for use in enums: its target will become a member.

   New in version 3.11.

@enum.nonmember

   A decorator for use in enums: its target will not become a member.

   New in version 3.11.

@enum.global_enum

   A decorator to change the "str()" and "repr()" of an enum to show
   its members as belonging to the module instead of its class. Should
   only be used when the enum members are exported to the module
   global namespace (see "re.RegexFlag" for an example).

   New in version 3.11.

enum.show_flag_values(value)

   Return a list of all power-of-two integers contained in a flag
   _value_.

   New in version 3.11.

======================================================================


Notes
=====

"IntEnum", "StrEnum", and "IntFlag"

   These three enum types are designed to be drop-in replacements for
   existing integer- and string-based values; as such, they have extra
   limitations:

   * "__str__" uses the value and not the name of the enum member

   * "__format__", because it uses "__str__", will also use the value
     of the enum member instead of its name

   If you do not need/want those limitations, you can either create
   your own base class by mixing in the "int" or "str" type yourself:
>
      >>> from enum import Enum
      >>> class MyIntEnum(int, Enum):
      ...     pass
<
   or you can reassign the appropriate "str()", etc., in your enum:
>
      >>> from enum import Enum, IntEnum
      >>> class MyIntEnum(IntEnum):
      ...     __str__ = Enum.__str__
<
vim:tw=78:ts=8:ft=help:norl: